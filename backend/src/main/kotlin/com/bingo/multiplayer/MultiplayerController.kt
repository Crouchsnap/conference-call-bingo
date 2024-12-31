package com.bingo.multiplayer

import org.springframework.context.annotation.Configuration
import org.springframework.format.FormatterRegistry
import org.springframework.http.HttpStatus
import org.springframework.http.MediaType
import org.springframework.web.bind.annotation.*
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer
import reactor.core.publisher.Flux
import java.time.Duration
import jakarta.validation.Valid


@RestController
@RequestMapping(path = ["/api/multiplayer"])
@CrossOrigin(origins = ["http://localhost:8000"])
class MultiplayerController(private val multiplayerService: MultiplayerService,
                            private val multiplayerRepository: MultiplayerRepository) {

    @PostMapping(path = ["start"])
    @ResponseStatus(HttpStatus.CREATED)
    fun startMultiplayer(@Valid @RequestBody addMultiplayerRequest: AddMultiplayerRequest): CreateGameResponse =
            multiplayerService.createMultiplayerGame(addMultiplayerRequest.toMultiplayerGame()).toCreateGameResponse()


    @PostMapping("join/{gameId}")
    fun joinMultiplayer(@PathVariable gameId: String, @Valid @RequestBody addMultiplayerRequest: AddMultiplayerRequest): CreateGameResponse {
        val player = addMultiplayerRequest.toPlayer()
        multiplayerService.addPlayer(gameId, player) ?: throw GameOverException("Cannot join already won game")
        return CreateGameResponse(gameId, player.id)
    }

    @PostMapping("leave/{gameId}/{playerId}")
    fun leaveMultiplayer(@PathVariable gameId: String, @PathVariable playerId: String) {
        multiplayerService.removePlayer(gameId, playerId).apply {
            if (modifiedCount.toInt() == 0) throw GameOverException("Cannot leave already won game")
        }
    }

    @PostMapping("{operation}/{gameId}/{playerId}")
    fun updateScore(@PathVariable operation: Operation, @PathVariable gameId: String, @PathVariable playerId: String) {
        multiplayerService.updateScore(operation, gameId, playerId).apply {
            if (modifiedCount.toInt() == 0) throw GameOverException("Game is over")
        }
    }

    @GetMapping(path = ["/scores/{gameId}"], produces = [MediaType.TEXT_EVENT_STREAM_VALUE])
    fun scores(@PathVariable gameId: String): Flux<List<ScoreResponse>>? =
            Flux.interval(Duration.ofSeconds(2))
                    .map {
                        multiplayerRepository.findById(gameId).get().players
                                .map { it.toScoreResponse() }
                    }
}


@Configuration
class OperationFormatter : WebMvcConfigurer {
    override fun addFormatters(registry: FormatterRegistry) {
        registry.addConverter(StringToOperationConverter())
    }
}

@ResponseStatus(HttpStatus.CONFLICT)
class GameOverException(s: String) : RuntimeException(s)

