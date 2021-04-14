# [conference-call-bingo](https://bingo.labs.ford.com/)

[Elm](https://elm-lang.org) app for playing conference call bingo in these trying times.

Credit to sscheman@ford.com for the design!

![](https://github.com/crouchsnap/conference-call-bingo/workflows/UI%20Tests/badge.svg)
![](https://github.com/Crouchsnap/conference-call-bingo/workflows/Backend%20Tests/badge.svg)

## Common questions about the game
 1. The free space is intentionally un-marked to start.
    Our bingo game counts the free space whether you mark it or not, so have fun daubing! 🖌🎨
 1. Being able to mark something more than once is intentional. Daubing something for a fourth time will un-daub™  it, so don't worry if you daub something by mistake!
    

## Running
### Prerequisites
 - npm
 - Java 8
 
#### UI
 1. `cd ui`
 1. `npm install`
 1. `npm run start`
 1. Navigate to `http://localhost:8000`
#### Backend
 1. `cd backend`
 1. `./gradlew bootRun`
