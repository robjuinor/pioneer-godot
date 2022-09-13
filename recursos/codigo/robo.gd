extends KinematicBody2D


# Declare member variables here. Examples:
# Configuracoes do robo
export var Vmax = 4
export var Wmax = 60  # (em graus/s)
export var sensrange = 200
export var desviop_sensor = 5

# Variaveis sistema de navegacao
var posR
var thetaR
var dirR  #Para utilizar na funcao de movimento
var dmin  #Distancia ao obstaculo mais proximo
var angmin  #angulo à distancia mais proxima
export var kV = 0.004
export var kW = 2
var V
var W 
var dobj
# var theta_obj
var theta_e_obj
var pos_obj
var d
var theta_d

########################### Variaveis para o sistema de teste##################
const sat_kobj = 0.01
const k1 = 1
const k2 = -15
const k3 = -80/PI
const k4 = 1.75
const k5 = -1
const k6 = 5.5
var kobs
var kobj
var theta_obs
var vetlsens
var theta_e_obs
var kparalelo
var Vobj
var Vobs
var Vtheta_obs
var Vtheta_obj
var Wobj
var Wtheta_obs
###############################################################################


# Variaveis dos sensores
var vetsensrangeliq
var vetangsens
#Range indicado pelo sensor depois da leitura:
var sensrangeliq1;  var sensrangeliq2; var sensrangeliq3; var sensrangeliq4; var sensrangeliq5;  var sensrangeliq6; var sensrangeliq7; var sensrangeliq8; var sensrangeliq9;  var sensrangeliq10; var sensrangeliq11; var sensrangeliq12; var sensrangeliq13;  var sensrangeliq14; var sensrangeliq15; var sensrangeliq16; 
# Leitura:
var lsens1; var lsens2; var lsens3; var lsens4; var lsens5; var lsens6; var lsens7; var lsens8; var lsens9; var lsens10; var lsens11; var lsens12; var lsens13; var lsens14; var lsens15; var lsens16; 
var rng = RandomNumberGenerator.new()
var angsens1; var angsens2; var angsens3; var angsens4; var angsens5; var angsens6; var angsens7; var angsens8; var angsens9; var angsens10; var angsens11; var angsens12; var angsens13; var angsens14; var angsens15; var angsens16; 
var ruido1; var ruido2; var ruido3; var ruido4; var ruido5; var ruido6; var ruido7; var ruido8; var ruido9; var ruido10; var ruido11; var ruido12; var ruido13; var ruido14; var ruido15; var ruido16

# Called when the node enters the scene tree for the first time.
func _ready():
	# Status inicial do robo
	posR = self.position
	thetaR = self.global_rotation
	dirR = Vector2(1,0).rotated(thetaR)
	
	# variaveis de navegacao
	V = 0
	W = 0
	Wmax = W * 0.01666  # (em graus/s * delta)
	pos_obj = get_node("..").get_node("Fundo/Objetivo").global_position

	# Setando leitura dos sensores:
	sensrangeliq1 = sensrange
	sensrangeliq2 = sensrange
	sensrangeliq3 = sensrange
	sensrangeliq4 = sensrange
	sensrangeliq5 = sensrange
	sensrangeliq6 = sensrange
	sensrangeliq7 = sensrange
	sensrangeliq8 = sensrange
	sensrangeliq9 = sensrange
	sensrangeliq10 = sensrange
	sensrangeliq11 = sensrange
	sensrangeliq12 = sensrange
	sensrangeliq13 = sensrange
	sensrangeliq14 = sensrange
	sensrangeliq15 = sensrange
	sensrangeliq16 = sensrange
	$Ondas/OndaSens1.enabled = true
	$Ondas/OndaSens2.enabled = true
	$Ondas/OndaSens3.enabled = true
	$Ondas/OndaSens4.enabled = true
	$Ondas/OndaSens5.enabled = true
	$Ondas/OndaSens6.enabled = true
	$Ondas/OndaSens7.enabled = true
	$Ondas/OndaSens8.enabled = true
	$Ondas/OndaSens9.enabled = true
	$Ondas/OndaSens10.enabled = true
	$Ondas/OndaSens11.enabled = true
	$Ondas/OndaSens12.enabled = true
	$Ondas/OndaSens13.enabled = true
	$Ondas/OndaSens14.enabled = true
	$Ondas/OndaSens15.enabled = true
	$Ondas/OndaSens16.enabled = true
	# Angulo inicial dos sensores:
	angsens1 = ($Sensores/sens1.global_position - posR).angle() - thetaR
	angsens2 = ($Sensores/sens2.global_position - posR).angle() - thetaR
	angsens3 = ($Sensores/sens3.global_position - posR).angle() - thetaR
	angsens4 = ($Sensores/sens4.global_position - posR).angle() - thetaR
	angsens5 = ($Sensores/sens5.global_position - posR).angle() - thetaR
	angsens6 = ($Sensores/sens6.global_position - posR).angle() - thetaR
	angsens7 = ($Sensores/sens7.global_position - posR).angle() - thetaR
	angsens8 = ($Sensores/sens8.global_position - posR).angle() - thetaR
	angsens9 = ($Sensores/sens9.global_position - posR).angle() - thetaR
	angsens10 = ($Sensores/sens10.global_position - posR).angle() - thetaR
	angsens11 = ($Sensores/sens11.global_position - posR).angle() - thetaR
	angsens12 = ($Sensores/sens12.global_position - posR).angle() - thetaR
	angsens13 = ($Sensores/sens13.global_position - posR).angle() - thetaR
	angsens14 = ($Sensores/sens14.global_position - posR).angle() - thetaR
	angsens15 = ($Sensores/sens15.global_position - posR).angle() - thetaR
	angsens16 = ($Sensores/sens16.global_position - posR).angle() - thetaR
	
	vetangsens = [angsens1, angsens2, angsens3, angsens4, angsens5, angsens6, angsens7, angsens8, angsens9, angsens10, angsens11, angsens12, angsens13, angsens14, angsens15, angsens16]
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Atualizacao do robo:
	posR = self.position
	thetaR = self.global_rotation
	d = (pos_obj - posR).length()
	
	# Sensores:
	# Leitura de obstáculos
	lsens1 = $Ondas/OndaSens1.get_collision_point()
	if $Ondas/OndaSens1.is_colliding():
		sensrangeliq1 = (lsens1 - posR).length()
	else:
		sensrangeliq1 = sensrange
		
	lsens2 = $Ondas/OndaSens2.get_collision_point()
	if $Ondas/OndaSens2.is_colliding():
		sensrangeliq2 = (lsens2 - posR).length()
	else:
		sensrangeliq2 = sensrange
		
	lsens3 = $Ondas/OndaSens3.get_collision_point()
	if $Ondas/OndaSens3.is_colliding():
		sensrangeliq3 = (lsens3 - posR).length()
	else:
		sensrangeliq3 = sensrange
	
	lsens4 = $Ondas/OndaSens4.get_collision_point()
	if $Ondas/OndaSens4.is_colliding():
		sensrangeliq4 = (lsens4 - posR).length()
	else:
		sensrangeliq4 = sensrange
		
	lsens5 = $Ondas/OndaSens5.get_collision_point()
	if $Ondas/OndaSens5.is_colliding():
		sensrangeliq5 = (lsens5 - posR).length()
	else:
		sensrangeliq5 = sensrange
		
	lsens6 = $Ondas/OndaSens6.get_collision_point()
	if $Ondas/OndaSens6.is_colliding():
		sensrangeliq6 = (lsens6 - posR).length()
	else:
		sensrangeliq6 = sensrange
		
	lsens7 = $Ondas/OndaSens7.get_collision_point()
	if $Ondas/OndaSens7.is_colliding():
		sensrangeliq7 = (lsens7 - posR).length()
	else:
		sensrangeliq7 = sensrange
	
	lsens8 = $Ondas/OndaSens8.get_collision_point()
	if $Ondas/OndaSens8.is_colliding():
		sensrangeliq8 = (lsens8 - posR).length()
	else:
		sensrangeliq8 = sensrange
		
	lsens9 = $Ondas/OndaSens9.get_collision_point()
	if $Ondas/OndaSens9.is_colliding():
		sensrangeliq9 = (lsens9 - posR).length()
	else:
		sensrangeliq9 = sensrange
		
	lsens10 = $Ondas/OndaSens10.get_collision_point()
	if $Ondas/OndaSens10.is_colliding():
		sensrangeliq10 = (lsens10 - posR).length()
	else:
		sensrangeliq10 = sensrange
		
	lsens11 = $Ondas/OndaSens11.get_collision_point()
	if $Ondas/OndaSens11.is_colliding():
		sensrangeliq11 = (lsens11 - posR).length()
	else:
		sensrangeliq11 = sensrange
	
	lsens12 = $Ondas/OndaSens12.get_collision_point()
	if $Ondas/OndaSens12.is_colliding():
		sensrangeliq12 = (lsens12 - posR).length()
	else:
		sensrangeliq12 = sensrange
	
	lsens13 = $Ondas/OndaSens13.get_collision_point()
	if $Ondas/OndaSens13.is_colliding():
		sensrangeliq13 = (lsens13 - posR).length()
	else:
		sensrangeliq13 = sensrange
		
	lsens14 = $Ondas/OndaSens14.get_collision_point()
	if $Ondas/OndaSens14.is_colliding():
		sensrangeliq14 = (lsens14 - posR).length()
	else:
		sensrangeliq14 = sensrange
		
	lsens15 = $Ondas/OndaSens15.get_collision_point()
	if $Ondas/OndaSens15.is_colliding():
		sensrangeliq15 = (lsens15 - posR).length()
	else:
		sensrangeliq15 = sensrange
	
	lsens16 = $Ondas/OndaSens16.get_collision_point()
	if $Ondas/OndaSens16.is_colliding():
		sensrangeliq16 = (lsens16 - posR).length()
	else:
		sensrangeliq16 = sensrange
		
	# Vetor de leituras Vector2
	vetlsens = [lsens1, lsens2, lsens3, lsens4, lsens5, lsens6, lsens7, lsens8, lsens9, lsens10, lsens11, lsens12, lsens13, lsens14, lsens15, lsens16]
	
	# Calculo de posição da luz de teste
	ruido1 = rng.randfn(0, desviop_sensor)
	ruido2 = rng.randfn(0, desviop_sensor)
	ruido3 = rng.randfn(0, desviop_sensor)
	ruido4 = rng.randfn(0, desviop_sensor)
	ruido5 = rng.randfn(0, desviop_sensor)
	ruido6 = rng.randfn(0, desviop_sensor)
	ruido7 = rng.randfn(0, desviop_sensor)
	ruido8 = rng.randfn(0, desviop_sensor)
	ruido9 = rng.randfn(0, desviop_sensor)
	ruido10 = rng.randfn(0, desviop_sensor)
	ruido11 = rng.randfn(0, desviop_sensor)
	ruido12 = rng.randfn(0, desviop_sensor)
	ruido13 = rng.randfn(0, desviop_sensor)
	ruido14 = rng.randfn(0, desviop_sensor)
	ruido15 = rng.randfn(0, desviop_sensor)
	ruido16 = rng.randfn(0, desviop_sensor)
	$Luzes/luzs1.global_position = posR + Vector2(1,0).rotated(angsens1 + thetaR).normalized() * (sensrangeliq1 + ruido1)
	$Luzes/luzs2.global_position = posR + Vector2(1,0).rotated(angsens2 + thetaR).normalized() * (sensrangeliq2 + ruido2)
	$Luzes/luzs3.global_position = posR + Vector2(1,0).rotated(angsens3 + thetaR).normalized() * (sensrangeliq3 + ruido3)
	$Luzes/luzs4.global_position = posR + Vector2(1,0).rotated(angsens4 + thetaR).normalized() * (sensrangeliq4 + ruido4)
	$Luzes/luzs5.global_position = posR + Vector2(1,0).rotated(angsens5 + thetaR).normalized() * (sensrangeliq5 + ruido5)
	$Luzes/luzs6.global_position = posR + Vector2(1,0).rotated(angsens6 + thetaR).normalized() * (sensrangeliq6 + ruido6)
	$Luzes/luzs7.global_position = posR + Vector2(1,0).rotated(angsens7 + thetaR).normalized() * (sensrangeliq7 + ruido7)
	$Luzes/luzs8.global_position = posR + Vector2(1,0).rotated(angsens8 + thetaR).normalized() * (sensrangeliq8 + ruido8)
	$Luzes/luzs9.global_position = posR + Vector2(1,0).rotated(angsens9 + thetaR).normalized() * (sensrangeliq9 + ruido9)
	$Luzes/luzs10.global_position = posR + Vector2(1,0).rotated(angsens10 + thetaR).normalized() * (sensrangeliq10 + ruido10)
	$Luzes/luzs11.global_position = posR + Vector2(1,0).rotated(angsens11 + thetaR).normalized() * (sensrangeliq11 + ruido11)
	$Luzes/luzs12.global_position = posR + Vector2(1,0).rotated(angsens12 + thetaR).normalized() * (sensrangeliq12 + ruido12)
	$Luzes/luzs13.global_position = posR + Vector2(1,0).rotated(angsens13 + thetaR).normalized() * (sensrangeliq13 + ruido13)
	$Luzes/luzs14.global_position = posR + Vector2(1,0).rotated(angsens14 + thetaR).normalized() * (sensrangeliq14 + ruido14)
	$Luzes/luzs15.global_position = posR + Vector2(1,0).rotated(angsens15 + thetaR).normalized() * (sensrangeliq15 + ruido15)
	$Luzes/luzs16.global_position = posR + Vector2(1,0).rotated(angsens16 + thetaR).normalized() * (sensrangeliq16 + ruido16)
	
	vetsensrangeliq = [sensrangeliq1 + ruido1, sensrangeliq2 + ruido2, sensrangeliq3 + ruido3, sensrangeliq4 + ruido4, sensrangeliq5 + ruido5, sensrangeliq6 + ruido6, sensrangeliq7 + ruido7, sensrangeliq8 + ruido8, sensrangeliq9 + ruido9, sensrangeliq10 + ruido10, sensrangeliq11 + ruido11, sensrangeliq12 + ruido12, sensrangeliq13 + ruido13, sensrangeliq14 + ruido14, sensrangeliq15 + ruido15, sensrangeliq16 + ruido16]
	dmin = vetsensrangeliq.min()
	# angmin = vetangsens.find(dmin)
	
	# Controle interativo: ####################################################
	# V = 0  # Em caso de nao usar os controle é preciso zerar velocidades a cada iteracao
	# W = 0  # Em caso de nao usar os controle é preciso zerar velocidades a cada iteracao
	self.global_rotation_degrees -= 6*(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	V = 6 * (Input.get_action_strength("speed"))
	
	# Sistema: ################################################################
	#
	dobj = pos_obj - posR
	theta_d = dobj.angle()
	
	dobj = dobj.length()
	theta_e_obj = theta_d - thetaR
	if theta_e_obj > PI: theta_e_obj = theta_e_obj - 2*PI
	if theta_e_obj < -PI: theta_e_obj = theta_e_obj + 2*PI
	
	theta_obs = (vetlsens.min() - posR).angle()
	theta_e_obs = theta_obs - thetaR
	if theta_e_obs > PI: theta_e_obs = theta_e_obs - 2*PI
	if theta_e_obs < -PI: theta_e_obs = theta_e_obs + 2*PI
	
	# V += kV * dobj
	# W = kW * (theta_e_obj)
	
	## Teste V1.0 #############################################################
	kobs = (sensrange - (dmin))/sensrange
	kobj = (sensrange - d)/sensrange
	#kobs = (500 - (dmin))/500
	if kobs < 0:
		kobs = 0
	if kobj < sat_kobj:
		kobj = sat_kobj
	kobj = kobj*10
	if theta_e_obs > 0:
		kparalelo = -PI/2
	else:
		kparalelo = +PI/2
	
	Vobj = k1*d
	if Vobj>80:
		Vobj = 80
	Vobs = k5*(80 - dmin)
	Vtheta_obs = k6*80*(abs(theta_e_obs)/PI)
	
	Vtheta_obj = k3*abs(theta_e_obj)
	
	V +=  ((Vobj + Vtheta_obj)*kobj + (Vobs + Vtheta_obs)*kobs)/(kobj+kobs)
	if V < 0:
		V = 0
	
	Wobj = k2*theta_e_obj
	Wtheta_obs = k4*(kparalelo - theta_e_obs)
	W = -(Wobj*kobj + Wtheta_obs*kobs)/(kobj + kobs)
	
	
	
	#Saturação:
	if V > Vmax:
		V = Vmax
#	if abs(W) > Wmax/delta:
#		W = Wmax/delta*W/abs(W)
	###########################################################################
	
	# Status
	#$Label.set_text('thd: %.0f' %(theta_d*180/PI) + ' thR: %.0f' %(thetaR*180/PI) + ' e:%.0f' %(theta_e_obj*180/PI))
	#$Label.set_text('thd: %s' %str(lsens4) + 'is: %s' %str($Ondas/OndaSens4.is_colliding()))
	#$Label.set_global_position(Vector2(500,400))
	# var rot = $Label.get_rotation()
	# $Label.set_text('dmin: %s' %str(dmin))
	
	
	# Controle de movimento:
	dirR = Vector2(1,0).rotated(thetaR)
	self.global_rotation_degrees += W
	self.move_and_collide(dirR*V)
	
	$Label.set_rotation(0)
