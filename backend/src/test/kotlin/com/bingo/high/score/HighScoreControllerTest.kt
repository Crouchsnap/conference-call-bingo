package com.bingo.high.score

import assertk.assertThat
import assertk.assertions.contains
import assertk.assertions.containsExactly
import assertk.assertions.isEqualTo
import org.junit.jupiter.api.Test
import org.mockito.Mockito.*
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.boot.test.mock.mockito.MockBean
import org.springframework.boot.test.web.client.TestRestTemplate
import org.springframework.core.ParameterizedTypeReference
import org.springframework.http.HttpMethod
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.util.UriComponentsBuilder

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
internal class HighScoreControllerTest {

    @Autowired
    lateinit var testRestTemplate: TestRestTemplate

    @MockBean
    lateinit var scoreRepository: ScoreRepository

    val highScoresUrl = UriComponentsBuilder.fromPath("/scores").build().toUri()
    class ListHighScores : ParameterizedTypeReference<List<HighScore>>()

    @Test
    internal fun `should retrieve all the scores from the database`() {

        `when`(scoreRepository.findAll()).thenReturn(listOf(GameResult("id1", 456, "player"), GameResult("id2", 123, "player")))

        val highScores = testRestTemplate.exchange(highScoresUrl, HttpMethod.GET, null, ListHighScores()).body

        assertThat(highScores!!).containsExactly(HighScore(123, "player"), HighScore(456, "player"))
    }

    @Test
    internal fun `should save a game result to the database`() {
        val gameResult = GameResultBody(score = 123, player = "play", suggestion = "something else", rating = 5)

        val response = testRestTemplate.postForEntity(highScoresUrl, gameResult, Void::class.java)

        assertThat(response.statusCode).isEqualTo(HttpStatus.OK)
        verify(scoreRepository).save(gameResult.toGameResult())
    }

    @Test
    internal fun `shouldn't save a game result with more than 4 letters in player or higher then 5 rating`() {
        val gameResult = GameResultBody(score = 123, player = "player", suggestion = "something else", rating = 12)

        val response : ResponseEntity<String> = testRestTemplate.postForEntity(highScoresUrl, gameResult, String::class.java)

        assertThat(response.statusCode).isEqualTo(HttpStatus.BAD_REQUEST)
        assertThat(response.body!!).contains("size must be between 2 and 4")
        assertThat(response.body!!).contains("must be between 1 and 5")
        verify(scoreRepository, never()).save(any())
    }
}



