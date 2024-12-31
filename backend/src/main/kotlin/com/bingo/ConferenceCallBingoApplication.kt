package com.bingo

import de.flapdoodle.embed.mongo.spring.autoconfigure.EmbeddedMongoAutoConfiguration
import org.springframework.boot.autoconfigure.EnableAutoConfiguration
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication
import org.springframework.context.annotation.Configuration
import org.springframework.context.annotation.Profile
import org.springframework.http.HttpStatus
import org.springframework.web.bind.MethodArgumentNotValidException
import org.springframework.web.bind.annotation.ExceptionHandler
import org.springframework.web.bind.annotation.ResponseStatus
import org.springframework.web.bind.annotation.RestControllerAdvice
import org.springframework.web.bind.support.WebExchangeBindException


@SpringBootApplication
class ConferenceCallBingoApplication

fun main(args: Array<String>) {
    runApplication<ConferenceCallBingoApplication>(*args)
}

@Configuration
@EnableAutoConfiguration(exclude = [EmbeddedMongoAutoConfiguration::class])
@Profile("cloud")
class CloudMongo


@RestControllerAdvice
class GlobalExceptionHandler {
    @ExceptionHandler(MethodArgumentNotValidException::class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    fun handleValidationExceptions(ex: MethodArgumentNotValidException): Map<String, String?> =
        ex.bindingResult.fieldErrors.associate { it.field to it.defaultMessage }

}