extends Node2D

var display_x
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	display_x = DisplayServer.screen_get_size().x
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_viewport().size = DisplayServer.screen_get_size()
