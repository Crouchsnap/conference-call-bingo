package com.bingo.multiplayer

import assertk.assertThat
import assertk.assertions.isEqualTo
import org.junit.jupiter.api.AfterEach
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

    @AfterEach
    internal fun tearDown() {
        multiplayerRepository.deleteAll()
    }

    @Test
    internal fun `start game should return a game ID`() {
        val requestBody = AddMultiplayerRequest(initials = "NK")

        val response = testRestTemplate.postForEntity("/api/multiplayer/start", requestBody, String::class.java)

        assertThat(response.statusCode).isEqualTo(HttpStatus.CREATED)
        val actual = multiplayerRepository.findAll()[0]
        assertThat(response.body).isEqualTo(actual.id)
        assertThat(actual.players[0].initials).isEqualTo("NK")

    }

    @Test
    internal fun `join game should return a game ID`() {
        val multiplayerGame = multiplayerRepository.save(MultiplayerGame(players = listOf(Player(initials = "NK"))))
        val requestBody = AddMultiplayerRequest(initials = "!NK")

        val response = testRestTemplate.postForEntity("/api/multiplayer/join/${multiplayerGame.id}", requestBody, String::class.java)

        assertThat(response.statusCode).isEqualTo(HttpStatus.OK)
        val actual = multiplayerRepository.findAll()[0].players[1]
        assertThat(response.body).isEqualTo(actual.id)
        assertThat(actual.initials).isEqualTo("!NK")

    }

    @Test
    internal fun `increment score should return 200 and increment the player's score by 1`() {
        val multiplayerGame = multiplayerRepository.save(MultiplayerGame(players = listOf(Player(initials = "NK"))))

        val response = testRestTemplate.postForEntity("/api/multiplayer/increment/${multiplayerGame.id}/${multiplayerGame.players[0].id}", null, Void::class.java)

        assertThat(response.statusCode).isEqualTo(HttpStatus.OK)
        val actual = multiplayerRepository.findAll()[0].players[0]
        assertThat(actual.score).isEqualTo(2)

    }

    @Test
    internal fun `decrement score should return 200 and decrement the player's score by 1`() {
        val multiplayerGame = multiplayerRepository.save(MultiplayerGame(players = listOf(Player(initials = "NK", score = 6))))

        val response = testRestTemplate.postForEntity("/api/multiplayer/decrement/${multiplayerGame.id}/${multiplayerGame.players[0].id}", null, Void::class.java)

        assertThat(response.statusCode).isEqualTo(HttpStatus.OK)
        val actual = multiplayerRepository.findAll()[0].players[0]
        assertThat(actual.score).isEqualTo(5)

    }

}