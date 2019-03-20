extends Node2D

#Constants
const PLAYERSPEED = 350
const INITIALBALLSPEED = 200

#Variables
var screenSize
var pad_size
var boundary_size
var ballDirection = Vector2(-1, 0)
var ballSpeed = INITIALBALLSPEED
var leftScore = 0
var rightScore = 0
var boundary_health = 2
var left_player_boundary_left
var left_player_boundary_right
var right_player_boundary_left
var right_player_boundary_right


func _ready():
	screenSize = get_viewport_rect().size
	pad_size = get_node("left").get_texture().get_size()
	boundary_size = get_node("boundary").get_texture().get_size()
	left_player_boundary_left = screenSize.x / 18
	left_player_boundary_right = screenSize.y * 0.64
	right_player_boundary_left = screenSize.x * 0.6
	right_player_boundary_right = screenSize.x
	
	pass

func _process(delta):
	#Ball Position
	var ballPosition = get_node("ball").get_position()
	
	#Colliders
	var left_collider = Rect2( get_node("left").get_position() - pad_size*0.5, pad_size )
	var right_collider = Rect2( get_node("right").get_position() - pad_size*0.5, pad_size )
	var boundary_collider = Rect2(Vector2(0,0),Vector2(0,0))
	var boundary =  get_node("boundary")
	if boundary:
		boundary_collider = Rect2( get_node("boundary").get_position() - pad_size*0.5, pad_size )
	

	#if( get_node("boundary") != null ):
		#boundary_collider = Rect2( get_node("boundary").get_position() - pad_size*0.5, pad_size )
	
	
	# Integrate new ball position
	ballPosition += ballDirection * ballSpeed * delta
	
	# Flip when touching roof or floor
	if ((ballPosition.y < 0 and ballDirection.y < 0) or (ballPosition.y > screenSize.y and ballDirection.y > 0)):
    	ballDirection.y = -ballDirection.y
	
	# Flip, change direction and increase speed when touching pads
	if ((left_collider.has_point(ballPosition) and ballDirection.x < 0) or (right_collider.has_point(ballPosition) and ballDirection.x > 0)):
		ballDirection.x = -ballDirection.x
		ballDirection.y = randf()*2.0 - 1
		ballDirection = ballDirection.normalized()
		ballSpeed *= 1.1
		
	#Decrease boundary health and change direction when ball touches boundary
	if ((boundary_collider.has_point(ballPosition) and ballDirection.x < 0) or (boundary_collider.has_point(ballPosition) and ballDirection.x > 0)):
		boundary_health -= 1
		get_node("boundary").texture = load("res://red.png")
		ballDirection.x = -ballDirection.x
		ballDirection.y = randf()*2.0 - 1
		ballDirection = ballDirection.normalized()
		ballSpeed *= 1.1
		
	if(boundary_health == 0) and boundary:
			get_node("boundary").queue_free()	
	
		
	# Check gameover
	if (ballPosition.x > screenSize.x):
		ballPosition = screenSize*0.5
		ballSpeed = INITIALBALLSPEED
		ballDirection = Vector2(1, 0)
		leftScore += 1
	
	if(ballPosition.x < 0):
		ballPosition = screenSize*0.5
		ballSpeed = INITIALBALLSPEED
		ballDirection = Vector2(-1, 0)
		rightScore += 1
	
	#variables for the player positions
	var leftPlayerPosition = get_node("left").get_position()
	var rightPlayerPosition = get_node("right").get_position()
	
	#Check inputs and move the players
	if(leftPlayerPosition.y > 0 and Input.is_action_pressed('left_up')):
		leftPlayerPosition.y += -PLAYERSPEED * delta
	if(leftPlayerPosition.y < screenSize.y and Input.is_action_pressed('left_down')):
		leftPlayerPosition.y += PLAYERSPEED * delta
	if(leftPlayerPosition.x > left_player_boundary_left and Input.is_action_pressed('ui_left')):
		leftPlayerPosition.x += -PLAYERSPEED * delta
	if(leftPlayerPosition.x < left_player_boundary_right and Input.is_action_pressed('ui_right')):
		leftPlayerPosition.x += PLAYERSPEED * delta
		
	if(rightPlayerPosition.y > 0 and Input.is_action_pressed('right_up')):
		rightPlayerPosition.y += -PLAYERSPEED * delta
	if(rightPlayerPosition.y < screenSize.y and Input.is_action_pressed('right_down')):
		rightPlayerPosition.y += PLAYERSPEED * delta
	if(rightPlayerPosition.x > right_player_boundary_left and Input.is_action_pressed('left')):
		rightPlayerPosition.x += -PLAYERSPEED * delta
	if(rightPlayerPosition.x < right_player_boundary_right and Input.is_action_pressed('right')):
		rightPlayerPosition.x += PLAYERSPEED * delta
	
	#Change the nodes' positions after inputs
	get_node("left").set_position(leftPlayerPosition)
	get_node("right").set_position(rightPlayerPosition)
	get_node("ball").set_position(ballPosition)
	
	#Update the scores
	get_node("leftScore").set_text(str(leftScore))
	get_node("rightScore").set_text(str(rightScore))
	
