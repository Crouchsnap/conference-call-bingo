package com.bingo.multiplayer

import org.springframework.data.annotation.Id
import org.springframework.data.mongodb.core.mapping.Document
import org.springframework.data.mongodb.repository.MongoRepository
import org.springframework.data.mongodb.repository.ReactiveMongoRepository
import org.springframework.data.mongodb.repository.Tailable
import org.springframework.stereotype.Repository
import reactor.core.publisher.Flux
import java.util.*
import javax.validation.constraints.Max
import javax.validation.constraints.Min
import javax.validation.constraints.Size

const val scoreRangeMessage = "must be between 1 and 5"
data class AddMultiplayerRequest(@field:Size(min = 2, max = 4) val initials: String = "")

fun AddMultiplayerRequest.toMultiplayerGame() = MultiplayerGame(players = listOf(Player(initials = initials)))
fun AddMultiplayerRequest.toPlayer() = Player(initials = initials)
fun Score.toScoreResponse() = ScoreResponse(playerId = playerId, initials = initials, score = score)

data class Player(@Id val id: String = UUID.randomUUID().toString(), val initials: String)
data class MultiplayerGame(@Id val id: String? = null, val players: List<Player> = emptyList())

@Document(collection = "score")
data class Score(@Id val id: String? = null, val gameId: String, val playerId: String, val initials: String, val score: Int)
data class ScoreRequest(@field:Min(value = 1, message = scoreRangeMessage)
                        @field:Max(value = 5, message = scoreRangeMessage)
                        val score: Int = 0)

data class ScoreResponse(val playerId: String = "", val initials: String = "", val score: Int = 0)

@Repository
interface MultiplayerRepository : MongoRepository<MultiplayerGame, String>

@Repository
interface MultiplayerScoreRepository : ReactiveMongoRepository<Score, String> {
    @Tailable
    fun findWithTailableCursorByGameId(gameId: String): Flux<Score>
}

