extends Area2D

var movement_direction = -1
var satisfaction = preload("res://Scenes/satisfaction/satisfaction.tscn")

func _ready():
	add_to_group('Ghost')

func satisfaction():
	var i = satisfaction.instance()
	i.get_node('sprite').frame = 1
	i.position = $pos_satisfaction_initial.position
	i.target_y_pos = $pos_satisfaction.position.y
	add_child(i)

func dissatisfaction():
	var i = satisfaction.instance()
	i.get_node('sprite').frame = 0
	i.position = $pos_satisfaction_initial.position
	i.target_y_pos = $pos_satisfaction.position.y
	add_child(i)