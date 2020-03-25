package com.bingo.high.score

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.*
import javax.validation.Valid

@RestController
@RequestMapping(path = ["/scores"])
@CrossOrigin(origins = ["http://localhost:8000", "https://bingo.apps.pd01.useast.cf.ford.com"])
class ScoreController {
    
    @Autowired
    lateinit var scoreRepository: ScoreRepository

    @GetMapping
    fun getHighScores(): List<HighScore> =
            scoreRepository.findAll().toHighScores().sortedBy { it.score }

    @PostMapping
    fun postScore(@Valid @RequestBody gameResultBody: GameResultBody) {
        scoreRepository.save(gameResultBody.toGameResult())
    }
}

