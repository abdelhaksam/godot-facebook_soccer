extends RigidBody2D

# Constants
onready var SPEED = 70 * self.gravity_scale
onready var BALL_SIZE = get_node("BallCollisionShape/BallImage").texture.get_size()
onready var WINDOW_SIZE = OS.get_window_size()

#Variables
onready var score = 0
onready var highScore = 0

#Nodes
onready var ScoreLabel = get_node('../ScoreLabel')
onready var ScoreDisplay = get_node('../Score')

# Called when the node enters the scene tree for the first time.
func _ready():
	initGame()
	
func _process(delta):
	detectOnPlayfield(self)


func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		print(event)
		if self.mode != RigidBody2D.MODE_RIGID: #If the game hasn't started, start it
			self.mode = RigidBody2D.MODE_RIGID
			ScoreLabel.hide()
			ScoreDisplay.add_color_override("font_color", Color('#333'))
		bounceOnTouch(self, event)


func bounceOnTouch(ball, event):
	var direction = (ball.position - event.position).normalized() #calculate the vector between cursor and ball center
	if direction[1] <= 0: #if the vector points towards the top
		ball.apply_impulse(direction, direction*SPEED)
		updateScore()
		

func updateScore():
	score += 1 
	ScoreDisplay.set_text(str(score))
	
func initGame():
	initBallPosition()
	if score > highScore:
		highScore = score
	ScoreDisplay.set_text(str(highScore))
	ScoreDisplay.add_color_override("font_color", Color('#00a6ff'))
	ScoreLabel.show()
	score = 0
	

func initBallPosition():
	self.mode = RigidBody2D.MODE_STATIC #make the body static
	var xpos = WINDOW_SIZE[0]/2
	var ypos = WINDOW_SIZE[1] - BALL_SIZE[1]/2
	
	self.transform = Transform2D(0.0,Vector2(xpos,ypos))

func detectOnPlayfield(node):
	if !get_node("BallCollisionShape/BallImage/VisibilityNotifier2D").is_on_screen():
		if node.position[1]>WINDOW_SIZE[1]+BALL_SIZE[1]:
			initGame()

