extends KinematicBody2D

export(int) var ACCELERATION = 512
export(int) var MAX_SPEED = 64
export(float) var FRICTION = 0.25
export(int) var GRAVITY = 200
export(int) var JUMP_FORCE = 128
export(int) var MAX_SLOPE_ANGLE = 46

var motion = Vector2.ZERO

func _physics_process(delta):
	var input_vector = get_input_vector()
	apply_horizontal_motion(input_vector, delta)
	jump_check()
	apply_gravity(delta)
	motion = move_and_slide(motion, Vector2.UP)

func get_input_vector():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	return input_vector

func apply_horizontal_motion(input_vector, delta):
	if input_vector.x != 0:
		motion.x += input_vector.x * ACCELERATION * delta
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
	else:
		apply_friction()

func apply_friction():
	motion.x = lerp(motion.x, 0, FRICTION)

func apply_gravity(delta):
	motion.y += GRAVITY * delta
	motion.y = min(motion.y, JUMP_FORCE)

func jump_check():
	if is_on_floor() && Input.is_action_just_pressed("jump"):
		motion.y = -JUMP_FORCE
	elif Input.is_action_just_released("jump") && motion.y < -JUMP_FORCE / 2:
		motion.y = -JUMP_FORCE / 2
	
