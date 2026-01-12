extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	on_enter_scene()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass 

func on_enter_scene():
	# if coming from game scene, start menu music
	# Actually, always just keep the music from previous scene
	#if Global.previous_scene == "res://source/settings/dev_room_1.tscn":
		#AudioManager.set_soundtrack("BgmMenu")
		#await get_tree().create_timer(1.0).timeout
		#AudioManager.soundtrack_start()

	if (Global.game_finished):
		Global.deck = Global.default_deck 
		Global.save_data() 
		Global.game_finished = false
	else:
		return

func on_main_menu_pressed(): 
	Global.previous_scene = get_tree().current_scene.scene_file_path
	if AudioManager.current_ost != NodePath("BgmMenu"):
		AudioManager.soundtrack_fade_out(0.5)
	get_tree().change_scene_to_file("res://source/gui/menus/title_screen.tscn")
