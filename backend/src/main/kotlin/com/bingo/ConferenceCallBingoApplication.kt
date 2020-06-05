package com.bingo

import org.springframework.boot.autoconfigure.EnableAutoConfiguration
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.autoconfigure.mongo.embedded.EmbeddedMongoAutoConfiguration
import org.springframework.boot.runApplication
import org.springframework.context.annotation.Configuration
import org.springframework.context.annotation.Profile


@SpringBootApplication
class ConferenceCallBingoApplication

fun main(args: Array<String>) {
    runApplication<ConferenceCallBingoApplication>(*args)
}

@Configuration
@EnableAutoConfiguration(exclude = [EmbeddedMongoAutoConfiguration::class])
@Profile("cloud")
class CloudMongo
