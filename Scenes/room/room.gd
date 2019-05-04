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
var satisfaction = preload("res://Scenes/satisfaction/satisfaction.tscn")
var ghost = preload("res://Scenes/ghost/ghost.tscn")
var current_request
var current_ghost

func _ready():
	$tmr_still.wait_time = rand_range(5, 10)
	$tmr_next.start()
	self.modulate=Color('727272')
	add_to_group('Door')
	set_process(true)

func _process(delta):
	$timerBar.value=$tmr_still.time_left
	$timerBar.max_value=$tmr_still.wait_time
	
	if move_to_ofuro:
		if $path_2d/path_follow_2d.unit_offset > 0.95:
			move_to_ofuro=false
			$tmr_still.wait_time = rand_range(1.5, 2.0)
			$tmr_still.start()
	if move_to_exit:
		if $path_2d/path_follow_2d.unit_offset < 0.05:
			move_to_exit = false
			current_ghost.fadeAway()
			current_request.fadeAway()
			$tmr_next.wait_time = rand_range(5.0, 10.0)
			$tmr_next.start()


func _on_tmr_next_timeout():
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
	$twnMovement.interpolate_property($path_2d/path_follow_2d,"unit_offset",0,1,rand_range(2.5,5.0),Tween.TRANS_SINE,Tween.EASE_OUT)
	$twnMovement.start()
	$twnGray.interpolate_property(self,"modulate",self.modulate,Color('ffffff'),0.4,Tween.TRANS_CUBIC,Tween.EASE_IN)
	$twnGray.start()

func _on_tmr_still_timeout():
	if str($ofuro.state_salt) + str($ofuro.state_temperature) == types_of_request[type_index]:
		global.score += 1
		global.reputation = clamp(global.reputation + 5.0, 0, 100)
		current_ghost.satisfaction()
	else:
		global.reputation -= 20.0
		current_ghost.dissatisfaction()
	
#	$ofuro.state_salt = $ofuro.Empty
	current_ghost.get_node('sprite').flip_h=false
	move_to_exit = true
	$twnMovement.interpolate_property($path_2d/path_follow_2d,"unit_offset",1,0,rand_range(2.5,7.5),Tween.TRANS_SINE,Tween.EASE_IN_OUT)
	$twnMovement.start()
	$twnGray.interpolate_property(self,"modulate",self.modulate,Color('727272'),0.4,Tween.TRANS_CUBIC,Tween.EASE_IN)
	$twnGray.start()
