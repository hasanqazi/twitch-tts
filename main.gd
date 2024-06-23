extends Control

@onready var gift = %Gift
@onready var tts_volume_slider: HSlider = %Volume
@onready var tts_status: Label = %Status
@onready var tts_voice: OptionButton = $OptionButton

var voices = DisplayServer.tts_get_voices_for_language("en")

var voice_id = voices[0]

var paused: bool = false

@onready var tts_volume: int = tts_volume_slider.value

var tts_queue = []

func _ready():
	gift.command_check.connect(_on_command_check)
	
	tts_voice.add_item("David")
	tts_voice.add_item("Zira")
	print(voices)

func _process(delta):
	if not DisplayServer.tts_is_speaking() and tts_queue.size() > 0 and not paused:
		play_next_tts()

func _on_command_check(msg) -> void:
	var prefix = msg.split(" ")[0].to_lower()
	var message = msg.trim_prefix(prefix).strip_edges()
	
	var filtered_message = Filter.filter_words(message)
	
	match prefix:
		"!tts":
			tts_queue.append(filtered_message)
		_:
			pass

func play_next_tts() -> void:
	if tts_queue.size() > 0:
		var tts_message = tts_queue.pop_front()
		DisplayServer.tts_speak(tts_message, voice_id, tts_volume)

func _on_volume_value_changed(value):
	tts_volume = value


func _on_pause_pressed():
	DisplayServer.tts_pause()
	paused = true
	tts_status.text = "Paused"


func _on_resume_pressed():
	DisplayServer.tts_resume()
	paused = false
	tts_status.text = "Playing"


func _on_stop_pressed():
	DisplayServer.tts_stop()
	tts_status.text = "Skipped"


func _on_option_button_item_selected(index):
	print(index)
	if (index == 0):
		voice_id = voices[0]
	if (index == 1):
		voice_id = voices[1]
