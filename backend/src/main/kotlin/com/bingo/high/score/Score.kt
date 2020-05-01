package com.bingo.high.score

import org.springframework.data.annotation.Id
import org.springframework.data.mongodb.repository.MongoRepository
import javax.validation.constraints.Max
import javax.validation.constraints.Min
import javax.validation.constraints.Size


data class HighScore(val score: Long, val player: String)
data class GameResult(@Id val id: String? = null, val score: Long, val player: String)
data class GameResultBody(val score: Long,
                          @field:Size(min = 2, max = 4)
                          val player: String,
                          val suggestion: String? = "",
                          val rating: Int = 0)

fun List<GameResult>.toHighScores(): List<HighScore> = map { it.toHighScore() }
fun GameResult.toHighScore(): HighScore = HighScore(score = score, player = player)
fun GameResultBody.toGameResult(): GameResult = GameResult(score = score, player = player)


interface ScoreRepository : MongoRepository<GameResult, String>