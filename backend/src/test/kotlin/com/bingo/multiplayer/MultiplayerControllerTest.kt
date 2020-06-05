package com.bingo.multiplayer

import assertk.assertThat
import assertk.assertions.isEqualTo
import assertk.assertions.isNotNull
import org.junit.jupiter.api.AfterEach
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.boot.test.web.client.TestRestTemplate
import org.springframework.data.mongodb.repository.MongoRepository
import org.springframework.http.HttpStatus
import org.springframework.http.MediaType
import org.springframework.test.web.reactive.server.WebTestClient
import org.springframework.test.web.reactive.server.returnResult


interface MultiplayerRepository : MongoRepository<MultiplayerGame, String>

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class MultiplayerControllerTest {

    @Autowired
    lateinit var multiplayerRepository: MultiplayerRepository

    @Autowired
    lateinit var testRestTemplate: TestRestTemplate

    @Autowired
    lateinit var multiplayerScoreRepository: MultiplayerScoreRepository

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
    internal fun `score should return 200 and add a score`() {
        val multiplayerGame = multiplayerRepository.save(MultiplayerGame(players = listOf(Player(initials = "NK"))))

        val response = testRestTemplate.postForEntity("/api/multiplayer/score/${multiplayerGame.id}/${multiplayerGame.players[0].id}", ScoreRequest(4), ScoreResponse::class.java)

        assertThat(response.statusCode).isEqualTo(HttpStatus.OK)
        assertThat(response.body!!).isEqualTo(ScoreResponse(playerId = multiplayerGame.players[0].id, initials = "NK", score = 4))

        val actual = multiplayerScoreRepository.findAll().blockFirst()!!
        assertThat(actual.playerId).isEqualTo(multiplayerGame.players[0].id)
        assertThat(actual.gameId).isEqualTo(multiplayerGame.id)
        assertThat(actual.initials).isEqualTo("NK")
        assertThat(actual.score).isEqualTo(4)
        assertThat(actual.id).isNotNull()
    }

    @Autowired
    private lateinit var webTestClient: WebTestClient

    @Test
    internal fun `scores should return 200 and a score`() {
        val multiplayerGame = multiplayerRepository.save(MultiplayerGame(players = listOf(Player(initials = "NK"))))
        val score = multiplayerScoreRepository.save(Score(gameId = multiplayerGame.id!!, playerId = multiplayerGame.players[0].id, initials = "NK", score = 3)).block()
        val score2 = multiplayerScoreRepository.save(Score(gameId = multiplayerGame.id!!, playerId = multiplayerGame.players[0].id, initials = "NK", score = 4)).block()

        val result = webTestClient.get().uri("/api/multiplayer/scores/${multiplayerGame.id}")
                .accept(MediaType.TEXT_EVENT_STREAM)
                .exchange()
                .expectStatus().isOk
                .returnResult<ScoreResponse>()
                .responseBody
                .take(2)
                .collectList()
                .block();

        assertThat(result).isEqualTo(listOf(score, score2).map { it?.toScoreResponse() })

    }


}

