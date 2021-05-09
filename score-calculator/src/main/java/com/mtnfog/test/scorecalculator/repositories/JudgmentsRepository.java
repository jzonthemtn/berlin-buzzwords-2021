package com.mtnfog.test.scorecalculator.repositories;

import com.mtnfog.test.scorecalculator.model.Judgment;
import org.springframework.data.repository.CrudRepository;

public interface JudgmentsRepository extends CrudRepository<Judgment, Long> {

	Judgment findById(long id);

}
