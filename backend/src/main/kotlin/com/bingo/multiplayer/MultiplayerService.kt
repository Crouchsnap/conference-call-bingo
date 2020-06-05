package com.bingo.multiplayer

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.data.mongodb.core.MongoTemplate
import org.springframework.data.mongodb.core.query.Criteria
import org.springframework.data.mongodb.core.query.Query
import org.springframework.data.mongodb.core.query.Update
import org.springframework.stereotype.Service
import reactor.core.publisher.Mono

@Service
class MultiplayerService {

    @Autowired
    private lateinit var mongoTemplate: MongoTemplate

    @Autowired
    private lateinit var multiplayerScoreRepository: MultiplayerScoreRepository

    fun createMultiplayerGame(game: MultiplayerGame): String =
            mongoTemplate.save(game).id!!

    fun addPlayer(gameId: String, player: Player) =
            mongoTemplate.findAndModify(
                    Query.query(Criteria.where("id").`is`(gameId)),
                    Update().push("players", player),
                    MultiplayerGame::class.java)


    fun updateScore(gameId: String, playerId: String, score: Int): Mono<ScoreResponse> {
        val multiplayerGame = mongoTemplate.findById(gameId, MultiplayerGame::class.java)
        val player = multiplayerGame?.players?.find { it.id == playerId }
                ?: throw RuntimeException("Player not found in game")
        return multiplayerScoreRepository.save(Score(gameId = gameId, playerId = playerId, score = score, initials = player.initials))
                .map { it.toScoreReponse() }
    }

}
