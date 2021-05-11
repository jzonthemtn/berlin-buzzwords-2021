package com.mtnfog.test.scorecalculator;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.mtnfog.test.scorecalculator.model.Judgment;
import com.mtnfog.test.scorecalculator.repositories.JudgmentsRepository;
import com.mtnfog.test.scorecalculator.scoring.DCG;
import com.mtnfog.test.scorecalculator.scoring.NDCG;
import org.apache.http.HttpHost;
import org.elasticsearch.action.search.SearchRequest;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.client.RestClient;
import org.elasticsearch.client.RestHighLevelClient;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.search.SearchHit;
import org.elasticsearch.search.builder.SearchSourceBuilder;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

import java.util.LinkedList;
import java.util.List;
import java.util.Map;

@SpringBootApplication
public class ScoreCalculator {

	public static void main(String[] args) {
		SpringApplication.run(ScoreCalculator.class);
		System.exit(0);
	}

	@Bean
	public CommandLineRunner calculate(ApplicationArguments args, JudgmentsRepository repository) {

		final String term = "christmas"; //args.getNonOptionArgs().get(0);
		//System.out.println("Using search term: " + searchTerm);

		return (result) -> {

			final RestHighLevelClient client = new RestHighLevelClient(
					RestClient.builder(
							new HttpHost("elasticsearch", 9200, "http")));

			final SearchSourceBuilder searchSourceBuilder = new SearchSourceBuilder();
			searchSourceBuilder.query(QueryBuilders.matchQuery("genres", "Family"));
			searchSourceBuilder.sort("classification_" + term);
			searchSourceBuilder.size(10);

			SearchRequest searchRequest = new SearchRequest();
			searchRequest.indices("tmdb");
			searchRequest.source(searchSourceBuilder);

			final SearchResponse response = client.search(searchRequest, RequestOptions.DEFAULT);
			final SearchHit[] searchHits = response.getHits().getHits();

			System.out.println("Search results: " + response.getHits().getTotalHits().value);

			final Gson gson = new GsonBuilder().create();

			final List<Integer> ids = new LinkedList<>();

			for(final SearchHit hit : searchHits) {

				String jsonString=hit.getSourceAsString();

				final Map jsonMap = gson.fromJson(jsonString, Map.class);
				final int id = Integer.valueOf((String) jsonMap.get("id"));

				ids.add(id);

			}

			final List<Judgment> judgments = new LinkedList<>();

			for(final int id : ids) {

				Judgment judgment = repository.findById(id);

				if(judgment == null) {
					// This is not a document we have in our judgments list.
					judgment = new Judgment(id, 0);
				}

				judgments.add(judgment);

				System.out.println("Search result document ID: " + id + ", Relevance: " + judgment.getRelevance());

			}

			final DCG dcg = new DCG();
			final double dcgScore = dcg.calculate(judgments, 10);

			final NDCG ndcg = new NDCG();
			final double ndcgScore = ndcg.calculate(judgments, 10);

			System.out.println("DCG: " + dcgScore);
			System.out.println("NDCG: " + ndcgScore);

			// TODO: Output the results as a JSON object.

		};

	}

}
