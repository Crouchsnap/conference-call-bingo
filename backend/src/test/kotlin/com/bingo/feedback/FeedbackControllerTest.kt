package com.bingo.feedback

import assertk.assertThat
import assertk.assertions.contains
import assertk.assertions.isBetween
import assertk.assertions.isEqualTo
import assertk.assertions.isEqualToIgnoringGivenProperties
import org.junit.jupiter.api.Test
import org.mockito.ArgumentCaptor
import org.mockito.Captor
import org.mockito.Mockito
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.boot.test.web.client.TestRestTemplate
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.test.context.bean.override.mockito.MockitoBean
import org.springframework.web.util.UriComponentsBuilder
import java.time.Instant

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
internal class FeedbackControllerTest {
    @Autowired
    lateinit var testRestTemplate: TestRestTemplate

    @Captor
    lateinit var feedbackArgumentCaptor: ArgumentCaptor<Feedback>

    @MockitoBean
    lateinit var feedbackRepository: FeedbackRepository
    val feedbackUrl = UriComponentsBuilder.fromPath("/api/feedback").build().toUri()

    @Test
    internal fun `should save a feedback to the database`() {
        val feedbackRequest = FeedbackRequest(suggestion = "something else", rating = 5)
        val beforeRequest = Instant.now()
        val response = testRestTemplate.postForEntity(feedbackUrl, feedbackRequest, Void::class.java)

        assertThat(response.statusCode).isEqualTo(HttpStatus.OK)
        Mockito.verify(feedbackRepository).save(feedbackArgumentCaptor.capture())

        val actual = feedbackArgumentCaptor.value
        val expected = feedbackRequest.toFeedback()
        assertThat(actual).isEqualToIgnoringGivenProperties(expected, Feedback::createdDate)
        assertThat(actual.createdDate).isBetween(beforeRequest, expected.createdDate)
    }


    @Test
    internal fun `shouldn't save a feedback with star rating more than 5`() {
        val feedbackRequest = FeedbackRequest(suggestion = "something else", rating = 12)

        val response : ResponseEntity<String> = testRestTemplate.postForEntity(feedbackUrl, feedbackRequest, String::class.java)

        assertThat(response.statusCode).isEqualTo(HttpStatus.BAD_REQUEST)
        assertThat(response.body!!).contains("must be between 1 and 5")
        Mockito.verify(feedbackRepository, Mockito.never()).save(Mockito.any())
    }
}
