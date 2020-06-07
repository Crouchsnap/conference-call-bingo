package com.bingo.multiplayer

import com.mongodb.client.result.UpdateResult
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.context.annotation.Configuration
import org.springframework.format.FormatterRegistry
import org.springframework.http.HttpStatus
import org.springframework.http.MediaType
import org.springframework.web.bind.annotation.*
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer
import reactor.core.publisher.Flux
import java.lang.RuntimeException
import java.time.Duration
import javax.validation.Valid


@RestController
@RequestMapping(path = ["/api/multiplayer"])
@CrossOrigin(origins = ["http://localhost:8000"])
class MultiplayerController {

    @Autowired
    private lateinit var multiplayerService: MultiplayerService

    @Autowired
    private lateinit var multiplayerRepository: MultiplayerRepository

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

    @PostMapping("{operation}/{gameId}/{playerId}")
    fun updateScore(@PathVariable operation: Operation, @PathVariable gameId: String, @PathVariable playerId: String): UpdateResult {
        val updateScore = multiplayerService.updateScore(operation, gameId, playerId)
        if(updateScore.modifiedCount.toInt() == 0) throw GameOverException("Game is over")
        return updateScore
    }

    @GetMapping(path = ["/scores/{gameId}"], produces = [MediaType.TEXT_EVENT_STREAM_VALUE])
    fun scores(@PathVariable gameId: String): Flux<List<ScoreResponse>>? {
        return Flux.interval(Duration.ofSeconds(2))
                .map { multiplayerRepository.findById(gameId).get().players
                        .map { it.toScoreResponse() } }

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

