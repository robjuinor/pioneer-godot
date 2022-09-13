extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var texto = ''

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta): 
	texto += '\n FPS = ' + str(1/(delta+10e-20))
	texto += '\n theta_R = ' + str($robo.global_rotation_degrees) + 'graus'
	# texto += '\n velocidade x = ' + str($robo.dirR.x)
	# texto += '\n velocidade y = ' + str($robo.dirR.y)
	texto += '\n velocidade linear = ' + str($robo.dirR.length())
	#texto += '\n posRLocal = ' + str($robo.position)
	texto += '\n posR x = ' + str($robo.position.x)
	texto += '\n posR y = ' + str($robo.position.y)
	texto += '\n posRgloball = ' + str($robo.global_position)
	texto += '\n posGoal = ' + str($Fundo/Objetivo.global_position)
	
	$Status.set_text(texto)
	texto = ''
