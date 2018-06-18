extends Area2D
###If someone actually looks at the source code of this game, please notice that
###I think I should have used a FSM here... welp, too late I guess.

###And I could have used a matrix or something like that for the types of requests, but... yeah, I dunno.
var types_of_request = [
	'00',
	'01',
	'02',
	'10',
	'11',
	'12']

var type_index = 0
var salt_index = 0
var temperature_index = 0

var ready_for_next = true
var move_to_ofuro = false
var move_to_exit = false

var request = preload("res://Scenes/requests/request1.tscn")
var ghost = preload("res://Scenes/ghost/ghost.tscn")
var current_request
var current_ghost


func _ready():
	$tmr_next.wait_time = rand_range(2.0, 4.0)
	$tmr_still.wait_time = rand_range(5, 10)
	$tmr_next.start()
	add_to_group('Door')
	set_process(true)

func _process(delta):
	if move_to_ofuro:
		$path_2d/path_follow_2d.unit_offset = lerp($path_2d/path_follow_2d.unit_offset, 0.99, 0.01)
		if $path_2d/path_follow_2d.unit_offset > 0.95:
			move_to_ofuro = false
			$tmr_still.wait_time = rand_range(7.5, 12.0)
			$tmr_still.start()
	if move_to_exit:
		$path_2d/path_follow_2d.unit_offset = lerp($path_2d/path_follow_2d.unit_offset, 0.01, 0.01)
		if $path_2d/path_follow_2d.unit_offset < 0.05:
			move_to_exit = false
			current_ghost.queue_free()
			current_request.queue_free()
			$tmr_next.wait_time = rand_range(2.0, 4.0)
			$tmr_next.start()


func _on_tmr_next_timeout():
	print('Cliente')
	salt_index = randi() % 2
	temperature_index = randi() % 3
	
	type_index = 0
	if temperature_index == 0: type_index = 0 if salt_index == 0 else 3
	elif temperature_index == 1: type_index = 1 if salt_index == 0 else 4
	elif temperature_index == 2: type_index = 2 if salt_index == 0 else 5
#	print('Se quer: ' + str(types_of_request[type_index]))
	
	var i = request.instance()
	i.position = Vector2()
	i.get_node('sprite').frame = type_index
	i.target_y_pos = $pos_request.global_position.y
	current_request = i
	add_child(i)
	
	var j = ghost.instance()
	j.position = Vector2()
	j.movement_direction = 1
	j.get_node('sprite').flip_h = true
	current_ghost = j
	$path_2d/path_follow_2d.add_child(j)
	
	move_to_ofuro = true

func _on_tmr_still_timeout():
	if str($ofuro.state_salt) + str($ofuro.state_temperature) == types_of_request[type_index]:
		global.score += 1
		print('Pontuacao esta em ' + str(global.score))
	else:
		global.reputation -= 1
		print('Reputacao caiu para ' + str(global.reputation))
	current_ghost.get_node('sprite').flip_h = false
	move_to_exit = true
