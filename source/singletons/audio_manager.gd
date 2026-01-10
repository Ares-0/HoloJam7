extends Node

# Autoload singelton that plays the music and sound effects of the game

var current_ost: NodePath
var ost_on: bool = false

func _ready() -> void:
	#print("audio ready")
	pass
	soundtrack_start()

func _process(_delta: float) -> void:
	pass
	#if Input.is_action_just_pressed("debug_0"):
		#play("TestBeep")
	if Input.is_action_just_pressed("toggle_music"):
		toggle_music()

func toggle_music() -> void:
	if ost_on:
		soundtrack_stop()
	else:
		soundtrack_start()

func soundtrack_start() -> void:
	current_ost = "Music1"
	#play(current_ost)
	var sound_node: AudioStreamPlayer2D = get_node_or_null(current_ost)
	if sound_node.stream_paused:
		sound_node.stream_paused = false
	else:
		sound_node.play()
	ost_on = true

func soundtrack_stop() -> void:
	#stop(current_ost)
	var sound_node: AudioStreamPlayer2D = get_node_or_null(current_ost)
	sound_node.stream_paused = true
	ost_on = false

func play(sound: NodePath):
	# sound is the name of the node of the sound to play
	# sound is case sensitive
	var sound_node: AudioStreamPlayer2D = get_node_or_null(sound)
	assert(sound_node != null, str("Sound ", sound, " does not exist"))
	sound_node.play()

func stop(sound: NodePath):
	var sound_node: AudioStreamPlayer2D = get_node_or_null(sound)
	assert(sound_node != null, str("Sound ", sound, " does not exist"))
	sound_node.stop()

func play_random_tap_sound() -> void:
	var options: Array[String] = ["Sizzle", "Chop"]
	play(options.pick_random())

func play_random_bell_sound() -> void:
	var options: Array[String] = ["BellDone", "BellDoneMid", "BellDoneShort"]
	play(options.pick_random())
