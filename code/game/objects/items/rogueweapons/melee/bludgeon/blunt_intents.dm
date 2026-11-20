/datum/intent/mace/strike
	name = "strike"
	blade_class = BCLASS_BLUNT
	attack_verb = list("strikes", "hits")
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	chargetime = 0
	penfactor = PEN_NONE
	swingdelay = 0
	icon_state = "instrike"
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR

/datum/intent/mace/smash
	name = "smash"
	blade_class = BCLASS_SMASH
	attack_verb = list("smashes")
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	penfactor = PEN_NONE
	chargedrain = 1 // Slight stamina drain on use.
	chargetime = 5 // Half a second of charge for a bit of a warning.
	icon_state = "insmash"
	item_d_type = "blunt"
	desc = "A powerful blow that delivers Strength-scaling knockback and slowdown to the target. The amount of inflicted knockback scales off your Strength, ranging from X (1 tile) to XIV (4 tiles). </br>Cannot inflict any knockback or slowdown if your Strength is below X. </br>Cannot be used consecutively more than every 5 seconds on the same target. </br>Prone targets halve the knockback distance. </br>Not fully charging the attack limits knockback to 1 tile."
	var/maxrange = 4

/datum/intent/mace/smash/spec_on_apply_effect(mob/living/H, mob/living/user, params)
	var/chungus_khan_str = user.STASTR
	if(H.has_status_effect(/datum/status_effect/debuff/yeetcd))
		return // Recently knocked back, cannot be knocked back again yet
	if(chungus_khan_str < 10)
		return // Too weak to have any effect
	var/scaling = CLAMP((chungus_khan_str - 10), 1, maxrange)
	H.apply_status_effect(/datum/status_effect/debuff/yeetcd)
	H.Slowdown(scaling)
	// Copypasta from knockback proc cuz I don't want the math there
	var/knockback_tiles = scaling // 1 to 4 tiles based on strength
	if(H.resting)
		knockback_tiles = max(1, knockback_tiles / 2)
	if(user?.client?.chargedprog < 100)
		knockback_tiles = 1 // Minimal knockback on non-charged smash.
	var/turf/edge_target_turf = get_edge_target_turf(H, get_dir(user, H))
	if(istype(edge_target_turf))
		H.safe_throw_at(edge_target_turf, \
		knockback_tiles, \
		scaling, \
		user, \
		spin = FALSE, \
		force = H.move_force)
// Do not call handle_knockback like in knockback cuz that means it will hardstun.

/datum/intent/mace/smash/prewarning()
	if(!mastermob || mastermob.next_move > world.time)
		return
	if(last_prewarning_sound > world.time)
		return
	last_prewarning_sound = world.time + clickcd
	playsound(mastermob, pick('sound/combat/wooshes/blunt/wooshhuge (2).ogg'), 100, FALSE)

/datum/intent/mace/smash/lesser
	name = "one-handed smash" //Exclusive to Warhammers, and other mace-styled bludgeons that can only be wielded in one hand.
	desc = "A powerful blow that delivers Strength-scaling knockback and slowdown to the target. The amount of inflicted knockback scales off your Strength, ranging from X (1 tile) to XIII (3 tiles). </br>Cannot inflict any knockback or slowdown if your Strength is below X. </br>Cannot be used consecutively more than every 5 seconds on the same target. </br>Prone targets halve the knockback distance. </br>Not fully charging the attack limits knockback to 1 tile."
	maxrange = 3

/datum/intent/mace/demolish
	name = "break"
	desc = "A deliberate strike that is much more effective at demolishing structures."
	icon_state = "incrush"
	blade_class = BCLASS_SMASH
	attack_verb = list("demolishes", "crushes", "wrecks")
	animname = "strike"
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	item_d_type = "blunt"
	penfactor = PEN_NONE
	demolition_mod = 3
	clickcd = CLICK_CD_HEAVY
	swingdelay = 10

/datum/intent/mace/lesserdemolish
	name = "break"
	desc = "A deliberate structure-breaking blow. Deals triple the damage to structures"
	icon_state = "incrush"
	blade_class = BCLASS_SMASH
	attack_verb = list("demolishes", "crushes", "wrecks")
	animname = "strike"
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	item_d_type = "blunt"
	penfactor = PEN_NONE
	demolition_mod = 3
	clickcd = CLICK_CD_HEAVY
	swingdelay = 10

/datum/intent/mace/thrust
	name = "thrust"
	blade_class = BCLASS_STAB
	attack_verb = list("thrusts")
	animname = "stab"
	icon_state = "instab"
	reach = 1
	clickcd = CLICK_CD_CHARGED
	recovery = 30
	warnie = "mobwarning"
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = PEN_MEDIUM
	damfactor = 0.5
	item_d_type = "stab"
	swingdelay = 8

/datum/intent/mace/thrust/ranged
	reach = 1
	swingdelay = 8
	damfactor = 0.5

/datum/intent/mace/bash
	name = "bash"
	blade_class = BCLASS_BLUNT
	penfactor = PEN_NONE
	icon_state = "inbash"
	attack_verb = list("bashes", "strikes")
	damfactor = NONBLUNT_BLUNT_DAMFACTOR
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR

/datum/intent/mace/bash/ranged
	name = "handlestroke"
	reach = 2

/datum/intent/mace/strike/grand
	name = "heavy strike"
	damfactor = 1.1
	demolition_mod = 1.25

/datum/intent/mace/smash/grand
	name = "heavy smash"
	damfactor = 1.1
	demolition_mod = 1.25
	chargedrain = 1.5
	desc = "A powerful blow that delivers Strength-scaling knockback and slowdown to the target. The amount of inflicted knockback scales off your Strength, ranging from X (1 tile) to XV (5 tiles). </br>Cannot inflict any knockback or slowdown if your Strength is below X. </br>Cannot be used consecutively more than every 5 seconds on the same target. </br>Prone targets halve the knockback distance. </br>Not fully charging the attack limits knockback to 1 tile."
	maxrange = 5

/datum/intent/mace/smash/crush
	name = "crush"
	attack_verb = list("crushes")
	icon_state = "incrush"
	damfactor = 1.75
	demolition_mod = 1.25 //Deals 83 DMG when swung from the strongest Maul (at a base of 34 DMG) with XIV STR. For comparison, a Steel Flail (which can be one-handed and swung faster) deals 63 DMG under the same parameters.
	chargedrain = 1.8 //Note that the Maul series is hardlocked to characters that have abnormally high STR, and is otherwise physically unwieldable.
	chargetime = 10
	desc = "A titanic blow that delivers Strength-scaling knockback and slowdown to the target. The amount of inflicted knockback scales off your Strength, ranging from X (1 tile) to XV (5 tiles). </br>Actively drains stamina while being charged up. </br>Cannot inflict any knockback or slowdown if your Strength is below X. </br>Cannot be used consecutively more than every 5 seconds on the same target. </br>Prone targets halve the knockback distance. </br>Not fully charging the attack limits knockback to 1 tile."
	maxrange = 5

/datum/intent/mace/smash/crush/demolish
	name = "demolish"
	attack_verb = list("demolishes", "crushes", "wrecks")
	icon_state = "incrush"
	desc = "A titanic blow that delivers Strength-scaling knockback to living targets, and massive damage to structural targets. The amount of inflicted knockback scales off your Strength, ranging from X (1 tile) to XV (5 tiles). </br>Actively drains stamina while being charged up. </br>Cannot inflict any knockback or slowdown if your Strength is below X. </br>Cannot be used consecutively more than every 5 seconds on the same target. </br>Prone targets halve the knockback distance. </br>Not fully charging the attack limits knockback to 1 tile. </br>Against structures, each attack reduces at least 15% of its maximum integrity."
	demolition_mod = 3.5

/datum/intent/mace/strike/poleaxe
	damfactor = 1.2

//Wooden club-specific intents.
/datum/intent/mace/smash/wood/ranged
	reach = 1

/datum/intent/mace/strike/wood
	hitsound = list('sound/combat/hits/blunt/woodblunt (1).ogg', 'sound/combat/hits/blunt/woodblunt (2).ogg')
	penfactor = PEN_NONE

/datum/intent/mace/smash/wood
	hitsound = list('sound/combat/hits/blunt/woodblunt (1).ogg', 'sound/combat/hits/blunt/woodblunt (2).ogg')
	penfactor = PEN_NONE

/datum/intent/mace/smash/wood/stone
	desc = "A heavy blow. You're not knocking anyone back with this."

/datum/intent/mace/smash/wood/stone/spec_on_apply_effect(mob/living/H, mob/living/user, params)
	return

// Dazing-specific intents.
/datum/intent/effect/daze
	name = "dazing strike"
	desc = "A heavy strike that causes temporary disorientation, but only when successfully landed on the head. The slower follow-through makes it \
	harder to complete without risking an interruption."
	icon_state = "indaze"
	attack_verb = list("dazes")
	animname = "strike"
	hitsound = list('sound/combat/hits/blunt/daze_hit.ogg')
	penfactor = PEN_NONE
	swingdelay = 1 SECONDS
	damfactor = 1
	item_d_type = "blunt"
	intent_effect = /datum/status_effect/debuff/dazed
	target_parts = list(BODY_ZONE_HEAD)
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR
	candodge = FALSE
	canparry = FALSE
	swingdelay_type = SWINGDELAY_CANCEL

/datum/intent/effect/daze/ranged
	name = "ranged dazing strike"
	reach = 2

//Cudgel and Flanged Mace-specific intents.
/datum/intent/mace/strike/wallop
	name = "wallop" // Non-lethal mace-striking (Made for cudgel specifically. Don't put this on everything. Yeah, I mean you.)
	blade_class = BCLASS_TWIST	//I know, it's weird, but this lets you dislocate limbs and works fine w/ -100 pen factor of blunt weapons.
	attack_verb = list("twamps", "thwacks", "wallops")
	damfactor = 1.3		// High damage mod to give high chance of dislocation against unarmored targets.
	intent_intdamage_factor = 0.4	// Purposefully bad at damaging armor. Specifically deals -60% integrity damage, irregardless of the previous intent's modifiers.
	icon_state = "inthresh"	// Wallop is too long for a button; placeholder.
	desc = "A quick and sudden thwack that can cripple unarmored limbs with tremendous force. </br>Deals TWIST damage instead of BLUNT damage. Critical hits cause DISLOCATIONS, instead of FRACTURES. </br>DISLOCATED ARMS and HANDS cannot wield, grab, or use anything. </br>DISLOCATED LEGS and FEET prevent the target from standing."

/datum/intent/mace/strike/dislocate
	name = "dislocate" // (I'm evil. Slight swing delay.)
	blade_class = BCLASS_TWIST
	attack_verb = list("thwacks", "threshes")
	hitsound = list('sound/combat/hits/punch/punch_hard (1).ogg', 'sound/combat/hits/punch/punch_hard (2).ogg', 'sound/combat/hits/punch/punch_hard (3).ogg')
	damfactor = 1.25
	intent_intdamage_factor = 0.4 //Reduces integrity damage modifier from +60% to -60%.
	swingdelay = 6 //Slower than a strike, quicker than a chop or old-school smash.
	icon_state = "inthresh"
	desc = "A slow-swinging strike that can cripple unarmored limbs with tremendous force. </br>Deals TWIST damage instead of BLUNT damage. Critical hits cause DISLOCATIONS, instead of FRACTURES. </br>DISLOCATED ARMS and HANDS cannot wield, grab, or use anything. </br>DISLOCATED LEGS and FEET prevent the target from standing."

// Warhammer-specific intents.
/datum/intent/mace/warhammer/stab
	name = "thrust"
	icon_state = "instab"
	blade_class = BCLASS_STAB
	attack_verb = list("thrusts", "stabs")
	animname = "stab"
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	no_early_release = TRUE
	penfactor = PEN_LIGHT
	damfactor = 0.9
	item_d_type = "stab"

/datum/intent/mace/warhammer/stab/lesser
	name = "stab with saigaman's pick" //Exclusive to warhammers - and axes? - who don't have a vertical spike for thrusting, ala the Battle Axe.
	icon_state = "instab"
	blade_class = BCLASS_STAB
	attack_verb = list("thrusts", "stabs")
	animname = "stab"
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	no_early_release = TRUE
	penfactor = PEN_LIGHT
	damfactor = 0.8
	swingdelay = 4
	item_d_type = "stab"

/datum/intent/mace/warhammer/pick
	name = "impale with saigaman's pick"
	icon_state = "inpick"
	blade_class = BCLASS_PICK
	attack_verb = list("picks", "impales")
	animname = "stab"
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	misscost = 1
	swingdelay = 15
	clickcd = 15
	penfactor = PEN_BSTEEL
	damfactor = 0.9
	item_d_type = "stab"

// Lithmyc Mace-specific intents.
/datum/intent/mace/boom
	name = "boom"
	attack_verb = list("thumps", "fungal-strikes")
	icon_state = "inboom"
	item_d_type = "blunt"
	desc = "A specialized strike that releases spores. Landing 7 consecutive strikes within 75 seconds triggers a fungal explosion."
	damfactor = 1

/datum/component/mushroom_mace
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/hit_count = 0
	var/last_hit_time = 0
	var/reset_timeout = 75 SECONDS

/datum/component/mushroom_mace/Initialize(mapload)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(parent, COMSIG_ITEM_ATTACK_SUCCESS, PROC_REF(on_attack))

/datum/component/mushroom_mace/proc/on_attack(obj/item/source, mob/living/target, mob/living/user)
	SIGNAL_HANDLER

	if(!istype(user.used_intent, /datum/intent/mace/boom))
		return

	var/current_time = world.time

	// Reset hit count if it's been too long since the last successful hit.
	if(hit_count > 0 && (current_time - last_hit_time) > reset_timeout)
		hit_count = 1
		last_hit_time = current_time
		to_chat(user, span_infection("The mushroom mace starts pulsing."))

	hit_count++
	spawn(0)
		spawn_spore_clouds(target, user)

	if(hit_count == 4)
		playsound(user, 'sound/magic/magnet.ogg', 75)
		to_chat(user, span_userdanger("The mushroom mace is pulsing wildly!"))

	if(hit_count >= 5)
		spawn(0)
			mushroom_boom(target, user)
		hit_count = 0 // Reset after the big boom

/datum/component/mushroom_mace/proc/spawn_spore_clouds(mob/living/target, mob/living/user)
	var/turf/T = get_turf(target)
	var/dir_to_target = get_dir(user, target)

	var/list/target_turfs = list(T)
	target_turfs += get_step(T, dir_to_target)
	target_turfs += get_step(T, turn(dir_to_target, 90))
	target_turfs += get_step(T, turn(dir_to_target, -90))

	for(var/turf/cloud_turf in target_turfs)
		if(cloud_turf == get_turf(user))
			continue
		var/obj/effect/temp_visual/spore/old_spores = locate(/obj/effect/temp_visual/spore) in cloud_turf
		if(old_spores)
			qdel(old_spores)
		new /obj/effect/temp_visual/spore(cloud_turf)

/datum/component/mushroom_mace/proc/mushroom_boom(mob/living/target, mob/living/user)
	var/turf/T = get_turf(target)
	T.visible_message(span_boldwarning("The mushroom mace releases a massive fungal detonation!"))
	explosion(T, extreme_impact_range = 0, heavy_impact_range = 0, light_impact_range = 4, smoke = TRUE, soundin = pick('sound/misc/explode/explosion.ogg'))

	for(var/mob/living/L in range(2, T))
		var/damage = 25
		if(L == user)
			damage = 5 // User takes reduced damage
		L.apply_damage(damage, TOX)
		if(L != user && ishuman(L))
			var/mob/living/carbon/human/H = L
			H.Immobilize(15)
			H.apply_status_effect(/datum/status_effect/debuff/exposed)

/obj/effect/temp_visual/spore
	name = "spore"
	icon_state = "spores"
	duration = 16 SECONDS
	plane = GAME_PLANE_UPPER
	layer = ABOVE_ALL_MOB_LAYER
	var/damage_amount = 6

/obj/effect/temp_visual/spore/Initialize(mapload)
	. = ..()
	// Damage anyone already standing on the tile
	var/turf/T = get_turf(src)
	for(var/mob/living/L in T)
		apply_spore_damage(L)

/obj/effect/temp_visual/spore/Crossed(atom/movable/AM)
	. = ..()
	if(isliving(AM))
		apply_spore_damage(AM)

/obj/effect/temp_visual/spore/proc/apply_spore_damage(mob/living/L)
	if(L.stat == DEAD)
		return

	if(HAS_TRAIT(L, TRAIT_NOBREATH))
		return

	to_chat(L, span_danger("You breathe in the spiky spores!"))
	L.apply_damage(damage_amount, BRUTE)

//Maul-specific intents.
/datum/intent/mace/sweep
	name = "sweeping strike"
	icon_state = "insweep"
	blade_class = BCLASS_BLUNT
	attack_verb = list("sweeps through", "smashes across")
	animname = "strike"
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	penfactor = PEN_NONE
	chargetime = 0
	damfactor = 1.2
	demolition_mod = 1.25
	clickcd = CLICK_CD_GLACIAL
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR
	cleave = /datum/cleave_pattern/frontal_arc
	desc = "A heavy sweep that smashes through targets to the sides and front."

/datum/intent/effect/hobble
	name = "hobbling strike"
	desc = "A heavy strike aimed at the legs to cripple movement."
	icon_state = "incrack"//Temp. Just so it's easy to differentiate.
	attack_verb = list("hobbles")
	animname = "strike"
	hitsound = list('sound/combat/hits/blunt/shovel_hit3.ogg')
	swingdelay = 6
	damfactor = 0.8
	penfactor = PEN_NONE
	clickcd = CLICK_CD_HEAVY
	item_d_type = "blunt"
	intent_effect = /datum/status_effect/debuff/hobbled
	target_parts = list(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG) //Intentionally leaving out feet. If you know, you know.

/datum/intent/maul/spiked
	name = "perforating strike"
	blade_class = BCLASS_STAB
	attack_verb = list("rends", "hammers", "wallops")
	animname = "stab"
	icon_state = "intear"
	warnie = "mobwarning"
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	item_d_type = "stab"

// Whip-specific intents.
/datum/intent/whip/lash
	name = "lash"
	desc = "Lash the whip against a target from afar. </br>Uniquely deals lashing wounds, which inflicts tremendous blood loss and pain onto the target."
	blade_class = BCLASS_LASHING
	attack_verb = list("lashes", "cracks")
	hitsound = list('sound/combat/hits/blunt/flailhit.ogg')
	chargetime = 0
	recovery = 7
	penfactor = PEN_LIGHT
	reach = 3
	icon_state = "inlash"
	item_d_type = "slash"

/datum/intent/whip/lash/master
	name = "lash with dismembering force"
	desc = "Lash the whip against a target from afar, leveraging your strength to lash their limbs apart. </br>Critical hits can uniquely dismember limbs and cause disembowelements."
	blade_class = BCLASS_CUT
	attack_verb = list("deftly lashes", "sharply cracks")

/datum/intent/whip/crack
	name = "crack"
	desc = "Crack the whip's tip against a target, leaving terrible cuts in its wake. </br>Cracking can uniquely dismember limbs and cause disembowelments."
	blade_class = BCLASS_CUT				//Lets you dismember
	attack_verb = list("cracks", "strikes") //something something dwarf fotresss
	hitsound = list('sound/combat/hits/blunt/flailhit.ogg')
	chargetime = 0
	recovery = 10
	damfactor = 1.1
	penfactor = PEN_LIGHT
	reach = 2
	icon_state = "incrack"
	item_d_type = "slash"

/datum/intent/whip/crack/blunt
	name = "bludgeon"
	desc = "Wind up and deliver a powerful strike with the reinforced tip of your whip, shortening your reach but increasing the power. </br>Strikes deliver powerful blunt damage, lacking any cutting power but increasing damage against integrity."
	blade_class = BCLASS_BLUNT
	penfactor = PEN_NONE
	recovery = 6
	reach = 2			//Less range than a normal whip by 1 compared to crack.
	icon_state = "instrike"
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR

/datum/intent/flail/smash/ranged/psywhip
	name = "meteor strike"
	desc = "Swing the weight of your whip around your body, using the angular momentum to deliver a \
	devastating strike, propelling your enemy back and savaging them at the same time."
	chargedrain = 0 //The charge time is indicative of a warmup, not a hold.
	chargedloop = /datum/looping_sound/flailswing
	keep_looping = FALSE

/datum/intent/whip/punish
	name = "punish" //'Non-lethal'.
	desc = "Lash the whip against a target from afar. </br>Uniquely deals lashing wounds, which inflicts tremendous pain onto the target."
	blade_class = BCLASS_PUNISH
	attack_verb = list("lashes", "cracks")
	hitsound = list('sound/combat/hits/blunt/flailhit.ogg')
	chargetime = 0
	recovery = 5
	damfactor = 1.2							//No range, gets bonus damage - using this even on weak SHOULD let you get perma-scars then.
	penfactor = PEN_NONE		//No pen cus punishment intent.
	reach = 1								//No range, cus not meant to be a flat-out combat intent.
	icon_state = "inpunish"
	item_d_type = "slash"

//Flail-specific intents.
/datum/intent/flail/strike
	name = "flailing strike"
	blade_class = BCLASS_BLUNT
	attack_verb = list("strikes", "sweeps")
	hitsound = list('sound/combat/hits/blunt/flailhit.ogg')
	chargetime = 0
	damfactor = 1.1
	penfactor = PEN_NONE
	icon_state = "instrike"
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR

/datum/intent/flail/strike/ranged
	name = "ranged flailing strike"
	blade_class = BCLASS_BLUNT
	attack_verb = list("strikes", "sweeps")
	hitsound = list('sound/combat/hits/blunt/flailhit.ogg')
	chargetime = 0
	recovery = 15
	damfactor = 1.2 // Extra damage. Flail babe flail.
	penfactor = PEN_NONE
	clickcd = CLICK_CD_CHARGED // Higher delay for a powerful ranged attack
	reach = 2
	icon_state = "instrike"
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR

/datum/intent/flail/strike/ranged/matthios
	reach = 2

/datum/intent/flail/bash
	name = "bash with handle"
	icon_state = "inbash"
	attack_verb = list("handlewhips", "bashes", "strikes")
	animname = "strike"
	blade_class = BCLASS_BLUNT
	hitsound = list('sound/combat/hits/punch/punch_hard (1).ogg', 'sound/combat/hits/punch/punch_hard (2).ogg', 'sound/combat/hits/punch/punch_hard (3).ogg')
	penfactor = PEN_NONE
	chargetime = 0
	swingdelay = 0
	damfactor = 0.8
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR

/datum/intent/flail/smash
	name = "flailing smash"
	chargetime = 0.8 SECONDS
	chargedrain = 1.5 // Slightly more stamina to drain, like before.
	damfactor = 1.5 // Flail smash has higher damage due to a longer charge.
	chargedloop = /datum/looping_sound/flailswing
	keep_looping = TRUE
	icon_state = "insmash"
	blade_class = BCLASS_SMASH
	attack_verb = list("smashes")
	hitsound = list('sound/combat/hits/blunt/flailhit.ogg')
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR
	desc = "A tremendous swipe that delivers Strength-scaling knockback and slowdown to the target. The amount of inflicted knockback scales off your Strength, ranging from X (1 tile) to XIV (4 tiles). </br>Actively drains stamina while being charged up. </br>Cannot inflict any knockback or slowdown if your Strength is below X. </br>Cannot be used consecutively more than every 5 seconds on the same target. </br>Prone targets halve the knockback distance. </br>Not fully charging the attack limits knockback to 1 tile."
	var/maxrange = 4

/datum/intent/flail/smash/spec_on_apply_effect(mob/living/H, mob/living/user, params)
	var/chungus_khan_str = user.STASTR
	if(H.has_status_effect(/datum/status_effect/debuff/yeetcd))
		return // Recently knocked back, cannot be knocked back again yet
	if(chungus_khan_str < 10)
		return // Too weak to have any effect
	var/scaling = CLAMP((chungus_khan_str - 10), 1, maxrange)
	H.apply_status_effect(/datum/status_effect/debuff/yeetcd)
	H.Slowdown(scaling)
	// Copypasta from knockback proc cuz I don't want the math there
	var/knockback_tiles = scaling // 1 to 4 tiles based on strength
	if(H.resting)
		knockback_tiles = max(1, knockback_tiles / 2)
	if(user?.client?.chargedprog < 100)
		knockback_tiles = 1 // Minimal knockback on non-charged smash.
	var/turf/edge_target_turf = get_edge_target_turf(H, get_dir(user, H))
	if(istype(edge_target_turf))
		H.safe_throw_at(edge_target_turf, \
		knockback_tiles, \
		scaling, \
		user, \
		spin = FALSE, \
		force = H.move_force)

/datum/intent/flail/smash/militia
	damfactor = 0.9

/datum/intent/flail/smash/golgotha
	chargetime = 3 SECONDS
	hitsound = list('sound/items/beartrap2.ogg')

/datum/intent/flail/smash/ranged
	name = "ranged flailing smash"
	chargetime = 1.2 SECONDS
	chargedrain = 1 //Less than a regular flail, as you're swinging it around with both hands (at the end of a staff) instead of just one.
	recovery = 30
	damfactor = 1.5
	reach = 2
	chargedloop = /datum/looping_sound/flailswing
	keep_looping = TRUE
	attack_verb = list("smashes")
	hitsound = list('sound/combat/hits/blunt/flailhit.ogg')
	item_d_type = "blunt"

/datum/intent/flail/smash/ranged/matthios
	reach = 2

/datum/intent/flail/sweep
	name = "sweeping strike"
	icon_state = "insweep"
	blade_class = BCLASS_BLUNT
	chargetime = 1.2 SECONDS
	chargedrain = 1
	chargedloop = /datum/looping_sound/flailswing
	attack_verb = list("sweeps", "thrashes through")
	animname = "strike"
	hitsound = list('sound/combat/hits/blunt/flailhit.ogg')
	penfactor = PEN_NONE
	damfactor = 1.5
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR
	cleave = /datum/cleave_pattern/horizontal_sweep
	desc = "A charged sweep that smashes through targets to the front."
