/obj/structure/statue
	name = "statue"
	desc = ""
	icon_state = ""
	density = TRUE
	anchored = FALSE
	max_integrity = 100
	var/oreAmount = 5
	var/material_drop_type
	var/impressiveness = 15
	CanAtmosPass = ATMOS_PASS_DENSITY
	var/art_type = /datum/component/art

/obj/structure/statue/Initialize(mapload)
	. = ..()
	AddComponent(art_type, impressiveness)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/datum, _AddComponent), /datum/component/beauty, impressiveness *  75), 0)

/obj/structure/statue/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		if(material_drop_type)
			var/drop_amt = oreAmount
			if(!disassembled)
				drop_amt -= 2
			if(drop_amt > 0)
				new material_drop_type(get_turf(src), drop_amt)
	qdel(src)
