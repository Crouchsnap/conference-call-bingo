package com.bingo.high.score

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping(path = ["/highscores"])
@CrossOrigin(origins = ["http://localhost:8000", "https://bingo.apps.pd01.useast.cf.ford.com"])
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

