package com.bingo

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication
class ConferenceCallBingoApplication

fun main(args: Array<String>) {
	runApplication<ConferenceCallBingoApplication>(*args)
}
