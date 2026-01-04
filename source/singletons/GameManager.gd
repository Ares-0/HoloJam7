extends Node

# Big boy tracker of everything that takes place in a day
# Primary job is to interface between objects that otherwise don't know about each other

# Order state machine could be elsewhere, depending
# Mostly just don't know if that messes up the visible scope of objects

const MAX_CARDS_PER_HAND: int = 5

# State machine for order loop
enum OrderState {
	WAIT, # waiting for order to start
	BEGIN, # receiving order from customer
	SELECT, # selecting ingredient cards
	SERVE # serve order and collect feedback
}
var order_state: OrderState = OrderState.WAIT
var current_order: Order

var draw_pile: Pile
var discard_pile: Pile
var hand: Hand
var HUD: DevHUD

# dev
var dish_taste = {
	"sweet": 0,
	"salty": 0,
	"sour": 0,
	"umami": 0
}


func _ready() -> void:
	SignalBus.discard.connect(_on_discard)
	SignalBus.card_tapped.connect(_on_card_tapped)
	SignalBus.pile_empty.connect(_on_pile_empty)
	SignalBus.serve_pressed.connect(_on_serve_pressed)

	#await get_tree().process_frame
	#order_begin_phase()

func _process(delta: float) -> void:
	pass
	if Input.is_action_just_pressed("debug_0"):
		fill_hand()

func add_values_to_dish(tastes: Dictionary) -> void:
	dish_taste["sweet"] = dish_taste["sweet"] + tastes["sweet"]
	dish_taste["salty"] = dish_taste["salty"] + tastes["salty"]
	dish_taste["sour"] = dish_taste["sour"] + tastes["sour"]
	dish_taste["umami"] = dish_taste["umami"] + tastes["umami"]
	HUD.update_dish_stats(dish_taste)
	#print(dish_taste)

func eval_score() -> int:
	# A score of 0 means the dish perfectly matched the taste
	var score = 0

	# simple algebra
	score = score + abs(current_order.taste_reqs["sweet"] - dish_taste["sweet"])
	score = score + abs(current_order.taste_reqs["salty"] - dish_taste["salty"])
	score = score + abs(current_order.taste_reqs["sour"] - dish_taste["sour"])
	score = score + abs(current_order.taste_reqs["umami"] - dish_taste["umami"])

	print("Lost ", score, " points! Good enough! Keep going!")
	return -score

func dish_taste_reset() -> void:
	dish_taste["sweet"] = 0
	dish_taste["salty"] = 0
	dish_taste["sour"] = 0
	dish_taste["umami"] = 0
	HUD.update_dish_stats(dish_taste)

func order_begin_phase() -> void:
	# All the work done before a player can select cards
	order_state = OrderState.BEGIN

	# random orders for testing
	var dev_order: Order = load("res://source/scenes/order.tscn").instantiate()
	var random_reqs: Array[int] = [0,1,2,0]
	random_reqs.shuffle()
	dev_order.setup_reqs(random_reqs)

	current_order = dev_order

	# Tell customer window what customer to display
	# customer_window.show_customer(daily_orders.customer_name)

	# Tell order window what order to display
	HUD.update_order_reqs(current_order.taste_reqs)
	HUD.update_dish_stats(dish_taste)

	# Fill hand with cards
	# fill_hand()

	# continue automatically
	order_select_phase()

func order_select_phase() -> void:
	# Phase for player to play and reroll cards
	order_state = OrderState.SELECT

func order_serve_phase() -> void:
	# Phase to complete the order and finish the loop
	order_state = OrderState.SERVE

	# Take order away

	# Collect feedback
	var score: int = eval_score()
	# and do what with the score
	HUD.update_feedback_label(str("dish score: ", score))
	dish_taste_reset()

	# Fill hand with cards
	fill_hand()
	
	# automatically return to begin phase
	# I actually don't like the stack growing like this
	order_begin_phase()

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
	add_values_to_dish(card.get_taste_values())
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
	# If WAITing, start first order
	# If SELECTing, serve order

	if order_state == OrderState.WAIT:
		order_begin_phase()
	elif order_state == OrderState.SELECT:
		order_serve_phase()
