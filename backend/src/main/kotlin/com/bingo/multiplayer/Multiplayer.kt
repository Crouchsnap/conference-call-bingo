package com.bingo.multiplayer

import org.springframework.core.convert.converter.Converter
import org.springframework.data.annotation.Id
import org.springframework.data.mongodb.repository.MongoRepository
import java.util.*

data class AddMultiplayerRequest(val initials: String = "")

fun AddMultiplayerRequest.toMultiplayerGame() = MultiplayerGame(players = listOf(Player(initials = initials)))
fun AddMultiplayerRequest.toPlayer() = Player(initials = initials)


data class Player(@Id val id: String = UUID.randomUUID().toString(), val initials: String, val score: Int = 1)
data class MultiplayerGame(@Id val id: String? = null, val players: List<Player> = emptyList())


enum class Operation(val amount: Int) {
    INCREMENT(1), DECREMENT(-1)
}

class StringToOperationConverter : Converter<String?, Operation?> {
    override fun convert(source: String): Operation =
            Operation.valueOf(source.toUpperCase())

}