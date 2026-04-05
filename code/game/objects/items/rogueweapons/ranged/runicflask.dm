#define TINCTURE_FIRE "fire"
// #define TINCTURE_FROST "frost" // Pending PR #6406 frost stack system
#define TINCTURE_THUNDER "thunder"
#define TINCTURE_KINETIC "kinetic"
#define TINCTURE_SPLINTER "splinter"

#define TINCTURE_MAX_CHARGES 20
#define TINCTURE_REFUEL_AMOUNT 20
#define TINCTURE_REFUEL_SKILL SKILL_LEVEL_JOURNEYMAN

/obj/item/runicflask
	name = "runic tincture flask"
	desc = "A miraculous flask inscribed with runic alchemical magic to convert primal alchemical matters into a solution that can be applied onto arrows and create elemental effects."
	icon = 'icons/roguetown/weapons/ranged/runicflask.dmi'
	icon_state = "runicflask_fire"
	item_state = "runicflask"
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_HIP
	sellprice = 15
	dropshrink = 0.6
	grid_width = 32
	grid_height = 32

	var/tincture_mode = TINCTURE_FIRE
	var/charges = 0

	var/static/list/tincture_modes = list(TINCTURE_FIRE, TINCTURE_THUNDER, TINCTURE_KINETIC, TINCTURE_SPLINTER)

	var/static/list/tincture_names = list(
		TINCTURE_FIRE = "Fire Tincture",
		TINCTURE_THUNDER = "Thunder Tincture",
		TINCTURE_KINETIC = "Kinetic Tincture",
		TINCTURE_SPLINTER = "Splinter Tincture",
	)

	var/static/list/tincture_arrow_types = list(
		TINCTURE_FIRE = /obj/item/ammo_casing/caseless/rogue/arrow/elemental/fire,
		TINCTURE_THUNDER = /obj/item/ammo_casing/caseless/rogue/arrow/elemental/thunder,
		TINCTURE_KINETIC = /obj/item/ammo_casing/caseless/rogue/arrow/elemental/kinetic,
		TINCTURE_SPLINTER = /obj/item/ammo_casing/caseless/rogue/arrow/elemental/splinter,
	)

	var/static/list/tincture_descs = list(
		TINCTURE_FIRE = "Coats arrows in a flammable tincture that ignites on impact.",
		TINCTURE_THUNDER = "Coats arrows in a crackling solution that sears with thunder.",
		TINCTURE_KINETIC = "Coats arrows in a volatile kinetic solution that blasts targets back.",
		TINCTURE_SPLINTER = "Coats arrows in a golden solution that shatters the head into a spread of three darts with low range but devastating damage up close.",
	)

	var/static/list/refuel_dust_types = list(
		/obj/item/alch/firedust,
		/obj/item/alch/infernaldust,
		/obj/item/alch/waterdust,
		/obj/item/alch/airdust,
		/obj/item/alch/coaldust,
	)

/obj/item/runicflask/examine(mob/user)
	. = ..()
	. += span_notice("Currently set to: <b>[tincture_names[tincture_mode]]</b>.")
	. += span_notice("[tincture_descs[tincture_mode]]")
	. += span_notice("Charges: [charges]/[TINCTURE_MAX_CHARGES].")
	. += span_info("Click to switch tincture mode. Click on a quiver to coat arrows.")
	. += span_info("Click elemental dust on the flask to refuel.")
	if(user.mind && user.get_skill_level(/datum/skill/craft/alchemy) >= SKILL_LEVEL_APPRENTICE)
		. += span_notice("The runes read: <i>Calcinate - Dissolve - Separate - Conjoin - Ferment.</i> A tincture cycle.")

/obj/item/runicflask/update_icon_state()
	icon_state = "runicflask_[tincture_mode]"

/obj/item/runicflask/attack_self(mob/living/user)
	var/list/choices = list()
	for(var/mode in tincture_modes)
		choices[tincture_names[mode]] = image(icon = src.icon, icon_state = "runicflask_[mode]")
	var/choice = show_radial_menu(user, src, choices, tooltips = TRUE)
	if(!choice)
		return
	for(var/mode in tincture_modes)
		if(tincture_names[mode] == choice)
			tincture_mode = mode
			update_icon_state()
			to_chat(user, span_notice("I switch the flask to [tincture_names[mode]]."))
			return

/obj/item/runicflask/attackby(obj/item/I, mob/living/user, params)
	var/is_dust = FALSE
	for(var/dust_type in refuel_dust_types)
		if(istype(I, dust_type))
			is_dust = TRUE
			break
	if(is_dust)
		if(!user.mind || user.get_skill_level(/datum/skill/craft/alchemy) < TINCTURE_REFUEL_SKILL)
			to_chat(user, span_warning("I don't understand the runes well enough to refuel this flask. I need more knowledge of alchemy."))
			return
		if(charges >= TINCTURE_MAX_CHARGES)
			to_chat(user, span_warning("The flask is already full!"))
			return
		charges = min(charges + TINCTURE_REFUEL_AMOUNT, TINCTURE_MAX_CHARGES)
		to_chat(user, span_notice("I pour the [I.name] into the flask. Charges: [charges]/[TINCTURE_MAX_CHARGES]."))
		playsound(src, 'sound/items/fillbottle.ogg', 80)
		qdel(I)
		return
	return ..()

/obj/item/runicflask/pre_attack(atom/target, mob/living/user, params)
	if(istype(target, /obj/item/quiver))
		coat_arrows_in_quiver(target, user)
		return TRUE
	if(istype(target, /obj/item/ammo_casing/caseless/rogue/arrow/iron))
		if(istype(target, /obj/item/ammo_casing/caseless/rogue/arrow/elemental))
			to_chat(user, span_warning("This arrow is already coated!"))
			return TRUE
		coat_single_arrow(target, user)
		return TRUE
	return ..()

/obj/item/runicflask/proc/coat_arrows_in_quiver(obj/item/quiver/Q, mob/living/user)
	if(charges <= 0)
		to_chat(user, span_warning("The flask is empty! Refuel it with elemental dust."))
		return

	if(!length(Q.arrows))
		to_chat(user, span_warning("The quiver is empty!"))
		return

	var/coatable_count = 0
	for(var/obj/item/ammo_casing/caseless/rogue/arrow/iron/A in Q.arrows)
		if(!istype(A, /obj/item/ammo_casing/caseless/rogue/arrow/elemental))
			coatable_count++

	if(!coatable_count)
		to_chat(user, span_warning("No iron broadhead arrows to coat!"))
		return

	var/max_coatable = min(coatable_count, charges)
	var/coat_count = tgui_input_number(user, "How many arrows to coat? ([max_coatable] available, [charges] charges remaining)", "Coat Arrows", max_coatable, max_coatable, 1)
	if(!coat_count || !user.canUseTopic(src, BE_CLOSE))
		return

	coat_count = clamp(coat_count, 1, max_coatable)

	to_chat(user, span_notice("I begin coating [coat_count] arrow\s..."))
	var/coated = 0
	for(var/obj/item/ammo_casing/caseless/rogue/arrow/iron/target_arrow in Q.arrows)
		if(istype(target_arrow, /obj/item/ammo_casing/caseless/rogue/arrow/elemental))
			continue
		if(coated >= coat_count)
			break
		if(charges <= 0)
			break
		if(!do_after(user, 0.5 SECONDS, src))
			break
		var/arrow_type = tincture_arrow_types[tincture_mode]
		var/obj/item/ammo_casing/caseless/rogue/arrow/elemental/new_arrow = new arrow_type(Q)
		Q.arrows -= target_arrow
		Q.arrows += new_arrow
		qdel(target_arrow)
		charges--
		coated++
		playsound(src, 'sound/items/fillbottle.ogg', 60)

	to_chat(user, span_notice("Coated [coated] arrow\s. [charges] charges remaining."))
	Q.update_icon()

/obj/item/runicflask/proc/coat_single_arrow(obj/item/ammo_casing/caseless/rogue/arrow/iron/target, mob/living/user)
	if(charges <= 0)
		to_chat(user, span_warning("The flask is empty!"))
		return
	to_chat(user, span_notice("I begin coating the arrow..."))
	if(!do_after(user, 1.5 SECONDS, target))
		return
	var/arrow_type = tincture_arrow_types[tincture_mode]
	var/obj/item/ammo_casing/caseless/rogue/arrow/elemental/new_arrow = new arrow_type(user.loc)
	user.transferItemToLoc(target, null)
	qdel(target)
	user.put_in_hands(new_arrow)
	charges--
	playsound(src, 'sound/items/fillbottle.ogg', 60)
	to_chat(user, span_notice("I coat the arrow with [tincture_names[tincture_mode]]. [charges] charges remaining."))

/obj/item/runicflask/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -7,"sy" = -5,"nx" = 8,"ny" = -5,"wx" = -4,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/runicflask/charged
	charges = 20

#undef TINCTURE_FIRE
// #undef TINCTURE_FROST // Pending PR #6406
#undef TINCTURE_THUNDER
#undef TINCTURE_KINETIC
#undef TINCTURE_SPLINTER
#undef TINCTURE_MAX_CHARGES
#undef TINCTURE_REFUEL_AMOUNT
#undef TINCTURE_REFUEL_SKILL
