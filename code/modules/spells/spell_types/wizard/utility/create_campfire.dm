/obj/effect/proc_holder/spell/invoked/create_campfire
	name = "Create Campfire"
	desc = "Creates a magical campfire to cook on. 3 tiles range. Lasts for 10 minutes."
	overlay_state = "create_campfire"
	sound = list('sound/magic/whiteflame.ogg')

	releasedrain = 30
	chargedrain = 1
	chargetime = 3 SECONDS
	no_early_release = TRUE
	recharge_time = 60 SECONDS

	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	antimagic_allowed = FALSE
	charging_slowdown = 3
	cost = 1
	range = 3
	spell_tier = 1 // Utility, with situational combat use. Great for fighting trolls..
	ignore_los = FALSE

	invocations = list("Ignis Castrensis Magicae.") // Literally "Magical Campfire"
	invocation_type = "shout"
	glow_color = GLOW_COLOR_FIRE
	glow_intensity = GLOW_INTENSITY_LOW

	var/fire_type = /obj/machinery/light/rogue/campfire/create_campfire

// Conjure spell type is not reusable cuz it don't respect invocation so special code it is
/obj/effect/proc_holder/spell/invoked/create_campfire/cast(list/targets, mob/user = usr)
	var/turf/target = get_turf(targets[1])

	if(!target || !target.Enter(user) || istransparentturf(target))
		to_chat(user, "<span class='warning'>This turf can't be on fiyaaaah! (It's blocked sire.)</span>")
		revert_cast()
		return
	new /obj/machinery/light/rogue/campfire/create_campfire(target)

	return TRUE

/obj/machinery/light/rogue/campfire/create_campfire
	name = "magical campfire"
	icon_state = "densefire1"
	base_state = "densefire"
	density = FALSE
	layer = 2.8
	brightness = 7
	fueluse = 10 MINUTES
	color = "#6ab2ee"
	bulb_colour = "#6ab2ee"
	max_integrity = 30
	var/lifespan = 10 MINUTES

/obj/machinery/light/rogue/campfire/create_campfire/Initialize()
	. = ..()
	if(lifespan)
		QDEL_IN(src, lifespan) //delete after it runs out
