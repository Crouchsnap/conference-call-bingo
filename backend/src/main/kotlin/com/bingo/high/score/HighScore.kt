package com.bingo.high.score

import org.springframework.data.annotation.Id
import org.springframework.data.mongodb.repository.MongoRepository

data class HighScore (val score: String, val player: String)
data class GameResult(@Id val id: String? = null, val score: String, val player: String)

fun List<GameResult>.toHighScores(): List<HighScore> = map { it.toHighScore() }
fun GameResult.toHighScore(): HighScore = HighScore(score = score, player = player)
fun HighScore.toGameResult(): GameResult = GameResult(score = score, player = player)


interface ScoreRepository : MongoRepository<GameResult, String>