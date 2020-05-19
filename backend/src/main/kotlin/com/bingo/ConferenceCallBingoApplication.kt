package com.bingo

import org.springframework.boot.autoconfigure.EnableAutoConfiguration
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.autoconfigure.mongo.embedded.EmbeddedMongoAutoConfiguration
import org.springframework.boot.runApplication
import org.springframework.context.annotation.Profile
import org.springframework.stereotype.Component


@SpringBootApplication
class ConferenceCallBingoApplication

fun main(args: Array<String>) {
    runApplication<ConferenceCallBingoApplication>(*args)
}

@Component
@EnableAutoConfiguration(exclude = [EmbeddedMongoAutoConfiguration::class])
@Profile("cloud")
class CloudMongo
