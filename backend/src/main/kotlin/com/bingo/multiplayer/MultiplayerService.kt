package com.bingo.multiplayer

import com.mongodb.BasicDBObject
import org.springframework.data.mongodb.core.MongoTemplate
import org.springframework.data.mongodb.core.query.Criteria
import org.springframework.data.mongodb.core.query.Query
import org.springframework.data.mongodb.core.query.Update
import org.springframework.stereotype.Service


@Service
class MultiplayerService(private  val mongoTemplate: MongoTemplate) {

    fun createMultiplayerGame(game: MultiplayerGame): MultiplayerGame =
            mongoTemplate.save(game)

    fun addPlayer(gameId: String, player: Player): MultiplayerGame? =
            mongoTemplate.findAndModify(
                    Query.query(Criteria.where("id").`is`(gameId)
                            .and("players.score").ne(5)),
                    Update().push("players", player),
                    MultiplayerGame::class.java)

    fun removePlayer(gameId: String, playerId: String) =
            mongoTemplate.updateFirst(
                    Query.query(Criteria.where("id").`is`(gameId)
                            .and("players.score").ne(5)
                    ),
                    Update().pull("players", BasicDBObject("id", playerId)),
                    MultiplayerGame::class.java)

    fun updateScore(operation: Operation, gameId: String, playerId: String) =
            mongoTemplate.updateFirst(
                    Query.query(Criteria.where("id").`is`(gameId)
                            .and("players.id").`is`(playerId)
                            .and("players.score").ne(5)
                    ),
                    when (operation) {
                        Operation.RESET -> Update().set("players.$.score", operation.amount)
                        else -> Update().inc("players.$.score", operation.amount)
                    },
                    MultiplayerGame::class.java)
}


