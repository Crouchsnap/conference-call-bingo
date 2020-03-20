package com.bingo.high.score

import org.springframework.data.annotation.Id
import org.springframework.data.mongodb.repository.MongoRepository

data class HighScore (val score: String, val player: String)
data class HighScoreEntity(@Id val id: String? = null, val score: String, val player: String)

fun List<HighScoreEntity>.toHighScores(): List<HighScore> = map { it.toHighScore() }
fun HighScoreEntity.toHighScore(): HighScore = HighScore(score = score, player = player)
fun HighScore.toHighScoreEntity(): HighScoreEntity = HighScoreEntity(score = score, player = player)


interface HighScoreRepository : MongoRepository<HighScoreEntity, String>