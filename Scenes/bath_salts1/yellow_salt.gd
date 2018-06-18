extends KinematicBody2D

var id = self
var being_carried = false

var vetor_velocidade = Vector2()
var animacao = ''

func _ready():
	add_to_group('Carryable')
	add_to_group('Yellow')

func _physics_process(delta):
	if being_carried: $CollisionShape2D.disabled = true
	else: $CollisionShape2D.disabled = false
	
	if being_carried: $Area2D/CollisionShape2D.disabled = true
	else: $Area2D/CollisionShape2D.disabled = false
	
	var lerp_constant = 0.1 if is_on_floor() else 0.0
	if not being_carried:
		vetor_velocidade.x = lerp(vetor_velocidade.x, 0, lerp_constant)
		vetor_velocidade.y += global.vector_gravity_up.y if vetor_velocidade.y < 0 else global.vector_gravity_down.y
		vetor_velocidade = move_and_slide(vetor_velocidade, global.vector_floor_normal)

func _on_Area2D_area_entered(area):
	if area.is_in_group('Ofuro') and not self.being_carried:
		$snd_splash.play()
		area.state_salt = area.Yellow
		self.visible = false
		$CollisionShape2D.disabled = true
		$Area2D/CollisionShape2D.disabled = true
		yield(get_tree().create_timer(3.0), 'timeout')
		self.queue_free()
