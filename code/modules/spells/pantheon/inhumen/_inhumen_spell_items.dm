////////////
//MATTHIOS//
////////////

//ALCHEMY
/obj/item/
	var/aura_color = null

/obj/item/Initialize(mapload)
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

/obj/item/alchserum/Initialize(mapload)
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

GLOBAL_LIST_INIT(da_bubbles, list('sound/foley/bubb (1).ogg','sound/foley/bubb (2).ogg','sound/foley/bubb (3).ogg','sound/foley/bubb (4).ogg','sound/foley/bubb (5).ogg'))

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

/obj/item/matthios_canister/Initialize(mapload)
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
	desc = "Within the glass swells a searing draught, as though molten gold were stirred with the heartblood of a volcano."
	current_color = "#ffffff"
	result_path = /obj/item/alchserum/matthios_lyfestruth
	// ROUTE STATE
	var/route = null // "herb", "coin", "lux"
	// ROUTE 1 - HERBS
	var/list/required_herbs = list(
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
		/obj/item/alch/rosa
	)
	var/blood_uses = 0
	var/max_blood_uses = 5
	// ROUTE 2 - COIN
	var/coin_value = 0
	var/coin_target = 500
	// ROUTE 3 - LUX
	var/lux_count = 0
	var/impure_lux_count = 0
	var/lux_blood = 0

/obj/item/matthios_canister/lyfestruth/Initialize(mapload)
	. = ..()
	required_herbs = required_herbs.Copy()

/obj/item/matthios_canister/lyfestruth/freeman_progress(mob/user)
	// NO ROUTE YET
	if(!route)
		return "The draught is unstable... it may yet accept herbs, mammon, or Lux."

	// ROUTE 1 — HERBS
	if(route == "herb")
		var/herb_hint = "none"
		if(required_herbs.len)
			var/typepath = pick(required_herbs)
			var/atom/A = typepath
			herb_hint = initial(A.name)

		var/remaining_blood = max(0, max_blood_uses - blood_uses)

		return "It still lacks [herb_hint]. Blood may substitute the missing pieces. ([remaining_blood]/[max_blood_uses] sacrifices remaining)"

	// ROUTE 2 — COIN
	if(route == "coin")
		return "Mammon bound: [coin_value]/[coin_target]. The draught demands wealth made manifest."

	// ROUTE 3 — LUX
	if(route == "lux")
		if(lux_count >= 1)
			return "The purified Lux is bound. The draught stabilizes..."

		var/needed_impure = max(0, 2 - impure_lux_count)
		var/needed_blood = max(0, 5 - lux_blood)

		return "The draught writhes incomplete... [needed_impure] more impure Lux required, and [needed_blood]/5 lyfeblood or heartblood sacrifices remain."

	return "The draught resists interpretation. It may require a herb, coin or any lux..."

/obj/item/matthios_canister/lyfestruth/proc/set_route(new_route, mob/user)
	if(route && route != new_route)
		to_chat(user, span_warning("The brew resists. Its path is already set."))
		return FALSE

	if(!route)
		route = new_route

	return TRUE

/obj/item/matthios_canister/lyfestruth/check_completion(mob/user)
	// ROUTE 1
	if(route == "herb")
		if(!required_herbs.len)
			alch_transform(user)
			return TRUE
	// ROUTE 2
	if(route == "coin")
		if(coin_value >= coin_target)
			alch_transform(user)
			return TRUE
	// ROUTE 3
	if(route == "lux")
		if(lux_count >= 1)
			if(impure_lux_count)
				new /obj/item/reagent_containers/lux_impure(user.loc)
			alch_transform(user)
			return TRUE
		if(impure_lux_count >= 2 && lux_blood >= 5)
			alch_transform(user)
			return TRUE

	return FALSE

/obj/item/matthios_canister/lyfestruth/attackby(obj/item/I, mob/user)
	if(!I)
		return

	// ROUTE 1 - HERBS
	for(var/T in required_herbs)
		if(istype(I, T))
			if(!set_route("herb", user))
				to_chat(user, span_notice("This will no longer work with the draught..."))
				return
			if(!do_after(user, 1 SECONDS))
				return
			required_herbs -= T
			qdel(I)

			to_chat(user, span_notice("The herb binds into the draught. ([required_herbs.len] remaining)"))
			check_completion(user)
			return

	// ROUTE 2 - COINS
	if(istype(I, /obj/item/roguecoin))
		if(!set_route("coin", user))
			to_chat(user, span_notice("This will no longer work with the draught..."))
			return
		if(!do_after(user, 1 SECONDS))
			return
		var/obj/item/roguecoin/C = I
		var/value = C.get_real_price()
		if(value <= 0)
			return
		coin_value += value
		qdel(I)
		to_chat(user, span_notice("The mammon dissolves into the draught... ([coin_value]/[coin_target])"))
		check_completion(user)
		return

	// ROUTE 3 - LUX
	if(istype(I, /obj/item/reagent_containers/lux)||istype(I, /obj/item/reagent_containers/lux_moss))
		if(!set_route("lux", user))
			to_chat(user, span_notice("This will no longer work with the draught..."))
			return
		if(!do_after(user, 1 SECONDS))
			return
		lux_count++
		qdel(I)

		to_chat(user, span_notice("The purified Lux binds perfectly into the mixture, sizzling with a golden glow..."))
		check_completion(user)
		return

	if(istype(I, /obj/item/reagent_containers/lux_impure))
		if(!set_route("lux", user))
			to_chat(user, span_notice("This will no longer work with the draught..."))
			return
		if(!do_after(user, 1 SECONDS))
			return
		impure_lux_count++
		qdel(I)

		to_chat(user, span_notice("The impure Lux writhes within the draught. It demands more..."))
		check_completion(user)
		return

	if(istype(I, /obj/item/heart_blood_canister/filled))
		if(!set_route("lux", user))
			to_chat(user, span_notice("This will no longer work with the draught..."))
			return
		if(lux_blood <= 5)
			to_chat(user, span_notice("This is brimming with vitae, it needs no more."))
			return
		if(!do_after(user, 1 SECONDS))
			return
		lux_blood = 5
		qdel(I)

		to_chat(user, span_notice("The heartblood boils within the draught. It demands no more."))
		check_completion(user)
		return

	if(istype(I, /obj/item/heart_blood_canister/filled))
		if(!set_route("lux", user))
			to_chat(user, span_notice("This will no longer work with the draught..."))
			return
		if(lux_blood <= 5)
			to_chat(user, span_notice("This is brimming with vitae, it needs no more."))
			return
		if(!do_after(user, 1 SECONDS))
			return
		lux_blood = 5
		qdel(I)

		to_chat(user, span_notice("The heartblood boils within the draught. It demands more..."))
		check_completion(user)
		return

/obj/item/matthios_canister/lyfestruth/afterattack(atom/target, mob/user, proximity_flag, params)
	if(!proximity_flag)
		return

	if(!HAS_TRAIT(user, TRAIT_MATTHIOS_EYES))
		return

	// ROUTE 1 - HERB BLOODPRICE
	if(route == "herb" || !route)
		if(ishuman(target))
			var/mob/living/carbon/human/H = target

			if(blood_uses >= max_blood_uses)
				to_chat(user, span_warning("The draught refuses further sacrifice."))
				return

			if(!H.get_bleed_rate())
				to_chat(user, span_warning("There is no open wound to draw from."))
				return

			if(!set_route("herb", user))
				return

			if(do_after(user, 2 SECONDS, target = H))
				var/drain_amt = round(BLOOD_VOLUME_NORMAL * 0.05)
				H.blood_volume -= drain_amt

				blood_uses++

				if(required_herbs.len)
					var/chosen = pick(required_herbs)
					required_herbs -= chosen

				to_chat(user, span_warning("The draught drinks deeply... ([blood_uses]/[max_blood_uses])"))

				if(user == H)
					H.visible_message(span_danger("[user] presses the vial to their own wound, feeding it."))
				else
					H.visible_message(span_danger("[user] presses the vial to [H]'s wound, drawing blood."))

				check_completion(user)
			return

	// ROUTE 3 - IMPURE LUX BLOODPRICE
	if(route == "lux" && impure_lux_count >= 1)
		if(ishuman(target))
			var/mob/living/carbon/human/H = target

			if(lux_blood >= 5)
				to_chat(user, span_warning("The draught has taken enough."))
				return

			if(!H.get_bleed_rate())
				to_chat(user, span_warning("There is no blood to take."))
				return

			if(do_after(user, 2 SECONDS, target = H))
				var/drain_amt = round(BLOOD_VOLUME_NORMAL * 0.05)
				H.blood_volume -= drain_amt

				lux_blood++

				to_chat(user, span_warning("The impure Lux within writhes as it feeds... ([lux_blood]/5)"))

				if(user == H)
					H.visible_message(span_danger("[user] feeds their own blood into the unstable draught."))
				else
					H.visible_message(span_danger("[user] draws blood from [H] into the unstable mixture."))

				check_completion(user)
			return

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
		target.emote("superagony", forced = TRUE)
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
// Vial of Firstlaw
// Accepts basic ingredients related to mining and alchemy, and refines it into raw mammon value. Can also slorp up mammon too.
////////////////////

/obj/item/matthios_canister/firstlaw
	name = "vial of firstlaw"
	desc = "A suffocating pressure coils within the glass, as though something immense has been forced into too small a space. The contents do not slosh nor settle. They weigh upon reality itself."
	current_color = "#e100ff"
	aura_color = "#ff00b3"
	var/stored_value = 0

/obj/item/matthios_canister/firstlaw/freeman_truth()
	return "All things bend to the First Law. Nothing is created. Nothing is lost. Value merely changes shape. Where distant alchemists ever sought the truth to turn stone into gold, Malchem at its prime casually achieved. That old truth still lingers within this blessed vial, weakened."

/obj/item/matthios_canister/firstlaw/freeman_progress(mob/user)
	return "Stored Value: [stored_value]"

// VALIDATION
/obj/item/matthios_canister/firstlaw/proc/get_value(obj/item/I)
	if(istype(I, /obj/item/roguecoin))
		var/obj/item/roguecoin/C = I
		return C.get_real_price()

	if(istype(I, /obj/item/natural/stone) || istype(I, /obj/item/natural/clay) || istype(I, /obj/item/natural/dirtclod) || istype(I, /obj/item/natural/glass_shard))
		return 1

	if(istype(I, (/obj/item/natural/rock)))
		return 4

	if(istype(I, (/obj/item/scrap) || istype(I, /obj/item/natural/glass)))
		return 10

	if(istype(I, /obj/item/rogueore))
		var/obj/item/rogueore/O = I
		return O.get_real_price()

	if(istype(I, /obj/item/roguegem))
		var/obj/item/roguegem/G = I
		return G.get_real_price()

	if(istype(I, /obj/item/riddleofsteel))
		var/obj/item/riddleofsteel/R = I
		return R.get_real_price()

	return 0

// MAIN ITEM INTERACTION
/obj/item/matthios_canister/firstlaw/attackby(obj/item/I, mob/user)
	if(!HAS_TRAIT(user, TRAIT_MATTHIOS_EYES))
		to_chat(user, span_warning("The principle behind this vial escapes me. This is nonsense and heresy!"))
		return TRUE

	var/value = get_value(I)

	if(value <= 0)
		to_chat(user, span_warning("This is worthless."))
		return TRUE

	if(!do_after(user, 0.75 SECONDS, target = user))
		return TRUE

	stored_value += value
	to_chat(user, span_warning("The contents compress into entropic dust... <br>(Current Value: [stored_value])"))

	playsound(user.loc, 'sound/misc/smelter_sound.ogg', 50, FALSE)
	qdel(I)
	return TRUE

/obj/item/matthios_canister/firstlaw/proc/process_stone_batch(mob/user, turf/T)
	var/level = user.get_skill_level(/datum/skill/magic/holy)
	var/batch_size = 2 + (level * 2)
	var/processed = 0

	while(TRUE)
		var/list/batch = list()

		// Build batch safely
		for(var/obj/item/I in T)
			if((istype(I, /obj/item/natural/stone) || istype(I, /obj/item/natural/clay) || istype(I, /obj/item/natural/glass_shard) || istype(I, /obj/item/natural/rock)))
				var/value = get_value(I)
				if(value > 0)
					batch += I

			if(batch.len >= batch_size)
				break

		// Nothing valid found → stop entirely
		if(!batch.len)
			break

		// Action delay
		if(!do_after(user, 1 SECONDS, target = user))
			break

		// Process batch
		for(var/obj/item/I in batch)
			if(QDELETED(I))
				continue

			var/value = get_value(I)
			if(value <= 0)
				continue

			stored_value += value
			qdel(I)
			processed++

		playsound(user.loc, 'sound/misc/smelter_sound.ogg', 25, FALSE)

	// Final feedback
	if(processed > 0)
		to_chat(user, span_warning("You gather the materials together, reducing them into entropic dust.<br>(Current Value: [stored_value])"))

	return processed > 0

/obj/item/matthios_canister/firstlaw/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(!proximity_flag || !HAS_TRAIT(user, TRAIT_MATTHIOS_EYES))
		return

	if(isitem(target))
		var/obj/item/I = target
		var/value = get_value(I)

		if(value <= 0)
			to_chat(user, span_warning("This cannot dissolve into entropic dust..."))
			return

		if(!do_after(user, 0.75 SECONDS, target = user))
			return

		if(istype(target, /obj/item/natural/rock))
			var/obj/item/natural/rock/R = target
			var/ore_value
			if(R.type != /obj/item/natural/rock) // should simulate the bonus dosh from finding ores/gems in boulders
				ore_value += rand(10,100)

		stored_value += value
		qdel(I)

		to_chat(user, span_warning("The contents compress into entropic dust... <br>(Current Value: [stored_value])"))
		playsound(user.loc, 'sound/misc/smelter_sound.ogg', 25, FALSE)
		return

	if(isturf(target))
		process_stone_batch(user, target)

// RESOLUTION
/obj/item/matthios_canister/firstlaw/attack_self(mob/user)
	if(!HAS_TRAIT(user, TRAIT_MATTHIOS_EYES))
		to_chat(user, span_warning("This is heresy beyond me."))
		return

	if(stored_value <= 0)
		to_chat(user, span_warning("The vial contains no transactable value."))
		return

	var/choice = input(user, "How shall the First Law resolve?", "First Law") as null|anything in list(
		"Coin begets Coin!",
		"Return as Stones",
		"Cancel"
	)

	if(!choice || choice == "Cancel")
		return

	if(!do_after(user, 2 SECONDS, target = user, same_direction = TRUE))
		return

	var/turf/T = get_turf(src)

	if(choice == "Return as Stones")
		resolve_stones(user, T)
	else
		new /obj/effect/temp_visual/barter_fx(T)
		resolve_coinage(user, T)

// STONE OUTPUT
/obj/item/matthios_canister/firstlaw/proc/resolve_stones(mob/user, turf/T)
	var/level = user.get_skill_level(/datum/skill/magic/holy)
	var/batch_size = 2 + (level * 2)

	to_chat(user, span_notice("You release the concept of value into a more... solid shape."))

	while(stored_value > 0)
		if(!do_after(user, 1 SECONDS, target = user))
			break

		var/count = min(batch_size, stored_value)

		for(var/i in 1 to count)
			new /obj/item/natural/stone(T)

		stored_value -= count
		playsound(user.loc, 'sound/misc/smelter_sound.ogg', 20, FALSE)

	to_chat(user, span_notice("The First Law loosens its grip... <br>(Remaining Value: [stored_value])"))
	update_icon()

	if(stored_value <= 0)
		playsound(T, 'sound/foley/glassbreak.ogg', 50, TRUE)
		funny_smoke(src)
		qdel(src)

// COIN OUTPUT
/obj/item/matthios_canister/firstlaw/proc/resolve_coinage(mob/user, turf/T)
	playsound(T, 'sound/effects/matth_barter.ogg', 100, TRUE)

	var/level = user.get_skill_level(/datum/skill/magic/holy)
	var/efficiency = min(100, 20 + (level * 20))
	var/base = round(stored_value * (efficiency / 100))
	var/result = base

	if(level <= SKILL_LEVEL_JOURNEYMAN && prob(60 - (level * 10)))
		var/tax = rand(2,10)
		to_chat(user, span_warning("Matthios claims His due... (1/[tax] lost)"))
		result = round(base - (base / tax))

	if(result > 0)
		budget2change(result, user, putinhands = FALSE, custom_turf = T)

	to_chat(user, span_notice("The First Law concludes. [stored_value] value → [result] coin ([efficiency]% efficiency)."))

	funny_smoke(src)
	qdel(src)

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
	return "A primal tincture of eld. Organic matter is stripped to its nutritional and experiential essence, then reshaped into perfected sustenance. It does not cook; it transforms under one law which governs its malchemations: 'Thou greed shalt feed.' It'll be wise to have a sufficiently rich hoard before trying it."

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
		else if(istype(I, /obj/item/natural/bundle/bone))
			var/obj/item/natural/bundle/bone/B = I
			for(var/i = 1 to B.amount)
				inserted_ingredients += /obj/item/natural/bone
		else
			inserted_ingredients += I.type

		var/color_to_use = null
		for(var/T in ingredient_colors)
			if(istype(I, T))
				color_to_use = ingredient_colors[T]
				break

		if(color_to_use)
			current_color = color_to_use

		qdel(I)
		playsound(user, pick(GLOB.da_bubbles), 30, FALSE)
		to_chat(user, span_warning("A faint hiss rises as the [I] is rendered to its base components, drawn into the brew..."))
		update_icon()
		check_completion(user)

	return TRUE

/obj/item/matthios_canister/kingsfeast/check_completion(mob/user)
	if(inserted_ingredients.len < max_ingredients)
		return

	alch_transform(user)

/obj/item/matthios_canister/kingsfeast/alch_transform(mob/user)
	var/miraclecheck = user.get_skill_level(/datum/skill/magic/holy)
	var/totalmammon = get_mammons_in_atom(user) + SStreasury.get_balance(user)

	to_chat(user, span_notice("You begin channeling your greed into the mixture..."))
	if(!do_after(user, 25, src))
		return

	var/burnchance = max(0, 30 - (5 * miraclecheck))
	if(prob(burnchance))
		to_chat(user, span_warning("The mixture ignites violently, collapsing into useless slag and bitter disappointment. It... technically is edible. I guess?"))
		new /obj/item/reagent_containers/food/snacks/badrecipe(get_turf(src))
		funny_smoke(src)
		qdel(src)
		return

	var/poorthreshold = 50
	var/neutralthreshold = 100
	var/finethreshold = 200
	var/lavishthreshold = 400

	if(miraclecheck >= SKILL_LEVEL_EXPERT)
		poorthreshold *= 0.5
		neutralthreshold *= 0.5
		finethreshold *= 0.5
		lavishthreshold *= 0.5

	var/highest_fare = FARE_IMPOVERISHED

	if(totalmammon >= poorthreshold)
		highest_fare = FARE_POOR
	if(totalmammon >= neutralthreshold)
		highest_fare = FARE_NEUTRAL
	if(totalmammon >= finethreshold)
		highest_fare = FARE_FINE
	if(totalmammon >= lavishthreshold)
		highest_fare = FARE_LAVISH

	var/list/fare_options = list("Impoverished" = FARE_IMPOVERISHED)

	if(highest_fare >= FARE_POOR)
		fare_options["Poor"] = FARE_POOR
	if(highest_fare >= FARE_NEUTRAL)
		fare_options["Neutral"] = FARE_NEUTRAL
	if(highest_fare >= FARE_FINE)
		fare_options["Fine"] = FARE_FINE
	if(highest_fare >= FARE_LAVISH)
		fare_options["Lavish"] = FARE_LAVISH

	var/selected_fare = input(user, "What fare shall your greed take?", "Kingsfeast") as null|anything in fare_options
	if(!selected_fare)
		return

	var/selected_fare_type = fare_options[selected_fare]

	var/selected_threshold = 0
	switch(selected_fare_type)
		if(FARE_POOR)
			selected_threshold = poorthreshold
		if(FARE_NEUTRAL)
			selected_threshold = neutralthreshold
		if(FARE_FINE)
			selected_threshold = finethreshold
		if(FARE_LAVISH)
			selected_threshold = lavishthreshold

	totalmammon = get_mammons_in_atom(user) + SStreasury.get_balance(user)

	if(totalmammon < selected_threshold)
		to_chat(user, span_warning("Your greed cannot afford the fare you selected. The mixture simplifies itself into bread."))
		new /obj/item/reagent_containers/food/snacks/rogue/bread(get_turf(src))
		funny_smoke(src)
		qdel(src)
		return

	var/list/foods = list()

	for(var/food_path in subtypesof(/obj/item/reagent_containers/food/snacks/rogue))
		var/obj/item/reagent_containers/food/snacks/rogue/food_type = food_path

		if(initial(food_type.faretype) != selected_fare_type)
			continue

		var/food_name = LOWER_TEXT(initial(food_type.name))

		switch(selected_fare_type) // i hate it here (a little less, thanks ryon!!!)
			if(FARE_IMPOVERISHED)
				var/list/blacklisted_words = list("snack", "flatbread", "pesto", "raw", "uncooked", "slab of", "unfinished", "half-done", "base", "unbaked", "plucked", "meat", "filet", "sliced", "venison", "deadite", "pale", "belly", "mince", "minced", "pie", "dough", "butterdough", "piece")
				var/blacklisted = FALSE
				for(var/word in blacklisted_words)
					if(findtextEx(food_name, word))
						blacklisted = TRUE
						break
				if(blacklisted)
					continue

		foods[initial(food_type.name)] = food_type

	if(!length(foods))
		to_chat(user, span_warning("The mixture cannot find a suitable dish for this fare."))
		return

	var/choice = input(user, "What form shall your greed take?", "Kingsfeast") as null|anything in foods
	if(!choice)
		return

	var/result_type = foods[choice]

	to_chat(user, span_notice("The mixture responds to your greed, shaping and taking the desired form. It feels warm and tasty!"))
	new result_type(get_turf(src))
	funny_smoke(src)
	qdel(src)

/obj/item/matthios_canister/kingsfeast/attack_self(mob/user)
	if(!HAS_TRAIT(user, TRAIT_MATTHIOS_EYES))
		to_chat(user, span_warning("This is worthless junk."))
		return

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
		/obj/item/natural/dirtclod,
	)
	ingredient_colors = list(
		/obj/item/alch/bonemeal = "#ffffff",
		/obj/item/alch/mentha = "#3aff7a",
		/obj/item/alch/manabloompowder = "#66ccff",
		/obj/item/reagent_containers/powder = "#ff00b3",
		/obj/item/natural/bone = "#e8e2cf",
		/obj/item/natural/bundle/bone = "#e8e2cf",
		/obj/item/natural/dirtclod = "#913a00",
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
		playsound(user, pick(GLOB.da_bubbles), 30, FALSE)
		to_chat(user, span_warning("A faint hiss rises as the [I] is rendered to its base components, drawn into the brew..."))
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
			target.energy_add(50)

			if(target.nutrition > 0)
				target.adjustBruteLoss(-2)
				target.adjustFireLoss(-2)

			if(target.hydration > 0)
				target.adjustOxyLoss(-4)
				target.adjustToxLoss(-2)

			sleep(50)

	to_chat(user, span_notice("The vial dulls and crumbles away."))
	playsound(user.loc,'sound/misc/smelter_sound.ogg', 50, FALSE)
	qdel(src)

/obj/item/matthios_canister/warsmith
	name = "vial of warsmith base"
	desc = "A biting liquor gnaws within the vial, as though it would eat iron itself. Flecks of metal drift and vanish, then return as if unmade and remade. It reeks of rust and sharp ruin. No forge would suffer this thing near its works."
	var/needed_scrap = 1
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
			playsound(user, pick(GLOB.da_bubbles), 30, FALSE)
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
				target.adjust_bloodpool(75)
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

//EQUIPPABLES
/obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gilded
	name = "ornate amulet of Matthios"
	desc = "He was ever the one to make you ask questions: Why are we still here? Just to suffer? Nae. We are here to make a change. And a change we shall make, together."
	icon_state = "matthios"
	resistance_flags = FIRE_PROOF
	slot_flags = ITEM_SLOT_NECK | ITEM_SLOT_RING
	smeltresult = /obj/item/ash
	aura_color = "#ffe761"
	is_important = TRUE // so this can't be sold in the navigator lol!!
	var/stolen_fyre = FALSE
	var/grant_chant = FALSE
	var/active_item = FALSE
	var/swap_type = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gilded/astrata
	var/swap_message = "The gilded amulet transmutates to a different form. You feel a smile, as you profane Her fyre the same way as He did."

/obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gilded/proc/swap_form(mob/living/carbon/human/user)
	var/obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gilded/new_amulet = new swap_type(user.loc)
	if(user.is_holding(src))
		user.temporarilyRemoveItemFromInventory(src)
		user.put_in_hands(new_amulet)
	else
		new_amulet.forceMove(get_turf(user))
	qdel(src)

/obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gilded/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_FREEMAN))
		. += span_notice("<i>As coin begets coin, so too does Her pride beget ruin. She believes Her will absolute, yet She stands as anything but. The theft of Her fyre was merely the first proof. The future belongs to the free. To humenkind. Not to the rule of a weak tyrant and their blood-bound puppets.</i>")
		. += span_warning("This amulet can be swapped into another form by using it on your hand.")
		. += span_warning("Grants +1 LUC if you use it while undisguised.")

/obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gilded/attack_self(mob/living/carbon/human/user)
	if(!HAS_TRAIT(user, TRAIT_FREEMAN))
		return
	if(!do_after(user, 1 SECONDS))
		return
	to_chat(user, span_warning(swap_message))
	playsound(user.loc, 'sound/magic/swap.ogg', 25, TRUE, -2)
	swap_form(user)

/obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gilded/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_SUSPICIOUS, HERESYDESC_MATTHIOS_ICON)

/obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gilded/astrata
	name = "ornate amulet of Astrata"
	desc = "Her command is absolute, and Her tyranny is unmarrable. Reclaim this world, child of mine, from those who'd seek to destroy it."
	icon_state = "astrata_g"
	aura_color = null
	swap_type = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gilded
	swap_message = "The gilded amulet settles back into familiar weight. You feel a grin, as He commends you for your boldness."
	stolen_fyre = TRUE
	is_important = TRUE // so this can't be sold in the navigator lol!!

/obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gilded/astrata/get_examine_highlight_status()
	return null

/obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gilded/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(obj_broken || active_item)
		return
	if((slot == SLOT_NECK || slot == SLOT_RING) && user.patron && (user.patron.type in ALL_INHUMEN_PATRONS))
		if(!stolen_fyre && HAS_TRAIT(user, TRAIT_FREEMAN))
			user.change_stat(STATKEY_LCK, 1, "matthios_boldness")
		active_item = TRUE
		if(!user.has_language(/datum/language/thievescant))
			to_chat(user, span_info("You gain insight on Thieves' Cant.<br><br><i>Keep in mind these are 'words' that come out as gestures, so blend it between normal speech to make it not so obvious.<br><font color=yellow>(Prefix: ,y)</font></i>"))
			user.grant_language(/datum/language/thievescant)
			grant_chant = TRUE
		else
			to_chat(user, span_info("You already know Thieves' Cant, but praise be Matthios anyway!"))

/obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gilded/dropped(mob/living/carbon/human/user)
	. = ..()
	if(!active_item)
		return
	active_item = FALSE
	if(!stolen_fyre && HAS_TRAIT(user, TRAIT_FREEMAN))
		user.change_stat(STATKEY_LCK, 0, "matthios_boldness")
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
	is_important = TRUE // so this can't be sold in the navigator lol!!
	var/active_item = FALSE
	unarmed_bonus = 10 // better than steel, worse than blacksteel, shitty durability
	unarmed_weapon_effects = TRUE
	equip_delay_self = 2 SECONDS // COMMIT
	unequip_delay_self = 2 SECONDS

/obj/item/clothing/gloves/roguetown/fingerless_leather/muffle_matthios/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(obj_broken || active_item)
		return
	if(slot == SLOT_GLOVES && HAS_TRAIT(user, TRAIT_FREEMAN))
		active_item = TRUE
		to_chat(user, span_info("Like Him, my hands ready to grasp the impossible."))
		ADD_TRAIT(user, TRAIT_SILENT_LOCKPICK, "matthios_gloves")
		user.change_stat(STATKEY_LCK, 1, "matthios_gloves")

/obj/item/clothing/gloves/roguetown/fingerless_leather/muffle_matthios/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_MATTHIOS_ARMOR)

/obj/item/clothing/gloves/roguetown/fingerless_leather/muffle_matthios/dropped(mob/living/carbon/human/user)
	. = ..()
	if(!active_item)
		return
	active_item = FALSE
	to_chat(user, span_info("Once again, these hands are supplicant."))
	REMOVE_TRAIT(user, TRAIT_SILENT_LOCKPICK, "matthios_gloves")
	user.change_stat(STATKEY_LCK, 0, "matthios_gloves")

/// This has way too much telegraphing already, so letting it be harder to detect being worn.

/obj/item/clothing/mask/rogue/spectacles/duelist/matthios
	name = "tinted duelist goggles"
	desc = "A drakkyne's eyes are oft blindsided by greed, yet such vision does hold some merit."
	armor = ARMOR_LEATHER
	color = "#faf5cb"
	aura_color = "#fffb00"
	icon_state = "sduelist"
	max_integrity = 150
	is_important = TRUE

/obj/item/clothing/mask/rogue/spectacles/duelist/matthios/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if((slot == SLOT_WEAR_MASK || slot == SLOT_HEAD) && HAS_TRAIT(user, TRAIT_FREEMAN))
		user.apply_status_effect(/datum/status_effect/buff/matthios_vision)

/obj/item/clothing/mask/rogue/spectacles/duelist/matthios/dropped(mob/living/carbon/human/user)
	. = ..()
	user.remove_status_effect(/datum/status_effect/buff/matthios_vision)

/obj/item/clothing/mask/rogue/spectacles/duelist/matthios/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing/matthicat, NECK, null, null, 'sound/foley/equip/rummaging-03.ogg', null, (UPD_HEAD|UPD_MASK))

/datum/component/adjustable_clothing/matthicat

/datum/component/adjustable_clothing/matthicat/toggle_open(obj/item/clothing/C, forced = FALSE)
	. = ..()
	var/mob/living/carbon/human/user = C.loc
	if(!user)
		return
	user.remove_status_effect(/datum/status_effect/buff/matthios_vision)

/datum/component/adjustable_clothing/matthicat/toggle_closed(obj/item/clothing/C, forced = FALSE)
	. = ..()
	var/mob/living/carbon/human/user = C.loc
	if(!user)
		return
	if(C.loc == user && (C in list(user.wear_mask, user.head)) && HAS_TRAIT(user, TRAIT_FREEMAN))
		user.apply_status_effect(/datum/status_effect/buff/matthios_vision)

/atom/movable/screen/alert/status_effect/buff/matthios_vision
	name = "Gilded True Sight"
	desc = "Through Him, all is seen, and no locks shall bar me. Whether that it should be... is another matter."
	icon_state = "darkvision"
	color = "#ffe600"

/datum/status_effect/buff/matthios_vision
	id = "matthios_vision"
	alert_type = /atom/movable/screen/alert/status_effect/buff/matthios_vision
	duration = -1
	tick_interval = 20 SECONDS

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
	var/mob/living/carbon/C = owner
	if(!C)
		return
	var/pickLV = C.get_skill_level(/datum/skill/misc/lockpicking)
	var/holyLV = C.get_skill_level(/datum/skill/magic/holy)
	var/weightedLV = (holyLV * 0.80) + (pickLV * 0.20)
	var/halluc_chance = clamp(100 - (weightedLV * (100 / 6)), 0, 100)

	// === HALLUCINATIONS ===
	if(prob(halluc_chance) && holyLV < SKILL_LEVEL_EXPERT)
		if(C.hallucination < 400)
			C.hallucination = min(400, C.hallucination + rand(5, 15))
			to_chat(C, span_warning(pick("This sight was not made for me.","I can feel my thoughts peeling apart.","The world looks wrong.","I should remove this.","My mind recoils from what it sees.","Too much truth presses inward.","Matthios, is this true?!","Matthios, is this TRVE?!","I regret everything.","Something broke.","DAFUQ?","What is that?!","What is this?!","Where am I??","I see it clearly now.","The truth is fine. Everything is fine.","I'm fine... I'm fine... I'm fine...","I can see Matthios. He is grinning.","I can see Astrata. She is furious.","Is this right?","What is wrong?","Behind me.","Behind you.","Free is watching you.","Grand Liege...?","La li lu le lo?","There are too many angles here.","Why does the floor have veins?","I can hear colors.","The walls know my name.","This was hidden for a reason.","I understand less each second.","The shadows are explaining things.","Who moved the horizon?","The stars are too close.","My teeth feel observant.","Why is the silence screaming?","I looked too far.","Everything has a second face.","The room blinked.","Truth tastes metallic.","I can smell geometry.","Someone is standing inside my reflection.","I should not know this.","The corners are whispering.","I remember tomorrow.","My heartbeat is counting backwards.","Why are there footprints on the ceiling?","The light is lying.","There is another sky above this one.","Numbers keep crawling away.","The door was never a door.","I have too many hands.","Did the world always breathe?","I can see where prayers go.","Something old just noticed me.","The dust is watching.","My bones disagree.","Reality feels temporary.","I found the seam.","Don't turn around.","Too late.","I was always behind me.")))
			C.Jitter(5)

	if(holyLV < SKILL_LEVEL_JOURNEYMAN)
		if(prob(25))
			var/dmg = rand(1, 15)
			C.adjustFireLoss(dmg)

	if(holyLV < SKILL_LEVEL_EXPERT)
		if(prob(30))
			C.emote(pick("breathgasp","shiver","groan","whimper","pain","sigh","giggle","laugh","cackle"))
			C.Jitter(10)

/obj/item/clothing/shoes/roguetown/boots/muffle_matthios //I guess in case someone wants to make generic muffled boots? Change it to muffle/matthios if you do
	name = "gilded leather boots"
	desc = "Those who bear His fyre often cower in its shadow."
	icon_state = "matthiosboots"
	sewrepair = TRUE
	armor = ARMOR_LEATHER
	color = "#fff9c0" // we golden
	aura_color = "#ffe600"
	equip_delay_self = 2 SECONDS // COMMIT
	unequip_delay_self = 2 SECONDS

/obj/item/clothing/shoes/roguetown/boots/muffle_matthios/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot == SLOT_SHOES && HAS_TRAIT(user, TRAIT_FREEMAN))
		to_chat(user, span_info("Like Him, I slink into the shadows."))
		ADD_TRAIT(user, TRAIT_SILENT_FOOTSTEPS, "matthios_boots")
		ADD_TRAIT(user, TRAIT_LIGHT_STEP, "matthios_boots")
		ADD_TRAIT(user, TRAIT_FREERUNNING, "matthios_boots")
		user.change_stat(STATKEY_SPD, 1, "matthios_boots")

/obj/item/clothing/shoes/roguetown/boots/muffle_matthios/dropped(mob/living/carbon/human/user)
	. = ..()
	if(istype(user) && user?.shoes == src)
		to_chat(user, span_info("Once again, I am under Her gaze."))
		REMOVE_TRAIT(user, TRAIT_SILENT_FOOTSTEPS, "matthios_boots")
		REMOVE_TRAIT(user, TRAIT_LIGHT_STEP, "matthios_boots")
		REMOVE_TRAIT(user, TRAIT_FREERUNNING, "matthios_boots")
		user.change_stat(STATKEY_SPD, 0, "matthios_boots")

/obj/item/clothing/shoes/roguetown/boots/muffle_matthios/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_MATTHIOS_ARMOR) //These were always meant to be valid I don't get why this was forgotten about

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
				span_warning("Sand gets into my eyes! I can't see!"))
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

/obj/item/storage/belt/rogue/pouch/matthios/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cursed_item, (TRAIT_FREEMAN||TRAIT_XYLIX), "BLESSED POUCH")

/obj/item/storage/belt/rogue/pouch/matthios/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_SUSPICIOUS, HERESYDESC_MATTHIOS_MISC)

/obj/item/storage/backpack/rogue/backpack/matthios
	name = "smuggling bag"
	desc = "A sack tied with some 'blessed' rope. There is a carving of a grinning symbol within the side of it. It has a strange, gilded glow to it."
	aura_color = "#fff385"
	icon_state = "rucksack_untied"
	item_state = "rucksack"
	component_type = /datum/component/storage/concrete/roguetown/backpack
	max_integrity = 100

/obj/item/storage/backpack/rogue/backpack/matthios/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cursed_item, (TRAIT_FREEMAN||TRAIT_XYLIX), "BLESSED RUCKSACK")

/obj/item/storage/backpack/rogue/backpack/matthios/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_SUSPICIOUS, HERESYDESC_MATTHIOS_MISC)

/obj/item/rope/chain/matthios
	name = "gilded chain"
	desc = "A heavy, gilded chain that thrums with latent divine power. It resonates negatively with the essence of nobility, as if stirred by divine rebuke."
	color = "#fdff86"
	aura_color = "#fff385"
	matthios_chains = TRUE
	smeltresult = /obj/item/ash

/obj/item/rope/chain/matthios/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_MATTHIOS_RELIC)

/obj/item/melee/touch_attack/lesserknock/matthios
	name = "gilded lockpick"
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

/obj/item/melee/touch_attack/lesserknock/matthios/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_MATTHIOS_RELIC)
