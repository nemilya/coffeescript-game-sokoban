# спецификация класса GameSokoban

{GameSokoban} = require('../lib/game_sokoban')

describe "describe GameSokoban", ->
  it "инициализация класса", ->
    game = new GameSokoban()
    expect(game).toBeDefined()
