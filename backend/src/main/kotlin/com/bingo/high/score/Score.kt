package com.bingo.high.score

import org.springframework.data.annotation.Id
import org.springframework.data.mongodb.repository.MongoRepository
import java.time.Instant
import javax.validation.constraints.Size


data class HighScore(val score: Long, val player: String)
data class GameResult(@Id val id: String? = null,
                      val score: Long, val player: String,
                      val createdDate: Instant = Instant.now())

data class GameResultBody(val score: Long,
                          @field:Size(min = 2, max = 4)
                          val player: String,
                          val suggestion: String? = "",
                          val rating: Int = 0)

fun List<GameResult>.toHighScores(): List<HighScore> = map { it.toHighScore() }
fun GameResult.toHighScore(): HighScore = HighScore(score = score, player = player)
fun GameResultBody.toGameResult(): GameResult = GameResult(score = score, player = player)


interface ScoreRepository : MongoRepository<GameResult, String>
