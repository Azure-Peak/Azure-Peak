/obj/item/natural/clay
	name = "clay"
	icon_state = "clay"     // Placeholder. TODO: Get an icon for clay.
	desc = "A handful of damp, malleable clay. When rolled out atop a potter's wheel, it can be sculpted into pots, cutlery, and statues."
	gripped_intents = null
	dropshrink = 0.75
	possible_item_intents = list(INTENT_GENERIC)
	force = 0
	throwforce = 0
	slot_flags = null
	obj_flags = null
	w_class = WEIGHT_CLASS_TINY
	var/cooked_type = /obj/item/natural/stone // What does this item turn into when glazed in a kiln?
											  // A regular clay lump just becomes an ordinary stone.
					// ...Possibly used to make bricks in a separate PR? Interesting way to integrate
					// the mason's construction work with the new Potter profession. - SunriseOYH

	var/cooking = 0 			// This variable measures the progress of the glazing act.
	var/cooktime = 1 MINUTES    // This dictates the time needed to glaze.
	var/burning = 0				// This variable measures the progress of the burning act
	var/burntime = 5 MINUTES	// How long must it be left unattended to burn and be ruined?
	var/burned_color = "#302d2d"

// '''Clay''' for making glass.
/obj/item/natural/clay/glassbatch
	name = "glass batch"
	icon_state = "glassBatch"
	desc = "A mixture of finely ground silica, flux and a stablizer. It glistens against the light, and could be turned into precious glass by a competent potter."
	smeltresult = /obj/item/natural/glass 	// Smelted in a furnace, like a ore.
	grind_results = list(/datum/reagent/iron = 15)
	sellprice = 5
	cooktime = 0
	burntime = 0

/obj/item/natural/clay/Initialize()
	if(cooked_type)
		cooktime = 30 SECONDS
	..() // The ..() refers to calling the parent class's (obj/item/natural) Initialize() proc.

/obj/item/natural/clay/cooking(input as num, burninput, atom/A) // I am using the same variable names from cooking
	if(!input)
		return
	if(cooktime)
		if(cooking < cooktime)
			cooking = cooking + input
			if(cooking >= cooktime)
				return heating_act(A)
			return
	burning(burninput)

/obj/item/natural/clay/heating_act(atom/A)
	var/obj/item/result
	if(istype(A,/obj/machinery/light/rogue/oven))
		if(cooked_type)
			result = new cooked_type(A)
		return result
	result = new /obj/item/ash(A) // No cooked_type? Pulverized.
	return result

/obj/item/natural/clay/burning(input as num) // Overrides the generic /obj/item/proc/burning in snacks.dm
	if(!input)
		return
	if(burntime)
		burning = burning + input
		if(burning >= burntime) // Left it glazing for too long. Right now, it only makes it ugly.
								// Maybe reduce selling price?
			color = burned_color
			name = "burnt [name]"
			desc = "It's dark and charred, but still functional."
		if(burning > (burntime * 2)) // Way too long. Incinerate.
			burn() // Burn is a method of obj/items that Qdels something and replaces it with ash.
