package com.bingo.multiplayer

import org.springframework.data.annotation.Id
import org.springframework.data.mongodb.repository.MongoRepository

data class StartMultiplayerRequest(val player: String = "")
fun StartMultiplayerRequest.toMultiplayerGame() = MultiplayerGame(players = listOf(Player(player)))


data class Player(val player:String)
data class MultiplayerGame(@Id val id: String? = null, val players: List<Player> = emptyList())

interface MultiplayerRepository : MongoRepository<MultiplayerGame, String>

