extends CanvasLayer

@onready var pause_panel = $PausePanel
@onready var sound_pause = $SoundPause
@onready var sound_unpause = $SoundUnpause

var paused := false

# Called when the node enters the scene tree for the first time.
func _ready():
	pause_panel.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Pause"):
		toggle_pause()

func _on_player_score_updated(score):
	print("Score: ", score)
	$ScorePanel/ScoreLabel.text = str(score)

func toggle_pause():
	if paused:
		paused = false
		pause_panel.visible = false
		get_tree().paused = false
		sound_unpause.play()
	else:
		paused = true
		pause_panel.visible = true
		get_tree().paused = true
		sound_pause.play()


func _on_button_pressed():
	toggle_pause()
