extends Area2D

onready var panel: Panel = $CanvasLayer/ResearchPanel
onready var done_button: Button = $CanvasLayer/ResearchPanel/DoneButton

var character: Node2D = null

func _ready() -> void:
	connect("body_entered", self, "on_body_entered")
	connect("body_exited", self, "on_body_exited")
	panel.hide()
	done_button.connect("pressed", self, "done_interacting")

func on_body_entered(body):
	if body.has_method("entered_interactive_range"):
		character = body
		body.entered_interactive_range(self)

func on_body_exited(body):
	if body.has_method("exited_interactive_range"):
		if body == character:
			character = null
		body.exited_interactive_range(self)

func interact():
	if !character || !is_instance_valid(character):
		character = null
		return
	character.set_process_input(false)
	character.set_physics_process(false)
	panel.show()

func done_interacting():
	panel.hide()
	if !character || !is_instance_valid(character):
		character = null
		return
	character.set_process_input(true)
	character.set_physics_process(true)

func update_inventory_view():
	if !character || !is_instance_valid(character):
		character = null
		return
	var inventory_buttons = $CanvasLayer/ResearchPanel/InventoryButtons.get_children()
	var button_idx = 0
	for item_type in character.inventory:
		if button_idx >= inventory_buttons.size():
			break
		if character.inventory[item_type] <= 0:
			continue
		inventory_buttons[button_idx].icon = Item.ICONS[item_type]
		button_idx += 1
	while button_idx < inventory_buttons.size():
		inventory_buttons[button_idx].icon = Item.ICONS[Item.ItemType.NONE]
		button_idx += 1
