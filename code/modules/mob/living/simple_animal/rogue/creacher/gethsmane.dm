/mob/living/simple_animal/hostile/retaliate/rogue/bigrat/gethsmane
	name = "fretensis"
	health = 100
	maxHealth = 100
	STASTR = 8
	STASPD = 13
	retreat_health = 0
	defprob = 20
	color = "#485775"
	attack_same = 0

	AIStatus = AI_OFF
	can_have_ai = FALSE
	ai_controller = /datum/ai_controller/fretensis

/mob/living/simple_animal/hostile/retaliate/rogue/bigrat/gethsmane/AttackingTarget()
	. = ..()
	if(. && isliving(target))
		var/mob/living/L = target
		if(L.reagents)
			L.reagents.add_reagent(/datum/reagent/toxin/spewium, 3) //this won't do much til u get 29u then uhhh bye lol

