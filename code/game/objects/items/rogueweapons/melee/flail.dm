/obj/item/rogueweapon/flail
	force = 25
	possible_item_intents = list(/datum/intent/flail/strike, /datum/intent/flail/smash, /datum/intent/flail/bash)
	name = "flail"
	desc = "A spiked macehead and wooden handle, linked together with a length of chain. It can be spun around to smash armored opponents with tremendous force, cracking plate and bone alike with unflinching impunity."
	icon_state = "iflail"
	icon = 'icons/roguetown/weapons/blunt32.dmi'
	sharpness = IS_BLUNT
	drop_sound = 'sound/foley/dropsound/chain_drop.ogg'
	pickup_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	equip_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	//dropshrink = 0.75
	max_integrity = 150
	wlength = WLENGTH_NORMAL
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_BACK
	associated_skill = /datum/skill/combat/whipsflails
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/iron
	parrysound = list('sound/combat/parry/parrygen.ogg')
	swingsound = BLUNTWOOSH_LARGE
	throwforce = 5
	wdefense = 0
	minstr = 4
	grid_width = 32
	grid_height = 96
	special = /datum/special_intent/flail_sweep

/obj/item/rogueweapon/flail/alt
	desc = "A studded macehead and wooden handle, linked together with a length of chain. It can be spun around to smash armored opponents with tremendous force, cracking plate and bone alike with unflinching impunity."
	icon_state = "iflailalt"

/datum/intent/flail/strike
	name = "flailing strike"
	blade_class = BCLASS_BLUNT
	attack_verb = list("strikes", "sweeps")
	hitsound = list('sound/combat/hits/blunt/flailhit.ogg')
	chargetime = 0
	damfactor = 1.1
	swingdelay = 4
	penfactor = BLUNT_DEFAULT_PENFACTOR
	icon_state = "instrike"
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR

/datum/intent/flail/strike/matthiosflail
	reach = 2

/datum/intent/flail/strikerange
	name = "ranged flailing strike"
	blade_class = BCLASS_BLUNT
	attack_verb = list("strikes", "sweeps")
	hitsound = list('sound/combat/hits/blunt/flailhit.ogg')
	chargetime = 0
	recovery = 15
	swingdelay = 6
	damfactor = 1.2 // Extra damage. Flail babe flail.
	penfactor = BLUNT_DEFAULT_PENFACTOR
	clickcd = CLICK_CD_CHARGED // Higher delay for a powerful ranged attack
	reach = 2
	icon_state = "instrike"
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR

/datum/intent/flail/bash
	name = "bash with handle"
	icon_state = "inbash"
	attack_verb = list("handlewhips", "bashes", "strikes")
	animname = "strike"
	blade_class = BCLASS_BLUNT
	hitsound = list('sound/combat/hits/punch/punch_hard (1).ogg', 'sound/combat/hits/punch/punch_hard (2).ogg', 'sound/combat/hits/punch/punch_hard (3).ogg')
	penfactor = BLUNT_DEFAULT_PENFACTOR
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

/datum/intent/flail/smash/matthiosflail
	reach = 2

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

/obj/item/rogueweapon/flail/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -10,"sy" = -3,"nx" = 11,"ny" = -2,"wx" = -7,"wy" = -3,"ex" = 3,"ey" = -3,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 22,"sturn" = -23,"wturn" = -23,"eturn" = 29,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/flail/aflail
	name = "decrepit flail"
	desc = "A spiked ball of wrought bronze, chained to a rotwooden handle. The chains groan with every twirl, strained by forces it hadn't felt in millenia; swing it a bit too hard, and there's a chance that the flailhead might completely fly off."
	icon_state = "aflail"
	force = 22
	max_integrity = 75
	color = "#bb9696"
	smeltresult = /obj/item/ingot/aaslag
	anvilrepair = null

/obj/item/rogueweapon/flail/sflail/paflail
	name = "ancient flail"
	desc = "A spiked ball of polished gilbranze, chained to a reinforced handle. They say that His children worshipped the flail above all else, for its twirls replicated the Comet Syon's blazing flights."
	icon_state = "aflail"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/rogueweapon/flail/bronze
	force = 27
	throwforce = 20
	max_integrity = 125
	icon_state = "bronzeflail"
	name = "bronze flail"
	desc = "A studded weight and a whittled handle, linked together with a length of bronze chain. It can be spun around to smash armored opponents with tremendous force, cracking plate and bone alike with unflinching impunity."
	smeltresult = /obj/item/ingot/bronze
	minstr = 7

/obj/item/rogueweapon/flail/sflail
	force = 30
	icon_state = "flail"
	desc = "A flanged macehead and a carved handle, linked together with a length of steel chain. It can be spun around to smash armored opponents with tremendous force, cracking plate and bone alike with unflinching impunity."
	smeltresult = /obj/item/ingot/steel
	minstr = 5

/obj/item/rogueweapon/flail/sflail/silver
	force = 35
	icon_state = "silverflail"
	name = "silver morningstar"
	possible_item_intents = list(/datum/intent/flail/strike, /datum/intent/flail/smash/ranged, /datum/intent/flail/bash)
	desc = "A heavy, silver flail. It follows the Grenzelhoftian design of a 'morning star', utilizing a longer chain to extend its reach. While stronger than a steel flail, it requires far more strength to effectively swing."
	smeltresult = /obj/item/ingot/silver
	max_integrity = 200 //Same value as before, for reference.
	minstr = 12
	is_silver = TRUE

/obj/item/rogueweapon/flail/sflail/silver/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 50,\
		added_def = 0,\
	)

/obj/item/rogueweapon/flail/sflail/necraflail
	name = "swift journey"
	desc = "The striking head is full of teeth, rattling viciously with every strike, with every rotation. Each set coming from one the wielder has laid to rest. Carried alongside them as a great show of respect."
	icon_state = "necraflail"
	force = 35
	is_silver = TRUE

/obj/item/rogueweapon/flail/sflail/necraflail/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 50,\
		added_def = 0,\
	)

/obj/item/rogueweapon/flail/sflail/psyflail
	name = "psydonic flail"
	desc = "An ornate flail, plated in a ceremonial veneer of silver. Its flanged head can crumple even the toughest of darksteel-maille."
	icon_state = "psyflail"
	force = 35
	minstr = 11
	wdefense = 0
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silverblessed

/obj/item/rogueweapon/flail/sflail/psyflail/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 50,\
		added_def = 0,\
	)

/obj/item/rogueweapon/flail/sflail/psyflail/relic
	name = "Consecratia"
	desc = "The weight of His anguish, His pain, His hope and His love for humenkind - all hanging on the ornamental silver-steel head chained to this arm. <br><br>A declaration of love for all that Psydon lives for, and a crushing reminder to the arch-nemesis that they will not triumph as long as He endures."
	icon_state = "psymorningstar"
	possible_item_intents = list(/datum/intent/flail/strike, /datum/intent/flail/smash/ranged, /datum/intent/flail/bash)

/obj/item/rogueweapon/flail/sflail/psyflail/relic/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 100,\
		added_def = 0,\
	)

/obj/item/rogueweapon/flail/peasantwarflail
	force = 10
	force_wielded = 35
	possible_item_intents = list(/datum/intent/flail/strike)
	gripped_intents = list(/datum/intent/flail/strikerange, /datum/intent/flail/smash/ranged)
	name = "militia thresher"
	desc = "Just like how a sling's bullet can fell a giant, so too does this great flail follow the principle of converting 'momentum' into 'plate-rupturing force'."
	icon_state = "peasantwarflail"
	icon = 'icons/roguetown/weapons/blunt64.dmi'
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	wlength = WLENGTH_GREAT
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = null
	minstr = 9
	wbalance = WBALANCE_HEAVY
	smeltresult = /obj/item/ingot/iron
	associated_skill = /datum/skill/combat/polearms
	anvilrepair = /datum/skill/craft/carpentry
	dropshrink = 0.9
	wdefense = 4
	resistance_flags = FLAMMABLE

/obj/item/rogueweapon/flail/peasantwarflail/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -3,"nx" = -5,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)

/obj/item/rogueweapon/flail/peasantwarflail/iron
	name = "greatflail"
	desc = "The lucerne's ungaitly cousin, favoring a 'ball-and-chain' design that - once spun - can devastate anything caught in its way; a trait that makes it dearly beloved by both peasantry and knights alike."
	icon_state = "greatflail"
	wdefense = 6
	minstr = 12
	anvilrepair = /datum/skill/craft/weaponsmithing

/obj/item/rogueweapon/flail/peasantwarflail/matthios
	name = "gilded flail"
	desc = "Weight of wealth in a deadly striking end."
	icon_state = "matthiosflail"
	sellprice = 250
	smeltresult = /obj/item/ingot/steel
	possible_item_intents = list(/datum/intent/flail/strike/matthiosflail)
	gripped_intents = list(/datum/intent/flail/strike/matthiosflail, /datum/intent/flail/smash/matthiosflail)
	associated_skill = /datum/skill/combat/whipsflails
	slot_flags = ITEM_SLOT_BACK
	anvilrepair = /datum/skill/craft/weaponsmithing


/obj/item/rogueweapon/flail/peasantwarflail/matthios/Initialize()
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_COMMIE, "FLAIL")

/obj/item/rogueweapon/flail/militia
	name = "militia flail"
	desc = "In another lyfe, this humble thresher was used to pound stalks into grain. Under a militiaman's grasp, however, it has found a new purpose: to humble overconfident bandits with crippling blows."
	icon_state = "milflail"
	possible_item_intents = list(/datum/intent/flail/strike, /datum/intent/flail/smash/militia)
	force = 27
	wdefense = 3
	wbalance = WBALANCE_HEAVY
