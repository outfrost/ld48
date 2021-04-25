class_name Item
extends Reference

enum ItemType {
	NONE,
	FLOWER1,
	FLOWER2,
}

static func type_str(item_type):
	for entry in ItemType:
		if item_type == ItemType.get(entry):
			return str(entry)
	return "Invalid ItemType"
