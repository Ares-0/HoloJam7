extends Node

# Big boy tracker of everything that takes place in a day
# Helps interface between objects that otherwise don't know about each other
# Order state machine could be elsewhere, depending

const MAX_CARDS_PER_HAND: int = 5

var draw_pile: Pile
var discard_pile: Pile
var hand: Hand

# dev
var score = {
	"a": 0,
	"b": 0,
	"c": 0,
	"d": 0
}


func _ready() -> void:
	SignalBus.discard.connect(_on_discard)
	SignalBus.card_tapped.connect(_on_card_tapped)
	SignalBus.pile_empty.connect(_on_pile_empty)
	SignalBus.serve_pressed.connect(_on_serve_pressed)

func _process(delta: float) -> void:
	pass
	if Input.is_action_just_pressed("debug_0"):
		fill_hand()

func add_values_to_score(tastes: Dictionary) -> void:
	score["a"] = score["a"] + tastes["sweet"]
	score["b"] = score["b"] + tastes["salty"]
	score["c"] = score["c"] + tastes["sour"]
	score["d"] = score["d"] + tastes["umami"]
	print(score)

func score_reset() -> void:
	score["a"] = 0
	score["b"] = 0
	score["c"] = 0
	score["d"] = 0
	print(score)

func order_begin_phase() -> void:
	pass
	# Tell customer window what customer to display
	# Tell order window what order to display
	# Fill hand with cards

func fill_hand() -> void:
	# Check if players hand is full and if not draw cards from pile to add to it
	# Player should not have to automatically draw ever
	var cards_in_hand: int = hand.get_cards_count()
	var diff = MAX_CARDS_PER_HAND - cards_in_hand
	for x in range(0,diff):
		var card: Card = draw_pile.draw_card()
		if card != null:
			hand.add_card(card)

func _on_discard(card: Card) -> void:
	hand.take_card(card)
	discard_pile.place_card(card)

func _on_card_tapped(card: Card) -> void:
	add_values_to_score(card.get_taste_values())
	hand.take_card(card)
	discard_pile.place_card(card)

func _on_pile_empty(pile: Pile) -> void:
	# If there's very few cards so both packs are empty, it can cause some soft locks
	if pile == draw_pile:
		var pack = discard_pile.remove_all_cards()
		if pack.size() > 0:
			draw_pile.add_cards(pack)
			draw_pile.shuffle()

func _on_serve_pressed() -> void:
	# take away order, disable card usage
	# 

	pass
	score_reset()
