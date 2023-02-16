extends StaticBody2D

@onready var diamond_sprite = $DiamondSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_diamond_area_body_entered(body):
	print(body)
	if body.has_method("pick_up"):
		body.pick_up(self)
		diamond_sprite.position.y += -22
		diamond_sprite.play("Big Diamond Collected")
		await diamond_sprite.animation_finished
		queue_free()
