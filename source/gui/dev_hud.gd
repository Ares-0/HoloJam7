class_name DevHUD
extends Control

@onready var reqA_label: Label = %ReqA
@onready var reqB_label: Label = %ReqB
@onready var reqC_label: Label = %ReqC
@onready var reqD_label: Label = %ReqD

func _ready() -> void:
	GameManager.HUD = self

func update_order_reqs(taste_reqs: Dictionary) -> void:
	var temp: int = taste_reqs["sweet"]
	reqA_label.text = str(temp, " sweet")
	reqA_label.visible = (temp != 0)

	temp = taste_reqs["salty"]
	reqB_label.text = str(temp, " salty")
	reqB_label.visible = (temp != 0)

	temp = taste_reqs["sour"]
	reqC_label.text = str(temp, " sour")
	reqC_label.visible = (temp != 0)

	temp = taste_reqs["umami"]
	reqD_label.text = str(temp, " umami")
	reqD_label.visible = (temp != 0)

func _on_button_pressed() -> void:
	SignalBus.serve_pressed.emit()
