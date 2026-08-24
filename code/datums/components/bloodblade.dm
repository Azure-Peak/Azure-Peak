/datum/component/bloodblade // literally enchanted blade but it's for a set amount of hits
	dupe_mode = COMPONENT_DUPE_UNIQUE // To avoid weird filter override this is the way..
	var/counter = 0

/datum/component/bloodblade/Initialize(mapload)
	if(!istype(parent, /obj/item/rogueweapon))
		return COMPONENT_INCOMPATIBLE
	var/obj/item/I = parent

	coat(I)
	RegisterSignal(parent, COMSIG_ITEM_AFTERATTACK, PROC_REF(onhit))
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))

	addtimer(CALLBACK(src, PROC_REF(timeout)), 30 SECONDS)

/datum/component/bloodblade/proc/coat(obj/item/I)
	counter = 3
	I.force += 10
	I.force_wielded += 10
	I.update_force_dynamic()
	I.color = "#6b2828"
	I.add_filter("bloodblade", 2, list("type" = "outline", "color" = "#000000", "alpha" = 200, "size" = 1))
	return

/datum/component/bloodblade/proc/onhit(obj/item/I)
	if(counter > 1)
		counter -= 1
	else
		remove()
		qdel(src)

/datum/component/bloodblade/proc/remove()
	var/obj/item/I = parent
	I.force -= 10
	I.force_wielded -= 10
	I.update_force_dynamic()
	I.color = initial(I.color)
	I.remove_filter("bloodblade")
	return

/datum/component/bloodblade/proc/on_examine(datum/source, mob/user, list/examine_list)
	examine_list += span_red("It's covered in <font color='["#0e0e0e"]'>sickly, black vitae</font>!")

/datum/component/bloodblade/proc/timeout()
	remove()
	qdel(src)
	return
