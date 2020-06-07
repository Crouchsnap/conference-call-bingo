package com.bingo.multiplayer

import org.springframework.core.convert.converter.Converter
import org.springframework.data.annotation.CreatedDate
import org.springframework.data.annotation.Id
import org.springframework.data.mongodb.repository.MongoRepository
import org.springframework.stereotype.Repository
import java.time.Instant
import java.util.*
import javax.validation.constraints.Size

data class AddMultiplayerRequest(@field:Size(min = 2, max = 4) val initials: String = "", val score: Int = 1)

fun AddMultiplayerRequest.toMultiplayerGame() = MultiplayerGame(players = listOf(Player(initials = initials, score = score)))
fun AddMultiplayerRequest.toPlayer() = Player(initials = initials, score = score)
fun Player.toScoreResponse() = ScoreResponse(playerId = id, initials = initials, score = score)
fun MultiplayerGame.toCreateGameResponse() = CreateGameResponse(id!!, players[0].id)


data class Player(@Id val id: String = UUID.randomUUID().toString(), val initials: String, val score: Int = 1)
data class MultiplayerGame(@Id val id: String? = null, private val createdDate: Instant = Instant.now(), val players: List<Player> = emptyList())
data class ScoreResponse(val playerId: String = "", val initials: String = "", val score: Int = 0)
data class CreateGameResponse(val id: String, val playerId: String = "")

@Repository
interface MultiplayerRepository : MongoRepository<MultiplayerGame, String>


enum class Operation(val amount: Int) {
    INCREMENT(1), DECREMENT(-1), RESET(1)
}

class StringToOperationConverter : Converter<String?, Operation?> {
    override fun convert(source: String): Operation =
            Operation.valueOf(source.toUpperCase())

}
