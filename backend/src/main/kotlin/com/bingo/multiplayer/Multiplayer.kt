package com.bingo.multiplayer

import org.springframework.data.annotation.Id
import org.springframework.data.mongodb.repository.MongoRepository

data class StartMultiplayerRequest(val player: String = "")
data class MultiplayerGame(@Id val id: String? = null)

fun StartMultiplayerRequest.toMultiplayerGame() = MultiplayerGame()

interface MultiplayerRepository : MongoRepository<MultiplayerGame, String>

