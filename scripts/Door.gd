extends StaticBody2D

@onready var sprite = $AnimatedSprite2D

@export var next_scene = "TestLevel"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body.has_method("finish"):
		body.finish(self, sprite)
