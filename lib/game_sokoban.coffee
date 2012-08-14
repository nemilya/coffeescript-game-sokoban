# класс игры Сокобан на CoffeeScript - GameSokoban

class GameSokoban

  @WALL:    '#'
  @SOKOBAN: '@'
  @FREE:    ' '
  @BOX:     '$'
  @GOAL:    '.'
  @SOKOBAN_ON_GOAL: '+'
  @BOX_ON_GOAL:     '*'


  set_level: (level) ->
  	@level_cells = []
  	rows = level.split /\n/
  	for row in rows
  		next if row == ''
  		cells = row.split //
  		@level_cells.push(row)
    @init_info()

  element_at_pos: (pos) ->
  	@level_cells[pos.row][pos.col]

  info: -> @_info

  init_info: ->
  	@_info = {}
  	@_info.box_cnt = 0
  	@_info.sokoban_cnt = 0
  	@_info.goals_cnt = 0
  	@_info.box_on_goal_cnt = 0
  	@_level_size = { max_row: 0, max_col: 0 }
  	@_level_size.max_row = @level_cells.length - 1
  	for row in @level_cells
  		@_level_size.max_col = row.length-1 if row.length-1 > @_level_size.max_col
  		for cell in row
  			@_info.box_cnt++      if cell in [GameSokoban.BOX, GameSokoban.BOX_ON_GOAL]
  			@_info.sokoban_cnt++  if cell in [GameSokoban.SOKOBAN, GameSokoban.SOKOBAN_ON_GOAL]
  			@_info.goals_cnt++    if cell in [GameSokoban.GOAL, GameSokoban.SOKOBAN_ON_GOAL, GameSokoban.BOX_ON_GOAL]
  			@_info.box_on_goal_cnt++  if cell is GameSokoban.BOX_ON_GOAL
  			  
  level_size: -> @_level_size

  level_valid: ->
  	@_info.sokoban_cnt == 1 and @_info.box_cnt > 0 and @_info.goals_cnt == @_info.box_cnt

exports.GameSokoban = GameSokoban