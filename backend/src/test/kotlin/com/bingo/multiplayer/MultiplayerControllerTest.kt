package com.bingo.multiplayer

import assertk.assertThat
import assertk.assertions.contains
import assertk.assertions.isEqualTo
import com.bingo.high.score.GameResultBody
import com.bingo.high.score.toGameResult
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.boot.test.web.client.TestRestTemplate
import org.springframework.http.HttpStatus

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class MultiplayerControllerTest {

    @Autowired
    lateinit var multiplayerRepository:MultiplayerRepository

    @Autowired
    lateinit var testRestTemplate:TestRestTemplate

    @Test
    internal fun `start game should return a game ID`() {
        val requestBody = StartMultiplayerRequest(player = "NK")

        val response = testRestTemplate.postForEntity("/api/multiplayer/start", requestBody, String::class.java)

        assertThat(response.statusCode).isEqualTo(HttpStatus.CREATED)
        assertThat(response.body).isEqualTo(multiplayerRepository.findAll()[0].id)
    }
}