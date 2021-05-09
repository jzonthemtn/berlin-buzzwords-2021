package com.mtnfog.test.scorecalculator;

import com.mtnfog.test.scorecalculator.model.Judgment;
import com.mtnfog.test.scorecalculator.repositories.JudgmentsRepository;
import com.mtnfog.test.scorecalculator.scoring.DCG;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

import java.util.LinkedList;
import java.util.List;

@SpringBootApplication
public class ScoreCalculator {

	public static void main(String[] args) {
		SpringApplication.run(ScoreCalculator.class);
	}

	@Bean
	public CommandLineRunner demo(JudgmentsRepository repository) {

		final DCG dcg = new DCG();

		return (args) -> {

			final List<Judgment> judgments = new LinkedList<>();

			final List<Long> ids = new LinkedList<>();

			for(final long id : ids) {

				final Judgment judgment = repository.findById(id);

				judgments.add(judgment);

			}

			final double score = dcg.calculate(judgments, 10);

		};

	}

}
