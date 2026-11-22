/datum/intent/shield/bash
	name = "bash"
	icon_state = "inbash"
	hitsound = list('sound/combat/shieldbash_wood.ogg')
	chargetime = 0
	penfactor = PEN_NONE
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR

/datum/intent/shield/bash/metal
	hitsound = list('sound/combat/parry/shield/metalshield (1).ogg')

/datum/intent/shield/block
	name = "block"
	icon_state = "inblock"
	tranged = 1 //we can't attack directly with this intent, but we can charge it
	tshield = 1
	chargetime = 1
	hitsound = list('sound/combat/shieldbash_wood.ogg')
	warnie = "shieldwarn"
	item_d_type = "blunt"

/datum/intent/shield/block/prewarning()
	if(!mastermob || mastermob.next_move > world.time)
		return
	if(last_prewarning_sound > world.time)
		return
	last_prewarning_sound = world.time + clickcd
	mastermob.visible_message(span_warning("[mastermob] raises [masteritem]!"))
	playsound(mastermob, pick('sound/combat/shieldraise.ogg'), 100, FALSE)

/datum/intent/shield/block/metal
	hitsound = list('sound/combat/parry/shield/metalshield (1).ogg')

/datum/intent/mace/smash/shield
	hitsound = list('sound/combat/shieldbash_wood.ogg')

/datum/intent/mace/smash/shield/metal
	hitsound = list('sound/combat/parry/shield/metalshield (1).ogg')

/datum/intent/mace/smash/shield/metal/great
	chargetime = 8
	chargedrain = 2
	hitsound = list('sound/combat/parry/shield/metalshield (1).ogg')

/datum/intent/effect/daze/shield
	hitsound = list('sound/combat/parry/shield/metalshield (1).ogg')

/obj/item/rogueweapon/shield/wood
	name = "wooden shield"
	desc = "A sturdy wooden shield. Will block anything you can imagine."
	icon_state = "woodsh"
	dropshrink = 0.8
	anvilrepair = /datum/skill/craft/carpentry
	coverage = 30
	max_integrity = 120
	heraldry_x_offset = 1
	heraldry_y_offset = -1 // 1px right and down to make it look centered

/obj/item/rogueweapon/shield/wood/deprived
	name = "ghastly shield"
	desc = "A frail looking amalgamation of planks. Yet somehow, the very wood itself seem to be filling you with resolve."
	icon_state = "deprived"
	coverage = 40
	max_integrity = 200
