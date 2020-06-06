package com.bingo.multiplayer

import assertk.assertThat
import assertk.assertions.isEqualTo
import org.junit.jupiter.api.AfterEach
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.boot.test.web.client.TestRestTemplate
import org.springframework.http.HttpStatus
import org.springframework.http.MediaType
import org.springframework.test.web.reactive.server.WebTestClient
import org.springframework.test.web.reactive.server.returnResult


@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class MultiplayerControllerTest {

    @Autowired
    lateinit var multiplayerRepository: MultiplayerRepository

    @Autowired
    private lateinit var webTestClient: WebTestClient

    @Autowired
    lateinit var testRestTemplate: TestRestTemplate

    @AfterEach
    internal fun tearDown() {
        multiplayerRepository.deleteAll()
    }

    @Test
    internal fun `start game should return a Create Game Response`() {
        val requestBody = AddMultiplayerRequest(initials = "NK", score = 4)

        val response = testRestTemplate.postForEntity("/api/multiplayer/start", requestBody, CreateGameResponse::class.java)

        assertThat(response.statusCode).isEqualTo(HttpStatus.CREATED)
        val actual = multiplayerRepository.findAll()[0]
        assertThat(response.body!!.id).isEqualTo(actual.id)
        assertThat(response.body!!.playerId).isEqualTo(actual.players.first().id)
        assertThat(actual.players[0].initials).isEqualTo("NK")
        assertThat(actual.players[0].score).isEqualTo(4)
    }

    @Test
    internal fun `join game should return a Create Game Response`() {
        val multiplayerGame = multiplayerRepository.save(MultiplayerGame(players = listOf(Player(initials = "NK"))))
        val requestBody = AddMultiplayerRequest(initials = "!NK", score = 3)

        val response = testRestTemplate.postForEntity("/api/multiplayer/join/${multiplayerGame.id}", requestBody, CreateGameResponse::class.java)

        assertThat(response.statusCode).isEqualTo(HttpStatus.OK)
        val actual = multiplayerRepository.findAll()[0]
        assertThat(response.body!!.id).isEqualTo(actual.id)
        assertThat(response.body!!.playerId).isEqualTo(actual.players[1].id)
        assertThat(actual.players[0].initials).isEqualTo("NK")
        assertThat(actual.players[0].score).isEqualTo(1)
        assertThat(actual.players[1].initials).isEqualTo("!NK")
        assertThat(actual.players[1].score).isEqualTo(3)
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

    @Test
    internal fun `reset score should return 200 and set the player's score to 1`() {
        val multiplayerGame = multiplayerRepository.save(MultiplayerGame(players = listOf(Player(initials = "NK", score = 6))))

        val response = testRestTemplate.postForEntity("/api/multiplayer/reset/${multiplayerGame.id}/${multiplayerGame.players[0].id}", null, Void::class.java)

        assertThat(response.statusCode).isEqualTo(HttpStatus.OK)
        val actual = multiplayerRepository.findAll()[0].players[0]
        assertThat(actual.score).isEqualTo(1)
    }


    @Test
    internal fun `scores should return 200 and a score`() {
        val multiplayerGame = multiplayerRepository.save(MultiplayerGame(players = listOf(Player(initials = "NK", score = 3), Player(initials = "MK"))))

        val result = webTestClient.get().uri("/api/multiplayer/scores/${multiplayerGame.id}")
                .accept(MediaType.TEXT_EVENT_STREAM)
                .exchange()
                .expectStatus().isOk
                .returnResult<List<ScoreResponse>>()
                .responseBody
                .take(2)
                .collectList()
                .block();

        val individualScoresResponse = multiplayerGame.players.map { it.toScoreResponse() }
        assertThat(result).isEqualTo(listOf(
                individualScoresResponse,
                individualScoresResponse
        ))
    }
}

