extends KinematicBody2D

var eu = self
var carry
var wr_carry
var carrying = false

var vetor_velocidade = Vector2()
var direcao_horizontal = 1
var velocidade_maxima = 185
var velocidade_pulo = 300
var animacao = ''

var vector_gravity = Vector2()

func _ready():
	add_to_group('Player')
	global.player = self
	set_physics_process(true)
	
func _physics_process(delta):
	if Input.is_action_just_pressed('ui_debug'): global.reputation -= 50
	
	remove_collision_exception_with(global.platforms)
	if animacao != $animation_player.current_animation: $animation_player.play(animacao)
	if is_on_floor(): animacao = 'idle' if abs(vetor_velocidade.x) < 0.5 else 'walking'
	else: animacao = 'going_up' if self.vetor_velocidade.y < 0 else 'going_down'
	
	vector_gravity = global.vector_gravity_up if vetor_velocidade.y < 0 else global.vector_gravity_down
	
	$sprites/mizuni.flip_h = true if direcao_horizontal < 0 else false
	$range_action.position.x = -15 if direcao_horizontal < 0 else 15
	$pos_carry.position.x = -5 if direcao_horizontal < 0 else 5
	
	var vetor_direcao_do_movimento = Vector2()
	var direcao_h = 1 if Input.is_action_pressed('ui_right') else -1 if Input.is_action_pressed('ui_left') else 0
	direcao_horizontal = direcao_h if direcao_h != 0 else direcao_horizontal
	vetor_direcao_do_movimento.x = direcao_h
	
	if Input.is_action_just_pressed('ui_jump'):
		if is_on_floor():
			if Input.is_action_pressed('ui_down'):
				pass
#				add_collision_exception_with(global.platforms)
			else:
				get_node("sounds/snd_jump" + str(randi() % 2)).play()
				$twn_gummy.interpolate_property($sprites, 'scale', $sprites.scale * Vector2( 0.66, 1.33), Vector2(1,1), 0.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
				$twn_gummy.start()
				vetor_velocidade.y = 0
				vetor_direcao_do_movimento.y -= 1
	
	if Input.is_action_just_pressed('ui_action'):
		if carrying == false:
			for area in $range_action.get_overlapping_areas():
				if area.get_parent().is_in_group('Carryable') and not area.is_in_group('Heat Range'):
					$sounds/snd_grab.play()
					carry = area.get_parent()
					wr_carry = weakref(carry)
					carry.being_carried = true
					carrying = true
					break
				elif area.is_in_group('Dispenser'):
					$sounds/snd_grab.play()
					area.dispense()
		else:
			$sounds/snd_throw.play()
			var throw_direction = Vector2()
			throw_direction.x = 1 if Input.is_action_pressed('ui_right') else -1 if Input.is_action_pressed('ui_left') else 0
			throw_direction.y = 1 if Input.is_action_pressed('ui_down') else -1 if Input.is_action_pressed('ui_up') else 0
			carry.vetor_velocidade = throw_direction.normalized() * (150 + self.vetor_velocidade.length())
			carry.being_carried = false
			carrying = false
	
	
	vetor_velocidade.x = lerp(vetor_velocidade.x, vetor_direcao_do_movimento.x * velocidade_maxima, 0.2)
	vetor_velocidade.y += vector_gravity.y + vetor_direcao_do_movimento.y * velocidade_pulo
	vetor_velocidade = move_and_slide(vetor_velocidade, global.vector_floor_normal)
	
	if carrying:
		carry.global_position = $pos_carry.global_position
	