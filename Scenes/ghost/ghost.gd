extends Area2D

var movement_direction = -1
var satisfaction = preload("res://Scenes/satisfaction/satisfaction.tscn")

func _ready():
	$sprite/satisfaction.modulate.a=0
	add_to_group('Ghost')

func satisfaction():
	$sprite/satisfaction.frame=1
	$twnTransparency.interpolate_property($sprite/satisfaction,"modulate:a",0,1,0.33,Tween.TRANS_CUBIC,Tween.EASE_IN);
	$twnTransparency.start()

func dissatisfaction():
	$sprite/satisfaction.frame=0
	$twnTransparency.interpolate_property($sprite/satisfaction,"modulate:a",0,1,0.33,Tween.TRANS_CUBIC,Tween.EASE_IN);
	$twnTransparency.start()
	
func fadeAway():
	$twnFade.interpolate_property(self,"modulate:a",self.modulate.a,0,0.4,Tween.TRANS_SINE,Tween.EASE_IN_OUT,0.2)
	$twnFade.start()
	
func _on_twnFade_tween_completed(object, key): self.queue_free()