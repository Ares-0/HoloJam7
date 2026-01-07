class_name Customer
extends Node2D

@export var exit_dir: float = 1.0

@export var order_attrs : Dictionary = {
	"sweet":0,
	"salty":0,
	"umami":0,
	"sour":0
} 
var satisfaction_pts : float

var initial_pos: Vector2

func _ready() -> void:
	initial_pos = self.position
	self.position = initial_pos + Vector2(exit_dir*1000.0,0)

func _process(delta: float) -> void:
	pass

func move_onscreen() -> void:
	self.scale.x = abs(self.scale.x)
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "position", initial_pos, 0.8)
	await tween.finished
	SignalBus.customer_done_moving.emit()

func move_offscreen() -> void:
	self.scale.x = self.scale.x*-1
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "position", initial_pos + Vector2(exit_dir*1000,0), 0.6)
	await tween.finished
	SignalBus.customer_done_moving.emit()
