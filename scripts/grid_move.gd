extends GridContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	size.x = DisplayServer.screen_get_size().x
	size.y = DisplayServer.screen_get_size().y - $"../Grass/ColorRect".size.y
	columns = 10
	
	for n in columns :
		var colorRect = ColorRect.new()
		colorRect.custom_minimum_size = Vector2(1900, 1080) / 5
		colorRect.set_color(Color(0.39, 0.39, 0.39, 0.39))
		
		add_child(colorRect)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
