extends CharacterBody2D

const base_max_speed : int = 200
const gravity : float = 35
const jump_force : int = 500
const acceleration : int = 50
const jump_buffer_time : int  = 15
const cayote_time : int = 15
const hit_force := 300

var jump_counter : int = 0
var jump_buffer_counter : int = 0
var cayote_counter : int = 0

var max_fall_speed := 2000

@onready var coyote_timer = $CoyoteTimer
@onready var hang_timer = $HangTimer
@onready var hang_jump_timer = $HangJumpTimer
@onready var sprite = $Rotatable/Sprite
@onready var raycast := $Rotatable/RayCast2D

@onready var heart_1 = $Hearts/Heart1
@onready var heart_2 = $Hearts/Heart2
@onready var heart_3 = $Hearts/Heart3

signal score_updated(score: int)

var last_wall_direction = 0

var score := 0
var life := 3
var start_position: Vector2 = Vector2()
var time_passed_seconds : float = 0
var finished := false
var finished_position := Vector2()

func _ready():
	start_position = self.position
	setLives(life)

func _physics_process(delta):
	if finished:
		velocity.y += gravity
		velocity.x = 0
		self.position.x = move_toward(self.position.x, finished_position.x, delta * base_max_speed / 2)
		self.modulate.a = move_toward(self.modulate.a, 0, delta)
		if self.position.x == finished_position.x:
			sprite.play("Idle")
		else:
			sprite.play("Running")
		move_and_slide()
		return

	if life < 1:
		velocity.y += gravity
		move_and_slide()
		return
	
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
		
	if !$HitTimer.is_stopped():
		sprite.play("Hit")
	
	if Input.is_action_just_pressed("ui_select") || Input.is_action_just_pressed("ui_up"):
		jump_buffer_counter = jump_buffer_time
	
	if jump_buffer_counter > 0:
		jump_buffer_counter -= 1
	
	if jump_buffer_counter > 0 and cayote_counter > 0:
		jump()
	
	if Input.is_action_just_released("ui_select"):
		if velocity.y < 0:
			velocity.y += 200
	
	move_and_slide()
	
func jump():
	velocity.y = -jump_force
	jump_buffer_counter = 0
	cayote_counter = 0

func pick_up(_body: StaticBody2D):
	score += 1
	emit_signal("score_updated", score)
	
func setLives(lives: int):
	if lives >= 1:
		heart_1.play("Small Heart")
		heart_1.visible = true
	elif heart_1.visible == true:
		heart_1.play("Hit")
		await heart_1.animation_finished
		heart_1.visible = false
		
	if lives >= 2:
		heart_2.play("Small Heart")
		heart_2.visible = true
	elif heart_2.visible == true:
		heart_2.play("Hit")
		await heart_2.animation_finished
		heart_2.visible = false
		
	if lives >= 3:
		heart_3.play("Small Heart")
		heart_3.visible = true
	elif heart_3.visible == true:
		heart_3.play("Hit")
		await heart_3.animation_finished
		heart_3.visible = false
	

func hit(damage: int, direction: int):
	if $HitTimer.is_stopped():
		life -= damage
		life = max(life, 0)
		setLives(life)
		if life < 1:
			die()
		else:
			velocity.x = direction * hit_force
			$HitTimer.start()
		print("Damage: ", damage)

func die():
	print("dead")
	sprite.play("Dead")
	await get_tree().create_timer(2).timeout
	self.position = start_position
	life = 3
	setLives(3)

func finish(body: StaticBody2D, door_sprite: AnimatedSprite2D):
	get_tree().call_group("mobs", "queue_free")
	finished = true
	finished_position = body.position
	door_sprite.play("Opening")
	await get_tree().create_timer(1).timeout
	print("ok")
	# fade out
	door_sprite.play("Closing")
	await get_tree().create_timer(1).timeout
	var next_scene = str("res://", body.next_scene, ".tscn")
	get_tree().change_scene_to_file(next_scene)
