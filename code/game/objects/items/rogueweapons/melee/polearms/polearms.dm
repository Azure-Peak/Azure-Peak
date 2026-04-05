//intent datums ฅ^•ﻌ•^ฅ

/datum/intent/spear/thrust
	name = "thrust"
	blade_class = BCLASS_STAB
	attack_verb = list("thrusts")
	animname = "stab"
	icon_state = "instab"
	reach = 2
	clickcd = CLICK_CD_CHARGED
	warnie = "mobwarning"
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = PEN_HEAVY
	item_d_type = "stab"
	effective_range = 2
	effective_range_type = EFF_RANGE_EXACT

/datum/intent/spear/thrust/bad
	name = "weak thrust"
	penfactor = PEN_LIGHT
	damfactor = 1
	desc = "A weak thrust from a polearm not designed for stabbing. Doesn't care about effective range,\ but also incapable of piercing all but the weakest cloth armor."
	effective_range = null
	effective_range_type = EFF_RANGE_NONE

/datum/intent/spear/thrust/training
	name = "blunted thrust"
	penfactor = PEN_NONE
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')

/datum/intent/spear/thrust/oneh
	name = "one-handed thrust"
	reach = 1
	swingdelay = 14
	damfactor = 1.6
	penfactor = PEN_HEAVY
	clickcd = CLICK_CD_RESIST
	effective_range = null
	effective_range_type = EFF_RANGE_NONE
	sharpness_penalty = 3

/datum/intent/spear/thrust/oneh/training
	name = "blunted one-handed thrust"
	penfactor = PEN_NONE
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')

/datum/intent/spear/thrust/militia
	penfactor = PEN_MEDIUM

/datum/intent/spear/thrust/pike		//EXPERIMENTAL
	name = "pike thrust"
	desc = "Thrust your pike forward from its furthest end to reach farther ahead than any spear ever could. Only effective at three paces."
	damfactor = 1.15
	reach = 3
	effective_range = 3
	clickcd = CLICK_CD_CHARGED + 1
	swingdelay = 1.5

/datum/intent/spear/thrust/pike/skewer		//EXPERIMENTAL
	name = "pike lance"
	desc = "Grab your pike from a closer end and charge forward with your whole body for devastating damage."
	clickcd = CLICK_CD_HEAVY + 4
	swingdelay = 6
	damfactor = 1.5
	penfactor = PEN_MEDIUM
	max_intent_damage = 54
	reach = 2
	effective_range = 2
	icon_state = "inlance"
	attack_verb = list("lances", "runs through", "skewers")

/datum/intent/spear/thrust/short
	reach = 1
	damfactor = 0.9
	penfactor = PEN_MEDIUM
	effective_range = null
	effective_range_type = EFF_RANGE_NONE

/datum/intent/spear/bash
	name = "bash"
	blade_class = BCLASS_BLUNT
	penfactor = PEN_NONE
	icon_state = "inbash"
	attack_verb = list("bashes", "strikes")
	damfactor = NONBLUNT_BLUNT_DAMFACTOR
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR

// Eaglebeak has a decent bash with range
/datum/intent/spear/bash/polehammer //Used for something that is not just eagle beak
	name = "crushing bash"
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	damfactor = 1
	reach = 2

/datum/intent/spear/bash/ranged
	reach = 2

/datum/intent/spear/cut
	name = "cut"
	blade_class = BCLASS_CUT
	attack_verb = list("cuts", "slashes")
	icon_state = "incut"
	damfactor = 1
	hitsound = list('sound/combat/hits/bladed/genslash (1).ogg', 'sound/combat/hits/bladed/genslash (2).ogg', 'sound/combat/hits/bladed/genslash (3).ogg')
	reach = 2
	item_d_type = "slash"

/datum/intent/spear/cut/oneh
	name = "one-handed cut"
	reach = 1
	swingdelay = 6
	sharpness_penalty = 2

/datum/intent/spear/cut/scythe
	reach = 3
	damfactor = 1

/datum/intent/spear/cut/bardiche/cleave
	name = "cleaving cut"
	icon_state = "incleave"
	attack_verb = list("cleaves", "carves through")
	clickcd = CLICK_CD_MASSIVE
	damfactor = 1.0
	cleave = /datum/cleave_pattern/forward_cleave
	desc = "A cleave that cuts through a second target behind the first."

/datum/intent/spear/cut/glaive
	damfactor = 1.2
	chargetime = 0

/datum/intent/spear/cut/glaive/sweep
	name = "sweeping cut"
	icon_state = "insweep"
	attack_verb = list("sweeps through", "cuts across")
	clickcd = CLICK_CD_GLACIAL
	cleave = /datum/cleave_pattern/horizontal_sweep
	desc = "A sweep that cuts through targets to the front."

/datum/intent/spear/cut/short
	reach = 1

/datum/intent/spear/cast
	name = "cast"
	chargetime = 0
	noaa = TRUE
	misscost = 0
	icon_state = "inuse"
	no_attack = TRUE

/datum/intent/spear/cut/naginata
	damfactor = 1.2
	chargetime = 0

/datum/intent/spear/cut/naginata/sweep
	name = "sweeping cut"
	icon_state = "insweep"
	attack_verb = list("sweeps through", "cuts across")
	clickcd = CLICK_CD_GLACIAL
	cleave = /datum/cleave_pattern/horizontal_sweep
	desc = "A sweep that cuts through targets to the front."

/datum/intent/rend
	name = "rend"
	icon_state = "inrend"
	attack_verb = list("rends", "cleaves")
	animname = "chop"
	blade_class = BCLASS_CHOP
	hitsound = list('sound/combat/hits/bladed/genchop (1).ogg', 'sound/combat/hits/bladed/genchop (2).ogg', 'sound/combat/hits/bladed/genchop (3).ogg')
	reach = 1
	swingdelay = 15
	penfactor = PEN_NONE
	damfactor = 2.5
	clickcd = CLICK_CD_CHARGED
	no_early_release = TRUE
	item_d_type = "slash"
	misscost = 10
	intent_intdamage_factor = 0.05
	demolition_mod = 0.05

/datum/intent/rend/apophis
	damfactor = 2.2
	intent_intdamage_factor = 0.2

/datum/intent/rend/reach
	name = "long rend"
	penfactor = PEN_NONE
	misscost = 5
	swingdelay = 15
	clickcd = CLICK_CD_HEAVY
	damfactor = 2
	reach = 2

/datum/intent/rend/reach/partizan
	name = "rending thrust"
	attack_verb = list("skewers", "cleaves")
	blade_class = BCLASS_STAB
	swingdelay = 8
	misscost = 20
	damfactor = 1.8
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	item_d_type = "stab"
	no_early_release = TRUE
	intent_intdamage_factor = 0.1




/datum/intent/spear/bash/ranged/quarterstaff
	damfactor = 1

/datum/intent/spear/thrust/quarterstaff
	blade_class = BCLASS_BLUNT
	hitsound = list('sound/combat/hits/blunt/bluntsmall (1).ogg', 'sound/combat/hits/blunt/bluntsmall (2).ogg')
	penfactor = PEN_NONE
	damfactor = 1.3 // Adds up to be slightly stronger than an unenhanced ebeak strike.
	clickcd = CLICK_CD_CHARGED

//polearm objs ฅ^•ﻌ•^ฅ

/obj/item/rogueweapon/woodstaff
	force = 10
	force_wielded = 15
	possible_item_intents = list(SPEAR_BASH)
	gripped_intents = list(SPEAR_BASH,/datum/intent/mace/smash/wood)
	name = "wooden staff"
	desc = "A solid dependable walking stick that allows one to traverse rough terrain with ease, keep the weight off an injured leg, or reliably fend off incoming blows. Perfect for beggars, pilgrims, and mages."
	icon_state = "woodstaff"
	icon = 'icons/roguetown/weapons/polearms64.dmi'
	wlength = WLENGTH_LONG
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	sharpness = IS_BLUNT
	walking_stick = TRUE
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	wdefense = 5
	wdefense_wbonus = 8	//11 when wielded.
	bigboy = TRUE
	gripsprite = TRUE
	associated_skill = /datum/skill/combat/staves
	anvilrepair = /datum/skill/craft/carpentry
	resistance_flags = FLAMMABLE

/obj/item/rogueweapon/woodstaff/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -6,"sy" = -1,"nx" = 8,"ny" = 0,"wx" = -4,"wy" = 0,"ex" = 2,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 32,"eturn" = -23,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 4,"sy" = -2,"nx" = -3,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/woodstaff/wise
	name = "wise staff"
	desc = "A staff for keeping the volves at bay..."

/obj/item/rogueweapon/woodstaff/aries
	name = "staff of the shepherd"
	desc = "This staff makes you look important to any peasant."
	force = 25
	force_wielded = 28
	icon_state = "aries"
	icon = 'icons/roguetown/weapons/misc32.dmi'
	pixel_y = 0
	pixel_x = 0
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = FALSE
	gripsprite = FALSE
	gripped_intents = null

/obj/item/rogueweapon/woodstaff/polearm
	name = "shillelagh"
	desc = "A particularly long and sturdy walking stick with a variety of uses. It's heavier at one end, making it a little unbalanced."
	associated_skill = /datum/skill/combat/polearms

/obj/item/rogueweapon/woodstaff/aries/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -6,"sy" = 2,"nx" = 8,"ny" = 2,"wx" = -4,"wy" = 2,"ex" = 1,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 300,"wturn" = 32,"eturn" = -23,"nflip" = 0,"sflip" = 100,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 4,"sy" = -2,"nx" = -3,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)


/obj/item/rogueweapon/spear
	force = 22
	force_wielded = 30
	possible_item_intents = list(SPEAR_THRUST_1H, SPEAR_CUT_1H)
	gripped_intents = list(SPEAR_THRUST, SPEAR_CUT, SPEAR_BASH) //bash is for nonlethal takedowns, only targets limbs
	name = "spear"
	desc = "One of the oldest weapons still in use today, second only to the club. The lack of reinforcements along the shaft leaves it vulnerable to being split in two."
	icon_state = "spear"
	icon = 'icons/roguetown/weapons/polearms64.dmi'
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	wlength = WLENGTH_GREAT
	w_class = WEIGHT_CLASS_BULKY
	minstr = 8
	max_blade_int = 180
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/iron
	associated_skill = /datum/skill/combat/polearms
	walking_stick = TRUE
	wdefense = 5
	thrown_bclass = BCLASS_STAB
	throwforce = 25
	resistance_flags = FLAMMABLE
	special = /datum/special_intent/polearm_backstep

/obj/item/rogueweapon/spear/short
	force = 25
	force_wielded = 25
	possible_item_intents = list(SHORT_SPEAR_THRUST, SHORT_SPEAR_CUT)
	gripped_intents = list(SHORT_SPEAR_THRUST, SHORT_SPEAR_CUT, SPEAR_BASH)
	name = "short spear"
	icon_state = "short_spear"
	wlength = WLENGTH_LONG

// ---- Azurean Shortspear intents ----
/datum/intent/spear/thrust/azurean
	name = "thrust"
	desc = "A quick, nimble two-handed thrust. Keeps reach but lacks the power to pierce armor."
	reach = 2
	clickcd = CLICK_CD_QUICK // Long range, quick poke, NO AP
	penfactor = PEN_NONE
	damfactor = 1
	effective_range = null
	effective_range_type = EFF_RANGE_NONE

/datum/intent/spear/thrust/azurean/oneh
	name = "one-handed thrust"
	desc = "A rapid jab from one hand. Fast with long range, but unable to penetrate armor."
	reach = 2
	clickcd = CLICK_CD_QUICK // capture that nimble feel
	penfactor = PEN_NONE
	damfactor = 1
	effective_range = null
	effective_range_type = EFF_RANGE_NONE

/datum/intent/spear/thrust/azurean/pick
	name = "pick"
	icon_state = "inpick"
	desc = "A shortspear is nimble enough to handle when two-handed and gripped toward the blade. Grasps it near the end and drive it into the weak point of your opponent's armor - hard to pull off but can be devastating if successful."
	blade_class = BCLASS_PICK
	attack_verb = list("impales", "drives into")
	hitsound = list('sound/combat/hits/pick/genpick (1).ogg', 'sound/combat/hits/pick/genpick (2).ogg')
	reach = 1
	clickcd = 18
	swingdelay = 14
	penfactor = PEN_HEAVY
	damfactor = 0.8
	item_d_type = "stab"
	effective_range = null
	effective_range_type = EFF_RANGE_NONE

//
/obj/item/rogueweapon/spear/spellblade
	name = "dory"
	icon_state = "short_spear"
	desc = "A shortened spear, six feet long and balanced. Favored by Azurean Spellblades \
		who found the traditional long spear ill-suited for their flashy, individualistic fighting style. \
		Designed to thrust quickly from one hand but maneuver nimbly in two.<BR><BR> \
		'From this dae on, we shall name ourselves naught spearman, but phalangite, and our spear, the dory, not a shortspear. \
		And with this measure we shall gain great respect henceforth.' - Unknown Grandmaster of the Azurean Spellblade Order, 900 AP."
	force = 20
	force_wielded = 25
	possible_item_intents = list(/datum/intent/spear/thrust/azurean/oneh)
	gripped_intents = list(/datum/intent/spear/thrust/azurean, /datum/intent/spear/thrust/azurean/pick, SPEAR_BASH)
	wlength = WLENGTH_LONG
	w_class = WEIGHT_CLASS_BULKY
	minstr = 7
	max_blade_int = 180
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/iron
	associated_skill = /datum/skill/combat/polearms
	wdefense = 5
	thrown_bclass = BCLASS_STAB
	throwforce = 22
	resistance_flags = FLAMMABLE
	armor_penetration = PEN_NONE

/obj/item/rogueweapon/spear/trainer
	name = "sparring spear"
	desc = "An old dulled spear with a shaft worn by the hands of countless trainees before you. The fabric and watting wrap is meant to protect combatants, \
	but getting hit with this still leaves welts and breaks fingers."
	icon_state = "spear_trainer"
	possible_item_intents = list(SPEAR_TRAINER_THRUST1H, SPEAR_BASH)
	gripped_intents = list(SPEAR_TRAINER_THRUST, SPEAR_BASH, MACE_SMASH_WOOD)
	force = 7
	force_wielded = 15
	sharpness = IS_BLUNT
	thrown_bclass = BCLASS_BLUNT

/obj/item/rogueweapon/spear/trainer/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -6,"sy" = 2,"nx" = 8,"ny" = 2,"wx" = -4,"wy" = 2,"ex" = 1,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 300,"wturn" = 32,"eturn" = -23,"nflip" = 0,"sflip" = 100,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 4,"sy" = -2,"nx" = -3,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)


/obj/item/rogueweapon/spear/trident
	// Better one handed & throwing weapon, flimsier.
	name = "bronze trident"
	desc = "A bronze trident from the seas designed to pierce fish upon its hooked teeth. Feels balanced in your hand, like you could throw it quite easily."
	icon_state = "bronzetri"
	force = 25
	wdefense = 4
	max_blade_int = 175
	max_integrity = 225
	throwforce = 30
	possible_item_intents = list(SPEAR_THRUST, SPEAR_BASH, SPEAR_CAST)
	gripped_intents = null
	smeltresult = /obj/item/ingot/bronze
	fishingMods=list(
		"commonFishingMod" = 0.8,
		"rareFishingMod" = 1.4,
		"treasureFishingMod" = 0,
		"trashFishingMod" = 0,
		"dangerFishingMod" = 0.9,
		"ceruleanFishingMod" = 0, // 1 on cerulean aril, 0 on everything else
		"cheeseFishingMod" = 0 // Just for the funny gimmick of a chance for rats and rouses.
	)

/obj/item/rogueweapon/spear/trident/afterattack(obj/target, mob/user, proximity)
	var/sl = user.get_skill_level(/datum/skill/labor/fishing)
	var/ft = 150
	var/fpp =  90 - (sl * 15)
	if(istype(target, /turf/open/water))
		if(user.used_intent.type == SPEAR_CAST && !user.doing)
			if(target in range(user,3))
				user.visible_message("<span class='warning'>[user] searches for a fish!</span>", \
									"<span class='notice'>I begin looking for a fish to spear.</span>")
				playsound(src.loc, 'sound/items/fishing_plouf.ogg', 100, TRUE)
				ft -= (sl * 20)
				ft = max(20,ft)
				if(do_after(user,ft, target = target))
					var/fishchance = 100
					if(user.mind)
						if(!sl)
							fishchance -= 50
						else
							fishchance -= fpp
					var/mob/living/fisherman = user
					if(prob(fishchance))
						var/A = getfishingloot(user, fishingMods.Copy(), target)
						if(A)
							var/ow = 30 + (sl * 10)
							to_chat(user, "<span class='notice'>You see something!</span>")
							playsound(src.loc, 'sound/items/fishing_plouf.ogg', 100, TRUE)
							if(!do_after(user,ow, target = target))
								if(ismob(A))
									var/mob/M = A
									if(M.type in subtypesof(/mob/living/simple_animal/hostile))
										new M(target)
									else
										new M(user.loc)
									user.mind.add_sleep_experience(/datum/skill/labor/fishing, fisherman.STAINT*2)
								else
									new A(user.loc)
									teleport_to_dream(user, 10000, 1)
									to_chat(user, "<span class='warning'>Pull 'em in!</span>")
									user.mind.add_sleep_experience(/datum/skill/labor/fishing, round(fisherman.STAINT, 2), FALSE)
									record_featured_stat(FEATURED_STATS_FISHERS, fisherman)
									GLOB.azure_round_stats[STATS_FISH_CAUGHT]++
									playsound(src.loc, 'sound/items/Fish_out.ogg', 100, TRUE)
							else
								to_chat(user, "<span class='warning'>Damn, it got away... I should <b>pull away</b> next time.</span>")
					else
						to_chat(user, "<span class='warning'>Not a single fish...</span>")
						user.mind.add_sleep_experience(/datum/skill/labor/fishing, fisherman.STAINT/2)
				else
					to_chat(user, "<span class='warning'>I must stand still to fish.</span>")
			update_icon()

/obj/item/rogueweapon/spear/aalloy
	name = "decrepit spear"
	desc = "A rotting staff, tipped with frayed bronze. After the stone, but before the sword; an interlude for the violence that would soon engulf His world."
	icon_state = "ancient_spear"
	force = 13
	force_wielded = 22
	max_integrity = 120
	blade_dulling = DULLING_SHAFT_CONJURED
	color = "#bb9696"
	smeltresult = /obj/item/ingot/aaslag
	anvilrepair = null
	randomize_blade_int_on_init = TRUE

/obj/item/rogueweapon/spear/paalloy
	name = "ancient spear"
	desc = "A gnarled staff, tipped with polished gilbranze. Your breathing hilts, and your knuckles tighten around the staff; you see what is yet to come, yet your mind refuses to retain it. To know what fate this dying world has - it would drive any man inzane."
	smeltresult = /obj/item/ingot/aaslag
	icon_state = "ancient_spear"


/obj/item/rogueweapon/spear/psyspear
	name = "psydonic spear"
	desc = "An ornate spear, plated in a ceremonial veneer of silver. The barbs pierce your palm, and - for just a moment - you see red. Never forget that you are why Psydon wept."
	icon_state = "psyspear"
	force = 15
	force_wielded = 25
	minstr = 11
	wdefense = 6
	resistance_flags = FIRE_PROOF	//It's meant to be smacked by a "lamptern", and is special enough to warrant overriding the spear weakness
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silverblessed

/obj/item/rogueweapon/spear/psyspear/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 50,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/spear/silver
	name = "silver spear"
	desc = "A winged staff, tipped with a silver spearhead. It bares a resemblenece to the 'boar spear', but with a critical difference; instead of stopping hogs, it halts charging deadites from spreading their sickness any further."
	icon_state = "silverspear"
	force = 15
	force_wielded = 25
	minstr = 11
	wdefense = 6
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silver

/obj/item/rogueweapon/spear/silver/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 50,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/spear/psyspear/old
	name = "enduring spear"
	desc = "An ornate spear, its silver tarnished by neglect. HE still guides the faithful's hand, if not this weapon."
	icon_state = "psyspear"
	force = 20
	force_wielded = 30
	minstr = 8
	wdefense = 5
	is_silver = FALSE
	smeltresult = /obj/item/ingot/steel
	color = COLOR_FLOORTILE_GRAY

/obj/item/rogueweapon/spear/psyspear/old/ComponentInitialize()
	return

/obj/item/rogueweapon/spear/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -3,"nx" = -5,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)

/obj/item/rogueweapon/spear/bonespear
	force = 18
	force_wielded = 22
	name = "bone spear"
	desc = "Yesterday's hunt, tomorrow's weapon."
	icon_state = "bonespear"
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	wlength = WLENGTH_GREAT
	w_class = WEIGHT_CLASS_BULKY
	minstr = 6
	max_blade_int = 80
	smeltresult = null
	associated_skill = /datum/skill/combat/polearms
	walking_stick = TRUE
	wdefense = 4
	max_integrity = 60
	throwforce = 20
	special = null

/obj/item/rogueweapon/spear/billhook
	name = "billhook"
	desc = "A neat hook. Used to pull riders from horses, as well as defend against said horses when used in a proper formation. The reinforcements along its shaft grant it higher durability against attacks."
	icon_state = "billhook"
	smeltresult = /obj/item/ingot/steel
	max_blade_int = 230
	minstr = 8
	wdefense = 6
	throwforce = 15

/obj/item/rogueweapon/spear/improvisedbillhook
	force = 12
	force_wielded = 25
	name = "improvised billhook"
	desc = "Looks hastily made, even a little flimsy."
	icon_state = "billhook"
	smeltresult = /obj/item/ingot/iron
	max_blade_int = 100
	wdefense = 4
	throwforce = 10

/obj/item/rogueweapon/spear/stone
	force = 15
	force_wielded = 18
	name = "stone spear"
	desc = "This handmade spear is simple, but does the job."
	icon_state = "stonespear"
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	wlength = WLENGTH_GREAT
	minstr = 6
	max_blade_int = 70
	smeltresult = null
	associated_skill = /datum/skill/combat/polearms
	walking_stick = TRUE
	wdefense = 4
	max_integrity = 50
	throwforce = 20
	special = null

// Copper spear, no point to adjust force just slightly better integrity
/obj/item/rogueweapon/spear/stone/copper
	name = "copper spear"
	desc = "A simple spear with a copper tip. More durable than stone, but not much better."
	pixel_y = 0
	pixel_x = 0
	max_integrity = 100
	icon = 'icons/roguetown/weapons/misc32.dmi'
	dam_icon = 'icons/effects/item_damage32.dmi'
	icon_state = "cspear"
	smeltresult = null

/obj/item/rogueweapon/fishspear
	force = 20
	possible_item_intents = list(SPEAR_THRUST, SPEAR_BASH, SPEAR_CAST) //bash is for nonlethal takedowns, only targets limbs
	name = "fishing spear"
	desc = "This two-pronged and barbed spear was made to catch those pesky fish."
	icon_state = "fishspear"
	icon = 'icons/roguetown/weapons/polearms64.dmi'
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	wlength = WLENGTH_GREAT
	w_class = WEIGHT_CLASS_BULKY
	minstr = 8
	max_blade_int = 200
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/steel
	associated_skill = /datum/skill/combat/polearms
	walking_stick = TRUE
	wdefense = 4
	thrown_bclass = BCLASS_STAB
	throwforce = 35
	resistance_flags = FLAMMABLE
	fishingMods=list(
		"commonFishingMod" = 0.8,
		"rareFishingMod" = 1.4,
		"treasureFishingMod" = 0,
		"trashFishingMod" = 0,
		"dangerFishingMod" = 1,
		"ceruleanFishingMod" = 0, // 1 on cerulean aril, 0 on everything else
		"cheeseFishingMod" = 0 // Just for the funny gimmick of a chance for rats and rouses.
	)

/obj/item/rogueweapon/fishspear/depthseek //DO NOT ADD RECIPE. MEANT TO BE AN ABYSSORITE RELIC. IDEA COURTESY OF LORDINQPLAS
	force = 45
	name = "blessed depthseeker"
	desc = "A beautifully crafted weapon, with handle carved of some beast's bone, inlaid with smooth seaglass at pommel and head, with two prongs smithed of fine dwarven steel. The seaglass carving at the head is a masterwork in and of itself, you can feel an abyssal energy radiating off it."
	icon_state = "depthseek"
	smeltresult = /obj/item/ingot/blacksteel
	max_blade_int = 2600
	wdefense = 8
	throwforce = 50

/obj/item/rogueweapon/fishspear/attack_self(mob/user)
	if(user.used_intent.type == SPEAR_CAST)
		if(user.doing)
			user.doing = 0

/obj/item/rogueweapon/fishspear/afterattack(obj/target, mob/user, proximity)
	var/sl = user.get_skill_level(/datum/skill/labor/fishing) // User's skill level
	var/ft = 160 //Time to get a catch, in ticks
	var/fpp =  90 - (sl * 15) // Fishing power penalty based on fishing skill level
	if(istype(target, /turf/open/water))
		if(user.used_intent.type == SPEAR_CAST && !user.doing)
			if(target in range(user,3))
				user.visible_message("<span class='warning'>[user] searches for a fish!</span>", \
									"<span class='notice'>I begin looking for a fish to spear.</span>")
				playsound(src.loc, 'sound/items/fishing_plouf.ogg', 100, TRUE)
				ft -= (sl * 20) //every skill lvl is -2 seconds
				ft = max(20,ft) //min of 2 seconds
				if(do_after(user,ft, target = target))
					var/fishchance = 100 // Total fishing chance, deductions applied below
					if(user.mind)
						if(!sl) // If we have zero fishing skill...
							fishchance -= 50 // 50% chance to fish base
						else
							fishchance -= fpp // Deduct a penalty the lower our fishing level is (-0 at legendary)
					var/mob/living/fisherman = user
					if(prob(fishchance)) // Finally, roll the dice to see if we fish.
						var/A = getfishingloot(user, fishingMods.Copy(), target)
						if(A)
							var/ow = 30 + (sl * 10) // Opportunity window, in ticks. Longer means you get more time to cancel your bait
							to_chat(user, "<span class='notice'>You see something!</span>")
							playsound(src.loc, 'sound/items/fishing_plouf.ogg', 100, TRUE)
							if(!do_after(user,ow, target = target))
								if(A in subtypesof(/mob/living))
									var/mob/M = A
									new M(target)
									if (!(M.type == /mob/living/simple_animal/hostile/retaliate/rogue/mudcrab))
										user.playsound_local(src, pick('sound/misc/jumpscare (1).ogg','sound/misc/jumpscare (2).ogg','sound/misc/jumpscare (3).ogg','sound/misc/jumpscare (4).ogg'), 100)
									user.mind.add_sleep_experience(/datum/skill/labor/fishing, fisherman.STAINT*2) // High risk high reward
								else
									new A(user.loc)
									teleport_to_dream(user, 10000, 1)
									to_chat(user, "<span class='warning'>Pull 'em in!</span>")
									user.mind.add_sleep_experience(/datum/skill/labor/fishing, round(fisherman.STAINT, 2), FALSE) // Level up!
									record_featured_stat(FEATURED_STATS_FISHERS, fisherman)
									record_round_statistic(STATS_FISH_CAUGHT)
									playsound(src.loc, 'sound/items/Fish_out.ogg', 100, TRUE)
							else
								to_chat(user, "<span class='warning'>Damn, it got away... I should <b>pull away</b> next time.</span>")
					else
						to_chat(user, "<span class='warning'>Not a single fish...</span>")
						user.mind.add_sleep_experience(/datum/skill/labor/fishing, fisherman.STAINT/2) // Pity XP.
				else
					to_chat(user, "<span class='warning'>I must stand still to fish.</span>")
			update_icon()

/obj/item/rogueweapon/fishspear/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list(
					"shrink" = 0.6,
					"sx" = -6,
					"sy" = 7,
					"nx" = 6,
					"ny" = 8,
					"wx" = 0,
					"wy" = 6,
					"ex" = -1,
					"ey" = 8,
					"northabove" = 0,
					"southabove" = 1,
					"eastabove" = 1,
					"westabove" = 0,
					"nturn" = -50,
					"sturn" = 40,
					"wturn" = 50,
					"eturn" = -50,
					"nflip" = 0,
					"sflip" = 8,
					"wflip" = 8,
					"eflip" = 0,
					)
			if("wielded")
				return list(
					"shrink" = 0.6,
					"sx" = 3,
					"sy" = 1,
					"nx" = -3,
					"ny" = 1,
					"wx" = -9,
					"wy" = 1,
					"ex" = 9,
					"ey" = 1,
					"northabove" = 0,
					"southabove" = 1,
					"eastabove" = 1,
					"westabove" = 0,
					"nturn" = -30,
					"sturn" = 30,
					"wturn" = -30,
					"eturn" = 30,
					"nflip" = 8,
					"sflip" = 0,
					"wflip" = 8,
					"eflip" = 0,
					)

/obj/item/rogueweapon/halberd
	force = 15
	force_wielded = 30
	possible_item_intents = list(SPEAR_THRUST_1H, SPEAR_BASH) //bash is for nonlethal takedowns, only targets limbs
	gripped_intents = list(SPEAR_THRUST, SPEAR_CUT, /datum/intent/axe/chop/halberd, SPEAR_BASH)
	name = "halberd"
	desc = "A steel halberd, the pinnacle of all cumulative melee weapon knowledge. The only downside is the cost, so it's rarely seen outside of the guardsmans' hands. The reinforcements along the shaft provide greater durability."
	icon_state = "halberd"
	icon = 'icons/roguetown/weapons/polearms64.dmi'
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	wlength = WLENGTH_GREAT
	w_class = WEIGHT_CLASS_BULKY
	minstr = 9
	max_blade_int = 200
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/steel
	associated_skill = /datum/skill/combat/polearms
	walking_stick = TRUE
	wdefense = 6
	special = /datum/special_intent/polearm_backstep

/obj/item/rogueweapon/halberd/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -3,"nx" = -5,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/spear/holysee
	name = "see spear"
	desc = "A blessed spear, wielded by the Holy See's templars to keep the forces of evil at bay. The design is remarkably well-balanced, allowing it for effective off-handed use with a shield. The prongs seem to catch even the tiniest glimmer of daelight, magnifying it into a blinding glare. </br>'I fear no evil, my Gods, for thou art with me!'"
	icon_state = "gsspear"
	force = 25 // better in one hand. Use it with the shield.
	max_blade_int = 225
	smeltresult = /obj/item/ingot/steel

/obj/item/rogueweapon/halberd/bardiche
	possible_item_intents = list(/datum/intent/spear/thrust/bad, SPEAR_BASH) //bash is for nonlethal takedowns, only targets limbs
	gripped_intents = list(/datum/intent/spear/cut, /datum/intent/spear/cut/bardiche/cleave, /datum/intent/spear/cut/glaive/sweep, SPEAR_BASH)
	name = "bardiche"
	desc = "A beautiful variant of the halberd. Its reinforced shaft provides it with greater durability against attacks."
	icon_state = "bardiche"
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/iron
	max_blade_int = 300
	wdefense = 5
	wbalance = WBALANCE_HEAVY

/obj/item/rogueweapon/halberd/bardiche/aalloy
	name = "decrepit bardiche"
	desc = "An imposing poleaxe, wrought from frayed bronze. Whatever noble purpose this weapon held has long since decayed; for it now persists to sunder the chaff that clings to this dying world."
	max_integrity = 180
	force = 12
	force_wielded = 22
	icon_state = "ancient_bardiche"
	blade_dulling = DULLING_SHAFT_CONJURED
	color = "#bb9696"
	smeltresult = /obj/item/ingot/aaslag
	anvilrepair = null
	randomize_blade_int_on_init = TRUE

/obj/item/rogueweapon/halberd/bardiche/paalloy
	name = "ancient bardiche"
	desc = "A terrifying poleaxe, forged from polished gilbranze. When Her ascension came, these weapons - bereft of their wielders - sunk deep into the earth. Shadowed hands cradled the blades over the centuries, and would eventually create its steel-tipped successor; the glaive."
	icon_state = "ancient_bardiche"
	smeltresult = /obj/item/ingot/aaslag


/obj/item/rogueweapon/halberd/bardiche/scythe
	name = "summer scythe"
	desc = "Summer's verdancy runs through the head of this scythe. All the more to sow."
	icon_state = "dendorscythe"
	gripped_intents = list(/datum/intent/spear/cut/bardiche, /datum/intent/spear/cut/bardiche/cleave, /datum/intent/spear/cut/glaive/sweep, /datum/intent/axe/chop/scythe)
	force_wielded = 33 // +3
	max_integrity = 300 // +50

/obj/item/rogueweapon/halberd/psyhalberd/relic
	name = "Stigmata"
	desc = "Christened in the Siege of Lirvas, these silver-tipped poleaxes - wielded by a lonesome contingent of Saint Eora's paladins - kept the horrors at bay for forty daes-and-nites. Long-since-recovered from the rubble, this relic now serve as a bulwark for the defenseless."
	icon_state = "psyhalberd"

/obj/item/rogueweapon/halberd/psyhalberd/relic/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 100,\
		added_def = 2,\
	)

/obj/item/rogueweapon/halberd/psyhalberd
	name = "psydonic halberd"
	desc = "A reliable design that has served humenkind to fell the enemy and defend Psydon's flock - now fitted with a lengthier blade and twin, silver-tipped beaks."
	icon_state = "silverhalberd"
	force = 10
	force_wielded = 25
	minstr = 11
	wdefense = 7
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silverblessed

/obj/item/rogueweapon/halberd/psyhalberd/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/halberd/glaive
	possible_item_intents = list(/datum/intent/spear/thrust/oneh, SPEAR_BASH) //bash is for nonlethal takedowns, only targets limbs
	gripped_intents = list(/datum/intent/spear/cut/glaive, /datum/intent/spear/cut/glaive/sweep, /datum/intent/spear/thrust, SPEAR_BASH)
	name = "glaive"
	desc = "A curved blade on a pole, specialised in defence, but expensive to manufacture."
	icon_state = "glaive"
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/steel
	max_blade_int = 160
	wdefense = 9

/obj/item/rogueweapon/halberd/glaive/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 3,"sy" = 4,"nx" = -1,"ny" = 4,"wx" = -8,"wy" = 3,"ex" = 7,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 15,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/// Ported from Scarlet Reach's Glaive. We're avoiding force increase because I hate roguepen. It can have better blade integrity and defense instead.
/obj/item/rogueweapon/halberd/glaive/knightcaptain
	name = "'Deliverance'"
	desc = "A masterwork glaive with a seasoned ashwood shaft reinforced by brass-sheathed steel bands. The blacksteel blade bears inscriptions on both side. One reads, \"QUIS CUSTODIET\" while the other reads, \"IPSOS CUSTODES\"."
	icon = 'icons/roguetown/weapons/special/captainglaive.dmi'
	icon_state = "capglaive"
	smeltresult = /obj/item/ingot/blacksteel
	max_integrity = 300 //blacksteel, so its gotta be more durable
	max_blade_int = 200
	sellprice = 250

/obj/item/rogueweapon/halberd/pestran
	name = "Lance of Boils"
	desc = "For when a scalpel is too short, and you still need to perform Pestra's holy work."
	icon_state = "pestranhalberd"

/obj/item/rogueweapon/halberd/bone
	name = "bone halberd"
	desc = "What an elegantly morbid statement."
	icon_state = "bonehalberd"
	smeltresult = null

/obj/item/rogueweapon/eaglebeak
	force = 15
	force_wielded = 30
	possible_item_intents = list(/datum/intent/spear/bash/polehammer, /datum/intent/mace/smash/eaglebeak)
	gripped_intents = list(/datum/intent/spear/bash/polehammer, /datum/intent/mace/smash/eaglebeak, /datum/intent/spear/thrust/bad)
	name = "eagle's beak"
	desc = "A reinforced pole affixed with an ornate steel eagle's head, of which its beak is intended to pierce with great harm."
	icon_state = "eaglebeak"
	icon = 'icons/roguetown/weapons/polearms64.dmi'
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	wlength = WLENGTH_GREAT
	w_class = WEIGHT_CLASS_BULKY
	minstr = 11
	smeltresult = /obj/item/ingot/steel
	associated_skill = /datum/skill/combat/polearms
	sharpness = IS_BLUNT
	walking_stick = TRUE
	wdefense = 5
	wbalance = WBALANCE_HEAVY
	sellprice = 60
	max_integrity = 250 //So there is actual difference between the two

/obj/item/rogueweapon/eaglebeak/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -6,"sy" = 6,"nx" = 6,"ny" = 7,"wx" = 0,"wy" = 5,"ex" = -1,"ey" = 7,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -50,"sturn" = 40,"wturn" = 50,"eturn" = -50,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 9,"sy" = -4,"nx" = -7,"ny" = 1,"wx" = -9,"wy" = 2,"ex" = 10,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 5,"sturn" = -190,"wturn" = -170,"eturn" = -10,"nflip" = 8,"sflip" = 8,"wflip" = 1,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)


/obj/item/rogueweapon/eaglebeak/lucerne
	name = "lucerne"
	desc = "A polehammer of simple iron. Fracture bone and dissent with simple brute force. The studding along its shaft makes for a slightly more reinforced weapon."
	force = 12
	force_wielded = 25
	icon_state = "polehammer"
	smeltresult = /obj/item/ingot/iron
	sellprice = 40
	max_integrity = 200

/datum/intent/mace/smash/eaglebeak
	reach = 2
	clickcd = CLICK_CD_HEAVY // Slightly longer since it has RANGE. Don't want to increase charge time more since it is unreliable.

/obj/item/rogueweapon/spear/bronze
	name = "bronze spear"
	desc = "An antiquital staff, adorned with a bronze spearhead. Ancient in both design and purpose, its lighter weight once complimented the towering shields of precivilizational legionnaires. While rarely seen beyond the Deadlands, nowadaes, its lightweight balance makes it perfect for one-handed thrusts and throws."
	force = 25
	force_wielded = 28
	throwforce = 30
	icon_state = "bronzespear"
	smeltresult = /obj/item/ingot/bronze
	armor_penetration = PEN_LIGHT //In-between a spear and javelin.
	embedding = list("embedded_pain_multiplier" = 4, "embed_chance" = 33, "embedded_fall_chance" = 2)
	max_blade_int = 225
	max_integrity = 155

/obj/item/rogueweapon/spear/bronze/winged
	name = "bronze winged spear"
	desc = "An antiquital staff, adorned with a winged bronze spearhead. The flared edges catch errant strikes and keep snarling foes from \
	further impaling themselves in order to maul its wielder. </br>Scholars believe this particular type of polearm was made to counter Vheslynic \
	seadaemons, during the now-mythologized Syonic era's collapse."
	icon_state = "bronzewingedspear"
	item_state = "bronzewingedspear"
	wdefense = 6 //Functionally the same, but with +1 DEF.

/obj/item/rogueweapon/spear/bronze/strapless
	desc = "An antiquital staff, adorned with a bronze spearhead. Ancient in both design and purpose, its lighter weight once complimented \
	the towering shields of precivilizational legionnaires. While rarely seen beyond the Deadlands, nowadaes, its lightweight balance makes \
	it perfect for one-handed thrusts and throws. </br>This particular spear has a thin strap running along its grain, allowing it to be stowed without the need for a greatweapon strap."
	slot_flags = ITEM_SLOT_BACK //Option-unique, uncraftable. Ensures the loadout doesn't implode on itself.
	equip_delay_self = 2 SECONDS
	unequip_delay_self = 2 SECONDS
	inv_storage_delay = 1 SECONDS

/obj/item/rogueweapon/spear/bronze/winged/strapless
	desc = "An antiquital staff, adorned with a winged bronze spearhead. The flared edges catch errant strikes and keep snarling foes from further \
	impaling themselves in order to maul its wielder. </br>Scholars believe this particular type of polearm was made to counter Vheslynic seadaemons, during the now-mythologized Syonic era's collapse. </br>This particular spear has a thin strap running along its grain, allowing it to be stowed without the need for a greatweapon strap."
	slot_flags = ITEM_SLOT_BACK //Ditto.
	equip_delay_self = 2 SECONDS
	unequip_delay_self = 2 SECONDS
	inv_storage_delay = 1 SECONDS

/obj/item/rogueweapon/woodstaff/quarterstaff
	name = "wooden quarterstaff"
	desc = "A staff that makes any journey easier. Durable and swift, capable of bludgeoning stray volves and ruffians alike. Its length allow it to be used for a thrusting attack."
	force = 15
	force_wielded = 20
	gripped_intents = list(/datum/intent/spear/bash/ranged/quarterstaff, /datum/intent/spear/thrust/quarterstaff)
	icon_state = "quarterstaff"
	associated_skill = /datum/skill/combat/staves
	max_integrity = 150

/obj/item/rogueweapon/woodstaff/quarterstaff/iron
	name = "iron quarterstaff"
	desc = "A quarterstaff reinforced with iron tips. It is capable of dealing more damage than a wooden one, and its blunt ends make for a decent blunt thrusting weapon. Can be used to bash down your opponents weapons."
	force = 16
	force_wielded = 22
	gripped_intents = list(/datum/intent/spear/bash/ranged/quarterstaff, /datum/intent/spear/thrust/quarterstaff)
	icon_state = "quarterstaff_iron"
	associated_skill = /datum/skill/combat/staves
	max_integrity = 200

/obj/item/rogueweapon/woodstaff/quarterstaff/steel
	name = "steel quarterstaff"
	desc = "A quarterstaff reinforced with steel tips and steel rings, blurring the line between a light polehammer and a reinforced quarterstaff. Extremely durable, and more than capable of bludgeoning brigands to death. Durable enough to break your opponents weapons."
	force = 18
	force_wielded = 25
	gripped_intents = list(/datum/intent/spear/bash/ranged/quarterstaff, /datum/intent/spear/thrust/quarterstaff)
	icon_state = "quarterstaff_steel"
	associated_skill = /datum/skill/combat/staves
	max_integrity = 200

/obj/item/rogueweapon/woodstaff/quarterstaff/silver
	name = "silver quarterstaff"
	desc = "A quarterstaff reinforced with silver tips. A relatively new design, purportedly inspired by the warstaffs oft-carried by Naledian warscholars. Durable enough to catch avantyne to the shaft, without so much as a splinter - or so, they say."
	force = 20
	force_wielded = 27
	gripped_intents = list(/datum/intent/spear/bash/ranged/quarterstaff, /datum/intent/spear/thrust/quarterstaff)
	icon_state = "quarterstaff_silver"
	associated_skill = /datum/skill/combat/staves
	max_integrity = 250
	is_silver = TRUE

/obj/item/rogueweapon/woodstaff/quarterstaff/silver/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 50,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/woodstaff/quarterstaff/psy
	name = "psydonic quarterstaff"
	desc = "A quarterstaff reinforced with silver tips. A relatively new design, purportedly inspired by the warstaffs oft-carried by Naledian warscholars. Durable enough to catch avantyne to the shaft, without so much as a splinter - or so, they say."
	force = 20
	force_wielded = 27
	gripped_intents = list(/datum/intent/spear/bash/ranged/quarterstaff, /datum/intent/spear/thrust/quarterstaff)
	icon_state = "quarterstaff_silver"
	associated_skill = /datum/skill/combat/staves
	max_integrity = 250
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silverblessed

/obj/item/rogueweapon/woodstaff/quarterstaff/psy/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 50,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/woodstaff/quarterstaff/gold
	name = "golden quarterstaff"
	desc = "The astute may point out that this staff is poorly designed. They would be correct. Gold, even low karat, is a bad material for a weapon. This one additionally manages to be doubly-sinned by having a heavy chunk of gold at the end. It's almost a polehammer. Practical? No. But it makes a statement."
	icon_state = "quarterstaff_gold"
	force = 23
	force_wielded = 30
	sellprice = 50
	max_integrity = 250 //equal to psydonite; putting it at half of this was a neat little experiment but agonizing


/obj/item/rogueweapon/spear/partizan
	name = "partizan"
	desc = "A reinforced spear-like polearm of disputed origin: A studded shaft fitted with a steel spearhead with protrusions to aid in parrying. An extremely recent invention that is seeing increasingly more usage in the Western lands."
	force = 8	//Not a possible one-handed weapon. Also too heavy!
	force_wielded = 30
	possible_item_intents = list(SPEAR_BASH) //bash is for nonlethal takedowns, only targets limbs
	gripped_intents = list(SPEAR_THRUST, SPEAR_CUT, PARTIZAN_REND)
	icon_state = "partizan"
	icon = 'icons/roguetown/weapons/polearms64.dmi'
	minstr = 10
	max_blade_int = 200
	wdefense = 8 // It IS a parrying spear after all.
	throwforce = 12	//Not a throwing weapon. Too heavy!
	icon_angle_wielded = 50
	smeltresult = /obj/item/ingot/steel

/obj/item/rogueweapon/spear/partizan/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -6,"sy" = 2,"nx" = 8,"ny" = 2,"wx" = -4,"wy" = 2,"ex" = 1,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 300,"wturn" = 32,"eturn" = -23,"nflip" = 0,"sflip" = 100,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 4,"sy" = -2,"nx" = -3,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)

/obj/item/rogueweapon/spear/boar
	name = "boar spear"
	desc = "A spear with a wide head and a pair of wings below the head. The wings are designed to prevent a boar from charging past the spearhead. \
	It is also useful for parrying and stopping a charging opponent."
	icon = 'icons/roguetown/weapons/polearms64.dmi'
	icon_state = "boarspear"
	force_wielded = 33 // 10% base damage increase
	wdefense = 6 // A little bit extra
	max_blade_int = 200
	smeltresult = /obj/item/ingot/steel

/obj/item/rogueweapon/spear/boar/frei
	name = "Aavnic lándzsa"
	desc = "A regional earspoon lance with a carved handle, adorned with the colours of the Freifechters. These are smithed by the legendary armourers of Vyšvou and given to distinguished lancers upon their graduation."
	icon_state = "cityspear"
	icon = 'icons/roguetown/weapons/special/freifechter.dmi'
	max_blade_int = 300	//You're gonna parry a lot. You need it.
	max_integrity = 235

/obj/item/rogueweapon/spear/boar/frei/pike
	name = "banner of Szöréndnížina"
	desc = "A steel pike with a white and red banner made to spend the time flowing proudly in the wind. A city founded by the free. A State made from the disciplined. Snowy peaks surround her strong walls, her gates make any attack a suicide. Fight, Szöréndnížina. Fight to lyve in a world that rejects you."
	icon_state = "citybanner"
	force = 18
	force_wielded = 33
	possible_item_intents = list(/datum/intent/dagger/sucker_punch, /datum/intent/sword/bash)
	gripped_intents = list(/datum/intent/spear/thrust/pike, /datum/intent/spear/thrust/pike/skewer)

/obj/item/rogueweapon/spear/boar/frei/pike/reformist
	name = "banner of Psydonic Reformism"
	desc = "A steel pike with an altered Psydonic cross representing the order of Primo Reformatio, crossed by a black stripe that symbolizes mourning. Mammukhus sum, qui castellum onere fero. Numquam genua flecto aut gradum amitto."
	icon_state = "reformistbanner"

/obj/item/rogueweapon/spear/naginata
	name = "naginata"
	desc = "A traditional Kazengunese polearm, combining the reach of a spear with the cutting power of a curved blade. Due to the brittle quality of Kazengunese bladesmithing, weaponsmiths have adapted its blade to be easily replaceable when broken by a peg upon the end of the shaft."
	force = 16
	force_wielded = 30
	possible_item_intents = list(/datum/intent/spear/cut/naginata, SPEAR_BASH) // no stab for you little chuddy, it's a slashing weapon
	gripped_intents = list(/datum/intent/spear/cut/naginata, /datum/intent/spear/cut/naginata/sweep, /datum/intent/rend/reach, SPEAR_BASH)
	icon_state = "naginata"
	icon = 'icons/roguetown/weapons/polearms64.dmi'
	minstr = 7
	max_blade_int = 150 //Nippon suteeru (dogshit)
	wdefense = 5
	throwforce = 12	//Not a throwing weapon.
	icon_angle_wielded = 50
	smeltresult = /obj/item/ingot/steel

/obj/item/rogueweapon/spear/naginata/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -6,"sy" = 2,"nx" = 8,"ny" = 2,"wx" = -4,"wy" = 2,"ex" = 1,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 300,"wturn" = 32,"eturn" = -23,"nflip" = 0,"sflip" = 100,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 4,"sy" = -2,"nx" = -3,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)


/obj/item/rogueweapon/spear/assegai/iron
	name = "iron assegai"
	desc = "A long spear originating from the southern regions of Naledi. Commoners living along the great river Bilomari are taught to use assegai so they can defend themselves against the Djinn."
	max_integrity = 150
	max_blade_int = 150
	icon_state = "assegai_iron"
	gripsprite = FALSE

/obj/item/rogueweapon/spear/assegai
	name = "steel assegai"
	desc = "A long spear originating from the southern regions of Naledi. Commoners living along the great river Bilomari are taught to use assegai so they can defend themselves against the Djinn."
	icon = 'icons/roguetown/weapons/polearms64.dmi'
	max_integrity = 250
	max_blade_int = 200
	icon_state = "assegai_steel"
	gripsprite = FALSE
	smeltresult = /obj/item/ingot/steel

/obj/item/rogueweapon/halberd/glaive/elvish
	name = "elvish glaive"
	desc = "An elven weapon that combines the elegant sweeping blade typical of Elven design with a lengthy handle. The true guardian of the forest realm."
	icon_state = "elfglaive"
	max_blade_int = 180 //Elven design makes it sharper
	sellprice = 60

/obj/item/rogueweapon/halberd/glaive/elvish/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -6,"sy" = 2,"nx" = 8,"ny" = 2,"wx" = -4,"wy" = 2,"ex" = 1,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 300,"wturn" = 32,"eturn" = -23,"nflip" = 0,"sflip" = 100,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 4,"sy" = -2,"nx" = -3,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
