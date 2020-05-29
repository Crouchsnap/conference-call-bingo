package com.bingo.multiplayer

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.context.annotation.Configuration
import org.springframework.data.mongodb.core.MongoTemplate
import org.springframework.data.mongodb.core.query.Criteria
import org.springframework.data.mongodb.core.query.Query
import org.springframework.data.mongodb.core.query.Update
import org.springframework.format.FormatterRegistry
import org.springframework.http.HttpStatus
import org.springframework.web.bind.annotation.*
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer
import javax.validation.Valid


@RestController
@RequestMapping(path = ["/api/multiplayer"])
@CrossOrigin(origins = ["http://localhost:8000"])
class MultiplayerController {
    @Autowired
    private lateinit var multiplayerRepository: MultiplayerRepository

    @Autowired
    private lateinit var mongoTemplate: MongoTemplate

    @PostMapping(path = ["start"])
    @ResponseStatus(HttpStatus.CREATED)
    fun startMultiplayer(@Valid @RequestBody addMultiplayerRequest: AddMultiplayerRequest): String =
            multiplayerRepository.save(addMultiplayerRequest.toMultiplayerGame()).id!!


    @PostMapping("join/{gameId}")
    fun joinMultiplayer(@PathVariable gameId: String, @Valid @RequestBody addMultiplayerRequest: AddMultiplayerRequest): String =
            addMultiplayerRequest
                    .toPlayer()
                    .apply {
                        mongoTemplate.findAndModify(
                                Query.query(Criteria.where("id").`is`(gameId)),
                                Update().push("players", this),
                                MultiplayerGame::class.java)
                    }.id


    @PostMapping("{operation}/{gameId}/{playerId}")
    fun decrementScore(@PathVariable operation: Operation, @PathVariable gameId: String, @PathVariable playerId: String) =
            mongoTemplate.updateFirst(
                    Query.query(Criteria.where("id").`is`(gameId)
                            .and("players.id").`is`(playerId)),
                    Update().inc("players.$.score", operation.amount),
                    MultiplayerGame::class.java)
}

@Configuration
class OperationFormatter : WebMvcConfigurer {
    override fun addFormatters(registry: FormatterRegistry) {
        registry.addConverter(StringToEnumConverter())
    }
}

