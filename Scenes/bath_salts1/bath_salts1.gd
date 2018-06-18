extends Area2D

var salts = preload("res://Scenes/bath_salts1/red_salt.tscn")

func _ready(): add_to_group('Dispenser')
func dispense():
	print('Dispensing')
	var i = salts.instance()
	global.player.carry = i
	global.player.carrying = true
	i.being_carried = true
	get_parent().add_child(i)
