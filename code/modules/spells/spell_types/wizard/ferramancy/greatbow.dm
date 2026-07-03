/datum/intent/shoot/bow/ferramancy
	name = "shoot"
	charging_slowdown = 4

/datum/intent/shoot/bow/ferramancy/arc
	name = "arc shot"
	desc = "Fires the shot in an arc that allows it to passes through mob in the way. Will also tracks the target IF you have your cursor over them. This also allows you to aims at a target above or below."
	icon_state = "inarc"
	charging_slowdown = 4

/datum/intent/shoot/bow/ferramancy/arc/arc_check()
	return TRUE

/datum/intent/shoot/bow/ferramancy/lance
	name = "lance"
	icon_state = "inlance"
	desc = "Fires a powerful, piercing arcyne lance that passes through mobs in the way indiscriminately, up to 5 of them without damage reduction."
	chargetime = 3 SECONDS
	no_early_release = TRUE
	charging_slowdown = 5

/obj/item/ammo_casing/caseless/rogue/arrow/iron/ferramancy
	name = "arcyne broadhead"
	color = GLOW_COLOR_ARCANE
	projectile_type = /obj/projectile/bullet/reusable/arrow/iron/ferramancy

/obj/projectile/bullet/reusable/arrow/iron/ferramancy
	color = GLOW_COLOR_ARCANE

/obj/projectile/bullet/reusable/arrow/iron/ferramancy/on_hit()
	. = ..()
	QDEL_NULL(dropped)

/obj/projectile/bullet/reusable/arrow/iron/ferramancy/handle_drop()
	QDEL_NULL(dropped)
	return

/obj/item/ammo_box/magazine/internal/shot/bow/ferramancy
	ammo_type = /obj/item/ammo_casing/caseless/rogue/arrow/iron/ferramancy
	start_empty = FALSE

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/greatbow
	name = "arcyne greatbow"
	desc = "A longbow of condensed arcyne light. It draws on the wielder's own energy in place of arrows, looses with a heavy and deliberate pull, and is far too unwieldy to fire on the move."
	color = GLOW_COLOR_ARCANE
	minstr = 0
	mag_type = /obj/item/ammo_box/magazine/internal/shot/bow/ferramancy
	spill_ammo_on_drop = FALSE
	possible_item_intents = list(
		/datum/intent/shoot/bow/ferramancy,
		/datum/intent/shoot/bow/ferramancy/arc,
		/datum/intent/shoot/bow/ferramancy/lance,
		INTENT_GENERIC,
		)
	var/reload_cost = 25
	var/lance_energy = 50
	var/held_slowdown = 2
	var/reload_time = 2 SECONDS
	var/reloading = FALSE
	var/lance_cooldown = 10 SECONDS
	COOLDOWN_DECLARE(lance_cd)

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/greatbow/Initialize()
	. = ..()
	chamber_round()

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/greatbow/equipped(mob/user, slot)
	. = ..()
	if(user.is_holding(src))
		user.add_movespeed_modifier("ferramancy_greatbow", TRUE, 100, override = TRUE, multiplicative_slowdown = held_slowdown)
	else
		user.remove_movespeed_modifier("ferramancy_greatbow")

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/greatbow/dropped(mob/user)
	. = ..()
	if(user)
		user.remove_movespeed_modifier("ferramancy_greatbow")

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/greatbow/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	if(istype(user.used_intent, /datum/intent/shoot/bow/ferramancy/lance))
		if(!COOLDOWN_FINISHED(src, lance_cd))
			balloon_alert(user, "Lance CD:[CEILING(COOLDOWN_TIMELEFT(src, lance_cd) * 0.1, 1)]s remaining")
			return FALSE
		if(user.energy < lance_energy)
			to_chat(user, span_warning("I haven't the arcyne energy to loose the lance!"))
			return FALSE
		user.energy_add(-lance_energy)
		COOLDOWN_START(src, lance_cd, lance_cooldown)
		fire_lance(target, user)
		return TRUE
	if(!chambered)
		if(!reloading)
			start_reload()
		to_chat(user, span_warning("My greatbow has not yet conjured its next arrow!"))
		return FALSE
	. = ..()
	if(!chambered && !reloading)
		start_reload()
	return .

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/greatbow/proc/fire_lance(atom/target, mob/living/user)
	user.Immobilize(1 SECONDS)
	playsound(get_turf(user), 'sound/magic/scrapeblade.ogg', 80, TRUE)
	var/obj/projectile/magic/arcyne_lance/greatbow/P = new(get_turf(user))
	P.firer = user
	P.preparePixelProjectile(target, user)
	P.fire()

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/greatbow/proc/start_reload()
	if(reloading)
		return
	reloading = TRUE
	addtimer(CALLBACK(src, PROC_REF(finish_reload)), reload_time)

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/greatbow/proc/finish_reload()
	if(QDELETED(src) || !magazine)
		reloading = FALSE
		return
	var/mob/living/holder = isliving(loc) ? loc : null
	if(holder && holder.energy < reload_cost)
		addtimer(CALLBACK(src, PROC_REF(finish_reload)), reload_time)
		return
	reloading = FALSE
	if(holder)
		holder.energy_add(-reload_cost)
	if(!chambered && !magazine.ammo_count())
		magazine.give_round(new /obj/item/ammo_casing/caseless/rogue/arrow/iron/ferramancy(magazine))
	chamber_round()
	update_icon()
	if(holder)
		playsound(loc, 'sound/foley/nockarrow.ogg', 50, TRUE)

