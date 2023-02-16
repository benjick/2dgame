extends CharacterBody2D

const base_max_speed : int = 200
const gravity : float = 35
const jump_force : int = 500
const acceleration : int = 50
const jump_buffer_time : int  = 15
const cayote_time : int = 15

var jump_counter : int = 0
var jump_buffer_counter : int = 0
var cayote_counter : int = 0

var max_fall_speed := 2000

@onready var coyote_timer = $CoyoteTimer
@onready var hang_timer = $HangTimer
@onready var hang_jump_timer = $HangJumpTimer
@onready var sprite = $Rotatable/Sprite
@onready var raycast := $Rotatable/RayCast2D

var last_wall_direction = 0

var score := 0

func _physics_process(delta):
	if !sprite.is_playing():
		sprite.play("Idle")
		
	var max_speed = base_max_speed if not Input.is_action_pressed("Run") else base_max_speed * 2
	var signed_direction = sign(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))

	if is_on_floor():
		cayote_counter = cayote_time
		jump_counter = 0
		last_wall_direction = 0

	if not is_on_floor():
		if cayote_counter > 0:
			cayote_counter -= 1
			
		if jump_buffer_counter > 0 :
			if raycast.is_colliding():
				if raycast.get_collider().name == "TileMap":
					# Only one jump on the same side
					if signed_direction != last_wall_direction:
						cayote_counter = 1
						velocity.x += 500 * signed_direction * -1
						last_wall_direction = signed_direction
			elif jump_counter < 1:
				jump_counter += 1
				cayote_counter = 1
		
		velocity.y += gravity
		if raycast.is_colliding():
			if raycast.get_collider().name == "TileMap":
				max_fall_speed = 200
		else:
			max_fall_speed = 2000
		velocity.y = min(velocity.y, max_fall_speed)

	if (signed_direction):
		$Rotatable.scale.x = signed_direction
		velocity.x += acceleration * signed_direction
		sprite.play("Run")


	else:
		velocity.x = lerpf(velocity.x, 0, 0.2)
		sprite.play("Idle")
	
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	
	if velocity.y < 0:
		sprite.play("Jump")
	if velocity.y > 0:
		sprite.play("Fall")
	
	if Input.is_action_just_pressed("ui_select") || Input.is_action_just_pressed("ui_up"):
		jump_buffer_counter = jump_buffer_time
	
	if jump_buffer_counter > 0:
		jump_buffer_counter -= 1
	
	if jump_buffer_counter > 0 and cayote_counter > 0:
		velocity.y = -jump_force
		jump_buffer_counter = 0
		cayote_counter = 0
	
	if Input.is_action_just_released("ui_select"):
		if velocity.y < 0:
			velocity.y += 200
	
	move_and_slide()

func pick_up(body: StaticBody2D):
	score += 1
	print("score: ", score)
