package com.mtnfog.rest;

import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.DELETE;
import retrofit2.http.Headers;
import retrofit2.http.POST;

public interface LtrService {

    @Headers({
            "Content-Type: application/json; charset=utf-8"
    })
    @POST("_ltr/_featureset/more_movie_features/_createmodel")
    Call<String> uploadLtrModel(@Body String model);

    @DELETE("_ltr/_model/my_linear_model")
    Call<String> deleteLtrModel();

}
