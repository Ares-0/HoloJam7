extends CanvasLayer

# Dialog / text box that displays lines of text
# Based on undertale tutorial, can update each visual element as need be

# todo: multiple speeds
const CHAR_READ_RATE = 0.05

@onready var start_symbol: Label = %Start
@onready var end_symbol: Label = %End
@onready var text_label: Label = %Text

enum State {
	READY,
	STEPPING,
	FINISHED
}

var current_state: int = State.READY
var tween: Tween
var text_queue: Array[String] = []

func _ready() -> void:
	SignalBus.queue_textbox.connect(queue_text) # likely replacing with separate function later
	hide_dialog_box()
	change_state(State.READY)

	#queue_text("This is some text to be added")
	#queue_text("Line number 2")
	#queue_text("Line number 3")
	#queue_text("Line number 4")

func _process(_delta: float) -> void:
	match current_state:
		State.READY:
			if not text_queue.is_empty():
				display_text()
		State.STEPPING:
			if Input.is_action_just_pressed("ui_accept"):
				text_label.visible_ratio = 1.0
				if tween:
					tween.kill()
				_on_tween_finished()
		State.FINISHED:
			if Input.is_action_just_pressed("ui_accept"):
				change_state(State.READY)
				hide_dialog_box()

func queue_text(next_text: String) -> void:
	text_queue.push_back(next_text)

func hide_dialog_box() -> void:
	self.hide()
	start_symbol.modulate = Color.TRANSPARENT
	end_symbol.modulate = Color.TRANSPARENT
	text_label.text = ""

func show_dialog_box() -> void:
	self.show()
	start_symbol.modulate = Color.WHITE
	end_symbol.modulate = Color.WHITE

func display_text() -> void:
	var next_text = text_queue.pop_front()
	text_label.text = next_text
	change_state(State.STEPPING)
	show_dialog_box()
	end_symbol.modulate = Color.TRANSPARENT

	# step characters
	text_label.visible_ratio = 0.0
	tween = get_tree().create_tween()
	tween.finished.connect(_on_tween_finished)
	tween.tween_property(text_label, "visible_ratio", 1.0, len(next_text) * CHAR_READ_RATE)

func change_state(next_state) -> void:
	current_state = next_state
	match current_state:
		State.READY:
			pass
			print("Changing state to: READY")
		State.STEPPING:
			pass
			print("Changing state to: STEPPING")
		State.FINISHED:
			pass
			print("Changing state to: FINISHED")

func _on_tween_finished() -> void:
	end_symbol.modulate = Color.WHITE
	change_state(State.FINISHED)
