/// INTENT DATUMS	v
/datum/intent/katar/cut
	name = "cut"
	icon_state = "incut"
	attack_verb = list("cuts", "slashes")
	animname = "cut"
	blade_class = BCLASS_CUT
	hitsound = list('sound/combat/hits/bladed/smallslash (1).ogg', 'sound/combat/hits/bladed/smallslash (2).ogg', 'sound/combat/hits/bladed/smallslash (3).ogg')
	penfactor = 20
	chargetime = 0
	swingdelay = 0
	damfactor = 1.3
	clickcd = CLICK_CD_FAST
	item_d_type = "slash"

/datum/intent/katar/thrust
	name = "thrust"
	icon_state = "instab"
	attack_verb = list("thrusts")
	animname = "stab"
	blade_class = BCLASS_STAB
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = 25
	chargetime = 0
	clickcd = CLICK_CD_FAST
	item_d_type = "stab"

/datum/intent/lordbash
	name = "bash"
	blade_class = BCLASS_BLUNT
	icon_state = "inbash"
	attack_verb = list("bashes", "strikes")
	penfactor = BLUNT_DEFAULT_PENFACTOR
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR

/datum/intent/lord_electrocute
	name = "electrocute"
	blade_class = null
	icon_state = "inuse"
	tranged = TRUE
	noaa = TRUE

/datum/intent/lord_silence
	name = "silence"
	blade_class = null
	icon_state = "inuse"
	tranged = TRUE
	noaa = TRUE

/datum/intent/knuckles/strike
	name = "punch"
	blade_class = BCLASS_BLUNT
	attack_verb = list("punches", "clocks")
	hitsound = list('sound/combat/hits/punch/punch_hard (1).ogg', 'sound/combat/hits/punch/punch_hard (2).ogg', 'sound/combat/hits/punch/punch_hard (3).ogg')
	chargetime = 0
	penfactor = BLUNT_DEFAULT_PENFACTOR
	clickcd = 8
	swingdelay = 0
	icon_state = "inpunch"
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR // This might be a mistake

/datum/intent/knuckles/smash
	name = "smash"
	blade_class = BCLASS_SMASH
	attack_verb = list("smashes")
	hitsound = list('sound/combat/hits/punch/punch_hard (1).ogg', 'sound/combat/hits/punch/punch_hard (2).ogg', 'sound/combat/hits/punch/punch_hard (3).ogg')
	penfactor = BLUNT_DEFAULT_PENFACTOR
	clickcd = CLICK_CD_MELEE
	swingdelay = 8
	icon_state = "insmash"
	item_d_type = "blunt"

/datum/intent/knuckles/strike/wallop
	name = "wallop"
	blade_class = BCLASS_TWIST
	attack_verb = list("wallops", "thwacks", "thwamps")
	damfactor = 1.1
	intent_intdamage_factor = 0.6
	icon_state = "inbash"	// Wallop is too long for a button; placeholder.

/// INTENT DATUMS	^

/obj/item/rogueweapon/lordscepter
	force = 20
	force_wielded = 20
	possible_item_intents = list(/datum/intent/lordbash, /datum/intent/lord_electrocute, /datum/intent/lord_silence)
	gripped_intents = list(/datum/intent/lordbash)
	name = "master's rod"
	desc = "Bend the knee. Can't be used outside of the manor."
	icon_state = "scepter"
	icon = 'icons/roguetown/weapons/misc32.dmi'
	sharpness = IS_BLUNT
	//dropshrink = 0.75
	wlength = WLENGTH_NORMAL
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_HIP
	associated_skill = /datum/skill/combat/maces
	smeltresult = /obj/item/ingot/iron
	swingsound = BLUNTWOOSH_MED
	minstr = 5
	COOLDOWN_DECLARE(scepter)

	grid_height = 96
	grid_width = 32

/obj/item/rogueweapon/lordscepter/getonmobprop(tag)
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -10,"sy" = -7,"nx" = 11,"ny" = -6,"wx" = -1,"wy" = -6,"ex" = 3,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -90,"eturn" = 90,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.5,"sx" = -1,"sy" = -4,"nx" = 1,"ny" = -3,"wx" = -1,"wy" = -6,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 20,"wturn" = 18,"eturn" = -19,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 0,"sy" = 2,"nx" = 1,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 4,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)

/obj/item/rogueweapon/lordscepter/afterattack(atom/target, mob/user, flag)
	. = ..()
	if(get_dist(user, target) > 7)
		return
	
	user.changeNext_move(CLICK_CD_MELEE)

	if(ishuman(user))
		var/mob/living/carbon/human/HU = user

		if(HU.job != "Grand Duke")
			to_chat(user, span_danger("The rod doesn't obey me."))
			return

		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			var/area/target_area = get_area(H)

			if(!istype(target_area, /area/rogue/indoors/town/manor))
				to_chat(user, span_danger("The rod cannot be used on targets outside of the manor!"))
				return

			if(H == HU)
				return

			if(!COOLDOWN_FINISHED(src, scepter))
				to_chat(user, span_danger("The [src] is not ready yet! [round(COOLDOWN_TIMELEFT(src, scepter) / 10, 1)] seconds left!"))
				return

			if(H.anti_magic_check())
				to_chat(user, span_danger("Something is disrupting the rod's power!"))
				return

			if(!(H in SStreasury.bank_accounts))
				to_chat(user, span_danger("The target must have a Meister account!"))
				return

			if(istype(user.used_intent, /datum/intent/lord_electrocute))
				HU.visible_message(span_warning("[HU] electrocutes [H] with the [src]."))
				user.Beam(target,icon_state="lightning[rand(1,12)]",time=5)
				H.electrocute_act(5, src)
				COOLDOWN_START(src, scepter, 20 SECONDS)
				to_chat(H, span_danger("I'm electrocuted by the scepter!"))
				return

			if(istype(user.used_intent, /datum/intent/lord_silence))
				HU.visible_message("<span class='warning'>[HU] silences [H] with \the [src].</span>")
				H.set_silence(20 SECONDS)
				COOLDOWN_START(src, scepter, 10 SECONDS)
				to_chat(H, "<span class='danger'>I'm silenced by the scepter!</span>")
				return

/obj/item/rogueweapon/mace/stunmace
	force = 15
	force_wielded = 15
	name = "stunmace"
	icon = 'icons/roguetown/weapons/misc32.dmi'
	icon_state = "stunmace0"
	desc = "Pain is our currency here."
	gripped_intents = null
	w_class = WEIGHT_CLASS_NORMAL
	possible_item_intents = list(/datum/intent/mace/strike/stunner, /datum/intent/mace/smash/stunner)
	wbalance = WBALANCE_NORMAL
	minstr = 5
	wdefense = 0
	var/charge = 100
	var/on = FALSE

/datum/intent/mace/strike/stunner/afterchange()
	var/obj/item/rogueweapon/mace/stunmace/I = masteritem
	if(I)
		if(I.on)
			hitsound = list('sound/items/stunmace_hit (1).ogg','sound/items/stunmace_hit (2).ogg')
		else
			hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	. = ..()

/datum/intent/mace/smash/stunner/afterchange()
	var/obj/item/rogueweapon/mace/stunmace/I = masteritem
	if(I)
		if(I.on)
			hitsound = list('sound/items/stunmace_hit (1).ogg','sound/items/stunmace_hit (2).ogg')
		else
			hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	. = ..()

/obj/item/rogueweapon/mace/stunmace/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/rogueweapon/mace/stunmace/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/rogueweapon/mace/stunmace/funny_attack_effects(mob/living/target, mob/living/user, nodmg)
	. = ..()
	if(on)
		target.electrocute_act(5, src)
		charge -= 33
		if(charge <= 0)
			on = FALSE
			charge = 0
			update_icon()
			if(user.a_intent)
				var/datum/intent/I = user.a_intent
				if(istype(I))
					I.afterchange()

/obj/item/rogueweapon/mace/stunmace/update_icon()
	if(on)
		icon_state = "stunmace1"
	else
		icon_state = "stunmace0"

/obj/item/rogueweapon/mace/stunmace/attack_self(mob/user)
	if(on)
		on = FALSE
	else
		if(charge <= 33)
			to_chat(user, span_warning("It's out of juice."))
			return
		user.visible_message(span_warning("[user] flicks [src] on."))
		on = TRUE
		charge--
	playsound(user, pick('sound/items/stunmace_toggle (1).ogg','sound/items/stunmace_toggle (2).ogg','sound/items/stunmace_toggle (3).ogg'), 100, TRUE)
	if(user.a_intent)
		var/datum/intent/I = user.a_intent
		if(istype(I))
			I.afterchange()
	update_icon()
	add_fingerprint(user)

/obj/item/rogueweapon/mace/stunmace/process()
	if(on)
		charge--
	else
		if(charge < 100)
			charge++
	if(charge <= 0)
		on = FALSE
		charge = 0
		update_icon()
		var/mob/user = loc
		if(istype(user))
			if(user.a_intent)
				var/datum/intent/I = user.a_intent
				if(istype(I))
					I.afterchange()
		playsound(src, pick('sound/items/stunmace_toggle (1).ogg','sound/items/stunmace_toggle (2).ogg','sound/items/stunmace_toggle (3).ogg'), 100, TRUE)

/obj/item/rogueweapon/mace/stunmace/extinguish()
	if(on)
		var/mob/living/user = loc
		if(istype(user))
			user.electrocute_act(5, src)
		on = FALSE
		charge = 0
		update_icon()
		playsound(src, pick('sound/items/stunmace_toggle (1).ogg','sound/items/stunmace_toggle (2).ogg','sound/items/stunmace_toggle (3).ogg'), 100, TRUE)

/obj/item/rogueweapon/katar
	slot_flags = ITEM_SLOT_HIP
	force = 24
	possible_item_intents = list(/datum/intent/katar/cut, /datum/intent/katar/thrust, /datum/intent/sword/peel)
	name = "katar"
	desc = "A steel blade that sits above the user's fist. Commonly used by those proficient at unarmed fighting."
	icon_state = "katar"
	icon = 'icons/roguetown/weapons/unarmed32.dmi'
	gripsprite = FALSE
	wlength = WLENGTH_SHORT
	w_class = WEIGHT_CLASS_SMALL
	parrysound = list('sound/combat/parry/bladed/bladedsmall (1).ogg','sound/combat/parry/bladed/bladedsmall (2).ogg','sound/combat/parry/bladed/bladedsmall (3).ogg')
	max_blade_int = 200
	max_integrity = 80
	swingsound = list('sound/combat/wooshes/bladed/wooshsmall (1).ogg','sound/combat/wooshes/bladed/wooshsmall (2).ogg','sound/combat/wooshes/bladed/wooshsmall (3).ogg')
	associated_skill = /datum/skill/combat/unarmed
	pickup_sound = 'sound/foley/equip/swordsmall2.ogg'
	throwforce = 12
	wdefense = 0	//Meant to be used with bracers
	wbalance = WBALANCE_NORMAL
	thrown_bclass = BCLASS_CUT
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/steel
	grid_height = 64
	grid_width = 32
	sharpness_mod = 2	//Can't parry, so it decays quicker on-hit.

/obj/item/rogueweapon/katar/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,"sx" = -7,"sy" = -4,"nx" = 7,"ny" = -4,"wx" = -3,"wy" = -4,"ex" = 1,"ey" = -4,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 110,"sturn" = -110,"wturn" = -110,"eturn" = 110,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)


/obj/item/rogueweapon/katar/abyssor
	name = "barotrauma"
	desc = "A gift from a creature of the sea. The claw is sharpened to a wicked edge."
	icon_state = "abyssorclaw"
	force = 27	//Its thrust will be able to pen 80 stab armor if the wielder has 17 STR. (With softcap)
	max_integrity = 80

/obj/item/rogueweapon/katar/bronze
	name = "bronze katar"
	desc = "A bronze blade that sits above the user's fist. Commonly used by those proficient at unarmed fighting."
	icon_state = "bronzekatar"
	force = 21 //-3 damage malus, same as the knuckles.
	max_integrity = 80
	smeltresult = /obj/item/ingot/bronze

/obj/item/rogueweapon/katar/punchdagger
	name = "punch dagger"
	desc = "A weapon that combines the ergonomics of the Ranesheni katar with the capabilities of the Western Psydonian \"knight-killers\". It can be tied around the wrist."
	slot_flags = ITEM_SLOT_WRISTS
	max_integrity = 120		//Steel dagger -30
	force = 15		//Steel dagger -5
	throwforce = 8
	wdefense = 0	//Hell no!
	thrown_bclass = BCLASS_STAB
	possible_item_intents = list(/datum/intent/dagger/thrust, /datum/intent/dagger/thrust/pick)
	icon_state = "plug"

/obj/item/rogueweapon/katar/punchdagger/frei
	name = "vývrtka"
	desc = "A type of punch dagger of Aavnic make initially designed to level the playing field with an orc in fisticuffs, its serrated edges and longer, thinner point are designed to maximize pain for the recipient. It's aptly given the name of \"corkscrew\", and this specific one has the colours of Szöréndnížina. Can be worn on your ring slot."
	icon_state = "freiplug"
	slot_flags = ITEM_SLOT_RING

/obj/item/rogueweapon/katar/psydon
	name = "psydonic katar"
	desc = "An exotic weapon taken from the hands of wandering monks, an esoteric design to the Otavan Orthodoxy. Special care was taken into account towards the user's knuckles: silver-tipped steel from tip to edges, and His holy cross reinforcing the heart of the weapon, with curved shoulders to allow its user to deflect incoming blows - provided they lead it in with the blade."
	icon_state = "psykatar"
	force = 19
	wdefense = 3
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silverblessed

/obj/item/rogueweapon/katar/psydon/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/knuckles/psydon
	name = "psydonic knuckles"
	desc = "A simple piece of harm molded in a holy mixture of steel and silver, finished with three stumps - Psydon's crown - to crush the heretics' garments and armor into smithereens."
	icon_state = "psyknuckle"
	force = 17
	wdefense = 5
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silverblessed

/obj/item/rogueweapon/knuckles/psydon/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/knuckles/psydon/old
	name = "enduring knuckles"
	desc = "A simple piece of harm molded in a holy mixture of steel and silver, its holy blessing long since faded. You are HIS weapon, you needn't fear Aeon."
	icon_state = "psyknuckle"
	force = 22
	wdefense = 6
	is_silver = FALSE
	smeltresult = /obj/item/ingot/steel
	color = COLOR_FLOORTILE_GRAY

/obj/item/rogueweapon/knuckles/psydon/old/ComponentInitialize()
	return

/obj/item/rogueweapon/knuckles
	name = "steel knuckles"
	desc = "A mean looking pair of steel knuckles."
	force = 25
	possible_item_intents = list(/datum/intent/knuckles/strike,/datum/intent/knuckles/smash, /datum/intent/knuckles/strike/wallop)
	icon = 'icons/roguetown/weapons/unarmed32.dmi'
	icon_state = "steelknuckle"
	gripsprite = FALSE
	wlength = WLENGTH_SHORT
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_HIP
	parrysound = list('sound/combat/parry/pugilism/unarmparry (1).ogg','sound/combat/parry/pugilism/unarmparry (2).ogg','sound/combat/parry/pugilism/unarmparry (3).ogg')
	sharpness = IS_BLUNT
	max_integrity = 200
	swingsound = list('sound/combat/wooshes/punch/punchwoosh (1).ogg','sound/combat/wooshes/punch/punchwoosh (2).ogg','sound/combat/wooshes/punch/punchwoosh (3).ogg')
	associated_skill = /datum/skill/combat/unarmed
	throwforce = 12
	wdefense = 4
	wbalance = WBALANCE_SWIFT
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/steel
	grid_width = 64
	grid_height = 32

/obj/item/rogueweapon/knuckles/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.2,"sx" = -7,"sy" = -4,"nx" = 7,"ny" = -4,"wx" = -3,"wy" = -4,"ex" = 1,"ey" = -4,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 110,"sturn" = -110,"wturn" = -110,"eturn" = 110,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.1,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/knuckles/bronzeknuckles
	name = "bronze knuckles"
	desc = "A mean looking pair of bronze knuckles. Mildly heavier than it's steel counterpart, making it a solid defensive option, if less wieldy."
	force = 22
	possible_item_intents = list(/datum/intent/knuckles/strike, /datum/intent/knuckles/smash, /datum/intent/knuckles/strike/wallop)
	icon = 'icons/roguetown/weapons/unarmed32.dmi'
	icon_state = "bronzeknuckle"
	gripsprite = FALSE
	wlength = WLENGTH_SHORT
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_HIP
	parrysound = list('sound/combat/parry/pugilism/unarmparry (1).ogg','sound/combat/parry/pugilism/unarmparry (2).ogg','sound/combat/parry/pugilism/unarmparry (3).ogg')
	sharpness = IS_BLUNT
	max_integrity = 200
	swingsound = list('sound/combat/wooshes/punch/punchwoosh (1).ogg','sound/combat/wooshes/punch/punchwoosh (2).ogg','sound/combat/wooshes/punch/punchwoosh (3).ogg')
	associated_skill = /datum/skill/combat/unarmed
	throwforce = 12
	wdefense = 6
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/bronze

/obj/item/rogueweapon/knuckles/aknuckles
	name = "decrepit knuckles"
	desc = "a set of knuckles made of ancient metals, Aeon's grasp wither their form."
	icon_state = "aknuckle"
	force = 12
	max_integrity = 100
	wdefense = 4
	smeltresult = /obj/item/ingot/aalloy
	blade_dulling = DULLING_SHAFT_CONJURED

/obj/item/rogueweapon/knuckles/paknuckles
	name = "ancient knuckles"
	desc = "a set of knuckles made of ancient metals, Aeon's grasp has been lifted from their form."
	icon_state = "aknuckle"
	smeltresult = /obj/item/ingot/aaslag


/obj/item/rogueweapon/knuckles/eora
	name = "close caress"
	desc = "Some times call for a more intimate approach."
	force = 24
	icon_state = "eoraknuckle"

///Peasantry / Militia Weapon Pack///

/obj/item/rogueweapon/woodstaff/militia
	force = 20
	force_wielded = 30
	possible_item_intents = list(SPEAR_BASH, /datum/intent/spear/cut)
	gripped_intents = list(/datum/intent/pick/ranged, /datum/intent/spear/thrust, SPEAR_BASH)
	name = "militia goedendag"
	desc = "Clubs - and their spiked descendants - are older than most languages and civilizations. Tyme hasn't made them any less deadly, however. "
	icon_state = "peasantwarclub"
	icon = 'icons/roguetown/weapons/64.dmi'
	smeltresult = /obj/item/rogueore/coal
	sharpness = IS_SHARP
	walking_stick = TRUE
	wdefense = 6
	max_blade_int = 140

/obj/item/rogueweapon/woodstaff/militia/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.8,"sx" = -9,"sy" = 5,"nx" = 9,"ny" = 5,"wx" = -4,"wy" = 4,"ex" = 4,"ey" = 4,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 32,"eturn" = -23,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.8,"sx" = 8,"sy" = 0,"nx" = -1,"ny" = 0,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)

/obj/item/rogueweapon/greataxe/militia
	name = "militia war axe"
	desc = "Shovels have always held some manner of importance in a militiaman's lyfe. Instead of digging corpsepits, however, this poleaxe will now fill them up."
	icon_state = "peasantwaraxe"
	possible_item_intents = list(/datum/intent/axe/cut, /datum/intent/axe/chop, SPEAR_BASH) //bash is for nonlethal takedowns, only targets limbs
	gripped_intents = list(/datum/intent/rend/reach, /datum/intent/axe/chop/battle/greataxe, /datum/intent/sword/peel/big, SPEAR_BASH)
	force = 15
	force_wielded = 25
	minstr = 10
	max_blade_int = 130
	anvilrepair = /datum/skill/craft/carpentry
	smeltresult = /obj/item/rogueore/coal
	wdefense = 4
	wbalance = WBALANCE_HEAVY

/obj/item/rogueweapon/greataxe/militia/silver
	name = "silver militia shovelaxe"
	desc = "'Do you think Psydon stays in Heaven because He too lives in fear of what He's created?' </br>A silver shovel, improvised - perhaps, by the hands of a particularly desperate gravedigger - to fill a polearm's duty."
	icon_state = "silvershovelwaraxe"
	possible_item_intents = list(/datum/intent/axe/cut, /datum/intent/axe/chop, SPEAR_BASH) //bash is for nonlethal takedowns, only targets limbs
	gripped_intents = list(/datum/intent/rend/reach, /datum/intent/axe/chop/battle/greataxe, /datum/intent/sword/peel/big, SPEAR_BASH)
	force = 15
	force_wielded = 25
	minstr = 11
	max_blade_int = 200
	anvilrepair = /datum/skill/craft/carpentry
	smeltresult = /obj/item/ingot/silver
	wdefense = 6
	wbalance = WBALANCE_HEAVY
	is_silver = TRUE

/obj/item/rogueweapon/greataxe/militia/silver/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/greataxe/militia/silver/preblessed/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_TENNITE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/spear/militia
	force = 18
	force_wielded = 30
	possible_item_intents = list(SPEAR_THRUST_1H, SPEAR_CUT_1H) 
	gripped_intents = list(SPEAR_THRUST, SPEAR_CUT, SPEAR_BASH)
	name = "militia spear"
	desc = "Pitchforks and hoes traditionally till the soil. In tymes of peril, however, it isn't uncommon for a militiaman to pound them into polearms."
	icon_state = "peasantwarspear"
	icon = 'icons/roguetown/weapons/64.dmi'
	minstr = 8
	max_blade_int = 120
	max_integrity = 200
	anvilrepair = /datum/skill/craft/carpentry
	smeltresult = /obj/item/rogueore/coal
	resistance_flags = FIRE_PROOF
	light_system = MOVABLE_LIGHT
	light_power = 5
	light_outer_range = 5
	light_on = FALSE
	light_color = "#db892b"
	var/is_loaded = FALSE 
	var/list/hay_types = list(/obj/structure/fluff/nest, /obj/structure/composter, /obj/structure/flora/roguegrass, /obj/item/reagent_containers/food/snacks/grown/wheat)

/obj/item/rogueweapon/spear/militia/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/ignitable/warspear)

/obj/item/rogueweapon/spear/militia/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(user.Adjacent(target) || get_dist(target, user) <= user.used_intent?.reach)
		if(!is_loaded)
			for(var/type in hay_types)
				if(istype(target, type))
					load_hay()
					update_icon()
					user.regenerate_icons()
					visible_message(span_warning("[user] grabs a clump of [target] and wraps it around \the [src]!"))
					playsound(src, 'sound/misc/hay_collect.ogg', 100)
					qdel(target)
					break

/obj/item/rogueweapon/spear/militia/proc/load_hay()
	var/datum/component/ignitable/CI = GetComponent(/datum/component/ignitable)
	is_loaded = TRUE
	toggle_state = "peasantwarspear_hay"
	icon_state = "[toggle_state][wielded ? "1" : ""]"
	CI.make_ignitable()

/datum/component/ignitable/warspear
	single_use = TRUE
	is_ignitable = FALSE
	icon_state_ignited = "peasantwarspear_hayfire"


/datum/component/ignitable/warspear/light_off()
	..()
	if(istype(parent, /obj/item/rogueweapon/spear/militia))
		var/obj/item/rogueweapon/spear/militia/P = parent
		P.is_loaded = FALSE

//Component used to make any item gain the ability to be lit afire and turned into a light source / usable for single-use fire attack.
//Uses toggle_state for the 'on-fire' sprites.
//By default, all it does is become ignited when you click a fire / light source with it, and spread it to anything else, then extinguish.
/datum/component/ignitable
	var/is_ignitable = TRUE	//This var makes it actually ignitable, so you want to handle it on a per-item-with-component basis.
	var/is_active
	var/single_use = TRUE
	var/icon_state_ignited

/datum/component/ignitable/Initialize(...)
	. = ..()
	RegisterSignal(parent, COMSIG_ITEM_AFTERATTACK, PROC_REF(item_afterattack))
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(parent, COMSIG_ATOM_FIRE_ACT, PROC_REF(on_fireact))

/datum/component/ignitable/proc/on_fireact(added, maxstacks)
	if(is_ignitable && !is_active)
		light_on()

/datum/component/ignitable/proc/make_ignitable()
	if(!is_ignitable && !is_active)
		is_ignitable = TRUE

/datum/component/ignitable/proc/light_on()
	var/obj/I = parent
	I.set_light_on(TRUE)
	playsound(I.loc, 'sound/items/firelight.ogg', 100)
	is_active = TRUE
	is_ignitable = FALSE
	update_icon()

/datum/component/ignitable/proc/light_off()
	var/obj/I = parent
	I.set_light_on(FALSE)
	playsound(get_turf(I), 'sound/items/firesnuff.ogg', 100)

/datum/component/ignitable/proc/update_icon()
	var/obj/item/I = parent
	if(is_active)
		I.toggle_state = "[icon_state_ignited]"
		I.icon_state = "[icon_state_ignited][I.wielded ? "1" : ""]"
	else
		I.icon_state = "[initial(I.icon_state)][I.wielded ? "1" : ""]"
		I.toggle_state = null
		I.update_icon()


/datum/component/ignitable/proc/item_afterattack(obj/item/source, atom/target, mob/user, proximity_flag, click_parameters)
	var/ignited = FALSE
	if(user.used_intent?.reach >= get_dist(target, user))
		if(is_active)
			if(isobj(target))
				var/obj/O = target
				if(!(O.resistance_flags & FIRE_PROOF))
					O.spark_act()
					O.fire_act()
					ignited = TRUE
			if(isliving(target))
				var/mob/living/M = target
				M.adjust_fire_stacks(5)
				M.ignite_mob()
				ignited = TRUE
			if(ignited && single_use)
				is_active = FALSE
				light_off()
				update_icon()
				user.regenerate_icons()
		else if(is_ignitable && !is_active)
			if(isobj(target))
				var/obj/O = target
				if(O.damtype == BURN || O.light_on == TRUE)	//Super hacky, but should work on every conventional source you'd expect to ignite it. But also a few other weird ones.
					light_on()
					user.regenerate_icons()


	
/datum/component/ignitable/proc/on_examine(datum/source, mob/user, list/examine_list)
	return

/obj/item/rogueweapon/scythe
	force = 15
	force_wielded = 25
	possible_item_intents = list(SPEAR_BASH)
	gripped_intents = list(/datum/intent/spear/cut/scythe, SPEAR_BASH, MACE_STRIKE)
	name = "scythe"
	desc = "The bane of fields, the trimmer of grass, the harvester of wheat, and - depending on who you ask - the shepherd of souls to the afterlyfe."
	icon_state = "peasantscythe"
	icon = 'icons/roguetown/weapons/64.dmi'
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	wlength = WLENGTH_GREAT
	w_class = WEIGHT_CLASS_BULKY
	minstr = 8
	max_blade_int = 120
	anvilrepair = /datum/skill/craft/carpentry
	smeltresult = /obj/item/rogueore/coal
	associated_skill = /datum/skill/labor/farming
	walking_stick = TRUE
	wdefense = 6
	thrown_bclass = BCLASS_BLUNT
	throwforce = 10
	resistance_flags = FLAMMABLE

/obj/item/rogueweapon/scythe/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.7,"sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.7,"sx" = 5,"sy" = -3,"nx" = -5,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)


/obj/item/rogueweapon/pick/militia
	name = "militia warpick"
	desc = "At the end of the dae, a knight's bascinet isn't much different than a particularly large stone. After all, both tend to rupture with sobering ease when introduced to a sharpened pickend."
	force = 20
	force_wielded = 25
	possible_item_intents = list(/datum/intent/pick/bad)
	gripped_intents = list(/datum/intent/pick, /datum/intent/stab/militia)
	icon_state = "milpick"
	icon = 'icons/roguetown/weapons/misc32.dmi'
	sharpness = IS_SHARP
	wlength = WLENGTH_SHORT
	max_blade_int = 140
	max_integrity = 400
	slot_flags = ITEM_SLOT_HIP
	associated_skill = /datum/skill/labor/mining
	anvilrepair = /datum/skill/craft/carpentry
	smeltresult = /obj/item/ingot/iron
	wdefense = 2
	wdefense_wbonus = 4
	wbalance = WBALANCE_NORMAL
/obj/item/rogueweapon/pick/militia/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -11,"sy" = -10,"nx" = 13,"ny" = -9,"wx" = -7,"wy" = -9,"ex" = 7,"ey" = -11,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -90,"eturn" = 90,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)


/obj/item/rogueweapon/pick/militia/steel
	force = 25
	force_wielded = 30
	name = "militia steel warpick"
	desc = "At the end of the dae, a knight's bascinet isn't much different than a particularly large stone. After all, both tend to rupture with sobering ease when introduced to a sharpened pickend. This one is honed out of steel parts."
	icon_state = "milsteelpick"
	max_blade_int = 180
	max_integrity = 600
	associated_skill = /datum/skill/combat/axes
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/steel
	wdefense = 3
	wdefense_wbonus = 5
	wbalance = WBALANCE_HEAVY
/obj/item/rogueweapon/pick/militia/steel/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -11,"sy" = -10,"nx" = 13,"ny" = -9,"wx" = -7,"wy" = -9,"ex" = 7,"ey" = -11,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -90,"eturn" = 90,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)


/obj/item/rogueweapon/sword/falchion/militia
	name = "maciejowski"
	desc = "Fittingly coined as a 'peasant's falchion', this hunting sword's blade has been retempered to hunt the most dangerous game. Those jagged edges are perfect for tearing into flesh-and-maille."
	possible_item_intents = list(/datum/intent/sword/cut, /datum/intent/sword/strike)
	icon_state = "maciejowski"
	gripped_intents = list(/datum/intent/rend, /datum/intent/sword/chop/militia, /datum/intent/sword/peel, /datum/intent/sword/strike)
	force = 18
	force_wielded = 25
	anvilrepair = /datum/skill/craft/carpentry
	smeltresult = /obj/item/ingot/iron
	wdefense = 3
	wbalance = WBALANCE_HEAVY

/obj/item/rogueweapon/handclaw
	slot_flags = ITEM_SLOT_HIP
	name = "Iron Hound Claws"
	desc = "A pair of heavily curved claws, styled after beasts of the wilds for rending bare flesh, \
			A show of the continual worship and veneration of beasts of strength in Gronn."
	icon_state = "ironclaws"
	icon = 'icons/roguetown/weapons/unarmed32.dmi'
	wdefense = 5
	force = 30
	possible_item_intents = list(/datum/intent/claw/cut/iron, /datum/intent/claw/lunge/iron, /datum/intent/claw/rend)
	wbalance = WBALANCE_NORMAL
	max_blade_int = 300
	max_integrity = 200
	gripsprite = FALSE
	parrysound = list('sound/combat/parry/bladed/bladedthin (1).ogg', 'sound/combat/parry/bladed/bladedthin (2).ogg', 'sound/combat/parry/bladed/bladedthin (3).ogg')
	swingsound = list('sound/combat/wooshes/bladed/wooshmed (1).ogg','sound/combat/wooshes/bladed/wooshmed (2).ogg','sound/combat/wooshes/bladed/wooshmed (3).ogg')
	swingsound = BLADEWOOSH_SMALL
	wlength = WLENGTH_NORMAL
	w_class = WEIGHT_CLASS_NORMAL
	associated_skill = /datum/skill/combat/unarmed
	pickup_sound = 'sound/foley/equip/swordsmall2.ogg'
	throwforce = 12
	thrown_bclass = BCLASS_CUT
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/iron
	grid_height = 96
	grid_width = 32

/obj/item/rogueweapon/handclaw/steel
	name = "Steel Mantis Claws"
	desc = "A pair of steel claws, An uncommon sight in Gronn as they do not forge their own steel, \
			Their longer blades offer a superior defence option but their added weight slows them down."
	icon_state = "steelclaws"
	icon = 'icons/roguetown/weapons/unarmed32.dmi'
	wdefense = 6
	force = 35
	possible_item_intents = list(/datum/intent/claw/cut/steel, /datum/intent/claw/lunge/steel, /datum/intent/claw/rend/steel)
	wbalance = WBALANCE_HEAVY
	max_blade_int = 180
	max_integrity = 200
	smeltresult = /obj/item/ingot/steel
	sharpness_mod = 2

/obj/item/rogueweapon/handclaw/gronn
	name = "Gronn Beast Claws"
	desc = "A pair of uniquely reinforced iron claws forged with the addition of bone by the Iskarn shamans of the Northern Empty. \
			Their unique design aids them in slipping between the plates in armor and their light weight supports rapid aggressive slashes. \
			'To see the claws of the four, Is to see the true danger of the north. Not man, Not land but beast. We are all prey in their eyes.'"
	icon_state = "gronnclaws"
	icon = 'icons/roguetown/weapons/unarmed32.dmi'
	wdefense = 3
	force = 25
	possible_item_intents = list(/datum/intent/claw/cut/gronn, /datum/intent/claw/lunge/gronn, /datum/intent/claw/rend)
	wbalance = WBALANCE_SWIFT
	max_blade_int = 200
	max_integrity = 200


/obj/item/rogueweapon/handclaw/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,"sx" = -7,"sy" = -4,"nx" = 7,"ny" = -4,"wx" = -3,"wy" = -4,"ex" = 1,"ey" = -4,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 110,"sturn" = -110,"wturn" = -110,"eturn" = 110,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/datum/intent/claw/lunge
	name = "lunge"
	icon_state = "inimpale"
	attack_verb = list("lunges")
	animname = "stab"
	blade_class = BCLASS_STAB
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')

/datum/intent/claw/lunge/iron
	damfactor = 1.2
	swingdelay = 8
	clickcd = CLICK_CD_MELEE
	penfactor = 35

/datum/intent/claw/lunge/steel
	damfactor = 1.2
	swingdelay = 12
	clickcd = CLICK_CD_HEAVY
	penfactor = 35

/datum/intent/claw/lunge/gronn
	damfactor = 1.1
	swingdelay = 5
	clickcd = 10
	penfactor = 45

/datum/intent/claw/cut
	name = "cut"
	icon_state = "incut"
	attack_verb = list("cuts", "slashes")
	animname = "cut"
	blade_class = BCLASS_CUT
	hitsound = list('sound/combat/hits/bladed/smallslash (1).ogg', 'sound/combat/hits/bladed/smallslash (2).ogg', 'sound/combat/hits/bladed/smallslash (3).ogg')
	item_d_type = "slash"

/datum/intent/claw/cut/iron
	penfactor = 20
	swingdelay = 8
	damfactor = 1.4
	clickcd = CLICK_CD_HEAVY

/datum/intent/claw/cut/steel
	penfactor = 10
	swingdelay = 4
	damfactor = 1.3
	clickcd = CLICK_CD_HEAVY

/datum/intent/claw/cut/gronn
	penfactor = 30
	swingdelay = 0
	damfactor = 1.1
	clickcd = CLICK_CD_MELEE

/datum/intent/claw/rend
	name = "rend"
	icon_state = "inrend"
	attack_verb = list("rends")
	animname = "cut"
	blade_class = BCLASS_CHOP
	reach = 1
	penfactor = BLUNT_DEFAULT_PENFACTOR
	swingdelay = 20
	damfactor = 2.5
	clickcd = CLICK_CD_HEAVY
	no_early_release = TRUE
	hitsound = list('sound/combat/hits/bladed/genslash (1).ogg', 'sound/combat/hits/bladed/genslash (2).ogg', 'sound/combat/hits/bladed/genslash (3).ogg')
	item_d_type = "slash"
	misscost = 10
	intent_intdamage_factor = 0.05

/datum/intent/claw/rend/steel
	damfactor = 3

/datum/intent/peculate
	name = "peculate"
	hitsound = null
	desc = "Thieve the appearance of another."
	icon_state = "peculate"

//Unique assassin/antag dagger.
/obj/item/rogueweapon/huntingknife/idagger/steel/profane
	name = "profane dagger"
	desc = "A profane dagger made of cursed black steel. Whispers emanate from the gem on its hilt."
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/thrust, /datum/intent/peculate)
	sellprice = 250
	icon_state = "pdagger"
	embedding = list("embed_chance" = 0) // Embedding the cursed dagger has the potential to cause duping issues. Keep it like this unless you want to do a lot of bug hunting.
	resistance_flags = INDESTRUCTIBLE
	stealthy_audio = TRUE

/obj/item/rogueweapon/huntingknife/idagger/steel/profane/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_ASSASSIN))
		. += "profane dagger whispers, \"[span_danger("Here we are!")]\""

/obj/item/rogueweapon/huntingknife/idagger/steel/profane/pickup(mob/living/M)
	. = ..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if (!HAS_TRAIT(H, TRAIT_ASSASSIN)) // Non-assassins don't like holding the profane dagger.
			H.add_stress(/datum/stressevent/profane)
			to_chat(M, "<span class='danger'>Your breath chills as you pick up the dagger. You feel a sense of morbid wrongness!</span>")
			var/message = pick(
				"<span class='danger'>Help me...</span>",
				"<span class='danger'>Save me...</span>",
				"<span class='danger'>It's cold...</span>",
				"<span class='danger'>Free us...please...</span>",
				"<span class='danger'>Necra...deliver...us...</span>")
//			H.visible_message("profane dagger whispers, \"[message]\"")
			to_chat(M, "profane dagger whispers, \"[message]\"")
		else
			var/message = pick(
				"<span class='danger'>Why...</span>",
				"<span class='danger'>...Who sent you?</span>",
				"<span class='danger'>...You will burn for what you've done...</span>",
				"<span class='danger'>I hate you...</span>",
				"<span class='danger'>Someone stop them!</span>",
				"<span class='danger'>Guards! Help!</span>",
				"<span class='danger'>...What's that in your hand?</span>",
				"<span class='danger'>...You love me...don't you?</span>",
				"<span class='danger'>Wait...don't I know you?</span>",
				"<span class='danger'>I thought you were...my friend...</span>",
				"<span class='danger'>How long have I been in here...</span>")
//			H.visible_message("profane dagger whispers, \"[message]\"")
			to_chat(M, "profane dagger whispers, \"[message]\"")

/obj/item/rogueweapon/huntingknife/idagger/steel/profane/pre_attack(mob/living/carbon/human/target, mob/living/user = usr, params)
	if(!istype(target))
		return FALSE
	if(target.has_flaw(/datum/charflaw/hunted)) // Check to see if the dagger will do 20 damage or 14
		force = 20 * 2	//vs trait havers, 2x damage over a steel knife
	else
		force = 20 + 4	//vs non-trait havers, 4 more damage over a steel knife
	return FALSE

/obj/item/rogueweapon/huntingknife/idagger/steel/profane/afterattack(mob/living/carbon/human/target, mob/living/user = usr, proximity)
	. = ..()
	if(!ishuman(target))
		return
	if(target.stat == DEAD || (target.health < target.crit_threshold)) // Trigger soul steal or identity theft if the target is either dead or in crit
		if(istype(user.used_intent, /datum/intent/peculate))
			if(!ishuman(user)) // carbons don't have all features of a human
				to_chat(user, span_danger("You can't do that!"))
				return
			var/obj/item/bodypart/head/target_head = target.get_bodypart(BODY_ZONE_HEAD)
			if(QDELETED(target_head))
				to_chat(user, span_notice("I need their head or else I can't confirm the blood-bounty!"))
				return

			var/datum/beam/transfer_beam = user.Beam(target, icon_state = "drain_life", time = 6 SECONDS)

			playsound(
				user,
				get_sfx("changeling_absorb"), //todo: turn sound keys into defines.
				100,
			)
			to_chat(user, span_danger("I start absorbing [target]'s identity."))
			if(!do_after(user, 3 SECONDS, target = target))
				qdel(transfer_beam)
				return

			playsound( // and anotha one
				user,
				get_sfx("changeling_absorb"),
				100,
			)

			if(!do_after(user, 3 SECONDS, target = target))
				qdel(transfer_beam)
				return

			if(!user.client)
				qdel(transfer_beam)
				return
			qdel(transfer_beam)

			var/mob/living/carbon/human/human_user = user

			human_user.copy_physical_features(target)
			to_chat(user, span_purple("I take on a new face.."))
			ADD_TRAIT(target, TRAIT_DISFIGURED, TRAIT_GENERIC)

			return

		if(target.has_flaw(/datum/charflaw/hunted)) // The profane dagger only thirsts for those who are hunted, by flaw or by zizoid curse.
			if(target.client == null) //See if the target's soul has left their body
				to_chat(user, "<span class='danger'>Your target's soul has already escaped its corpse...you try to call it back!</span>")
				get_profane_ghost(target,user) //Proc to capture a soul that has left the body.
			else
				user.adjust_triumphs(1)
				init_profane_soul(target, user) //If they are still in their body, send them to the dagger!

/obj/item/rogueweapon/huntingknife/idagger/steel/profane/proc/init_profane_soul(mob/living/carbon/human/target, mob/user)
	record_featured_stat(FEATURED_STATS_CRIMINALS, user)
	record_round_statistic(STATS_ASSASSINATIONS)
	var/mob/dead/observer/profane/S = new /mob/dead/observer/profane(src)
	S.AddComponent(/datum/component/profaned, src)
	S.name = "soul of [target.real_name]"
	S.real_name = "soul of [target.real_name]"
	S.deadchat_name = target.real_name
	S.ManualFollow(src)
	S.key = target.key
	S.language_holder = target.language_holder.copy(S)
	target.visible_message("<span class='danger'>[target]'s soul is pulled from their body and sucked into the profane dagger!</span>", "<span class='danger'>My soul is trapped within the profane dagger. Damnation!</span>")
	playsound(src, 'sound/magic/soulsteal.ogg', 100, extrarange = 5)
	blade_int = max_blade_int // Stealing a soul successfully sharpens the blade.
	obj_fix(max_integrity) // And fixes the dagger. No blacksmith required!

/obj/item/rogueweapon/huntingknife/idagger/steel/profane/proc/get_profane_ghost(mob/living/carbon/human/target, mob/user)
	var/mob/dead/observer/chosen_ghost
	var/mob/living/carbon/spirit/underworld_spirit = target.get_spirit() //Check if a soul has already gone to the underworld
	if(underworld_spirit) // If they are in the underworld, pull them back to the real world and make them a normal ghost. Necra can't save you now!
		var/mob/dead/observer/ghost = underworld_spirit.ghostize()
		chosen_ghost = ghost.get_ghost(TRUE,TRUE)
	else //Otherwise, try to get a ghost from the real world
		chosen_ghost = target.get_ghost(TRUE,TRUE)
	if(!chosen_ghost || !chosen_ghost.client) // If there is no valid ghost or if that ghost has no active player
		return FALSE
	user.adjust_triumphs(1)
	init_profane_soul(target, user) // If we got the soul, store them in the dagger.
	qdel(target) // Get rid of that ghost!
	return TRUE

/obj/item/rogueweapon/huntingknife/idagger/steel/profane/proc/release_profane_souls(mob/user) // For ways to release the souls trapped within a profane dagger, such as a Necrite burial rite. Returns the number of freed souls.
	var/freed_souls = 0
	for(var/mob/dead/observer/profane/A in src) // for every trapped soul in the dagger, whether they have left the game or not
		to_chat(A, "<b>I have been freed from my vile prison, I await Necra's cold grasp. Salvation!</b>")
		A.returntolobby() //Send the trapped soul back to the lobby
		user.visible_message("<span class='warning'>The [A.name] flows out from the profane dagger, finally free of its grasp.</span>")
		freed_souls += 1
	user.visible_message("<span class='warning'>The profane dagger shatters into putrid smoke!</span>")
	qdel(src) // Delete the dagger. Forevermore.
	return freed_souls

/datum/component/profaned
	var/atom/movable/container

/datum/component/profaned/Initialize(atom/movable/container)
	if(!istype(parent, /mob/dead/observer/profane))
		return COMPONENT_INCOMPATIBLE
	var/mob/dead/observer/profane/S = parent

	src.container = container

	S.forceMove(container)
