package com.bingo

import org.springframework.boot.autoconfigure.EnableAutoConfiguration
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.autoconfigure.mongo.embedded.EmbeddedMongoAutoConfiguration
import org.springframework.boot.runApplication
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.context.annotation.Profile
import org.springframework.data.mongodb.core.CollectionOptions
import org.springframework.data.mongodb.core.MongoOperations


@SpringBootApplication
class ConferenceCallBingoApplication

fun main(args: Array<String>) {
    runApplication<ConferenceCallBingoApplication>(*args)
}

@Configuration
@EnableAutoConfiguration(exclude = [EmbeddedMongoAutoConfiguration::class])
@Profile("cloud")
class CloudMongo


@Configuration
class MongoConfig {
    @Bean
    fun config(mongoOperations: MongoOperations): CollectionOptions {
        val options : CollectionOptions = CollectionOptions.empty()
                .capped().size(5242880)
                .maxDocuments(5000)
        mongoOperations.createCollection("score", options)

        return options
    }
}
