/datum/intent/spear/bash/staff
	name = "staff bash"
	damfactor = 1
	reach = 2

/datum/intent/spear/bash/ranged/quarterstaff
	damfactor = 1

/datum/intent/spear/thrust/quarterstaff
	blade_class = BCLASS_BLUNT
	hitsound = list('sound/combat/hits/blunt/bluntsmall (1).ogg', 'sound/combat/hits/blunt/bluntsmall (2).ogg')
	penfactor = PEN_NONE
	damfactor = 1.3 // Adds up to be slightly stronger than an unenhanced ebeak strike.
	clickcd = CLICK_CD_CHARGED

/obj/item/rogueweapon/woodstaff
	force = 10
	force_wielded = 15
	possible_item_intents = list(SPEAR_BASH)
	gripped_intents = list(/datum/intent/spear/bash/ranged, /datum/intent/mace/smash/wood/ranged)
	name = "wooden staff"
	desc = "A solid dependable walking stick that allows one to traverse rough terrain with ease, keep the weight off an \
	injured leg, or reliably fend off incoming blows. Perfect for beggars, pilgrims, and mages."
	icon_state = "woodstaff"
	icon = 'icons/roguetown/weapons/polearms64.dmi'
	wlength = WLENGTH_LONG
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	sharpness = IS_BLUNT
	walking_stick = TRUE
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	wdefense = 5
	wdefense_wbonus = 6	//11 when wielded.
	bigboy = TRUE
	gripsprite = TRUE
	associated_skill = /datum/skill/combat/staves
	special = /datum/special_intent/quarterstaff_sweep
	anvilrepair = /datum/skill/craft/carpentry
	resistance_flags = FLAMMABLE
	twirly = SKILL_LEVEL_JOURNEYMAN

/obj/item/rogueweapon/woodstaff/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -6,"sy" = -1,"nx" = 8,"ny" = 0,"wx" = -4,"wy" = 0,"ex" = 2,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 32,"eturn" = -23,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 4,"sy" = -2,"nx" = -3,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/woodstaff/wise
	name = "wise staff"
	desc = "A staff for keeping the volves at bay..."

/obj/item/rogueweapon/woodstaff/aries // more humble with no aura
	name = "staff of the shepherd"
	desc = "A finely wrought bishop's crozier crowned with the likeness of a shepherd watching over his flock. Its curved head serves as a reminder that a true shepherd does not rule through fear, but through guidance, mercy, and unwavering vigilance. To the faithful it is a symbol of humble service; to the lost, a promise that even the stray may yet find their way home."
	force = 25
	force_wielded = 28
	icon_state = "aries"
	icon = 'icons/roguetown/weapons/polearms64.dmi'
	associated_skill = /datum/skill/magic/holy
	sellprice = 240
	pixel_y = -22
	pixel_x = -22
	possible_item_intents = list(SPEAR_BASH, /datum/intent/bless)
	gripped_intents = list(/datum/intent/spear/bash/ranged, /datum/intent/mace/smash/wood/ranged, /datum/intent/bless)

/obj/item/rogueweapon/woodstaff/aries/icarus // more boisterous with aura
	name = "staff of the guide"
	desc = "A radiant staff crowned by a lavish, pure gold-forged sun whose rays stretch in every direction. It embodies the sacred duty to bring light where darkness lingers, offering wisdom to the faithful and hope to the despairing. More than a mark of rank, it stands as a beacon that calls others to walk the righteous path beneath the ever-watchful eyes of the Ten."
	icon_state = "icarus"
	aura_color = "#ffed9f"

/obj/item/rogueweapon/woodstaff/aries/afterattack(atom/movable/A, mob/user, proximity)
	. = ..()

	if(user.mind?.assigned_role != "Bishop")
		to_chat(user, span_warning("The staff sizzles against my hand!"))
		user.emote("pain")
		return

	if(user.used_intent?.type != /datum/intent/bless)
		return

	// people
	if(ishuman(A))
		var/mob/living/carbon/human/H = A

		if(H.has_status_effect(/datum/status_effect/buff/blessed) || H.has_stress_event(/datum/stressevent/blessed_evil) || H.has_stress_event(/datum/stressevent/blessed_neutral))
			to_chat(user, span_warning("[H] has already been blessed."))
			return

		playsound(user, 'sound/magic/censercharging.ogg', 100)
		user.visible_message(span_info("[user] holds \the [src] over \the [H], offering a solemn blessing..."))

		if(!do_after(user, 50, target = H))
			return

		if(H.patron?.type in ALL_INHUMEN_PATRONS)
			to_chat(H, span_boldred("You feel the Ten's blessings weigh upon your soul."))
			H.add_stress(/datum/stressevent/blessed_evil)
		else if(H.patron?.type in OLD_GOD_PATRON)
			to_chat(H, span_hypnophrase("You feel the Ten's blessings reluctantly settle upon your soul."))
			H.add_stress(/datum/stressevent/blessed_neutral)
		else
			to_chat(H, span_hypnophrase("You feel the Ten's blessings settle upon your soul."))
			H.apply_status_effect(/datum/status_effect/buff/blessed)
			H.add_stress(/datum/stressevent/blessed)

		playsound(H, 'sound/magic/bless.ogg', 100)
		new /obj/effect/temp_visual/censer_dust(get_turf(H))
		user.visible_message(span_blue("[user] blesses [H]."))
		return

	// silver items
	if(isitem(A))
		var/obj/item/I = A
		var/datum/component/silverbless/CP = I.GetComponent(/datum/component/silverbless)

		if(!CP)
			to_chat(user, span_info("\The [I] cannot be blessed."))
			return

		if(CP.is_blessed)
			to_chat(user, span_info("It has already been blessed."))
			return

		if(!(CP.silver_type & SILVER_TENNITE))
			to_chat(user, span_info("\The [I] cannot receive Tennite blessings."))
			return

		playsound(user, 'sound/magic/censercharging.ogg', 100)
		user.visible_message(span_info("[user] holds \the [src] over \the [I]..."))

		if(!do_after(user, 5 SECONDS, target = I))
			return

		CP.try_bless(BLESSING_TENNITE)
		new /obj/effect/temp_visual/censer_dust(get_turf(I))
		return

/obj/item/rogueweapon/woodstaff/aries/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -6,"sy" = -1,"nx" = 8,"ny" = 0,"wx" = -4,"wy" = 0,"ex" = 2,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 32,"eturn" = -23,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 4,"sy" = -2,"nx" = -3,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)

/obj/item/churcharticles/litany
	name = "litany of the Ten"
	desc = "A finely illuminated parchment of litany bearing the sacred verses of the Holy See. Penned upon blessed parchment and sealed with crimson wax, it contains the Rite of Endorsement, a solemn invocation entrusted only to ordained bishops. Once the final verse is spoken, the parchment burns to ash, and one of the Ten's sacred croziers is called forth. Don't lose it."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "litany"
	item_state = "litany"
	aura_color = "#ffed9f"
	var/in_use = FALSE

/obj/item/churcharticles/litany/attack_self(mob/user)
	. = ..()
	if(!ishuman(user))
		return
	if(in_use)
		to_chat(user, span_warning("The litany is already being recited."))
		return
	in_use = TRUE
	user.visible_message(span_boldwarning("[user] unfurls [src], raising it high before beginning a solemn rite."))
	if(!do_after(user, 25, target = user))
		in_use = FALSE
		return
	user.say(",g Before the Holy Ten, I reaffirm the sacred vows laid upon my soul.")
	if(!do_after(user, 25, target = user))
		in_use = FALSE
		return
	user.say(",g May I serve with humility, wisdom, and unwavering faith.")
	if(!do_after(user, 25, target = user))
		in_use = FALSE
		return
	user.say(",g Let my voice be Yours in counsel.")
	if(!do_after(user, 25, target = user))
		in_use = FALSE
		return
	user.say(",g Let my hand be Yours in mercy.")
	if(!do_after(user, 25, target = user))
		in_use = FALSE
		return
	user.say(",g Let my office stand as testament to the covenant between the Holy See and the faithful.")
	if(!do_after(user, 25, target = user))
		in_use = FALSE
		return
	user.say(",g Should I yet prove worthy in Your sight, grant unto me a sacred staff, wrought by the grace of the Holy Ten, that I may bear it as the symbol of the authority entrusted to me.")
	var/choice = tgui_alert(user, "Which of the Ten's staves do you invoke?", "RITE OF THE TEN", list("Staff of the Shepherd", "Staff of the Guide", "Cancel"))
	if(!choice || choice == "Cancel")
		in_use = FALSE
		return
	var/obj/item/rogueweapon/woodstaff/aries/staff
	switch(choice)
		if("Staff of the Shepherd")
			staff = new /obj/item/rogueweapon/woodstaff/aries(get_turf(user))
		if("Staff of the Guide")
			staff = new /obj/item/rogueweapon/woodstaff/aries/icarus(get_turf(user))
	playsound(get_turf(user), 'sound/magic/holyshield.ogg', 100, FALSE)
	new /obj/effect/temp_visual/censer_dust(get_turf(user))
	user.visible_message(span_blue("As the final words leave [user]'s lips, [src] crumbles into sacred ash and [staff] manifests before them!"))
	qdel(src)

/obj/item/rogueweapon/woodstaff/quarterstaff
	name = "wooden quarterstaff"
	desc = "A staff that makes any journey easier. Durable and swift, capable of bludgeoning stray volves and ruffians alike. The prodigious length \
	permits it to both incapacitate the villainous with blunted strikes, and to keep snarling foes at staff's length."
	force = 15
	force_wielded = 20
	gripped_intents = list(/datum/intent/spear/bash/ranged/quarterstaff, /datum/intent/spear/thrust/quarterstaff, /datum/intent/mace/smash/wood/ranged)
	icon_state = "quarterstaff"
	associated_skill = /datum/skill/combat/staves
	max_integrity = 150
	smeltresult = /obj/item/ash

/obj/item/rogueweapon/woodstaff/quarterstaff/virtue
	name = "shepherd's quarterstaff" //Reskinned iron quarterstaff without the smeltability-into-ingotry.
	force = 16
	force_wielded = 22
	gripped_intents = list(/datum/intent/spear/bash/ranged/quarterstaff, /datum/intent/spear/thrust/quarterstaff, /datum/intent/mace/smash/wood/ranged)
	icon_state = "quarterstaff_virtue"
	max_integrity = 200

/obj/item/rogueweapon/woodstaff/quarterstaff/iron
	name = "iron quarterstaff"
	desc = "A quarterstaff reinforced with iron studdings and counterweights. The prodigious length \
	permits it to both incapacitate the villainous with blunted strikes, and to keep snarling foes at staff's length."
	force = 16
	force_wielded = 22
	icon_state = "quarterstaff_iron"
	max_integrity = 200
	smeltresult = /obj/item/ingot/iron

/obj/item/rogueweapon/woodstaff/quarterstaff/steel
	name = "steel quarterstaff"
	desc = "A quarterstaff reinforced with steel tips and steel rings, blurring the line between a light polehammer and a reinforced \
	quarterstaff. Extremely durable, and more than capable of bludgeoning brigands to death; or more mercifully, robbing them of their \
	very own tools."
	force = 18
	force_wielded = 25
	icon_state = "quarterstaff_steel"
	max_integrity = 200
	smeltresult = /obj/item/ingot/steel

/obj/item/rogueweapon/woodstaff/quarterstaff/steel/holysee
	name = "see quarterstaff"
	desc = "A decorated quarterstaff reinforced with metal with enough heft behind it to send deadites back into Necra's realm. \
	Exceedingly durable and capable it is favorite of many orders that forgo cladding themselves in steel."
	icon_state = "quarterstaff_see"
	max_integrity = 230

/obj/item/rogueweapon/woodstaff/quarterstaff/steel/astrata
	name = "solar scepter"
	desc = "A quarterstaff bearing the symbol of Astrata, Her rule given form in a scepter atop a reinforced shaft."
	icon_state = "quarterstaff_astrata"
	max_integrity = 230

/obj/item/rogueweapon/woodstaff/quarterstaff/steel/noc
	name = "lunar crescent"
	desc = "A quarterstaff bearing the symbol of Noc, His moonlight taken form atop a reinforced shaft."
	icon_state = "quarterstaff_noc"
	max_integrity = 230

/obj/item/rogueweapon/woodstaff/quarterstaff/blacksteel
	name = "blacksteel quarterstaff"
	desc = "A quarterstaff reinforced with blacksteel tips. One might imagine that the elegance of such a design hardly befits the people \
	who'd traditionally wield such a weapon; then again, who are we to judge?"
	force = 20
	force_wielded = 30
	icon_state = "quarterstaff_blacksteel"
	max_integrity = 350
	smeltresult = /obj/item/ingot/blacksteel
	wdefense_wbonus = 7	//12 when wielded.

/obj/item/rogueweapon/woodstaff/quarterstaff/silver
	name = "silver quarterstaff"
	desc = "A quarterstaff reinforced with silver tips. A relatively new design, purportedly inspired by the warstaffs oft-carried by Naledian \
	warscholars. Durable enough to catch-and-disarm avantyne to the shaft, without so much as a splinter - or so, they say."
	force = 20
	force_wielded = 27
	icon_state = "quarterstaff_silver"
	max_integrity = 250
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silver

/obj/item/rogueweapon/woodstaff/quarterstaff/silver/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 50,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/woodstaff/quarterstaff/psy
	name = "psydonic quarterstaff"
	desc = "A quarterstaff reinforced with silver tips. A relatively new design, purportedly inspired by the warstaffs \
	oft-carried by Naledian warscholars. Durable enough to catch avantyne to the shaft, without so much as a splinter - or so, they say."
	force_wielded = 27
	icon_state = "quarterstaff_silver"
	max_integrity = 250
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silverblessed

/obj/item/rogueweapon/woodstaff/quarterstaff/psy/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 50,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/woodstaff/quarterstaff/psy/preblessed/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 50,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/woodstaff/quarterstaff/gold
	name = "golden quarterstaff"
	desc = "The astute may point out that this staff is poorly designed. They would be correct. Gold, even low karat, is a bad material for a \
	weapon. This one additionally manages to be doubly-sinned by having a heavy chunk of gold at the end. It's almost a polehammer. Practical? \
	No. But it makes a statement."
	icon_state = "quarterstaff_gold"
	force = 23
	force_wielded = 30
	special = /datum/special_intent/gilded_dragon_sweep
	sellprice = 80
	no_loot_taint = TRUE
	max_integrity = 250 //equal to psydonite; putting it at half of this was a neat little experiment but agonizing

