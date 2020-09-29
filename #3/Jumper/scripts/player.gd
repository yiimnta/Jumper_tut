extends KinematicBody2D

var audio_jump = load("res://sounds/jump.wav")

var velocity = Vector2.ZERO
var speed = 90

var jump_height = 65
var time_jump_apex = 0.4
var gravity
var jump_force

var on_ground = false

func _ready():
	pass

func _physics_process(delta):
	
	gravity = (2 * jump_height) / pow(time_jump_apex,2)
	jump_force = gravity * time_jump_apex
	
	velocity.y += gravity * delta
	
	if Input.is_action_pressed("move_left"):
		velocity.x = -speed
		$animation.flip_h = true
		$animation.play("run")
	elif Input.is_action_pressed("move_right"):
		velocity.x = speed
		$animation.flip_h = false
		$animation.play("run")
	else:
		velocity.x = 0
		$animation.play("idle")
	
	if Input.is_action_just_pressed("jump"):
		if on_ground:
			velocity.y = -jump_force
			on_ground = false
			$audio.stream = audio_jump
			$audio.play()
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if is_on_floor():
		on_ground = true
	else:
		on_ground = false
		if velocity.y < 0: 
			$animation.play("jump")
		else:
			$animation.play("fall")	

	pass
