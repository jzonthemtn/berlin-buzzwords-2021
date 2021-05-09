package com.mtnfog.test.scorecalculator.scoring;

/*
 * Copyright 2018 org.LTR4L
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import com.mtnfog.test.scorecalculator.model.Judgment;

import java.util.List;

public class DCG {

    /**
     * Calculate Discounted Cumulative Gain. DCG is an evaluation measure that can leverage the relevance judgement
     * in terms of multiple ordered categories, and has an explicit position discount factor in its definition.
     * @param judgments
     * @param position the k-position of DCG@k
     * @return the score of DCG
     */
    static double dcg(List<Judgment> judgments, int position) {

        double sum = 0;

        if (position > -1) {

            final int pos = Math.min(position, judgments.size());

            for (int i = 0; i < pos; i++) {
                sum += (Math.pow(2, judgments.get(i).getRelevance()) - 1) / Math.log(i + 2);
            }

        }

        return sum * Math.log(2);  //Change of base

    }

    public double calculate(List<Judgment> docRanks, int position){
        return dcg(docRanks, position);
    }

}