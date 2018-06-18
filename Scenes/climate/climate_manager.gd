extends Node2D

var id = self
var temperature_index = 1
var possible_temperatures = [8.0, 25.0, 42.0]

func _ready():
	global.climate_manager = id
	global.climate_temperature = possible_temperatures[temperature_index]

func _on_tmr_change_timeout():
	$tmr_change.wait_time = rand_range(30.0, 120.0)
	temperature_index = randi() % 3
	global.climate_temperature = possible_temperatures[temperature_index]
