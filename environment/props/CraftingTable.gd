extends Area2D

const PROGRESS_TIME: float = 2.0

const RECIPES: Dictionary = {
	Item.ItemType.NONE: {},
	Item.ItemType.BOTTLE_RED: {
		Item.ItemType.ORB_RED: 2,
		Item.ItemType.LEAVES: 1,
		Item.ItemType.TWIG: 1,
	},
	Item.ItemType.BOTTLE_BLUE: {
		Item.ItemType.ORB_BLUE: 2,
		Item.ItemType.LEAVES: 1,
		Item.ItemType.TWIG: 1,
	},
	Item.ItemType.BOTTLE_YELLOW: {
		Item.ItemType.ORB_YELLOW: 2,
		Item.ItemType.LEAVES: 1,
	},
}

export var research_table_path: NodePath
onready var research_table = get_node(research_table_path)

onready var panel: Panel = $CanvasLayer/CraftingPanel
onready var confirm_button: Button = $CanvasLayer/CraftingPanel/ConfirmButton
onready var done_button: Button = $CanvasLayer/CraftingPanel/DoneButton
onready var progress_bar: ProgressBar = $CanvasLayer/CraftingPanel/ProgressBar

onready var recipe_buttons = $CanvasLayer/CraftingPanel/RecipeButtons.get_children()
onready var recipe_ingr_icons = $CanvasLayer/CraftingPanel/RecipeIngrIcons.get_children()

var button_recipes: Dictionary

var character: Node2D = null
var current_recipe = Item.ItemType.NONE
var animate_progress_bar: bool = false

func _ready() -> void:
	connect("body_entered", self, "on_body_entered")
	connect("body_exited", self, "on_body_exited")
	panel.hide()
	confirm_button.connect("pressed", self, "on_confirm")
	done_button.connect("pressed", self, "done_interacting")
	for i in range(recipe_buttons.size()):
		recipe_buttons[i].connect("pressed", self, "on_recipe_button_pressed", [i])

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
	current_recipe = Item.ItemType.NONE
	$CanvasLayer/CraftingPanel/ChosenRecipeIconRect.texture = (
		Item.ICONS[current_recipe])
	progress_bar.value = 0.0
	confirm_button.disabled = false

func on_confirm():
	if !character || !is_instance_valid(character):
		character = null
		return
	if current_recipe == Item.ItemType.NONE:
		return
	for entry in RECIPES[current_recipe]:
		if !character.inventory.has(entry) || character.inventory[entry] < RECIPES[current_recipe][entry]:
			return
	confirm_button.disabled = true
	done_button.disabled = true
	for btn in recipe_buttons:
		btn.disabled = true
	progress_bar.value = 0.0
	animate_progress_bar = true
	yield(get_tree().create_timer(PROGRESS_TIME), "timeout")
	animate_progress_bar = false
	if character && is_instance_valid(character):
		for entry in RECIPES[current_recipe]:
			character.inventory[entry] -= RECIPES[current_recipe][entry]
		if !character.inventory.has(current_recipe):
			character.inventory[current_recipe] = 0
		character.inventory[current_recipe] += 1
		character.update_selector()
	update_inventory_view()
	done_button.disabled = false

	var enough: bool = true
	for ingredient in RECIPES[current_recipe]:
		if !character.inventory.has(ingredient) || character.inventory[ingredient] < RECIPES[current_recipe][ingredient]:
			enough = false
			break
	confirm_button.disabled = !enough

	character.print_inventory()

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

	var button_idx = 0
	for recipe in RECIPES:
		if button_idx >= recipe_buttons.size():
			break
		if recipe == Item.ItemType.NONE:
			continue
		button_recipes[button_idx] = recipe
		var researched: bool = true
		for ingredient in RECIPES[recipe]:
			if !(ingredient in research_table.researched_types):
				researched = false
		if researched:
			recipe_buttons[button_idx].icon = Item.ICONS[recipe]
			recipe_buttons[button_idx].disabled = false
		else:
			recipe_buttons[button_idx].icon = Item.ICONS[Item.ItemType.NONE]
			recipe_buttons[button_idx].disabled = true
		button_idx += 1
	while button_idx < recipe_buttons.size():
		recipe_buttons[button_idx].icon = Item.ICONS[Item.ItemType.NONE]
		recipe_buttons[button_idx].disabled = true
		button_idx += 1

func on_recipe_button_pressed(idx):
	current_recipe = button_recipes[idx]
	$CanvasLayer/CraftingPanel/ChosenRecipeIconRect.texture = (
		Item.ICONS[current_recipe])
	for icon in recipe_ingr_icons:
		icon.texture = Item.ICONS[Item.ItemType.NONE]
	var enough: bool = true
	var icon_idx: int = 0
	for ingredient in RECIPES[current_recipe]:
		if icon_idx < recipe_ingr_icons.size():
			recipe_ingr_icons[icon_idx].texture = Item.ICONS[ingredient]
			icon_idx += 1
		if !character.inventory.has(ingredient) || character.inventory[ingredient] < RECIPES[current_recipe][ingredient]:
			enough = false
	progress_bar.value = 0.0
	confirm_button.disabled = !enough
