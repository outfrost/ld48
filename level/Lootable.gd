class_name Lootable
extends Node2D

export(Item.ItemType) var loot1
export var loot1_amount: int
export(Item.ItemType) var loot2
export var loot2_amount: int

var character

func _ready() -> void:
	$Area2D.connect("body_entered", self, "on_body_entered")
	$Area2D.connect("body_exited", self, "on_body_exited")

func on_body_entered(body):
	if body.has_method("entered_lootable_range"):
		body.entered_lootable_range(self)

func on_body_exited(body):
	if body.has_method("exited_lootable_range"):
		body.exited_lootable_range(self)