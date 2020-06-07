package com.bingo.feedback

import org.springframework.data.annotation.Id
import org.springframework.data.mongodb.repository.MongoRepository
import java.time.Instant
import javax.validation.constraints.Max
import javax.validation.constraints.Min

const val ratingRangeMessage = "must be between 1 and 5"


data class Feedback(@Id val id: String? = null,
                    val createdDate: Instant = Instant.now(),
                    val suggestion: String? = "",
                    val rating: Int = 0)

data class FeedbackRequest(val suggestion: String?,
                           @field:Min(value = 1, message = ratingRangeMessage)
                           @field:Max(value = 5, message = ratingRangeMessage)
                           val rating: Int)

fun FeedbackRequest.toFeedback(): Feedback = Feedback(suggestion = suggestion, rating = rating)
interface FeedbackRepository : MongoRepository<Feedback, String>


