package com.mtnfog;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.twitter.hbc.core.endpoint.StatusesFilterEndpoint;
import com.twitter.hbc.core.endpoint.StreamingEndpoint;
import org.apache.flink.api.common.functions.FlatMapFunction;
import org.apache.flink.api.common.restartstrategy.RestartStrategies;
import org.apache.flink.api.java.tuple.Tuple2;
import org.apache.flink.streaming.api.TimeCharacteristic;
import org.apache.flink.streaming.api.datastream.DataStream;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
import org.apache.flink.streaming.api.functions.windowing.AllWindowFunction;
import org.apache.flink.streaming.api.windowing.time.Time;
import org.apache.flink.streaming.api.windowing.windows.TimeWindow;
import org.apache.flink.streaming.connectors.twitter.TwitterSource;
import org.apache.flink.util.Collector;

import java.io.Serializable;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class FlinkTwitter {

    public static final String APPLICATION_NAME = "BerlinBuzzwords2021";
    public static final Integer HASHTAG_LIMIT = 20;
    public static final List<String> TAGS = new ArrayList<>(Arrays.asList("CoronavirusOutbreak", "WorstWayToEndAnArgument"));

    public static void main(String[] args) throws Exception {

        final StreamExecutionEnvironment env = StreamExecutionEnvironment.createLocalEnvironment();

        // enable event time processing
        env.setStreamTimeCharacteristic(TimeCharacteristic.ProcessingTime);
        env.getConfig().setAutoWatermarkInterval(1000L);
        env.setParallelism(1);

        // enable fault-tolerance, 60s checkpointing
        env.enableCheckpointing(60000);

        // enable restarts
        env.setRestartStrategy(RestartStrategies.fixedDelayRestart(0, 500L));

        // Get parameters from command line
        //final ParameterTool params = ParameterTool.fromArgs(args);

        final Properties props = new Properties();
        props.setProperty(TwitterSource.CONSUMER_KEY, System.getenv("CONSUMER_KEY"));
        props.setProperty(TwitterSource.CONSUMER_SECRET, System.getenv("CONSUMER_SECRET"));
        props.setProperty(TwitterSource.TOKEN, System.getenv("TOKEN"));
        props.setProperty(TwitterSource.TOKEN_SECRET, System.getenv("TOKEN_SECRET"));

        final TweetFilter customFilterInitializer = new TweetFilter();
        final TwitterSource twitterSource = new TwitterSource(props);
        twitterSource.setCustomEndpointInitializer(customFilterInitializer);

        final DataStream<String> streamSource = env.addSource(twitterSource);

        // Parse JSON tweets, flatmap and emit keyed stream
        final DataStream<Tuple2<String, Integer>> jsonTweets = streamSource.flatMap(new TweetFlatMapper()).keyBy(0);

        // Ordered topN list of most popular hashtags
        final int windowSize = 300;
        final int slide = 10;

        final DataStream<LinkedHashMap<String, Integer>> ds = jsonTweets
                .timeWindowAll(Time.seconds(windowSize), Time.seconds(slide))
                .apply(new MostPopularTags());

        // Print to stdout
        ds.print();

        env.execute(APPLICATION_NAME);

    }

    public static class TweetFilter implements TwitterSource.EndpointInitializer, Serializable {

        @Override
        public StreamingEndpoint createEndpoint() {

            final StatusesFilterEndpoint endpoint = new StatusesFilterEndpoint();
            endpoint.trackTerms(TAGS);

            return endpoint;

        }

    }

    private static class TweetFlatMapper implements FlatMapFunction<String, Tuple2<String, Integer>> {

        @Override
        public void flatMap(String tweet, Collector<Tuple2<String, Integer>> out) throws Exception {

            final ObjectMapper mapper = new ObjectMapper();
            String tweetString = null;

            final Pattern p = Pattern.compile("#\\w+");

            try {

                final JsonNode jsonNode = mapper.readValue(tweet, JsonNode.class);
                tweetString = jsonNode.get("text").textValue();

            } catch (Exception e) {
                // That's ok
            }

            if (tweetString != null) {

                final List<String> tags = new ArrayList<>();
                final Matcher matcher = p.matcher(tweetString);

                while (matcher.find()) {

                    final String cleanedHashtag = matcher.group(0).trim();

                    if (cleanedHashtag != null) {
                        out.collect(new Tuple2<>(cleanedHashtag, 1));
                    }

                }

            }

        }

    }

    // Window functions
    public static class MostPopularTags implements AllWindowFunction<Tuple2<String, Integer>, LinkedHashMap<String, Integer>, TimeWindow> {

        @Override
        public void apply(TimeWindow window, Iterable<Tuple2<String, Integer>> tweets, Collector<LinkedHashMap<String, Integer>> collector) throws Exception {

            final HashMap<String, Integer> hmap = new HashMap<>();

            for (Tuple2<String, Integer> t : tweets) {

                int count = 0;

                if (hmap.containsKey(t.f0)) {
                    count = hmap.get(t.f0);
                }

                hmap.put(t.f0, count + t.f1);

            }

            final Comparator<String> comparator = new ValueComparator(hmap);
            final TreeMap<String, Integer> sortedMap = new TreeMap<>(comparator);

            sortedMap.putAll(hmap);

            final LinkedHashMap<String, Integer> sortedTopN = sortedMap
                    .entrySet()
                    .stream()
                    .limit(HASHTAG_LIMIT)
                    .collect(LinkedHashMap::new, (m, e) -> m.put(e.getKey(), e.getValue()), Map::putAll);

            collector.collect(sortedTopN);

            // TODO: Persist the hashtags somewhere.
        }

    }

    public static class ValueComparator implements Comparator<String> {

        final HashMap<String, Integer> map = new HashMap<>();

        public ValueComparator(HashMap<String, Integer> map) {
            this.map.putAll(map);
        }

        @Override
        public int compare(String s1, String s2) {

            if (map.get(s1) >= map.get(s2)) {
                return -1;
            } else {
                return 1;
            }

        }

    }

}