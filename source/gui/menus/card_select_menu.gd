class_name CardSelectMenu 
extends Control 

@onready var new_choices_grid = %"Card Choices"

var number_selected = 0 
var new_cards = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void: 
	GameManager.card_select_menu = self
	#new_cards = new_choices_grid.get_children() 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass 

func get_selected(): 
	var cards_picked = [] 
	for c in new_choices_grid.get_children():
		if (c.checked()):
			cards_picked.push_back(c)
	return cards_picked

#Updates the display of the current deck
func update_current_deck():
	pass

func on_confirm(): 
	var picks = get_selected()
	var num = len(picks)
	if (num > 3):
		print("Choose only three cards, please")
		return 
	else: 
		for p in picks:
			Global.deck.push_back(p.card_img.card_num) 
			Global.save_data()
		self.hide()
		GameManager.day_machine.on_card_selection_confirmed()
