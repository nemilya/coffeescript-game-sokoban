# класс игры Сокобан на CoffeeScript - GameSokoban

class GameSokoban

  @WALL:    '#'
  @SOKOBAN: '@'
  @FREE:    ' '
  @BOX:     '$'
  @GOAL:    '.'
  @SOKOBAN_ON_GOAL: '+'
  @BOX_ON_GOAL:     '*'

  @DIRECTIONS = 
    'up'   : row: -1
    'down' : row:  1
    'left' : col: -1
    'right': col:  1


  set_level: (level) ->
  	@level_cells = []
  	rows = level.split /\n/
  	for row in rows
  		continue if row == ''
  		cells = row.split //
  		@level_cells.push(cells)
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
  	@_sokoban_pos = {}
  	@_walls = []
  	@_boxes = []
  	@_goals = []
  	pos_row = 0
  	for row in @level_cells
  		pos_col = 0
  		@_level_size.max_col = row.length-1 if row.length-1 > @_level_size.max_col
  		for cell in row
  			cur_pos = {row: pos_row, col: pos_col}

  			if cell is GameSokoban.WALL
  				@_walls.push(cur_pos) 

  			if cell in [GameSokoban.SOKOBAN, GameSokoban.SOKOBAN_ON_GOAL]
  				@_info.sokoban_cnt++  
  				@_sokoban_pos = cur_pos

  			if cell in [GameSokoban.BOX, GameSokoban.BOX_ON_GOAL]
  				@_boxes.push(cur_pos)
  				@_info.box_cnt++

  			if cell in [GameSokoban.GOAL, GameSokoban.SOKOBAN_ON_GOAL, GameSokoban.BOX_ON_GOAL]
  				@_goals.push(cur_pos)
  				@_info.goals_cnt++    

  			@_info.box_on_goal_cnt++  if cell is GameSokoban.BOX_ON_GOAL
  			pos_col++
  		pos_row++
  			  
  level_size: -> @_level_size

  level_valid: ->
  	@_info.sokoban_cnt == 1 and @_info.box_cnt > 0 and @_info.goals_cnt == @_info.box_cnt

  get_cell_at: (pos) ->
    return GameSokoban.WALL if @is_wall_at_pos(pos)

    if @is_sokoban_at_pos(pos)
      return GameSokoban.SOKOBAN_ON_GOAL if @is_goal_at_pos(pos)
      return GameSokoban.SOKOBAN

    if @is_box_at_pos(pos)
      return GameSokoban.BOX_ON_GOAL if @is_goal_at_pos(pos)
      return GameSokoban.BOX

    return GameSokoban.GOAL if @is_goal_at_pos(pos)
    GameSokoban.FREE

  get_level: ->
  	@refresh_cells()
  	@cells2ascii()

  sokoban_pos: -> @_sokoban_pos

  valid_direction: (direction) ->
  	d_keys = []
  	for d_key, d of GameSokoban.DIRECTIONS
  		d_keys.push d_key
  	return direction in d_keys

  sokoban_move: (direction) ->
    return unless @valid_direction(direction)
    new_pos = @_new_pos_by_direction(@_sokoban_pos, direction)
    element_at_pos = @element_at_pos(new_pos)
    if element_at_pos in [GameSokoban.FREE, GameSokoban.GOAL]
      @_sokoban_pos = new_pos
    if element_at_pos == GameSokoban.BOX
      if @is_box_movable(new_pos, direction)
        @move_box(new_pos, direction)
        @_sokoban_pos = new_pos
    
  	
  is_box_movable: (pos, direction) ->
    element_at_pos = @element_at_pos @_new_pos_by_direction(pos, direction)
    return true if element_at_pos in [GameSokoban.FREE, GameSokoban.GOAL]
    false

  move_box: (pos, direction) ->
    box = @get_box_at(pos)
    vector = GameSokoban.DIRECTIONS[direction]
    for k, d of vector
      box[k] += d

  get_box_at: (pos) ->
    for box_pos in @_boxes
      return box_pos if @_is_pos_eq(box_pos,  pos)
    

  boxes: -> @_boxes

  # inner arrays to cells
  refresh_cells: ->
    new_cells = []
    for row_pos in [0..@_level_size.max_row]
      new_cells[row_pos] = []
      for col_pos in [0..@_level_size.max_col]
        cur_pos = {col: col_pos, row: row_pos}
        cell = @get_cell_at(cur_pos)
        new_cells[row_pos][col_pos] = cell
    @level_cells = new_cells


  _clone_pos: (pos) ->
  	{col: pos.col, row: pos.row}

  _new_pos_by_direction: (pos, direction) ->
  	_pos = @_clone_pos(pos)
  	delta = GameSokoban.DIRECTIONS[direction]
  	for k, v of delta
  	  _pos[k] += v
  	_pos


  cells2ascii: ->
  	rows = []
  	for row in @level_cells
  		rows.push row.join('')
  	rows.join("\n")

  is_wall_at_pos: (pos) ->
  	@_is_pos_in_array @_walls, pos

  is_sokoban_at_pos: (pos) ->
  	@_is_pos_eq(pos, @_sokoban_pos)

  is_box_at_pos: (pos) ->
  	@_is_pos_in_array @_boxes, pos

  is_goal_at_pos: (pos) ->
  	@_is_pos_in_array @_goals, pos

  _is_pos_eq: (pos1, pos2) ->
    pos1.col == pos2.col and pos1.row == pos2.row

  _is_pos_in_array: (arr, pos) ->
  	for _pos in arr
  		return true if @_is_pos_eq pos, _pos
  	false



root = exports ? this
root.GameSokoban = GameSokoban