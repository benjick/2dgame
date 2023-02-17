extends CharacterBody2D

const JUMP_VELOCITY = -400.0
const DAMAGE = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 250
var speed = 300

func _enter_tree():
	velocity.y = -randi_range(0, 150)
	speed = randi_range(200, 400)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.x = -1 * speed

	move_and_slide()


func _on_area_2d_body_entered(body):
	if body.has_method("hit"):
		var direction = sign(velocity.x)
		body.hit(DAMAGE, direction)
		queue_free()
