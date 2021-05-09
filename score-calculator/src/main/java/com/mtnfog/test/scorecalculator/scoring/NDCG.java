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

import java.util.Comparator;
import java.util.List;

public class NDCG extends DCG {

    /**
     * Calculate Normalized Discounted Cumulative Gain. This is calculated by normalizing {@link DCG#dcg(List, int)}
     * {@literal @}k with its maximum possible value.
     * @param docsRanks
     * @param position the k-position of NDCG@k
     * @return the score of NDCG
     */
    public double calculate(List<Judgment> docsRanks, int position) {

        //Accept docs in predicted ranking order
        double dcg = dcg(docsRanks, position);

        //Sort for ideal
        docsRanks.sort(Comparator.comparingInt(Judgment::getRelevance).reversed()); //to arrange in order of highest to lowest

        double idealDcg = dcg(docsRanks, position);
        return idealDcg == 0 ? 0.0 : dcg / idealDcg;

    }

}