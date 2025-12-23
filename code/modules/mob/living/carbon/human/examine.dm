/mob/living/carbon/human/proc/on_examine_face(mob/living/carbon/human/user)
	if(!istype(user))
		return
	if(user.mind)
		user.mind.i_know_person(src)
	if(user.has_flaw(/datum/charflaw/paranoid))	//We hate different species, that are stronger than us, and aren't racist themselves
		if(dna.species.name != user.dna.species.name && (STASTR - user.STASTR) > 1 && !has_flaw(/datum/charflaw/paranoid))
			user.add_stress(/datum/stressevent/parastr)
	if(HAS_TRAIT(user, TRAIT_JESTERPHOBIA) && job == "Jester")
		user.add_stress(/datum/stressevent/jesterphobia)
	if(HAS_TRAIT(src, TRAIT_BEAUTIFUL) && user != src)//it doesn't really make sense that you can examine your own face
		user.add_stress(/datum/stressevent/beautiful)
	if(HAS_TRAIT(src, TRAIT_UNSEEMLY) && user != src)
		if(!HAS_TRAIT(user, TRAIT_UNSEEMLY))
			user.add_stress(/datum/stressevent/unseemly)
	if(HAS_TRAIT(src, TRAIT_LEPROSY) && user != src)
		user.add_stress(/datum/stressevent/leprosy)
	if(HAS_TRAIT(src, TRAIT_BEAUTIFUL_UNCANNY) && user != src)
		if(prob(50) && !user.has_stress_event(/datum/stressevent/uncanny))
			user.add_stress(/datum/stressevent/beautiful)
		else
			if(!user.has_stress_event(/datum/stressevent/beautiful))
				user.add_stress(/datum/stressevent/uncanny)
	// Apply Xylix buff when examining someone with the beautiful trait
	if(HAS_TRAIT(user, TRAIT_XYLIX) && !user.has_status_effect(/datum/status_effect/buff/xylix_joy) && user.has_stress_event(/datum/stressevent/beautiful))
		user.apply_status_effect(/datum/status_effect/buff/xylix_joy)
		to_chat(user, span_info("Their beauty brings a smile to my face, and fortune to my steps!"))

/mob/living/carbon/human/examine(mob/user)
	var/observer_privilege = isobserver(user)
	var/t_He = p_they(TRUE)
	var/t_his = p_their()
//	var/t_him = p_them()
	var/t_has = p_have()
	var/t_is = p_are()
	var/obscure_name = FALSE
	var/race_name = "<a href='?src=[REF(src)];species_lore=1'><u>[dna.species.name]</u></A> "
	var/datum/antagonist/maniac/maniac = user.mind?.has_antag_datum(/datum/antagonist/maniac)
	var/datum/antagonist/skeleton/skeleton = user.mind?.has_antag_datum(/datum/antagonist/skeleton)
	if(maniac && (user != src))
		race_name = "disgusting pig"
	if(skeleton && (user != src))
		race_name = "[pick("shambling", "taut", "decrepit")]"

	var/m1 = "[t_He] [t_is]"
	var/m2 = "[t_his]"
	var/m3 = "[t_He] [t_has]"
	if(user == src)
		m1 = "I am"
		m2 = "my"
		m3 = "I have"

	if(isliving(user))
		var/mob/living/L = user
		if(HAS_TRAIT(L, TRAIT_PROSOPAGNOSIA))
			obscure_name = TRUE

	var/static/list/unknown_names = list(
		"Unknown",
		"Unknown Man",
		"Unknown Woman",
	)
	if(get_face_name() != real_name)
		obscure_name = TRUE

	if(observer_privilege)
		obscure_name = FALSE

	if(name in unknown_names)
		. = list(span_info("ø ------------ ø\nThis is <EM>[name]</EM>."))
	else if(obscure_name)
		. = list(span_info("ø ------------ ø\nThis is an unknown <EM>[name]</EM>."))
	else
		on_examine_face(user)
		var/used_name = name
		var/used_title = get_role_title()
		if(SSticker.regentmob == src)
			used_title = "[used_title]" + " Regent"
		var/display_as_wanderer = FALSE
		if(observer_privilege)
			used_name = real_name
		if(migrant_type)
			var/datum/migrant_role/migrant = MIGRANT_ROLE(migrant_type)
			if(migrant.show_wanderer_examine)
				display_as_wanderer = TRUE
		else if(job)
			var/datum/job/J = SSjob.GetJob(job)
			if(!J || J.wanderer_examine)
				display_as_wanderer = TRUE
		var/displayed_headshot
		var/datum/antagonist/vampire/vampireplayer = src.mind?.has_antag_datum(/datum/antagonist/vampire)
		var/datum/antagonist/lich/lichplayer = src.mind?.has_antag_datum(/datum/antagonist/lich)
		if(vampireplayer && (!SEND_SIGNAL(src, COMSIG_DISGUISE_STATUS))&& !isnull(vampire_headshot_link)) //vampire with their disguise down and a valid headshot
			displayed_headshot = src.vampire_headshot_link
		else if (lichplayer && !isnull(src.lich_headshot_link))//Lich with a valid headshot
			displayed_headshot = src.lich_headshot_link
		else
			displayed_headshot = src.headshot_link

		if ((valid_headshot_link(src, displayed_headshot, TRUE)) && (user.client?.prefs.chatheadshot))
			if(display_as_wanderer)
				. = list(span_info("ø ------------ ø\n<img src=[displayed_headshot] width=100 height=100/>\nThis is <EM>[used_name]</EM>, the wandering [race_name]."))
			else if(used_title)
				. = list(span_info("ø ------------ ø\n<img src=[displayed_headshot] width=100 height=100/>\nThis is <EM>[used_name]</EM>, the [race_name] [used_title]."))
			else
				. = list(span_info("ø ------------ ø\n<img src=[displayed_headshot] width=100 height=100/>\nThis is the <EM>[used_name]</EM>, the [race_name]."))
		else
			if(display_as_wanderer)
				. = list(span_info("ø ------------ ø\nThis is <EM>[used_name]</EM>, the wandering [race_name]."))
			else if(used_title)
				. = list(span_info("ø ------------ ø\nThis is <EM>[used_name]</EM>, the [race_name] [used_title]."))
			else
				. = list(span_info("ø ------------ ø\nThis is the <EM>[used_name]</EM>, the [race_name]."))

		if(HAS_TRAIT(src, TRAIT_WITCH))
			if(HAS_TRAIT(user, TRAIT_NOBLE) || HAS_TRAIT(user, TRAIT_INQUISITION) || HAS_TRAIT(user, TRAIT_WITCH))
				. += span_warning("A witch! Their presence brings an unsettling aura.")
			else if(HAS_TRAIT(user, TRAIT_COMMIE) || HAS_TRAIT(user, TRAIT_CABAL) || HAS_TRAIT(user, TRAIT_HORDE) || HAS_TRAIT(user, TRAIT_DEPRAVED))
				. += span_notice("A practitioner of the old ways.")
			else
				. += span_notice("Something about them seems... different.")

		if(GLOB.lord_titles[name])
			. += span_notice("[m3] been granted the title of \"[GLOB.lord_titles[name]]\".")

		if(HAS_TRAIT(src, TRAIT_NOBLE) || HAS_TRAIT(src, TRAIT_DEFILED_NOBLE))
			if(HAS_TRAIT(user, TRAIT_NOBLE) || HAS_TRAIT(user, TRAIT_DEFILED_NOBLE))
				. += span_notice("A fellow noble.")
			else
				. += span_notice("A noble!")

		if((HAS_TRAIT(user, TRAIT_RACISMISBAD) && !(src.dna.species.name == "Elf" || src.dna.species.name == "Dark Elf" || src.dna.species.name == "Half Elf")))
			. += span_phobia("An invader...")

		//For tennite schism god-event
		if(length(GLOB.tennite_schisms))
			var/datum/tennite_schism/S = GLOB.tennite_schisms[1]
			var/user_side = (WEAKREF(user) in S.supporters_astrata) ? "astrata" : (WEAKREF(user) in S.supporters_challenger) ? "challenger" : null
			var/mob_side = (WEAKREF(src) in S.supporters_astrata) ? "astrata" : (WEAKREF(src) in S.supporters_challenger) ? "challenger" : null

			if(user_side && mob_side)
				var/datum/patron/their_god = (mob_side == "astrata") ? S.astrata_god.resolve() : S.challenger_god.resolve()
				if(their_god)
					. += (user_side == mob_side) ? span_notice("Fellow [their_god.name] supporter!") : span_userdanger("Vile [their_god.name] supporter!")

		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(H.marriedto == name)
				. += span_love("It's my spouse.")

		if(name in GLOB.excommunicated_players)
			. += span_userdanger("HERETIC! SHAME!")

		if(HAS_TRAIT(src, TRAIT_EXCOMMUNICATED))
			. += span_userdanger("EXCOMMUNICATED! SHAME!")//Temporary, probably going to get rid of the trait since it doesn't fit for us.
/*
		if(name in GLOB.excommunicated_players)
			var/mob/living/carbon/human/H = src
			switch (H.patron)
				if (istype(H.patron, /datum/patron/divine))
					. += span_userdanger("EXCOMMUNICATED! SHAME!")
				if (istype(H.patron, /datum/patron/inhumen))
					. += span_userdanger("HERETIC! SHAME!")
				if (istype(H.patron, /datum/patron/old_god))
					. += span_userdanger("HEATHEN! SHAME!")
*/
		if(name in GLOB.outlawed_players)
			. += span_userdanger("OUTLAW!")

		if(HAS_TRAIT(user, TRAIT_JUSTICARSIGHT) && !HAS_TRAIT(src, TRAIT_DECEIVING_MEEKNESS))
			for(var/datum/bounty/b in GLOB.head_bounties) //I hate this.
				if(b.target == real_name)
					. += span_syndradio("[m3] a bounty on [m2] head of [b.amount] mammon for [b.reason], issued by [b.employer].")
					break

		if(name in GLOB.court_agents)
			var/datum/job/J = SSjob.GetJob(user.mind?.assigned_role)
			if(J?.department_flag & GARRISON || J?.department_flag & NOBLEMEN)
				. += span_greentext("<b>[m1] an agent of the court!</b>")

		if(user != src && !HAS_TRAIT(src, TRAIT_DECEIVING_MEEKNESS))
			if(has_flaw(/datum/charflaw/addiction/lovefiend) && user.has_flaw(/datum/charflaw/addiction/lovefiend))
				. += span_aiprivradio("[m1] as lovesick as I.")

			if(has_flaw(/datum/charflaw/addiction/junkie) && user.has_flaw(/datum/charflaw/addiction/junkie))
				. += span_deadsay("[m1] carrying the same dust marks on their nose as I.")

			if(has_flaw(/datum/charflaw/addiction/smoker) && user.has_flaw(/datum/charflaw/addiction/smoker))
				. += span_suppradio("[m1] enveloped by the familiar, faint stench of smoke. I know it well.")

			if(has_flaw(/datum/charflaw/addiction/alcoholic) && user.has_flaw(/datum/charflaw/addiction/alcoholic))
				. += span_syndradio("[m1] struggling to hide the hangover, and the stench of spirits. We're alike.")

			if(has_flaw(/datum/charflaw/paranoid) && user.has_flaw(/datum/charflaw/paranoid))
				if(ishuman(user))
					var/mob/living/carbon/human/H = user
					if(dna.species.name == H.dna.species.name)
						. += span_nicegreen("[m1] privy to the dangers of all these strangers around us. [m1] just as afraid as I am.")
					else
						. += span_nicegreen("[m1] one of the good ones. [m1] just as afraid as I am.")
			if(has_flaw(/datum/charflaw/addiction/masochist) && user.has_flaw(/datum/charflaw/addiction/sadist))
				. += span_secradio("[m1] marked by scars inflicted for pleasure. A delectable target for my urges.")
			if(has_flaw(/datum/charflaw/addiction/sadist) && user.has_flaw(/datum/charflaw/addiction/masochist))
				. += span_secradio("[m1] looking with eyes filled with a desire to inflict pain. So exciting.")
			if(HAS_TRAIT(user, TRAIT_EMPATH) && HAS_TRAIT(src, TRAIT_PERMAMUTE))
				. += span_notice("[m1] lacks a voice. [m1] is a mute!")

		var/villain_text = get_villain_text(user)
		if(villain_text)
			. += villain_text
		var/heretic_text = get_heretic_text(user)
		if(heretic_text)
			. += span_notice(heretic_text)
		var/inquisition_text = get_inquisition_text(user)
		if(inquisition_text)
			. +=span_notice(inquisition_text)

		if (HAS_TRAIT(src, TRAIT_LEPROSY))
			. += span_necrosis("A LEPER...")

		if (HAS_TRAIT(src, TRAIT_BEAUTIFUL))
			switch (pronouns)
				if (HE_HIM, SHE_HER_M)
					. += span_beautiful_masc("[m1] handsome!")
				if (SHE_HER, HE_HIM_F)
					. += span_beautiful_fem("[m1] beautiful!")
				if (THEY_THEM, THEY_THEM_F, IT_ITS)
					. += span_beautiful_nb("[m1] good-looking!")

		if (HAS_TRAIT(src, TRAIT_UNSEEMLY))
			switch (pronouns)
				if (HE_HIM)
					. += span_redtext("[m1] revolting!")
				if (SHE_HER)
					. += span_redtext("[m1] repugnant!")
				if (THEY_THEM, THEY_THEM_F, IT_ITS)
					. += span_redtext("[m1] repulsive!")

		var/datum/antagonist/vampire/vamp_inspect = src.mind?.has_antag_datum(/datum/antagonist/vampire)
		if(vamp_inspect && (!SEND_SIGNAL(src, COMSIG_DISGUISE_STATUS)))
			. += span_redtext("[m3] strange glowying eyes and fangs!")

		// Shouldn't be able to tell they are unrevivable through a mask as a Necran
		if(HAS_TRAIT(src, TRAIT_DNR) && src != user)
			if(HAS_TRAIT(user, TRAIT_DEATHSIGHT) || stat == DEAD)
				. += span_danger("They extrude a pale aura. Their soul [stat == DEAD ? "was not" : "is not"] clean. This [stat == DEAD ? "was" : "is"] their only chance at lyfe.")

	// Real medical role can tell at a glance it is a waste of time, but only if the Necra message don't come first.

	if(user.get_skill_level(/datum/skill/misc/medicine) >= SKILL_LEVEL_EXPERT && src.stat == DEAD)
		if(HAS_TRAIT(src, TRAIT_DNR) && src != user && !HAS_TRAIT(user, TRAIT_DEATHSIGHT)) // A lot of conditional to avoid a redundant message, but we also want unknown DNRs to be covered.
			. += span_danger("Their body holds not even a glimmer of life. No medicine can bring them back.")

	if (HAS_TRAIT(src, TRAIT_CRITICAL_WEAKNESS) && (!HAS_TRAIT(src, TRAIT_VAMP_DREAMS)))
		if(isliving(user))
			var/mob/living/L = user
			if(L.STAINT > 9 && L.STAPER > 9)
				. += span_redtext("<i>[m1] critically fragile!</i>")

	if(user != src && HAS_TRAIT(user, TRAIT_MATTHIOS_EYES) && (!HAS_TRAIT(src, TRAIT_DECEIVING_MEEKNESS)))
		var/atom/item = get_most_expensive()
		if(item)
			. += span_notice("You get the feeling [m2] most valuable possession is \a [item].")

	var/obscured = check_obscured_slots()
	var/skipface = (wear_mask && (wear_mask.flags_inv & HIDEFACE)) || (head && (head.flags_inv & HIDEFACE))
	if(HAS_TRAIT(user, TRAIT_ROYALSERVANT))
		var/datum/job/our_job = SSjob.name_occupations[job]
		if(length(culinary_preferences) && is_type_in_list(our_job, list(/datum/job/roguetown/lord, /datum/job/roguetown/lady, /datum/job/roguetown/exlady, /datum/job/roguetown/prince)))
			var/obj/item/reagent_containers/food/snacks/fav_food = src.culinary_preferences[CULINARY_FAVOURITE_FOOD]
			var/datum/reagent/consumable/fav_drink = src.culinary_preferences[CULINARY_FAVOURITE_DRINK]
			if(fav_food)
				if(fav_drink)
					. += span_notice("Their favourites are [fav_food.name] and [fav_drink.name].")
				else
					. += span_notice("Their favourite is [fav_food.name].")
			else if(fav_drink)
				. += span_notice("Their favourite is [fav_drink.name].")
			var/obj/item/reagent_containers/food/snacks/hated_food = src.culinary_preferences[CULINARY_HATED_FOOD]
			var/datum/reagent/consumable/hated_drink = src.culinary_preferences[CULINARY_HATED_DRINK]
			if(hated_food)
				if(hated_drink)
					. += span_notice("They hate [hated_food.name] and [hated_drink.name].")
				else
					. += span_notice("They hate [hated_food.name].")
			else if(hated_drink)
				. += span_notice("They hate [hated_drink.name].")

	var/is_stupid = FALSE
	var/is_smart = FALSE
	var/is_normal = FALSE
	if(ishuman(user))
		var/mob/living/carbon/human/H = user

		if(HAS_TRAIT(H, TRAIT_INTELLECTUAL) || H.get_skill_level(H, /datum/skill/craft/blacksmithing) >= SKILL_EXP_EXPERT)
			is_smart = TRUE	//Most of this is determining integrity of objects + seeing multiple layers.
		if(((H?.STAINT - 10) + round((H?.STAPER - 10) / 2) + H.get_skill_level(/datum/skill/misc/reading)) < 0 && !is_smart)
			is_stupid = TRUE
		if(((H?.STAINT - 10) + (H?.STAPER - 10) + H.get_skill_level(/datum/skill/misc/reading)) >= 5)
			is_normal = TRUE

	if(user != src)
		var/datum/mind/Umind = user.mind
		if(Umind && mind)
			for(var/datum/antagonist/aD in mind.antag_datums)
				for(var/datum/antagonist/bD in Umind.antag_datums)
					var/shit = bD.examine_friendorfoe(aD,user,src)
					if(shit)
						. += shit
		if(user.mind?.has_antag_datum(/datum/antagonist/vampire) || user.mind?.has_antag_datum(/datum/antagonist/vampire))
			. += span_userdanger("<a href='?src=[REF(src)];task=bloodpoolinfo;'>Vitae: [(mind && !clan) ? (bloodpool * CLIENT_VITAE_MULTIPLIER) : bloodpool]; Blood: [blood_volume]</a>")

	if(wear_shirt && !(SLOT_SHIRT in obscured))
		var/str = "[m3] [wear_shirt.generate_tooltip(wear_shirt.get_examine_string(user), showcrits = (is_normal || is_smart))]. "
		str += "[wear_shirt.integrity_check(is_smart)]"
		if(is_stupid)
			str = "[m3] some kind of shirt!"
		. += str

	//uniform
	if(wear_pants && !(SLOT_PANTS in obscured))
		//accessory
		var/accessory_msg
		if(istype(wear_pants, /obj/item/clothing/under))
			var/obj/item/clothing/under/U = wear_pants
			if(U.attached_accessory)
				accessory_msg += " with [icon2html(U.attached_accessory, user)] \a [U.attached_accessory]"
		var/str = "[m3] [wear_pants.generate_tooltip(wear_pants.get_examine_string(user), showcrits = (is_normal || is_smart))][accessory_msg]. "
		if(!wear_armor)
			str += wear_pants.integrity_check(is_smart)
		if(is_stupid)
			str = "[m3] a pair of some pants! "
		. += str


	//head
	if(head && !(SLOT_HEAD in obscured))
		var/str = "[m3] [head.generate_tooltip(head.get_examine_string(user), showcrits = (is_normal || is_smart))] on [m2] head. "
		str += head.integrity_check(is_smart)
		if(is_stupid)
			if(istype(head,/obj/item/clothing/head/roguetown/helmet))
				str = "[m3] some kinda helmet!"
			else
				str = "[m3] some kinda hat!"
		. += str

	//suit/armor
	if(wear_armor && !(SLOT_ARMOR in obscured))
		var/str = "[m3] [wear_armor.generate_tooltip(wear_armor.get_examine_string(user), showcrits = (is_normal || is_smart))]. "
		if(is_smart || is_normal)
			str += wear_armor.integrity_check(is_smart)
		else if (is_stupid)
			if(istype(wear_armor, /obj/item/clothing/suit/roguetown/armor))
				var/obj/item/clothing/suit/roguetown/armor/examined_armor = wear_armor
				switch(examined_armor.armor_class)
					if(ARMOR_CLASS_LIGHT)
						str = "[m3] some flimsy leathers!"
					if(ARMOR_CLASS_MEDIUM)
						if(!HAS_TRAIT(user, TRAIT_MEDIUMARMOR))
							str = "[m3] some metal and leather!"
					if(ARMOR_CLASS_HEAVY)
						if(!HAS_TRAIT(user, TRAIT_HEAVYARMOR))
							str = "[m3] some heavy metal stuff!"
		. += str
		//suit/armor storage
		if(s_store && !(SLOT_S_STORE in obscured))
			if(is_normal || is_smart)
				. += "[m1] carrying [s_store.get_examine_string(user)] on [m2] [wear_armor.name]."
	//back
//	if(back)
//		. += "[m3] [back.get_examine_string(user)] on [m2] back."

	//cloak
	if(cloak && !(SLOT_CLOAK in obscured))
		var/str
		if(istype(cloak, /obj/item/clothing))
			var/obj/item/clothing/CL = cloak
			str = "[m3] [CL.generate_tooltip(CL.get_examine_string(user), showcrits = (is_normal || is_smart))] on [m2] shoulders. "
		else
			str = "[m3] [cloak.get_examine_string(user)] on [m2] shoulders. "
		str += cloak.integrity_check(is_smart)
		if (is_stupid)					//So they can tell the named RG tabards. If they can read them, anyway.
			if(!istype(cloak, /obj/item/clothing/cloak/tabard/stabard) && user.get_skill_level(/datum/skill/misc/reading) == 0)
				str = "[m3] some kinda clothy thing on [m2] shoulders!"
		. += str

	//right back
	if(backr && !(SLOT_BACK_R in obscured))
		var/str = "[m3] [backr.get_examine_string(user)] on [m2] back. "
		str += backr.integrity_check(is_smart)
		. += str

	//left back
	if(backl && !(SLOT_BACK_L in obscured))
		var/str = "[m3] [backl.get_examine_string(user)] on [m2] back. "
		str += backl.integrity_check(is_smart)
		. += str

	//Hands
	for(var/obj/item/I in held_items)
		if(!(I.item_flags & ABSTRACT))
			var/str = "[m1] holding [I.get_examine_string(user)] in [m2] [get_held_index_name(get_held_index_of_item(I))]. "
			str += I.integrity_check(is_smart)
			. += str

	var/datum/component/forensics/FR = GetComponent(/datum/component/forensics)
	//gloves
	if(gloves && !(SLOT_GLOVES in obscured))
		var/str = "[m3] [gloves.generate_tooltip(gloves.get_examine_string(user), showcrits = (is_normal || is_smart))] on [m2] hands. "
		str += gloves.integrity_check(is_smart)
		if(is_stupid)
			str = "[m3] a pair of gloves of some kind!"
		. += str
	else if(FR && length(FR.blood_DNA))
		var/hand_number = get_num_arms(FALSE)
		if(hand_number)
			if(is_stupid)
				. += "[m3] got weird hands! They don't look right!"
			else
				. += "[m3][hand_number > 1 ? "" : " a"] <span class='bloody'>blood-stained</span> hand[hand_number > 1 ? "s" : ""]!"

	//belt
	if(belt && !(SLOT_BELT in obscured))
		var/str = "[m3] [belt.get_examine_string(user)] about [m2] waist. "
		str += belt.integrity_check(is_smart)
		. += str

	//right belt
	if(beltr && !(SLOT_BELT_R in obscured))
		var/str = "[m3] [beltr.get_examine_string(user)] on [m2] belt. "
		str += beltr.integrity_check(is_smart)
		. += str

	//left belt
	if(beltl && !(SLOT_BELT_L in obscured))
		var/str = "[m3] [beltl.get_examine_string(user)] on [m2] belt. "
		str += beltl.integrity_check(is_smart)
		. += str

	//shoes
	if(shoes && !(SLOT_SHOES in obscured))
		var/str = "[m3] [shoes.generate_tooltip(shoes.get_examine_string(user), showcrits = (is_normal || is_smart))] on [m2] feet. "
		str += shoes.integrity_check(is_smart)
		if(is_stupid)
			str = "[m3] some shoes on [m2] feet!"
		. += str

	//mask
	if(wear_mask && !(SLOT_WEAR_MASK in obscured))
		var/str = "[m3] [wear_mask.generate_tooltip(wear_mask.get_examine_string(user), showcrits = (is_normal || is_smart))] on [m2] face. "
		str += wear_mask.integrity_check(is_smart)
		if(is_stupid)
			str = "[m3] some kinda thing on [m2] face!"
		. += str

	//mouth
	if(mouth && !(SLOT_MOUTH in obscured))
		var/str
		if(istype(mouth, /obj/item/clothing))
			var/obj/item/clothing/CM = mouth
			str = "[m3] [CM.generate_tooltip(CM.get_examine_string(user), showcrits = (is_normal || is_smart))] in [m2] mouth. "
		else
			"[m3] [mouth.get_examine_string(user)] in [m2] mouth. "
		str += mouth.integrity_check(is_smart)
		if(is_stupid)
			str = "[m3] some kinda thing on [m2] mouth!"
		. += str

	//neck
	if(wear_neck && !(SLOT_NECK in obscured))
		var/str = "[m3] [wear_neck.generate_tooltip(wear_neck.get_examine_string(user), showcrits = (is_normal || is_smart))] around [m2] neck. "
		str += wear_neck.integrity_check(is_smart)
		if (is_stupid)
			str = "[m3] something on [m2] neck!"
		. += str

	//eyes
	if(!(SLOT_GLASSES in obscured))
		if(glasses)
			. += "[m3] [glasses.get_examine_string(user)] covering [m2] eyes."
		else if(eye_color == BLOODCULT_EYE)
			. += span_warning("<B>[m2] eyes are glowing an unnatural red!</B>")

	//ears
	if(ears && !(SLOT_HEAD in obscured))
		. += "[m3] [ears.get_examine_string(user)] on [m2] ears."

	//ID
	if(wear_ring && !(SLOT_RING in obscured))
		var/str = "[m3] [wear_ring.generate_tooltip(wear_ring.get_examine_string(user), showcrits = (is_normal || is_smart))] on [m2] hands. "
		if(is_smart && istype(wear_ring, /obj/item/clothing/ring/active))
			var/obj/item/clothing/ring/active/AR = wear_ring
			if(AR.cooldowny)
				if(world.time < AR.cooldowny + AR.cdtime)
					str += span_warning("It cannot activate again, yet.")
				else
					str += span_warning("It is ready to use.")
		if(is_stupid)
			str = "[m3] some sort of ring!"
		. += str

	//wrists
	if(wear_wrists && !(SLOT_WRISTS in obscured))
		var/str = "[m3] [wear_wrists.generate_tooltip(wear_wrists.get_examine_string(user), showcrits = (is_normal || is_smart))] on [m2] wrists."
		str += wear_wrists.integrity_check(is_smart)
		if (is_stupid)
			str = "[m3] something on [m2] wrists!"
		. += str

	//handcuffed?
	if(handcuffed)
		if(user == src)
			. += "<span class='warning'>[m1] tied up with \a [handcuffed]!</span>"
		else
			. += "<A href='?src=[REF(src)];item=[SLOT_HANDCUFFED]'><span class='warning'>[m1] tied up with \a [handcuffed]!</span></A>"

	if(legcuffed)
		. += "<A href='?src=[REF(src)];item=[SLOT_LEGCUFFED]'><span class='warning'>[m3] \a [legcuffed] around [m2] legs!</span></A>"

	var/datum/status_effect/bugged/effect = has_status_effect(/datum/status_effect/bugged)
	if(effect && HAS_TRAIT(user, TRAIT_INQUISITION))
		. += "<A href='?src=[REF(src)];item=[effect.device]'><span class='warning'>[m3] \a [effect.device] implanted.</span></A>"

	//Gets encapsulated with a warning span
	var/list/msg = list()

	var/appears_dead = FALSE
	if(stat == DEAD || (HAS_TRAIT(src, TRAIT_FAKEDEATH)))
		appears_dead = TRUE

	var/temp = getBruteLoss() + getFireLoss() //no need to calculate each of these twice

	if (get_bodypart(BODY_ZONE_HEAD)?.grievously_wounded)
		msg += span_bloody("<b>[p_their(TRUE)] neck is a ghastly ruin of blood and bone, barely hanging on!</b>")

	if(!(user == src && src.hal_screwyhud == SCREWYHUD_HEALTHY)) //fake healthy
		// Damage
		switch(temp)
			if(5 to 25)
				msg += "[m1] a little wounded."
			if(25 to 50)
				msg += "[m1] wounded."
			if(50 to 100)
				msg += "<B>[m1] severely wounded.</B>"
			if(100 to INFINITY)
				msg += span_danger("[m1] gravely wounded.")

	// Blood volume
	switch(blood_volume)
		if(-INFINITY to BLOOD_VOLUME_SURVIVE)
			msg += span_artery("<B>[m1] extremely pale and sickly.</B>")
		if(BLOOD_VOLUME_SURVIVE to BLOOD_VOLUME_BAD)
			msg += span_artery("<B>[m1] very pale.</B>")
		if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_OKAY)
			msg += span_artery("[m1] pale.")
		if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
			msg += span_artery("[m1] a little pale.")

	// Bleeding
	var/bleed_rate = get_bleed_rate()
	if(bleed_rate)
		if(!is_stupid)
			var/bleed_wording = "bleeding"
			switch(bleed_rate)
				if(0 to 1)
					bleed_wording = "bleeding slightly"
				if(1 to 5)
					bleed_wording = "bleeding"
				if(5 to 10)
					bleed_wording = "bleeding a lot"
				if(10 to INFINITY)
					bleed_wording = "bleeding profusely"
			var/list/bleeding_limbs = list()
			var/static/list/bleed_zones = list(
				BODY_ZONE_HEAD,
				BODY_ZONE_CHEST,
				BODY_ZONE_R_ARM,
				BODY_ZONE_L_ARM,
				BODY_ZONE_R_LEG,
				BODY_ZONE_L_LEG,
			)
			for(var/bleed_zone in bleed_zones)
				var/obj/item/bodypart/bleeder = get_bodypart(bleed_zone)
				if(!bleeder?.get_bleed_rate() || (!observer_privilege && !get_location_accessible(src, bleeder.body_zone)))
					continue
				bleeding_limbs += parse_zone(bleeder.body_zone)
			if(length(bleeding_limbs))
				if(bleed_rate >= 5)
					msg += span_bloody("<B>[capitalize(m2)] [english_list(bleeding_limbs)] [bleeding_limbs.len > 1 ? "are" : "is"] [bleed_wording]!</B>")
				else
					msg += span_bloody("[capitalize(m2)] [english_list(bleeding_limbs)] [bleeding_limbs.len > 1 ? "are" : "is"] [bleed_wording]!")
			else
				if(bleed_rate >= 5)
					msg += span_bloody("<B>[m1] [bleed_wording]</B>!")
				else
					msg += span_bloody("[m1] [bleed_wording]!")
		else
			if(isliving(user))
				var/mob/living/M = user
				if(M.patron.type == /datum/patron/inhumen/graggar)
					msg += span_bloody("[m1] shedding lyfe's blood, exposing weakness!")
				else
					msg += span_bloody("[m1] letting out the red stuff!")

	// Missing limbs
	var/missing_head = FALSE
	var/list/missing_limbs = list()
	for(var/missing_zone in get_missing_limbs())
		if(missing_zone == BODY_ZONE_HEAD)
			missing_head = TRUE
			if (isdullahan(src))
				var/datum/species/dullahan/user_species = dna.species
				if(user_species.headless && user != src && !isdullahan(user))
					user.add_stress(/datum/stressevent/headless)
		missing_limbs += parse_zone(missing_zone)

	if(length(missing_limbs))
		var/missing_limb_message = "<B>[capitalize(m2)] [english_list(missing_limbs)] [missing_limbs.len > 1 ? "are" : "is"] gone.</B>"
		if(missing_head)
			missing_limb_message = span_dead("[missing_limb_message]")
		else
			missing_limb_message = span_danger("[missing_limb_message]")
		msg += missing_limb_message

	//Grabbing
	if(pulledby && pulledby.grab_state)
		msg += "[m1] being grabbed by [pulledby]."

	//Nutrition and Thirst
	if(nutrition < (NUTRITION_LEVEL_STARVING - 50))
		msg += "[m1] looking emaciated."
//	else if(nutrition >= NUTRITION_LEVEL_FAT)
//		if(user.nutrition < NUTRITION_LEVEL_STARVING - 50)
//			msg += "[t_He] [t_is] plump and delicious looking - Like a fat little piggy. A tasty piggy."
//		else
//			msg += "[t_He] [t_is] quite chubby."

	if(HAS_TRAIT(user, TRAIT_EXTEROCEPTION))
		switch(nutrition)
			if(NUTRITION_LEVEL_HUNGRY to NUTRITION_LEVEL_FED)
				msg += "[m1] looking peckish."
			if(NUTRITION_LEVEL_STARVING to NUTRITION_LEVEL_HUNGRY)
				msg += "[m1] looking hungry."
			if(NUTRITION_LEVEL_STARVING-50 to NUTRITION_LEVEL_STARVING)
				msg += "[m1] looking starved."
		switch(hydration)
			if(HYDRATION_LEVEL_THIRSTY to HYDRATION_LEVEL_SMALLTHIRST)
				msg += "[m1] looking like [m2] mouth is dry."
			if(HYDRATION_LEVEL_DEHYDRATED to HYDRATION_LEVEL_THIRSTY)
				msg += "[m1] looking thirsty for a drink."
			if(0 to HYDRATION_LEVEL_DEHYDRATED)
				msg += "[m1] looking parched."

	//Fire/water stacks
	if(has_status_effect(/datum/status_effect/fire_handler))
		msg += "[m1] covered in something flammable."
	if(has_status_effect(/datum/status_effect/fire_handler/wet_stacks))
		msg += "[m1] soaked."

	//Status effects
	var/list/status_examines = status_effect_examines()
	if(length(status_examines))
		msg += status_examines

	//Disgusting behemoth of stun absorption
	if(islist(stun_absorption))
		for(var/i in stun_absorption)
			if(stun_absorption[i]["end_time"] > world.time && stun_absorption[i]["examine_message"])
				msg += "[m1][stun_absorption[i]["examine_message"]]"

	if(!appears_dead)
		if(!skipface)
			//Disgust
			switch(disgust)
				if(DISGUST_LEVEL_SLIGHTLYGROSS to DISGUST_LEVEL_GROSS)
					msg += "[m1] a little disgusted."
				if(DISGUST_LEVEL_GROSS to DISGUST_LEVEL_VERYGROSS)
					msg += "[m1] disgusted."
				if(DISGUST_LEVEL_VERYGROSS to DISGUST_LEVEL_DISGUSTED)
					msg += "[m1] really disgusted."
				if(DISGUST_LEVEL_DISGUSTED to INFINITY)
					msg += "<B>[m1] extremely disgusted.</B>"

			//Drunkenness
			switch(drunkenness)
				if(11 to 21)
					msg += "[m1] slightly flushed."
				if(21.01 to 41) //.01s are used in case drunkenness ends up to be a small decimal
					msg += "[m1] flushed."
				if(41.01 to 51)
					msg += "[m1] quite flushed and [m2] breath smells of alcohol."
				if(51.01 to 61)
					msg += "[m1] very flushed, with breath reeking of alcohol."
				if(61.01 to 91)
					msg += "[m1] looking like a drunken mess."
				if(91.01 to INFINITY)
					msg += "[m1] a shitfaced, slobbering wreck."

			//Stress
			var/stress = get_stress_amount()
			if(HAS_TRAIT(user, TRAIT_EMPATH))
				switch(stress)
					if(20 to INFINITY)
						msg += "[m1] extremely stressed."
					if(10 to 19)
						msg += "[m1] very stressed."
					if(1 to 9)
						msg += "[m1] a little stressed."
					if(-9 to 0)
						msg += "[m1] not stressed."
					if(-19 to -10)
						msg += "[m1] somewhat at peace."
					if(-20 to INFINITY)
						msg += "[m1] at peace inside."
			else if(stress > 10)
				msg += "[m3] stress all over [m2] face."

		//Jitters
		switch(jitteriness)
			if(300 to INFINITY)
				msg += "<B>[m1] convulsing violently!</B>"
			if(200 to 300)
				msg += "[m1] extremely jittery."
			if(100 to 200)
				msg += "[m1] twitching ever so slightly."

		if(InCritical())
			msg += span_warning("[m1] barely conscious.")
		else
			if(stat >= UNCONSCIOUS)
				msg += "[m1] [IsSleeping() ? "sleeping" : "unconscious"]."
			else if(eyesclosed)
				msg += "[capitalize(m2)] eyes are closed."
			else if(has_status_effect(/datum/status_effect/debuff/sleepytime))
				msg += "[m1] looking a little tired."
	else
		msg += "[m1] unconscious."
//		else
//			if(HAS_TRAIT(src, TRAIT_DUMB))
//				msg += "[m3] a stupid expression on [m2] face."
//			if(InCritical())
//				msg += "[m1] barely conscious."
//		if(getorgan(/obj/item/organ/brain))
//			if(!key)
//				msg += span_deadsay("[m1] totally catatonic. The stresses of life in deep-space must have been too much for [t_him]. Any recovery is unlikely.")
//			else if(!client)
//				msg += "[m3] a blank, absent-minded stare and appears completely unresponsive to anything. [t_He] may snap out of it soon."

	if(length(msg))
		. += span_warning("[msg.Join("\n")]")

	// Show especially large embedded objects at a glance
	for(var/obj/item/bodypart/part in bodyparts)
		if (LAZYLEN(part.embedded_objects))
			for(var/obj/item/stuck_thing in part.embedded_objects)
				if (stuck_thing.w_class >= WEIGHT_CLASS_SMALL)
					. += span_bloody("<b>[m3] \a [stuck_thing] stuck in [m2] [part.name]!</b>")

	if((user != src) && isliving(user))
		var/mob/living/L = user
		var/final_str = STASTR
		if(HAS_TRAIT(src, TRAIT_DECEIVING_MEEKNESS))
			final_str = L.STASTR - rand(1,2)
		var/strength_diff = final_str - L.STASTR
		switch(strength_diff)
			if(5 to INFINITY)
				. += span_warning("<B>[t_He] look[p_s()] much stronger than I.</B>")
			if(1 to 5)
				. += span_warning("[t_He] look[p_s()] stronger than I.")
			if(0)
				. += "[t_He] look[p_s()] about as strong as I."
			if(-5 to -1)
				. += span_warning("[t_He] look[p_s()] weaker than I.")
			if(-INFINITY to -5)
				. += span_warning("<B>[t_He] look[p_s()] much weaker than I.</B>")

	if((HAS_TRAIT(user,TRAIT_INTELLECTUAL)))
		var/mob/living/L = user
		var/final_int = STAINT
		if(HAS_TRAIT(src, TRAIT_DECEIVING_MEEKNESS))
			final_int = L.STAINT
		var/int_diff = final_int - L.STAINT
		switch(int_diff)
			if(5 to INFINITY)
				. += span_revenwarning("[t_He] look[p_s()] far more intelligent than I.")
			if(2 to 5)
				. += span_revenminor("[t_He] look[p_s()] smarter than I.")
			if(-1 to 1)
				. += "[t_He] look[p_s()] about as intelligent as I."
			if(-5 to -2)
				. += span_revennotice("[t_He] look[p_s()] dumber than I.")
			if(-INFINITY to -5)
				. += span_revennotice("[t_He] look[p_s()] as blunt-minded as a rock.")

	if(maniac)
		var/obj/item/organ/heart/heart = getorganslot(ORGAN_SLOT_HEART)
		if(heart?.inscryption && (heart.inscryption_key in maniac.key_nums))
			. += span_danger("[t_He] know[p_s()] [heart.inscryption_key], I AM SURE OF IT!")

	var/medical_text = ""
	if(Adjacent(user))
		if(observer_privilege)
			var/static/list/check_zones = list(
				BODY_ZONE_HEAD,
				BODY_ZONE_CHEST,
				BODY_ZONE_R_ARM,
				BODY_ZONE_L_ARM,
				BODY_ZONE_R_LEG,
				BODY_ZONE_L_LEG,
			)
			for(var/zone in check_zones)
				var/obj/item/bodypart/bodypart = get_bodypart(zone)
				if(!bodypart)
					continue
				. += "<a href='?src=[REF(src)];inspect_limb=[zone]'>Inspect [parse_zone(zone)]</a>"
			. += "<a href='?src=[REF(src)];check_hb=1'>Check Heartbeat</a>"
		else
			var/checked_zone = check_zone(user.zone_selected)
			var/heartbeat
			if(!(mobility_flags & MOBILITY_STAND) && user != src && (user.zone_selected == BODY_ZONE_CHEST))
				heartbeat = "<a href='?src=[REF(src)];check_hb=1'>Listen to Heartbeat</a>"
			medical_text = "[heartbeat ? "[heartbeat] | " : ""]<a href='?src=[REF(src)];inspect_limb=[checked_zone]'>Inspect [parse_zone(checked_zone)]</a>"

	. += medical_text

	if(!HAS_TRAIT(src, TRAIT_DECEIVING_MEEKNESS) && user != src)
		if(isliving(user))
			var/mob/living/L = user
			if(L.STAINT > 9 && L.STAPER > 9)
				if(HAS_TRAIT(src, TRAIT_COMBAT_AWARE))
					. += span_warning("<i>They look battle-aware.</i>")
				if(HAS_TRAIT(user, TRAIT_COMBAT_AWARE))
					var/userheld = user.get_active_held_item()
					var/srcheld = get_active_held_item()
					var/datum/skill/user_skill = /datum/skill/combat/unarmed	//default
					var/datum/skill/src_skill = /datum/skill/combat/unarmed
					if(userheld)
						var/obj/item/I = userheld
						if(I.associated_skill)
							user_skill = I.associated_skill
					if(srcheld)
						var/obj/item/I = srcheld
						if(I.associated_skill)
							src_skill = I.associated_skill
					var/skilldiff = user.get_skill_level(user_skill) - get_skill_level(src_skill)
					. += "<font size = 3><i>[skilldiff_report(skilldiff)] in my wielded skill than they are in theirs.</i></font>"

	var/showassess = FALSE
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(get_dist(src, H) <= ((2 + clamp(floor(((H.STAPER - 10))),-1, 4)) + HAS_TRAIT(user, TRAIT_INTELLECTUAL)))
			showassess = TRUE

	if((!obscure_name || client?.prefs.masked_examine) && (flavortext || headshot_link || ooc_notes))
		. += "<a href='?src=[REF(src)];task=view_headshot;'>Examine closer</a> [showassess ? " | <a href='?src=[REF(src)];task=assess;'>Assess</a>" : ""]"

	if(lip_style)
		switch(lip_color)
			if("red")
				. += "<span class='info' style='color: #a81324'>[m1] wearing red lipstick.</span>"
			if("purple")
				. += "<span class='info' style='color: #800080'>[m1] wearing purple lipstick.</span>"
			if("lime")
				. += "<span class='info' style='color: #00FF00'>[m1] wearing lime lipstick.</span>"
			if("black")
				. += "<span class='info' style='color: #313131ff'>[m1] wearing black lipstick.</span>"


	var/list/lines
	if((get_face_name() != real_name) && !observer_privilege)
		lines = build_cool_description_unknown(get_mob_descriptors_unknown(obscure_name, user), src)
	else
		lines = build_cool_description(get_mob_descriptors(obscure_name, user), src)

	var/app_str
	if(!(user.client?.prefs?.full_examine))
		app_str = "<details><summary>[span_info("Details")]</summary>"

	for(var/line in lines)
		var/index = 1
		app_str += span_info(line)
		index++
		if(index != length(lines))
			app_str += "<br>"
	if(!(user.client?.prefs?.full_examine))
		if(length(lines))
			app_str += "</details>"

	. += app_str

	// Characters with the hunted flaw will freak out if they can't see someone's face.
	if(!appears_dead)
		if(skipface && user.has_flaw(/datum/charflaw/hunted) && user != src)
			user.add_stress(/datum/stressevent/hunted)

	var/trait_exam = common_trait_examine()
	if(!isnull(trait_exam))
		. += trait_exam

	SEND_SIGNAL(src, COMSIG_PARENT_EXAMINE, user, .)

/mob/living/proc/status_effect_examines(pronoun_replacement) //You can include this in any mob's examine() to show the examine texts of status effects!
	var/list/dat = list()
	if(!pronoun_replacement)
		pronoun_replacement = p_they(TRUE)
	for(var/V in status_effects)
		var/datum/status_effect/E = V
		if(E.examine_text)
			var/new_text = replacetext(E.examine_text, "SUBJECTPRONOUN", pronoun_replacement)
			new_text = replacetext(new_text, "[pronoun_replacement] is", "[pronoun_replacement] [p_are()]") //To make sure something become "They are" or "She is", not "They are" and "She are"
			dat += "[new_text]\n" //dat.Join("\n") doesn't work here, for some reason
	if(dat.len)
		return dat.Join()

/// Returns patron-related examine text for the mob, if any. Can return null.
/mob/living/proc/get_heretic_text(mob/examiner)
	var/heretic_text = null
	var/seer

	if(HAS_TRAIT(src,TRAIT_DECEIVING_MEEKNESS))
		return null

	if(HAS_TRAIT(examiner, TRAIT_HERETIC_SEER))
		seer = TRUE

	if(HAS_TRAIT(src, TRAIT_COMMIE))
		if(seer)
			heretic_text += "Matthiosan."
			if(HAS_TRAIT(examiner, TRAIT_COMMIE))
				heretic_text += " To share with. To take with. For all, and us."
		else if(HAS_TRAIT(examiner, TRAIT_COMMIE))
			heretic_text += "Comrade!"
	else if((HAS_TRAIT(src, TRAIT_CABAL)))
		if(seer)
			heretic_text += "A member of Zizo's cabal."
			if(HAS_TRAIT(examiner, TRAIT_CABAL))
				heretic_text += " May their ambitions not interfere with mine."
	else if((HAS_TRAIT(src, TRAIT_HORDE)))
		if(seer)
			heretic_text += "Hardened by Graggar's Rituals."
			if(HAS_TRAIT(examiner, TRAIT_HORDE))
				heretic_text += " Mine were a glorious memory."
	else if((HAS_TRAIT(src, TRAIT_DEPRAVED)))
		if(seer)
			heretic_text += "Baotha's Touched."
			if(HAS_TRAIT(examiner, TRAIT_DEPRAVED))
				heretic_text += " She leads us to the greatest ends."

	return heretic_text

/// Same as get_heretic_text, but returns a simple symbol depending on the type of heretic!
/mob/living/proc/get_heretic_symbol(mob/examiner)
	var/heretic_text
	if(HAS_TRAIT(src, TRAIT_DECEIVING_MEEKNESS))
		return
	if(HAS_TRAIT(src, TRAIT_COMMIE) && HAS_TRAIT(examiner, TRAIT_COMMIE))
		heretic_text += "♠"
	//Defunct as of *fsalute changes, leaving here as a symbol reference.
	/*else if(HAS_TRAIT(src, TRAIT_CABAL) && HAS_TRAIT(examiner, TRAIT_CABAL))
		heretic_text += "♦"
	else if(HAS_TRAIT(src, TRAIT_HORDE) && HAS_TRAIT(examiner, TRAIT_HORDE))
		heretic_text += "♠"
	else if(HAS_TRAIT(src, TRAIT_DEPRAVED) && HAS_TRAIT(examiner, TRAIT_DEPRAVED))
		heretic_text += "♥"*/

	return heretic_text


// Used for Inquisition tags
/mob/living/proc/get_inquisition_text(mob/examiner)
	var/inquisition_text
	if(HAS_TRAIT(src, TRAIT_INQUISITION) && HAS_TRAIT(examiner, TRAIT_INQUISITION))
		inquisition_text = "A fellow adherent to the Holy Otavan Inquisition's missives."
	if(HAS_TRAIT(src, TRAIT_PURITAN) && HAS_TRAIT(examiner, TRAIT_INQUISITION))
		inquisition_text = "My superior, sent by the Holy Otavan Inquisition to lead our sect."
	if(HAS_TRAIT(src, TRAIT_INQUISITION) && HAS_TRAIT(examiner, TRAIT_PURITAN))
		inquisition_text = "A subordinate to my authority, as willed by the Holy Otavan Inquisition."
	if(HAS_TRAIT(src, TRAIT_PURITAN) && HAS_TRAIT(examiner, TRAIT_PURITAN))
		inquisition_text = "Myself. I lead this sect of the Holy Otavan Inquisition."

	return inquisition_text

/// Returns antagonist-related examine text for the mob, if any. Can return null.
/mob/living/proc/get_villain_text(mob/examiner)
	var/villain_text
	if(mind)
		if(mind.special_role == "Bandit")
			if(HAS_TRAIT(examiner, TRAIT_COMMIE))
				villain_text = span_notice("Free man!")
			if(HAS_TRAIT(src,TRAIT_KNOWNCRIMINAL))
				villain_text = span_userdanger("BANDIT!")
		if(mind.special_role == "Vampire Lord")
			var/datum/antagonist/vampire/VD = mind.has_antag_datum(/datum/antagonist/vampire)
			if(!SEND_SIGNAL(VD.owner, COMSIG_DISGUISE_STATUS))
				villain_text += span_userdanger("A MONSTER!")
		if(mind.assigned_role == "Lunatic")
			villain_text += span_userdanger("LUNATIC!")

	return villain_text

/proc/get_blade_dulling_text(obj/item/rogueweapon/I, verbose = FALSE)
	switch(I.blade_dulling)
		if(DULLING_SHAFT_WOOD)
			return "[verbose ? "Wooden" : "(W. shaft)"]"
		if(DULLING_SHAFT_REINFORCED)
			return "[verbose ? "Reinforced" : "(R. shaft)"]"
		if(DULLING_SHAFT_METAL)
			return "[verbose ? "Metal" : "(M. shaft)"]"
		if(DULLING_SHAFT_GRAND)
			return "[verbose ? "Grand" : "(G. shaft)"]"
		if(DULLING_SHAFT_CONJURED)
			return "[verbose ? "Conjured" : "(C. shaft)"]"
		else
			return null
