class_name TutorialPopup
extends Control

const NUM_PAGES: int = 5

var current_page: int = 0

@onready var page0: Control = %"Page 0"
@onready var page1: Control = %"Page 1"
@onready var page2: Control = %"Page 2"
@onready var page3: Control = %"Page 3"
@onready var page4: Control = %"Page 4"
@onready var pages: Array[Control] = [page0, page1, page2, page3, page4]

func _ready() -> void:
	$Ref.hide()
	self.hide()
	self.set_page(0)
	await get_tree().create_timer(1.2).timeout
	self.show()

func hide_all_pages() -> void:
	for item in pages:
		item.visible = false

func set_page(num: int) -> void:
	hide_all_pages()
	pages[num].visible = true

	%"Prev Button".disabled = (num == 0)
	%"Next Button".disabled = (num == NUM_PAGES-1)
	
	if num == NUM_PAGES - 1:
		%SkipLabel.text = "Done"
	else:
		%SkipLabel.text = "Skip"

func _on_next_button_mouse_entered() -> void:
	pass
	#AudioManager.play("UIHoverC")

func _on_next_button_pressed() -> void:
	if current_page < NUM_PAGES - 1:
		AudioManager.play("UIHoverA")
		current_page = current_page + 1
	set_page(current_page)

func _on_skip_button_mouse_entered() -> void:
	pass
	#AudioManager.play("UIHoverC")

func _on_skip_button_pressed() -> void:
	AudioManager.play("UIHoverA")
	self.hide()

func _on_prev_button_pressed() -> void:
	if current_page > 0:
		AudioManager.play("UIHoverA")
		current_page = current_page - 1
	set_page(current_page)
