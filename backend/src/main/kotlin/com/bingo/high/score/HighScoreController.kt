package com.bingo.high.score

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping(path = ["/highscores"])
class HighScoreController {
    
    @Autowired
    lateinit var highScoreRepository: HighScoreRepository

    @GetMapping
    fun getHighScores(): List<HighScore> =
            highScoreRepository.findAll().toHighScores()

    @PostMapping
    fun postScore(@RequestBody score: HighScore) {
        highScoreRepository.save(score.toHighScoreEntity())
    }
}


