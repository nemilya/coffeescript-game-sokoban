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

  element_at_pos: (pos) ->
  	@level_cells[pos.row][pos.col]

exports.GameSokoban = GameSokoban