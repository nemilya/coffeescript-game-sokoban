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

# 
LEVEL3 = "
#####\n
#   #\n
# @ #\n
#   #\n
#####"

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

    it "информация по уровню", ->
      game = new GameSokoban()

      game.set_level(LEVEL1)
      info = game.info()

      expect( info.box_cnt     ).toEqual 1
      expect( info.sokoban_cnt ).toEqual 1
      expect( info.goals_cnt   ).toEqual 1
      expect( info.box_on_goal_cnt).toEqual 0
      
      game.set_level(LEVEL2)
      info = game.info()
      expect( info.box_cnt     ).toEqual 1
      expect( info.sokoban_cnt ).toEqual 1
      expect( info.goals_cnt   ).toEqual 2
      expect( info.box_on_goal_cnt ).toEqual 1

    it "размер уровня", ->
      game = new GameSokoban()
      game.set_level(LEVEL1)
      expect( game.level_size() ).toEqual { max_row: 2, max_col: 6 }
    
    it "валидный уровень, если есть 1 Сокобан, по крайней мере один ящик, и целей по количеству ящиков", ->
      game = new GameSokoban
      game.set_level(LEVEL1)
      expect( game.level_valid() ).toBeTruthy()
    
    it "не валидный уровень", ->
      game = new GameSokoban
      game.set_level LEVEL2
      expect( game.level_valid() ).toBeFalsy()

    it "#get_cell_at", ->
      game = new GameSokoban
      game.set_level LEVEL1

      # на базе внутреннего представления
      expect( game.get_cell_at({col: 1, row: 1}) ).toEqual GameSokoban.SOKOBAN
      expect( game.get_cell_at({col: 0, row: 0}) ).toEqual GameSokoban.WALL
      expect( game.get_cell_at({col: 3, row: 1}) ).toEqual GameSokoban.BOX
      expect( game.get_cell_at({col: 5, row: 1}) ).toEqual GameSokoban.GOAL

    it "получение уровня", ->
      game = new GameSokoban
      game.set_level LEVEL1
      expect( game.get_level() ).toEqual LEVEL1
    
  describe "Сокобан", ->
    it "местоположение", ->
      game = new GameSokoban
      game.set_level LEVEL1
      expect( game.sokoban_pos() ).toEqual { col: 1, row: 1}

    it "#valid_direction?", ->
      game = new GameSokoban
      expect( game.valid_direction('up') ).toBeTruthy()
      expect( game.valid_direction('down') ).toBeTruthy()
      expect( game.valid_direction('left') ).toBeTruthy()
      expect( game.valid_direction('right') ).toBeTruthy()

      expect( game.valid_direction('jump') ).toBeFalsy()

    describe "свободное передвижение", ->
      it "вверх", ->
        game = new GameSokoban
        game.set_level LEVEL3
        expect( game.sokoban_pos() ).toEqual { col: 2, row: 2}

        game.sokoban_move 'up'
        expect( game.sokoban_pos() ).toEqual { col: 2, row: 1}

      it "вниз", ->
        game = new GameSokoban
        game.set_level LEVEL3
        expect( game.sokoban_pos() ).toEqual { col: 2, row: 2}

        game.sokoban_move 'down'
        expect( game.sokoban_pos() ).toEqual { col: 2, row: 3}

      it "влево", ->
        game = new GameSokoban
        game.set_level LEVEL3
        expect( game.sokoban_pos() ).toEqual { col: 2, row: 2}

        game.sokoban_move 'left'
        expect( game.sokoban_pos() ).toEqual { col: 1, row: 2}

      it "вправо", ->
        game = new GameSokoban
        game.set_level LEVEL3
        expect( game.sokoban_pos() ).toEqual { col: 2, row: 2}

        game.sokoban_move 'right'
        expect( game.sokoban_pos() ).toEqual { col: 3, row: 2}

#      it "передвижение на цель возможно", ->
#        game = new GameSokoban
#        game.set_level ' @. #'
#        game.sokoban_move 'right'
#        
#        expect( game.get_level() ).toEqual '  + #'

    describe "перемещения на стену", ->
      it "координаты не меняются", ->
        game = new GameSokoban
        game.set_level LEVEL1
        initial_pos = game.sokoban_pos()

        game.sokoban_move 'up'
        expect( game.sokoban_pos() ).toEqual initial_pos

        game.sokoban_move 'down'
        expect( game.sokoban_pos() ).toEqual initial_pos
      
        game.sokoban_move 'left'
        expect( game.sokoban_pos() ).toEqual initial_pos

    describe "перемещение ящика", ->
      describe "#is_box_movable?", ->
        it "перемещение ящика возможно", ->
          game = new GameSokoban
          game.set_level ' @$  '
          expect( game.is_box_movable({col: 2, row: 0}, 'right') ).toBeTruthy()

          game.set_level ' @$. '
          expect( game.is_box_movable({col: 2, row: 0}, 'right') ).toBeTruthy()

        it "перемещение ящика невозможно", ->
          game = new GameSokoban
          game.set_level ' @$# '
          expect( game.is_box_movable({col: 2, row: 0}, 'right') ).toBeFalsy()

          game.set_level ' @$$ '
          expect( game.is_box_movable({col: 2, row: 0}, 'right') ).toBeFalsy()

          game.set_level ' @$* '
          expect( game.is_box_movable({col: 2, row: 0}, 'right') ).toBeFalsy()

        it "перемещение ящика стоящего на цели возможно", ->
          game = new GameSokoban
          game.set_level ' @*  '
          expect( game.is_box_movable({col: 2, row: 0}, 'right') ).toBeTruthy()

          game.set_level ' @*. '
          expect( game.is_box_movable({col: 2, row: 0}, 'right') ).toBeTruthy()

        it "перемещение ящика стоящего на цели невозможно", ->
          game = new GameSokoban
          game.set_level ' @*# '
          expect( game.is_box_movable({col: 2, row: 0}, 'right') ).toBeFalsy()
        
          game.set_level ' @*$ '
          expect( game.is_box_movable({col: 2, row: 0}, 'right') ).toBeFalsy()

          game.set_level ' @** '
          expect( game.is_box_movable({col: 2, row: 0}, 'right') ).toBeFalsy()

      it "#boxes", ->
        game = new GameSokoban
        game.set_level '#@$ #'
        expect( game.boxes() ).toEqual [{col: 2, row: 0}]

      it "отрисовка перемещения", ->
        game = new GameSokoban
        game.set_level '#@$ #'
        game.sokoban_move 'right'
        expect( game.get_level() ).toEqual '# @$#'

      it "отрисовка нельзя переместить", ->
        game = new GameSokoban
        game.set_level '#@$$#'
        game.sokoban_move 'right'

        expect( game.get_level() ).toEqual '#@$$#'
