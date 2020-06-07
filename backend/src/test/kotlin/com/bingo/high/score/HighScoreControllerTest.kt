package com.bingo.high.score

import assertk.assertThat
import assertk.assertions.*
import org.junit.jupiter.api.Test
import org.mockito.ArgumentCaptor
import org.mockito.Captor
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
import java.time.Instant

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
internal class HighScoreControllerTest {

    @Autowired
    lateinit var testRestTemplate: TestRestTemplate

    @Captor
    lateinit var gameResultCaptor: ArgumentCaptor<GameResult>

    @MockBean
    lateinit var scoreRepository: ScoreRepository

    val highScoresUrl = UriComponentsBuilder.fromPath("/api/scores").build().toUri()
    class ListHighScores : ParameterizedTypeReference<List<HighScore>>()

    @Test
    internal fun `should retrieve all the scores from the database`() {

        `when`(scoreRepository.findAll()).thenReturn(listOf(GameResult("id1", 456, "player"), GameResult("id2", 123, "player")))

        val highScores = testRestTemplate.exchange(highScoresUrl, HttpMethod.GET, null, ListHighScores()).body

        assertThat(highScores!!).containsExactly(HighScore(123, "player"), HighScore(456, "player"))
    }

    @Test
    internal fun `should save a game result to the database`() {
        val gameResult = GameResultBody(score = 123, player = "play")
        val beforeRequest = Instant.now()

        val response = testRestTemplate.postForEntity(highScoresUrl, gameResult, Void::class.java)

        assertThat(response.statusCode).isEqualTo(HttpStatus.OK)
        verify(scoreRepository).save(gameResultCaptor.capture())

        val actual = gameResultCaptor.value
        val expected = gameResult.toGameResult()
        assertThat(actual).isEqualToIgnoringGivenProperties(expected, GameResult::createdDate)
        assertThat(actual.createdDate).isBetween(beforeRequest, expected.createdDate)
    }

    @Test
    internal fun `shouldn't save a game result without initials`() {
        val gameResult = GameResultBody(score = 123, player = "")

        val response : ResponseEntity<String> = testRestTemplate.postForEntity(highScoresUrl, gameResult, String::class.java)

        assertThat(response.statusCode).isEqualTo(HttpStatus.BAD_REQUEST)
        assertThat(response.body!!).contains("size must be between 2 and 4")
        verify(scoreRepository, never()).save(any())
    }
}



