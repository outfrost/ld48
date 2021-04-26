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
	FLOWER1,
	FLOWER2,
	FLOWER3,
}

static func type_str(item_type):
	for entry in ItemType:
		if item_type == ItemType.get(entry):
			return str(entry)
	return "Invalid ItemType"
