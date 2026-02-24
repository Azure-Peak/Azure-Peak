//intent datums ฅ^•ﻌ•^ฅ

/datum/intent/mace/strike
	name = "strike"
	blade_class = BCLASS_BLUNT
	attack_verb = list("strikes", "hits")
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	chargetime = 0
	penfactor = BLUNT_DEFAULT_PENFACTOR
	swingdelay = 0
	icon_state = "instrike"
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR

/datum/intent/mace/smash
	name = "smash"
	blade_class = BCLASS_SMASH
	attack_verb = list("smashes")
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	penfactor = BLUNT_DEFAULT_PENFACTOR
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
// Do not call handle_knockback like in knockback cuz that means it will hardstun

/datum/intent/mace/smash/prewarning()
	if(mastermob)
		playsound(mastermob, pick('sound/combat/shieldraise.ogg'), 100, FALSE)

/datum/intent/mace/smash/lesser
	name = "one-handed smash" //Exclusive to Warhammers, and other mace-styled bludgeons that can only be wielded in one hand.
	desc = "A powerful blow that delivers Strength-scaling knockback and slowdown to the target. The amount of inflicted knockback scales off your Strength, ranging from X (1 tile) to XIII (3 tiles). </br>Cannot inflict any knockback or slowdown if your Strength is below X. </br>Cannot be used consecutively more than every 5 seconds on the same target. </br>Prone targets halve the knockback distance. </br>Not fully charging the attack limits knockback to 1 tile."
	maxrange = 3

/datum/intent/mace/rangedthrust
	name = "thrust"
	blade_class = BCLASS_STAB
	attack_verb = list("thrusts")
	animname = "stab"
	icon_state = "instab"
	reach = 2
	clickcd = CLICK_CD_CHARGED
	recovery = 30
	warnie = "mobwarning"
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = 25
	damfactor = 0.9
	item_d_type = "stab"

/datum/intent/mace/bash
	name = "bash"
	blade_class = BCLASS_BLUNT
	penfactor = BLUNT_DEFAULT_PENFACTOR
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

/datum/intent/mace/smash/grand
	name = "heavy smash"
	damfactor = 1.1
	chargedrain = 1.5
	desc = "A powerful blow that delivers Strength-scaling knockback and slowdown to the target. The amount of inflicted knockback scales off your Strength, ranging from X (1 tile) to XV (5 tiles). </br>Cannot inflict any knockback or slowdown if your Strength is below X. </br>Cannot be used consecutively more than every 5 seconds on the same target. </br>Prone targets halve the knockback distance. </br>Not fully charging the attack limits knockback to 1 tile."
	maxrange = 5

/datum/intent/mace/smash/crush
	name = "crush"
	attack_verb = list("crushes")
	icon_state = "incrush"
	damfactor = 1.75 //Deals 83 DMG when swung from the strongest Maul (at a base of 34 DMG) with XIV STR. For comparison, a Steel Flail (which can be one-handed and swung faster) deals 63 DMG under the same parameters.
	chargedrain = 1.8 //Note that the Maul series is hardlocked to characters that have abnormally high STR, and is otherwise physically unwieldable.
	chargetime = 10
	desc = "A titanic blow that delivers Strength-scaling knockback and slowdown to the target. The amount of inflicted knockback scales off your Strength, ranging from X (1 tile) to XV (5 tiles). </br>Actively drains stamina while being charged up. </br>Cannot inflict any knockback or slowdown if your Strength is below X. </br>Cannot be used consecutively more than every 5 seconds on the same target. </br>Prone targets halve the knockback distance. </br>Not fully charging the attack limits knockback to 1 tile."
	maxrange = 5

//blunt objs ฅ^•ﻌ•^ฅ

/obj/item/rogueweapon/mace
	force = 22
	force_wielded = 27
	possible_item_intents = list(/datum/intent/mace/strike, /datum/intent/mace/strike/dislocate)
	gripped_intents = list(/datum/intent/mace/strike, /datum/intent/mace/smash, /datum/intent/effect/daze, /datum/intent/mace/strike/dislocate)
	name = "mace"
	desc = "Carved wood, cold iron. </br>Crushing down upon thine foe. </br>Cracking plate, bone, soul."
	icon_state = "mace"
	icon = 'icons/roguetown/weapons/blunt32.dmi'
	item_state = "mace_greyscale"
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	sharpness = IS_BLUNT
	//dropshrink = 0.75
	wlength = WLENGTH_NORMAL
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_BACK
	associated_skill = /datum/skill/combat/maces
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/iron
	parrysound = list('sound/combat/parry/parrygen.ogg')
	swingsound = BLUNTWOOSH_MED
	minstr = 7
	wdefense = 2
	wbalance = WBALANCE_HEAVY
	max_integrity = 350
	icon_angle_wielded = 50
	special = /datum/special_intent/ground_smash

/obj/item/rogueweapon/mace/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -11,"sy" = -8,"nx" = 12,"ny" = -8,"wx" = -5,"wy" = -8,"ex" = 6,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -90,"eturn" = 90,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.7,"sx" = 5,"sy" = -4,"nx" = -5,"ny" = -4,"wx" = -5,"wy" = -3,"ex" = 7,"ey" = -4,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -45,"sturn" = 45,"wturn" = -45,"eturn" = 45,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.45,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/mace/bronze
	force = 23
	force_wielded = 29
	name = "bronze mace"
	icon_state = "bronzemace"
	desc = "An antiquital staff, crested with a studded sphere of bronze. Bludgeons were the first implements made for the explicit purpose of killing another; fittingly, this was the second."
	smeltresult = /obj/item/ingot/bronze
	max_integrity = 250

/obj/item/rogueweapon/mace/alloy
	name = "decrepit mace"
	desc = "Frayed bronze, perched atop a rotwooden shaft. His sacrifice had drowned Old Syon, and - in its wake - left Man bereft of all it had accomplished. With all other prayers falling upon deaf ears, Man had crafted this idol in tribute to its new God; violence."
	icon_state = "amace"
	force = 17
	force_wielded = 21
	max_integrity = 180
	blade_dulling = DULLING_SHAFT_CONJURED
	color = "#bb9696"
	smeltresult = /obj/item/ingot/aaslag
	anvilrepair = null

/obj/item/rogueweapon/mace/church
	force = 25
	force_wielded = 30
	name = "bell ringer"
	desc = "Each man's death diminishes me, for I am involved in mankind. </br>Therefore, send not to know for whom the bell tolls. </br>It tolls for thee."
	icon_state = "churchmace"
	wbalance = WBALANCE_HEAVY
	smeltresult = /obj/item/ingot/steel
	wdefense = 3

/obj/item/rogueweapon/mace/church/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("This mace can be used to ring the Church's bell, distinctly hearable by everyone within the Town's limits.")

/obj/item/rogueweapon/mace/steel
	force = 25
	force_wielded = 32
	name = "steel mace"
	desc = "Cold steel, royal might. </br>Crushing down upon thine foe. </br>Cracking plate, bone, soul."
	icon_state = "smace"
	smeltresult = /obj/item/ingot/steel
	wdefense = 3
	smelt_bar_num = 2

/obj/item/rogueweapon/mace/steel/palloy
	name = "ancient alloy mace"
	desc = "Polished gilbranze, perched atop a reinforced shaft. Break the unenlightened into naught-but-giblets; like a potter's vessels, dashed against the rocks."
	icon_state = "amace"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/rogueweapon/mace/steel/silver
	force = 30
	force_wielded = 35
	name = "silver mace"
	desc = "A long and heavy flanged mace, forged from pure silver. For a lord, it's the perfect symbol of authority; a decorative piece for the courts. For a paladin, however, there's no better implement for shattering avantyne-maille into a putrid pile of debris."
	icon_state = "silvermace"
	smeltresult = /obj/item/ingot/silver
	minstr = 10
	wdefense = 5
	smelt_bar_num = 2
	swingsound = BLUNTWOOSH_LARGE
	is_silver = TRUE

/obj/item/rogueweapon/mace/steel/silver/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/mace/gold
	name = "golden mace"
	desc = "A heavenly staff of besilked rosawood, crested with the golden sigil of royalty. Like the plump-bellied aristocrats who've surely commissioned this article's design, it is overbearingly heavy."
	icon_state = "goldmace"
	force = 35
	force_wielded = 40
	max_integrity = 50
	anvilrepair = null //Ceremonial. This should break comedically easily, but still have just enough toughness to work with a few strikes.
	minstr = 11
	sellprice = 300
	smeltresult = /obj/item/ingot/gold
	unenchantable = TRUE

/obj/item/rogueweapon/mace/gold/lordscepter
	name = "\"Morningstar\""
	desc = "A heavenly staff of besilked rosawood, crested with the golden sigil of royalty. Nestled within its glistening bosom is a shard of Astrata's divinity authority; let Her judgement course through those who'd dare to lessen your presence. ‎</br>‎‎ </br>'..The end of the matter - for all has been heard. Fear the Lord and keep their commandments, for this is the whole duty of man.'"
	possible_item_intents = list(/datum/intent/mace/strike, /datum/intent/mace/strike/dislocate, /datum/intent/lord_electrocute, /datum/intent/lord_silence)
	gripped_intents = list(/datum/intent/mace/strike, /datum/intent/mace/smash, /datum/intent/effect/daze, /datum/intent/mace/strike/dislocate) 
	icon_state = "goldmaceking"
	max_integrity = 300
	anvilrepair = /datum/skill/craft/weaponsmithing
	minstr = 7
	sellprice = 363
	unenchantable = TRUE
	COOLDOWN_DECLARE(sceptermace)

/obj/item/rogueweapon/mace/gold/lordscepter/afterattack(atom/target, mob/user, flag)
	. = ..()
	if(get_dist(user, target) > 7)
		return
	
	user.changeNext_move(CLICK_CD_MELEE)

	if(ishuman(user))
		var/mob/living/carbon/human/HU = user

		if(HU.job != "Grand Duke")
			to_chat(user, span_danger("The mace's divine authority doesn't recognize me."))
			return

		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			var/area/target_area = get_area(H)

			if(!istype(target_area, /area/rogue/indoors/town/manor))
				to_chat(user, span_danger("The mace's divine authority cannot be invoked on targets outside of the manor!"))
				return

			if(H == HU)
				return

			if(!COOLDOWN_FINISHED(src, sceptermace))
				to_chat(user, span_danger("The [src] is not ready yet! [round(COOLDOWN_TIMELEFT(src, sceptermace) / 10, 1)] seconds left!"))
				return

			if(H.anti_magic_check())
				to_chat(user, span_danger("Something is disrupting the mace's divine authority!"))
				return

			if(istype(user.used_intent, /datum/intent/lord_electrocute))
				HU.visible_message(span_warning("[HU] electrocutes [H] with the [src]."))
				user.Beam(target,icon_state="lightning[rand(1,12)]",time=5)
				H.electrocute_act(5, src)
				COOLDOWN_START(src, sceptermace, 20 SECONDS)
				to_chat(H, span_danger("I'm electrocuted by the mace's divine authority!"))
				return

			if(istype(user.used_intent, /datum/intent/lord_silence))
				HU.visible_message("<span class='warning'>[HU] silences [H] with \the [src].</span>")
				H.set_silence(20 SECONDS)
				COOLDOWN_START(src, sceptermace, 10 SECONDS)
				to_chat(H, "<span class='danger'>I'm silenced by the mace's divine authority!</span>")
				return

/obj/item/rogueweapon/mace/woodclub
	force = 15
	force_wielded = 18
	name = "wooden club"
	desc = "A primitive cudgel carved of a stout piece of treefall."
	icon_state = "club1"
	//dropshrink = 0.75
	wbalance = WBALANCE_NORMAL
	wdefense = 1
	possible_item_intents = list(/datum/intent/mace/strike/wood)
	gripped_intents = list(/datum/intent/mace/strike/wood, /datum/intent/mace/smash/wood, /datum/intent/effect/daze)
	smeltresult = /obj/item/ash
	anvilrepair = /datum/skill/craft/carpentry
	minstr = 7
	resistance_flags = FLAMMABLE

/obj/item/rogueweapon/mace/woodclub/New()
	..()
	icon_state = "club[rand(1,2)]"

/datum/intent/mace/strike/wood
	hitsound = list('sound/combat/hits/blunt/woodblunt (1).ogg', 'sound/combat/hits/blunt/woodblunt (2).ogg')
	penfactor = BLUNT_DEFAULT_PENFACTOR

/datum/intent/mace/smash/wood
	hitsound = list('sound/combat/hits/blunt/woodblunt (1).ogg', 'sound/combat/hits/blunt/woodblunt (2).ogg')
	penfactor = BLUNT_DEFAULT_PENFACTOR

/obj/item/rogueweapon/mace/woodclub/deprived
	name = "warped club"
	desc = "It's a piece of wood marred by age and strife alike."
	icon_state = "deprived"
	force = 20
	force_wielded = 22
	wbalance = WBALANCE_HEAVY

/obj/item/rogueweapon/mace/woodclub/deprived/New()
	..()
	icon_state = "deprived"

/datum/intent/mace/smash/wood/ranged
	reach = 2

/obj/item/rogueweapon/mace/cudgel
	name = "cudgel"
	desc = "A stubby little club for used by guards, brigands, and various criminals. Perfect to cripple someone on a budget."
	force = 23
	icon_state = "cudgel"
	possible_item_intents = list(/datum/intent/mace/strike, /datum/intent/mace/strike/wallop, /datum/intent/effect/daze)
	gripped_intents = null //One-handed. Pseudo-sidegrade between the Mace and Warhammer. Exchanges smashing for dislocation.
	smeltresult = /obj/item/ash
	wlength = WLENGTH_SHORT
	w_class = WEIGHT_CLASS_NORMAL
	wbalance = WBALANCE_HEAVY
	minstr = 7
	wdefense = 1
	resistance_flags = FLAMMABLE
	grid_width = 32
	grid_height = 96
	special = null //Should probably get something unique, but definitely not Mace ground slam

/obj/item/rogueweapon/mace/cudgel/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -8,"sy" = -7,"nx" = 10,"ny" = -7,"wx" = -1,"wy" = -8,"ex" = 1,"ey" = -7,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 91,"sturn" = -90,"wturn" = -90,"eturn" = 90,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.4,"sx" = -3,"sy" = -4,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 70,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 1,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

// Non-lethal mace-striking (Made for cudgel specifically. Don't put this on everything. Yeah, I mean you.)
/datum/intent/mace/strike/wallop
	name = "wallop"
	blade_class = BCLASS_TWIST	//I know, it's weird, but this lets you dislocate limbs and works fine w/ -100 pen factor of blunt weapons.
	attack_verb = list("twamps", "thwacks", "wallops")
	damfactor = 1.3		// High damage mod to give high chance of dislocation against unarmored targets.
	intent_intdamage_factor = 0.4	// Purposefully bad at damaging armor. Specifically deals -60% integrity damage, irregardless of the previous intent's modifiers.
	icon_state = "inbash"	// Wallop is too long for a button; placeholder.
	desc = "A quick and sudden thwack that can cripple unarmored limbs with tremendous force. </br>Deals TWIST damage instead of BLUNT damage. Critical hits cause DISLOCATIONS, instead of FRACTURES. </br>DISLOCATED ARMS and HANDS cannot wield, grab, or use anything. </br>DISLOCATED LEGS and FEET prevent the target from standing."

// (I'm evil. Slight swing delay.)
/datum/intent/mace/strike/dislocate
	name = "dislocate"
	blade_class = BCLASS_TWIST
	attack_verb = list("thwacks", "threshes")
	hitsound = list('sound/combat/hits/punch/punch_hard (1).ogg', 'sound/combat/hits/punch/punch_hard (2).ogg', 'sound/combat/hits/punch/punch_hard (3).ogg')
	damfactor = 1.25
	intent_intdamage_factor = 0.4 //Reduces integrity damage modifier from +60% to -60%.
	swingdelay = 6 //Slower than a strike, quicker than a chop or old-school smash.
	icon_state = "inthresh"	
	desc = "A slow-swinging strike that can cripple unarmored limbs with tremendous force. </br>Deals TWIST damage instead of BLUNT damage. Critical hits cause DISLOCATIONS, instead of FRACTURES. </br>DISLOCATED ARMS and HANDS cannot wield, grab, or use anything. </br>DISLOCATED LEGS and FEET prevent the target from standing."

/obj/item/rogueweapon/mace/cudgel/flanged
	name = "flanged mace"
	desc = "Chivalry. </br>A one-handed derivative of the mace, purpose-made to dazzle armored opponents. Quartered into four symmetrical ridges, its flanged macehead can comfortably carve maille-and-bone behind the safety of an accompying shield."
	force = 27 //+2 (1H) but -5 (2H), compared to the Steel Mace.
	possible_item_intents = list(/datum/intent/mace/strike, /datum/intent/mace/strike/dislocate, /datum/intent/effect/daze, /datum/intent/mace/warhammer/stab)
	gripped_intents = null //One-handed. Pseudo-sidegrade between the Mace and Warhammer, offering more damage and dislocations at the cost of no Picking or Smashing.
	swingsound = BLUNTWOOSH_LARGE
	minstr = 7
	wdefense = 3
	smeltresult = /obj/item/ingot/steel
	icon_state = "flangedmace"

/obj/item/rogueweapon/mace/cudgel/flanged/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -11,"sy" = -8,"nx" = 12,"ny" = -8,"wx" = -5,"wy" = -8,"ex" = 6,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -90,"eturn" = 90,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.4,"sx" = -3,"sy" = -4,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 70,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 1,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/mace/cudgel/flanged/silver
	name = "silver flanged mace"
	desc = "A flanged mace of silver, fit for a holy paladin's grasp. The weight within your hand is not of silver, alone - but of the fate that you may yet avert; for yourself, and \
    for the world you love. </br>'Please do not wait for me..' \ </br>'For though I depart, my magic will never die..' </br>'Listen to my laughter in the babbling brook..' \
	</br>'Hear my song being sung by the bards..' </br>'Feel my warmth in the rays of the morning sun..' </br>'See my light in the twinkling stars at night..' \
	</br>'..and know that my spirit will always be with you..' </br>'..woven into the very fabric of the world we cherished together.'"
	force = 30
	minstr = 9
	wdefense = 5
	resistance_flags = FIRE_PROOF
	icon_state = "psyflangedmace"
	swingsound = BLUNTWOOSH_LARGE
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silver

/obj/item/rogueweapon/mace/cudgel/flanged/silver/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 50,\
		added_def = 1,\
	)

/obj/item/rogueweapon/mace/cudgel/shellrungu
	name = "shell rungu"
	desc = "A ceremonial rungu carved out of clam shell. Not intended for combat. Its used in various Sea and Coastal Elven rituals and ceremonies."
	icon = 'icons/roguetown/gems/gem_shell.dmi'
	icon_state = "rungu_shell"

	max_integrity = 75
	sellprice = 35

/obj/item/rogueweapon/mace/cudgel/psy
	name = "psydonic flanged mace"
	desc = "A flanged mace of blessed silver, wielded by His children. The rosewood handle's curved nature beckons your fingers to curl along its grooves, and to never let go; \
    no matter the weather nor odds. </br>'Please do not wait for me..' \ </br>'For though I depart, my magic will never die..' </br>'Listen to my laughter in the babbling brook..' \
	</br>'Hear my song being sung by the bards..' </br>'Feel my warmth in the rays of the morning sun..' </br>'See my light in the twinkling stars at night..' \
	</br>'..and know that my spirit will always be with you..' </br>'..woven into the very fabric of the world we cherished together.'"
	force = 30
	possible_item_intents = list(/datum/intent/mace/strike, /datum/intent/mace/strike/dislocate, /datum/intent/effect/daze, /datum/intent/mace/warhammer/stab)
	gripped_intents = null //One-handed. Pseudo-sidegrade between the Mace and Warhammer. Exchanges smashing for dislocation.
	minstr = 9
	wdefense = 5
	resistance_flags = FIRE_PROOF
	swingsound = BLUNTWOOSH_LARGE
	icon_state = "psyflangedmace"
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silverblessed

/obj/item/rogueweapon/mace/cudgel/psy/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 50,\
		added_def = 1,\
	)

/obj/item/rogueweapon/mace/cudgel/psy/preblessed/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 50,\
		added_def = 1,\
	)

/obj/item/rogueweapon/mace/cudgel/psy/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -11,"sy" = -8,"nx" = 12,"ny" = -8,"wx" = -5,"wy" = -8,"ex" = 6,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -90,"eturn" = 90,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.4,"sx" = -3,"sy" = -4,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 70,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 1,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/mace/cudgel/psy/old
	name = "enduring flanged mace"
	desc = "A flanged mace, weathered by tyme's gaze. It radiates a strange energy; distant, fleeting, but ever-so-familiar. </br>'Please do not wait for me..' \
	</br>'For though I depart, my magic will never die..' </br>'Listen to my laughter in the babbling brook..' </br>'Hear my song being sung by the bards..' \
	</br>'Feel my warmth in the rays of the morning sun..' </br>'See my light in the twinkling stars at night..' </br>'..and know that my spirit will always be with you..' \
	</br>'..woven into the very fabric of the world we cherished together.'"
	force_wielded = 25
	wbalance = WBALANCE_NORMAL
	icon_state = "opsyflangedmace"
	smeltresult = /obj/item/ingot/iron

/obj/item/rogueweapon/mace/cudgel/psy/old/ComponentInitialize()
	return

//

/obj/item/rogueweapon/mace/cudgel/psyclassic
	name = "psydonic handmace"
	desc = "A shorter variant of the flanged silver mace, rebalanced for one-handed usage. It isn't uncommon for these sidearms to mysteriously 'vanish' from an Adjudicator's belt, only to be 'rediscovered' - and subsequently kept - by a Confessor."
	possible_item_intents = list(/datum/intent/mace/strike, /datum/intent/mace/strike/wallop)
	gripped_intents = list(/datum/intent/mace/strike, /datum/intent/mace/strike/wallop, /datum/intent/mace/smash, /datum/intent/effect/daze)
	force = 25
	force_wielded = 30
	minstr = 7
	wdefense = 5 
	wbalance = WBALANCE_SWIFT
	resistance_flags = FIRE_PROOF
	icon_state = "psyflangedmacelegacy"
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silverblessed

/obj/item/rogueweapon/mace/cudgel/psyclassic/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 50,\
		added_def = 1,\
	)

/obj/item/rogueweapon/mace/cudgel/psyclassic/preblessed/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 50,\
		added_def = 1,\
	)

/obj/item/rogueweapon/mace/cudgel/psyclassic/old
	name = "enduring handmace"
	desc = "A flanged mace, well-balanced for usage in one hand. It radiates with a strange energy: familiar, yet ever-so-distant."
	force = 20
	force_wielded = 25
	wbalance = WBALANCE_NORMAL
	icon_state = "opsyflangedmacelegacy"
	smeltresult = /obj/item/ingot/steel

/obj/item/rogueweapon/mace/cudgel/psyclassic/old/ComponentInitialize()
	return

//

/obj/item/rogueweapon/mace/cudgel/copper
	name = "copper bludgeon"
	desc = "An extremely crude weapon for cruder bastards."
	force = 15
	icon_state = "cbludgeon"
	force_wielded = 20
	smeltresult = /obj/item/ingot/copper
	wdefense = 2

/obj/item/rogueweapon/mace/cudgel/justice
	name = "'Justice'"
	desc = "The icon of the right of office of the Marshal. While mostly ceremonial in design, it serves it's purpose in dishing out some much needed justice."
	force = 30
	icon_state = "justice"
	possible_item_intents = list(/datum/intent/mace/strike, /datum/intent/mace/smash, /datum/intent/effect/daze, /datum/intent/mace/strike/dislocate)
	smeltresult = /obj/item/ingot/steel
	wlength = WLENGTH_SHORT
	w_class = WEIGHT_CLASS_NORMAL
	wbalance = WBALANCE_SWIFT
	resistance_flags = FIRE_PROOF
	minstr = 7
	wdefense = 5

/obj/item/rogueweapon/mace/cudgel/justice/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -11,"sy" = -8,"nx" = 12,"ny" = -8,"wx" = -5,"wy" = -8,"ex" = 6,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -90,"eturn" = 90,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.4,"sx" = -3,"sy" = -4,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 70,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 1,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/mace/wsword
	name = "wooden sword"
	desc = "This wooden sword is great for training."
	force = 5
	force_wielded = 8
	icon_state = "wsword"
	//dropshrink = 0.75
	possible_item_intents = list(/datum/intent/mace/strike/wood) //Allows for the teaching of both core Mace mechanics and alternative Sword mechanics.
	gripped_intents = list(/datum/intent/mace/strike/wood, /datum/intent/mace/smash/wood, /datum/intent/effect/daze) //..ala, Daze and Dislocate.
	smeltresult = /obj/item/ash
	minstr = 7
	wdefense = 5
	wbalance = WBALANCE_NORMAL
	associated_skill = /datum/skill/combat/swords
	anvilrepair = /datum/skill/craft/carpentry
	resistance_flags = FLAMMABLE

/obj/item/rogueweapon/mace/wsword/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -10,"sy" = -8,"nx" = 13,"ny" = -8,"wx" = -8,"wy" = -7,"ex" = 7,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -80,"eturn" = 81,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.7,"sx" = 5,"sy" = -2,"nx" = -6,"ny" = -2,"wx" = -6,"wy" = -2,"ex" = 7,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -28,"sturn" = 29,"wturn" = -35,"eturn" = 32,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.5,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 100,"sturn" = 156,"wturn" = 90,"eturn" = 180,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/mace/goden
	force = 15
	force_wielded = 30
	possible_item_intents = list(/datum/intent/mace/strike, /datum/intent/mace/bash/ranged) //Fluffed as either buttstroking with the Grand Mace, or ineffectually swinging it.
	gripped_intents = list(/datum/intent/mace/strike/grand, /datum/intent/mace/smash/grand, /datum/intent/mace/rangedthrust, /datum/intent/effect/daze)
	name = "goedendag"
	desc = "Good morning."
	icon_state = "goedendag"
	icon = 'icons/roguetown/weapons/blunt64.dmi'
	sharpness = IS_BLUNT
	//dropshrink = 0.75
	wlength = WLENGTH_LONG
	w_class = WEIGHT_CLASS_BULKY
	associated_skill = /datum/skill/combat/maces
	smeltresult = /obj/item/ash
	swingsound = BLUNTWOOSH_LARGE
	minstr = 10
	wdefense = 3
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE

/obj/item/rogueweapon/mace/goden/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -3,"nx" = -5,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/mace/goden/aalloy
	name = "decrepit grand mace"
	desc = "Good nite, sire."
	force = 12
	force_wielded = 22
	icon_state = "ancient_supermace"
	blade_dulling = DULLING_SHAFT_CONJURED
	color = "#bb9696"
	smeltresult = /obj/item/ingot/aaslag
	anvilrepair = null

/obj/item/rogueweapon/mace/goden/steel
	name = "grand mace"
	desc = "Good morning, sire."
	icon_state = "polemace"
	force = 15
	force_wielded = 35
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 2
	wdefense_wbonus = 5
	special = null
	max_integrity = 300

/obj/item/rogueweapon/mace/goden/steel/paalloy
	name = "ancient grand mace"
	desc = "A twisting polehammer, forged in polished gilbranze. What did you think this was all about? This destruction, this war, this sacrifice; it was all to prepare Man for its true ascension."
	icon_state = "ancient_supermace"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/rogueweapon/mace/goden/deepduke
	name = "deep duke's staff"
	desc = "A staff made of seaglass and sturdy but unusual metal, holding no power after its misled owner's death. More useful as a bashing tool than a magic focus."
	icon = 'icons/roguetown/mob/monster/pufferboss.dmi'
	icon_state = "pufferprod"
	force = 15
	force_wielded = 35
	minstr = 11
	max_integrity = 900
	smeltresult = /obj/item/ingot/steelholy
	smelt_bar_num = 2

/obj/item/rogueweapon/mace/goden/kanabo
	name = "kanabo"
	desc = "A steel-banded wooden club, made to break the enemy in spirit as much as in flesh. One of the outliers among the many more elegant weapons of Kazengun."
	icon_state = "kanabo"
	slot_flags = ITEM_SLOT_BACK
	gripped_intents = list(/datum/intent/mace/strike/grand, /datum/intent/mace/smash/grand, /datum/intent/stab, /datum/intent/effect/daze)
	max_integrity = 250 // it's strong wood, but it's still wood.

/obj/item/rogueweapon/mace/goden/steel/ravox
	name = "duel settler"
	desc = "The tenets of Ravoxian duels are enscribed upon the head of this maul."
	icon_state = "ravoxhammer"
	gripped_intents = list(/datum/intent/mace/strike, /datum/intent/mace/smash, /datum/intent/effect/daze, /datum/intent/mace/bash/ranged) // It loses the Goden stab so I give it daze
	max_integrity = 400 // I am reluctant to give a steel goden more force as it breaks weapon so durability it is.

/obj/item/rogueweapon/mace/goden/psymace
	name = "psydonic mace"
	desc = "An ornate mace, plated in a ceremonial veneer of silver. Do not go quietly into the darkness; shatter your chains, roar with all your might, and bring the whole damndable temple down with you. </br>Even the unholy aren't immune to discombobulation."
	icon_state = "psymace"
	force = 30
	force_wielded = 35
	minstr = 12
	wdefense = 6
	wbalance = WBALANCE_HEAVY
	smelt_bar_num = 2
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silverblessed

/obj/item/rogueweapon/mace/goden/psymace/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 50,\
		added_def = 1,\
	)

/obj/item/rogueweapon/mace/spiked
	icon_state = "spiked_club"

/obj/item/rogueweapon/mace/steel/morningstar
	name = "morning star"
	icon_state = "morningstar"
	desc = "Royalty. </br>An uncommon derivative of the mace, studded with spikes and seated upon a serpentine shaft. When raised aloft, the macehead mimics a stylized imitation of Astrata's glare; ergo, 'morning star'."
	wdefense = 5

/obj/item/rogueweapon/mace/warhammer
	force = 20
	possible_item_intents = list(/datum/intent/mace/strike, /datum/intent/mace/smash/lesser, /datum/intent/mace/warhammer/pick, /datum/intent/mace/warhammer/stab/lesser)
	gripped_intents = null //Warhammers are purpose-made to kill. Smaller maceheads lock them out from the 'Dislocate' intent and 'Smash' intent's full knockback. Still, their boon comes from being a 'jack of all trades'.
	name = "warhammer"
	desc = "A one-handed derivative of the mace, purpose-made to defeat armored opponents in battle. Paired nicely with a mug of Azuria's finest zenny-liqour and a heater shield."
	icon_state = "iwarhammer"
	wbalance = WBALANCE_HEAVY
	smeltresult = /obj/item/ingot/iron
	wdefense = 3
	max_integrity = 200

/obj/item/rogueweapon/mace/warhammer/bronze
	force = 22
	name = "bronze warclub"
	desc = "The warhammer's ancestral link, carved from a weightsome log and studded with bronze. Elven natureguards carry it to both honor their forefathers, and as a way to sunder those who'd ravage Dendor's bounties without thought-or-restraint; a toss from afar turns into a sundering hurlbat."
	icon_state = "bronzeclub"
	wbalance = WBALANCE_HEAVY
	throwforce = 30
	embedding = list("embedded_pain_multiplier" = 4, "embed_chance" = 50, "embedded_fall_chance" = 20)
	smeltresult = /obj/item/ingot/bronze
	wdefense = 3
	max_integrity = 180

/obj/item/rogueweapon/mace/warhammer/bronze/decorated
	name = "decorated bronze warclub"
	desc = "Flowers, silk, and gold caress this carved-and-spiked log; a honored totem who's roots trace back to the daes before Syon's impact. Myths speak of ancient elve-and-humen alike, wielding such bronzen bludgeons against the Archdevil's rampaging hordes."
	icon_state = "bronzeclubdec"
	smeltresult = /obj/item/ingot/gold
	sellprice = 100
	wdefense = 5
	max_integrity = 250

/obj/item/rogueweapon/mace/warhammer/alloy
	name = "decrepit warhammer"
	desc = "A macehead of frayed bronze, spiked and perched atop a thin shaft. To see such a knightly implement abandoned to decay and neglect; that wounds the heart greater than any well-poised strike."
	icon_state = "awarhammer"
	force = 17
	max_integrity = 150
	blade_dulling = DULLING_SHAFT_CONJURED
	color = "#bb9696"
	smeltresult = /obj/item/ingot/aaslag
	anvilrepair = null

/obj/item/rogueweapon/mace/warhammer/steel
	force = 25
	possible_item_intents = list(/datum/intent/mace/strike, /datum/intent/mace/smash/lesser, /datum/intent/mace/warhammer/pick, /datum/intent/mace/warhammer/stab)
	name = "steel warhammer"
	desc = "Nobility. </br>A one-handed lucerne with a steel hammerhead, perfectly balanced for a gauntlet's grasp. The unique hook-shaped spike sprouting from its rear is better known as a 'saigaman's pick', which excels at gouging wounds through the gaps in an armored opponent's maille."
	icon_state = "swarhammer"
	smeltresult = /obj/item/ingot/steel
	wdefense = 4

/obj/item/rogueweapon/mace/warhammer/getonmobprop(tag)
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -9,"sy" = -8,"nx" = 9,"ny" = -7,"wx" = -7,"wy" = -8,"ex" = 3,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -90,"eturn" = 90,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 3,"sy" = -7,"nx" = -6,"ny" = -3,"wx" = 3,"wy" = -4,"ex" = 4,"ey" = -3,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -44,"sturn" = 45,"wturn" = 47,"eturn" = 33,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.4,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
	return ..()

/obj/item/rogueweapon/mace/warhammer/steel/paalloy
	name = "ancient alloy warhammer"
	desc = "A macehead of polished gilbranze, spiked and perched atop a reinforced shaft. An elegant weapon from a more civilized age; when Man lived in harmony with one-another, and when 'the undying' was nothing more than a nitemare's thought."
	icon_state = "awarhammer"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/rogueweapon/mace/warhammer/steel/silver
	name = "silver warhammer"
	desc = "A heavy warhammer, forged from pure silver. It follows the Otavan design of a 'lucerene'; a shortened polehammer with a pronounced spike, rebalanced for one-handed usage. Resplendent in presentation, righteous in purpose."
	icon_state = "silverhammer"
	force = 30
	force_wielded = 30
	minstr = 10
	wdefense = 5
	smeltresult = /obj/item/ingot/silver
	smelt_bar_num = 2
	is_silver = TRUE

/obj/item/rogueweapon/mace/warhammer/steel/silver/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 50,\
		added_def = 2,\
	)


/datum/intent/mace/warhammer/stab
	name = "thrust"
	icon_state = "instab"
	blade_class = BCLASS_STAB
	attack_verb = list("thrusts", "stabs")
	animname = "stab"
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	no_early_release = TRUE
	penfactor = 20
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
	penfactor = 20
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
	penfactor = 80
	damfactor = 0.9
	item_d_type = "stab"

//Mauls. Woe. Most characters will not be able to engage with this, beyond hobbling.
//Why? The unique strength lockout. The minimum strength is not a suggestion.
/obj/item/rogueweapon/mace/maul
	force = 12 //Don't one-hand this.
	force_wielded = 32 //-3 compared to grand mace(steel goden). Better intents.
	possible_item_intents = list(/datum/intent/mace/strike, /datum/intent/mace/bash/ranged) 
	gripped_intents = list(/datum/intent/mace/smash/crush, /datum/intent/mace/strike/grand, /datum/intent/effect/daze, /datum/intent/effect/hobble)
	name = "maul"
	desc = "Who would need something this large? It looks like it was made for tearing down walls, rather than men."
	icon_state = "sledge"
	icon = 'icons/roguetown/weapons/blunt64.dmi'
	wlength = WLENGTH_LONG
	swingsound = BLUNTWOOSH_HUGE
	slot_flags = null//No.
	smelt_bar_num = 2
	minstr = 14
	wdefense = 3
	demolition_mod = 1.25 //Oh, yes...
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	dropshrink = 0.6
	bigboy = TRUE
	gripsprite = TRUE
	minstr_req = TRUE //You MUST have the required strength. No exceptions.

/obj/item/rogueweapon/mace/maul/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -3,"nx" = -5,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)

/obj/item/rogueweapon/mace/maul/grand
	name = "grand maul"
	desc = "You could probably crack a man's spine just by tapping them with this. \
	Only a lunatic would carry something so heavy, however."
	icon_state = "cross"
	force_wielded = 34 // -1 compared to grand mace.
	smeltresult = /obj/item/ingot/steel
	minstr = 15
	wdefense_wbonus = 4 // from 6
	smelt_bar_num = 3

//Malumite maul. Intended for Templars.
/obj/item/rogueweapon/mace/maul/grand/malum
	name = "Kargrund Maul"
	desc = "Forged from the legacy of dwarven rock-hammers, this maul’s holy steel and divine runes grant it immense power. \
	Unwieldy to those weak of arm or faith, its mighty blows have the strength to shatter both stone and skull alike."
	icon_state = "malumhammer"
	minstr = 8//Handled by the unique interaction below. Inverted to start, since they spawn with it, and funny stuff can happen.

/obj/item/rogueweapon/mace/maul/grand/malum/pickup(mob/living/user)
	if(HAS_TRAIT(user, TRAIT_FORGEBLESSED))
		src.minstr = 8//-10, if you have the ability to use this.
	else
		src.minstr = 18
	..()
	
//Dwarvish mauls. Unobtanium outside of Grudgebearer. Do not change that.
/obj/item/rogueweapon/mace/maul/steel
	name = "dwarvish maul"
	desc = "An incredibly heavy, oversized hammer. The owner is not compensating, for this maul will do the speaking. \
	This one has been well balanced, allowing for a weaker wielder to make use of it."
	icon_state = "dwarfhammer"
	smeltresult = /obj/item/ingot/steel
	minstr = 11 // +2STR from Grudgebearer Soldier. Should cover this.
	wdefense_wbonus = 3 // 5
	smelt_bar_num = 3 // You'll break my heart.
	max_integrity = 390

/obj/item/rogueweapon/mace/maul/spiked
	name = "spiked maul"
	desc = "Covered in spikes, such is the weapon of a Dwarvish smith. \
	This one has been well balanced, allowing for a weaker wielder to make use of it."
	icon_state = "spiky"
	gripped_intents = list(/datum/intent/maul/spiked, /datum/intent/mace/smash/grand, /datum/intent/effect/daze, /datum/intent/effect/hobble)
	wdefense_wbonus = 2 //4
	minstr = 10 //+1 STR from Grudgebearer Smith. It should be fine.
	smelt_bar_num = 3 //Please don't...
	max_integrity = 370

//Intents for the mauls.
/datum/intent/effect/hobble
	name = "hobbling strike"
	desc = "A heavy strike aimed at the legs to cripple movement."
	icon_state = "incrack"//Temp. Just so it's easy to differentiate.
	attack_verb = list("hobbles")
	animname = "strike"
	hitsound = list('sound/combat/hits/blunt/shovel_hit3.ogg')
	swingdelay = 6
	damfactor = 0.8
	penfactor = BLUNT_DEFAULT_PENFACTOR
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

/datum/component/mushroom_mace
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/hit_count = 0
	var/last_hit_time = 0
	var/reset_timeout = 75 SECONDS

/datum/component/mushroom_mace/Initialize()
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(parent, COMSIG_ITEM_ATTACK_SUCCESS, .proc/on_attack)

/datum/component/mushroom_mace/proc/on_attack(obj/item/source, mob/living/target, mob/living/user)
	SIGNAL_HANDLER

	if(!istype(user.used_intent, /datum/intent/mace/boom))
		return

	var/current_time = world.time

	// Reset hit count if it's been too long since the last succesful hit.
	if(hit_count > 0 && (current_time - last_hit_time) > reset_timeout)
		hit_count = 1
		last_hit_time = current_time
		to_chat(user, span_infection("The mushroom mace starts pulsing."))

	hit_count++
	spawn(0)
		spawn_spore_clouds(target, user)

	if(hit_count == 6)
		playsound(user, 'sound/magic/magnet.ogg', 75)
		to_chat(user, span_userdanger("The mushroom mace is pulsing wildly!"))

	if(hit_count >= 7)
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
	explosion(T, devastation_range = 0, heavy_impact_range = 0, light_impact_range = 4, smoke = TRUE, soundin = pick('sound/misc/explode/explosion.ogg'))

	for(var/mob/living/L in range(2, T))
		var/damage = 30
		if(L == user)
			damage = 10 // User takes reduced damage
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
	var/damage_amount = 5

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

	to_chat(L, span_danger("You breathe in the spiky spores!"))
	L.apply_damage(damage_amount, BRUTE)

/datum/intent/mace/boom
	name = "boom"
	attack_verb = list("thumps", "fungal-strikes")
	icon_state = "inboom"
	item_d_type = "blunt"
	desc = "A specialized strike that releases spores. Landing 7 consecutive strikes within 75 seconds triggers a fungal explosion."
	damfactor = 1

/obj/item/rogueweapon/mace/mushroom
	name = "Lithmyc Mace"
	desc = "A heavy mace forged from fungal-infused metals. Looks spiky!"
	icon_state = "mushroom"
	force = 18
	force_wielded = 24
	max_integrity = 500
	possible_item_intents = list(/datum/intent/mace/strike, /datum/intent/mace/boom, /datum/intent/mace/strike/dislocate)
	gripped_intents = list(/datum/intent/mace/strike, /datum/intent/mace/boom, /datum/intent/mace/strike/dislocate, /datum/intent/mace/smash)
	smeltresult = /obj/item/ingot/lithmyc

/obj/item/rogueweapon/mace/mushroom/Initialize()
	. = ..()
	AddComponent(/datum/component/mushroom_mace)
