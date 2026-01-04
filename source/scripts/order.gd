class_name Order
extends Node

# Class representing an order that comes from a customer

@export var recipe_name: String
@export var image_path: String
@export var taste_reqs : Dictionary = {
	"sweet" : 0,
	"salty": 0,
	"sour": 0,
	"umami" : 0
}

func _ready() -> void:
	recipe_name = "blank recipe"
	image_path = "res://icon.svg"

func setup_reqs(reqs: Array[int]) -> void:
	# replace with fuller function later
	taste_reqs["sweet"] = reqs[0]
	taste_reqs["salty"] = reqs[1]
	taste_reqs["sour"] = reqs[2]
	taste_reqs["umami"] = reqs[3]
