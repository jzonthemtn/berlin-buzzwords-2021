package com.mtnfog.rest;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import okhttp3.OkHttpClient;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

import java.io.IOException;

public class LtrClient {

    private LtrService ltrService;

    public LtrClient(final String baseUrl) {

        final OkHttpClient.Builder httpClient = new OkHttpClient.Builder();
        final OkHttpClient client = httpClient.build();

        final Gson gson = new GsonBuilder()
                .setLenient()
                .create();

        final Retrofit retrofit = new Retrofit.Builder()
                .baseUrl(baseUrl)
                .addConverterFactory(GsonConverterFactory.create(gson))
                .client(client)
                .build();

        this.ltrService = retrofit.create(LtrService.class);

    }

    public String uploadModel(String model) throws IOException {

        System.out.println("Uploading model...");

        // Surround the model with required text.
        String body = "{" +
                "    \"model\": {" +
                "        \"name\": \"my_linear_model\"," +
                "        \"model\": {" +
                "            \"type\": \"model/xg-boost+json\"," +
                "            \"definition\":" + model +
                "        }" +
                "    }" +
                "}";

        //final Gson gson = new GsonBuilder().setPrettyPrinting().create();
        System.out.println(body);

        body = body.replaceAll("\\s+", "");

        return ltrService.uploadLtrModel(body).execute().body();

    }

}
