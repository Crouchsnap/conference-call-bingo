package com.bingo.high.score

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RestController

@RestController("/highscore")
class HighScoreController {
    
    @Autowired
    lateinit var highScoreRepository: HighScoreRepository

    @GetMapping
    fun getHighScores(): List<HighScore> =
            highScoreRepository.findAll().toHighScores()

    @PostMapping
    fun postScore(@RequestBody score: HighScore) {

    }
}


