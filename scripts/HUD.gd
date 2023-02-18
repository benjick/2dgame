extends CanvasLayer

@onready var pause_panel = $PausePanel

@onready var time_label = $TimePanel/TimeLabel
@onready var score_label = $ScorePanel/ScoreLabel

@onready var sound_pause = $SoundPause
@onready var sound_unpause = $SoundUnpause

var paused := false
var time_passed_seconds : float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = true
	pause_panel.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Pause"):
		toggle_pause()

func _on_player_score_updated(score):
	score_label.text = str(score)

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

func time_convert(time_in_sec):
	var seconds = time_in_sec%60
	var minutes = (time_in_sec/60)%60
	var hours = (time_in_sec/60)/60

	return "%02d:%02d:%02d" % [hours, minutes, seconds]

func _on_button_pressed():
	toggle_pause()


func _on_player_time_passed_updated(seconds):
	time_passed_seconds = seconds
	time_label.text = time_convert(int(seconds))
