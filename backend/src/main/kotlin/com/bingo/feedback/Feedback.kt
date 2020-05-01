package com.bingo.feedback

import org.springframework.data.annotation.Id
import org.springframework.data.mongodb.repository.MongoRepository
import javax.validation.constraints.Max
import javax.validation.constraints.Min
const val ratingRangeMessage = "must be between 1 and 5"


data class FeedbackEntity(@Id val id: String? = null
                          ,val suggestion: String? = "",
                          val rating: Int = 0)
data class FeedbackRequest(val suggestion: String?,
                           @field:Min(value = 1, message = ratingRangeMessage)
                           @field:Max(value = 5, message = ratingRangeMessage)
                           val rating: Int)

fun FeedbackRequest.toFeedbackEntity(): FeedbackEntity = FeedbackEntity(suggestion = suggestion, rating = rating)
interface FeedbackRepository : MongoRepository<FeedbackEntity, String>


