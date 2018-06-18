extends Area2D

var temperature = 25
var request = preload("res://Scenes/requests/request1.tscn")

enum State_Salt {Yellow, Red, Empty}
enum State_Temperature {Neutral, Hot Cold}

var state_salt = Empty
var state_temperature = Neutral



func _ready():
	add_to_group('Ofuro')
#	request()
	set_process(true)

func _process(delta):
#	print($sprites/path_2d/path_follow_2d.unit_offset)
#	print('State: ' + str(state_salt) + str(state_temperature))
	temperature = clamp(temperature + 0.66 * delta * sign(global.climate_temperature - self.temperature), 0, global.maximum_temperature)
	$sprites/path_2d/path_follow_2d.unit_offset = lerp($sprites/path_2d/path_follow_2d.unit_offset, temperature/global.maximum_temperature - 0.01, 0.1)
	
	if $sprites/path_2d/path_follow_2d.unit_offset < 0.32: state_temperature = Cold
	elif $sprites/path_2d/path_follow_2d.unit_offset < 0.62: state_temperature = Neutral
	else: state_temperature = Hot
#func request():
#	var i = request.instance()
#	i.target_y_pos = $pos_request.global_position.y
#	i.position = Vector2()
#	add_child(i)
