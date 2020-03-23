extends RigidBody2D

onready var speed = 70 * self.gravity_scale
onready var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		if self.is_sleeping(): #If the game hasn't started, start it
			self.set_sleeping(false)
		bounceOnTouch(self, event)
			

func bounceOnTouch(ball, event):
	var direction = (ball.position - event.position).normalized() #calculate the vector between cursor and ball center
	if direction[1] <= 0: #if the vector points towards the top
		ball.apply_impulse(direction, direction*speed)
		updateScore()
		

func updateScore():
	score += 1 
	get_node('../Tree/Score').set_text(str(score))
	
