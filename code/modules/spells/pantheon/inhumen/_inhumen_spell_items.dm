////////////
//MATTHIOS//
////////////

//ALCHEMY
/obj/item/
	var/aura_color = null

/obj/item/Initialize()
	. = ..()
	if(aura_color)
		apply_aura()

/obj/item/proc/apply_aura()
	if(!aura_color)
		return
	if(!filters)
		filters = list()
	remove_aura()
	var/aura_color_final = "[aura_color]40"
	filters += filter(type="outline", color=aura_color_final, size=2)

/obj/item/proc/remove_aura()
	if(!filters)
		return

	for(var/F in filters)
		if(islist(F))
			if(F["type"] == "outline")
				filters -= F

/obj/item/proc/refresh_aura()
	if(aura_color)
		apply_aura()

/obj/item/alchserum
	var/current_color = "#ffffff"

/obj/item/alchserum/Initialize()
	. = ..()
	update_icon()

/obj/item/alchserum/update_icon()
	cut_overlays()

/proc/funny_smoke(atom/source, radius = 0, sound_vol = 50)
	if(!source)
		return
	var/turf/T = get_turf(source)
	if(!T)
		return
	playsound(T, 'sound/items/smokebomb.ogg', sound_vol)
	var/datum/effect_system/smoke_spread/smoke = new
	smoke.set_up(radius, T)
	smoke.start()

var/global/list/da_bubbles = list('sound/foley/bubb (1).ogg','sound/foley/bubb (2).ogg','sound/foley/bubb (3).ogg','sound/foley/bubb (4).ogg','sound/foley/bubb (5).ogg')

// admin spawnable only
/obj/item/matthios_canister
	name = "gilded alchemical canister"
	desc = "A strange, fragile alchemical vessel housing a silent power beyond human comprehension. Is this true?"
	icon = 'icons/obj/structures/heart_items.dmi'
	icon_state = "canister_empty"
	w_class = WEIGHT_CLASS_TINY
	var/current_color = "#ffffff"
	var/list/required_ingredients = list()
	var/list/inserted_ingredients = list()
	var/list/ingredient_colors = list()
	var/result_path = null

/obj/item/matthios_canister/Initialize()
	. = ..()
	update_icon()

/obj/item/matthios_canister/examine(mob/user)
	. = ..()

	if(HAS_TRAIT(user, TRAIT_FREEMAN))
		. += span_notice("[freeman_truth()]")
		. += span_warning("[freeman_progress(user)]")

/obj/item/matthios_canister/proc/freeman_truth()
	return "..."

/obj/item/matthios_canister/proc/freeman_progress(mob/user)
	return "..."

/obj/item/matthios_canister/update_icon()
	. = ..()
	cut_overlays()
	var/mutable_appearance/fluid = mutable_appearance(icon, "canister_fluid")
	fluid.color = current_color
	add_overlay(fluid)

/obj/item/matthios_canister/attackby(obj/item/I, mob/user)
	if(!HAS_TRAIT(user, TRAIT_MATTHIOS_EYES))
		return TRUE

	return TRUE

/obj/item/matthios_canister/proc/check_completion(mob/user)
	for(var/T in required_ingredients)
		if(!(T in inserted_ingredients))
			return
	alch_transform(user)

/obj/item/matthios_canister/proc/alch_transform(mob/user)
	if(!result_path)
		return
	to_chat(user, span_notice("The mixture stabilizes successfully."))
	new result_path(get_turf(src))
	funny_smoke(src)
	qdel(src)

//////////////////////
//Vial of Lyfestruth//
//Uses all herbs in game, and one purified lux, explosively (literal!) revives your target.

/obj/item/matthios_canister/lyfestruth
	name = "vial of lyfestruth base"
	desc = "Within the glass swells a searing draught, as though molten gold were stirred with the heartblood of a volcano. It glows too bright, too alive. The vessel ought crack, yet it does not. What is this impossible sorcery?"
	current_color = "#ffffff"	
	result_path = /obj/item/alchserum/matthios_lyfestruth
	var/has_lux = FALSE
	var/lux_types = list(
		/obj/item/reagent_containers/lux,
		/obj/item/reagent_containers/lux_impure,
		/obj/item/reagent_containers/lux_moss,
		/obj/item/leechtick_bloated,

	)
	required_ingredients = list(
		/obj/item/alch/atropa,
		/obj/item/alch/matricaria,
		/obj/item/alch/symphitum,
		/obj/item/alch/taraxacum,
		/obj/item/alch/euphrasia,
		/obj/item/alch/paris,
		/obj/item/alch/calendula,
		/obj/item/alch/mentha,
		/obj/item/alch/urtica,
		/obj/item/alch/salvia,
		/obj/item/alch/hypericum,
		/obj/item/alch/benedictus,
		/obj/item/alch/valeriana,
		/obj/item/alch/artemisia,
		/obj/item/reagent_containers/food/snacks/grown/manabloom,
		/obj/item/alch/rosa,
	)
	ingredient_colors = list(
		/obj/item/alch/atropa = "#8b37c4",
		/obj/item/alch/matricaria = "#f5e6a8",
		/obj/item/alch/symphitum = "#4f8f6a",
		/obj/item/alch/taraxacum = "#ffd84d",
		/obj/item/alch/euphrasia = "#cfe8ff",
		/obj/item/alch/paris = "#62a044",
		/obj/item/alch/calendula = "#ff9f1a",
		/obj/item/alch/mentha = "#3aff7a",
		/obj/item/alch/urtica = "#2f7f3f",
		/obj/item/alch/salvia = "#6b8e23",
		/obj/item/alch/hypericum = "#ffcc33",
		/obj/item/alch/benedictus = "#d4b24c",
		/obj/item/alch/valeriana = "#8e5a3c",
		/obj/item/alch/artemisia = "#7a9e7e",
		/obj/item/reagent_containers/food/snacks/grown/manabloom = "#66ccff",
		/obj/item/alch/rosa = "#ff4d6d"
	)

	result_path = /obj/item/alchserum/matthios_lyfestruth

/obj/item/matthios_canister/lyfestruth/Initialize()
	. = ..()
	required_ingredients = required_ingredients.Copy()

/obj/item/matthios_canister/lyfestruth/freeman_progress(mob/user)
	if(!required_ingredients.len && !has_lux)
		return "The draught is complete. You can feel the heat, but it lacks the life essence to stabilize it."

	var/typepath = pick(required_ingredients)
	var/atom/A = typepath
	var/initial_name = initial(A.name)

	if(has_lux)
		return "It lacks [initial_name], but gold dust may also serve. Lux has been bound, speeding the process. ([required_ingredients.len] components yet unbound)"

	return "It lacks [initial_name], but gold dust may also serve. ([required_ingredients.len] components yet unbound)"


/obj/item/matthios_canister/lyfestruth/freeman_truth()
	return "This is no vulgar tonic, but 'Geald', the stolen fyre of Astrata condensed into liquid form. Oft called 'liquid anastasis', it restores not flesh, but the moment before death was writ. However, it is a fact of its volatile nature."

/obj/item/matthios_canister/lyfestruth/attackby(obj/item/I, mob/user)
	. = ..()
	if(!I)
		return 

	var/is_gold = istype(I, /obj/item/alch/golddust)
	var/is_lux = FALSE

	for(var/L in lux_types)
		if(istype(I, L))
			is_lux = TRUE
			break

	var/is_valid = FALSE
	for(var/T in required_ingredients)
		if(istype(I, T))
			is_valid = TRUE
			break

	if(!is_valid && !is_gold && !is_lux)
		return

	if(do_after(user, 2 SECONDS))

		if(is_lux)
			if(has_lux)
				to_chat(user, span_warning("The vessel recoils—too much Lux would surely rupture it."))
				return

			has_lux = TRUE
			current_color = "#66ccff"

			var/remove_count = max(1, round(required_ingredients.len * 0.5))
			for(var/i = 1, i <= remove_count, i++)
				if(!required_ingredients.len)
					break
				var/chosen = pick(required_ingredients)
				required_ingredients -= chosen

			to_chat(user, span_notice("The mixture surges! Its progress hastened considerably by the life essence!"))

			qdel(I)
			playsound(user, 'sound/misc/lava_death.ogg', 15, FALSE)
			update_icon()
			check_completion(user)
			return

		if(is_gold)
			if(!required_ingredients.len)
				return

			var/chosen = pick(required_ingredients)
			required_ingredients -= chosen
			current_color = "#fff066"

			qdel(I)
			playsound(user, 'sound/misc/lava_death.ogg', 15, FALSE)
			update_icon()
			check_completion(user)
			return

		if(!(I.type in required_ingredients))
			to_chat(user, span_warning("That essence has already been bound."))
			return

		required_ingredients -= I.type

		if(ingredient_colors[I.type])
			current_color = ingredient_colors[I.type]

		qdel(I)
		playsound(user, pick(da_bubbles), 30, FALSE)
		update_icon()
		check_completion(user)

	return

/obj/item/matthios_canister/lyfestruth/check_completion(mob/user)
	if(!required_ingredients.len && !has_lux)
		to_chat(user, span_warning("The mixture writhes… yet something radiant and vital is still missing..."))
		return

	if(!required_ingredients.len && has_lux)
		alch_transform(user)

/obj/item/alchserum/matthios_lyfestruth
	name = "vial of lyfestruth"
	desc = "A radiant vial containing a volatile mixture. The liquid within churns with molten intensity, casting a searing orange-gold glow that flickers against its glass prison. It seems extremely volatile."
	icon = 'icons/obj/structures/heart_items.dmi'
	icon_state = "canister_empty"
	current_color = "#ff9d00"
	aura_color = "#fffaad"
	w_class = WEIGHT_CLASS_TINY

/obj/item/alchserum/matthios_lyfestruth/attack(mob/living/target, mob/user)
	if(!istype(target, /mob/living/carbon))
		return
	if(target.stat != DEAD)
		to_chat(user, span_notice("They are not dead!"))
		return
	if(!target.mind || !target.mind.active)
		to_chat(user, "Strangely, the fluid seems a little colder when you try.")
		return
	if(HAS_TRAIT(target, TRAIT_DNR))
		to_chat(user, span_danger("The Geald within the vial does not react to them at all. Strange."))
		return	
	if(HAS_TRAIT(target, TRAIT_NOBLE))
		to_chat(user, span_notice("You have a feeling that Matthios would personally eviscerate you for trying this on them."))
		return

	to_chat(user, span_notice("You begin pouring the lyfestruth over [target.name]..."))

	if(do_after(user, 6 SECONDS, target))
		if(!target || target.stat != DEAD)
			return
		apply_effect(target, user)

/obj/item/alchserum/matthios_lyfestruth/proc/apply_effect(mob/living/carbon/target, mob/user)
	if(!target)
		return

	var/choice
	if(target.client)
		choice = alert(target, "You feel divine warmth offering you freedom from the shackles of Necra...", "Revival", "I need to wake up! Freedom!", "I'd rather be dead than free.")
	else
		choice = "I'd rather be dead than free."

	var/accepted = (choice == "I need to wake up! Freedom!")

	if(accepted)
		target.revive(full_heal = TRUE)
		to_chat(target, span_warning("Your body is violently forced back to life, as a searing heat floods from within— IT BURNS!!"))
		target.visible_message(span_warning("[target.name]'s body rewinds to life... only for a massive shockwave of fire to burst from them!"))
		target.adjust_fire_stacks(5)
		target.ignite_mob()
		target.emote("agony", forced = TRUE)
	else
		to_chat(target, span_warning("You refuse the call... but the warmth curdles into something volatile."))
		target.visible_message(span_warning("[target.name] does not rise. The Geald within them destabilizes violently!"))

	var/turf/T = get_turf(target)
	if(T)
		explosion(T, devastation_range = null, heavy_impact_range = null, light_impact_range = 4, flame_range = 8, smoke = TRUE, soundin = pick('sound/misc/explode/bottlebomb (1).ogg','sound/misc/explode/bottlebomb (2).ogg'))

	for(var/mob/living/M in range(4, target))
		if(M == target)
			continue
		var/dir = get_dir(target, M)
		var/turf/throw_target = get_edge_target_turf(M, dir)
		if(throw_target)
			M.throw_at(throw_target, 4, 2)

	qdel(src)

////////////////////
//Vial of Firstlaw//
//The core of Malchemy, harsher than the real deal. If you fail to produce the good, you lose all the ingredients.

/obj/item/matthios_canister/firstlaw
	name = "vial of firstlaw"
	desc = "A suffocating pressure coils within the glass, as though something immense has been forced into too small a space. The contents do not slosh nor settle... they weigh upon reality itself."
	current_color = "#e100ff"
	aura_color = "#ff00b3"

	var/stone_progress = 0
	var/current_choice = null

	required_ingredients = list(
		/obj/item/natural/dirtclod,
		/obj/item/natural/clay,
		/obj/item/natural/stone,
		/obj/item/rogueore/coal,
		/obj/item/rogueore/iron,
		/obj/item/rogueore/gold,
		/obj/item/roguegem/yellow,
		/obj/item/roguegem/green,
		/obj/item/roguegem/violet,
		/obj/item/roguegem/blue,
		/obj/item/roguegem/diamond,
	)

/obj/item/matthios_canister/firstlaw/freeman_truth()
	return "All things bend to the First Law. Equivalent exchange is not a rule, it is the only truth. To hold it is to feel a principle enforced: nothing is gained, nothing is lost, only exchanged."

/obj/item/matthios_canister/firstlaw/freeman_progress(mob/user)
	return "Stored Value: [stone_progress] stone\nChoice: [current_choice ? current_choice : "NONE"]"

/obj/item/matthios_canister/firstlaw/proc/get_stone_value(obj/item/I)
	if(istype(I, /obj/item/natural/dirtclod)) return 1
	if(istype(I, /obj/item/natural/clay)) return 1
	if(istype(I, /obj/item/natural/stone)) return 1
	if(istype(I, /obj/item/rogueore/coal)) return 4
	if(istype(I, /obj/item/rogueore/iron)) return 8
	if(istype(I, /obj/item/rogueore/gold)) return 32
	if(istype(I, /obj/item/roguegem/yellow)) return 65
	if(istype(I, /obj/item/roguegem/green)) return 129
	if(istype(I, /obj/item/roguegem/violet)) return 193
	if(istype(I, /obj/item/roguegem/blue)) return 257
	if(istype(I, /obj/item/roguegem/diamond)) return 578
	if(istype(I, /obj/item/riddleofsteel)) return 1184
	return 0

/obj/item/matthios_canister/firstlaw/proc/get_cost(choice)
	switch(choice)
		if("Dirt") return 0
		if("Clay") return 1
		if("Stone") return 1
		if("Mortar & Pestle") return 2
		if("Coal") return 4
		if("Iron") return 8
		if("Alchemy Station") return 10
		if("Cauldron") return 16
		if("Firstlaw Extract") return 18
		if("Gold") return 32
		if("Toper") return 65
		if("Gemerald") return 129
		if("Saffira") return 193
		if("Blortz") return 257
		if("Dorpel") return 578
		if("Riddle of Steel") return 1184

/obj/item/matthios_canister/firstlaw/proc/get_requirement(choice)
	switch(choice)
		if("Mortar & Pestle","Alchemy Station","Cauldron","Dirt","Clay","Stone") return SKILL_LEVEL_NONE
		if("Firstlaw Extract","Coal","Iron") return SKILL_LEVEL_JOURNEYMAN
		if("Gold","Toper","Gemerald","Saffira","Blortz") return SKILL_LEVEL_EXPERT
		if("Dorpel","Riddle of Steel") return SKILL_LEVEL_MASTER

/obj/item/matthios_canister/firstlaw/attackby(obj/item/I, mob/user)
	if(!HAS_TRAIT(user, TRAIT_MATTHIOS_EYES))
		to_chat(user, span_warning("The principle escapes me. This is nonsense and heresy."))
		return TRUE

	var/valid = FALSE
	for(var/T in required_ingredients)
		if(istype(I, T))
			valid = TRUE
			break

	if(!valid)
		return TRUE

	if(do_after(user, 1 SECONDS))
		var/value = get_stone_value(I)
		stone_progress += value
		to_chat(user, span_warning("[I] disintegrates into a refined dust...<br>(Current Value: [stone_progress])"))
		playsound(user.loc,'sound/misc/smelter_sound.ogg', 50, FALSE)
		qdel(I)
		update_icon()

	return TRUE

/obj/item/matthios_canister/firstlaw/proc/process_stone_batch(mob/user, turf/T)
	var/level = user.get_skill_level(/datum/skill/magic/holy)
	var/batch_size = 2 + 2 * level

	var/found_any = FALSE
	for(var/obj/item/natural/stone/S in T)
		found_any = TRUE
		break

	if(!found_any)
		return FALSE

	var/processed_any = FALSE

	while(TRUE)
		var/list/batch = list()

		for(var/obj/item/natural/stone/S in T)
			batch += S
			if(batch.len >= batch_size)
				break

		if(!batch.len)
			break

		if(!do_after(user, 1 SECONDS, target = user))
			break

		for(var/obj/item/natural/stone/S in batch)
			if(QDELETED(S))
				continue
			stone_progress += 1
			qdel(S)
			processed_any = TRUE

		playsound(user.loc, 'sound/misc/smelter_sound.ogg', 25, FALSE)

	if(processed_any)
		to_chat(user, span_warning("You gather the stones together, dissolving them into a pile of fine dust.<br>(Current Value: [stone_progress])"))
		update_icon()

	return processed_any

/obj/item/matthios_canister/firstlaw/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(!proximity_flag) return
	if(!HAS_TRAIT(user, TRAIT_MATTHIOS_EYES)) return

	if(istype(target, /obj/item/natural/stone))
		var/obj/item/natural/stone/S = target
		if(do_after(user, 0.5 SECONDS, target = user))
			stone_progress += 1
			qdel(S)
			playsound(user.loc,'sound/misc/smelter_sound.ogg', 50, FALSE)
			to_chat(user, span_warning("The stone crumbles into dust.<br>(Current Value: [stone_progress])"))
			update_icon()
		return

	if(istype(target, /obj/item/natural/rock))
		var/obj/item/natural/rock/R = target
		if(do_after(user, 2 SECONDS, target = user))
			var/gain = rand(1,4)
			stone_progress += gain

			if(prob(4))
				var/list/ores = list(
					/obj/item/natural/stone,
					/obj/item/rogueore/coal,
					/obj/item/rogueore/iron,
					/obj/item/rogueore/gold,
					/obj/item/roguegem/blue,
					/obj/item/roguegem/yellow,
					/obj/item/roguegem/green,
					/obj/item/roguegem/violet,
				)
				var/typepath = pick(ores)
				var/bonus = get_stone_value(new typepath)
				stone_progress += bonus

			qdel(R)
			playsound(user.loc,'sound/misc/smelter_sound.ogg', 50, FALSE)
			to_chat(user, span_warning("The boulder is reduced to dust.<br>(Current Value: [stone_progress])"))
			update_icon()
		return

	if(isturf(target))
		var/turf/T = target
		process_stone_batch(user, T)

/obj/item/matthios_canister/firstlaw/attack_self(mob/user)
	if(!HAS_TRAIT(user, TRAIT_MATTHIOS_EYES))
		to_chat(user, span_warning("This is heresy beyond me."))
		return

	var/list/options_map = list(
		"Mortar & Pestle" = list(/obj/item/reagent_containers/glass/mortar, /obj/item/pestle),
		"Cauldron" = /obj/machinery/light/rogue/cauldron,
		"Alchemy Station" = /obj/structure/fluff/alch,
		"Firstlaw Extract" = /obj/item/alchserum/matthios_insight,
		"Dirt" = /obj/item/natural/dirtclod,
		"Clay" = /obj/item/natural/clay,
		"Stone" = /obj/item/natural/stone,
		"Coal" = /obj/item/rogueore/coal,
		"Iron" = /obj/item/rogueore/iron,
		"Gold" = /obj/item/rogueore/gold,
		"Toper" = /obj/item/roguegem/yellow,
		"Gemerald" = /obj/item/roguegem/green,
		"Saffira" = /obj/item/roguegem/violet,
		"Blortz" = /obj/item/roguegem/blue,
		"Dorpel" = /obj/item/roguegem/diamond,
		"Riddle of Steel" = /obj/item/riddleofsteel
	)

	var/level = user.get_skill_level(/datum/skill/magic/holy)

	if(current_choice)
		var/cost = get_cost(current_choice)
		var/remaining = max(cost - stone_progress, 0)

		var/finalize_text = (stone_progress >= cost) ? "Finalize Exchange (Ready!)" : "Finalize Exchange ([remaining] left.)"
		var/redirect_text = "Redirect Law"
		var/refund_text = "Refund Stones (75%)"
		var/nevermind_text = "Nevermind"

		var/list/choices = list(finalize_text, redirect_text, refund_text, nevermind_text)

		var/decision = input(user, "The Law is in motion.", "First Law") as null|anything in choices
		if(!decision || decision == nevermind_text)
			return

		if(decision == refund_text)
			var/refund_amt = round(stone_progress * 0.75)
			for(var/i in 1 to refund_amt)
				new /obj/item/natural/stone(get_turf(src))

			stone_progress = 0
			current_choice = null
			to_chat(user, span_warning("The Law unravels. Most is returned."))
			update_icon()
			return

		if(decision == redirect_text)
			var/list/display = list()
			var/list/lookup = list()

			for(var/K in options_map)
				var/c = get_cost(K)
				var/r = get_requirement(K)

				if(level >= r)
					var/entry = "[K] ([c])"
					display += entry
					lookup[entry] = K

			var/pick_choice = input(user, "Redirect the Law?", "First Law") as null|anything in display
			if(!pick_choice)
				return

			var/new_choice = lookup[pick_choice]
			current_choice = new_choice
			to_chat(user, span_notice("The Law bends toward [new_choice]."))

			var/new_cost = get_cost(new_choice)

			if(stone_progress >= new_cost)
				var/excess = stone_progress - new_cost
				stone_progress = 0

				var/result = options_map[new_choice]

				if(islist(result))
					for(var/typepath in result)
						if(ispath(typepath))
							new typepath(get_turf(src))
				else
					if(ispath(result))
						new result(get_turf(src))

				var/half = round(excess / 2)
				for(var/i in 1 to half)
					new /obj/item/natural/stone(get_turf(src))

				to_chat(user, span_notice("The Law resolves instantly into [new_choice], for a hefty cost..."))
				if(isliving(user))
					var/mob/living/U = user
					U.adjust_fire_stacks(2)
					U.adjustFireLoss(125)
					U.ignite_mob()
				funny_smoke(src)
				qdel(src)
				return

			return

		if(decision == finalize_text)
			if(stone_progress < cost)
				to_chat(user, span_warning("The Law demands more value to be transacted."))
				return

			if(do_after(user, 2.5 SECONDS, target = user, same_direction = TRUE))

				var/list/single_crafts = list(
					"Mortar & Pestle",
					"Cauldron",
					"Alchemy Station",
					"Firstlaw Extract"
				)

				var/is_single = (current_choice in single_crafts)

				var/amount
				var/excess

				if(is_single)
					amount = 1
					excess = stone_progress - cost
				else
					amount = (cost > 0) ? floor(stone_progress / cost) : 1
					excess = (cost > 0) ? (stone_progress % cost) : 0

				var/result = options_map[current_choice]

				var/base_fail = min(75, round(cost / 5))
				var/skill_bonus = level * 5

				var/total_spent = amount * cost
				var/overpay = max(0, stone_progress - total_spent)
				var/overpay_ratio = cost > 0 ? (overpay / cost) : 0
				var/overpay_bonus = round(overpay_ratio * 30)

				var/final_fail = max(0, base_fail - skill_bonus - overpay_bonus)
				if(final_fail)
					to_chat(user, span_notice("--[final_fail]% chance of failure per item! Matthios have mercy..."))

				for(var/i in 1 to amount)
					if(prob(final_fail))
						if(prob(50))
							var/list/fail_results = list(/obj/item/ingot/aaslag, /obj/item/scrap)
							var/typepath = pick(fail_results)
							new typepath(get_turf(src))
							to_chat(user, span_notice("The exchange falters..."))
						else
							to_chat(user, span_warning("The Law rejects part of the exchange."))
					else
						var/turf/spawn_turf = get_turf(src)

						if(is_single)
							var/turf/front = get_step(user, user.dir)

							if(front && !front.density)
								var/blocked = FALSE
								for(var/atom/A in front)
									if(A.density)
										blocked = TRUE
										break

								if(!blocked)
									spawn_turf = front
							else
								spawn_turf = get_turf(src)

						if(islist(result))
							for(var/typepath in result)
								if(ispath(typepath))
									new typepath(spawn_turf)
						else
							if(ispath(result))
								new result(spawn_turf)



				to_chat(user, span_notice("The exchange concludes. ([amount] attempted)"))

				if(excess > 0)
					for(var/i in 1 to excess)
						new /obj/item/natural/stone(get_turf(src))

				stone_progress = 0
				funny_smoke(src)
				qdel(src)
				return
	else
		var/list/display = list()
		var/list/lookup = list()

		for(var/K in options_map)
			var/cost = get_cost(K)
			var/req = get_requirement(K)

			if(level >= req)
				var/entry = "[K] ([cost])"
				display += entry
				lookup[entry] = K

		if(!display.len)
			to_chat(user, span_warning("Nothing may yet be chosen."))
			return

		var/choice = input(user, "What shall be defined?", "First Law") as null|anything in display
		if(!choice)
			return 

		current_choice = lookup[choice]
		to_chat(user, span_notice("The Law bends toward [current_choice]."))


//////////////////////
//Vial of Kingsfeast//
//Uses up to 10 organic items and converts them into 1 lavish food of choice. It can fail and become bread or worse.

/obj/item/matthios_canister/kingsfeast
	name = "vial of kingsfeast base"
	desc = "The brew within sloshes thick as spoiled blood. A stench rises from it most foul, resembling a mixture of rot and brine. The very vapours of said tincture can dissolve organic matter."

	var/max_ingredients = 10

	required_ingredients = list(
		/obj/item/alch/sinew,
		/obj/item/natural/bone,
		/obj/item/natural/bundle/bone,
		/obj/item/natural/fibers,
		/obj/item/natural/bundle/fibers,
		/obj/item/reagent_containers/powder/salt,
		/obj/item/reagent_containers/food
	)
	ingredient_colors = list(
		/obj/item/alch/sinew = "#a84a4a",
		/obj/item/natural/bone = "#e8e2cf",
		/obj/item/natural/bundle/bone = "#e8e2cf",
		/obj/item/natural/fibers = "#007e1f",
		/obj/item/natural/bundle/fibers = "#007e1f",
		/obj/item/reagent_containers/powder/salt = "#f0f0f0",
		/obj/item/reagent_containers/food = "#d67a4a"
	)

/obj/item/matthios_canister/kingsfeast/freeman_truth()
	return "A primal alchemical reduction tincture. All organic input is stripped to its nutritional and experiential essence, then recomposed into perfected sustenance. It does not cook, it outright defines what it means to be food."

/obj/item/matthios_canister/kingsfeast/freeman_progress(mob/user)
	var/remaining = max_ingredients - inserted_ingredients.len
	if(remaining <= 0)
		return "The feast is ready to take form."

	return "It needs [remaining] more organic offerings."

/obj/item/matthios_canister/kingsfeast/attackby(obj/item/I, mob/user)
	if(!HAS_TRAIT(user, TRAIT_MATTHIOS_EYES))
		to_chat(user, span_warning("The hell do I do with this? This is no alchemy!"))
		return TRUE

	var/valid = FALSE
	for(var/T in required_ingredients)
		if(istype(I, T))
			valid = TRUE
			break

	if(!valid)
		return TRUE

	if(inserted_ingredients.len >= max_ingredients)
		to_chat(user, span_warning("The canister refuses to take more. It is... full."))
		return TRUE

	if(do_after(user, 1.5 SECONDS))

		if(istype(I, /obj/item/natural/bundle/fibers))
			var/obj/item/natural/bundle/fibers/B = I
			for(var/i = 1 to B.amount)
				inserted_ingredients += /obj/item/natural/fibers
		else
			inserted_ingredients += I.type

		var/color_to_use = null
		for(var/T in ingredient_colors)
			if(istype(I, T))
				color_to_use = ingredient_colors[T]
				break

		if(color_to_use)
			current_color = color_to_use

		var/list/absorb_flavor = list(
			"The mixture's vapors overtake the [I] at once, breaking it down into a fine, formless draught...",
			"A faint hiss rises as the [I] is rendered to its base components, drawn into the brew...",
			"The [I] loses all shape, reduced to a pale suspension within the thickened mixture...",
			"The [I] slackens and falls apart, its substance wholly undone and folded into the draught...",
			"The brew strips the [I] to its essence, leaving no trace of its former form...",
			"A subtle reaction passes through the vessel as the [I] is reduced and made one with it...",
			"The [I] collapses into a fine residue, its nature thoroughly dissolved into the mixture...",
			"The [I] is unmade in moments, rendered down and claimed by the alchemical base...",
			"The draught clouds as the [I] is broken to its simplest form and drawn within...",
			"The [I] yields entirely, reduced and recomposed within the vessel's thick contents..."
		)
		qdel(I)
		playsound(user, pick(da_bubbles), 30, FALSE)
		to_chat(user, span_notice(pick(absorb_flavor)))
		update_icon()
		check_completion(user)

	return TRUE

/obj/item/matthios_canister/kingsfeast/check_completion(mob/user)
	if(inserted_ingredients.len < max_ingredients)
		return

	alch_transform(user)

/obj/item/matthios_canister/kingsfeast/alch_transform(mob/user)
	var/ishungry = user.nutrition < NUTRITION_LEVEL_HUNGRY
	var/miraclecheck = 10 * user.get_skill_level(/datum/skill/magic/holy)
	to_chat(user, span_notice("You begin channeling your greed into the mixture..."))

	var/list/options = list(
		"Ducal Peppersteak" = /obj/item/reagent_containers/food/snacks/rogue/peppersteak/ducal,
		"Lobster Meal" = /obj/item/reagent_containers/food/snacks/rogue/fryfish/lobster/meal,
		"Crabcake" = /obj/item/reagent_containers/food/snacks/rogue/crabcake,
		"Chocolate" = /obj/item/reagent_containers/food/snacks/chocolate,
		"Meat Tomatoplate" = /obj/item/reagent_containers/food/snacks/rogue/meattomatoplate,
		"Broth Brique" = /obj/item/reagent_containers/food/snacks/rogue/meat/brothbrique,
		"Strawberry Cake" = /obj/item/reagent_containers/food/snacks/rogue/strawberrycake,
		"Cookies" = /obj/item/reagent_containers/food/snacks/rogue/cookiec,
		"Meat Handpie" = /obj/item/reagent_containers/food/snacks/rogue/handpie/meat,
	)

	var/choice = input(user, "What form shall your greed take?", "Kingsfeast") as null|anything in options
	if(!choice)
		return

	var/result_type = options[choice]

	if(prob(25) && !ishungry)
		to_chat(user, span_warning("The mixture ignites violently, collapsing into useless slag and bitter disappointment. It... technically is edible. I guess?"))
		new /obj/item/reagent_containers/food/snacks/badrecipe(get_turf(src))
		funny_smoke(src)
		qdel(src)
		return
	
	if(!ishungry && prob(80 - miraclecheck)) // bread troll
		to_chat(user, span_warning("The mixture shifts... simplifying itself into something more befitting your greed."))
		new /obj/item/reagent_containers/food/snacks/rogue/bread(get_turf(src))
		if(prob(20))
			user.emote(pick("sigh","groan"))
		funny_smoke(src)
		qdel(src)
		return

	if(ishungry && prob(25)) 
		to_chat(user, span_notice("Matthios takes pity on your mortal limitations. You compulsively shout in gratitude!"))
		user.say(pick("PRAISE YOU, O' GENEROUS MATTHIOS!!","AT LAST, THE TRUE GOLD OF CULINARY ALCHEMY!!","BLESSED BE THY HANDS WHICH GRANT ME SUSTENANCE, MATTHIOS!!","I SHALL GIVE ALL FOR THY SMILE, LORD OF FREEDOM!!"), language = /datum/language/common)

	to_chat(user, span_notice("The mixture responds to your greed, shaping and taking the desired form. It feels warm and tasty!"))

	new result_type(get_turf(src))
	funny_smoke(src)
	qdel(src)

/obj/item/matthios_canister/kingsfeast/attack_self(mob/user)
	if(inserted_ingredients.len < max_ingredients)
		to_chat(user, span_warning("It is not yet ready."))
		return

	to_chat(user, span_notice("The mixture churns expectantly, awaiting the weight of your greed..."))
	alch_transform(user)

/obj/item/matthios_canister/goodnite
	name = "vial of goodnite base"
	desc = "A dim, cloudy fluid rests inside, barely moving. Occasionally, something viscous streaks through it— like diluted brain matter. The glass feels warm, almost comforting. Staring at too long makes your eyelids heavy, and you get an odd compulsion to drink it."
	
	var/max_ingredients = 5

	required_ingredients = list(
		/obj/item/alch/bonemeal,
		/obj/item/alch/mentha,
		/obj/item/alch/manabloompowder,
		/obj/item/reagent_containers/powder,
		/obj/item/natural/bone,
		/obj/item/natural/bundle/bone,
	)

	ingredient_colors = list(
		/obj/item/alch/bonemeal = "#ffffff",
		/obj/item/alch/mentha = "#3aff7a",
		/obj/item/alch/manabloompowder = "#66ccff",
		/obj/item/reagent_containers/powder = "#ff00b3",
		/obj/item/natural/bone = "#e8e2cf",
		/obj/item/natural/bundle/bone = "#e8e2cf",
	)

/obj/item/matthios_canister/goodnite/freeman_truth()
	return "Condensed stellar residue. Dust harvested from a somnolent star that emits rhythmic sleep pulses. This is not sedation. It entrains the body to a universal resting cadence."

/obj/item/matthios_canister/goodnite/freeman_progress(mob/user)
	var/remaining = max_ingredients - inserted_ingredients.len

	if(remaining <= 0)
		return "The mixture has reached perfect stillness."

	return "It requires further refinement with any powdered drugs (such as ozium), bonemeal, manabloom dust or whole menthas. ([remaining] infusions remaining)"

/obj/item/matthios_canister/goodnite/attackby(obj/item/I, mob/user)
	if(!HAS_TRAIT(user, TRAIT_MATTHIOS_EYES))
		to_chat(user, span_warning("The hell do I do with this? This is no alchemy!"))
		return TRUE

	var/valid = FALSE
	for(var/T in required_ingredients)
		if(istype(I, T))
			valid = TRUE
			break

	if(!valid)
		return TRUE

	if(inserted_ingredients.len >= max_ingredients)
		to_chat(user, span_warning("The vial will accept no more. It rests at perfect equilibrium."))
		return TRUE

	if(do_after(user, 1.5 SECONDS))
		inserted_ingredients += I.type

		var/color_to_use = null
		for(var/T in ingredient_colors)
			if(istype(I, T))
				color_to_use = ingredient_colors[T]
				break

		if(color_to_use)
			current_color = color_to_use

		qdel(I)
		playsound(user, pick(da_bubbles), 30, FALSE)

		var/list/absorb_flavor = list(
			"The mixture receives [I], its form dissolving into a calm, pale suspension...",
			"[I] softens and unravels, drawn quietly into the resting fluid...",
			"A faint stillness follows as [I] is reduced and folded into the mixture...",
			"[I] loses all distinction, rendered into a smooth, somnolent draught...",
			"The vial clouds gently as [I] is broken down and made one with it..."
		)

		to_chat(user, span_notice(pick(absorb_flavor)))

		update_icon()
		check_completion(user)

	return TRUE

/obj/item/matthios_canister/goodnite/check_completion(mob/user)
	if(inserted_ingredients.len < max_ingredients)
		return

	alch_transform(user)

/obj/item/matthios_canister/goodnite/alch_transform(mob/user)
	to_chat(user, span_notice("The mixture settles into a perfectly still, somnolent state."))
	new /obj/item/alchserum/matthios_goodnite(get_turf(src))
	funny_smoke(src)
	qdel(src)

/obj/item/alchserum/matthios_insight
	name = "vial of firstlaw extract"
	desc = "A soft-glowing concoction that hums with unbearable clarity. The liquid remains perfectly still, as if reality itself fears to disturb it. Those who glimpse too deeply may come to understand more than they were meant to."
	icon = 'icons/obj/structures/heart_items.dmi'
	icon_state = "canister_empty"
	current_color = "#ff00b3"
	aura_color = "#1100ff"
	w_class = WEIGHT_CLASS_TINY

/obj/item/alchserum/matthios_insight/attack(mob/living/carbon/human/target, mob/user)
	if(!istype(target))
		return

	if(target == user)
		to_chat(user, span_notice("You begin administering the vial to [target.name]'s forehead..."))	
	else
		to_chat(user, span_notice("You begin administering the vial to your own forehead..."))

	if(do_after(user, 6 SECONDS, target))
		apply_firstlaw_insight(target, user)

/obj/item/alchserum/matthios_insight/proc/apply_firstlaw_insight(mob/living/carbon/human/T, mob/user)
	if(T.get_skill_level(/datum/skill/craft/alchemy) <= 0)
		T.adjust_skillrank_up_to(/datum/skill/craft/alchemy, SKILL_LEVEL_NOVICE, TRUE)
		to_chat(T, span_notice("For a fleeting moment, the principles of transmutation become clear. You have become more proficient in Alchemy!"))
	else
		to_chat(T, span_notice("For a fleeting moment, the principles of transmutation become clear... But you soon realize those are just the basics!"))

	qdel(src)
	playsound(T.loc,'sound/misc/smelter_sound.ogg', 50, FALSE)
	sleep(30)
	to_chat(T, span_artery("<i>...Huh?</i>"))
	sleep(30)
	to_chat(T, span_danger("--The Law's purest essence reveals itself. In nature, nothing is given, nothing is lost. Everything is transformed."))
	T.Knockdown(30)
	T.adjustBruteLoss(125)
	T.adjustFireLoss(150)
	explosion(get_turf(T), light_impact_range = 1, flame_range = 2, smoke = FALSE, adminlog = FALSE)

/obj/item/alchserum/matthios_goodnite
	name = "vial of goodnite"
	desc = "A soft-glowing concoction that induces immediate, restorative sleep. The fluid rests in perfect stillness, undisturbed by motion or time. Gazing into it too long draws a creeping heaviness into the body, as if the world itself is gently insisting you lie down and surrender to rest."
	icon = 'icons/obj/structures/heart_items.dmi'
	icon_state = "canister_empty"
	current_color = "#5c6fb2"
	aura_color = "#5e53ff"
	w_class = WEIGHT_CLASS_TINY

/obj/item/alchserum/matthios_goodnite/attack(mob/living/target, mob/user)
	if(!istype(target))
		return

	to_chat(user, span_notice("You begin gently administering the concoction to [target.name]'s eyes..."))

	if(do_after(user, 6 SECONDS, target))
		apply_sleep(target, user)

/obj/item/alchserum/matthios_goodnite/proc/apply_sleep(mob/living/target, mob/user)
	if(!target)
		return

	if(HAS_TRAIT(target, TRAIT_NOSLEEP))
		to_chat(user, span_warning("[target.name] resists the effects entirely."))
		return

	to_chat(target, span_notice("A heavy calm overtakes your body..."))
	sleep(5)
	visible_message(span_notice("[target.name] suddenly goes limp, overtaken by unnatural sleep."))

	target.SetSleeping(600)
	target.SetUnconscious(0)
	target.stat = UNCONSCIOUS

	spawn()
		while(target && target.IsSleeping())
			target.energy_add(20)
			target.adjustBruteLoss(2)

			if(target.nutrition > 0)
				target.adjustBruteLoss(-1)
				target.adjustFireLoss(-1)

			if(target.hydration > 0)
				target.adjustOxyLoss(-2)
				target.adjustToxLoss(-1)

			sleep(20)

	to_chat(user, span_notice("The vial dulls and crumbles away."))
	playsound(user.loc,'sound/misc/smelter_sound.ogg', 50, FALSE)
	qdel(src)

/obj/item/matthios_canister/warsmith
	name = "vial of warsmith base"
	desc = "A biting liquor gnaws within the vial, as though it would eat iron itself. Flecks of metal drift and vanish, then return as if unmade and remade. It reeks of rust and sharp ruin. No forge would suffer this thing near its works."

	var/needed_scrap = 3
	var/current_scrap = 0
	var/has_needle = FALSE
	var/current_fibers = 0
	var/needed_fibers = 6

	required_ingredients = list(
		/obj/item/needle,
		/obj/item/natural/bundle/fibers,
		/obj/item/natural/fibers,
		/obj/item/scrap,
		/obj/item/rogueore/iron,
	)
	ingredient_colors = list(
		/obj/item/needle = "#c0c0c0",
		/obj/item/natural/bundle/fibers = "#1fa712",
		/obj/item/natural/fibers = "#1fa712",
		/obj/item/scrap = "#6e6e6e",
		/obj/item/rogueore/iron = "#6e6e6e",
	)

/obj/item/matthios_canister/warsmith/freeman_truth()
	return "A cunning weave of filament and will. Metal and fiber undone to their first truths, that they may be rewrought aright. It does not destroy— it remembers the shape of perfection, and compels all things toward it."

/obj/item/matthios_canister/warsmith/freeman_progress(mob/user)
	return "Needle: [has_needle ? "set" : "wanting"]\nFibers: [current_fibers]/[needed_fibers]\nIron scrap: [current_scrap]/[needed_scrap]"

/obj/item/matthios_canister/warsmith/attackby(obj/item/I, mob/user)
	if(!HAS_TRAIT(user, TRAIT_MATTHIOS_EYES))
		to_chat(user, span_warning("The hell do I do with this? This is no alchemy!"))
		return TRUE

	if((istype(I, /obj/item/scrap)) || (istype(I, /obj/item/rogueore/iron)))
		if(current_scrap >= needed_scrap)
			to_chat(user, span_warning("The mixture refuses more metal."))
			return TRUE

		if(do_after(user, 2 SECONDS))
			if(current_scrap >= needed_scrap)
				return TRUE

			current_scrap = min(current_scrap + 1, needed_scrap)
			playsound(user.loc,'sound/misc/smelter_sound.ogg', 50, FALSE)
			qdel(I)

			var/color_to_use = ingredient_colors[/obj/item/scrap]
			if(color_to_use)
				current_color = color_to_use

			to_chat(user, span_notice("You feed scrap into the mixture. ([current_scrap]/[needed_scrap])"))
			update_icon()
			check_completion(user)
		return TRUE

	if(istype(I, /obj/item/needle))
		if(has_needle)
			to_chat(user, span_warning("A needle has already been integrated."))
			return TRUE

		if(do_after(user, 2 SECONDS))
			if(has_needle)
				return TRUE

			has_needle = TRUE
			playsound(user.loc,'sound/misc/smelter_sound.ogg', 50, FALSE)
			qdel(I)

			var/color_to_use = ingredient_colors[/obj/item/needle]
			if(color_to_use)
				current_color = color_to_use

			to_chat(user, span_notice("The needle dissolves into fine metallic thread."))
			update_icon()
			check_completion(user)
		return TRUE

	if(istype(I, /obj/item/natural/bundle/fibers))
		if(current_fibers >= needed_fibers)
			to_chat(user, span_warning("The mixture will take no more fiber."))
			return TRUE

		var/obj/item/natural/bundle/fibers/B = I
		var/amount = B.amount
		var/space_left = needed_fibers - current_fibers
		var/to_transfer = min(amount, space_left)

		if(to_transfer <= 0)
			return TRUE

		if(do_after(user, 2 SECONDS))
			space_left = needed_fibers - current_fibers
			to_transfer = min(amount, space_left)
			if(to_transfer <= 0)
				return TRUE

			current_fibers = min(current_fibers + to_transfer, needed_fibers)

			if(to_transfer >= amount)
				qdel(B)
			else
				B.amount -= to_transfer
				B.update_icon()

			var/color_to_use = ingredient_colors[/obj/item/natural/bundle/fibers/full]
			if(color_to_use)
				current_color = color_to_use

			to_chat(user, span_notice("You feed [to_transfer] measure\s of fiber into the mixture. ([current_fibers]/[needed_fibers])"))
			playsound(user.loc,'sound/misc/smelter_sound.ogg', 50, FALSE)
			update_icon()
			check_completion(user)

		return TRUE

	if(istype(I, /obj/item/natural/fibers))
		if(current_fibers >= needed_fibers)
			to_chat(user, span_warning("The mixture will take no more fiber."))
			return TRUE

		if(do_after(user, 2 SECONDS))
			if(current_fibers >= needed_fibers)
				return TRUE

			current_fibers = min(current_fibers + 1, needed_fibers)
			qdel(I)

			var/color_to_use = ingredient_colors[/obj/item/natural/bundle/fibers/full]
			if(color_to_use)
				current_color = color_to_use

			to_chat(user, span_notice("The fiber is reduced and drawn into the mixture. ([current_fibers]/[needed_fibers])"))
			playsound(user.loc,'sound/misc/smelter_sound.ogg', 50, FALSE)
			update_icon()
			check_completion(user)

		return TRUE

	to_chat(user, span_warning("This does not belong in the canister."))
	return TRUE

/obj/item/matthios_canister/warsmith/check_completion(mob/user)
	if(current_scrap < needed_scrap)
		return
	if(!has_needle)
		return
	if(current_fibers < needed_fibers)
		return

	alch_transform(user)

/obj/item/matthios_canister/warsmith/alch_transform(mob/user)
	to_chat(user, span_notice("The mixture hardens, then liquefies into an amorphous, perfect balance of fiber and steel."))
	new /obj/item/alchserum/matthios_warsmith(get_turf(src))
	funny_smoke(src)
	qdel(src)

/obj/item/alchserum/matthios_warsmith
	name = "vial of warsmith"
	desc = "A volatile fusion of textile and metal-binding alchemy. Filaments of steel and fiber drift within the mixture, weaving and unweaving themselves in restless patterns. It hums faintly when held, as if anticipating fracture— and the satisfaction of making something whole again."
	icon = 'icons/obj/structures/heart_items.dmi'
	icon_state = "canister_empty"
	current_color = "#9c7b45"
	aura_color = "#ffe4b9"
	w_class = WEIGHT_CLASS_TINY
	var/uses = 4

/obj/item/alchserum/matthios_warsmith/attack_obj(obj/O, mob/living/user)
	if(!isitem(O))
		return
	var/obj/item/I = O
	if(!I.max_integrity)
		to_chat(user, span_warning("This cannot be repaired."))
		return
	if(I.obj_integrity >= I.max_integrity)
		to_chat(user, span_warning("This is not broken."))
		return
	to_chat(user, span_notice("You begin applying the warsmith mixture to [I]..."))
	if(!do_after(user, 6 SECONDS, target = I))
		return
	playsound(loc, 'sound/magic/swap.ogg', 100, TRUE, -2)
	user.visible_message(span_info("[user] restores [I] with alchemical precision."))
	if(I.body_parts_covered != I.body_parts_covered_dynamic)
		I.repair_coverage()
	I.obj_integrity = I.max_integrity
	if(I.obj_broken)
		I.obj_fix()
	uses--
	if(uses > 0)
		to_chat(user, span_notice("The mixture settles, awkwardly. You estimate [uses] uses remain."))
	else
		to_chat(user, span_warning("The vial burns out, its contents fully spent."))
		playsound(user.loc,'sound/misc/smelter_sound.ogg', 50, FALSE)
		qdel(src)

/obj/item/matthios_canister/kingswine
	name = "vial of kingswine base"
	desc = "A foul slurry churns within the glass, thick with rot and sugared decay. It smells of spoiled fruit left in gutters and something far worse beneath it... coppery, clinging, wrong. No proper alchemist would name this craft; it is theft of nature."
	var/needed_liquid = 10
	var/current_liquid = 0
	var/path = null

	required_ingredients = list(
		/obj/item/reagent_containers/glass,
		/obj/item/organ,
		/obj/item/alch/viscera,
		/obj/item/reagent_containers/food/snacks/grown/fruit,
	)
	ingredient_colors = list(
		/obj/item/reagent_containers/glass = "#9c6262",
		/obj/item/organ = "#5c0a0a",
		/obj/item/alch/viscera = "#971616",
		/obj/item/reagent_containers/food/snacks/grown/fruit = "#9c3b1f",
	)

/obj/item/matthios_canister/kingswine/freeman_truth()
	if(path == "blood")
		return "The path of Kingsblood is set. The vial now craves richer, vital inputs such as blood, viscera, even organs... refining them into a draught of a potent coagulant, or darker indulgence for the ashen ones."
	else if(path == "wine")
		return "A true miracle of Malchemy! Like the old tale of 'water to wine', this stands as proof that where miracles or alchemy begin, Malchem Arts had already long, long walked."
	else
		return "A simple base, eager to take on character. It accepts liquids, fruits, anything with juice… though, one notes, blood is a liquid as well."


/obj/item/matthios_canister/kingswine/freeman_progress(mob/user)
	return "Progress: [current_liquid]/[needed_liquid]\nPath: [path ? uppertext(path) : "UNFORMED"]"

/obj/item/matthios_canister/kingswine/attackby(obj/item/I, mob/user)
	var/miracle = user.get_skill_level(/datum/skill/magic/holy)
	var/can_blood = (miracle >= SKILL_LEVEL_JOURNEYMAN)

	if(current_liquid >= needed_liquid)
		to_chat(user, span_warning("The mixture will take no more."))
		return TRUE

	if(!HAS_TRAIT(user, TRAIT_MATTHIOS_EYES))
		to_chat(user, span_warning("The hell do I do with this? This is no alchemy!"))
		return TRUE

	if(istype(I, /obj/item/organ) || istype(I, /obj/item/alch/viscera))
		if(path && path != "blood")
			to_chat(user, span_warning("The mixture rejects this. It has already chosen sweetness over blood."))
			return TRUE

		if(!can_blood)
			to_chat(user, span_warning("I lack the divine insight to work with this. It'll only ruin the tincture if I try."))
			return TRUE

		if(do_after(user, 2 SECONDS))
			path = "blood"
			current_liquid = min(current_liquid + 1, needed_liquid)

			qdel(I)
			current_color = "#5c0a0a"
			playsound(user.loc,'sound/misc/lava_death.ogg', 50, FALSE)
			to_chat(user, span_warning("The meaty component dissolves into a thick slurry. ([current_liquid]/[needed_liquid])"))
			update_icon()
			check_completion(user)
		return TRUE

	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit))
		if(path && path != "wine")
			to_chat(user, span_warning("The mixture curdles. It refuses sweetness now."))
			return TRUE

		if(do_after(user, 2 SECONDS))
			path = "wine"
			current_liquid = min(current_liquid + 1, needed_liquid)

			qdel(I)
			current_color = "#9c3b1f"
			playsound(user, pick(da_bubbles), 30, FALSE)
			to_chat(user, span_notice("The mixture ferments the offering. ([current_liquid]/[needed_liquid])"))
			update_icon()
			check_completion(user)
		return TRUE

	if(istype(I, /obj/item/reagent_containers/glass))
		var/obj/item/reagent_containers/glass/R = I

		if(!R.reagents || !R.reagents.total_volume)
			to_chat(user, span_warning("It holds nothing to extract."))
			return TRUE

		var/has_blood = FALSE
		for(var/datum/reagent/rg in R.reagents.reagent_list)
			if(rg.name in list("Blood", "Dirty blood", "Liquid gibs"))
				has_blood = TRUE
				break

		if(has_blood && !can_blood)
			to_chat(user, span_warning("I lack the divine insight to work with this. It'll only ruin the tincture if I try."))
			return TRUE

		if(path == "wine" && has_blood)
			to_chat(user, span_warning("The mixture recoils from blood."))
			return TRUE

		if(path == "blood" && !has_blood)
			to_chat(user, span_warning("It demands only blood now."))
			return TRUE

		var/amount = min(20, R.reagents.total_volume)
		
		if(do_after(user, 2 SECONDS))
			if(has_blood)
				path = "blood"
				current_color = "#5c0a0a"
			else
				path = "wine"
				current_color = "#7a1f1f"

			R.reagents.remove_any(amount)

			var/stacks = clamp(round(amount / 10), 1, 2)
			current_liquid = min(current_liquid + stacks, needed_liquid)

			to_chat(user, span_notice("The mixture siphons [amount] doses of liquid. ([current_liquid]/[needed_liquid])"))

			update_icon()
			check_completion(user)

		return TRUE

	to_chat(user, span_warning("This does not belong in the canister."))
	return TRUE

/obj/item/matthios_canister/kingswine/attack(atom/target, mob/user)
	var/miracle = user.get_skill_level(/datum/skill/magic/holy)
	var/can_blood = (miracle >= SKILL_LEVEL_JOURNEYMAN)

	if(current_liquid >= needed_liquid)
		to_chat(user, span_warning("The mixture is already complete."))
		return TRUE

	if(!HAS_TRAIT(user, TRAIT_MATTHIOS_EYES))
		to_chat(user, span_warning("The hell do I do with this? This is no alchemy!"))
		return TRUE

	if(ishuman(target))
		var/mob/living/carbon/human/H = target

		if(path && path != "blood")
			to_chat(user, span_warning("The mixture refuses flesh now."))
			return TRUE

		if(!can_blood)
			to_chat(user, span_warning("I lack the divine insight to work with this. It'll only ruin the tincture if I try."))
			return TRUE

		if(!H.get_bleed_rate())
			to_chat(user, span_warning("There is no blood to take."))
			return TRUE

		if(H.mind.has_antag_datum((/datum/antagonist/vampire)||(/datum/antagonist/skeleton)||(/datum/antagonist/zombie)||(/datum/antagonist/zizo_knight)||(/datum/antagonist/werewolf)||(/datum/antagonist/gnoll)))
			to_chat(user, span_warning("Not your finest choice of blood for this. It won't work, even by the impossible Malchemical standards."))
			return TRUE

		if(do_after(user, 2 SECONDS, target = H))
			path = "blood"
			current_liquid = min(current_liquid + 1, needed_liquid)
			current_color = "#5c0a0a"

			to_chat(user, span_warning("The mixture drinks from the wound. ([current_liquid]/[needed_liquid])"))

			if(user == H)
				H.visible_message(span_danger("[user] presses a vial at their open wound, filling it a bit."))
			else
				H.visible_message(span_danger("[user] presses a vial at [H]'s open wound, filling it a bit."))

			var/drain_amt = round(BLOOD_VOLUME_NORMAL * 0.05)
			H.blood_volume -= drain_amt

			update_icon()
			check_completion(user)

		return TRUE

	return ..()

/obj/item/matthios_canister/kingswine/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(!proximity_flag)
		return

	var/miracle = user.get_skill_level(/datum/skill/magic/holy)
	var/can_blood = (miracle >= SKILL_LEVEL_JOURNEYMAN)

	if(current_liquid >= needed_liquid)
		to_chat(user, span_warning("The mixture is already complete."))
		return

	if(!HAS_TRAIT(user, TRAIT_MATTHIOS_EYES))
		to_chat(user, span_warning("The hell do I do with this? This is no alchemy!"))
		return

	if(isturf(target))
		var/turf/T = target
		var/is_blood_water = istype(T, /turf/open/water/bloody)
		var/is_water = (istype(T, /turf/open/water/river) || istype(T, /turf/open/water/cleanshallow) || istype(T, /turf/open/water/pond) || istype(T, /turf/open/water/ocean) || istype(T, /turf/open/water/ocean/deep) || istype(T, /turf/open/water/swamp) || istype(T, /turf/open/water/swamp/deep))

		if(is_blood_water)
			if(path && path != "blood")
				to_chat(user, span_warning("The mixture recoils... This is not the path it chose."))
				return

			if(!can_blood)
				to_chat(user, span_warning("I lack the divine insight to work with this. It'll only ruin the tincture if I try."))
				return

			path = "blood"
			current_liquid = needed_liquid
			current_color = "#5c0a0a"

			to_chat(user, span_warning("The mixture greedily devours the blood water."))
			user.visible_message(span_danger("[user] dips a vial into [T], and it greedily fills."))

			update_icon()
			check_completion(user)
			return

		if(is_water)
			if(path && path != "wine")
				to_chat(user, span_warning("The mixture rejects the water, already tainted by blood."))
				return

			path = "wine"
			current_liquid = needed_liquid
			current_color = "#7a2f1b"

			to_chat(user, span_notice("The mixture eagerly drinks from the boundless waters."))
			user.visible_message(span_notice("[user] dips a vial into [T], and it greedily fills."))

			update_icon()
			check_completion(user)
			return

/obj/item/matthios_canister/kingswine/check_completion(mob/user)
	if(current_liquid < needed_liquid)
		return

	if(!path)
		return

	if(path == "wine")
		result_path = /obj/item/reagent_containers/glass/bottle/rogue/wine

	else if(path == "blood")
		result_path = /obj/item/alchserum/matthios_kingsblood

	alch_transform(user)

/obj/item/alchserum/matthios_kingsblood
	name = "vial of kingsblood"
	desc = "A dense, crimson tincture swirls within the glass, thick with vitality. It hums faintly with promise— a potent restorative said to replenish lost blood with unnatural efficiency. Though crude in origin, its effect is undeniable: where life has thinned, it forces it back in."
	icon = 'icons/obj/structures/heart_items.dmi'
	icon_state = "canister_empty"
	current_color = "#ff0000"
	aura_color = "#8a0f0f"
	w_class = WEIGHT_CLASS_TINY
	var/uses = 4

/obj/item/alchserum/matthios_kingsblood/examine(mob/user)
	. = ..()

	if(user?.mind?.has_antag_datum(/datum/antagonist/vampire) || HAS_TRAIT(user, TRAIT_PALLID) || HAS_TRAIT(user, TRAIT_ORGAN_EATER))
		. += span_warning("TIP: You could drink this instead of applying it. Aim for your mouth and use it on yourself.")

/obj/item/alchserum/matthios_kingsblood/attack(mob/living/carbon/human/target, mob/living/user)
	if(!istype(target))
		return ..()

	var/is_vampire = target.mind?.has_antag_datum(/datum/antagonist/vampire)
	var/is_blood_drinker = is_vampire || HAS_TRAIT(target, TRAIT_PALLID) || HAS_TRAIT(target, TRAIT_ORGAN_EATER)

	if(target == user && user.zone_selected == BODY_ZONE_PRECISE_MOUTH && is_blood_drinker)
		if(do_after(user, 2 SECONDS, target = target))
			if(is_vampire)
				to_chat(target, span_notice("It tastes like very old wine... Rich, deep, and impossibly satisfying~"))
				target.bloodpool += 75
				target.apply_status_effect(/datum/status_effect/buff/vitae)
			else
				to_chat(target, span_notice("It tastes like old wine... Strange, but not entirely unpleasant."))

			target.visible_message(span_notice("[target] drinks from [src]."))

			for(var/datum/wound/W as anything in target.get_wounds())
				if(W && W.bleed_rate > 0)
					W.set_bleed_rate(0)

			playsound(user, 'sound/misc/drink_blood.ogg', 100)
			uses--
	else
		if(do_after(user, 2 SECONDS, target = target))

			if(!target.get_bleed_rate())
				to_chat(user, span_warning("[target] is not bleeding. The tincture finds nothing to mend."))
				return TRUE

			target.visible_message(
				span_notice("[user] applies [src] to [target]'s wounds."),
				span_notice("The tincture seeps into the flesh, cold and invasive...")
			)

			for(var/datum/wound/W as anything in target.get_wounds())
				if(W && W.bleed_rate > 0)
					W.set_bleed_rate(0)

			var/heal_amt = round(BLOOD_VOLUME_NORMAL * 0.2)
			target.blood_volume = min(target.blood_volume + heal_amt, BLOOD_VOLUME_NORMAL)

			to_chat(target, span_warning("Something sloshes around your wounds, forcing them to coagulate. The bleeding stops."))
			uses--

	if(uses > 0)
		to_chat(user, span_notice("The tincture settles uneasily. You estimate [uses] uses remain."))
	else
		to_chat(user, span_warning("The vial empties, its contents spent."))
		playsound(user.loc,'sound/misc/smelter_sound.ogg', 50, FALSE)
		qdel(src)

	return TRUE
/*
/obj/item/matthios_canister/truthsnuke
	name = "gilded bomb canister"
	desc = "A sealed vessel packed with gray ruin and glimmering excess. Ash churns endlessly within, swallowing light, while a single mote of gold refuses to be consumed. It does not yearn for the Crown— it rejects it. Matthios once stole Astrata's fire not to kneel, but to prove no throne was sacred. This vessel follows that truth, straining to break authority itself."
	icon_state = "impact_grenade"
	icon = 'icons/roguetown/items/misc.dmi'
	aura_color = "#ffee01"

	var/needed_ash = 200
	var/current_ash = 0

	var/needed_coaldust = 100
	var/current_coaldust = 0

	var/needed_fire = 50
	var/current_fire = 0

	var/has_crown = FALSE
	var/has_flower = FALSE

	required_ingredients = list(
		/obj/item/ash,
		/obj/item/alch/coaldust,
		/obj/item/alch/firedust,
		/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius,
		/obj/item/clothing/head/roguetown/crown/serpcrown
	)

	ingredient_colors = list(
		/obj/item/ash = "#4a4a4a",
		/obj/item/alch/coaldust = "#2b2b2b",
		/obj/item/alch/firedust = "#ff4500",
		/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius = "#ffae42",
		/obj/item/clothing/head/roguetown/crown/serpcrown = "#ffd700"
	)

/obj/item/matthios_canister/truthsnuke/freeman_truth()
	if(has_crown)
		return "You did it. You stole her fire, just as He once did. Not begged, not granted. Taken. Hopefully. Let the crowns of this world tremble, for they were always a lie. A king is only a man who has not yet been defied."
	else if(has_flower)
		return "Fire is fire, no matter how it is kindled. Even a lie can burn. Still… you feel it, don't you? This is not the same. A shadow of the act. Perhaps next time, you take the real thing."
	else
		return "Matthios did not ask. He did not kneel. He reached into the heavens and took what was denied, and in doing so proved the truth: no throne is sacred, no ruler chosen. Power belongs to those who seize it. This work follows that path, but it is not yet complete."

/obj/item/matthios_canister/truthsnuke/freeman_progress(mob/user)
	return "Ash: [current_ash]/[needed_ash]\nCoal Dust: [current_coaldust]/[needed_coaldust]\nFire Essentia: [current_fire]/[needed_fire]\nAstrata's Ultimate Authority: [has_crown ? "present" : "missing"]\nFyritius Replacement: [has_flower ? "present" : "missing"]"

/obj/item/matthios_canister/truthsnuke/attackby(obj/item/I, mob/user)
	if(!HAS_TRAIT(user, TRAIT_MATTHIOS_EYES))
		to_chat(user, span_warning("You can't begin to think where to start with this... insanity."))
		return TRUE

	if(istype(I, /obj/item/ash))
		if(current_ash >= needed_ash)
			to_chat(user, span_warning("The vessel can hold no more ruin."))
			return TRUE

		if(do_after(user, 1 SECONDS))
			current_ash++
			qdel(I)
			current_color = ingredient_colors[/obj/item/ash]

			to_chat(user, span_notice("The ash is swallowed. ([current_ash]/[needed_ash])"))
			playsound(user, pick(da_bubbles), 30, FALSE)

			update_icon()
			check_completion(user)
		return TRUE

	if(istype(I, /obj/item/alch/coaldust))
		if(current_coaldust >= needed_coaldust)
			to_chat(user, span_warning("No more foundation can be laid."))
			return TRUE

		if(do_after(user, 1 SECONDS))
			current_coaldust++
			qdel(I)
			current_color = ingredient_colors[/obj/item/alch/coaldust]

			to_chat(user, span_notice("The dust settles into the mass. ([current_coaldust]/[needed_coaldust])"))
			update_icon()
			check_completion(user)
		return TRUE

	if(istype(I, /obj/item/alch/firedust))
		if(current_fire >= needed_fire)
			to_chat(user, span_warning("The essence within can grow no hotter."))
			return TRUE

		if(do_after(user, 1 SECONDS))
			current_fire++
			qdel(I)
			current_color = ingredient_colors[/obj/item/alch/firedust]

			to_chat(user, span_notice("The essence feeds the core. ([current_fire]/[needed_fire])"))
			update_icon()
			check_completion(user)
		return TRUE

	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/rogue/fyritius))
		if(has_flower)
			to_chat(user, span_warning("The vessel already bears a fire within."))
			return TRUE

		if(has_crown)
			to_chat(user, span_warning("Why settle for a dream, when you already have the real deal?"))
			return TRUE

		if(do_after(user, 2 SECONDS))
			has_flower = TRUE
			qdel(I)
			current_color = ingredient_colors[/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius]

			to_chat(user, span_warning("The flower wilts… yet something answers. A lie, accepted."))
			update_icon()
			check_completion(user)
		return TRUE

	if(istype(I, /obj/item/clothing/head/roguetown/crown/serpcrown))
		if(has_crown)
			to_chat(user, span_warning("The vessel already bears true authority. But how can this be?"))
			return TRUE

		if(has_flower)
			to_chat(user, span_warning("The false fire burns away as if to make way for the real deal."))
			has_flower = FALSE

		if(do_after(user, 2 SECONDS))
			has_crown = TRUE
			qdel(I)
			current_color = ingredient_colors[/obj/item/clothing/head/roguetown/crown/serpcrown]

			to_chat(user, span_notice("The Crown resists… and soon submits. The fire of Astrata is stolen once more. You feel HIS smile upon you."))
			playsound(user, 'sound/misc/lava_death.ogg', 30, FALSE)

			update_icon()
			check_completion(user)
		return TRUE

	return TRUE

/obj/item/matthios_canister/truthsnuke/check_completion(mob/user)
	if(current_ash < needed_ash)
		return
	if(current_coaldust < needed_coaldust)
		return
	if(current_fire < needed_fire)
		return

	if(!has_crown && !has_flower)
		return

	alch_transform(user)

/obj/item/matthios_canister/truthsnuke/alch_transform(mob/user)
	to_chat(user, span_notice("The mixture collapses inward… then stabilizes."))

	if(has_crown)
		new /obj/item/impact_grenade/truthsnuke(get_turf(src))
	else
		new /obj/item/impact_grenade/truthsnuke/lesser(get_turf(src))
	funny_smoke(src)
	qdel(src)
*/

//EQUIPPABLES
/obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gilded
	name = "strange gilded amulet"
	desc = "He was ever the one to make you ask questions: Why are we still here? Just to suffer? Nae. We are here to make a change. And a change we shall make, together."
	icon_state = "matthios"
	resistance_flags = FIRE_PROOF
	slot_flags = ITEM_SLOT_NECK
	smeltresult = /obj/item/ash
	var/grant_chant = FALSE
	aura_color = "#ffe761"

/obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gilded/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(obj_broken)
		return
	if(slot == (SLOT_NECK||SLOT_RING) && HAS_TRAIT(user, TRAIT_FREEMAN))
		if(!user.has_language(/datum/language/thievescant))
			to_chat(user, span_info("You gain insight on Thieves' Cant.<br><br><i>Keep in mind these are 'words' that come out as gestures, so blend it between normal speech to make it not so obvious.</i>"))
			user.grant_language(/datum/language/thievescant)
			grant_chant = TRUE
		else
			to_chat(user, span_info("You already know Thieves' Cant, but praise be Matthios."))

/obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gilded/dropped(mob/living/carbon/human/user)
	. = ..()
	if(istype(user) && user.get_item_by_slot((SLOT_NECK||SLOT_RING)) == src)
		if(grant_chant)
			to_chat(user, span_info("The knowledge fades from my mind."))
			user.remove_language(/datum/language/thievescant)
			grant_chant = FALSE

/obj/item/clothing/gloves/roguetown/fingerless_leather/muffle_matthios
	name = "gilded fingerless gloves"
	desc = "Those who grasp at Fyre, are bount to be burned."
	sewrepair = TRUE
	armor = ARMOR_LEATHER
	color = "#fce517" // we golden
	aura_color = "#fff385"

/obj/item/clothing/gloves/roguetown/fingerless_leather/muffle_matthios/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(obj_broken)
		return
	if(slot == SLOT_GLOVES && HAS_TRAIT(user, TRAIT_FREEMAN))
		to_chat(user, span_info("Like Him, my hands ready to grasp the impossible."))
		ADD_TRAIT(user, TRAIT_SILENT_LOCKPICK, "matthiosboon")

/obj/item/clothing/gloves/roguetown/fingerless_leather/muffle_matthios/dropped(mob/living/carbon/human/user)
	. = ..()
	if(istype(user) && user.get_item_by_slot(SLOT_GLOVES) == src)
		to_chat(user, span_info("Once again, these hands are supplicant."))
		REMOVE_TRAIT(user, TRAIT_SILENT_LOCKPICK, "matthiosboon")

/obj/item/clothing/mask/rogue/spectacles/matthios
	name = "gilded spectacles"
	desc = "A drakkyne's eyes are oft blindsided by greed, yet such vision does hold some merit."
	armor = ARMOR_LEATHER
	color = "#faf5cb" // we golden
	aura_color = "#fffb00"

/obj/item/clothing/mask/rogue/spectacles/matthios/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(obj_broken)
		return
	if(slot == SLOT_WEAR_MASK)
		if(HAS_TRAIT(user, TRAIT_FREEMAN))
			if(!user.has_status_effect(/datum/status_effect/buff/matthios_vision))
				to_chat(user, span_info("Gold gleams where truth once hid."))
				user.apply_status_effect(/datum/status_effect/buff/matthios_vision)
		else
			to_chat(user, span_warning("You look ridiculous and stupid. You are an amateur and a fool!"))

/obj/item/clothing/mask/rogue/spectacles/matthios/dropped(mob/living/carbon/human/user)
	. = ..()
	if(istype(user) && user.get_item_by_slot(SLOT_WEAR_MASK) == src)
		to_chat(user, span_info("The gleam fades from my sight."))
		user.remove_status_effect(/datum/status_effect/buff/matthios_vision)

/atom/movable/screen/alert/status_effect/buff/matthios_vision
	name = "Gilded True Sight"
	desc = "Through Him, all is seen, and no locks shall bar me. Whether that it should be... is another matter."
	icon_state = "darkvision"

/datum/status_effect/buff/matthios_vision
	id = "matthios_vision"
	alert_type = /atom/movable/screen/alert/status_effect/buff/matthios_vision
	duration = -1
	tick_interval = 15 SECONDS

/datum/status_effect/buff/matthios_vision/on_apply(mob/living/new_owner)
	. = ..()
	to_chat(owner, span_warning("The world sharpens. Nothing hides from His gaze, now yours."))
	ADD_TRAIT(owner, TRAIT_GILDED_SIGHT, "matthiosboon")
	ADD_TRAIT(owner, TRAIT_PSYCHOSIS, "matthiosboon")
	owner.update_sight()

/datum/status_effect/buff/matthios_vision/on_remove()
	. = ..()
	to_chat(owner, span_warning("The truth fades. Darkness returns, but so does peace."))
	REMOVE_TRAIT(owner, TRAIT_GILDED_SIGHT, "matthiosboon")
	REMOVE_TRAIT(owner, TRAIT_PSYCHOSIS, "matthiosboon")
	owner.update_sight()

/datum/status_effect/buff/matthios_vision/tick()
	. = ..()
	var/mob/living/carbon/crazymofo = owner
	var/pickLV = crazymofo.get_skill_level(/datum/skill/misc/lockpicking)
	var/miracleLV = crazymofo.get_skill_level(/datum/skill/magic/holy)
	var/hallucAMT = 62 - (miracleLV * 10)
	if(miracleLV <= SKILL_LEVEL_JOURNEYMAN || pickLV <= SKILL_LEVEL_JOURNEYMAN)
		if(prob(hallucAMT))
			crazymofo.adjustFireLoss(5)
		if(prob(hallucAMT))
			crazymofo.adjustFireLoss(10)
		if(prob(hallucAMT))
			crazymofo.adjustFireLoss(5)
		if(prob(hallucAMT))
			crazymofo.adjustFireLoss(5)
	if(crazymofo.hallucination < 200)
		crazymofo.hallucination += rand(1,hallucAMT)
		to_chat(crazymofo, span_warning(pick("Is this TRVE??","DAFUQ?","I am NOT meant to see this.","What... WHAT is this?","This doesn't make SENSE.","I don't UNDERSTAND.","Why does it LOOK like that?","Something is WRONG here.","I can't make SENSE of this.","This isn't RIGHT.","What am I looking at?","None of THIS adds up.","I shouldn't be SEEING this.","This feels... INCORRECT.","Why is everything like this?","I CAN'T process this.","This ISN'T how it should be.","I don't get it.","What is happening?","This is all WRONG.","I CAN'T tell what's REAL.","Why does it feel off?","I don't recognize this.","This SHOULDN'T exist.","What is THIS supposed to be?","I can't FOLLOW this.","This isn't making sense anymore.","I think SOMETHING is broke.", "Why can't I understand THIS?", "This feels IMPOSSIBLE.", "I don't KNOW what I'm seeing.")))
		crazymofo.Jitter(5)
		if(prob(10+hallucAMT))
			crazymofo.emote(pick("giggle","laugh","chuckle"))
	if(prob(10+hallucAMT) && crazymofo.hallucination > 100)
		crazymofo.blur_eyes(5)
		crazymofo.adjust_blurriness(10)
		crazymofo.blind_eyes(1.5)
		crazymofo.adjustBruteLoss(10)
		if(prob(10))
			crazymofo.emote("agony")
		to_chat(crazymofo, span_alert("MY EYES!!! THEY BURN!!!"))

/obj/item/clothing/shoes/roguetown/boots/muffle_matthios //I guess in case someone wants to make generic muffled boots? Change it to muffle/matthios if you do
	name = "gilded leather boots"
	desc = "Those who bear His fyre often cower in its shadow."
	icon_state = "matthiosboots"
	sewrepair = TRUE
	armor = ARMOR_LEATHER
	color = "#fff9c0" // we golden
	aura_color = "#ffe600"

/obj/item/clothing/shoes/roguetown/boots/muffle_matthios/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot == SLOT_SHOES && HAS_TRAIT(user, TRAIT_FREEMAN))
		to_chat(user, span_info("Like Him, I slink into the shadows."))
		ADD_TRAIT(user, TRAIT_SILENT_FOOTSTEPS, "matthiosboon")
		ADD_TRAIT(user, TRAIT_LIGHT_STEP, "matthiosboon")

/obj/item/clothing/shoes/roguetown/boots/muffle_matthios/dropped(mob/living/carbon/human/user)
	. = ..()
	if(istype(user) && user?.shoes == src)
		to_chat(user, span_info("Once again, I am under Her gaze."))
		REMOVE_TRAIT(user, TRAIT_SILENT_FOOTSTEPS, "matthiosboon")
		REMOVE_TRAIT(user, TRAIT_LIGHT_STEP, "matthiosboon")

//THROWABLES
/obj/item/impact_grenade/truthsnuke/lesser
	name = "Incomplete TRUTHSNUKE"
	desc = "A fragile canister, filled with an explosive surprise. Shards of flint line its thin sleeve, aching to ignite at the slightest disturbance. The fire of Astrata does not seem to be imbuing it, but..."

/obj/item/impact_grenade/truthsnuke/lesser/explodes()
	STOP_PROCESSING(SSfastprocess, src)

	var/turf/T = get_turf(src)
	if(!T)
		qdel(src)
		return

	for(var/mob/living/target in range(3, T))

		if(HAS_TRAIT(target, TRAIT_NOBLE) || HAS_TRAIT(target, TRAIT_CLERGY))
			target.visible_message(span_danger("[target]'s skin begins to SLOUGH AND BURN HORRIFICALLY, glowing like molten metal!"), span_userdanger("MY LIMBS BURN IN AGONY..."))
			target.Stun(80)
			target.emote("agony")
			target.adjustFireLoss(50)
			target.adjust_fire_stacks(9, /datum/status_effect/fire_handler/fire_stacks/divine)
			target.ignite_mob()
			playsound(target, 'sound/magic/churn.ogg', 100, TRUE)
			explosion(get_turf(target), light_impact_range = 1, flame_range = 1, smoke = FALSE)
			sleep(80)
			target.visible_message(span_danger("[target]'s limbs REND into coin and gem!"), span_userdanger("WEALTH. POWER. THE FINAL SIGHT UPON MYNE EYE IS A DRAGON'S MAW TEARING ME IN TWAIN. MY ENTRAILS ARE OF GOLD AND SILVER."))  		//this one's actually pretty good. i like this
			playsound(target, 'sound/magic/churn.ogg', 100, TRUE)
			playsound(target, 'sound/magic/whiteflame.ogg', 100, TRUE)
			explosion(get_turf(target), light_impact_range = 1, flame_range = 1, smoke = FALSE)
			new /obj/item/roguecoin/silver/pile(target.loc)
			new /obj/item/roguecoin/gold/pile(target.loc)
			new /obj/item/roguegem/random(target.loc)
			new /obj/item/roguegem/random(target.loc)
			var/list/possible_limbs = list()
			for(var/zone in list(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG))
				var/obj/item/bodypart/limb = target.get_bodypart(zone)
				if(limb)
					possible_limbs += limb
				var/limbs_to_gib = min(rand(1, 4), possible_limbs.len)
				for(var/i in 1 to limbs_to_gib)
					var/obj/item/bodypart/selected_limb = pick(possible_limbs)
					possible_limbs -= selected_limb
					if(selected_limb?.drop_limb())
						var/turf/limb_turf = get_turf(selected_limb) || get_turf(target) || target.drop_location()
						if(limb_turf)
							new /obj/effect/decal/cleanable/blood/gibs/limb(limb_turf)
			target.death()
			continue

		var/is_heretic = HAS_TRAIT(target, TRAIT_FREEMAN) || HAS_TRAIT(target, TRAIT_CABAL) || HAS_TRAIT(target, TRAIT_HORDE) || HAS_TRAIT(target, TRAIT_DEPRAVED)
		target.apply_status_effect(/datum/status_effect/buff/alch/fire_resist)

		if(is_heretic)
			to_chat(target, span_artery("They called us Inhumen. They called this Heresy. Yet here we stand—unbroken, unburned. Let the world choke on truth."))
			target.visible_message(span_notice("[target] stands untouched amidst the inferno."))

		else
			target.emote("agony")
			target.Stun(2)
			target.Knockdown(2)
			target.adjustFireLoss(40)
			to_chat(target, span_artery("IT BURNS! THE TRUTH! IT BURNS!!!"))

	for(var/turf/affected in range(3, T))

		for(var/obj/structure/mineral_door/D in affected)
			if(!(D.resistance_flags & INDESTRUCTIBLE))
				qdel(D)

		for(var/obj/structure/roguewindow/W in affected)
			if(!(W.resistance_flags & INDESTRUCTIBLE))
				qdel(W)
		
		for(var/obj/O in affected)
			if(!(O.resistance_flags & INDESTRUCTIBLE))
				O.visible_message(span_danger("[O] is torn apart by the blast!"))
				qdel(O)

		if(istype(affected, /turf/closed) && !istype(affected, /turf/closed/indestructible))
			var/turf/closed/C = affected
			C.ChangeTurf(/turf/open/floor/rogue/dirt)
			continue

		if(istype(affected, /turf/open) && !istype(affected, /turf/open/floor/rogue/dirt))
			var/turf/open/O = affected
			O.ChangeTurf(/turf/open/floor/rogue/dirt)


	for(var/mob/living/M in range(3, T))
		var/dir = get_dir(T, M)
		M.throw_at(get_edge_target_turf(M, dir), 6, 3)

	explosion(T, devastation_range = 0,	heavy_impact_range = 0,	light_impact_range = 4, flame_range = 8, flash_range = 8, smoke = TRUE, soundin = pick('sound/misc/explode/bottlebomb (1).ogg','sound/misc/explode/bottlebomb (2).ogg'))
	qdel(src)

//I'll leave it as an admin spawnable cause why not, but as is right now there's no way anything can get access to this.
/obj/item/impact_grenade/truthsnuke
	name = "TRUTHSNUKE"
	desc = "A fragile canister, filled with an explosive surprise. Shards of flint line its thin sleeve, aching to ignite at the slightest disturbance. It glows with a divine might, and once again stolen fire."
	aura_color = "#fbff00"

/obj/item/impact_grenade/truthsnuke/explodes()
	STOP_PROCESSING(SSfastprocess, src)

	var/turf/T = get_turf(src)
	if(!T)
		qdel(src)
		return

	for(var/mob/living/target in range(15, T))

		if(HAS_TRAIT(target, TRAIT_NOBLE) || HAS_TRAIT(target, TRAIT_CLERGY))
			target.visible_message(span_danger("[target]'s skin begins to SLOUGH AND BURN HORRIFICALLY, glowing like molten metal!"), span_userdanger("MY LIMBS BURN IN AGONY..."))
			target.Stun(80)
			target.emote("agony")
			target.adjustFireLoss(50)
			target.adjust_fire_stacks(9, /datum/status_effect/fire_handler/fire_stacks/divine)
			target.ignite_mob()
			playsound(target, 'sound/magic/churn.ogg', 100, TRUE)
			explosion(get_turf(target), light_impact_range = 1, flame_range = 1, smoke = FALSE)
			sleep(80)
			target.visible_message(span_danger("[target]'s limbs REND into coin and gem!"), span_userdanger("WEALTH. POWER. THE FINAL SIGHT UPON MYNE EYE IS A DRAGON'S MAW TEARING ME IN TWAIN. MY ENTRAILS ARE OF GOLD AND SILVER."))  		//this one's actually pretty good. i like this
			playsound(target, 'sound/magic/churn.ogg', 100, TRUE)
			playsound(target, 'sound/magic/whiteflame.ogg', 100, TRUE)
			explosion(get_turf(target), light_impact_range = 1, flame_range = 1, smoke = FALSE)
			new /obj/item/roguecoin/silver/pile(target.loc)
			new /obj/item/roguecoin/gold/pile(target.loc)
			new /obj/item/roguegem/random(target.loc)
			new /obj/item/roguegem/random(target.loc)
			var/list/possible_limbs = list()
			for(var/zone in list(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG))
				var/obj/item/bodypart/limb = target.get_bodypart(zone)
				if(limb)
					possible_limbs += limb
				var/limbs_to_gib = min(rand(1, 4), possible_limbs.len)
				for(var/i in 1 to limbs_to_gib)
					var/obj/item/bodypart/selected_limb = pick(possible_limbs)
					possible_limbs -= selected_limb
					if(selected_limb?.drop_limb())
						var/turf/limb_turf = get_turf(selected_limb) || get_turf(target) || target.drop_location()
						if(limb_turf)
							new /obj/effect/decal/cleanable/blood/gibs/limb(limb_turf)
			target.death()
			continue

		var/is_heretic = HAS_TRAIT(target, TRAIT_FREEMAN) || HAS_TRAIT(target, TRAIT_CABAL) || HAS_TRAIT(target, TRAIT_HORDE) || HAS_TRAIT(target, TRAIT_DEPRAVED)
		target.apply_status_effect(/datum/status_effect/buff/alch/fire_resist)

		if(is_heretic)
			to_chat(target, span_artery("They called us Inhumen. They called this Heresy. Yet here we stand—unbroken, unburned. Let the world choke on truth."))
			target.visible_message(span_notice("[target] stands untouched amidst the inferno."))

		else
			target.emote("agony")
			target.Stun(2)
			target.Knockdown(2)
			target.adjustFireLoss(40)
			to_chat(target, span_artery("IT BURNS! THE TRUTH! IT BURNS!!!"))

	for(var/turf/affected in range(15, T))

		for(var/obj/structure/mineral_door/D in affected)
			if(!(D.resistance_flags & INDESTRUCTIBLE))
				qdel(D)

		for(var/obj/structure/roguewindow/W in affected)
			if(!(W.resistance_flags & INDESTRUCTIBLE))
				qdel(W)
		
		for(var/obj/O in affected)
			if(!(O.resistance_flags & INDESTRUCTIBLE))
				O.visible_message(span_danger("[O] is torn apart by the blast!"))
				qdel(O)

		if(istype(affected, /turf/closed) && !istype(affected, /turf/closed/indestructible))
			var/turf/closed/C = affected
			C.ChangeTurf(/turf/open/floor/rogue/dirt)
			continue

		if(istype(affected, /turf/open) && !istype(affected, /turf/open/floor/rogue/dirt))
			var/turf/open/O = affected
			O.ChangeTurf(/turf/open/floor/rogue/dirt)


	for(var/mob/living/M in range(12, T))
		var/dir = get_dir(T, M)
		M.throw_at(get_edge_target_turf(M, dir), 6, 3)

	explosion(T, devastation_range = 0,	heavy_impact_range = 0,	light_impact_range = 10, flame_range = 15, flash_range = 15, smoke = TRUE, soundin = pick('sound/misc/explode/bottlebomb (1).ogg','sound/misc/explode/bottlebomb (2).ogg'))

	qdel(src)

/obj/item/impact_grenade/pocketsand
	name = "pocket sand"
	desc = "A fistful of fine, irritating sand. Guaranteed to be clawing at the eyes of the unwise."
	icon_state = "clod1"
	icon = 'icons/roguetown/items/natural.dmi'

/obj/item/impact_grenade/pocketsand/explodes()
	STOP_PROCESSING(SSfastprocess, src)
	var/turf/T = get_turf(src)
	if(T)
		for(var/mob/living/target in range(0, T))
			if(!target.mind || istype(target, /mob/living/simple_animal))
				target.adjustBruteLoss(5)
			if(iscarbon(target))
				target.blur_eyes(5)
				target.adjust_blurriness(10)
				target.blind_eyes(1.5)
			target.visible_message(
				span_warning("[target] is blasted with a cloud of sand!"),
				span_warning("Sand gets into my eyes! I can't see!")
			)
			target.emote("pain")
			target.apply_status_effect(/datum/status_effect/debuff/clickcd, 3 SECONDS)
		qdel(src)

//MISC

/datum/component/storage/concrete/roguetown/pouch/matthios
	screen_max_rows = 4
	screen_max_columns = 2

/obj/item/storage/belt/rogue/pouch/matthios
	aura_color = "#fff385"
	desc = "A small sack with a drawstring that allows it to be worn around the neck. Or at the hips, provided you have a belt. It has a strange, gilded glow to it."
	component_type = /datum/component/storage/concrete/roguetown/pouch/matthios

/obj/item/storage/belt/rogue/pouch/matthios/Initialize()
	. = ..()
	AddComponent(/datum/component/cursed_item, (TRAIT_FREEMAN||TRAIT_XYLIX), "BLESSED POUCH")

/obj/item/storage/backpack/rogue/backpack/matthios
	name = "smuggling bag"
	desc = "A sack tied with some 'blessed' rope. There is a carving of a grinning symbol within the side of it. It has a strange, gilded glow to it."
	aura_color = "#fff385"
	icon_state = "rucksack_untied"
	item_state = "rucksack"
	component_type = /datum/component/storage/concrete/roguetown/backpack
	max_integrity = 100

/obj/item/storage/backpack/rogue/backpack/matthios/Initialize()
	. = ..()
	AddComponent(/datum/component/cursed_item, (TRAIT_FREEMAN||TRAIT_XYLIX), "BLESSED RUCKSACK")

/obj/item/rope/chain/matthios
	name = "gilded chain"
	desc = "A heavy, gilded chain that thrums with latent divine power. It resonates negatively with the essence of nobility, as if stirred by divine rebuke."	
	color = "#fdff86"
	aura_color = "#fff385"
	matthios_chains = TRUE
	smeltresult = /obj/item/ash

/obj/item/melee/touch_attack/lesserknock/matthios
	name = "Gilded Lockpick"
	desc = "A golden, glowing lockpick that appears to be held together by the truth of Matthios. To dispel it, simply use it on anything that isn't a door."
	catchphrase = null
	possible_item_intents = list(/datum/intent/use)
	icon = 'icons/roguetown/items/keys.dmi'
	icon_state = "lockpick"
	color = "#eeff00" // we golden now, bij
	max_integrity = 20
	destroy_sound = 'sound/items/pickbreak.ogg'
	resistance_flags = FIRE_PROOF
	aura_color = "#ffe761"

/obj/item/melee/touch_attack/lesserknock/attack_self()
	qdel(src)
