extends Control

@onready var king = $Sprites/King
@onready var pig = $Sprites/Pig

# Called when the node enters the scene tree for the first time.
func _ready():
	king.play("Idle")
	pig.play("Idle")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_start_pressed():
	get_tree().change_scene_to_file("res://Level1.tscn")
