extends NinePatchRect

export(Item.ItemType) var item_type = Item.ItemType.NONE setget set_item_type
export var quantity: int = 0 setget set_quantity

onready var icon_rect: TextureRect = $IconRect
onready var label: Label = $Label

func display(item_type, qty=0) -> void:
	set_item_type(item_type)
	set_quantity(qty)

func set_item_type(val) -> void:
	item_type = val
	icon_rect.texture = Item.ICONS[item_type]

func set_quantity(val) -> void:
	quantity = val
	if quantity == 0:
		label.text = ""
	else:
		label.text = str(quantity)
