extends KinematicBody2D

var audio_jump = load("res://sounds/jump.wav")

var velocity = Vector2.ZERO
var speed = 90

var jump_height = 65
var time_jump_apex = 0.4
var gravity
var jump_force

var on_ground = false
var can_double_jump = false
var is_double_jumping = false

func _ready():
	pass

func _physics_process(delta):
	
	gravity = (2 * jump_height) / pow(time_jump_apex,2)
	jump_force = gravity * time_jump_apex
	
	velocity.y += gravity * delta
	
	if Input.is_action_pressed("move_left"):
		velocity.x = -speed
		$animation.flip_h = true
	elif Input.is_action_pressed("move_right"):
		velocity.x = speed
		$animation.flip_h = false
	else:
		velocity.x = 0
	
	if Input.is_action_just_pressed("jump"):
		if on_ground:
			if $check_platform.is_colliding() and Input.is_action_pressed("move_down"):
				set_collision_mask_bit(2, false)
			else:
				velocity.y = -jump_force
				on_ground = false
				$audio.stream = audio_jump
				$audio.play()
				can_double_jump = true #dc phep nhay 2 lan
		else:#on_ground = false
			if can_double_jump:
				velocity.y = -jump_force
				can_double_jump = false
				is_double_jumping = true
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if is_on_floor():
		on_ground = true
		can_double_jump = false
		is_double_jumping = false
		
		if velocity.x == 0:
			$animation.play("idle")
		else:
			$animation.play("run")
	else:
		on_ground = false
		if velocity.y < 0:
			if is_double_jumping:
				$animation.play("doubleJump")
			else:
				$animation.play("jump")
		else:
			$animation.play("fall")	

	pass


func _on_Area2D_body_exited(body):
	set_collision_mask_bit(2, true)
	pass
