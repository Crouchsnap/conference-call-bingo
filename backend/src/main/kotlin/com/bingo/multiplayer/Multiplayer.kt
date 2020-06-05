package com.bingo.multiplayer

import org.springframework.core.convert.converter.Converter
import org.springframework.data.annotation.Id
import org.springframework.data.mongodb.repository.MongoRepository
import org.springframework.stereotype.Repository
import java.util.*
import javax.validation.constraints.Size

data class AddMultiplayerRequest(@field:Size(min = 2, max = 4) val initials: String = "")

fun AddMultiplayerRequest.toMultiplayerGame() = MultiplayerGame(players = listOf(Player(initials = initials)))
fun AddMultiplayerRequest.toPlayer() = Player(initials = initials)
fun Player.toScoreResponse() = ScoreResponse(playerId = id, initials = initials, score = score)


data class Player(@Id val id: String = UUID.randomUUID().toString(), val initials: String, val score: Int = 1)
data class MultiplayerGame(@Id val id: String? = null, val players: List<Player> = emptyList())
data class ScoreResponse(val playerId: String = "", val initials: String = "", val score: Int = 0)

@Repository
interface MultiplayerRepository : MongoRepository<MultiplayerGame, String>


enum class Operation(val amount: Int) {
    INCREMENT(1), DECREMENT(-1), RESET(1)
}

class StringToOperationConverter : Converter<String?, Operation?> {
    override fun convert(source: String): Operation =
            Operation.valueOf(source.toUpperCase())

}
