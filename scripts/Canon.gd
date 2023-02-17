extends Node2D

@onready var timer = $Timer
@onready var cannon = $CannonBody/Cannon
@onready var cannon_pig = $PigBody/CannonPig

@export var balls := 1
@export var pig_alive := true

var one_shot := true

func _ready():
	cannon_pig.play("Pig Idle")
	shoot()
	pass

func _on_timer_timeout():
	shoot()
	pass # Replace with function body.

func shoot():
	if !pig_alive: return # There must be a better way of doing this
	
	cannon_pig.play("Lighting the Match")
	await cannon_pig.animation_finished
	if !pig_alive: return
	
	cannon_pig.play("Match On")
	await cannon_pig.animation_finished
	if !pig_alive: return
	
	cannon_pig.play("Lighting the Cannon")
	await cannon_pig.animation_finished
	if !pig_alive: return
	
	cannon.play("Shoot")
	spawnCannonBall()
	await cannon.animation_finished
	cannon.play("Idle")
	cannon_pig.play("Pig Idle")

func spawnCannonBall():
	var cannon_ball_scene = load("res://scenes/CannonBall.tscn")
	for n in range(balls):
		var instance = cannon_ball_scene.instantiate()
		add_child(instance)

func _on_area_2d_body_entered(body):
	if pig_alive:
		if body.has_method("hit"):
			pigAlive(false)
			body.jump()

func pigAlive(alive: bool):
	pig_alive = alive
	if alive == false:
		$PigBody/Area2D.queue_free()
		$PigBody/PigCollision.queue_free()
		cannon_pig.play("Dead")
		await cannon_pig.animation_finished
		$PigBody.queue_free()
