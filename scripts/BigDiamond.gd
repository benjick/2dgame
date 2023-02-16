extends StaticBody2D


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
		queue_free()
