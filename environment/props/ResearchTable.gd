extends Area2D

const PROGRESS_TIME: float = 3.0
const RESEARCHABLE: Array = [
	Item.ItemType.ORB_RED,
	Item.ItemType.ORB_BLUE,
	Item.ItemType.ORB_YELLOW,
	Item.ItemType.ORB_GREEN,
	Item.ItemType.LEAVES,
	Item.ItemType.TWIG,
]

onready var panel: Panel = $CanvasLayer/ResearchPanel
onready var confirm_button: Button = $CanvasLayer/ResearchPanel/ConfirmButton
onready var done_button: Button = $CanvasLayer/ResearchPanel/DoneButton
onready var progress_bar: ProgressBar = $CanvasLayer/ResearchPanel/ProgressBar

onready var inventory_buttons = $CanvasLayer/ResearchPanel/InventoryButtons.get_children()

var character: Node2D = null
var inv_item_types: Dictionary
var current_item_type = Item.ItemType.NONE
var animate_progress_bar: bool = false

var researched_types: Array

func _ready() -> void:
	connect("body_entered", self, "on_body_entered")
	connect("body_exited", self, "on_body_exited")
	panel.hide()
	confirm_button.connect("pressed", self, "on_confirm")
	done_button.connect("pressed", self, "done_interacting")
	for i in range(inventory_buttons.size()):
		inventory_buttons[i].connect("pressed", self, "on_inventory_button_pressed", [i])

func _process(delta: float) -> void:
	if animate_progress_bar:

		progress_bar.value += (delta / PROGRESS_TIME) * progress_bar.max_value

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
	update_inventory_view()
	current_item_type = Item.ItemType.NONE
	$CanvasLayer/ResearchPanel/ChosenItemIconRect.texture = (
		Item.ICONS[current_item_type])
	progress_bar.value = 0.0
	confirm_button.disabled = false

func on_confirm():
	if !character || !is_instance_valid(character):
		character = null
		return
	if !character.inventory.has(current_item_type) || character.inventory[current_item_type] < 1:
		return
	if !(current_item_type in RESEARCHABLE):
		return
	confirm_button.disabled = true
	done_button.disabled = true
	for btn in inventory_buttons:
		btn.disabled = true
	progress_bar.value = 0.0
	animate_progress_bar = true
	yield(get_tree().create_timer(PROGRESS_TIME), "timeout")
	animate_progress_bar = false
	if character && is_instance_valid(character):
		character.inventory[current_item_type] -= 1
	researched_types.append(current_item_type)
	current_item_type = Item.ItemType.NONE
	update_inventory_view()
	done_button.disabled = false

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

	inv_item_types.clear()
	var button_idx = 0
	for item_type in character.inventory:
		if button_idx >= inventory_buttons.size():
			break
		if character.inventory[item_type] <= 0:
			continue
		if !(item_type in RESEARCHABLE):
			continue
		inventory_buttons[button_idx].icon = Item.ICONS[item_type]
		inv_item_types[button_idx] = item_type
		inventory_buttons[button_idx].disabled = item_type in researched_types
		button_idx += 1
	while button_idx < inventory_buttons.size():
		inventory_buttons[button_idx].icon = Item.ICONS[Item.ItemType.NONE]
		inv_item_types[button_idx] = Item.ItemType.NONE
		inventory_buttons[button_idx].disabled = true
		button_idx += 1

func on_inventory_button_pressed(idx):
	current_item_type = inv_item_types[idx]
	$CanvasLayer/ResearchPanel/ChosenItemIconRect.texture = (
		Item.ICONS[current_item_type])
	progress_bar.value = 0.0
	confirm_button.disabled = false
