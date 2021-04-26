class_name Item
extends Reference

enum ItemType {
	NONE,
	ORB_RED,
	ORB_BLUE,
	ORB_YELLOW,
	ORB_GREEN,
	LEAVES,
	TWIG,
	BOTTLE_RED,
	BOTTLE_BLUE,
	BOTTLE_YELLOW,
	BOTTLE_GREEN,
}

const ICONS: Dictionary = {
	ItemType.NONE: preload("res://item/None.tres"),
	ItemType.ORB_RED: preload("res://item/OrbRed.tres"),
	ItemType.ORB_BLUE: preload("res://item/OrbBlue.tres"),
	ItemType.ORB_YELLOW: preload("res://item/OrbYellow.tres"),
	ItemType.ORB_GREEN: preload("res://item/OrbGreen.tres"),
	ItemType.LEAVES: preload("res://item/Leaves.tres"),
	ItemType.TWIG: preload("res://item/Twig.tres"),
	ItemType.BOTTLE_RED: preload("res://item/BottleRed.tres"),
	ItemType.BOTTLE_BLUE: preload("res://item/BottleBlue.tres"),
	ItemType.BOTTLE_YELLOW: preload("res://item/BottleYellow.tres"),
	ItemType.BOTTLE_GREEN: preload("res://item/BottleGreen.tres"),
}

static func type_str(item_type):
	for entry in ItemType:
		if item_type == ItemType.get(entry):
			return str(entry)
	return "Invalid ItemType"
