extends Control

export var icon_view: PackedScene

onready var icon_container: Control = $VBoxContainer

func update_view(inventory: Dictionary) -> void:
	for icon in icon_container.get_children():
		icon_container.remove_child(icon)
		icon.queue_free()
	for entry in inventory:
		if inventory[entry] > 0:
			var icon = icon_view.instance()
			icon_container.add_child(icon)
			icon.display(entry, inventory[entry])
