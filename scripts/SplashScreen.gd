extends Control

@onready var animated_sprite_2d = $Node2D/AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite_2d.play("Idle")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_start_pressed():
	get_tree().change_scene_to_file("res://Level1.tscn")