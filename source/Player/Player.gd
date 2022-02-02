extends Area2D

signal hit
# How fast the player will move (pixels/sec).
export var speed = 400 
# Size of the game window.
var screen_size 


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()

#is called every frame
func _process(delta):
	# The player's movement vector.
	var velocity = Vector2.ZERO 
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()

	position_change(velocity,delta)
	walk_animation_change(velocity)
	
func position_change(velocity,delta):
	var player_height = $AnimatedSprite.frames.get_frame("walk",0).get_height()
	var player_width = $AnimatedSprite.frames.get_frame("walk",0).get_width()
	var player_scale = $AnimatedSprite.scale.x
	var player_size_x = (player_width*player_scale)/2
	var playeR_size_y =	(player_height*player_scale)/2
	position += velocity * delta
	position.x = clamp(position.x, 0+player_size_x, screen_size.x-player_size_x)
	position.y = clamp(position.y, 0+playeR_size_y, screen_size.y-playeR_size_y)		

func walk_animation_change(velocity):
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0


func _on_Player_body_entered(_body):
	# Player disappears after being hit.
	hide()
	emit_signal("hit")
	# tells Godot to wait to disable the shape 
	#until it's safe to do so.
	$CollisionShape2D.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
