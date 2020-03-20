package com.bingo.high.score

import org.springframework.data.annotation.Id
import org.springframework.data.mongodb.repository.MongoRepository

data class HighScore (val score: String, val player: String)


data class HighScoreEntity(@Id val id: String?, val score: String, val player: String)

fun List<HighScoreEntity>.toHighScores(): List<HighScore> = emptyList()

interface HighScoreRepository : MongoRepository<HighScoreEntity, String>