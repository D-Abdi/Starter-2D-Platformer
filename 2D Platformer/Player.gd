extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 20
const MAX_FALL_SPEED =  200
const MOVE_SPEED = 200
const JUMP_FORCE = 300
const ACCEL = 10

var state_machine 
var motion = Vector2()
var facing_right = true

func _ready() -> void:
	state_machine = $AnimationTree.get("parameters/playback")

func _physics_process(delta: float) -> void:
	get_input()
	motion.y += GRAVITY
	if motion.y > MAX_FALL_SPEED:
		motion.y = MAX_FALL_SPEED
		
	motion.x = clamp(motion.x, -MOVE_SPEED, MOVE_SPEED)
	
	motion = move_and_slide(motion, UP)
	
	
func get_input():
	var _current = state_machine.get_current_node()
	if Input.is_action_just_pressed("attack1.0"):
		state_machine.travel("light")
		print("attack1")
		return
	if Input.is_action_just_pressed("attack2.0"):
		state_machine.travel("strong")
		print("attack2")
		return
	if Input.is_action_pressed("move_left"):
		motion.x -= ACCEL
		facing_right = false
		state_machine.travel("run")
	elif Input.is_action_pressed("move_right"):
		motion.x += ACCEL
		facing_right = true
		state_machine.travel("run")
	else:
		motion.x = lerp(motion.x, 0,0.2)
		state_machine.travel("idle")
		
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			motion.y = -JUMP_FORCE
			
	if !is_on_floor():
		if motion.y < 0:
			state_machine.travel("jump")
			
	if facing_right == true:
		$Sprite.scale.x = 1
	else:
		$Sprite.scale.x = -1

func _on_SwordHit_area_entered(area: Area2D) -> void:
	if area.is_in_group("hurtbox"):
		 area.take_damage()
