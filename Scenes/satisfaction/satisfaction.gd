extends Node2D

var target_y_pos = 0

func _ready():
	set_process(false)
	$twn.interpolate_property($sprite, 'position:y', $sprite.position.y, target_y_pos, 1.0, Tween.TRANS_BACK, Tween.EASE_OUT)
	$twn.start()
	
func _process(delta):
	self.modulate.a -= delta
	if self.modulate.a < 0.0: self.queue_free()
	
func _on_tmr_free_timeout(): set_process(true)
