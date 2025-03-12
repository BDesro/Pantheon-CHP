class_name AIController
extends BaseController


#var cur_state: AIState = null
#enum AIStateType {
	#IDLE,
	#CHASE,
	#ATTACK,
	#FLEE
#}
#
#func _ready():
	#super._ready()
	#
	#change_state(AIStateType.IDLE)
	#move_requested.connect(character.move_unit)
	#ability_requested.connect(character.use_ability)
#
#func change_state(state_type: AIStateType):
	#if cur_state:
		#cur_state.exit
	#
	#match state_type:
		#AIStateType.IDLE:
			#cur_state = IdleState.new()
		#AIStateType.CHASE:
			#cur_state = ChaseState.new()
		#AIStateType.ATTACK:
			#cur_state = AttackState.new()
		#AIStateType.FLEE:
			#cur_state = FleeState.new()
	#
	#cur_state.enter()
#
#func _process(delta):
	#if cur_state:
		#cur_state.update(delta)
