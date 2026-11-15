//intent datums ฅ^•ﻌ•^ฅ
/datum/intent/dagger
	clickcd = 8

/datum/intent/dagger/cut
	name = "cut"
	icon_state = "incut"
	attack_verb = list("cuts", "slashes")
	animname = "cut"
	blade_class = BCLASS_CUT
	hitsound = list('sound/combat/hits/bladed/smallslash (1).ogg', 'sound/combat/hits/bladed/smallslash (2).ogg', 'sound/combat/hits/bladed/smallslash (3).ogg')
	penfactor = PEN_NONE
	chargetime = 0
	swingdelay = 0
	clickcd = CLICK_CD_QUICK
	item_d_type = "slash"

/datum/intent/dagger/cut/blunt
	blade_class = BCLASS_BLUNT // Training dagger-exclusive(?) slash. Could potentially be reused for other blunt-edged handweapons.
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	penfactor = PEN_NONE
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR

/datum/intent/dagger/cut/heavy
	name = "heavy cut" /// For unusually heavy daggers with a strong cutting edge.
	damfactor = 1.2
	penfactor = PEN_MEDIUM
	clickcd = 11

/datum/intent/dagger/cut/blunt
	blade_class = BCLASS_BLUNT

/datum/intent/dagger/cut/quick //8CD, making it a faster, lower-pen sidegrade to the 10CD stab. Good on flesh.
	clickcd = CLICK_CD_FAST

/datum/intent/dagger/cut/rend
	name = "wicked slice" // Mini-Rendage!
	icon_state = "inrend"
	attack_verb = list("slices", "dices")
	animname = "cut"
	blade_class = BCLASS_CHOP
	reach = 1
	swingdelay = 10
	penfactor = PEN_NONE
	damfactor = 2
	clickcd = CLICK_CD_CHARGED
	no_early_release = TRUE
	hitsound = list('sound/combat/hits/bladed/genslash (1).ogg', 'sound/combat/hits/bladed/genslash (2).ogg', 'sound/combat/hits/bladed/genslash (3).ogg')
	item_d_type = "slash"
	misscost = 5
	intent_intdamage_factor = 0.05

/datum/intent/dagger/cut/wood
	name = "cut"
	icon_state = "incut"
	attack_verb = list("cuts", "slashes")
	animname = "cut"
	blade_class = BCLASS_BLUNT
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	penfactor = PEN_NONE
	chargetime = 0
	swingdelay = 0
	clickcd = CLICK_CD_QUICK
	item_d_type = "slash"

/datum/intent/dagger/chop
	name = "chop"
	icon_state = "inchop"
	attack_verb = list("chops")
	animname = "chop"
	blade_class = BCLASS_CHOP
	hitsound = list('sound/combat/hits/bladed/smallslash (1).ogg', 'sound/combat/hits/bladed/smallslash (2).ogg', 'sound/combat/hits/bladed/smallslash (3).ogg')
	penfactor = PEN_NONE
	damfactor = 1.5
	swingdelay = 5
	clickcd = CLICK_CD_QUICK
	item_d_type = "slash"

/datum/intent/dagger/chop/cleaver
	hitsound = list('sound/combat/hits/bladed/genchop (1).ogg', 'sound/combat/hits/bladed/genchop (2).ogg', 'sound/combat/hits/bladed/genchop (3).ogg')
	penfactor = PEN_MEDIUM

/datum/intent/dagger/chop/bronze
	name = "wedged chop"
	attack_verb = list("chops")
	damfactor = 1.3

/datum/intent/dagger/chop/wood
	name = "wedged chop"
	icon_state = "inchop"
	attack_verb = list("chops")
	animname = "chop"
	blade_class = BCLASS_BLUNT
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	penfactor = PEN_NONE
	damfactor = 1.3
	swingdelay = 5
	clickcd = CLICK_CD_QUICK
	item_d_type = "slash"

/datum/intent/dagger/thrust
	name = "thrust"
	icon_state = "instab"
	attack_verb = list("thrusts")
	animname = "stab"
	blade_class = BCLASS_STAB
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = PEN_MEDIUM
	chargetime = 0
	clickcd = CLICK_CD_QUICK
	item_d_type = "stab"

/datum/intent/dagger/thrust/quick
	name = "quick thrust"
	icon_state = "inshank"
	attack_verb = list("quickly thrusts")
	damfactor = 0.8
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = PEN_LIGHT
	clickcd = CLICK_CD_FAST

/datum/intent/dagger/thrust/weak
	name = "lopsided thrust" // A slightly weaker thrust for daggers with a curved blade, or which otherwise aren't very good at stabbing.
	damfactor = 0.8
	swingdelay = 0.5 SECONDS
	penfactor = PEN_MEDIUM // Slightly more pen, to compensate in penetration for the lower damage.
	// You're still doing less damage than with a stabbier dagger, but your AP isn't penalised.
	clickcd = CLICK_CD_QUICK

/datum/intent/dagger/thrust/pick
	name = "icepick stab"
	icon_state = "inpick"
	attack_verb = list("stabs", "impales")
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = PEN_BSTEEL
	clickcd = 1.4 SECONDS
	swingdelay = 1.2 SECONDS
	damfactor = 1.1
	blade_class = BCLASS_PICK

/datum/intent/dagger/thrust/blunt
	blade_class = BCLASS_BLUNT // Training dagger-exclusive(?) thrust. Could potentially be reused for other blunt-edged handweapons.
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	penfactor = PEN_NONE
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR

/datum/intent/dagger/thrust/blunt
	blade_class = BCLASS_BLUNT

/datum/intent/dagger/thrust/pick/blunt
	blade_class = BCLASS_BLUNT

/datum/intent/dagger/thrust/bronze
	name = "piercing thrust"
	icon_state = "inpick"
	attack_verb = list("stabs", "impales")
	penfactor = PEN_HEAVY
	clickcd = 12
	swingdelay = 6 //Halfway point between a 'stab' and 'pick'.
	damfactor = 1.05
	blade_class = BCLASS_PICK

/datum/intent/dagger/thrust/wood
	name = "piercing thrust"
	icon_state = "inpick"
	attack_verb = list("stabs", "impales")
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	penfactor = PEN_HEAVY
	clickcd = 12
	swingdelay = 6 //Halfway point between a 'stab' and 'pick'.
	damfactor = 1.05
	blade_class = BCLASS_BLUNT

/datum/intent/dagger/thrust/combat
	name = "wedged thrust"
	icon_state = "instab"
	attack_verb = list("gouges")
	animname = "stab"
	blade_class = BCLASS_STAB
	penfactor = PEN_LIGHT
	damfactor = 0.9
	chargetime = 0
	clickcd = 8
	item_d_type = "stab"

/datum/intent/snip // The salvaging intent!
	name = "snip"
	desc = "Target a piece of clothing to sheer it apart. Sheered clothing is destroyed in the process, but provides some salvaged materials in turn. The amount of salvaged materials gained from sheered clothing scales with your Sewing skill. </br>Target the head-or-skull of someone else to begin grooming their hair. This can be used to give someone a completely new hairstyle, or to shave away whatever hair they have."
	icon_state = "insnip"
	chargetime = 0
	noaa = TRUE
	candodge = FALSE
	canparry = FALSE
	misscost = 0
	no_attack = TRUE
	releasedrain = 0
	blade_class = BCLASS_PUNCH

/obj/item/rogueweapon/huntingknife/scissors/attack(mob/living/M, mob/living/user)
	// Check if using snip intent and targeting a human's head or skull
	if(user.used_intent.type == /datum/intent/snip && ishuman(M))
		var/mob/living/carbon/human/H = M
		// Check if targeting the head or skull zone
		if(user.zone_selected == BODY_ZONE_HEAD || user.zone_selected == BODY_ZONE_PRECISE_SKULL)
			var/list/options = list("hairstyle", "facial hairstyle")
			var/chosen = input(user, "What would you like to style?", "Hair Styling") as null|anything in options
			if(!chosen)
				return

			switch(chosen)
				if("hairstyle")
					var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)
					var/list/valid_hairstyles = list()
					for(var/hair_type in hair_choice.sprite_accessories)
						var/datum/sprite_accessory/hair/head/hair = new hair_type()
						valid_hairstyles[hair.name] = hair_type

					var/new_style = input(user, "Choose their hairstyle", "Hair Styling") as null|anything in valid_hairstyles
					if(new_style)
						user.visible_message(span_notice("[user] begins styling [H]'s hair..."), span_notice("You begin styling [H == user ? "your" : "[H]'s"] hair..."))
						if(!do_after(user, 30 SECONDS, target = H))
							to_chat(user, span_warning("The styling was interrupted!"))
							return

						var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
						if(head && head.bodypart_features)
							var/datum/bodypart_feature/hair/head/current_hair = null
							for(var/datum/bodypart_feature/hair/head/hair_feature in head.bodypart_features)
								current_hair = hair_feature
								break

							if(current_hair)
								var/datum/customizer_entry/hair/hair_entry = new()
								hair_entry.hair_color = current_hair.hair_color

								// Preserve gradients and their colors
								if(istype(current_hair, /datum/bodypart_feature/hair/head))
									hair_entry.natural_gradient = current_hair.natural_gradient
									hair_entry.natural_color = current_hair.natural_color
									if(hasvar(current_hair, "hair_dye_gradient"))
										hair_entry.dye_gradient = current_hair.hair_dye_gradient
									if(hasvar(current_hair, "hair_dye_color"))
										hair_entry.dye_color = current_hair.hair_dye_color

								var/datum/bodypart_feature/hair/head/new_hair = new()
								new_hair.set_accessory_type(valid_hairstyles[new_style], hair_entry.hair_color, H)
								hair_choice.customize_feature(new_hair, H, null, hair_entry)

								head.remove_bodypart_feature(current_hair)
								head.add_bodypart_feature(new_hair)
								H.update_hair()
								playsound(src, 'sound/items/flint.ogg', 50, TRUE)
								user.visible_message(span_notice("[user] finishes styling [H]'s hair."), span_notice("You finish styling [H == user ? "your" : "[H]'s"] hair."))

				if("facial hairstyle")
					if(H.gender != MALE)
						to_chat(user, span_warning("They don't have facial hair to style!"))
						return
					var/datum/customizer_choice/bodypart_feature/hair/facial/humanoid/facial_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/facial/humanoid)
					var/list/valid_facial_hairstyles = list()
					for(var/facial_type in facial_choice.sprite_accessories)
						var/datum/sprite_accessory/hair/facial/facial = new facial_type()
						valid_facial_hairstyles[facial.name] = facial_type

					var/new_style = input(user, "Choose their facial hairstyle", "Hair Styling") as null|anything in valid_facial_hairstyles
					if(new_style)
						user.visible_message(span_notice("[user] begins styling [H]'s facial hair..."), span_notice("You begin styling [H == user ? "your" : "[H]'s"] facial hair..."))
						if(!do_after(user, 60 SECONDS, target = H))
							to_chat(user, span_warning("The styling was interrupted!"))
							return

						var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
						if(head && head.bodypart_features)
							var/datum/bodypart_feature/hair/facial/current_facial = null
							for(var/datum/bodypart_feature/hair/facial/facial_feature in head.bodypart_features)
								current_facial = facial_feature
								break

							if(current_facial)
								var/datum/customizer_entry/hair/facial/facial_entry = new()
								facial_entry.hair_color = current_facial.hair_color
								facial_entry.accessory_type = current_facial.accessory_type

								var/datum/bodypart_feature/hair/facial/new_facial = new()
								new_facial.set_accessory_type(valid_facial_hairstyles[new_style], facial_entry.hair_color, H)
								facial_choice.customize_feature(new_facial, H, null, facial_entry)

								head.remove_bodypart_feature(current_facial)
								head.add_bodypart_feature(new_facial)
								H.update_hair()
								playsound(src, 'sound/items/flint.ogg', 50, TRUE)
								user.visible_message(span_notice("[user] finishes styling [H]'s facial hair."), span_notice("You finish styling [H == user ? "your" : "[H]'s"] facial hair."))
			return TRUE
	// If not using snip intent on head/skull or not a human, proceed with normal attack
	if(user.used_intent.type == /datum/intent/snip)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			var/list/options = list("hairstyle", "facial hairstyle")
			var/chosen = input(user, "What would you like to style?", "Hair Styling") as null|anything in options
			if(!chosen)
				return

			switch(chosen)
				if("hairstyle")
					var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)
					var/list/valid_hairstyles = list()
					for(var/hair_type in hair_choice.sprite_accessories)
						var/datum/sprite_accessory/hair/head/hair = new hair_type()
						valid_hairstyles[hair.name] = hair_type

					var/new_style = input(user, "Choose their hairstyle", "Hair Styling") as null|anything in valid_hairstyles
					if(new_style)
						user.visible_message(span_notice("[user] begins styling [H]'s hair..."), span_notice("You begin styling [H == user ? "your" : "[H]'s"] hair..."))
						if(!do_after(user, 60 SECONDS, target = H))
							to_chat(user, span_warning("The styling was interrupted!"))
							return

						var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
						if(head && head.bodypart_features)
							var/datum/bodypart_feature/hair/head/current_hair = null
							for(var/datum/bodypart_feature/hair/head/hair_feature in head.bodypart_features)
								current_hair = hair_feature
								break

							if(current_hair)
								var/datum/customizer_entry/hair/hair_entry = new()
								hair_entry.hair_color = current_hair.hair_color

								// Preserve gradients and their colors
								if(istype(current_hair, /datum/bodypart_feature/hair/head))
									hair_entry.natural_gradient = current_hair.natural_gradient
									hair_entry.natural_color = current_hair.natural_color
									if(hasvar(current_hair, "hair_dye_gradient"))
										hair_entry.dye_gradient = current_hair.hair_dye_gradient
									if(hasvar(current_hair, "hair_dye_color"))
										hair_entry.dye_color = current_hair.hair_dye_color

								var/datum/bodypart_feature/hair/head/new_hair = new()
								new_hair.set_accessory_type(valid_hairstyles[new_style], hair_entry.hair_color, H)
								hair_choice.customize_feature(new_hair, H, null, hair_entry)

								head.remove_bodypart_feature(current_hair)
								head.add_bodypart_feature(new_hair)
								H.update_hair()
								playsound(src, 'sound/items/flint.ogg', 50, TRUE)
								user.visible_message(span_notice("[user] finishes styling [H]'s hair."), span_notice("You finish styling [H == user ? "your" : "[H]'s"] hair."))

				if("facial hairstyle")
					if(H.gender != MALE)
						to_chat(user, span_warning("They don't have facial hair to style!"))
						return
					var/datum/customizer_choice/bodypart_feature/hair/facial/humanoid/facial_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/facial/humanoid)
					var/list/valid_facial_hairstyles = list()
					for(var/facial_type in facial_choice.sprite_accessories)
						var/datum/sprite_accessory/hair/facial/facial = new facial_type()
						valid_facial_hairstyles[facial.name] = facial_type

					var/new_style = input(user, "Choose their facial hairstyle", "Hair Styling") as null|anything in valid_facial_hairstyles
					if(new_style)
						user.visible_message(span_notice("[user] begins styling [H]'s facial hair..."), span_notice("You begin styling [H == user ? "your" : "[H]'s"] facial hair..."))
						if(!do_after(user, 60 SECONDS, target = H))
							to_chat(user, span_warning("The styling was interrupted!"))
							return

						var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
						if(head && head.bodypart_features)
							var/datum/bodypart_feature/hair/facial/current_facial = null
							for(var/datum/bodypart_feature/hair/facial/facial_feature in head.bodypart_features)
								current_facial = facial_feature
								break

							if(current_facial)
								var/datum/customizer_entry/hair/facial/facial_entry = new()
								facial_entry.hair_color = current_facial.hair_color
								facial_entry.accessory_type = current_facial.accessory_type

								var/datum/bodypart_feature/hair/facial/new_facial = new()
								new_facial.set_accessory_type(valid_facial_hairstyles[new_style], facial_entry.hair_color, H)
								facial_choice.customize_feature(new_facial, H, null, facial_entry)

								head.remove_bodypart_feature(current_facial)
								head.add_bodypart_feature(new_facial)
								H.update_hair()
								playsound(src, 'sound/items/flint.ogg', 50, TRUE)
								user.visible_message(span_notice("[user] finishes styling [H]'s facial hair."), span_notice("You finish styling [H == user ? "your" : "[H]'s"] facial hair."))
			return
	return ..()

/obj/item/rogueweapon/huntingknife/attack_obj(obj/O, mob/living/user)
	if(user.used_intent.type == /datum/intent/snip && istype(O, /obj/item))
		var/obj/item/item = O
		if(item.sewrepair && item.salvage_result) // We can only salvage objects which can be sewn!
			var/salvage_time = 70
			salvage_time = (70 - ((user.get_skill_level(/datum/skill/craft/sewing)) * 10))
			if(!do_after(user, salvage_time, target = user))
				return

			if(item.fiber_salvage) //We're getting fiber as base if fiber is present on the item
				new /obj/item/natural/fibers(get_turf(item))
			if(istype(item, /obj/item/storage))
				var/obj/item/storage/bag = item
				bag.emptyStorage()
			var/skill_level = user.get_skill_level(/datum/skill/craft/sewing)
			if(prob(50 - (skill_level * 10))) // We are dumb and we failed!
				to_chat(user, span_info("I ruined some of the materials due to my lack of skill..."))
				playsound(item, 'sound/foley/cloth_rip.ogg', 50, TRUE)
				qdel(item)
				user.mind.add_sleep_experience(/datum/skill/craft/sewing, (user.STAINT)) //Getting exp for failing
				return //We are returning early if the skill check fails!
			item.salvage_amount -= item.torn_sleeve_number
			for(var/i = 1; i <= item.salvage_amount; i++) // We are spawning salvage result for the salvage amount minus the torn sleves!
				var/obj/item/Sr = new item.salvage_result(get_turf(item))
				Sr.color = item.color
			user.visible_message(span_notice("[user] salvages [item] into usable materials."))
			playsound(item, 'sound/items/flint.ogg', 100, TRUE)
			qdel(item)
			user.mind.add_sleep_experience(/datum/skill/craft/sewing, (user.STAINT))
	return ..()

/datum/intent/dagger/sucker_punch
	name = "unevadable punch"
	icon_state = "inpunch"
	desc = "Breach your target's guard with a swift-and-sudden jab. This strike deals low damage, but cannot be parried or dodged."
	attack_verb = list("punches", "jabs", "clocks")
	animname = "strike"
	blade_class = BCLASS_BLUNT
	hitsound = list('sound/combat/hits/punch/punch_hard (1).ogg', 'sound/combat/hits/punch/punch_hard (2).ogg', 'sound/combat/hits/punch/punch_hard (3).ogg')
	damfactor = 0.6 // Less damage than a normal attack I don't want this to be better than stabbing
	penfactor = PEN_NONE
	clickcd = 14
	recovery = 10
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR
	canparry = FALSE
	candodge = FALSE
