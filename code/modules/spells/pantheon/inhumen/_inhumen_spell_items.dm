////////////
//MATTHIOS//
////////////

//ALCHEMY
/obj/item
	var/aura_color = null

/obj/item/Initialize(mapload)
	. = ..()
	if(aura_color)
		apply_aura()

/obj/item/proc/apply_aura()
	if(!aura_color)
		return
	remove_aura()
	filters += filter(type = "outline", color = "[aura_color]40", size = 2)

/obj/item/proc/remove_aura()
	for(var/F in filters)
		if(islist(F) && F["type"] == "outline")
			filters -= F

/obj/item/proc/refresh_aura()
	apply_aura()

/// Anyone Matthios (or his circle) will tolerate carrying his relics
/proc/matthios_worthy(mob/user)
	return HAS_TRAIT(user, TRAIT_FREEMAN) || HAS_TRAIT(user, TRAIT_XYLIX) || HAS_TRAIT(user, TRAIT_CABAL) || HAS_TRAIT(user, TRAIT_HORDE) || HAS_TRAIT(user, TRAIT_DEPRAVED)

/// Turns the item to ash (spilling its contents) if the user is unworthy. Returns TRUE if that happened.
/obj/item/proc/ash_unworthy(mob/user)
	if(matthios_worthy(user))
		return FALSE
	to_chat(user, "[src] turns to ash in my hands!")
	playsound(user.loc, 'sound/items/firesnuff.ogg', 100, FALSE, -1)
	for(var/obj/item/I in contents)
		I.forceMove(get_turf(src))
	qdel(src)
	return TRUE

/obj/item/alchserum
	var/current_color = "#ffffff"

/obj/item/alchserum/Initialize(mapload)
	. = ..()
	update_icon()

/obj/item/alchserum/update_icon()
	cut_overlays()

/proc/funny_smoke(atom/source, radius = 0, sound_vol = 50)
	var/turf/T = get_turf(source)
	if(!T)
		return
	playsound(T, 'sound/items/smokebomb.ogg', sound_vol)
	var/datum/effect_system/smoke_spread/smoke = new
	smoke.set_up(radius, T)
	smoke.start()

GLOBAL_LIST_INIT(da_bubbles, list('sound/foley/bubb (1).ogg','sound/foley/bubb (2).ogg','sound/foley/bubb (3).ogg','sound/foley/bubb (4).ogg','sound/foley/bubb (5).ogg'))

////////////////////
// Canister base  //
////////////////////

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
	/// How many whole ingredients this canister takes (used by the default check_completion)
	var/max_ingredients = 0
	var/result_path = null
	var/finish_message = "The mixture stabilizes successfully."

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
	return TRUE

/obj/item/matthios_canister/proc/matthios_only(mob/user, fail_message = "The hell do I do with this? This is no alchemy!")
	if(HAS_TRAIT(user, TRAIT_MATTHIOS_EYES))
		return TRUE
	to_chat(user, span_warning(fail_message))
	return FALSE

/obj/item/matthios_canister/proc/is_ingredient(obj/item/I)
	for(var/T in required_ingredients)
		if(istype(I, T))
			return TRUE
	return FALSE

/obj/item/matthios_canister/proc/ingredient_color(obj/item/I)
	for(var/T in ingredient_colors)
		if(istype(I, T))
			return ingredient_colors[T]

/// Takes blood from H, with a message for self-draws and for draws on someone else
/obj/item/matthios_canister/proc/draw_blood(mob/living/carbon/human/H, mob/user, self_message, other_message)
	H.blood_volume -= round(BLOOD_VOLUME_NORMAL * 0.05)
	H.visible_message(span_danger(user == H ? self_message : other_message))

/// Shared by canisters that count whole ingredients (kingsfeast, goodnite)
/obj/item/matthios_canister/proc/insert_ingredient(obj/item/I, mob/user, full_message, expand_bundles = FALSE)
	if(!matthios_only(user) || !is_ingredient(I))
		return
	if(inserted_ingredients.len >= max_ingredients)
		to_chat(user, span_warning(full_message))
		return
	if(!do_after(user, 1.5 SECONDS) || QDELETED(I))
		return

	var/item_name = "[I]"
	var/ingredient_type = I.type
	var/count = 1
	if(expand_bundles && istype(I, /obj/item/natural/bundle/fibers))
		var/obj/item/natural/bundle/fibers/F = I
		count = F.amount
		ingredient_type = /obj/item/natural/fibers
	else if(expand_bundles && istype(I, /obj/item/natural/bundle/bone))
		var/obj/item/natural/bundle/bone/B = I
		count = B.amount
		ingredient_type = /obj/item/natural/bone
	for(var/i in 1 to min(count, max_ingredients - inserted_ingredients.len))
		inserted_ingredients += ingredient_type

	var/new_color = ingredient_color(I)
	if(new_color)
		current_color = new_color
	qdel(I)
	playsound(user, pick(GLOB.da_bubbles), 30, FALSE)
	to_chat(user, span_warning("A faint hiss rises as the [item_name] is rendered to its base components, drawn into the brew... ([inserted_ingredients.len]/[max_ingredients])"))
	update_icon()
	check_completion(user)

/obj/item/matthios_canister/proc/check_completion(mob/user)
	if(max_ingredients && inserted_ingredients.len >= max_ingredients)
		alch_transform(user)

/obj/item/matthios_canister/proc/alch_transform(mob/user)
	if(!result_path)
		return
	to_chat(user, span_notice(finish_message))
	var/obj/item/result = new result_path(get_turf(src))
	if(istype(result, /obj/item/alchserum/matthios_lyfestruth))
		var/obj/item/alchserum/matthios_lyfestruth/lyfe = result
		lyfe.benefactor = user
	funny_smoke(src)
	qdel(src)

//////////////////////
//Vial of Lyfestruth//
//Uses all herbs in game, and one purified lux, explosively (literal!) revives your target.

/obj/item/matthios_canister/lyfestruth
	name = "vial of lyfestruth base"
	desc = "Within the glass swells a searing draught, as though molten gold were stirred with the heartblood of a volcano."
	result_path = /obj/item/alchserum/matthios_lyfestruth
	/// "herb", "coin" or "lux" once the first ingredient is accepted
	var/route = null
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
		/obj/item/alch/rosa,
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
	switch(route)
		if("herb")
			var/herb_hint = "none"
			if(required_herbs.len)
				var/atom/A = pick(required_herbs)
				herb_hint = initial(A.name)
			return "It still lacks [herb_hint]. Blood may substitute the missing pieces. ([max(0, max_blood_uses - blood_uses)]/[max_blood_uses] sacrifices remaining)"
		if("coin")
			return "Mammon bound: [coin_value]/[coin_target]. The draught demands wealth made manifest."
		if("lux")
			if(lux_count >= 1)
				return "The purified Lux is bound. The draught stabilizes..."
			return "The draught writhes incomplete... [max(0, 2 - impure_lux_count)] more impure Lux required, and [max(0, 5 - lux_blood)]/5 lyfeblood or heartblood sacrifices remain."
	return "The draught is unstable... it may yet accept herbs, mammon, or Lux."

/// Checks the route is compatible, waits out the delay, and only then locks the route in
/obj/item/matthios_canister/lyfestruth/proc/begin_feed(obj/item/I, mob/user, new_route)
	if(route && route != new_route)
		to_chat(user, span_warning("This will no longer work with the draught..."))
		return FALSE
	if(!do_after(user, 1 SECONDS) || QDELETED(I) || (route && route != new_route))
		return FALSE
	route = new_route
	return TRUE

/obj/item/matthios_canister/lyfestruth/check_completion(mob/user)
	var/done = FALSE
	switch(route)
		if("herb")
			done = !required_herbs.len
		if("coin")
			done = coin_value >= coin_target
		if("lux")
			done = lux_count >= 1 || (impure_lux_count >= 2 && lux_blood >= 5)
			if(done && lux_count >= 1) // impure lux wasn't needed, give it back
				for(var/i in 1 to impure_lux_count)
					new /obj/item/reagent_containers/lux_impure(user.loc)
	if(done)
		alch_transform(user)

/obj/item/matthios_canister/lyfestruth/attackby(obj/item/I, mob/user)
	if(!matthios_only(user))
		return TRUE

	var/fed = FALSE
	var/herb
	for(var/T in required_herbs)
		if(istype(I, T))
			herb = T
			break

	if(herb)
		if(begin_feed(I, user, "herb"))
			required_herbs -= herb
			to_chat(user, span_notice("The herb binds into the draught. ([required_herbs.len] remaining)"))
			fed = TRUE
	else if(istype(I, /obj/item/roguecoin))
		var/obj/item/roguecoin/C = I
		var/value = C.get_real_price()
		if(value > 0 && begin_feed(I, user, "coin"))
			coin_value += value
			to_chat(user, span_notice("The mammon dissolves into the draught... ([coin_value]/[coin_target])"))
			fed = TRUE
	else if(istype(I, /obj/item/reagent_containers/lux) || istype(I, /obj/item/reagent_containers/lux_moss))
		if(begin_feed(I, user, "lux"))
			lux_count++
			to_chat(user, span_notice("The purified Lux binds perfectly into the mixture, sizzling with a golden glow..."))
			fed = TRUE
	else if(istype(I, /obj/item/reagent_containers/lux_impure))
		if(begin_feed(I, user, "lux"))
			impure_lux_count++
			to_chat(user, span_notice("The impure Lux writhes within the draught. It demands more..."))
			fed = TRUE
	else if(istype(I, /obj/item/heart_blood_canister/filled))
		if(lux_blood >= 5)
			to_chat(user, span_notice("This is brimming with vitae, it needs no more."))
		else if(begin_feed(I, user, "lux"))
			lux_blood = 5
			to_chat(user, span_notice("The heartblood boils within the draught. It demands no more."))
			fed = TRUE

	if(fed)
		qdel(I)
		check_completion(user)
	return TRUE

/obj/item/matthios_canister/lyfestruth/afterattack(atom/target, mob/user, proximity_flag, params)
	if(!proximity_flag || !ishuman(target) || route == "coin" || !HAS_TRAIT(user, TRAIT_MATTHIOS_EYES))
		return
	var/for_lux = (route == "lux")
	if(for_lux && impure_lux_count < 1)
		return

	var/mob/living/carbon/human/H = target
	if(for_lux ? lux_blood >= 5 : blood_uses >= max_blood_uses)
		to_chat(user, span_warning(for_lux ? "The draught has taken enough." : "The draught refuses further sacrifice."))
		return
	if(!H.get_bleed_rate())
		to_chat(user, span_warning(for_lux ? "There is no blood to take." : "There is no open wound to draw from."))
		return
	if(!do_after(user, 2 SECONDS, target = H))
		return

	if(for_lux)
		lux_blood++
		draw_blood(H, user, "[user] feeds their own blood into the unstable draught.", "[user] draws blood from [H] into the unstable mixture.")
		to_chat(user, span_warning("The impure Lux within writhes as it feeds... ([lux_blood]/5)"))
	else
		route = "herb"
		blood_uses++
		if(required_herbs.len)
			required_herbs -= pick(required_herbs)
		draw_blood(H, user, "[user] presses the vial to their own wound, feeding it.", "[user] presses the vial to [H]'s wound, drawing blood.")
		to_chat(user, span_warning("The draught drinks deeply... ([blood_uses]/[max_blood_uses])"))
	check_completion(user)

/obj/item/alchserum/matthios_lyfestruth
	name = "vial of lyfestruth"
	desc = "A radiant vial containing a volatile mixture. The liquid within churns with molten intensity, casting a searing orange-gold glow that flickers against its glass prison. It seems extremely volatile."
	icon = 'icons/obj/structures/heart_items.dmi'
	icon_state = "canister_empty"
	current_color = "#ff9d00"
	aura_color = "#fffaad"
	w_class = WEIGHT_CLASS_TINY
	var/mob/benefactor

/obj/item/alchserum/matthios_lyfestruth/attack(mob/living/target, mob/user)
	var/fail // null = ok, otherwise an extra line appended to the standard refusal
	if(!iscarbon(target))
		fail = ""
	else if(target.stat != DEAD)
		fail = " There's too much lyfe in that Lux."
	else if(!target.mind?.active)
		fail = ""
	else if(HAS_TRAIT(target, TRAIT_DNR))
		fail = " There's not a spec left of lyfe to rekindle on that one."
	if(!isnull(fail))
		to_chat(user, "Strangely, the fluid crystalizes when you try, only to become viscous again as you pull away.[fail]")
		return
	if(!benefactor)
		to_chat(user, span_warning("The vial has no benefactor to anchor its exchange, rendering it useless."))
		return
	if(!target.revive_check(user))
		return

	to_chat(user, span_notice("You begin pouring the mysterious vial over [target.name]..."))
	if(!do_after(user, 6 SECONDS, target) || QDELETED(src) || QDELETED(target) || target.stat != DEAD || !target.revive_check(user))
		return
	apply_effect(target, user)

/obj/item/alchserum/matthios_lyfestruth/proc/apply_effect(mob/living/carbon/target, mob/user)
	if(!target || !benefactor)
		return
	var/debt = rand(100, 200)
	if(target.patron?.type in ALL_INHUMEN_PATRONS)
		debt *= 0.5
	else if(HAS_TRAIT(target, TRAIT_NOBLE) && !HAS_TRAIT(target, TRAIT_FREEMAN))
		debt *= 3
	target.apply_status_effect(/datum/status_effect/debuff/matthios_debt, round(debt), benefactor)
	target.adjustOxyLoss(-target.getOxyLoss())
	if(!target.revive(full_heal = FALSE))
		to_chat(user, span_warning("Nothing happens."))
		return
	var/mob/living/carbon/spirit/underworld_spirit = target.get_spirit()
	if(underworld_spirit)
		var/mob/dead/observer/ghost = underworld_spirit.ghostize()
		qdel(underworld_spirit)
		ghost.mind.transfer_to(target, TRUE)
	target.grab_ghost(force = TRUE)
	target.emote("breathgasp")
	target.Jitter(100)
	target.update_body()
	target.visible_message(span_astrata("[target] is rekindled by a burst of primordial fyre!"), span_green("I awake from the void."))
	target.mind.remove_antag_datum(/datum/antagonist/zombie)
	target.remove_status_effect(/datum/status_effect/debuff/rotted_zombie)
	target.apply_status_effect(/datum/status_effect/debuff/revived)
	to_chat(user, span_userdanger("Surely no consequences will come from using this, right?..."))
	to_chat(target, span_userdanger("Your soul returns, but it feels as if your Patron demands compensation..."))

	if(HAS_TRAIT(target, TRAIT_IRONMAN))
		target.apply_status_effect(/datum/status_effect/debuff/integrity_rig, 11 MINUTES)
		target.visible_message(span_danger("[target] is looking on the verge of exploding again! Their core may need an extra whack from a hammer."))

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
	/// Prevents overlapping do_afters from double-spending or duplicating value
	var/busy = FALSE
	var/flame_cost = 30
	var/serum_cost = 5
	/// Types the vial sweeps up when used on a turf (deliberately excludes coins, ore and gems)
	var/list/sweep_types = list(
		/obj/item/natural/rock,
		/obj/item/natural/stone,
		/obj/item/natural/clay,
		/obj/item/natural/glass_shard,
	)

/obj/item/matthios_canister/firstlaw/freeman_truth()
	return "All things bend to the First Law. Nothing is created. Nothing is lost. Value merely changes shape. Where distant alchemists ever sought the truth to turn stone into gold, Malchem at its prime casually achieved. That old truth still lingers within this blessed vial, weakened."

/obj/item/matthios_canister/firstlaw/freeman_progress(mob/user)
	return "Stored Value: [stored_value]"

/obj/item/matthios_canister/firstlaw/proc/can_use(mob/user, fail_message)
	return matthios_only(user, fail_message) && !busy

/obj/item/matthios_canister/firstlaw/proc/give_item(mob/user, obj/item/I)
	if(!user.put_in_inactive_hand(I))
		user.put_in_hands(I) // falls back to the floor if hands are full

/obj/item/matthios_canister/firstlaw/proc/is_sweepable(obj/item/I)
	for(var/path in sweep_types)
		if(istype(I, path))
			return TRUE
	return FALSE

/obj/item/matthios_canister/firstlaw/proc/get_value(obj/item/I)
	// Order matters: check the more specific types before their possible parents
	if(istype(I, /obj/item/roguecoin))
		var/obj/item/roguecoin/C = I
		return C.get_real_price()
	if(istype(I, /obj/item/rogueore))
		var/obj/item/rogueore/O = I
		return O.get_real_price()
	if(istype(I, /obj/item/roguegem))
		var/obj/item/roguegem/G = I
		return G.get_real_price()
	if(istype(I, /obj/item/riddleofsteel))
		var/obj/item/riddleofsteel/R = I
		return R.get_real_price()
	if(istype(I, /obj/item/natural/rock))
		return 4
	if(istype(I, /obj/item/natural/stone) || istype(I, /obj/item/natural/clay) || istype(I, /obj/item/natural/dirtclod) || istype(I, /obj/item/natural/glass_shard))
		return 1
	if(istype(I, /obj/item/scrap) || istype(I, /obj/item/natural/glass))
		return 10
	return 0

/// Consumes the item and returns the value actually gained (0 if nothing happened).
/// Rocks that aren't plain boulders simulate the bonus dosh from ores/gems found inside.
/obj/item/matthios_canister/firstlaw/proc/absorb_item(obj/item/I)
	var/value = QDELETED(I) ? 0 : get_value(I)
	if(value <= 0)
		return 0
	if(istype(I, /obj/item/natural/rock) && I.type != /obj/item/natural/rock)
		value += rand(10, 100)
	stored_value += value
	qdel(I)
	return value

/obj/item/matthios_canister/firstlaw/proc/dissolve(obj/item/I, mob/user, volume)
	busy = TRUE
	if(do_after(user, 0.75 SECONDS, target = user) && !QDELETED(I))
		var/gained = absorb_item(I)
		if(gained > 0)
			to_chat(user, span_notice("The contents compress into entropic dust... <br>(+[gained], Current Value: [stored_value])"))
			playsound(user.loc, 'sound/misc/smelter_sound.ogg', volume, FALSE)
	busy = FALSE

/obj/item/matthios_canister/firstlaw/attackby(obj/item/I, mob/user, params)
	if(!can_use(user, "The principle behind this vial escapes me. This is nonsense and heresy!"))
		return TRUE
	if(get_value(I) <= 0)
		to_chat(user, span_warning("This is worthless."))
	else
		dissolve(I, user, 50)
	return TRUE

/obj/item/matthios_canister/firstlaw/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(!proximity_flag || target == src || !can_use(user, "This is heresy beyond me."))
		return
	if(isitem(target))
		var/obj/item/I = target
		// Only things lying on the ground or held by the user, never from other people's hands or containers
		if(I.anchored || !(isturf(I.loc) || I.loc == user))
			return
		if(get_value(I) <= 0)
			to_chat(user, span_warning("This cannot dissolve into entropic dust..."))
			return
		dissolve(I, user, 25)
	else if(isturf(target))
		busy = TRUE
		sweep_turf(user, target)
		busy = FALSE

/obj/item/matthios_canister/firstlaw/proc/sweep_turf(mob/user, turf/T)
	var/batch_size = 2 + (user.get_skill_level(/datum/skill/magic/holy) * 2)
	var/list/queue = list()
	for(var/obj/item/I in T)
		if(I != src && !I.anchored && is_sweepable(I))
			queue += I

	var/gained_total = 0
	while(queue.len)
		if(!do_after(user, 1 SECONDS, target = user))
			break
		for(var/i in 1 to min(batch_size, queue.len))
			var/obj/item/I = queue[1]
			queue.Cut(1, 2)
			if(!QDELETED(I) && I.loc == T)
				gained_total += absorb_item(I)
		playsound(user.loc, 'sound/misc/smelter_sound.ogg', 25, FALSE)

	if(gained_total > 0)
		to_chat(user, span_notice("You gather the materials together, reducing them into entropic dust.<br>(+[gained_total], Current Value: [stored_value])"))

/obj/item/matthios_canister/firstlaw/attack_self(mob/user)
	if(!can_use(user, "This is heresy beyond me."))
		return
	if(stored_value <= 0)
		to_chat(user, span_warning("The vial contains no transactable value."))
		return

	var/choice = tgui_input_list(user, "How shall the First Law resolve?", "First Law", list("Coin begets Coin!", "Return as Stones", "Morph Serum", "Borrow The Flame"))
	// State may have changed while the menu was open
	if(!choice || QDELETED(src) || QDELETED(user) || loc != user || busy || stored_value <= 0)
		return

	busy = TRUE
	switch(choice)
		if("Borrow The Flame")
			resolve_flame(user)
		if("Morph Serum")
			resolve_serum(user)
		if("Return as Stones")
			if(do_after(user, 2 SECONDS, target = user, same_direction = TRUE))
				resolve_stones(user)
		if("Coin begets Coin!")
			if(do_after(user, 2 SECONDS, target = user, same_direction = TRUE))
				resolve_coinage(user)
	if(!QDELETED(src))
		busy = FALSE

/obj/item/matthios_canister/firstlaw/proc/resolve_flame(mob/user)
	if(stored_value < flame_cost)
		to_chat(user, span_warning("There is not enough stored entropic dust to create this. ([flame_cost] required)"))
		return
	stored_value -= flame_cost
	give_item(user, new /obj/item/flashlight/flare/torch/lantern/malchem(get_turf(user)))
	playsound(loc, 'sound/magic/swap.ogg', 100, TRUE, -2)
	to_chat(user, span_notice("The draught condenses [flame_cost] entropic dust into a Malchem Fyre. (Remaining Value: [stored_value])"))
	update_icon()

/obj/item/matthios_canister/firstlaw/proc/resolve_serum(mob/user)
	if(stored_value < serum_cost)
		to_chat(user, span_warning("There is not enough stored entropic dust to create this. ([serum_cost] required)"))
		return

	var/list/serums = list()
	for(var/serum_type in subtypesof(/obj/item/matthios_canister))
		if(ispath(serum_type, type)) // skip ourselves and anything derived from us
			continue
		var/obj/item/matthios_canister/S = serum_type
		serums[initial(S.name)] = serum_type
	if(!serums.len)
		to_chat(user, span_warning("The First Law knows no such draught forms."))
		return

	var/serum_choice = tgui_input_list(user, "What shall the First Law translate to? ([serum_cost] required)", "First Law", serums)
	if(!serum_choice || !do_after(user, 2 SECONDS, target = user, same_direction = TRUE))
		return
	if(QDELETED(src) || QDELETED(user) || stored_value < serum_cost)
		return

	stored_value -= serum_cost
	var/serum_path = serums[serum_choice]
	var/obj/item/matthios_canister/serum = new serum_path(get_turf(user))
	give_item(user, serum)
	playsound(loc, 'sound/magic/swap.ogg', 100, TRUE, -2)
	to_chat(user, span_notice("The draught condenses [serum_cost] entropic dust into [serum]. (Remaining Value: [stored_value])"))
	update_icon()

/obj/item/matthios_canister/firstlaw/proc/resolve_stones(mob/user)
	var/batch_size = 2 + (user.get_skill_level(/datum/skill/magic/holy) * 2)
	to_chat(user, span_notice("You release the concept of value into a more... solid shape."))

	while(stored_value > 0)
		if(!do_after(user, 1 SECONDS, target = user))
			break
		if(QDELETED(src) || QDELETED(user))
			return
		var/count = min(batch_size, stored_value)
		var/turf/T = get_turf(user)
		for(var/i in 1 to count)
			new /obj/item/natural/stone(T)
		stored_value -= count
		playsound(user.loc, 'sound/misc/smelter_sound.ogg', 20, FALSE)

	to_chat(user, span_notice("The First Law loosens its grip... <br>(Remaining Value: [stored_value])"))
	update_icon()
	if(stored_value <= 0)
		playsound(get_turf(user), 'sound/foley/glassbreak.ogg', 50, TRUE)
		funny_smoke(src)
		qdel(src)

/obj/item/matthios_canister/firstlaw/proc/resolve_coinage(mob/user)
	var/turf/T = get_turf(user)
	var/level = user.get_skill_level(/datum/skill/magic/holy)
	var/efficiency = min(100, 20 + (level * 20))
	var/result = round(stored_value * (efficiency / 100))
	if(result <= 0)
		to_chat(user, span_warning("There is not enough value stored to yield a single coin at your mastery."))
		return

	new /obj/effect/temp_visual/barter_fx(T)
	playsound(T, 'sound/effects/matth_barter.ogg', 100, TRUE)
	if(level <= SKILL_LEVEL_JOURNEYMAN && prob(60 - (level * 10)))
		var/tax = rand(2, 10)
		to_chat(user, span_warning("Matthios claims His due... (1/[tax] lost)"))
		result = round(result - (result / tax))
	if(result > 0)
		budget2change(result, user, putinhands = FALSE, custom_turf = T)

	to_chat(user, span_notice("The First Law concludes. [stored_value] value → [result] coin ([efficiency]% efficiency)."))
	funny_smoke(src)
	qdel(src)

//////////////////////
//Vial of Kingsfeast//
//Uses up to 6 organic items and converts them into 1 lavish food of choice. It can fail and become bread or worse.

/obj/item/matthios_canister/kingsfeast
	name = "vial of kingsfeast base"
	desc = "The brew within sloshes thick as spoiled blood. A stench rises from it most foul, resembling a mixture of rot and brine. The very vapours of said tincture can dissolve organic matter."
	max_ingredients = 6
	required_ingredients = list(
		/obj/item/alch/sinew,
		/obj/item/natural/bone,
		/obj/item/natural/bundle/bone,
		/obj/item/natural/fibers,
		/obj/item/natural/bundle/fibers,
		/obj/item/reagent_containers/powder/salt,
		/obj/item/reagent_containers/food,
	)
	ingredient_colors = list(
		/obj/item/alch/sinew = "#a84a4a",
		/obj/item/natural/bone = "#e8e2cf",
		/obj/item/natural/bundle/bone = "#e8e2cf",
		/obj/item/natural/fibers = "#007e1f",
		/obj/item/natural/bundle/fibers = "#007e1f",
		/obj/item/reagent_containers/powder/salt = "#f0f0f0",
		/obj/item/reagent_containers/food = "#d67a4a",
	)

/obj/item/matthios_canister/kingsfeast/freeman_truth()
	return "A primal tincture of eld. Organic matter is stripped to its nutritional and experiential essence, then reshaped into perfected sustenance. It does not cook; it transforms under one law which governs its malchemations: 'Thou greed shalt feed.' It'll be wise to have a sufficiently rich hoard before trying it."

/obj/item/matthios_canister/kingsfeast/freeman_progress(mob/user)
	var/remaining = max_ingredients - inserted_ingredients.len
	return remaining <= 0 ? "The feast is ready to take form." : "It needs [remaining] more organic offerings."

/obj/item/matthios_canister/kingsfeast/attackby(obj/item/I, mob/user)
	insert_ingredient(I, user, "The canister refuses to take more. It is... full.", expand_bundles = TRUE)
	return TRUE

/obj/item/matthios_canister/kingsfeast/attack_self(mob/user)
	if(!matthios_only(user, "This is worthless junk."))
		return
	if(inserted_ingredients.len < max_ingredients)
		to_chat(user, span_warning("It is not yet ready."))
		return
	to_chat(user, span_notice("The mixture churns expectantly, awaiting the weight of your greed..."))
	alch_transform(user)

/// Name -> path of every finished dish of the given fare. safe_only drops raw/rotten/burned eating effects.
/obj/item/matthios_canister/kingsfeast/proc/get_foods(fare, safe_only = FALSE)
	var/static/list/blacklisted_words = list("slab of", "unfinished", "half-done", "base", "unbaked", "venison", "deadite", "pale", "slice", "dough", "butterdough", "piece", "bottom", "raw", "uncooked", "minced", "clove", "medicinal", "royal")
	var/list/foods = list()
	for(var/food_path in subtypesof(/obj/item/reagent_containers/food/snacks/rogue))
		if(length(subtypesof(food_path))) // only leaf types are finished dishes
			continue
		var/obj/item/reagent_containers/food/snacks/rogue/F = food_path
		if(initial(F.faretype) != fare)
			continue
		if(safe_only && (initial(F.eat_effect) in list(/datum/status_effect/debuff/uncookedfood, /datum/status_effect/debuff/rotfood, /datum/status_effect/debuff/burnedfood)))
			continue
		var/food_name = LOWER_TEXT(initial(F.name))
		var/blacklisted = FALSE
		for(var/word in blacklisted_words)
			if(findtextEx(food_name, word))
				blacklisted = TRUE
				break
		if(!blacklisted)
			foods[initial(F.name)] = food_path
	return foods

/obj/item/matthios_canister/kingsfeast/alch_transform(mob/user)
	var/holy = user.get_skill_level(/datum/skill/magic/holy)
	to_chat(user, span_notice("You begin channeling your greed into the mixture..."))
	if(!do_after(user, 25, src))
		return

	if(prob(20)) // Unreliable, of course.
		to_chat(user, span_warning("The mixture ignites violently, collapsing into useless slag and bitter disappointment. It... technically is edible. I guess?"))
		new /obj/item/reagent_containers/food/snacks/badrecipe(get_turf(src))
		funny_smoke(src)
		qdel(src)
		return

	var/discount = holy >= SKILL_LEVEL_EXPERT ? 0.5 : 1
	var/list/fare_options = list( // name = list(fare, mammon needed)
		"Impoverished" = list(FARE_IMPOVERISHED, 0),
		"Poor" = list(FARE_POOR, 50 * discount),
		"Neutral" = list(FARE_NEUTRAL, 100 * discount),
		"Fine" = list(FARE_FINE, 200 * discount),
		"Lavish" = list(FARE_LAVISH, 400 * discount),
	)
	var/selected_fare = tgui_input_list(user, "What fare shall your greed take?", "Kingsfeast", fare_options)
	if(!selected_fare)
		return
	var/list/fare_data = fare_options[selected_fare]

	if(get_mammons_in_atom(user) + SStreasury.get_balance(user) < fare_data[2])
		var/list/fallback = get_foods(FARE_IMPOVERISHED, TRUE)
		fallback["bread"] = /obj/item/reagent_containers/food/snacks/rogue/bread
		var/fallback_type = fallback[pick(fallback)]
		var/obj/item/reagent_containers/food/snacks/rogue/fallback_food = new fallback_type(get_turf(src))
		to_chat(user, span_warning("Your greed is weak and lacking. The mixture simplifies itself into [fallback_food.name]."))
		funny_smoke(src)
		qdel(src)
		return

	var/list/foods = get_foods(fare_data[1])
	if(!foods.len)
		to_chat(user, span_warning("The mixture cannot find a suitable dish for this fare."))
		return
	var/choice = tgui_input_list(user, "What form shall your greed take?", "Kingsfeast", foods)
	if(!choice)
		return

	var/result_type = foods[choice]
	new result_type(get_turf(src))
	to_chat(user, span_notice("The mixture responds to your greed, shaping and taking the desired form. It feels warm and tasty!"))
	funny_smoke(src)
	qdel(src)

//////////////////////
//Vial of Goodnite  //
//////////////////////

/obj/item/matthios_canister/goodnite
	name = "vial of goodnite base"
	desc = "A dim, cloudy fluid rests inside, barely moving. Occasionally, something viscous streaks through it— like diluted brain matter. The glass feels warm, almost comforting. Staring at too long makes your eyelids heavy, and you get an odd compulsion to drink it."
	max_ingredients = 5
	result_path = /obj/item/alchserum/matthios_goodnite
	finish_message = "The mixture settles into a perfectly still, somnolent state."
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
	insert_ingredient(I, user, "The vial will accept no more. It rests at perfect equilibrium.")
	return TRUE

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

	qdel(src) // spent immediately so it can't be reused during the delays below
	to_chat(user, span_notice("The vial dulls and crumbles away."))
	playsound(user.loc, 'sound/misc/smelter_sound.ogg', 50, FALSE)
	to_chat(target, span_notice("A heavy calm overtakes your body..."))
	sleep(5)
	if(QDELETED(target))
		return
	target.visible_message(span_notice("[target.name] suddenly goes limp, overtaken by unnatural sleep."))
	target.SetSleeping(600)
	target.SetUnconscious(0)
	target.stat = UNCONSCIOUS

	spawn()
		while(!QDELETED(target) && target.IsSleeping())
			target.energy_add(50)
			if(target.nutrition > 0)
				target.adjustBruteLoss(-2)
				target.adjustFireLoss(-2)
			if(target.hydration > 0)
				target.adjustOxyLoss(-4)
				target.adjustToxLoss(-2)
			sleep(50)

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
	to_chat(user, span_notice(target == user ? "You begin administering the vial to your own forehead..." : "You begin administering the vial to [target.name]'s forehead..."))
	if(do_after(user, 6 SECONDS, target))
		apply_firstlaw_insight(target, user)

/obj/item/alchserum/matthios_insight/proc/apply_firstlaw_insight(mob/living/carbon/human/T, mob/user)
	if(T.get_skill_level(/datum/skill/craft/alchemy) <= 0)
		T.adjust_skillrank_up_to(/datum/skill/craft/alchemy, SKILL_LEVEL_NOVICE, TRUE)
		to_chat(T, span_notice("For a fleeting moment, the principles of transmutation become clear. You have become more proficient in Alchemy!"))
	else
		to_chat(T, span_notice("For a fleeting moment, the principles of transmutation become clear... But you soon realize those are just the basics!"))

	qdel(src)
	playsound(T.loc, 'sound/misc/smelter_sound.ogg', 50, FALSE)
	sleep(30)
	if(QDELETED(T))
		return
	to_chat(T, span_artery("<i>...Huh?</i>"))
	sleep(30)
	if(QDELETED(T))
		return
	to_chat(T, span_danger("--The Law's purest essence reveals itself. In nature, nothing is given, nothing is lost. Everything is transformed."))
	T.Knockdown(30)
	T.adjustBruteLoss(125)
	T.adjustFireLoss(150)
	explosion(get_turf(T), light_impact_range = 1, flame_range = 2, smoke = FALSE, adminlog = FALSE)

//////////////////////
//Vial of Warsmith  //
//////////////////////

/obj/item/matthios_canister/warsmith
	name = "vial of warsmith base"
	desc = "A biting liquor gnaws within the vial, as though it would eat iron itself. Flecks of metal drift and vanish, then return as if unmade and remade. It reeks of rust and sharp ruin. No forge would suffer this thing near its works."
	result_path = /obj/item/alchserum/matthios_warsmith
	finish_message = "The mixture hardens, then liquefies into an amorphous, perfect balance of fiber and steel."
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

/// Whether the canister still has room for this kind of ingredient
/obj/item/matthios_canister/warsmith/proc/needs(obj/item/I)
	if(istype(I, /obj/item/needle))
		return !has_needle
	if(istype(I, /obj/item/natural/fibers) || istype(I, /obj/item/natural/bundle/fibers))
		return current_fibers < needed_fibers
	return current_scrap < needed_scrap

/obj/item/matthios_canister/warsmith/attackby(obj/item/I, mob/user)
	if(!matthios_only(user))
		return TRUE
	if(!is_ingredient(I))
		to_chat(user, span_warning("This does not belong in the canister."))
		return TRUE
	if(!needs(I))
		to_chat(user, span_warning("The mixture will take no more of that."))
		return TRUE
	if(!do_after(user, 2 SECONDS) || QDELETED(I) || !needs(I))
		return TRUE

	var/consume = TRUE
	if(istype(I, /obj/item/needle))
		has_needle = TRUE
		to_chat(user, span_notice("The needle dissolves into fine metallic thread."))
	else if(istype(I, /obj/item/natural/bundle/fibers))
		var/obj/item/natural/bundle/fibers/B = I
		var/taken = min(B.amount, needed_fibers - current_fibers)
		current_fibers += taken
		if(taken < B.amount) // leave the remainder in the bundle
			B.amount -= taken
			B.update_icon()
			consume = FALSE
		to_chat(user, span_notice("You feed [taken] measure\s of fiber into the mixture. ([current_fibers]/[needed_fibers])"))
	else if(istype(I, /obj/item/natural/fibers))
		current_fibers++
		to_chat(user, span_notice("The fiber is reduced and drawn into the mixture. ([current_fibers]/[needed_fibers])"))
	else
		current_scrap++
		to_chat(user, span_notice("You feed scrap into the mixture. ([current_scrap]/[needed_scrap])"))

	var/new_color = ingredient_color(I)
	if(new_color)
		current_color = new_color
	if(consume)
		qdel(I)
	playsound(user.loc, 'sound/misc/smelter_sound.ogg', 50, FALSE)
	update_icon()
	check_completion(user)
	return TRUE

/obj/item/matthios_canister/warsmith/check_completion(mob/user)
	if(current_scrap >= needed_scrap && has_needle && current_fibers >= needed_fibers)
		alch_transform(user)

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

	if(--uses > 0)
		to_chat(user, span_notice("The mixture settles, awkwardly. You estimate [uses] uses remain."))
		return
	to_chat(user, span_warning("The vial burns out, its contents fully spent."))
	playsound(user.loc, 'sound/misc/smelter_sound.ogg', 50, FALSE)
	qdel(src)

//////////////////////
//Vial of Kingswine //
//////////////////////

/obj/item/matthios_canister/kingswine
	name = "vial of kingswine base"
	desc = "A foul slurry churns within the glass, thick with rot and sugared decay. It smells of spoiled fruit left in gutters and something far worse beneath it... coppery, clinging, wrong. No proper alchemist would name this craft; it is theft of nature."
	var/needed_liquid = 10
	var/current_liquid = 0
	/// "blood" or "wine" once chosen
	var/brew = null
	var/static/list/water_turfs = list(
		/turf/open/water/river,
		/turf/open/water/cleanshallow,
		/turf/open/water/pond,
		/turf/open/water/ocean,
		/turf/open/water/swamp,
	)
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
	switch(brew)
		if("blood")
			return "The path of Kingsblood is set. The vial now craves richer, vital inputs such as blood, viscera, even organs... refining them into a draught of a potent coagulant, or darker indulgence for the ashen ones."
		if("wine")
			return "A true miracle of Malchemy! Like the old tale of 'water to wine', this stands as proof that where miracles or alchemy begin, Malchem Arts had already long, long walked."
	return "A simple base, eager to take on character. It accepts liquids, fruits, anything with juice… though, one notes, blood is a liquid as well."

/obj/item/matthios_canister/kingswine/freeman_progress(mob/user)
	return "Progress: [current_liquid]/[needed_liquid]\nPath: [brew ? uppertext(brew) : "UNFORMED"]"

/// Whether the canister may take this brew from the user (path not clashing, enough divine insight for blood)
/obj/item/matthios_canister/kingswine/proc/accepts_brew(new_brew, mob/user, refusal)
	if(brew && brew != new_brew)
		to_chat(user, span_warning(refusal))
		return FALSE
	if(new_brew == "blood" && user.get_skill_level(/datum/skill/magic/holy) < SKILL_LEVEL_JOURNEYMAN)
		to_chat(user, span_warning("I lack the divine insight to work with this. It'll only ruin the tincture if I try."))
		return FALSE
	return TRUE

/obj/item/matthios_canister/kingswine/proc/add_liquid(amount, new_brew, new_color, mob/user, message)
	brew = new_brew
	current_color = new_color
	current_liquid = min(current_liquid + amount, needed_liquid)
	to_chat(user, span_notice("[message] ([current_liquid]/[needed_liquid])"))
	update_icon()
	check_completion(user)

/obj/item/matthios_canister/kingswine/attackby(obj/item/I, mob/user)
	if(!matthios_only(user))
		return TRUE
	if(current_liquid >= needed_liquid)
		to_chat(user, span_warning("The mixture will take no more."))
		return TRUE

	if(istype(I, /obj/item/organ) || istype(I, /obj/item/alch/viscera))
		if(accepts_brew("blood", user, "The mixture rejects this. It has already chosen sweetness over blood.") && do_after(user, 2 SECONDS) && !QDELETED(I))
			qdel(I)
			playsound(user.loc, 'sound/misc/lava_death.ogg', 50, FALSE)
			add_liquid(1, "blood", "#5c0a0a", user, "The meaty component dissolves into a thick slurry.")
	else if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit))
		if(accepts_brew("wine", user, "The mixture curdles. It refuses sweetness now.") && do_after(user, 2 SECONDS) && !QDELETED(I))
			qdel(I)
			playsound(user, pick(GLOB.da_bubbles), 30, FALSE)
			add_liquid(1, "wine", "#9c3b1f", user, "The mixture ferments the offering.")
	else if(istype(I, /obj/item/reagent_containers/glass))
		var/obj/item/reagent_containers/glass/R = I
		if(!R.reagents?.total_volume)
			to_chat(user, span_warning("It holds nothing to extract."))
			return TRUE
		var/has_blood = FALSE
		for(var/datum/reagent/rg in R.reagents.reagent_list)
			if(rg.name in list("Blood", "Dirty blood", "Liquid gibs"))
				has_blood = TRUE
				break
		var/new_brew = has_blood ? "blood" : "wine"
		if(!accepts_brew(new_brew, user, has_blood ? "The mixture recoils from blood." : "It demands only blood now."))
			return TRUE
		var/amount = min(20, R.reagents.total_volume)
		if(do_after(user, 2 SECONDS))
			R.reagents.remove_any(amount)
			add_liquid(clamp(round(amount / 10), 1, 2), new_brew, has_blood ? "#5c0a0a" : "#7a1f1f", user, "The mixture siphons [amount] doses of liquid.")
	else
		to_chat(user, span_warning("This does not belong in the canister."))
	return TRUE

/obj/item/matthios_canister/kingswine/attack(atom/target, mob/user)
	if(!ishuman(target))
		return ..()
	if(!matthios_only(user))
		return TRUE
	if(current_liquid >= needed_liquid)
		to_chat(user, span_warning("The mixture is already complete."))
		return TRUE

	var/mob/living/carbon/human/H = target
	if(!accepts_brew("blood", user, "The mixture refuses flesh now."))
		return TRUE
	if(!H.get_bleed_rate())
		to_chat(user, span_warning("There is no blood to take."))
		return TRUE
	for(var/antag in list(/datum/antagonist/vampire, /datum/antagonist/skeleton, /datum/antagonist/zombie, /datum/antagonist/zizo_knight, /datum/antagonist/werewolf, /datum/antagonist/gnoll))
		if(H.mind?.has_antag_datum(antag))
			to_chat(user, span_warning("Not your finest choice of blood for this. It won't work, even by the impossible Malchemical standards."))
			return TRUE

	if(do_after(user, 2 SECONDS, target = H))
		draw_blood(H, user, "[user] presses a vial at their open wound, filling it a bit.", "[user] presses a vial at [H]'s open wound, filling it a bit.")
		add_liquid(1, "blood", "#5c0a0a", user, "The mixture drinks from the wound.")
	return TRUE

/obj/item/matthios_canister/kingswine/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(!proximity_flag || !isturf(target) || current_liquid >= needed_liquid || !matthios_only(user))
		return
	var/blood_water = istype(target, /turf/open/water/bloody)
	if(!blood_water && !is_type_in_list(target, water_turfs))
		return
	var/new_brew = blood_water ? "blood" : "wine"
	if(!accepts_brew(new_brew, user, blood_water ? "The mixture recoils... This is not the path it chose." : "The mixture rejects the water, already tainted by blood."))
		return
	user.visible_message(blood_water ? span_danger("[user] dips a vial into [target], and it greedily fills.") : span_notice("[user] dips a vial into [target], and it greedily fills."))
	add_liquid(needed_liquid, new_brew, blood_water ? "#5c0a0a" : "#7a2f1b", user, blood_water ? "The mixture greedily devours the blood water." : "The mixture eagerly drinks from the boundless waters.")

/obj/item/matthios_canister/kingswine/check_completion(mob/user)
	if(current_liquid < needed_liquid || !brew)
		return
	result_path = brew == "wine" ? /obj/item/reagent_containers/glass/bottle/rogue/wine : /obj/item/alchserum/matthios_kingsblood
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
	if(user?.mind?.has_antag_datum(/datum/antagonist/vampire) || HAS_TRAIT(user, TRAIT_ORGAN_EATER))
		. += span_warning("TIP: You could drink this instead of applying it. Aim for your mouth and use it on yourself.")

/obj/item/alchserum/matthios_kingsblood/attack(mob/living/carbon/human/target, mob/living/user)
	if(!istype(target))
		return ..()

	var/is_vampire = target.mind?.has_antag_datum(/datum/antagonist/vampire)
	var/drink = target == user && user.zone_selected == BODY_ZONE_PRECISE_MOUTH && (is_vampire || HAS_TRAIT(target, TRAIT_ORGAN_EATER))
	if(!drink && !target.get_bleed_rate())
		to_chat(user, span_warning("[target] is not bleeding. The tincture finds nothing to mend."))
		return TRUE
	if(!do_after(user, 2 SECONDS, target = target))
		return TRUE

	if(drink)
		if(is_vampire)
			to_chat(target, span_notice("It tastes like very old wine... Rich, deep, and impossibly satisfying~"))
			target.adjust_bloodpool(75)
			target.apply_status_effect(/datum/status_effect/buff/vitae)
		else
			to_chat(target, span_notice("It tastes like old wine... Strange, but not entirely unpleasant."))
		target.visible_message(span_notice("[target] drinks from [src]."))
		playsound(user, 'sound/misc/drink_blood.ogg', 100)
	else
		target.visible_message(span_notice("[user] applies [src] to [target]'s wounds."), span_notice("The tincture seeps into the flesh, cold and invasive..."))
		target.blood_volume = min(target.blood_volume + round(BLOOD_VOLUME_NORMAL * 0.2), BLOOD_VOLUME_NORMAL)
		to_chat(target, span_warning("Something sloshes around your wounds, forcing them to coagulate. The bleeding stops."))
	for(var/datum/wound/W as anything in target.get_wounds())
		if(W?.bleed_rate > 0)
			W.set_bleed_rate(0)

	if(--uses > 0)
		to_chat(user, span_notice("The tincture settles uneasily. You estimate [uses] uses remain."))
		return TRUE
	to_chat(user, span_warning("The vial empties, its contents spent."))
	playsound(user.loc, 'sound/misc/smelter_sound.ogg', 50, FALSE)
	qdel(src)
	return TRUE

//EQUIPPABLES
/obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gilded
	name = "ornate amulet of Matthios"
	desc = "He was ever the one to make you ask questions: Why are we still here? Just to suffer? Nae. We are here to make a change. And a change we shall make, together."
	icon_state = "matthios"
	resistance_flags = FIRE_PROOF
	slot_flags = ITEM_SLOT_NECK | ITEM_SLOT_RING
	smeltresult = /obj/item/natural/ash
	aura_color = "#ffe761"
	is_important = TRUE // so this can't be sold in the navigator lol!!
	var/stolen_fyre = FALSE
	var/grant_chant = FALSE
	var/active_item = FALSE
	var/swap_type = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gilded/astrata
	var/swap_message = "The gilded amulet transmutates to a different form. You feel a smile, as you profane Her fyre the same way as He did."

/obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gilded/proc/swap_form(mob/living/carbon/human/user)
	var/obj/item/new_amulet = new swap_type(user.loc)
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
	if(!HAS_TRAIT(user, TRAIT_FREEMAN) || !do_after(user, 1 SECONDS))
		return
	playsound(user.loc, 'sound/magic/swap.ogg', 25, TRUE, -2)
	if(findtext(LOWER_TEXT(name), "ruined"))
		to_chat(user, span_warning("[src] crumbles into ash in your hands."))
		new /obj/item/natural/ash(get_turf(src))
		qdel(src)
		return
	to_chat(user, span_warning(swap_message))
	swap_form(user)

/obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gilded/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_SUSPICIOUS, HERESYDESC_MATTHIOS_ICON)

/obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gilded/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(obj_broken || active_item)
		return
	if((slot == SLOT_NECK || slot == SLOT_RING) && user.patron && (user.patron.type in ALL_INHUMEN_PATRONS))
		if(!stolen_fyre && HAS_TRAIT(user, TRAIT_FREEMAN))
			user.change_stat(STATKEY_LCK, 1, "matthios_boldness")
		active_item = TRUE
		if(user.has_language(/datum/language/thievescant))
			to_chat(user, span_info("You already know Thieves' Cant, but praise be Matthios anyway!"))
			return
		to_chat(user, span_info("You gain insight on Thieves' Cant.<br><br><i>Keep in mind these are 'words' that come out as gestures, so blend it between normal speech to make it not so obvious.<br><font color=yellow>(Prefix: ,y)</font></i>"))
		user.grant_language(/datum/language/thievescant)
		grant_chant = TRUE

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

/obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gilded/astrata
	name = "ornate amulet of Astrata"
	desc = "Her command is absolute, and Her tyranny is unmarrable. Reclaim this world, child of mine, from those who'd seek to destroy it."
	icon_state = "astrata_g"
	aura_color = null
	swap_type = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gilded
	swap_message = "The gilded amulet settles back into familiar weight. You feel a grin, as He commends you for your boldness."
	stolen_fyre = TRUE

/obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gilded/astrata/get_examine_highlight_status()
	return null

/obj/item/clothing/gloves/roguetown/fingerless_leather/muffle_matthios
	name = "gilded fingerless gloves"
	desc = "Those who grasp at Fyre, are bound to be burned."
	sewrepair = TRUE
	armor = ARMOR_LEATHER
	color = "#fce517" // we golden
	aura_color = "#fff385"
	is_important = TRUE // so this can't be sold in the navigator lol!!
	unarmed_bonus = 10 // better than steel, worse than blacksteel, shitty durability
	unarmed_weapon_effects = TRUE
	equip_delay_self = 2 SECONDS // COMMIT
	unequip_delay_self = 2 SECONDS
	var/active_item = FALSE

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
	body_parts_covered = FULL_HEAD
	flags_inv = HIDEFACE
	flags_cover = HIDEFACE
	attachable = FALSE

/obj/item/clothing/mask/rogue/spectacles/duelist/matthios/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/adjustable_clothing/matthicat, FULL_HEAD, 0, 0, null, null, (UPD_HEAD|UPD_MASK))

/obj/item/clothing/mask/rogue/spectacles/duelist/matthios/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if((slot == SLOT_WEAR_MASK || slot == SLOT_HEAD) && HAS_TRAIT(user, TRAIT_FREEMAN))
		user.apply_status_effect(/datum/status_effect/buff/matthios_vision)

/obj/item/clothing/mask/rogue/spectacles/duelist/matthios/dropped(mob/living/carbon/human/user)
	. = ..()
	user.remove_status_effect(/datum/status_effect/buff/matthios_vision)

/datum/component/adjustable_clothing/matthicat

/datum/component/adjustable_clothing/matthicat/toggle_open(obj/item/clothing/C, forced = FALSE)
	. = ..()
	if(ishuman(C.loc))
		var/mob/living/carbon/human/user = C.loc
		user.remove_status_effect(/datum/status_effect/buff/matthios_vision)

/datum/component/adjustable_clothing/matthicat/toggle_closed(obj/item/clothing/C, forced = FALSE)
	. = ..()
	if(!ishuman(C.loc))
		return
	var/mob/living/carbon/human/user = C.loc
	if((C in list(user.wear_mask, user.head)) && HAS_TRAIT(user, TRAIT_FREEMAN))
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
	var/static/list/halluc_lines = list("This sight was not made for me.","I can feel my thoughts peeling apart.","The world looks wrong.","I should remove this.","My mind recoils from what it sees.","Too much truth presses inward.","Matthios, is this true?!","Matthios, is this TRVE?!","I regret everything.","Something broke.","DAFUQ?","What is that?!","What is this?!","Where am I??","I see it clearly now.","The truth is fine. Everything is fine.","I'm fine... I'm fine... I'm fine...","I can see Matthios. He is grinning.","I can see Astrata. She is furious.","Is this right?","What is wrong?","Behind me.","Behind you.","Free is watching you.","Grand Liege...?","La li lu le lo?","There are too many angles here.","Why does the floor have veins?","I can hear colors.","The walls know my name.","This was hidden for a reason.","I understand less each second.","The shadows are explaining things.","Who moved the horizon?","The stars are too close.","My teeth feel observant.","Why is the silence screaming?","I looked too far.","Everything has a second face.","The room blinked.","Truth tastes metallic.","I can smell geometry.","Someone is standing inside my reflection.","I should not know this.","The corners are whispering.","I remember tomorrow.","My heartbeat is counting backwards.","Why are there footprints on the ceiling?","The light is lying.","There is another sky above this one.","Numbers keep crawling away.","The door was never a door.","I have too many hands.","Did the world always breathe?","I can see where prayers go.","Something old just noticed me.","The dust is watching.","My bones disagree.","Reality feels temporary.","I found the seam.","Don't turn around.","Too late.","I was always behind me.")

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
	var/holyLV = C.get_skill_level(/datum/skill/magic/holy)
	var/weightedLV = (holyLV * 0.80) + (C.get_skill_level(/datum/skill/misc/lockpicking) * 0.20)
	var/halluc_chance = clamp(100 - (weightedLV * (100 / 6)), 0, 100)

	if(holyLV < SKILL_LEVEL_EXPERT)
		if(prob(halluc_chance) && C.hallucination < 400)
			C.hallucination = min(400, C.hallucination + rand(5, 15))
			to_chat(C, span_warning(pick(halluc_lines)))
			C.Jitter(5)
		if(prob(30))
			C.emote(pick("breathgasp", "shiver", "groan", "whimper", "pain", "sigh", "giggle", "laugh", "cackle"))
			C.Jitter(10)
	if(holyLV < SKILL_LEVEL_JOURNEYMAN && prob(25))
		C.adjustFireLoss(rand(1, 15))

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
	is_important = TRUE
	var/active_item = FALSE

/obj/item/clothing/shoes/roguetown/boots/muffle_matthios/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(active_item || slot != SLOT_SHOES || !HAS_TRAIT(user, TRAIT_FREEMAN))
		return
	active_item = TRUE
	to_chat(user, span_info("Like Him, I slink into the shadows."))
	ADD_TRAIT(user, TRAIT_SILENT_FOOTSTEPS, "matthios_boots")
	ADD_TRAIT(user, TRAIT_LIGHT_STEP, "matthios_boots")
	ADD_TRAIT(user, TRAIT_FREERUNNING, "matthios_boots")
	user.change_stat(STATKEY_SPD, 1, "matthios_boots")

/obj/item/clothing/shoes/roguetown/boots/muffle_matthios/dropped(mob/living/carbon/human/user)
	. = ..()
	if(!active_item || !istype(user))
		return
	active_item = FALSE
	to_chat(user, span_info("Once again, I am under Her gaze."))
	REMOVE_TRAIT(user, TRAIT_SILENT_FOOTSTEPS, "matthios_boots")
	REMOVE_TRAIT(user, TRAIT_LIGHT_STEP, "matthios_boots")
	REMOVE_TRAIT(user, TRAIT_FREERUNNING, "matthios_boots")
	user.change_stat(STATKEY_SPD, 0, "matthios_boots")

/obj/item/clothing/shoes/roguetown/boots/muffle_matthios/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_MATTHIOS_ARMOR) //These were always meant to be valid I don't get why this was forgotten about

//THROWABLES
//I'll leave it as an admin spawnable cause why not, but as is right now there's no way anything can get access to this.
/obj/item/explosive/impact/truthsnuke
	name = "TRUTHSNUKE"
	desc = "A fragile canister, filled with an explosive surprise. Shards of flint line its thin sleeve, aching to ignite at the slightest disturbance. It glows with a divine might, and once again stolen fire."
	aura_color = "#fbff00"
	/// Radius in which mobs are judged and the land is razed
	var/nukerange = 15
	/// Radius in which mobs are flung outwards
	var/fling = 12
	var/lightrange = 10
	var/flamerange = 15

/obj/item/explosive/impact/truthsnuke/lesser
	name = "Incomplete TRUTHSNUKE"
	desc = "A fragile canister, filled with an explosive surprise. Shards of flint line its thin sleeve, aching to ignite at the slightest disturbance. The fire of Astrata does not seem to be imbuing it, but..."
	nukerange = 3
	fling = 3
	lightrange = 4
	flamerange = 8

/obj/item/explosive/impact/truthsnuke/blast(turf/T, forced)
	// Affect mobs
	for(var/mob/living/target in range(nukerange, T))

		if(QDELETED(target))
			continue

/obj/item/lockpick/gilded
	name = "gilded lockpick"
	desc = "A lockpick that glimmers with an unmistakable sheen of tempered gold. You feel watched by an unseen force while holding this."
	icon_state = "lockpick"
	icon = 'icons/roguetown/items/keys.dmi'
	w_class = WEIGHT_CLASS_TINY
	color = "#fff89d"
	aura_color = "#ffe75e"
	dropshrink = 0.75
	throwforce = 0
	max_integrity = 10
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_MOUTH|ITEM_SLOT_NECK
	destroy_sound = 'sound/items/pickbreak.ogg'
	resistance_flags = FIRE_PROOF
	associated_skill = /datum/skill/misc/lockpicking
	always_destroy = TRUE
	grid_width = 32
	grid_height = 64
	var/using = FALSE
	/// The jawbank must hold more than this before it can be plundered
	var/bank_floor = 500
	/// name = list(item path, devotion cost, mammon cost, cooldown). The names double as the cooldown keys.
	var/static/list/vault_tools = list(
		"Return Tool" = null,
		"Smuggling Bag - 100 Devotion, 10 Mammon" = list(/obj/item/storage/backpack/rogue/satchel/beltpack/matthios, 100, 10, 5 MINUTES),
		"Gilded Dexterous Gloves - 400 Devotion, 10 Mammon" = list(/obj/item/clothing/gloves/roguetown/fingerless_leather/muffle_matthios, 400, 10, 5 MINUTES),
		"Gilded Muffled Boots - 250 Devotion, 10 Mammon" = list(/obj/item/clothing/shoes/roguetown/boots/muffle_matthios, 250, 10, 5 MINUTES),
		"Gilded Lockpicking Specs - 500 Devotion, 10 Mammon" = list(/obj/item/clothing/mask/rogue/spectacles/duelist/matthios, 500, 10, 10 MINUTES),
		"Gilded Chains - 50 Devotion, 10 Mammon" = list(/obj/item/rope/chain/matthios, 50, 10, 2 MINUTES),
		"Gilded Amulet of Matthios - 50 Devotion, 10 Mammon" = list(/obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gilded, 50, 10, 30 SECONDS),
	)

/obj/item/lockpick/gilded/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_MATTHIOS_RELIC)

/obj/item/lockpick/gilded/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))

/// Dropping it on the floor destroys it
/obj/item/lockpick/gilded/proc/on_moved()
	if(isturf(loc))
		qdel(src)

/obj/item/lockpick/gilded/attack_self(mob/living/user)
	if(using || !ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(!HAS_TRAIT(H, TRAIT_FREEMAN))
		to_chat(H, span_warning("The gilded lockpick refuses your hand."))
		return
	var/datum/action/cooldown/spell/matthios/freemans_tools/freeman_tools = locate(/datum/action/cooldown/spell/matthios/freemans_tools) in H.actions
	if(!freeman_tools)
		to_chat(H, span_warning("The gilded lockpick has no connection to Matthios' vault."))
		return

	using = TRUE
	open_vault(H, freeman_tools)
	if(!QDELETED(src))
		using = FALSE

/obj/item/lockpick/gilded/proc/open_vault(mob/living/carbon/human/H, datum/action/cooldown/spell/matthios/freemans_tools/freeman_tools)
	H.visible_message(span_notice("[H] inserts the gilded lockpick into thin air, twisting an invisible lock..."), span_notice("You feel around for an unseen lock, turning the gilded lockpick until you hear a faint click."))
	if(!do_after(H, 2 SECONDS) || QDELETED(src))
		return

	var/choice = tgui_input_list(H, "Choose something to borrow from Matthios' vault.", "Matthios' Vault", vault_tools)
	if(!choice || QDELETED(src) || QDELETED(H))
		return
	if(choice == "Return Tool")
		return_tool(H, freeman_tools)
		return

	var/list/selection = vault_tools[choice]
	var/devotion_cost = selection[2]
	var/mammon_cost = selection[3]
	var/cooldown_end = freeman_tools.item_cooldowns[choice]
	if(cooldown_end > world.time)
		to_chat(H, span_warning("Your gilded loan is still in effect. Try again in [DisplayTimeText(cooldown_end - world.time)]."))
		return
	if(H.devotion?.devotion < devotion_cost)
		H.visible_message(span_notice("The portal rudely closes!"), span_notice("Your connection to the Free God is too faint to ask for this favor."))
		return

	H.visible_message(span_notice("[H] rummages through a mysterious golden portal that suddenly appeared..."), span_notice("You rummage through Matthios' vault, searching for \the [choice]."))
	// Pay only once the delay has succeeded, so a cancelled attempt costs nothing
	if(!do_after(H, 2 SECONDS) || QDELETED(src) || QDELETED(H) || QDELETED(freeman_tools) || freeman_tools.item_cooldowns[choice] > world.time)
		return
	if(remove_debt_mammon(H, mammon_cost) < mammon_cost)
		H.visible_message(span_notice("The portal rudely closes!"), span_notice("You lack the Mammon to tithe for His attention."))
		return

	H.devotion.update_devotion(-devotion_cost)
	var/reward_path = selection[1]
	H.put_in_hands(new reward_path(H.drop_location()))
	freeman_tools.item_cooldowns[choice] = world.time + selection[4]
	qdel(src)

/// Refunds a vault tool held in the other hand. Only vault items qualify.
/obj/item/lockpick/gilded/proc/return_tool(mob/living/carbon/human/H, datum/action/cooldown/spell/matthios/freemans_tools/freeman_tools)
	var/obj/item/tool = H.get_inactive_held_item()
	var/from_vault = FALSE
	for(var/name in vault_tools)
		var/list/selection = vault_tools[name]
		if(selection && istype(tool, selection[1]))
			from_vault = TRUE
			break
	if(!tool || tool == src || !from_vault)
		to_chat(H, span_warning("You have no vault tool in your other hand to return."))
		return

	H.visible_message(span_notice("[H] stuffs \the [tool] through a mysterious golden portal..."), span_notice("You rummage through Matthios' vault, returning up \the [tool]."))
	if(!do_after(H, 1 SECONDS) || QDELETED(src) || QDELETED(tool) || H.get_inactive_held_item() != tool)
		return
	qdel(tool)

	var/skill = H.get_skill_level(freeman_tools.associated_skill)
	if(skill < SKILL_LEVEL_JOURNEYMAN)
		to_chat(H, span_warning("NO REFUNDS!!"))
		return
	var/full_refund = skill > SKILL_LEVEL_JOURNEYMAN
	H.put_in_hands(full_refund ? new /obj/item/roguecoin/gold(H.drop_location()) : new /obj/item/roguecoin/silver(H.drop_location()))
	to_chat(H, span_warning(full_refund ? "The FREE GOD is most generous! Full refund!" : "The FREE GOD is most generous! A small refund!"))

/obj/item/lockpick/gilded/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(using || !proximity_flag)
		return
	if(!istype(target, /obj/structure/roguemachine/vaultbank))
		return ..()
	using = TRUE
	rob_bank(target, user)
	using = FALSE

/obj/item/lockpick/gilded/proc/rob_bank(obj/structure/roguemachine/vaultbank/J, mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(!HAS_TRAIT(H, TRAIT_FREEMAN))
		to_chat(H, span_warning("What the hell am I supposed to do with this?"))
		return
	var/datum/fund/F = J.get_linked_fund()
	if(!F)
		to_chat(H, span_warning("[J] has no treasury to plunder."))
		return
	if(F.balance <= bank_floor)
		to_chat(H, span_warning("[J] is too devoid of mammon for this trickery to work."))
		return

	var/skill = H.get_skill_level(/datum/skill/magic/holy)
	H.visible_message(span_warning("[H] begins working the gilded lockpick into [J]'s mechanisms."), span_notice("You carefully work the gilded lockpick into the JAWBANK's mechanisms."))
	if(!do_after(H, max(1 SECONDS, 5 SECONDS - (skill * 1 SECONDS)), J) || QDELETED(src) || QDELETED(J))
		return

	F = J.get_linked_fund() // may have changed during the delay
	var/bashable = F ? max(0, F.balance - bank_floor) : 0
	if(bashable <= 0)
		to_chat(H, span_warning("The JAWBANK has nothing left to surrender."))
		return

	var/taken = min(rand(25, 100), bashable)
	budget2change(taken, custom_turf = get_turf(J))
	SStreasury.burn(F, taken, "!GI$%#!LD$%%$ED T##$HEF¨%#T!!")
	H.visible_message(span_danger("The gilded lockpick clicks inside [J], and [taken] mammon spills loose!"), span_notice("You feel the lock give. [taken] mammon spills from the JAWBANK."))
	if(skill < SKILL_LEVEL_JOURNEYMAN)
		playsound(J, 'sound/misc/coindispense.ogg', 70, TRUE)
		if(prob(50))
			J.anguish()
		if(prob(50))
			J.announce_robbery(taken)

	J.total_extorted += taken
	J.hits_since_lump += 1
	J.update_icon()

/obj/item/lockpick/gilded/equipped(mob/user, slot)
	. = ..()
	if(ishuman(user) && user.get_skill_level(/datum/skill/magic/holy) >= SKILL_LEVEL_EXPERT)
		ADD_TRAIT(user, TRAIT_SILENT_LOCKPICK, "[REF(src)]")

/obj/item/lockpick/gilded/dropped(mob/user)
	if(ishuman(user))
		REMOVE_TRAIT(user, TRAIT_SILENT_LOCKPICK, "[REF(src)]")
	return ..()
