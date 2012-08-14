# спецификация класса GameSokoban

{GameSokoban} = require('../lib/game_sokoban')

# корректный уровень
LEVEL1 = "
#######\n
#@ $ .#\n
#######"

# в уровне больше Целей чем Ящиков
LEVEL2 = "
#######\n
#   +*#\n
#######"


describe "describe GameSokoban", ->
  it "инициализация класса", ->
    game = new GameSokoban()
    expect(game).toBeDefined()
  
  describe "загрузка уровня", ->
    it "наличие элемента в ячейкее", ->
      game = new GameSokoban()
      game.set_level(LEVEL1)
      expect( game.element_at_pos({ col: 0, row: 0}) ).toEqual GameSokoban.WALL
      expect( game.element_at_pos({ col: 1, row: 1}) ).toEqual GameSokoban.SOKOBAN
      expect( game.element_at_pos({ col: 2, row: 1}) ).toEqual GameSokoban.FREE
      expect( game.element_at_pos({ col: 3, row: 1}) ).toEqual GameSokoban.BOX
      expect( game.element_at_pos({ col: 5, row: 1}) ).toEqual GameSokoban.GOAL

      game.set_level(LEVEL2)
      expect( game.element_at_pos({ col: 4, row: 1}) ).toEqual GameSokoban.SOKOBAN_ON_GOAL
      expect( game.element_at_pos({ col: 5, row: 1}) ).toEqual GameSokoban.BOX_ON_GOAL
