#define IRONHIDE_FILTER "ironhide_glow"

/datum/status_effect/buff/ironhide
	id = "ironhide"
	alert_type = /atom/movable/screen/alert/status_effect/buff/ironhide
	duration = -1
	effectedstats = list(STATKEY_CON = 1)
	var/outline_colour = "#8a97a8"

/atom/movable/screen/alert/status_effect/buff/ironhide
	name = "Ironhide"
	desc = "A lattice of arcyne iron sheathes my body, turning aside thrusts that would slip past lesser wards."

/datum/status_effect/buff/ironhide/on_apply()
	. = ..()
	var/filter = owner.get_filter(IRONHIDE_FILTER)
	if(!filter)
		owner.add_filter(IRONHIDE_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 40, "size" = 1))

/datum/status_effect/buff/ironhide/on_remove()
	. = ..()
	owner.remove_filter(IRONHIDE_FILTER)

#undef IRONHIDE_FILTER

/datum/action/cooldown/spell/conjure_arcyne_ward/ironhide
	name = "Conjure Ironhide Ward"
	desc = "Conjure an ironhide ward - an upgraded arcyne ward imitating iron, hardened especially against thrusts and points. \
	Grants plate-tier defense against cuts and thrusts, but like real plate it does little against blunt force. Frailer than steel would be, with only 200 integrity. \
	Shatters violently when broken, knocking back nearby foes. \
	Otherwise functions as a standard arcyne ward - yields coverage to real armor, does not regenerate. \
	Cast again to dismiss. Cooldown begins when dismissed or destroyed."
	button_icon_state = "conjure_dragonhide"
	spell_color = GLOW_COLOR_METAL
	invocations = list("Ferri Congrego!")
	dismiss_invocation = "Ferri Dissipo!"
	regen_invocation = "Ferri Restauro!"
	charge_time = 6 SECONDS
	point_cost = 4
	spell_tier = 3
	exclusive_group = "arcyne_ward"
	ward_type = /obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/ironhide
	regen_spell_type = /datum/action/cooldown/spell/regenerate_arcyne_ward/ironhide

/datum/action/cooldown/spell/regenerate_arcyne_ward/ironhide
	name = "Regenerate Ironhide Ward"
	spell_tier = 3

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/ironhide
	name = "ironhide ward"
	desc = "An arcyne ward plated with conjured iron. Turns aside cuts and thrusts like a suit of plate, but blunt force still tells. Shatters violently when broken."
	armor = ARMOR_PLATE
	max_integrity = 200
	ward_color = GLOW_COLOR_METAL
	arcyne_armor_tier = ARCYNE_WARD_TIER_GREATER

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/ironhide/setup_ward(mob/living/carbon/human/H)
	..()
	H.apply_status_effect(/datum/status_effect/buff/ironhide)

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/ironhide/cleanup_ward()
	if(ward_owner)
		ward_owner.remove_status_effect(/datum/status_effect/buff/ironhide)
	..()

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/ironhide/obj_break()
	if(ward_owner)
		blast_back(ward_owner)
	..()

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/ironhide/proc/blast_back(mob/living/wearer)
	if(!wearer)
		return
	for(var/mob/living/target in oview(1, wearer))
		var/throwtarget = get_edge_target_turf(wearer, get_dir(wearer, get_step_away(target, wearer)))
		target.safe_throw_at(throwtarget, 2, 1, wearer, spin = FALSE, force = MOVE_FORCE_EXTREMELY_STRONG)
		target.adjustBruteLoss(20)
