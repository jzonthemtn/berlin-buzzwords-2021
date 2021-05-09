package com.mtnfog.test.scorecalculator;

import com.mtnfog.test.scorecalculator.model.Judgment;
import com.mtnfog.test.scorecalculator.repositories.JudgmentsRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class ScoreCalculator {

	private static final Logger log = LoggerFactory.getLogger(ScoreCalculator.class);

	public static void main(String[] args) {
		SpringApplication.run(ScoreCalculator.class);
	}

	@Bean
	public CommandLineRunner demo(JudgmentsRepository repository) {

		return (args) -> {

			// fetch all customers
			log.info("Customers found with findAll():");
			log.info("-------------------------------");
			for (Judgment judgment : repository.findAll()) {
				log.info(judgment.toString());
			}
			log.info("");

		};

	}

}
