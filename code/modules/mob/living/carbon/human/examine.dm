/mob/living/carbon/human/proc/on_examine_face(mob/living/carbon/human/user)
	if(!istype(user))
		return
	if(user.mind)
		user.mind.i_know_person(src)
	if(HAS_TRAIT(user, TRAIT_JESTERPHOBIA) && job == "Jester")
		user.add_stress(/datum/stressevent/jesterphobia)
	if(HAS_TRAIT(src, TRAIT_BEAUTIFUL) && user != src)//it doesn't really make sense that you can examine your own face
		user.add_stress(/datum/stressevent/beautiful)
	if(HAS_TRAIT(src, TRAIT_UNSEEMLY) && user != src)
		if(!HAS_TRAIT(user, TRAIT_UNSEEMLY))
			user.add_stress(/datum/stressevent/unseemly)
	if(HAS_TRAIT(src, TRAIT_LEPROSY) && user != src)
		user.add_stress(/datum/stressevent/leprosy)
	// Apply Xylix buff when examining someone with the beautiful trait
	if(HAS_TRAIT(user, TRAIT_XYLIX) && !user.has_status_effect(/datum/status_effect/buff/xylix_joy) && user.has_stress_event(/datum/stressevent/beautiful))
		user.apply_status_effect(/datum/status_effect/buff/xylix_joy)
		to_chat(user, span_info("Their beauty brings a smile to my face, and fortune to my steps!"))

/mob/living/carbon/human/examine(mob/user)
	. = list()
	var/datum/pronouns/pronoun = get_pronoun() // mutated many, many times
	var/self_examine = (user == src) // used to swap to first person pronouns

	if(!user.client?.prefs?.top_examine)
		. += span_info("ø ------------ ø")
	var/observer_privilege = isobserver(user)
	var/obscure_name = FALSE
	var/race_name = "<a href='?src=[REF(src)];species_lore=1'><u>[dna.species.name]</u></A> "
	var/origin_name = "<a href='?src=[REF(src)];origin_lore=1'><u>[dna.species.origin]</u></A>"
	var/datum/antagonist/maniac/maniac = user.mind?.has_antag_datum(/datum/antagonist/maniac)
	var/datum/antagonist/skeleton/skeleton = user.mind?.has_antag_datum(/datum/antagonist/skeleton)
	var/datum/antagonist/zombie/zombie = user.mind?.has_antag_datum(/datum/antagonist/zombie)
	if(maniac && (user != src))
		race_name = "disgusting pig"
	if(skeleton && (user != src))
		race_name = "[pick("shambling", "taut", "decrepit")]"
	if(zombie && (user != src))
		race_name = "[pick("shambling thing", "taut thing", "decrepit thing", "wyrd thing", "UHHHHHHH...")]" //UHHHHH... zombie has to think moment

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

	if(user.client?.prefs?.top_examine)
		. += generate_main_examine_body(user, self_examine, obscure_name, race_name, origin_name, observer_privilege, unknown_names)

	if(user != src && HAS_TRAIT(user, TRAIT_MATTHIOS_EYES) && !HAS_TRAIT(src, TRAIT_DECEIVING_MEEKNESS))
		var/atom/item = get_most_expensive()
		if(item)
			. += span_notice("You get the feeling [src]'s most valuable possession is \a [item].")
		var/mammonsonperson = get_mammons_in_atom(src)
		var/mammonsinbank = SStreasury.get_balance(src)
		var/totalvalue = mammonsonperson + mammonsinbank
		if(totalvalue && HAS_TRAIT(user, TRAIT_GILDED_SIGHT))
			. += span_notice("They carry [mammonsonperson] mammons, with [mammonsinbank] stored away, totaling [totalvalue].")
		else if(mammonsonperson && mammonsonperson >= 100) // worth a whole mission board!
			. += span_notice("They carry about [mammonsonperson] mammons with them.")
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
	var/guarded = FALSE
	if(ishuman(user))
		var/mob/living/carbon/human/H = user

		if(HAS_TRAIT(H, TRAIT_INTELLECTUAL) || H.get_skill_level(H, /datum/skill/craft/blacksmithing) >= SKILL_EXP_EXPERT)
			is_smart = TRUE	//Most of this is determining integrity of objects + seeing multiple layers.
		if(((H?.STAINT - 10) + round((H?.STAPER - 10) / 2) + H.get_skill_level(/datum/skill/misc/reading)) < 0 && !is_smart)
			is_stupid = TRUE
		if(((H?.STAINT - 10) + (H?.STAPER - 10) + H.get_skill_level(/datum/skill/misc/reading)) >= 5)
			is_normal = TRUE

		if(user != src)
			if(HAS_TRAIT(src, TRAIT_DECEIVING_MEEKNESS))
				guarded = TRUE

	if(HAS_TRAIT(src, TRAIT_DEADITE)) //Zombies always show up as deadites to others even behind masks
		. += span_userdanger("DEADITE!") //Below this is an OOC hint, it AIN'T METAGAMING, you can TELL very clearly what this abomination is.
		. += span_warning("Uneasy steps, the sound of profane flesh and bone knitting itself and a stench of rot. A walking corpse!")

	if(HAS_TRAIT(user, TRAIT_DEADITE) && !HAS_TRAIT(src, TRAIT_ZOMBIE_IMMUNE) && src.stat == CONSCIOUS) //Zombies get some messed up examines on non-zombie immune people that aren't KO'd.
		. += span_narsie(pick("KILL IT. KILL IT", "FLESH. HUNGER.", "KILL. CONSUME.", "CONSUME.", "KILL THE RASPING THING.", "HUNGER.", "EAT IT.", "MUST HAVE FLESH."))

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


	if(HAS_TRAIT(src, TRAIT_NPC_EXAMINE) && !mind && src.stat == CONSCIOUS) //NPCs always show up if they're mindless.
		. += span_warning("[src]'s hollow expression is filled with mindless anger!")

	if(wear_shirt && !(SLOT_SHIRT in obscured))
		var/str = "[pronoun.m3(self_examine)] [wear_shirt.generate_tooltip(wear_shirt.get_examine_string(user))]. "
		str += "[wear_shirt.integrity_check(is_smart, guarded)]"
		if(is_stupid)
			str = "[pronoun.m3(self_examine)] some kind of shirt!"
		. += str

	//uniform
	if(wear_pants && !(SLOT_PANTS in obscured))
		//accessory
		var/accessory_msg
		if(istype(wear_pants, /obj/item/clothing/under))
			var/obj/item/clothing/under/U = wear_pants
			if(U.attached_accessory)
				accessory_msg += " with [icon2html(U.attached_accessory, user)] \a [U.attached_accessory]"
		var/str = "[pronoun.m3(self_examine)] [wear_pants.generate_tooltip(wear_pants.get_examine_string(user))][accessory_msg]. "
		if(!wear_armor)
			str += wear_pants.integrity_check(is_smart, guarded)
		if(is_stupid)
			str = "[pronoun.m3(self_examine)] a pair of some pants! "
		. += str


	//head
	if(head && !(SLOT_HEAD in obscured))
		var/str = "[pronoun.m3(self_examine)] [head.generate_tooltip(head.get_examine_string(user))] on [pronoun.m2(self_examine)] head. "
		str += head.integrity_check(is_smart)
		if(is_stupid)
			if(istype(head,/obj/item/clothing/head/roguetown/helmet))
				str = "[pronoun.m3(self_examine)] some kinda helmet!"
			else
				str = "[pronoun.m3(self_examine)] some kinda hat!"
		. += str

	//suit/armor
	if(wear_armor && !(SLOT_ARMOR in obscured))
		var/str = "[pronoun.m3(self_examine)] [wear_armor.generate_tooltip(wear_armor.get_examine_string(user))]. "
		if(is_smart || is_normal)
			str += wear_armor.integrity_check(is_smart, guarded)
		else if (is_stupid)
			if(istype(wear_armor, /obj/item/clothing/suit/roguetown/armor))
				var/obj/item/clothing/suit/roguetown/armor/examined_armor = wear_armor
				switch(examined_armor.armor_class)
					if(ARMOR_CLASS_LIGHT)
						str = "[pronoun.m3(self_examine)] some flimsy leathers!"
					if(ARMOR_CLASS_MEDIUM)
						if(!HAS_TRAIT(user, TRAIT_MEDIUMARMOR))
							str = "[pronoun.m3(self_examine)] some metal and leather!"
					if(ARMOR_CLASS_HEAVY)
						if(!HAS_TRAIT(user, TRAIT_HEAVYARMOR))
							str = "[pronoun.m3(self_examine)] some heavy metal stuff!"
		. += str
		//suit/armor storage
		if(s_store && !(SLOT_S_STORE in obscured))
			if(is_normal || is_smart)
				. += "[pronoun.m1(self_examine)] carrying [get_item_examine_label(s_store, user)] on [pronoun.m2(self_examine)] [wear_armor.name]."

	//back
//	if(back)
//		. += "[pronoun.m3(self_examine)] [back.get_examine_string(user)] on [pronoun.m2(self_examine)] back."

	//cloak
	if(cloak && !(SLOT_CLOAK in obscured))
		var/str
		if(istype(cloak, /obj/item/clothing))
			var/obj/item/clothing/CL = cloak
			str = "[pronoun.m3(self_examine)] [CL.generate_tooltip(CL.get_examine_string(user))] on [pronoun.m2(self_examine)] shoulders. "
		else
			str = "[pronoun.m3(self_examine)] [cloak.get_examine_string(user)] on [pronoun.m2(self_examine)] shoulders. "
		str += cloak.integrity_check(is_smart, guarded)
		if (is_stupid)					//So they can tell the named RG tabards. If they can read them, anyway.
			if(!istype(cloak, /obj/item/clothing/cloak/tabard/stabard) && user.get_skill_level(/datum/skill/misc/reading) == 0)
				str = "[pronoun.m3(self_examine)] some kinda clothy thing on [pronoun.m2(self_examine)] shoulders!"
		. += str

	//right back
	if(backr && !(SLOT_BACK_R in obscured))
		var/str = "[pronoun.m3(self_examine)] [get_item_examine_label(backr, user)] on [pronoun.m2(self_examine)] back. "
		str += backr.integrity_check(is_smart, guarded)
		. += str

	//left back
	if(backl && !(SLOT_BACK_L in obscured))
		var/str = "[pronoun.m3(self_examine)] [get_item_examine_label(backl, user)] on [pronoun.m2(self_examine)] back. "
		str += backl.integrity_check(is_smart, guarded)
		. += str

	//Hands
	for(var/obj/item/I in held_items)
		if(!(I.item_flags & ABSTRACT))
			var/str = "[pronoun.m1(self_examine)] holding [get_item_examine_label(I, user)] in [pronoun.m2(self_examine)] [get_held_index_name(get_held_index_of_item(I))]. "
			str += I.integrity_check(is_smart, guarded)
			. += str

	var/datum/component/forensics/FR = GetComponent(/datum/component/forensics)
	//gloves
	if(gloves && !(SLOT_GLOVES in obscured))
		var/str = "[pronoun.m3(self_examine)] [gloves.generate_tooltip(gloves.get_examine_string(user))] on [pronoun.m2(self_examine)] hands. "
		str += gloves.integrity_check(is_smart, guarded)
		if(is_stupid)
			str = "[pronoun.m3(self_examine)] a pair of gloves of some kind!"
		. += str
	else if(FR && length(FR.blood_DNA))
		var/hand_number = get_num_arms(FALSE)
		if(hand_number)
			if(is_stupid)
				. += "[pronoun.m3(self_examine)] got weird hands! They don't look right!"
			else
				. += "[pronoun.m3(self_examine)][hand_number > 1 ? "" : " a"] <span class='bloody'>blood-stained</span> hand[hand_number > 1 ? "s" : ""]!"

	//belt
	if(belt && !(SLOT_BELT in obscured))
		var/str = "[pronoun.m3(self_examine)] [get_item_examine_label(belt, user)] about [pronoun.m2(self_examine)] waist. "
		str += belt.integrity_check(is_smart, guarded)
		. += str

	//right belt
	if(beltr && !(SLOT_BELT_R in obscured))
		var/str = "[pronoun.m3(self_examine)] [get_item_examine_label(beltr, user)] on [pronoun.m2(self_examine)] belt. "
		str += beltr.integrity_check(is_smart, guarded)
		. += str

	//left belt
	if(beltl && !(SLOT_BELT_L in obscured))
		var/str = "[pronoun.m3(self_examine)] [get_item_examine_label(beltl, user)] on [pronoun.m2(self_examine)] belt. "
		str += beltl.integrity_check(is_smart)
		. += str

	//shoes
	if(shoes && !(SLOT_SHOES in obscured))
		var/str = "[pronoun.m3(self_examine)] [shoes.generate_tooltip(shoes.get_examine_string(user))] on [pronoun.m2(self_examine)] feet. "
		str += shoes.integrity_check(is_smart, guarded)
		if(is_stupid)
			str = "[pronoun.m3(self_examine)] some shoes on [pronoun.m2(self_examine)] feet!"
		. += str

	//mask
	if(wear_mask && !(SLOT_WEAR_MASK in obscured))
		var/str = "[pronoun.m3(self_examine)] [wear_mask.generate_tooltip(wear_mask.get_examine_string(user))] on [pronoun.m2(self_examine)] face. "
		str += wear_mask.integrity_check(is_smart, guarded)
		if(is_stupid)
			str = "[pronoun.m3(self_examine)] some kinda thing on [pronoun.m2(self_examine)] face!"
		. += str

	//mouth
	if(mouth && !(SLOT_MOUTH in obscured))
		var/str
		if(istype(mouth, /obj/item/clothing))
			var/obj/item/clothing/CM = mouth
			str = "[pronoun.m3(self_examine)] [CM.generate_tooltip(CM.get_examine_string(user))] in [pronoun.m2(self_examine)] mouth. "
		else
			"[pronoun.m3(self_examine)] [get_item_examine_label(mouth, user)] in [pronoun.m2(self_examine)] mouth. "
		str += mouth.integrity_check(is_smart, guarded)
		if(is_stupid)
			str = "[pronoun.m3(self_examine)] some kinda thing on [pronoun.m2(self_examine)] mouth!"
		. += str

	//neck
	if(wear_neck && !(SLOT_NECK in obscured))
		var/str = "[pronoun.m3(self_examine)] [wear_neck.generate_tooltip(wear_neck.get_examine_string(user))] around [pronoun.m2(self_examine)] neck. "
		str += wear_neck.integrity_check(is_smart, guarded)
		if (is_stupid)
			str = "[pronoun.m3(self_examine)] something on [pronoun.m2(self_examine)] neck!"
		. += str

	//eyes
	if(!(SLOT_GLASSES in obscured))
		if(glasses)
			. += "[pronoun.m3(self_examine)] [get_item_examine_label(glasses, user)] covering [pronoun.m2(self_examine)] eyes."
		else if(eye_color == BLOODCULT_EYE)
			. += span_warning("<B>[pronoun.m2(self_examine)] eyes are glowing an unnatural red!</B>")

	//ears
	if(ears && !(SLOT_HEAD in obscured))
		. += "[pronoun.m3(self_examine)] [get_item_examine_label(ears, user)] on [pronoun.m2(self_examine)] ears."

	//ID
	if(wear_ring && !(SLOT_RING in obscured))
		var/str = "[pronoun.m3(self_examine)] [wear_ring.generate_tooltip(wear_ring.get_examine_string(user))] on [pronoun.m2(self_examine)] hands. "
		if(is_smart && istype(wear_ring, /obj/item/clothing/ring/active))
			var/obj/item/clothing/ring/active/AR = wear_ring
			if(AR.cooldowny)
				if(world.time < AR.cooldowny + AR.cdtime)
					str += span_warning("It cannot activate again, yet.")
				else
					str += span_warning("It is ready to use.")
		if(is_stupid)
			str = "[pronoun.m3(self_examine)] some sort of ring!"
		. += str

	//wrists
	if(wear_wrists && !(SLOT_WRISTS in obscured))
		var/str = "[pronoun.m3(self_examine)] [wear_wrists.generate_tooltip(wear_wrists.get_examine_string(user))] on [pronoun.m2(self_examine)] wrists."
		str += wear_wrists.integrity_check(is_smart, guarded)
		if (is_stupid)
			str = "[pronoun.m3(self_examine)] something on [pronoun.m2(self_examine)] wrists!"
		. += str

	//arcyne ward
	if(istype(skin_armor, /obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward))
		var/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/ward = skin_armor
		var/str = "[pronoun.m3(self_examine)] <font color='[ward.ward_color]'>[ward.generate_tooltip(ward.get_examine_string(user))] shimmering around [user == src ? "me" : pronoun.p_them()].</font>"
		str += ward.integrity_check(is_smart, guarded)
		if (is_stupid)
			str = "[pronoun.m3(self_examine)] some weird shiny thing!"
		. += str

	pronoun = get_pronoun()

	//handcuffed?
	if(handcuffed)
		if(user == src)
			. += "<span class='warning'>[pronoun.m1(self_examine)] tied up with \a [handcuffed]!</span>"
		else
			. += "<A href='?src=[REF(src)];item=[SLOT_HANDCUFFED]'><span class='warning'>[pronoun.m1(self_examine)] tied up with \a [handcuffed]!</span></A>"

	if(legcuffed)
		. += "<A href='?src=[REF(src)];item=[SLOT_LEGCUFFED]'><span class='warning'>[pronoun.m3(self_examine)] \a [legcuffed] around [pronoun.m2(self_examine)] legs!</span></A>"

	var/datum/status_effect/bugged/effect = has_status_effect(/datum/status_effect/bugged)
	if(effect && HAS_TRAIT(user, TRAIT_INQUISITION))
		. += "<A href='?src=[REF(src)];item=[effect.device]'><span class='warning'>[pronoun.m3(self_examine)] \a [effect.device] implanted.</span></A>"

	//Gets encapsulated with a warning span
	var/list/msg = list()

	var/appears_dead = FALSE
	if(stat == DEAD || (HAS_TRAIT(src, TRAIT_FAKEDEATH)))
		appears_dead = TRUE

	var/temp = getBruteLoss() + getFireLoss() //no need to calculate each of these twice

	if (get_bodypart(BODY_ZONE_HEAD)?.grievously_wounded)
		msg += span_bloody("<b>[pronoun.p_their(TRUE)] neck is a ghastly ruin of blood and bone, barely hanging on!</b>")

	if(!(user == src && src.hal_screwyhud == SCREWYHUD_HEALTHY)) //fake healthy
		// Damage
		switch(temp)
			if(5 to 25)
				msg += "[pronoun.m1(self_examine)] a little wounded."
			if(25 to 50)
				msg += "[pronoun.m1(self_examine)] wounded."
			if(50 to 100)
				msg += "<B>[pronoun.m1(self_examine)] severely wounded.</B>"
			if(100 to INFINITY)
				msg += span_danger("[pronoun.m1(self_examine)] gravely wounded.")

	// Blood volume
	switch(blood_volume)
		if(-INFINITY to BLOOD_VOLUME_SURVIVE)
			msg += span_artery("<B>[pronoun.m1(self_examine)] extremely pale and sickly.</B>")
		if(BLOOD_VOLUME_SURVIVE to BLOOD_VOLUME_BAD)
			msg += span_artery("<B>[pronoun.m1(self_examine)] very pale.</B>")
		if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_OKAY)
			msg += span_artery("[pronoun.m1(self_examine)] pale.")
		if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
			msg += span_artery("[pronoun.m1(self_examine)] a little pale.")

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
			pronoun = get_pronoun()
			if(length(bleeding_limbs))
				if(bleed_rate >= 5)
					msg += span_bloody("<B>[capitalize(pronoun.m2(self_examine))] [english_list(bleeding_limbs)] [bleeding_limbs.len > 1 ? "are" : "is"] [bleed_wording]!</B>")
				else
					msg += span_bloody("[capitalize(pronoun.m2(self_examine))] [english_list(bleeding_limbs)] [bleeding_limbs.len > 1 ? "are" : "is"] [bleed_wording]!")
			else
				if(bleed_rate >= 5)
					msg += span_bloody("<B>[pronoun.m1(self_examine)] [bleed_wording]</B>!")
				else
					msg += span_bloody("[pronoun.m1(self_examine)] [bleed_wording]!")
		else
			if(isliving(user))
				var/mob/living/M = user
				pronoun = get_pronoun()
				if(M.patron.type == /datum/patron/inhumen/graggar)
					msg += span_bloody("[pronoun.m1(self_examine)] shedding lyfe's blood, exposing weakness!")
				else
					msg += span_bloody("[pronoun.m1(self_examine)] letting out the red stuff!")

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
		pronoun = get_pronoun()
		var/missing_limb_message = "<B>[capitalize(pronoun.m2(self_examine))] [english_list(missing_limbs)] [missing_limbs.len > 1 ? "are" : "is"] gone.</B>"
		if(missing_head)
			missing_limb_message = span_dead("[missing_limb_message]")
		else
			missing_limb_message = span_danger("[missing_limb_message]")
		msg += missing_limb_message

	//Grabbing
	if(pulledby && pulledby.grab_state)
		pronoun = get_pronoun()
		msg += "[pronoun.m1(self_examine)] being grabbed by [pulledby]."

	//Nutrition and Thirst
	if(nutrition < (NUTRITION_LEVEL_STARVING - 50))
		pronoun = get_pronoun()
		msg += "[pronoun.m1(self_examine)] looking emaciated."
//	else if(nutrition >= NUTRITION_LEVEL_FAT)
//		if(user.nutrition < NUTRITION_LEVEL_STARVING - 50)
//			msg += "[pronoun.p_they(TRUE)] [pronoun.p_are()] plump and delicious looking - Like a fat little piggy. A tasty piggy."
//		else
//			msg += "[pronoun.p_they(TRUE)] [pronoun.p_are()] quite chubby."

	if(HAS_TRAIT(user, TRAIT_EXTEROCEPTION))
		pronoun = get_pronoun()
		switch(nutrition)
			if(NUTRITION_LEVEL_HUNGRY to NUTRITION_LEVEL_FED)
				msg += "[pronoun.m1(self_examine)] looking peckish."
			if(NUTRITION_LEVEL_STARVING to NUTRITION_LEVEL_HUNGRY)
				msg += "[pronoun.m1(self_examine)] looking hungry."
			if(NUTRITION_LEVEL_STARVING-50 to NUTRITION_LEVEL_STARVING)
				msg += "[pronoun.m1(self_examine)] looking starved."
		switch(hydration)
			if(HYDRATION_LEVEL_THIRSTY to HYDRATION_LEVEL_SMALLTHIRST)
				msg += "[pronoun.m1(self_examine)] looking like [pronoun.m2(self_examine)] mouth is dry."
			if(HYDRATION_LEVEL_DEHYDRATED to HYDRATION_LEVEL_THIRSTY)
				msg += "[pronoun.m1(self_examine)] looking thirsty for a drink."
			if(0 to HYDRATION_LEVEL_DEHYDRATED)
				msg += "[pronoun.m1(self_examine)] looking parched."

	//Fire/water stacks
	if(has_status_effect(/datum/status_effect/fire_handler))
		pronoun = get_pronoun()
		msg += "[pronoun.m1(self_examine)] covered in something flammable."
	if(has_status_effect(/datum/status_effect/fire_handler/wet_stacks))
		pronoun = get_pronoun()
		msg += "[pronoun.m1(self_examine)] soaked."

	//Status effects
	var/list/status_examines = status_effect_examines()
	if(length(status_examines))
		msg += status_examines

	//Disgusting behemoth of stun absorption
	if(islist(stun_absorption))
		for(var/i in stun_absorption)
			if(stun_absorption[i]["end_time"] > world.time && stun_absorption[i]["examine_message"])
				pronoun = get_pronoun()
				msg += "[pronoun.m1(self_examine)][stun_absorption[i]["examine_message"]]"

	//Temporary wards and/or status effects go here, just for some more clarity.
	if(src.skin_armor && istype(src.skin_armor, /obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/bestowed))
		var/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/bestowed/W = src.skin_armor
		var/time_remaining = max(0, W.expires_at - world.time)
		var/total_seconds = round(time_remaining / 10)
		var/minutes = floor(total_seconds / 60)
		var/seconds = total_seconds % 60
		if(minutes > 0)
			msg += "<font color='#ffbd09'>A temporary ward surrounds them. It will last for [minutes] minute[minutes == 1 ? "" : "s"], [seconds] second[seconds == 1 ? "" : "s"].</font>"
		else
			msg += "<font color='#ffbd09'>A temporary ward surrounds them. It will last for [seconds] second[seconds == 1 ? "" : "s"].</font>"

	if(!appears_dead)
		if(!skipface)
			pronoun = get_pronoun()
			//Disgust
			switch(disgust)
				if(DISGUST_LEVEL_SLIGHTLYGROSS to DISGUST_LEVEL_GROSS)
					msg += "[pronoun.m1(self_examine)] a little disgusted."
				if(DISGUST_LEVEL_GROSS to DISGUST_LEVEL_VERYGROSS)
					msg += "[pronoun.m1(self_examine)] disgusted."
				if(DISGUST_LEVEL_VERYGROSS to DISGUST_LEVEL_DISGUSTED)
					msg += "[pronoun.m1(self_examine)] really disgusted."
				if(DISGUST_LEVEL_DISGUSTED to INFINITY)
					msg += "<B>[pronoun.m1(self_examine)] extremely disgusted.</B>"

			pronoun = get_pronoun()
			//Drunkenness
			switch(drunkenness)
				if(11 to 21)
					msg += "[pronoun.m1(self_examine)] slightly flushed."
				if(21.01 to 41) //.01s are used in case drunkenness ends up to be a small decimal
					msg += "[pronoun.m1(self_examine)] flushed."
				if(41.01 to 51)
					msg += "[pronoun.m1(self_examine)] quite flushed and [pronoun.m2(self_examine)] breath smells of alcohol."
				if(51.01 to 61)
					msg += "[pronoun.m1(self_examine)] very flushed, with breath reeking of alcohol."
				if(61.01 to 91)
					msg += "[pronoun.m1(self_examine)] looking like a drunken mess."
				if(91.01 to INFINITY)
					msg += "[pronoun.m1(self_examine)] a shitfaced, slobbering wreck."

			//Deadened
			if(user.has_empath_for(src) && HAS_TRAIT(src, TRAIT_DETACHED))
				pronoun = get_pronoun()
				msg += "[pronoun.m1(self_examine)] completely hollow inside, radiating a deep, tragic silence."

			//Stress
			var/stress = get_stress_amount()
			if(user.has_empath_for(src))
				pronoun = get_pronoun()
				switch(stress)
					if(20 to INFINITY)
						msg += "[pronoun.m1(self_examine)] extremely stressed."
					if(10 to 19)
						msg += "[pronoun.m1(self_examine)] very stressed."
					if(1 to 9)
						msg += "[pronoun.m1(self_examine)] a little stressed."
					if(-9 to 0)
						msg += "[pronoun.m1(self_examine)] not stressed."
					if(-19 to -10)
						msg += "[pronoun.m1(self_examine)] somewhat at peace."
					if(-20 to INFINITY)
						msg += "[pronoun.m1(self_examine)] at peace inside."
			else if(stress > 10)
				msg += "[pronoun.m3(self_examine)] stress all over [pronoun.m2(self_examine)] face."

		//Jitters
		pronoun = get_pronoun()
		switch(jitteriness)
			if(300 to INFINITY)
				msg += "<B>[pronoun.m1(self_examine)] convulsing violently!</B>"
			if(200 to 300)
				msg += "[pronoun.m1(self_examine)] extremely jittery."
			if(100 to 200)
				msg += "[pronoun.m1(self_examine)] twitching ever so slightly."

		pronoun = get_pronoun()
		if(InCritical())
			msg += span_warning("[pronoun.m1(self_examine)] barely conscious.")
		else
			if(stat >= UNCONSCIOUS)
				msg += "[pronoun.m1(self_examine)] [IsSleeping() ? "sleeping" : "unconscious"]."
			else if(eyesclosed)
				msg += "[capitalize(pronoun.m2(self_examine))] eyes are closed."
			else if(has_status_effect(/datum/status_effect/debuff/sleepytime))
				msg += "[pronoun.m1(self_examine)] looking a little tired."
	else
		pronoun = get_pronoun()
		msg += "[pronoun.m1(self_examine)] unconscious."
//		else
//			if(HAS_TRAIT(src, TRAIT_DUMB))
//				msg += "[pronoun.m3(self_examine)] a stupid expression on [pronoun.m2(self_examine)] face."
//			if(InCritical())
//				msg += "[pronoun.m1(self_examine)] barely conscious."
//		if(getorgan(/obj/item/organ/brain))
//			if(!key)
//				msg += span_deadsay("[pronoun.m1(self_examine)] totally catatonic. The stresses of life in deep-space must have been too much for [t_him]. Any recovery is unlikely.")
//			else if(!client)
//				msg += "[pronoun.m3(self_examine)] a blank, absent-minded stare and appears completely unresponsive to anything. [pronoun.p_they(TRUE)] may snap out of it soon."

	if(length(msg))
		. += span_warning("[msg.Join("\n")]")

	// Show especially large embedded objects at a glance
	for(var/obj/item/bodypart/part as anything in bodyparts)
		if(LAZYLEN(part.embedded_objects))
			for(var/obj/item/stuck_thing as anything in part.embedded_objects)
				if(stuck_thing.w_class >= WEIGHT_CLASS_SMALL)
					pronoun = get_pronoun()
					. += span_bloody("<b>[pronoun.m3(self_examine)] \a [stuck_thing] stuck in [pronoun.m2(self_examine)] [part.name]!</b>")

	if((user != src) && isliving(user))
		var/mob/living/L = user
		var/final_str = STASTR
		var/final_con = STACON
		if(HAS_TRAIT(src, TRAIT_DECEIVING_MEEKNESS))
			final_str = L.STASTR - rand(1,2)
			final_con = L.STACON - rand(1,2)
		var/strength_diff = final_str - L.STASTR
		var/con_diff = final_con - L.STACON

		var/str_desc
		var/str_extreme = FALSE
		switch(strength_diff)
			if(5 to INFINITY)
				str_desc = "much stronger"
				str_extreme = TRUE
			if(1 to 5)
				str_desc = "stronger"
			if(-5 to -1)
				str_desc = "weaker"
			if(-INFINITY to -5)
				str_desc = "much weaker"
				str_extreme = TRUE

		var/con_desc
		var/con_extreme = FALSE
		switch(con_diff)
			if(5 to INFINITY)
				con_desc = "much tougher"
				con_extreme = TRUE
			if(1 to 5)
				con_desc = "tougher"
			if(-5 to -1)
				con_desc = "frailer"
			if(-INFINITY to -5)
				con_desc = "much frailer"
				con_extreme = TRUE

		var/is_extreme = str_extreme || con_extreme
		var/phys_msg
		pronoun = get_pronoun()
		if(str_desc && con_desc)
			var/connector = ((strength_diff > 0) == (con_diff > 0)) ? "and" : "but"
			phys_msg = "[pronoun.p_they(TRUE)] look[p_s()] [str_desc] [connector] [con_desc] than me."
		else if(str_desc)
			phys_msg = "[pronoun.p_they(TRUE)] look[p_s()] [str_desc] than me."
		else if(con_desc)
			phys_msg = "[pronoun.p_they(TRUE)] look[p_s()] [con_desc] than me."
		else
			phys_msg = "[pronoun.p_they(TRUE)] look[p_s()] about as strong as I."

		if(is_extreme)
			. += span_warning("<B>[phys_msg]</B>")
		else if(str_desc || con_desc)
			. += span_warning(phys_msg)
		else
			. += phys_msg

	if((HAS_TRAIT(user,TRAIT_INTELLECTUAL)))
		var/mob/living/L = user
		var/final_int = STAINT
		if(HAS_TRAIT(src, TRAIT_DECEIVING_MEEKNESS))
			final_int = L.STAINT
		var/int_diff = final_int - L.STAINT
		pronoun = get_pronoun()
		switch(int_diff)
			if(5 to INFINITY)
				. += span_revenwarning("[pronoun.p_they(TRUE)] look[p_s()] far more intelligent than me.")
			if(2 to 5)
				. += span_revenminor("[pronoun.p_they(TRUE)] look[p_s()] smarter than me.")
			if(-1 to 1)
				. += "[pronoun.p_they(TRUE)] look[p_s()] about as intelligent as I."
			if(-5 to -2)
				. += span_revennotice("[pronoun.p_they(TRUE)] look[p_s()] dumber than me.")
			if(-INFINITY to -5)
				. += span_revennotice("[pronoun.p_they(TRUE)] look[p_s()] as blunt-minded as a rock.")

	if(maniac)
		var/obj/item/organ/heart/heart = getorganslot(ORGAN_SLOT_HEART)
		if(heart?.inscryption && (heart.inscryption_key in maniac.key_nums))
			pronoun = get_pronoun()
			. += span_danger("[pronoun.p_they(TRUE)] know[p_s()] [heart.inscryption_key], I AM SURE OF IT!")

	if(!HAS_TRAIT(src, TRAIT_DECEIVING_MEEKNESS) && user != src)
		if(isliving(user))
			var/mob/living/L = user
			if((L.STAINT > 9 && L.STAPER > 9) || HAS_TRAIT(L, TRAIT_INTELLECTUAL))
				if(HAS_TRAIT(src, TRAIT_COMBAT_AWARE))
					pronoun = get_pronoun()
					. += span_warning("<i>[pronoun.m1(self_examine)] battle-aware.</i>")
				if(HAS_TRAIT(src, TRAIT_DEATHLESS) && !mind?.has_antag_datum(/datum/antagonist/vampire))
					pronoun = get_pronoun()
					. += span_warning("<i>[pronoun.m1(self_examine)] absent of lyfe. [pronoun.p_they(TRUE)] will linger even without blood.</i>")
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
					if(!skilldiff)
						. += "<font size = 3><i>[skilldiff_report(skilldiff)] in our wielded skills.</i></font>"
					else
						. += "<font size = 3><i>[skilldiff_report(skilldiff)] in my wielded skill than they are in theirs.</i></font>"

	if(lip_style)
		pronoun = get_pronoun()
		switch(lip_color)
			if("red")
				. += "<span class='info' style='color: #a81324'>[pronoun.m1(self_examine)] wearing red lipstick.</span>"
			if("purple")
				. += "<span class='info' style='color: #800080'>[pronoun.m1(self_examine)] wearing purple lipstick.</span>"
			if("lime")
				. += "<span class='info' style='color: #00FF00'>[pronoun.m1(self_examine)] wearing lime lipstick.</span>"
			if("black")
				. += "<span class='info' style='color: #313131ff'>[pronoun.m1(self_examine)] wearing black lipstick.</span>"


	if(show_descriptors)
		var/list/lines
		if((get_face_name() != real_name) && !observer_privilege)
			lines = build_cool_description_unknown(get_mob_descriptors_unknown(obscure_name, user), src)
		else
			lines = build_cool_description(get_mob_descriptors(obscure_name, user), src)

		var/app_str
		if(!(user.client?.prefs?.full_examine))
			app_str = "<details><summary>[span_info("Details")]</summary>"

		for(var/i in 1 to length(lines))
			app_str += span_info(lines[i])
			if(i != length(lines))
				app_str += "<br>"
		if(!(user.client?.prefs?.full_examine))
			if(length(lines))
				app_str += "</details>"

		. += app_str

	// Characters with the targeted flaw will freak out if they can't see someone's face.
	if(!appears_dead)
		if(skipface && user.has_flaw(/datum/charflaw/targeted) && user != src)
			user.add_stress(/datum/stressevent/targeted)

	if(dna?.species?.type == /datum/species/gnoll)
		if(istype(user, /mob/living/carbon/human)) //Submitting this one upstream because not our shitcode for once
			var/mob/living/carbon/human/H = user
			if(H.dna?.species?.type == /datum/species/gnoll)
				if(user.advjob)
					. += span_notice("<i>They are a [advjob] of the pack.</i>")

	var/trait_exam = common_trait_examine()
	if(!isnull(trait_exam))
		. += trait_exam

	if(!user.client?.prefs?.top_examine)
		. += generate_main_examine_body(user, self_examine, obscure_name, race_name, origin_name, observer_privilege, unknown_names)

	if(pose_text)
		. += fieldset_block("Pose", pose_text, "pose_block")

	SEND_SIGNAL(src, COMSIG_PARENT_EXAMINE, user, .)

/mob/living/carbon/human/proc/generate_main_examine_body(mob/user, self_examine, obscure_name, race_name, origin_name, observer_privilege, list/unknown_names)
	. = list()
	var/datum/pronouns/pronoun = get_pronoun() // here we go again
	if(name in unknown_names)
		. += span_info("ø ------------ ø\nThis is <EM>[name]</EM>.")
	else if(obscure_name && !client?.prefs?.masked_examine)
		. += span_info("ø ------------ ø\nThis is an unknown <EM>[name]</EM>.")
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
				. += (span_info("ø ------------ ø\n[chat_headshot(displayed_headshot)]\nThis is <EM>[used_name]</EM>, the wandering [race_name]."))
			else if(used_title)
				. += (span_info("ø ------------ ø\n[chat_headshot(displayed_headshot)]\nThis is <EM>[used_name]</EM>, the [race_name] [used_title]."))
			else
				. += (span_info("ø ------------ ø\n[chat_headshot(displayed_headshot)]\nThis is the <EM>[used_name]</EM>, the [race_name]."))
		else
			if(display_as_wanderer)
				. += (span_info("ø ------------ ø\nThis is <EM>[used_name]</EM>, the wandering [race_name]."))
			else if(used_title)
				. += (span_info("ø ------------ ø\nThis is <EM>[used_name]</EM>, the [race_name] [used_title]."))
			else
				. += (span_info("ø ------------ ø\nThis is the <EM>[used_name]</EM>, the [race_name]."))

		//Origins
		var/pnoun	//They / Their
		if(!dna.species.use_skin_tone_wording_for_examine)
			if(user == src)
				pnoun = "I"
			else
				pnoun = capitalize(pronoun.p_they(TRUE))
		else
			pnoun = capitalize(pronoun.m2(self_examine))
		var/wording = (dna.species.use_skin_tone_wording_for_examine ? "[lowertext(dna.species.skin_tone_wording)]" : "hail[(user == src) ? "" : "s"] from")	//Ancestry / Tribe or hails from
		var/origin
		if(dna.species.use_skin_tone_wording_for_examine)
			if(dna.species.origin == "Unknown")
				origin = span_bold("is implacable..")
			else
				origin = "originates in [origin_name]"
		else
			if(dna.species.origin == "Unknown")
				origin = span_bold("nowhere..")
			else
				origin = dna.species.origin
		var/astratan_symbol
		var/astratan_tooltip
		if(HAS_TRAIT(user, TRAIT_ASTRATAN_AFFINITY) && get_dist(user, src) <= 2)
			if(!HAS_TRAIT(src, TRAIT_DECEIVING_MEEKNESS))	//Guarded virtue protects from this
				if(issunelf(src) || patron?.type == /datum/patron/divine/astrata)
					astratan_symbol = icon2html('icons/misc/language.dmi', world, "celestial")
					astratan_tooltip = SPAN_TOOLTIP("One of Astrata's [issunelf(src) ? "chosen" : "followers"]", astratan_symbol)
		. += span_info("[pnoun] [wording] [origin]. [astratan_tooltip]")	//"He hails from [X / Nowhere]" || "His [word] originates from [X]" || "His [word] is implacable..."

		if(HAS_TRAIT(src, TRAIT_WITCH))
			if(HAS_TRAIT(user, TRAIT_NOBLE) || HAS_TRAIT(user, TRAIT_INQUISITION) || HAS_TRAIT(user, TRAIT_WITCH))
				. += span_warning("A witch! Their presence brings an unsettling aura.")
			else if(HAS_TRAIT(user, TRAIT_FREEMAN) || HAS_TRAIT(user, TRAIT_CABAL) || HAS_TRAIT(user, TRAIT_HORDE) || HAS_TRAIT(user, TRAIT_DEPRAVED))
				. += span_notice("A practitioner of the old ways.")
			else
				. += span_notice("Something about them seems... different.")

		if((HAS_TRAIT(user, TRAIT_ANCIENT_HAG) || HAS_TRAIT(user, TRAIT_FEYTOUCHED) || istype(user, /mob/living/simple_animal/pet/familiar/fae)) && HAS_TRAIT(src, TRAIT_FEYTOUCHED))
			. += span_nicegreen("Someone touched by, or created by fey. Perhaps a vessel of the past, or a deeply affected puppet.")

		if((HAS_TRAIT(user, TRAIT_FEYTOUCHED) ||  istype(user, /mob/living/simple_animal/pet/familiar/fae)) && HAS_TRAIT(src, TRAIT_ANCIENT_HAG))
			. += span_nicegreen("A true force of the fey, the mossmother speaks to this one closely.")

		if(SSticker.rulermob == src)
			. += span_notice("<b>The ruler of this land.</b>")
		else if(GLOB.lord_titles[name])
			pronoun = get_pronoun()
			. += span_notice("[pronoun.m3(self_examine)] been granted the title of \"[GLOB.lord_titles[name]]\".")

		if(HAS_TRAIT(src, TRAIT_NOBLE) || HAS_TRAIT(src, TRAIT_DEFILED_NOBLE))
			if(HAS_TRAIT(user, TRAIT_NOBLE) || HAS_TRAIT(user, TRAIT_DEFILED_NOBLE))
				. += span_notice("A fellow noble.")
			else
				. += span_notice("A noble!")

		if(HAS_TRAIT(src, TRAIT_RESIDENT))
			. += span_notice("A chartered resident of Azuria.")

		if(HAS_TRAIT(src, TRAIT_AGENT_MERCHANT))
			. += span_notice("An agent of the Azurian Trading Company.")
		if(HAS_TRAIT(src, TRAIT_AGENT_BATHHOUSE))
			. += span_notice("An agent of the Bathhouse.")
		if(HAS_TRAIT(src, TRAIT_ARMOR_BREAK))
			pronoun = get_pronoun()
			. += span_phobia("[capitalize(pronoun.m2(self_examine))] armor hangs on by a thread...")

		if(HAS_TRAIT(src, TRAIT_DEBTOR))
			if(ishuman(user))
				var/mob/living/carbon/human/viewer = user
				var/saw_specific = FALSE
				if(HAS_TRAIT(src, TRAIT_DEBTOR_CHURCH) && (viewer.job in GLOB.church_positions))
					. += span_userdanger("DEFAULT DEBTOR OF THE CHURCH!")
					saw_specific = TRUE
				if(HAS_TRAIT(src, TRAIT_DEBTOR_MERCHANT) && (viewer.job == "Merchant" || viewer.job == "Shophand" || HAS_TRAIT(viewer, TRAIT_AGENT_MERCHANT)))
					. += span_userdanger("DEFAULT DEBTOR OF THE TRADING COMPANY!")
					saw_specific = TRUE
				if(HAS_TRAIT(src, TRAIT_DEBTOR_BATHHOUSE) && (viewer.job == "Bathmaster" || viewer.job == "Bathhouse Attendant" || HAS_TRAIT(viewer, TRAIT_AGENT_BATHHOUSE)))
					. += span_userdanger("DEFAULT DEBTOR OF THE BATHHOUSE!")
					saw_specific = TRUE
				if(!saw_specific && HAS_TRAIT(src, TRAIT_DEBTOR_CROWN))
					if((viewer.job in GLOB.garrison_positions) || (viewer.job in GLOB.retinue_positions) || (viewer.job in GLOB.courtier_positions) || (viewer.job in GLOB.noble_positions))
						. += span_userdanger("DEFAULT DEBTOR OF THE CROWN!")

		if(HAS_TRAIT(src, TRAIT_ARREARS))
			// Poll-tax arrears: a soft mark. Authority roles (garrison, retinue, courtier, noble)
			// can read it off a subject, but only as a hint - the actual amount owed lives with
			// the Steward, and enforcement is up to whoever spots it.
			if(ishuman(user))
				var/mob/living/carbon/human/viewer = user
				if((viewer.job in GLOB.garrison_positions) || (viewer.job in GLOB.retinue_positions) || (viewer.job in GLOB.courtier_positions) || (viewer.job in GLOB.noble_positions))
					. += span_smallred("Destitute..")

		if(src.job in GLOB.church_positions)
			. += span_notice("A member of the Church of Azuria.")
		else if(HAS_TRAIT(src, TRAIT_AGENT_CHURCH))
			. += span_notice("A benefactor of the Church of Azuria.")

		if(src.job in GLOB.inquisition_positions)
			. += span_notice("An adherent of the Holy Otavan Inquisition.")

		if((HAS_TRAIT(user, TRAIT_BLACKOAK) && !(src.dna.species.name == "Elf" || src.dna.species.name == "Dark Elf" || src.dna.species.name == "Half-Elf")))
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
					pronoun = get_pronoun()
					. += span_syndradio("[pronoun.m3(self_examine)] a bounty on [pronoun.m2(self_examine)] head of [b.amount] mammon for [b.reason], issued by [b.employer].")
					break

		if(name in GLOB.court_agents)
			var/datum/job/J = SSjob.GetJob(user.mind?.assigned_role)
			if(J?.department_flag & GARRISON || J?.department_flag & NOBLEMEN || J?.department_flag & COURTIERS || J?.department_flag & RETINUE)
				pronoun = get_pronoun()
				. += span_greentext("<b>[pronoun.m1(self_examine)] an agent of the court!</b>")

		if(user != src && !HAS_TRAIT(src, TRAIT_DECEIVING_MEEKNESS))
			if(has_flaw(/datum/charflaw/addiction/lovefiend) && user.has_flaw(/datum/charflaw/addiction/lovefiend))
				pronoun = get_pronoun()
				. += span_aiprivradio("[pronoun.m1(self_examine)] as lovesick as I.")

			if(has_flaw(/datum/charflaw/addiction/junkie) && user.has_flaw(/datum/charflaw/addiction/junkie))
				pronoun = get_pronoun()
				. += span_deadsay("[pronoun.m1(self_examine)] carrying the same dust marks on their nose as I.")

			if(has_flaw(/datum/charflaw/addiction/smoker) && user.has_flaw(/datum/charflaw/addiction/smoker))
				pronoun = get_pronoun()
				. += span_suppradio("[pronoun.m1(self_examine)] enveloped by the familiar, faint stench of smoke. I know it well.")

			if(has_flaw(/datum/charflaw/addiction/alcoholic) && user.has_flaw(/datum/charflaw/addiction/alcoholic))
				pronoun = get_pronoun()
				. += span_syndradio("[pronoun.m1(self_examine)] struggling to hide the hangover, and the stench of spirits. We're alike.")

			if(user.has_flaw(/datum/charflaw/addiction/paranoid))
				var/datum/charflaw/addiction/paranoid/pflaw = user.get_flaw(/datum/charflaw/addiction/paranoid)
				if(ishuman(user))
					if(has_flaw(/datum/charflaw/addiction/paranoid))
						pronoun = get_pronoun()
						. += span_nicegreen("[pronoun.m1(self_examine)] is the kind who sticks to their own. I understand.")
						user.sate_addiction(/datum/charflaw/addiction/paranoid)
					else if(pflaw)
						if(pflaw.check_faction(src))
							. += span_nicegreen("One of my own.")
							user.sate_addiction(/datum/charflaw/addiction/paranoid)
						else
							user.add_stress(/datum/stressevent/paracrowd)

			if(has_flaw(/datum/charflaw/addiction/masochist) && user.has_flaw(/datum/charflaw/addiction/sadist))
				pronoun = get_pronoun()
				. += span_secradio("[pronoun.m1(self_examine)] marked by scars inflicted for pleasure. A delectable target for my urges.")

			if(has_flaw(/datum/charflaw/addiction/sadist) && user.has_flaw(/datum/charflaw/addiction/masochist))
				pronoun = get_pronoun()
				. += span_secradio("[pronoun.m1(self_examine)] looking with eyes filled with a desire to inflict pain. So exciting.")

			if(has_flaw(/datum/charflaw/addiction/thrillseeker) && user.has_flaw(/datum/charflaw/addiction/thrillseeker))
				pronoun = get_pronoun()
				. += span_rose("[pronoun.m1(self_examine)] twitching for a thrilling fight. So am I.")
			
			if(user.has_flaw(/datum/charflaw/averse))
				var/datum/charflaw/averse/averseflaw = user.get_flaw(/datum/charflaw/averse)
				if(averseflaw?.check_aversion(user, src))
					user.add_stress(/datum/stressevent/averse)
					. += span_secradio("One of <b>them...</b>")

			if(user.has_flaw(/datum/charflaw/addiction/voyeur) && get_dist(src, user) <= 3)
				if(charflaws.len)
					var/list/vice_desc = list()
					for(var/datum/charflaw/cf in charflaws)
						if(cf.voyeur_descriptor)
							vice_desc.Add(cf.voyeur_descriptor)
					if(length(vice_desc))
						pronoun = get_pronoun()
						. += span_voyeurvice("[pronoun.m1(self_examine)] [english_list(vice_desc)]...")

			if(HAS_TRAIT(user, TRAIT_EMPATH) && HAS_TRAIT(src, TRAIT_PERMAMUTE))
				pronoun = get_pronoun()
				. += span_notice("[pronoun.m1(self_examine)] lacks a voice. [pronoun.m1(self_examine)] is a mute!")

		var/villain_text = get_villain_text(user)
		if(villain_text)
			. += villain_text
		var/heretic_text = get_heretic_text(user)
		if(heretic_text)
			. += span_notice(heretic_text)
		var/inquisition_text = get_inquisition_text(user)
		if(inquisition_text)
			. +=span_notice(inquisition_text)
		var/clergy_text = get_clergy_text(user)
		if(clergy_text)
			. +=span_notice(clergy_text)

		if (HAS_TRAIT(src, TRAIT_LEPROSY))
			. += span_necrosis("A LEPER...")

		var/we_got_spooked
		if (HAS_TRAIT(src, TRAIT_BEAUTIFUL_UNCANNY) && user != src)
			we_got_spooked = prob(50)
			if(we_got_spooked)
				user.add_stress(/datum/stressevent/uncanny)
			else
				user.add_stress(/datum/stressevent/beautiful)		

		if (HAS_TRAIT(src, TRAIT_BEAUTIFUL) || HAS_TRAIT(src, TRAIT_BEAUTIFUL_UNCANNY) || (issunelf(src) && issunelf(user)))
			pronoun = get_pronoun()
			switch (get_first_pronoun())
				if (HE_HIM)
					. += span_beautiful_masc("[pronoun.m1(self_examine)] handsome! [we_got_spooked ? "...Something is deeply wrong." : ""]")
				if (SHE_HER)
					. += span_beautiful_fem("[pronoun.m1(self_examine)] beautiful! [we_got_spooked ? "...Something is deeply wrong." : ""]")
				if (THEY_THEM, IT_ITS)
					. += span_beautiful_nb("[pronoun.m1(self_examine)] good-looking! [we_got_spooked ? "...Something is deeply wrong." : ""]")

		if (HAS_TRAIT(src, TRAIT_UNSEEMLY))
			pronoun = get_pronoun()
			switch (get_first_pronoun())
				if (HE_HIM)
					. += span_redtext("[pronoun.m1(self_examine)] revolting!")
				if (SHE_HER)
					. += span_redtext("[pronoun.m1(self_examine)] repugnant!")
				if (THEY_THEM, IT_ITS)
					. += span_redtext("[pronoun.m1(self_examine)] repulsive!")

		var/datum/antagonist/vampire/vamp_inspect_vlord = src.mind?.has_antag_datum(/datum/antagonist/vampire/lord)
		if(vamp_inspect_vlord && (!SEND_SIGNAL(src, COMSIG_DISGUISE_STATUS)))
			. += span_userdanger("A MONSTER!")

		var/datum/antagonist/vampire/vamp_inspect = src.mind?.has_antag_datum(/datum/antagonist/vampire)
		if(vamp_inspect && (!SEND_SIGNAL(src, COMSIG_DISGUISE_STATUS)))
			pronoun = get_pronoun()
			. += span_redtext("[pronoun.m3(self_examine)] strange glowing eyes and fangs!")
	
		//Blackblood Inquisition trauma
		if(HAS_TRAIT(src, TRAIT_INQUISITION) && HAS_TRAIT(user, TRAIT_BLACKBLOOD))
			var/mob/living/carbon/carbs = user
			if(HAS_TRAIT(user, TRAIT_PSYDONIAN_GRIT) || HAS_TRAIT(user, TRAIT_NOMOOD))
				return
			if(!carbs.has_stress_event(/datum/stressevent/inq_trauma))
				carbs.add_stress(/datum/stressevent/inq_trauma)
				if(prob(20))
					carbs.stress_freakout()
				else if(prob(40))
					carbs.freak_out()
				else
					carbs.emote("gulp")
			if(!HAS_TRAIT(user, TRAIT_STEELHEARTED))
				carbs.Jitter(10)
				carbs.stuttering += 25

		// Shouldn't be able to tell they are unrevivable through a mask as a Necran
		if(HAS_TRAIT(src, TRAIT_DNR) && src != user)
			if(HAS_TRAIT(user, TRAIT_DEATHSIGHT) || stat == DEAD)
				. += span_danger("They extrude a pale aura. Their soul [stat == DEAD ? "was not" : "is not"] clean. This [stat == DEAD ? "was" : "is"] their only chance at lyfe.")

	// Real medical role can tell at a glance it is a waste of time, but only if the Necra message don't come first.

	if(user.get_skill_level(/datum/skill/misc/medicine) >= SKILL_LEVEL_EXPERT && src.stat == DEAD)
		if(HAS_TRAIT(src, TRAIT_DNR) && src != user && !HAS_TRAIT(user, TRAIT_DEATHSIGHT)) // A lot of conditional to avoid a redundant message, but we also want unknown DNRs to be covered.
			. += span_danger("Their body holds not even a glimmer of life. No medicine can bring them back.")

	if (HAS_TRAIT(src, TRAIT_CRITICAL_WEAKNESS) && (!HAS_TRAIT(src, TRAIT_VAMP_DREAMS)) && (!HAS_TRAIT(src, TRAIT_DECEIVING_MEEKNESS)))
		if(isliving(user))
			var/mob/living/L = user
			if(L.STAINT > 9 && L.STAPER > 9)
				. += span_redtext("<i>[pronoun.m1(self_examine)] critically fragile!</i>")

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

	var/showassess = FALSE
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(get_dist(src, H) <= ((2 + clamp(floor(((H.STAPER - 10))),-1, 4)) + HAS_TRAIT(user, TRAIT_INTELLECTUAL)))
			showassess = TRUE

	if((!obscure_name || client?.prefs.masked_examine) && (flavortext || headshot_link || ooc_notes))
		. += "<a href='?src=[REF(src)];task=view_headshot;'>Examine closer</a> [showassess ? " | <a href='?src=[REF(src)];task=assess;'>Assess</a>" : ""]"

	/// Rumours & Gossip
	if(length(rumour) || length(noble_gossip))
		if(!obscure_name || (obscure_name && client?.prefs.masked_examine) || observer_privilege)
			. += "<a href='?src=[REF(src)];task=view_rumours_gossip;'>Recall Rumours & Gossip</a>"

/mob/living/proc/status_effect_examines() //You can include this in any mob's examine() to show the examine texts of status effects!
	var/list/dat = list()
	var/datum/pronouns/pronoun = get_pronoun()
	for(var/V in status_effects)
		var/datum/status_effect/E = V
		if(E.examine_text)
			var/new_text = replacetext(E.examine_text, "SUBJECTPRONOUN", pronoun.p_they(TRUE))
			new_text = replacetext(new_text, "[pronoun.p_they(TRUE)] is", "[pronoun.p_they(TRUE)] [pronoun.p_are()]") //To make sure something become "They are" or "She is", not "They are" and "She are"
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

	if(HAS_TRAIT(src, TRAIT_DUSTRUNNER))
		var/mob/living/living_examiner = examiner
		if(HAS_TRAIT(examiner, TRAIT_DUSTRUNNER))
			heretic_text += "Fellow runner. The dust moves."
		else if(living_examiner?.patron?.type == /datum/patron/inhumen/matthios)
			heretic_text += "A Guild runner, by the look of them."
		else if(examiner.job in GLOB.bathhouse_positions)
			heretic_text += "One of the Guild's runners. I know the signs."

	if(HAS_TRAIT(src, TRAIT_FREEMAN))
		if(seer)
			heretic_text += "Matthiosian."
			if(HAS_TRAIT(examiner, TRAIT_FREEMAN))
				heretic_text += " To share with. To take with. For all, and us."
		else if(HAS_TRAIT(examiner, TRAIT_FREEMAN))
			heretic_text += "Fellow Free Man!"
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
	if(HAS_TRAIT(src, TRAIT_FREEMAN) && HAS_TRAIT(examiner, TRAIT_FREEMAN))
		heretic_text += "⚖️" //♠ is the original
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
	if(!HAS_TRAIT(examiner, TRAIT_INQUISITION)) //If the person doing the examining doesn't have the trait, we don't need to do the other four ifs
		return null
	if(HAS_TRAIT(src, TRAIT_INQUISITION) && HAS_TRAIT(examiner, TRAIT_INQUISITION))
		inquisition_text = "A fellow adherent to the Holy Otavan Inquisition's missives."
	if(HAS_TRAIT(src, TRAIT_PURITAN) && HAS_TRAIT(examiner, TRAIT_INQUISITION))
		inquisition_text = "My superior, sent by the Holy Otavan Inquisition to lead our sect."
	if(HAS_TRAIT(src, TRAIT_INQUISITION) && HAS_TRAIT(examiner, TRAIT_PURITAN))
		inquisition_text = "A subordinate to my authority, within the Holy Otavan Inquisition."
	if(HAS_TRAIT(src, TRAIT_PURITAN) && HAS_TRAIT(examiner, TRAIT_PURITAN))
		inquisition_text = "Myself. I lead this sect of the Holy Otavan Inquisition."
	if(HAS_TRAIT(src, TRAIT_MANORKEEPER) && HAS_TRAIT(examiner, TRAIT_INQUISITION))
		inquisition_text = "Our honored priest, this estate's keeper, and my superior's confidant."
	if(HAS_TRAIT(src, TRAIT_MANORKEEPER) && HAS_TRAIT(examiner, TRAIT_PURITAN))
		inquisition_text = "Our honored priest, this estate's keeper, and my trusted confidant."
	if(HAS_TRAIT(src, TRAIT_MANORKEEPER) && HAS_TRAIT(examiner, TRAIT_MANORKEEPER))
		inquisition_text = "Myself. I am a honored priest, this estate's keeper, and the Inquisitor's confidant."
	return inquisition_text

// Used for Church tags
/mob/living/proc/get_clergy_text(mob/examiner)
	var/clergy_text
	if(!HAS_TRAIT(examiner, TRAIT_CLERGY)) //If the person doing the examining doesn't have the trait, we don't need to do the other four ifs
		return null
	if(HAS_TRAIT(src, TRAIT_CLERGY) && HAS_TRAIT(examiner, TRAIT_CLERGY))
		clergy_text = "A fellow member of the Azurian Church of the Ten."
	if(HAS_TRAIT(src, TRAIT_CHOSEN) && HAS_TRAIT(examiner, TRAIT_CLERGY))
		clergy_text = "The Bishop, the leader of my Church and Chosen of the Ten."
	if(HAS_TRAIT(src, TRAIT_CLERGY) && HAS_TRAIT(examiner, TRAIT_CHOSEN))
		clergy_text = "A member of the clergy under my leadership, as willed by the Ten."
	if(HAS_TRAIT(src, TRAIT_CHOSEN) && HAS_TRAIT(examiner, TRAIT_CHOSEN))
		clergy_text = "Myself. I am the Bishop of Azuria, voice of the Ten in these lands."

	return clergy_text

/// Returns antagonist-related examine text for the mob, if any. Can return null.
/mob/living/proc/get_villain_text(mob/examiner)
	var/villain_text
	if(mind)
		if(mind.special_role == "Bandit")
			if(HAS_TRAIT(examiner, TRAIT_FREEMAN))
				villain_text = span_notice("Free man!")
			if(HAS_TRAIT(src,TRAIT_KNOWNCRIMINAL))
				villain_text = span_userdanger("BANDIT!")
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

/mob/living/proc/get_item_examine_label(obj/item/I, mob/living/user)
	var/examine_highlight_status = I.get_examine_highlight_status()
	var/item_examine_string = I.get_examine_string(user)
	if(examine_highlight_status)
		var/severity = examine_highlight_status[1]
		var/heresy_examine_tooltip = I.get_examine_highlight_description(examine_highlight_status) + "<br>" + I.get_examine_highlight_explanation(severity)
		item_examine_string = SPAN_TOOLTIP_DANGEROUS_HTML(heresy_examine_tooltip, I.get_examine_highlight_labeled_string(severity, item_examine_string))
	return item_examine_string
