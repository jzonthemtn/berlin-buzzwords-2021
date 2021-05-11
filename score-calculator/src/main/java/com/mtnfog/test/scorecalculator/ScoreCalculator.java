package com.mtnfog.test.scorecalculator;

import com.mtnfog.test.scorecalculator.model.Judgment;
import com.mtnfog.test.scorecalculator.repositories.JudgmentsRepository;
import com.mtnfog.test.scorecalculator.scoring.DCG;
import org.apache.http.HttpHost;
import org.elasticsearch.action.search.SearchRequest;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.client.RestClient;
import org.elasticsearch.client.RestHighLevelClient;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.search.SearchHit;
import org.elasticsearch.search.builder.SearchSourceBuilder;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;
import java.util.stream.Collectors;

@SpringBootApplication
public class ScoreCalculator {

	public static void main(String[] args) {
		SpringApplication.run(ScoreCalculator.class);
	}

	@Bean
	public CommandLineRunner demo(JudgmentsRepository repository) {

		final DCG dcg = new DCG();

		return (args) -> {

			final RestHighLevelClient client = new RestHighLevelClient(
					RestClient.builder(
							new HttpHost("elasticsearch", 9200, "http")));

			final List<Integer> ids = new LinkedList<>();

			final SearchSourceBuilder searchSourceBuilder = new SearchSourceBuilder();
			searchSourceBuilder.query(QueryBuilders.matchQuery("overview", "christmas"));
			searchSourceBuilder.size(10);

			SearchRequest searchRequest = new SearchRequest();
			searchRequest.indices("tmdb");
			searchRequest.source(searchSourceBuilder);

			final SearchResponse response = client.search(searchRequest, RequestOptions.DEFAULT);
			final SearchHit[] searchHits = response.getHits().getHits();

			System.out.println("Search results: " + response.getHits().getTotalHits().value);

			for(final SearchHit hit : searchHits) {

				System.out.println("Search result document ID: " + hit.docId());
				ids.add(hit.docId());

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

			final double score = dcg.calculate(judgments, 10);

			System.out.println("Score: " + score);

		};

	}

}
