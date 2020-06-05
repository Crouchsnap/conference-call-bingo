package com.bingo.multiplayer

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.HttpStatus
import org.springframework.http.MediaType
import org.springframework.web.bind.annotation.*
import reactor.core.publisher.Flux
import java.time.Duration
import javax.validation.Valid


@RestController
@RequestMapping(path = ["/api/multiplayer"])
@CrossOrigin(origins = ["http://localhost:8000"])
class MultiplayerController {

    @Autowired
    private lateinit var multiplayerService: MultiplayerService

    @Autowired
    private lateinit var multiplayerScoreRepository: MultiplayerScoreRepository

    @PostMapping(path = ["start"])
    @ResponseStatus(HttpStatus.CREATED)
    fun startMultiplayer(@Valid @RequestBody addMultiplayerRequest: AddMultiplayerRequest): String =
            multiplayerService.createMultiplayerGame(addMultiplayerRequest.toMultiplayerGame())


    @PostMapping("join/{gameId}")
    fun joinMultiplayer(@PathVariable gameId: String, @Valid @RequestBody addMultiplayerRequest: AddMultiplayerRequest): String {
        val player = addMultiplayerRequest.toPlayer()
        multiplayerService.addPlayer(gameId, player)
        return player.id
    }

    @PostMapping("score/{gameId}/{playerId}")
    fun updateScore(@PathVariable gameId: String, @PathVariable playerId: String, @RequestBody scoreRequest: ScoreRequest) =
            multiplayerService.updateScore(gameId, playerId, scoreRequest.score)

    @GetMapping(path = ["/scores/{gameId}"], produces = [MediaType.TEXT_EVENT_STREAM_VALUE])
    fun scores(@PathVariable gameId: String): Flux<List<ScoreResponse>>? {
        return Flux.interval(Duration.ofSeconds(2))
                .map { multiplayerScoreRepository.findAllByGameId(gameId)
                        .map { it.toScoreResponse() } }

    }
}


