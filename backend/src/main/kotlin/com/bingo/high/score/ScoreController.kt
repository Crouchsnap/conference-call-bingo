package com.bingo.high.score

import jakarta.validation.Valid
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping(path = ["/api/scores"])
@CrossOrigin(origins = ["http://localhost:8000"])
class ScoreController(private val scoreRepository: ScoreRepository) {
    
    @GetMapping
    fun getHighScores(): List<HighScore> =
            scoreRepository.findAll().toHighScores().sortedBy { it.score }

    @PostMapping
    fun postScore(@Valid @RequestBody gameResultBody: GameResultBody) {
        scoreRepository.save(gameResultBody.toGameResult())
    }
}
