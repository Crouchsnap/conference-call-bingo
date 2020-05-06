package com.bingo.feedback

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.*
import javax.validation.Valid

@RestController
@RequestMapping(path = ["/api/feedback"])
@CrossOrigin(origins = ["http://localhost:8000"])
class FeedbackController {

    @Autowired
    private lateinit var feedbackRepository: FeedbackRepository

    @PostMapping
    fun postFeedback(@Valid @RequestBody feedbackRequest: FeedbackRequest){
        feedbackRepository.save(feedbackRequest.toFeedback())
    }
}