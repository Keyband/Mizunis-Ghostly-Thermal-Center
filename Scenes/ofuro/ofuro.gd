extends Area2D

var temperature = 25
var request = preload("res://Scenes/requests/request1.tscn")

enum State_Salt {Yellow, Red, Empty}
enum State_Temperature {Neutral, Hot, Cold}

var state_salt = State_Salt["Empty"]
var state_temperature = State_Temperature["Neutral"]

func _ready():
	add_to_group('Ofuro')
	set_process(true)

func _process(delta):
	temperature = clamp(temperature + 0.66 * delta * sign(global.climate_temperature - self.temperature), 0, global.maximum_temperature)
	$sprites/path_2d/path_follow_2d.unit_offset = lerp($sprites/path_2d/path_follow_2d.unit_offset, temperature/global.maximum_temperature - 0.01, 0.1)
	
	if $sprites/path_2d/path_follow_2d.unit_offset < 0.32: state_temperature = State_Temperature["Cold"]
	elif $sprites/path_2d/path_follow_2d.unit_offset < 0.62: state_temperature = State_Temperature["Neutral"]
	else: state_temperature = State_Temperature["Hot"]
