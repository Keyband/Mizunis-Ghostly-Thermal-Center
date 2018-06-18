extends KinematicBody2D

var id = self
var being_carried = false

var vetor_velocidade = Vector2()
var animacao = ''

func _ready():
	add_to_group('Carryable')
	$range_heat.add_to_group('Heat Range')

func _physics_process(delta):
	if being_carried: $CollisionShape2D.disabled = true
	else: $CollisionShape2D.disabled = false
	
	for area in $range_heat.get_overlapping_areas():
		if area.is_in_group('Ofuro'):
			area.temperature += global.heat_transfer_rate

	var lerp_constant = 0.1 if is_on_floor() else 0.0
	if not being_carried:
		vetor_velocidade.x = lerp(vetor_velocidade.x, 0, lerp_constant)
		vetor_velocidade.y += global.vector_gravity_up.y if vetor_velocidade.y < 0 else global.vector_gravity_down.y
		vetor_velocidade = move_and_slide(vetor_velocidade, global.vector_floor_normal)