extends RigidBody2D

onready var speed = 70 * self.gravity_scale
onready var score = 0
var reset

# Called when the node enters the scene tree for the first time.
func _ready():
	initBall()
	
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		if self.mode != RigidBody2D.MODE_RIGID: #If the game hasn't started, start it
			self.mode = RigidBody2D.MODE_RIGID
		bounceOnTouch(self, event)
			

func bounceOnTouch(ball, event):
	var direction = (ball.position - event.position).normalized() #calculate the vector between cursor and ball center
	if direction[1] <= 0: #if the vector points towards the top
		ball.apply_impulse(direction, direction*speed)
		updateScore()
		

func updateScore():
	score += 1 
	get_node('../Tree/Score').set_text(str(score))
	
func initBall():
	self.mode = RigidBody2D.MODE_STATIC
	var window_size = OS.get_window_size()
	var ball_size = get_node("BallCollisionShape/BallImage").texture.get_size()
	var xpos = window_size[0]/2
	var ypos = window_size[1] - ball_size[1]/2
	
	self.position = Vector2(xpos,ypos)
