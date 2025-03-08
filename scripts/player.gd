extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -3000
const FULL_VELOCITY = 5000
const GRAVITY = 6000
const GRAVITY_DIAGONAL = 3000 * 14
const MOVE_VELOCITY = 2700
const JUMP_VELO_DIAGONAL = MOVE_VELOCITY * -2.3
const MINIMUM_DRAG = 40
const THRESHOLD = 20.8

var is_superior_diagonal = false
var is_inferior_diagonal = false
var swipe_started = false
var swipe_start_pos = Vector2()
var swipe_cursor_pos = Vector2()
var direction

var can_move = true
var SPACE_ACTIONS

func _ready() -> void:
	print(DisplayServer.screen_get_size())

func get_gravit(velocity: Vector2):
	if velocity.y < 0 and not is_superior_diagonal:
		return GRAVITY
	if velocity.y < 0 and is_superior_diagonal:
		return GRAVITY_DIAGONAL
	if not is_superior_diagonal:
		return FULL_VELOCITY
	if is_superior_diagonal:
		return FULL_VELOCITY * 8

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += get_gravit(velocity) * delta
		print(get_gravit(velocity))
		
	if Input.is_action_just_released("LMB") :
		if velocity.y < 0:
			velocity.y = JUMP_VELOCITY / 5
		direction = 0
		is_superior_diagonal = false
		can_move = true
		
	# Handle jump.
	if Input.is_action_just_pressed("LMB"):
		#if get_global_mouse_position().x <= SPACE_ACTIONS.x / 2 + 400:
		swipe_start_pos = get_global_mouse_position()
		if !swipe_started:
			swipe_started = true
		#if get_global_mouse_position().x >= SPACE_ACTIONS.x / 2 + 400 and is_on_floor():
			
	
	if Input.is_action_pressed("LMB"):
		if swipe_started:
			swipe_cursor_pos = get_global_mouse_position()
			if swipe_start_pos.distance_to(swipe_cursor_pos) >= MINIMUM_DRAG:
				if abs(swipe_start_pos.y - swipe_cursor_pos.y) <= THRESHOLD:#Range 40
					print(swipe_start_pos.y - swipe_cursor_pos.y)
					print("X: ", swipe_start_pos.x - swipe_cursor_pos.x)
					print("horizontal")
					if swipe_start_pos.x - swipe_cursor_pos.x < 0:
						print("right")
						direction = 1
						
					elif swipe_start_pos.x - swipe_cursor_pos.x > 0:
						print("left")
						direction = -1
					swipe_started = false
				elif abs(swipe_start_pos.x - swipe_cursor_pos.x) <= THRESHOLD: #Range 20
					print(swipe_start_pos.x - swipe_cursor_pos.x)
					print("Y: ", swipe_start_pos.y - swipe_cursor_pos.y)
					print("vertical")
					if swipe_start_pos.y - swipe_cursor_pos.y > 0 and is_on_floor():
						print("up")
						velocity.y = JUMP_VELOCITY
					elif swipe_start_pos.y - swipe_cursor_pos.y < 0 and not is_on_floor():
						print("down")
						velocity.y = FULL_VELOCITY * 3
					swipe_started = false
				elif abs(swipe_start_pos.x - swipe_cursor_pos.x) > THRESHOLD and abs(swipe_start_pos.y - swipe_cursor_pos.y) > THRESHOLD and is_on_floor():
					if swipe_start_pos.y - swipe_cursor_pos.y > 0 and swipe_start_pos.x - swipe_cursor_pos.x > 0:
						print("superior diagonal left")
						velocity.y = JUMP_VELO_DIAGONAL
						direction = -1
						is_superior_diagonal = true
					elif swipe_start_pos.y - swipe_cursor_pos.y > 0 and swipe_start_pos.x - swipe_cursor_pos.x < 0:
						print("superior diagonal right")
						velocity.y = JUMP_VELO_DIAGONAL
						direction = 1
						is_superior_diagonal = true
					elif swipe_start_pos.y - swipe_cursor_pos.y < 0 and swipe_start_pos.x - swipe_cursor_pos.x < 0:
						print("inferior diagonal right")
					elif swipe_start_pos.y - swipe_cursor_pos.y < 0 and swipe_start_pos.x - swipe_cursor_pos.x > 0:
						print("inferior diagonal left")
					swipe_started = false
	else:
		swipe_started = false
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = JUMP_VELOCITY
		
	if direction and can_move:
		velocity.x = MOVE_VELOCITY * direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	if is_superior_diagonal and is_on_floor():
		can_move = false
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	
func _process(delta: float) -> void:
	position = position.clamp(Vector2.ZERO, get_viewport_rect().size)
	SPACE_ACTIONS = DisplayServer.screen_get_size()
