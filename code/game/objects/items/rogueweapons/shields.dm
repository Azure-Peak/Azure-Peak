/obj/item/rogueweapon/shield
	name = ""
	desc = ""
	icon_state = ""
	icon = 'icons/roguetown/weapons/shields32.dmi'
	slot_flags = ITEM_SLOT_BACK
	flags_1 = null
	force = 10
	throwforce = 5
	throw_speed = 1
	throw_range = 3
	w_class = WEIGHT_CLASS_BULKY
	possible_item_intents = list(SHIELD_BASH, SHIELD_BLOCK, SHIELD_SMASH)
	block_chance = 0
	sharpness = IS_BLUNT
	wlength = WLENGTH_SHORT
	resistance_flags = FLAMMABLE
	can_parry = TRUE
	associated_skill = /datum/skill/combat/shields		//Trained via blocking or attacking dummys with; makes better at parrying w/ shields.
	wdefense = 10										//should be pretty baller
	var/coverage = 50
	parrysound = list('sound/combat/parry/shield/towershield (1).ogg','sound/combat/parry/shield/towershield (2).ogg','sound/combat/parry/shield/towershield (3).ogg')
	parrysound = list('sound/combat/parry/shield/towershield (1).ogg','sound/combat/parry/shield/towershield (2).ogg','sound/combat/parry/shield/towershield (3).ogg')
	max_integrity = 100
	anvilrepair = /datum/skill/craft/carpentry
	COOLDOWN_DECLARE(shield_bang)
	special = /datum/special_intent/limbguard


/obj/item/rogueweapon/shield/attackby(obj/item/attackby_item, mob/user, params)

	// Shield banging
	if(src == user.get_inactive_held_item())
		if(istype(attackby_item, /obj/item/rogueweapon))
			if(!COOLDOWN_FINISHED(src, shield_bang))
				return
			user.visible_message(span_danger("[user] bangs [src] with [attackby_item]!"))
			playsound(user.loc, 'sound/combat/shieldbang.ogg', 50, TRUE)
			COOLDOWN_START(src, shield_bang, SHIELD_BANG_COOLDOWN)
			return

	return ..()

/obj/item/rogueweapon/shield/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the projectile", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	SEND_SIGNAL(src, COMSIG_ITEM_HIT_REACT, args)
	var/mob/attacker
	var/obj/item/I
	if(attack_type == THROWN_PROJECTILE_ATTACK)
		if(istype(hitby, /obj/item)) // can't trust mob -> item assignments
			I = hitby
		if(I?.thrownby)
			attacker = I.thrownby
	if(attack_type == PROJECTILE_ATTACK)
		var/obj/projectile/P = hitby
		if(P?.firer)
			attacker = P.firer
	if(attacker && istype(attacker))
		if (!owner.can_see_cone(attacker))
			return FALSE
		if(obj_broken) // No blocking with a broken shield you fool
			return FALSE
		if((owner.client?.chargedprog == 100 && owner.used_intent?.tranged) || prob(coverage))
			owner.visible_message(span_danger("[owner] expertly blocks [hitby] with [src]!"))
			src.take_damage(floor(damage / 4))
			return TRUE
	return FALSE

/datum/intent/shield/bash
	name = "bash"
	icon_state = "inbash"
	hitsound = list('sound/combat/shieldbash_wood.ogg')
	chargetime = 0
	penfactor = BLUNT_DEFAULT_PENFACTOR
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

/datum/intent/shield/block/metal
	hitsound = list('sound/combat/parry/shield/metalshield (1).ogg')

/datum/intent/mace/smash/shield
	hitsound = list('sound/combat/shieldbash_wood.ogg')

/datum/intent/mace/smash/shield/metal
	hitsound = list('sound/combat/parry/shield/metalshield (1).ogg')

/obj/item/rogueweapon/shield/wood
	name = "wooden shield"
	desc = "A sturdy wooden shield. Will block anything you can imagine."
	icon_state = "woodsh"
	dropshrink = 0.8
	anvilrepair = /datum/skill/craft/carpentry
	coverage = 30

/obj/item/rogueweapon/shield/wood/deprived
	name = "ghastly shield"
	desc = "A frail looking amalgamation of planks. Yet somehow, the very wood itself seem to be filling you with resolve."
	icon_state = "deprived"
	coverage = 40
	max_integrity = 200

/obj/item/rogueweapon/shield/attack_right(mob/user)
	if(overlays.len)
		..()
		return

	var/icon/J = new('icons/roguetown/weapons/shield_heraldry.dmi')
	var/list/istates = J.IconStates()
	for(var/icon_s in istates)
		if(!findtext(icon_s, "[icon_state]_"))
			istates.Remove(icon_s)
			continue
		istates.Add(replacetextEx(icon_s, "[icon_state]_", ""))
		istates.Remove(icon_s)

	if(!istates.len)
		..()
		return

	var/picked_name = input(user, "Choose a Heraldry", "ROGUETOWN", name) as null|anything in sortList(istates)
	if(!picked_name)
		picked_name = "none"
	var/mutable_appearance/M = mutable_appearance('icons/roguetown/weapons/shield_heraldry.dmi', "[icon_state]_[picked_name]")
	M.appearance_flags = NO_CLIENT_COLOR
	add_overlay(M)
	if(alert("Are you pleased with your heraldry?", "Heraldry", "Yes", "No") != "Yes")
		cut_overlays()
	
	update_icon()

/obj/item/rogueweapon/shield/wood/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -5,"sy" = -1,"nx" = 6,"ny" = -1,"wx" = 0,"wy" = -2,"ex" = 0,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = 1,"sy" = 4,"nx" = 1,"ny" = 2,"wx" = 3,"wy" = 3,"ex" = 0,"ey" = 2,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/rogueweapon/shield/tower
	name = "tower shield"
	desc = "A gigantic, iron reinforced shield that covers the entire body, a design-copy of the Aasimar shields of an era gone by."
	icon_state = "shield_tower"
	force = 6
	throwforce = 10
	throw_speed = 1
	throw_range = 3
	wlength = WLENGTH_NORMAL
	resistance_flags = FLAMMABLE
	var/swapped = FALSE
	wdefense = 10
	coverage = 40
	parrysound = list('sound/combat/parry/shield/towershield (1).ogg','sound/combat/parry/shield/towershield (2).ogg','sound/combat/parry/shield/towershield (3).ogg')
	max_integrity = 300
	anvilrepair = /datum/skill/craft/weaponsmithing

/obj/item/rogueweapon/shield/tower/holysee
	name = "decablessed shield"
	desc = "A blessed kite shield, said to bestow the Pantheon's protection upon the wielder. A final, staunch line against the darkness. For it's not what is before the shield-carrier that matters, but the home behind them."
	icon_state = "gsshield"
	force = 20
	throwforce = 10
	throw_speed = 1
	throw_range = 3
	possible_item_intents = list(SHIELD_BASH_METAL, SHIELD_BLOCK, SHIELD_SMASH_METAL)	
	wlength = WLENGTH_NORMAL
	resistance_flags = null
	flags_1 = CONDUCT_1
	wdefense = 11
	coverage = 50
	attacked_sound = list('sound/combat/parry/shield/metalshield (1).ogg','sound/combat/parry/shield/metalshield (2).ogg','sound/combat/parry/shield/metalshield (3).ogg')
	parrysound = list('sound/combat/parry/shield/metalshield (1).ogg','sound/combat/parry/shield/metalshield (2).ogg','sound/combat/parry/shield/metalshield (3).ogg')
	max_integrity = 330
	sellprice = 30

/obj/item/rogueweapon/shield/tower/holysee/MiddleClick(mob/user, params)
	. = ..()
	swapped = !swapped
	update_icon()

/obj/item/rogueweapon/shield/tower/holysee/update_icon()
	. = ..()
	if(swapped)
		icon_state = "gsshielddark"
	else
		icon_state = "gsshield"


/obj/item/rogueweapon/shield/tower/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -5,"sy" = -1,"nx" = 6,"ny" = -1,"wx" = 0,"wy" = -2,"ex" = 0,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = 1,"sy" = 4,"nx" = 1,"ny" = 2,"wx" = 3,"wy" = 3,"ex" = 0,"ey" = 2,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/rogueweapon/shield/tower/metal
	name = "kite shield"
	desc = "A kite-shaped iron shield. Reliable and sturdy."
	icon_state = "kitesh"
	force = 20
	throwforce = 10
	throw_speed = 1
	throw_range = 3
	possible_item_intents = list(SHIELD_BASH_METAL, SHIELD_BLOCK, SHIELD_SMASH_METAL)
	wlength = WLENGTH_NORMAL
	resistance_flags = null
	flags_1 = CONDUCT_1
	wdefense = 12
	coverage = 60
	attacked_sound = list('sound/combat/parry/shield/metalshield (1).ogg','sound/combat/parry/shield/metalshield (2).ogg','sound/combat/parry/shield/metalshield (3).ogg')
	parrysound = list('sound/combat/parry/shield/metalshield (1).ogg','sound/combat/parry/shield/metalshield (2).ogg','sound/combat/parry/shield/metalshield (3).ogg')
	max_integrity = 300
	sellprice = 30
	anvilrepair = /datum/skill/craft/weaponsmithing

/obj/item/rogueweapon/shield/tower/metal/getonmobprop(tag)
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -5,"sy" = -1,"nx" = 6,"ny" = -1,"wx" = 0,"wy" = -2,"ex" = 0,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = 1,"sy" = 4,"nx" = 1,"ny" = 2,"wx" = 3,"wy" = 3,"ex" = 0,"ey" = 2,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
	return ..()

/obj/item/rogueweapon/shield/tower/metal/psy
	name = "Covenant"
	desc = "A Psydonian endures. A Psydonian preserves themselves. A Psydonian preserves His flock."
	icon_state = "psyshield"
	force = 15
	throwforce = 5
	throw_speed = 1
	throw_range = 3
	possible_item_intents = list(SHIELD_BASH_METAL, SHIELD_BLOCK, SHIELD_SMASH_METAL)
	wlength = WLENGTH_NORMAL
	resistance_flags = null
	flags_1 = CONDUCT_1
	wdefense = 14
	coverage = 50
	attacked_sound = list('sound/combat/parry/shield/metalshield (1).ogg','sound/combat/parry/shield/metalshield (2).ogg','sound/combat/parry/shield/metalshield (3).ogg')
	parrysound = list('sound/combat/parry/shield/metalshield (1).ogg','sound/combat/parry/shield/metalshield (2).ogg','sound/combat/parry/shield/metalshield (3).ogg')
	max_integrity = 350
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silver

/obj/item/rogueweapon/shield/tower/metal/psy/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = -3,\
		added_blade_int = 0,\
		added_int = 100,\
		added_def = 1,\
	)

/obj/item/rogueweapon/shield/tower/metal/alloy
	name = "decrepit shield"
	desc = "A hefty tower shield, wrought from frayed bronze. Looped with dried kelp and reeking of saltwater, you'd assume that this had been fished out from the remains of a long-sunken warship.. alongside its former legionnaire."
	max_integrity = 120
	wdefense = 9
	icon_state = "ancientsh"
	blade_dulling = DULLING_SHAFT_CONJURED
	color = "#bb9696"
	smeltresult = /obj/item/ingot/aaslag
	anvilrepair = null

/obj/item/rogueweapon/shield/tower/metal/palloy
	name = "ancient shield"
	desc = "A venerable scutum, plated with polished gilbranze. An undying legionnaire's closest friend; that which rebukes arrow-and-bolt alike with unphasing prejudice. It is a reminder - one of many - that Her progress cannot be stopped."
	icon_state = "ancientsh"
	smeltresult = /obj/item/ingot/purifiedaalloy

/obj/item/rogueweapon/shield/tower/raneshen
	name = "rider shield"
	desc = "A shield of Raneshen design. Clever usage of wood, iron, and leather make an impressive match for any weapon."
	icon_state = "desert_rider"
	possible_item_intents = list(SHIELD_BASH_METAL, SHIELD_BLOCK)
	force = 25
	throwforce = 25 //for cosplaying captain raneshen
	wdefense = 11
	max_integrity = 220 //not fully metal but not fully wood either
	anvilrepair = /datum/skill/craft/carpentry

/obj/item/rogueweapon/shield/tower/raneshen/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -5,"sy" = -1,"nx" = 6,"ny" = -1,"wx" = 0,"wy" = -2,"ex" = 0,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 1,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = 1,"sy" = 4,"nx" = 1,"ny" = 2,"wx" = 3,"wy" = 3,"ex" = 0,"ey" = 2,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/rogueweapon/shield/tower/spidershield
	name = "spider shield"
	desc = "A bulky shield of spike-like lengths molten together. The motifs evoke anything but safety and protection."
	icon_state = "spidershield"
	coverage = 55

/obj/item/rogueweapon/shield/buckler
	name = "buckler shield"
	desc = "A sturdy buckler shield. Will block anything you can imagine."
	icon_state = "bucklersh"
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_BACK
	force = 20
	throwforce = 10
	dropshrink = 0.8
	resistance_flags = null
	possible_item_intents = list(SHIELD_BASH_METAL, SHIELD_BLOCK, SHIELD_SMASH_METAL)
	wdefense = 9
	coverage = 10
	attacked_sound = list('sound/combat/parry/shield/metalshield (1).ogg','sound/combat/parry/shield/metalshield (2).ogg','sound/combat/parry/shield/metalshield (3).ogg')
	parrysound = list('sound/combat/parry/shield/metalshield (1).ogg','sound/combat/parry/shield/metalshield (2).ogg','sound/combat/parry/shield/metalshield (3).ogg')
	max_integrity = 130
	associated_skill = /datum/skill/combat/shields
	grid_width = 32
	grid_height = 64
	anvilrepair = /datum/skill/craft/weaponsmithing

/obj/item/rogueweapon/shield/buckler/examine(mob/living/user)
	. = ..()
	. += "Buckler uses the skill of your active weapon to parry. Otherwise it uses your shields skill."

/obj/item/rogueweapon/shield/buckler/proc/bucklerskill(mob/living/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/bucklerer = user
	var/obj/item/mainhand = bucklerer.get_active_held_item()
	var/weapon_parry = FALSE
	if(mainhand)
		if(mainhand.can_parry)
			weapon_parry = TRUE
	if(istype(mainhand, /obj/item/rogueweapon/shield/buckler))
		associated_skill = /datum/skill/combat/shields
	if(weapon_parry && mainhand.associated_skill && ispath(mainhand.associated_skill, /datum/skill/combat))
		associated_skill = mainhand.associated_skill
	else
		associated_skill = /datum/skill/combat/shields

/obj/item/rogueweapon/shield/buckler/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -5,"sy" = -1,"nx" = 6,"ny" = -1,"wx" = 0,"wy" = -2,"ex" = 0,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 1,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = 1,"sy" = 4,"nx" = 1,"ny" = 2,"wx" = 3,"wy" = 3,"ex" = 0,"ey" = 2,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/rogueweapon/shield/buckler/palloy
	name = "ancient buckler"
	desc = "An object once before its time, now out of it. The artisan's hammerstrikes are still visible in the mottled surface, yet \
	the encroach of rust and rot threatens even this memory."
	icon_state = "ancient_buckler"
	max_integrity = 85
	smeltresult = /obj/item/ingot/purifiedaalloy

// unique, better buckler for knight captain
/obj/item/rogueweapon/shield/buckler/knightcaptain
	name = "'Aegis'"
	desc = "A special buckler made out of blacksteel for the Knight Captain, adorned with a crest. An inscription along the top reads,\"RUAT CAELUM\""
	icon_state = "capbuckler"
	icon = 'icons/roguetown/weapons/special/captain.dmi'
	max_integrity = 150
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_BACK
	sellprice = 100 // lets not make it too profitable
	smeltresult = /obj/item/ingot/blacksteel

/obj/item/rogueweapon/shield/heater
	name = "heater shield"
	desc = "A sturdy wood and leather shield. Made to not be too encumbering while still providing good protection."
	icon_state = "heatersh"
	force = 15
	throwforce = 10
	dropshrink = 0.8
	coverage = 30
	attacked_sound = list('sound/combat/parry/shield/towershield (1).ogg','sound/combat/parry/shield/towershield (2).ogg','sound/combat/parry/shield/towershield (3).ogg')
	parrysound = list('sound/combat/parry/shield/towershield (1).ogg','sound/combat/parry/shield/towershield (2).ogg','sound/combat/parry/shield/towershield (3).ogg')
	max_integrity = 220

/obj/item/rogueweapon/shield/heater/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -5,"sy" = -1,"nx" = 6,"ny" = -1,"wx" = 0,"wy" = -2,"ex" = 0,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = 1,"sy" = 4,"nx" = 1,"ny" = 2,"wx" = 3,"wy" = 3,"ex" = 0,"ey" = 2,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)


/obj/item/rogueweapon/shield/iron
	name = "iron shield"
	desc = "A heavy iron shield. It's cheaper than steel, but more encumbering."
	icon_state = "ironsh"
	force = 20
	throwforce = 25 // "I can do this all day."
	dropshrink = 0.8
	coverage = 30
	attacked_sound = list('sound/combat/parry/shield/metalshield (1).ogg','sound/combat/parry/shield/metalshield (2).ogg','sound/combat/parry/shield/metalshield (3).ogg')
	parrysound = list('sound/combat/parry/shield/metalshield (1).ogg','sound/combat/parry/shield/metalshield (2).ogg','sound/combat/parry/shield/metalshield (3).ogg')
	possible_item_intents = list(SHIELD_SMASH_METAL, SHIELD_BLOCK) // No SHIELD_BASH. Too heavy to swing quickly, or something.
	max_integrity = 220
	anvilrepair = /datum/skill/craft/weaponsmithing

/obj/item/rogueweapon/shield/iron/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -5,"sy" = -1,"nx" = 6,"ny" = -1,"wx" = 0,"wy" = -2,"ex" = 0,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = 1,"sy" = 4,"nx" = 1,"ny" = 2,"wx" = 3,"wy" = 3,"ex" = 0,"ey" = 2,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

#undef SHIELD_BANG_COOLDOWN

/obj/item/rogueweapon/shield/iron/steppesman
	name = "steppesman shield"
	desc = "A banded iron shield decorated with traditional Aavnic colours, often seen in the hands of the Steppesmen."
	icon_state = "ironsh_steppeman"
	max_integrity = 250 //+30

/*/obj/item/rogueweapon/shield/buckler/freelancer
	name = "fencer's wrap"
	desc = "A traditional Etruscan quilted cloth square with a woolen cover. It can be used to daze and distract people with its bright colours and hanging steel balls."
	force = 10
	throwforce = 10
	coverage = 15
	max_integrity = 200
	possible_item_intents = list(SHIELD_BLOCK, FENCER_DAZE) */

/obj/item/rogueweapon/shield/steam
	name = "steam shield"
	desc = "A sturdy wood shield thats been highly modified by an artificer. It seems to have several pipes and gears built into it."
	icon_state = "artificershield"
	force = 15
	throwforce = 10
	dropshrink = 0.8
	coverage = 60
	attacked_sound = list('sound/combat/parry/shield/towershield (1).ogg','sound/combat/parry/shield/towershield (2).ogg','sound/combat/parry/shield/towershield (3).ogg')
	parrysound = list('sound/combat/parry/shield/towershield (1).ogg','sound/combat/parry/shield/towershield (2).ogg','sound/combat/parry/shield/towershield (3).ogg')
	max_integrity = 200
	var/smoke_path = /obj/effect/particle_effect/smoke
	var/cooldowny
	var/cdtime = 30 SECONDS

/obj/item/rogueweapon/shield/steam/attack_self(mob/user)
	if(cooldowny)
		if(world.time < cooldowny + cdtime)
			to_chat(user, span_warning("[src] hisses weakly, It's still building up steam!"))
			return
	if(prob(25))
		smoke_path = /obj/effect/particle_effect/smoke/bad
	else
		smoke_path = /obj/effect/particle_effect/smoke
	var/list/thrownatoms = list()
	var/atom/throwtarget
	var/distfromcaster
	user.visible_message(span_notice("Loud whizzing clockwork and the hiss of steam comes from within [src]."))
	to_chat(user, span_warning("[user] activates a mechanism on [src]!"))
	sleep(15)
	playsound(user, 'sound/items/steamrelease.ogg', 100, FALSE, -1)
	cooldowny = world.time
	addtimer(CALLBACK(src,PROC_REF(steamready), user), cdtime)
	for(var/atom/movable/AM in view(1, user))
		thrownatoms += AM
	for(var/turf/T in oview(2, user))
		new smoke_path(T) //smoke everywhere!

	for(var/atom/movable/AM as anything in thrownatoms)
		if(AM == user || AM.anchored)
			continue
		throwtarget = get_edge_target_turf(user, get_dir(user, get_step_away(AM, user)))
		distfromcaster = get_dist(user, AM)

		if(distfromcaster == 0)
			if(isliving(AM))
				var/mob/living/M = AM
				M.Paralyze(10)
				M.adjustFireLoss(25)
				to_chat(M, span_danger("You're slammed into the floor by [user]!"))
		else
			if(isliving(AM))
				var/mob/living/M = AM
				M.adjustFireLoss(25)
				to_chat(M, span_danger( "You're thrown back by [user]!"))
			AM.safe_throw_at(throwtarget, 4, 2, user, TRUE, force = MOVE_FORCE_OVERPOWERING)

/obj/item/rogueweapon/shield/steam/proc/steamready(mob/user)
	playsound(user, 'sound/items/steamcreation.ogg', 100, FALSE, -1)
	to_chat(user, span_warning("[src] is ready to be used again!"))
/obj/item/rogueweapon/shield/steam/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -5,"sy" = -1,"nx" = 6,"ny" = -1,"wx" = 0,"wy" = -2,"ex" = 0,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = 1,"sy" = 4,"nx" = 1,"ny" = 2,"wx" = 3,"wy" = 3,"ex" = 0,"ey" = 2,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
