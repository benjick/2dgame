@tool
extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -400.0

@onready var box_thrower = $".."
@onready var static_box = $"../StaticBoxBody/StaticBox"
@onready var dialogue = $Dialogue
@onready var sprite = $Sprite
@onready var sound_death = $"../SoundDeath"

var pig_alive := true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var has_box := true
var start_position: Vector2 = Vector2()
var box_position: Vector2 = Vector2()
var getting_box := false
var picking_up_box := false
var throwing_box := false
var in_area := false

func _ready():
	start_position = self.position
	box_position = static_box.position
	dialogue.visible = false
		

func _physics_process(delta):
	if !pig_alive:
		return
		
	if !has_box:
		if position.x == box_position.x:
				if !picking_up_box:
					pickUpBox(delta)
		else:
			sprite.play("Run no box")
			sprite.scale.x = -1
			position.x = move_toward(position.x, box_position.x, SPEED * delta)
		pass
	else:
		if position.x == start_position.x:
			if in_area:
				throwBox()
			else:
				sprite.play("Idle")
		else:
			sprite.play("Run")
			sprite.scale.x = 1
			position.x = move_toward(position.x, start_position.x, SPEED * delta)

	move_and_slide()
	
func throwBox():
	if !throwing_box:
		throwing_box = true
		sprite.play("Throwing Box")
		await get_tree().create_timer(0.3).timeout
		spawnThrowableBox()
		await get_tree().create_timer(1).timeout
		has_box = false
		throwing_box = false

func spawnThrowableBox():
	var throwable_box_scene = load("res://scenes/ThrowableBox.tscn")	
	var instance = throwable_box_scene.instantiate()
	get_parent().add_child(instance)


func pickUpBox(delta):
	picking_up_box = true
	sprite.play("Picking Box")
	await sprite.animation_finished
	sprite.play("Idle")
	has_box = true
	getting_box = false
	picking_up_box = false
	

func showDialogue():
	dialogue.visible = true
	dialogue.play("#!?")
	await dialogue.animation_finished
	dialogue.visible = false

func _on_area_2d_body_entered(body):
	if body.has_method("hit"):
		in_area = true
		showDialogue()

func _on_area_2d_body_exited(body):
	if body.has_method("hit"):
		in_area = false

func _on_hit_area_2d_body_entered(body):
	if pig_alive:
		if body.has_method("hit"):
			pigAlive(false)
			body.jump()
	
func pigAlive(alive: bool):
	pig_alive = alive
	if alive == false:
		$BodyCollision.queue_free()
		if has_box:
			spawnThrowableBox()
		sprite.play("Dead")
		sound_death.play()
		await sprite.animation_finished
		self.queue_free()
