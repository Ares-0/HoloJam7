class_name FallingText
extends Label

const SPEED: float = 50.0

@export var text_str: String = "Text"
@export var duration_s: float = 1.0
@export var dir: float = 1.0

var angle: Vector2
var timer: Timer

func _ready() -> void:
	pass
	angle = Vector2.RIGHT.rotated(randf_range(-PI/3, PI/3))
	#print(angle)
	#start("asdf", 10.0)

func _process(delta: float) -> void:
	self.position = self.position + angle*SPEED*delta*Vector2(dir, 1.0)

func start(new_text: String, duration: float, dir_r: float = 1.0) -> void:
	self.text_str = new_text
	self.duration_s = duration
	self.text = text_str
	self.dir = dir_r

	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, duration_s)
	await tween.finished
	self.queue_free()
