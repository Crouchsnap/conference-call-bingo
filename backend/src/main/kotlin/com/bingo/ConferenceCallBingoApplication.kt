package com.bingo

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication
import org.springframework.data.mongodb.repository.config.EnableMongoRepositories

@SpringBootApplication
@EnableMongoRepositories
class ConferenceCallBingoApplication

fun main(args: Array<String>) {
	runApplication<ConferenceCallBingoApplication>(*args)
}
