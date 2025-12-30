class_name PauseMenu
extends Control

var paused: bool = false

@onready var resume_button: Button = %ResumeB
@onready var pause_menu_ui = %PauseUI
#@onready var options_ui = %OptionsMenu

const pause_ui_pos_off = Vector2(0, -300)
const pause_ui_pos_on = Vector2.ZERO

func _ready() -> void:
	pause_menu_ui.position = pause_ui_pos_off
	paused = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if paused:
			unpause()
		else:
			pause()

func pause() -> void:
	paused = true
	get_tree().paused = true
	resume_button.grab_focus()
	self.show()

	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(pause_menu_ui, "position:y", pause_ui_pos_on.y, 0.1)

func unpause() -> void:
	pause_menu_ui.visible = true
	# options menu .visible = false
	paused = false
	get_tree().paused = false

	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(pause_menu_ui, "position:y", pause_ui_pos_off.y, 0.1)
	await get_tree().create_timer(0.1).timeout

	self.hide()

func _on_resume_b_pressed() -> void:
	unpause()

func _on_options_b_pressed() -> void:
	pass

func _on_menu_b_pressed() -> void:
	paused = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://source/gui/title_screen.tscn")
