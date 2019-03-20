extends KinematicBody2D

export var speed = 3
var velocity = Vector2(0,0)
var current_x_direction = 0
var current_y_direction = 0
var last_direction = 0
export(Curve) var attack_curve

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	velocity.x = 0
	velocity.y = 0
	
	if Input.is_key_pressed(KEY_RIGHT):
		current_x_direction = 1
	if Input.is_key_pressed(KEY_LEFT):
		current_x_direction = -1
	if Input.is_key_pressed(KEY_UP):
		current_y_direction = -1
	if Input.is_key_pressed(KEY_DOWN):
		current_y_direction = 1
	
	
	velocity.x = current_x_direction*speed*attack_curve.interpolate(1)
	velocity.y = current_y_direction*speed*attack_curve.interpolate(1)
	
	move_and_collide(velocity)