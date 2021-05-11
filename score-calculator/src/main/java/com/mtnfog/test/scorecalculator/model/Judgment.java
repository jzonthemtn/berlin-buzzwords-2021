package com.mtnfog.test.scorecalculator.model;

import javax.persistence.*;

@Entity
@Table(name = "judgments")
public class Judgment {

	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private long documentId;
	private int relevance;

	protected Judgment(	) {

	}

	public Judgment(long documentId, int relevance) {
		this.documentId = documentId;
		this.relevance = relevance;
	}

	public long getDocumentId() {
		return documentId;
	}

	public void setDocumentId(long documentId) {
		this.documentId = documentId;
	}

	public int getRelevance() {
		return relevance;
	}

	public void setRelevance(int relevance) {
		this.relevance = relevance;
	}

}
