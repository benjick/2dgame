extends CharacterBody2D

@onready var dialogue = $Dialogue

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	dialogue.visible = false
	if self.scale.x == -1:
		dialogue.scale.x = -1

func _physics_process(delta):

	move_and_slide()


func _on_area_2d_body_entered(body):
	if body.has_method("hit"):
		dialogue.visible = true
		dialogue.play("Hello")
		await dialogue.animation_finished
		dialogue.visible = false
	pass # Replace with function body.
