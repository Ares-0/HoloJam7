extends Node

# Autoload singleton that plays the music and sound effects of the game

const PAUSE_ADJUST: float = 10.0

var current_ost: NodePath
var ost_on: bool = false
var ost_tween: Tween

func _ready() -> void:
	#print("audio ready")
	pass
	#soundtrack_start()

func _process(_delta: float) -> void:
	pass
	# if Input.is_action_just_pressed("debug_0"):
		#play("TestBeep")
		# soundtrack_fade_in()
	if Input.is_action_just_pressed("toggle_music"):
		toggle_music()

func toggle_music() -> void:
	if ost_on:
		soundtrack_pause()
	else:
		soundtrack_unpause()

func set_soundtrack(track: NodePath) -> void:
	current_ost = track

func soundtrack_start() -> void:
	# starts / restarts soundtrack
	print("starting ", current_ost)
	var sound_node: AudioStreamPlayer2D = get_node_or_null(current_ost)
	if sound_node == null:
		return

	sound_node.stream_paused = false
	sound_node.play()
	ost_on = true

func soundtrack_pause() -> void:
	print("pausing ", current_ost)
	var sound_node: AudioStreamPlayer2D = get_node_or_null(current_ost)
	assert(sound_node != null, str("Sound ", current_ost, " does not exist"))

	sound_node.stream_paused = true
	ost_on = false

func soundtrack_unpause() -> void:
	print("unpausing ", current_ost)
	var sound_node: AudioStreamPlayer2D = get_node_or_null(current_ost)
	assert(sound_node != null, str("Sound ", current_ost, " does not exist"))

	sound_node.stream_paused = false
	ost_on = true

func soundtrack_fade_out(fade_length: float = 3.0) -> void:
	print("fade out ", current_ost)
	# Fade the music out, then pause
	# Remember the old volume so that it can be restored
	var sound_node: AudioStreamPlayer2D = get_node_or_null(current_ost)
	assert(sound_node != null, str("Sound ", current_ost, " does not exist"))

	var base_volume = sound_node.volume_db
	ost_tween = get_tree().create_tween()
	ost_tween.tween_property(sound_node, "volume_db", -100, fade_length)
	ost_on = false
	await ost_tween.finished
	sound_node.stream_paused = true
	sound_node.volume_db = base_volume

func soundtrack_fade_in(fade_length: float = 3.0) -> void:
	print("fade in ", current_ost)
	var sound_node: AudioStreamPlayer2D = get_node_or_null(current_ost)
	assert(sound_node != null, str("Sound ", current_ost, " does not exist"))

	var target_volume = sound_node.volume_db
	sound_node.volume_db = -50
	await get_tree().create_timer(0.1).timeout # avoid click
	soundtrack_start()
	ost_tween = get_tree().create_tween()
	ost_tween.tween_property(sound_node, "volume_db", target_volume, fade_length)

func soundtrack_reduce(fade_length: float = 3.0) -> void:
	# Like fade but not all the way and doesn't stop it
	# careful because volume gets lost
	print("reduce ", current_ost)
	var sound_node: AudioStreamPlayer2D = get_node_or_null(current_ost)
	assert(sound_node != null, str("Sound ", current_ost, " does not exist"))

	#last_volume = sound_node.volume_db
	sound_node.volume_db = sound_node.volume_db - PAUSE_ADJUST

func soundtrack_raise(fade_length: float = 3.0) -> void:
	# Like fade but not all the way and doesn't stop it
	print("raise ", current_ost)
	var sound_node: AudioStreamPlayer2D = get_node_or_null(current_ost)
	assert(sound_node != null, str("Sound ", current_ost, " does not exist"))

	ost_tween = get_tree().create_tween()
	ost_tween.tween_property(sound_node, "volume_db", sound_node.volume_db + PAUSE_ADJUST, fade_length)
	#sound_node.volume_db = sound_node.volume_db + PAUSE_ADJUST

func play(sound: NodePath):
	# sound is the name of the node of the sound to play
	# sound is case sensitive
	var sound_node: AudioStreamPlayer2D = get_node_or_null(sound)
	assert(sound_node != null, str("Sound ", sound, " does not exist"))
	sound_node.play()

func try_start(sound: NodePath):
	# Like play but does nothing if the sound is already playing
	var sound_node: AudioStreamPlayer2D = get_node_or_null(sound)
	assert(sound_node != null, str("Sound ", sound, " does not exist"))
	if not sound_node.is_playing():
		sound_node.play()

func stop(sound: NodePath):
	var sound_node: AudioStreamPlayer2D = get_node_or_null(sound)
	assert(sound_node != null, str("Sound ", sound, " does not exist"))
	sound_node.stop()

func play_random_tap_sound() -> void:
	var options: Array[String] = ["Sizzle", "Chop"]
	play(options.pick_random())

func play_random_bell_sound() -> void:
	var options: Array[String] = ["BellDone", "BellDoneMid"]
	play(options.pick_random())
