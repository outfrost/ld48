class_name Lootable
extends Area2D

export(Item.ItemType) var loot1
export var loot1_amount: int
export(Item.ItemType) var loot2
export var loot2_amount: int
export(Item.ItemType) var loot3
export var loot3_amount: int

var character

func _ready() -> void:
	connect("body_entered", self, "on_body_entered")
	connect("body_exited", self, "on_body_exited")
	connect("tree_exiting", self, "on_tree_exiting")

func on_body_entered(body):
	if body.has_method("entered_lootable_range"):
		body.entered_lootable_range(self)

func on_body_exited(body):
	if body.has_method("exited_lootable_range"):
		body.exited_lootable_range(self)

func on_tree_exiting():
	var highlight = get_node(@"../Highlight")
	if highlight:
		highlight.queue_free()
