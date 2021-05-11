package com.mtnfog.test.scorecalculator.model;

public class Score{

    private double dcg;
    private double ndcg;

    public Score(double dcg, double ndcg) {
        this.dcg = dcg;
        this.ndcg = ndcg;
    }

    public double getDcg() {
        return dcg;
    }

    public void setDcg(double dcg) {
        this.dcg = dcg;
    }

    public double getNdcg() {
        return ndcg;
    }

    public void setNdcg(double ndcg) {
        this.ndcg = ndcg;
    }

}
