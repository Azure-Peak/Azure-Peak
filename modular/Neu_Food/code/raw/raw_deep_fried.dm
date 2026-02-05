/obj/item/reagent_containers/food/snacks/rogue/foodbase/nitzel
	name = "unfinished nitzel"
	desc = "Tenderized meat, awaiting a coating of toastcrumbs and a hot oil bath."
	icon = 'modular/Neu_Food/icons/raw/raw_deep_fried.dmi'
	icon_state = "nitzel_step1"
	process_step = 1
	cooked_smell = /datum/pollutant/food/fried_meat

/obj/item/reagent_containers/food/snacks/rogue/foodbase/nitzel/attackby(obj/item/I, mob/living/user, params)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/egg))
		if(process_step != 1)
			return
		to_chat(user, span_notice("Cracking an egg over the nitzel."))
		if(do_after(user, short_cooktime, target = src))
			playsound(get_turf(user), 'modular/Neu_Food/sound/eggbreak.ogg', 100, TRUE, -1)
			name = "nitzel with egg"
			desc = "A nitzel with an egg cracked over it. It awaits toastcrumbs and a hot oil bath."
			icon_state = "nitzel_step2"
			process_step = 2
			update_icon()
			qdel(I)
			return
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/toastcrumbs))
		if(process_step != 2)
			return
		to_chat(user, span_notice("Coating the nitzel with toastcrumbs."))
		if(do_after(user, short_cooktime, target = src))
			name = "nitzel with toastcrumbs"
			desc = "A nitzel coated in toastcrumbs. It awaits a hot oil bath."
			icon_state = "nitzel_step3"
			process_step = 3
			deep_fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/nitzel
			update_icon()
			qdel(I)
			return
	return ..()

/obj/item/reagent_containers/food/snacks/rogue/foodbase/schnitzel
	name = "schnitzel"
	desc = "Tenderized spider meat, awaiting a coating of toastcrumbs and a hot oil bath."
	icon = 'modular/Neu_Food/icons/raw/raw_deep_fried.dmi'
	icon_state = "schnitzel_step1"
	process_step = 1
	cooked_smell = /datum/pollutant/food/fried_meat

// copy paste code to shame my ancestors (some1 refactor this)
/obj/item/reagent_containers/food/snacks/rogue/foodbase/schnitzel/attackby(obj/item/I, mob/living/user, params)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/egg))
		if(process_step != 1)
			return
		to_chat(user, span_notice("Cracking an egg over the schnitzel."))
		if(do_after(user, short_cooktime, target = src))
			playsound(get_turf(user), 'modular/Neu_Food/sound/eggbreak.ogg', 100, TRUE, -1)
			name = "schnitzel with egg"
			desc = "A schnitzel with an egg cracked over it. It awaits toastcrumbs and a hot oil bath."
			icon_state = "schnitzel_step2"
			process_step = 2
			update_icon()
			qdel(I)
			return
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/toastcrumbs))
		if(process_step != 2)
			return
		to_chat(user, span_notice("Coating the schnitzel with toastcrumbs."))
		if(do_after(user, short_cooktime, target = src))
			name = "schnitzel with toastcrumbs"
			desc = "A schnitzel coated in toastcrumbs. It awaits a hot oil bath."
			icon_state = "schnitzel_step3"
			process_step = 3
			deep_fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/nitzel/schnitzel
			update_icon()
			qdel(I)
			return
	return ..()

// Squire's delight (deep fried butter)
/obj/item/reagent_containers/food/snacks/rogue/foodbase/squires_delight
	name = "unfinished squire's delight"
	desc = "A butter stick with an egg cracked over it. It awaits toastcrumbs and a hot oil bath."
	icon = 'modular/Neu_Food/icons/raw/raw_deep_fried.dmi'
	icon_state = "squiresdelight_step1"
	process_step = 1
	cooked_smell = /datum/pollutant/food/fried_butter

/obj/item/reagent_containers/food/snacks/rogue/foodbase/squires_delight/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/toastcrumbs))
		if(process_step != 1)
			return
		to_chat(user, span_notice("Coating the butter with toastcrumbs."))
		if(do_after(user, short_cooktime, target = src))
			name = "squire's delight with toastcrumbs"
			desc = "A butter stick coated in toastcrumbs. It awaits a hot oil bath."
			icon_state = "squiresdelight_step2"
			process_step = 2
			deep_fried_type = /obj/item/reagent_containers/food/snacks/squiresdelight
			update_icon()
			qdel(I)
			return

/obj/item/reagent_containers/food/snacks/rogue/foodbase/chickentender
	name = "unfinished tender frybird"
	desc = "Tenderized meat, awaiting a coating of toastcrumbs and a hot oil bath."
	icon = 'modular/Neu_Food/icons/raw/raw_deep_fried.dmi'
	icon_state = "chickentender_step1"
	process_step = 1
	cooked_smell = /datum/pollutant/food/fried_chicken

/obj/item/reagent_containers/food/snacks/rogue/foodbase/chickentender/attackby(obj/item/I, mob/living/user, params)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/egg))
		if(process_step != 1)
			return
		to_chat(user, span_notice("Cracking an egg over the nitzel."))
		if(do_after(user, short_cooktime, target = src))
			playsound(get_turf(user), 'modular/Neu_Food/sound/eggbreak.ogg', 100, TRUE, -1)
			name = "tender frybird with egg"
			desc = "A frybard with an egg cracked over it. It awaits toastcrumbs and a hot oil bath."
			icon_state = "chickentender_step2"
			process_step = 2
			update_icon()
			qdel(I)
			return
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/toastcrumbs))
		if(process_step != 2)
			return
		to_chat(user, span_notice("Coating the nitzel with toastcrumbs."))
		if(do_after(user, short_cooktime, target = src))
			name = "tender frybird with toastcrumbs"
			desc = "A frybird coated in toastcrumbs. It awaits a hot oil bath."
			icon_state = "chickentender_step3"
			process_step = 3
			deep_fried_type = /obj/item/reagent_containers/food/snacks/rogue/meat/nitzel
			update_icon()
			qdel(I)
			return
	return ..()
