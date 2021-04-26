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
	NONE = preload("res://item/None.tres"),
	ORB_RED = preload("res://item/OrbRed.tres"),
	ORB_BLUE = preload("res://item/OrbBlue.tres"),
	ORB_YELLOW = preload("res://item/OrbYellow.tres"),
	ORB_GREEN = preload("res://item/OrbGreen.tres"),
	LEAVES = preload("res://item/Leaves.tres"),
	TWIG = preload("res://item/Twig.tres"),
	BOTTLE_RED = preload("res://item/BottleRed.tres"),
	BOTTLE_BLUE = preload("res://item/BottleBlue.tres"),
	BOTTLE_YELLOW = preload("res://item/BottleYellow.tres"),
	BOTTLE_GREEN = preload("res://item/BottleGreen.tres"),
}

static func type_str(item_type):
	for entry in ItemType:
		if item_type == ItemType.get(entry):
			return str(entry)
	return "Invalid ItemType"
