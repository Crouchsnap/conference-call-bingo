package com.bingo.multiplayer

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.HttpStatus
import org.springframework.web.bind.annotation.*
import javax.validation.Valid

@RestController
@RequestMapping(path=["/api/multiplayer"])
@CrossOrigin(origins = ["http://localhost:8000"])
class MultiplayerController {
    @Autowired
    private lateinit var multiplayerRepository: MultiplayerRepository

    @PostMapping(path=["start"])
    @ResponseStatus(HttpStatus.CREATED)
    fun startMultiplayer(@Valid @RequestBody startMultiplayerRequest: StartMultiplayerRequest ):String =
            multiplayerRepository.save(startMultiplayerRequest.toMultiplayerGame()).id!!

}