extends StaticBody2D

@onready var diamond_sprite = $DiamondSprite

var picked_up := false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_diamond_area_body_entered(body):
	if !picked_up:
		if body.has_method("pick_up"):
			picked_up = true
			body.pick_up(self)
			diamond_sprite.position.y += -22
			diamond_sprite.play("Big Diamond Collected")
			await diamond_sprite.animation_finished
			queue_free()
