extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DAMAGE = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 250

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	move_and_slide()



func _on_area_2d_body_entered(body):
	if body.has_method("hit"):
		var direction = sign(velocity.x)
		print("direction", direction)
		body.hit(DAMAGE, direction)
		animated_sprite_2d.play("Hit")
		gravity = 0
		await animated_sprite_2d.animation_finished
		queue_free()
