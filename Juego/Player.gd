extends Area2D

signal hit

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var moving_right = false
var moving_left=false
var moving_up=false
var moving_down=false

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed(&"move_right"):
		velocity.x += 1
	if Input.is_action_pressed(&"move_left"):
		velocity.x -= 1
	if Input.is_action_pressed(&"move_down"):
		velocity.y += 1
	if Input.is_action_pressed(&"move_up"):
		velocity.y -= 1
	if moving_right:
		velocity.x += 1
		
	if moving_left:
		velocity.x -= 1
	if moving_up:
		position.y += speed * delta
	if moving_down:
		position.y -= speed * delta

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		# See the note below about boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x < 0
		
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0

func start(pos):
	position = pos
	rotation = 0
	show()
	$CollisionShape2D.disabled = false


func _on_body_entered(_body):
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)


func _on_button_pressed():
	moving_right = true
	moving_left=false
	moving_down=false
	moving_up=false


func _on_button_2_pressed():
	moving_right = false
	moving_left=true
	moving_down=false
	moving_up=false





func _on_button_3_pressed():
	moving_right = false
	moving_left=false
	moving_down=true
	moving_up=false



func _on_button_4_pressed():
	moving_right = false
	moving_left=false
	moving_down=false
	moving_up=true

