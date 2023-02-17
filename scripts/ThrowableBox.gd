extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DAMAGE = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 250

func _enter_tree():
	velocity.x = -150 * self.scale.x

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.x = lerpf(velocity.x, 0, 0.1)

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	move_and_slide()

func flip():
	self.scale.x = -1 if self.scale.x == 1 else 1

func _on_area_2d_body_entered(body):
	if body.has_method("hit"):
		var direction = sign(velocity.x)
		body.hit(DAMAGE, direction)
		animated_sprite_2d.play("Hit")
		gravity = 0
		await animated_sprite_2d.animation_finished
		queue_free()
