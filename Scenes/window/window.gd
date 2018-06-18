extends Node2D

func _ready(): set_process(true)
	
func _process(delta):
	if global.climate_manager.temperature_index == 0: #Cold
		$mid.modulate.a = lerp($mid.modulate.a, 0, 0.01)
		$hot.modulate.a = lerp($hot.modulate.a, 0, 0.01)
		$cold.modulate.a = lerp($cold.modulate.a, 1, 0.01)
	elif global.climate_manager.temperature_index == 1: #OK
		$mid.modulate.a = lerp($mid.modulate.a, 1, 0.01)
		$hot.modulate.a = lerp($hot.modulate.a, 0, 0.01)
		$cold.modulate.a = lerp($cold.modulate.a, 0, 0.01)
	if global.climate_manager.temperature_index == 2: #Hot
		$mid.modulate.a = lerp($mid.modulate.a, 0, 0.01)
		$hot.modulate.a = lerp($hot.modulate.a, 1, 0.01)
		$cold.modulate.a = lerp($cold.modulate.a, 0, 0.01)