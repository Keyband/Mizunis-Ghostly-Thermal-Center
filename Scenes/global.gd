extends Node

var player
var platforms
var climate_manager 
var gui_layer 
var score = 0
var reputation = 100

var vector_gravity_up = Vector2(0,13)
var vector_gravity_down = Vector2(0,16)
var vector_floor_normal = Vector2(0,-1)

var heat_transfer_rate = 0.1
var climate_temperature = 25.0
var maximum_temperature = 50.0

var bg = preload("res://Scenes/snd_bg.tscn")
var gameover = preload("res://Scenes/gameover.tscn")

func _ready():
	randomize()
	OS.window_size *= 2
	set_process(true)

func _process(delta):
	reputation = clamp(reputation, -100.0, 100.0)
	if reputation < 0.0:
		set_process(false)
		gameover()

func turn_the_boombox_on_m8(): add_child(bg.instance())

func gameover():
	gui_layer.add_child(gameover.instance())
#	self.pause_mode = Node.PAUSE_MODE_PROCESS
	get_tree().paused = true
	