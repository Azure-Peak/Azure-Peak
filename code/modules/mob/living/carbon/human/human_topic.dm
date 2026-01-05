GLOBAL_VAR_INIT(year, time2text(world.realtime,"YYYY"))
GLOBAL_VAR_INIT(year_integer, text2num(year)) // = 2013???

/mob/living/carbon/human/Topic(href, href_list)
	var/observer_privilege = isobserver(usr)

	if(href_list["task"] == "bloodpoolinfo")
		to_chat(usr, span_notice("Usable blood that yields Vitae and total blood is not the same thing. It takes some time for blood to become nourishing for us."))
		return

	if(href_list["task"] == "view_headshot")
		if(!ismob(usr))
			return
		var/datum/examine_panel/mob_examine_panel = new(src)
		mob_examine_panel.holder = src
		mob_examine_panel.viewing = usr
		mob_examine_panel.ui_interact(usr)
		return

	if(href_list["inspect_limb"] && (observer_privilege || usr.canUseTopic(src, BE_CLOSE, NO_DEXTERITY)))
		var/list/msg = list()
		var/mob/user = usr
		var/checked_zone = check_zone(href_list["inspect_limb"])
		var/obj/item/bodypart/bodypart = get_bodypart(checked_zone)
		if(bodypart)
			var/list/bodypart_status = bodypart.inspect_limb(user)
			if(length(bodypart_status))
				msg += bodypart_status
			else
				msg += "<B>[capitalize(bodypart.name)]:</B>"
				msg += "[bodypart] is healthy."
		else
			msg += "<B>[capitalize(parse_zone(checked_zone))]:</B>"
			msg += "<span class='dead'>Limb is missing!</span>"
		to_chat(usr, "<span class='info'>[msg.Join("\n")]</span>")

	if(href_list["embedded_object"] && usr.canUseTopic(src, BE_CLOSE, NO_DEXTERITY))
		var/obj/item/bodypart/L = locate(href_list["embedded_limb"]) in bodyparts
		if(!L)
			return
		var/obj/item/I = locate(href_list["embedded_object"]) in L.embedded_objects
		if(!I) //no item, no limb, or item is not in limb or in the person anymore
			return
		var/time_taken = I.embedding.embedded_unsafe_removal_time*I.w_class
		if(usr == src)
			usr.visible_message("<span class='warning'>[usr] attempts to remove [I] from [usr.p_their()] [L.name].</span>","<span class='warning'>I attempt to remove [I] from my [L.name]...</span>")
		else
			usr.visible_message("<span class='warning'>[usr] attempts to remove [I] from [src]'s [L.name].</span>","<span class='warning'>I attempt to remove [I] from [src]'s [L.name]...</span>")
		if(do_after(usr, time_taken, needhand = TRUE, target = src))
			if(QDELETED(I) || QDELETED(L) || !L.remove_embedded_object(I))
				return
			var/hort = FALSE
			hort = L.receive_damage(I.embedding.embedded_unsafe_removal_pain_multiplier*I.w_class)//It hurts to rip it out, get surgery you dingus.
			usr.put_in_hands(I)
			if (hort)
				emote("pain", TRUE)
			playsound(loc, 'sound/foley/flesh_rem.ogg', 100, TRUE, -2)
			if(usr == src)
				usr.visible_message("<span class='notice'>[usr] rips [I] out of [usr.p_their()] [L.name]!</span>", "<span class='notice'>I successfully remove [I] from my [L.name].</span>")
			else
				usr.visible_message("<span class='notice'>[usr] rips [I] out of [src]'s [L.name]!</span>", "<span class='notice'>I successfully remove [I] from [src]'s [L.name].</span>")

	if(href_list["bandage"] && usr.canUseTopic(src, BE_CLOSE, NO_DEXTERITY))
		var/obj/item/bodypart/L = locate(href_list["bandaged_limb"]) in bodyparts
		if(!L)
			return

		if(!usr.Adjacent(src))
			to_chat(usr, span_warning("I need to be closer to remove that!"))
			return

		var/obj/item/I = L.bandage
		if(!I)
			return
		if(usr == src)
			usr.visible_message("<span class='warning'>[usr] starts unbandaging [usr.p_their()] [L.name].</span>","<span class='warning'>I start unbandaging [L.name]...</span>")
		else
			usr.visible_message("<span class='warning'>[usr] starts unbandaging [src]'s [L.name].</span>","<span class='warning'>I start unbandaging [src]'s [L.name]...</span>")
		if(do_after(usr, 50, needhand = TRUE, target = src))
			if(QDELETED(I) || QDELETED(L) || (L.bandage != I))
				return
			L.remove_bandage()
			usr.put_in_hands(I)

	if(href_list["item"]) //canUseTopic check for this is handled by mob/Topic()
		var/slot = text2num(href_list["item"])
		if(slot in check_obscured_slots(TRUE))
			to_chat(usr, span_warning("I can't reach that! Something is covering it."))
			return

	if(href_list["species_lore"])
		if(!dna?.species?.desc)
			return
		var/datum/browser/popup = new(usr, "species_info", "<center>Lore</center>", 460, 550)
		popup.set_content(dna.species.desc)
		popup.open()
		return

	if(href_list["undiesthing"]) //canUseTopic check for this is handled by mob/Topic()
		if(!get_location_accessible(src, BODY_ZONE_PRECISE_GROIN, skipundies = TRUE))
			to_chat(usr, span_warning("I can't reach that! Something is covering it."))
			return
		if(!underwear)
			return
		usr.visible_message(span_warning("[usr] starts taking off [src]'s [underwear.name]."),span_warning("I start taking off [src]'s [underwear.name]..."))
		if(do_after(usr, 50, needhand = 1, target = src))
			var/obj/item/bodypart/chest = get_bodypart(BODY_ZONE_CHEST)
			chest.remove_bodypart_feature(underwear.undies_feature)
			underwear.forceMove(get_turf(src))
			if(iscarbon(usr))
				var/mob/living/carbon/C = usr
				C.put_in_hands(underwear)
			underwear = null

	if(href_list["legwearsthing"]) //canUseTopic check for this is handled by mob/Topic()
		if(!get_location_accessible(src, BODY_ZONE_PRECISE_GROIN, skipundies = TRUE))
			to_chat(usr, span_warning("I can't reach that! Something is covering it."))
			return
		if(!legwear_socks)
			return
		usr.visible_message(span_warning("[usr] starts taking off [src]'s [legwear_socks.name]."),span_warning("I start taking off [src]'s [legwear_socks.name]..."))
		if(do_after(usr, 50, needhand = 1, target = src))
			var/obj/item/bodypart/chest = get_bodypart(BODY_ZONE_CHEST)
			chest.remove_bodypart_feature(legwear_socks.legwears_feature)
			underwear.forceMove(get_turf(src))
			if(iscarbon(usr))
				var/mob/living/carbon/C = usr
				C.put_in_hands(underwear)
			underwear = null

	if(href_list["pockets"] && usr.canUseTopic(src, BE_CLOSE, NO_DEXTERITY)) //TODO: Make it match (or intergrate it into) strippanel so you get 'item cannot fit here' warnings if mob_can_equip fails
		var/pocket_side = href_list["pockets"]
		var/pocket_id = (pocket_side == "right" ? SLOT_R_STORE : SLOT_L_STORE)
		var/obj/item/pocket_item = (pocket_id == SLOT_R_STORE ? r_store : l_store)
		var/obj/item/place_item = usr.get_active_held_item() // Item to place in the pocket, if it's empty

		var/delay_denominator = 1
		if(pocket_item && !(pocket_item.item_flags & ABSTRACT))
			if(HAS_TRAIT(pocket_item, TRAIT_NODROP))
				to_chat(usr, "<span class='warning'>I try to empty [src]'s [pocket_side] pocket, it seems to be stuck!</span>")
			to_chat(usr, "<span class='notice'>I try to empty [src]'s [pocket_side] pocket.</span>")
		else if(place_item && place_item.mob_can_equip(src, usr, pocket_id, 1) && !(place_item.item_flags & ABSTRACT))
			to_chat(usr, "<span class='notice'>I try to place [place_item] into [src]'s [pocket_side] pocket.</span>")
			delay_denominator = 4
		else
			return

		if(do_mob(usr, src, POCKET_STRIP_DELAY/delay_denominator)) //placing an item into the pocket is 4 times faster
			if(pocket_item)
				if(pocket_item == (pocket_id == SLOT_R_STORE ? r_store : l_store)) //item still in the pocket we search
					dropItemToGround(pocket_item)
			else
				if(place_item)
					if(place_item.mob_can_equip(src, usr, pocket_id, FALSE, TRUE))
						usr.temporarilyRemoveItemFromInventory(place_item, TRUE)
						equip_to_slot(place_item, pocket_id, TRUE)
					//do nothing otherwise
				//updating inv screen after handled by living/Topic()
		else
			// Display a warning if the user mocks up
			to_chat(src, "<span class='warning'>I feel your [pocket_side] pocket being fumbled with!</span>")

	if(href_list["task"] == "assess")
		if(!ishuman(usr))
			return
		if(!ishuman(src))
			return
		var/success = FALSE
		var/obscured_name = FALSE 

		var/static/list/unknown_names = list(
		"Unknown",
		"Unknown Man",
		"Unknown Woman",
		)
		
		var/mob/living/carbon/human/H = src
		var/mob/living/carbon/human/user = usr
		var/intellectual = HAS_TRAIT(user, TRAIT_INTELLECTUAL)

		if(H.get_visible_name() in unknown_names)
			obscured_name = TRUE

		if(get_dist(user, H) <= (2 + clamp(floor(((user.STAPER - 10))),-1, 4) + intellectual))
			success = TRUE
		if(!success)
			to_chat(user, span_info("They've moved too far away!"))
			return
		user.visible_message("[user] begins assessing [src].")
		
		if(do_mob(user, src, ((intellectual ? 20 : 40)) - (user.STAINT - 10) - (user.STAPER - 10) - user.get_skill_level(/datum/skill/misc/reading), uninterruptible = intellectual, double_progress = (intellectual ? FALSE : TRUE)))
			var/is_guarded = HAS_TRAIT(src, TRAIT_DECEIVING_MEEKNESS)	//Will scramble Stats and prevent skills from being shown
			var/is_smart = FALSE	//Maximum info (all skills, gear and stats) either Intellectual virtue or having high enough PER / INT / Reading
			var/is_stupid = FALSE	//Less than 9 INT, Intellectual virtue overrides it.
			var/is_normal = FALSE	//High amount of info -- most gear slots, combat skills. No stats.
			//If you don't get any of these, you'll still get to see 3 gear slots and shown weapon skills in Assess.
			if(intellectual || ((user.STAINT - 10) + (user.STAPER - 10) + user.get_skill_level(/datum/skill/misc/reading)) >= 10)
				is_smart = TRUE	
			if(user.STAINT < 10 && !is_smart)
				is_stupid = TRUE
			if(!is_smart && !is_stupid && ((user.STAINT - 10) + (user.STAPER - 10) + user?.get_skill_level(/datum/skill/misc/reading)) >= 5)
				is_normal = TRUE
			var/list/dat = list()
			// Top-level table
			dat += "<table style='width: 100%; line-height: 20px;'>"
			// NEXT ROW
			dat += "<tr>"
			dat += "<td style='width:16%;text-align:left;vertical-align: text-top'>"
			if(intellectual && (!obscured_name || H.client?.prefs.masked_examine))
				dat += "<b>STATS:</b><br><br>"
				if(!is_guarded)
					dat +=("STR: \Roman [H.STASTR]<br>")
					dat +=("PER: \Roman [H.STAPER]<br>")
					dat +=("INT: \Roman [H.STAINT]<br>")
					dat +=("CON: \Roman [H.STACON]<br>")
					dat +=("END: \Roman [H.STAWIL]<br>")
					dat +=("SPD: \Roman [H.STASPD]<br>")
				else
					dat +=("STR: \Roman [rand(1,20)]<br>")
					dat +=("PER: \Roman [rand(1,20)]<br>")
					dat +=("INT: \Roman [rand(1,20)]<br>")
					dat +=("CON: \Roman [rand(1,20)]<br>")
					dat +=("END: \Roman [rand(1,20)]<br>")
					dat +=("SPD: \Roman [rand(1,20)]<br>")
				if(is_guarded || job == "Jester")
					dat += "Something feels off..."
				dat += "</td>"
			else
				dat += "</td>"

			dat += "<td style='width:33%;text-align:left;vertical-align: text-top'>"
			var/list/damtypes = list("blunt","slash","stab","piercing")
			var/list/body_parts = list(skin_armor, head, wear_mask, wear_wrists, gloves, wear_neck, cloak, wear_armor, wear_shirt, shoes, wear_pants, backr, backl, belt, s_store, glasses, ears, wear_ring)
			var/list/coverage_exposed = list(READABLE_ZONE_HEAD, READABLE_ZONE_CHEST, READABLE_ZONE_ARMS, READABLE_ZONE_L_ARM, READABLE_ZONE_R_ARM, READABLE_ZONE_LEGS, READABLE_ZONE_L_LEG, READABLE_ZONE_R_LEG, READABLE_ZONE_NOSE, READABLE_ZONE_MOUTH, READABLE_ZONE_EYES, READABLE_ZONE_NECK, READABLE_ZONE_VITALS, READABLE_ZONE_GROIN, READABLE_ZONE_HANDS, READABLE_ZONE_L_HAND, READABLE_ZONE_R_HAND, READABLE_ZONE_FEET, READABLE_ZONE_L_FOOT, READABLE_ZONE_R_FOOT)
			var/list/coverage = list()	//All of the covered areas
			var/list/blunt_max = list()	//Highest armor prot values
			var/list/slash_max = list()	
			var/list/stab_max = list()
			var/list/piercing_max = list()
			for(var/part in body_parts)
				if(!part)
					continue
				if(part && istype(part, /obj/item/clothing))
					var/obj/item/clothing/C = part
					var/list/readable_coverage
					if(C.max_integrity)
						if(C.obj_integrity <= 0)
							continue
						if(C.integrity_failure)
							if(C.obj_broken)
								continue
					if(!C.armor)	//No armor -- no need to care about it
						continue
					if(C.armor)
						if(C.armor.slash == 0 && C.armor.stab == 0 && C.armor.blunt == 0 && C.armor.piercing == 0)	//No armor but there's an armor datum. Useless for Assess, so we skip it.
							continue
					if(C.body_parts_covered_dynamic)
						readable_coverage = body_parts_covered2organ_names(C.body_parts_covered_dynamic, verbose = TRUE)
					for(var/coverageflag in readable_coverage)
						for(var/type in damtypes)
							switch(type)			//We get the max armor  values for this coverage flag
								if("blunt")
									blunt_max[coverageflag] = max(C.armor.getRating(type), blunt_max[coverageflag])
								if("slash")
									slash_max[coverageflag] = max(C.armor.getRating(type), slash_max[coverageflag])
								if("stab")
									stab_max[coverageflag] = max(C.armor.getRating(type), stab_max[coverageflag])
								if("piercing")
									piercing_max[coverageflag] = max(C.armor.getRating(type), piercing_max[coverageflag])
						coverage[coverageflag] += 1
						switch(coverageflag)		//This removes covered zones from the _exposed list. The remainder, if any, will be highlighted in red as an "exposed" zone.
							if(READABLE_ZONE_L_ARM)
								coverage_exposed.Remove(READABLE_ZONE_ARMS, READABLE_ZONE_L_ARM)
							if(READABLE_ZONE_R_ARM)
								coverage_exposed.Remove(READABLE_ZONE_ARMS, READABLE_ZONE_R_ARM)	//Since individual limbs can be exposed, this is needed for the accuracy / granularity of the printout.
							if(READABLE_ZONE_L_LEG)
								coverage_exposed.Remove(READABLE_ZONE_LEGS, READABLE_ZONE_L_LEG)	//However it do be ugly.
							if(READABLE_ZONE_R_LEG)	
								coverage_exposed.Remove(READABLE_ZONE_LEGS, READABLE_ZONE_R_LEG)
							if(READABLE_ZONE_L_HAND)
								coverage_exposed.Remove(READABLE_ZONE_HANDS, READABLE_ZONE_L_HAND)
							if(READABLE_ZONE_R_HAND)
								coverage_exposed.Remove(READABLE_ZONE_HANDS, READABLE_ZONE_R_HAND)
							if(READABLE_ZONE_R_FOOT)
								coverage_exposed.Remove(READABLE_ZONE_FEET, READABLE_ZONE_R_FOOT)
							if(READABLE_ZONE_L_FOOT)
								coverage_exposed.Remove(READABLE_ZONE_FEET, READABLE_ZONE_L_FOOT)
							else
								coverage_exposed.Remove(coverageflag)
			for(var/coverageflag in coverage)	//We go through the set up list and filter out redundancies. (ie Left Arm & Right Arm having identical stats to Arms)
				switch(coverageflag)
					if(READABLE_ZONE_ARMS)
						if(coverage[READABLE_ZONE_L_ARM] == coverage[READABLE_ZONE_R_ARM])
							if((blunt_max[READABLE_ZONE_L_ARM] == blunt_max[READABLE_ZONE_R_ARM]) && (slash_max[READABLE_ZONE_L_ARM] == slash_max[READABLE_ZONE_R_ARM]) && (stab_max[READABLE_ZONE_L_ARM] == stab_max[READABLE_ZONE_R_ARM]))
								coverage.Remove(READABLE_ZONE_L_ARM, READABLE_ZONE_R_ARM)
							else
								coverage.Remove(READABLE_ZONE_ARMS)
						else
							coverage.Remove(READABLE_ZONE_ARMS)
					if(READABLE_ZONE_LEGS)
						if(coverage[READABLE_ZONE_L_LEG] == coverage[READABLE_ZONE_R_LEG])
							if((blunt_max[READABLE_ZONE_L_LEG] == blunt_max[READABLE_ZONE_R_LEG]) && (slash_max[READABLE_ZONE_L_LEG] == slash_max[READABLE_ZONE_R_LEG]) && (stab_max[READABLE_ZONE_L_LEG] == stab_max[READABLE_ZONE_R_LEG]))
								coverage.Remove(READABLE_ZONE_L_LEG, READABLE_ZONE_R_LEG)
							else
								coverage.Remove(READABLE_ZONE_LEGS)
						else
							coverage.Remove(READABLE_ZONE_LEGS)
					if(READABLE_ZONE_HANDS)
						if(coverage[READABLE_ZONE_L_HAND] == coverage[READABLE_ZONE_R_HAND])
							if((blunt_max[READABLE_ZONE_L_HAND] == blunt_max[READABLE_ZONE_R_HAND]) && (slash_max[READABLE_ZONE_L_HAND] == slash_max[READABLE_ZONE_R_HAND]) && (stab_max[READABLE_ZONE_L_HAND] == stab_max[READABLE_ZONE_R_HAND]))
								coverage.Remove(READABLE_ZONE_L_HAND, READABLE_ZONE_R_HAND)
							else
								coverage.Remove(READABLE_ZONE_HANDS)
						else
							coverage.Remove(READABLE_ZONE_HANDS)
					if(READABLE_ZONE_FEET)
						if(coverage[READABLE_ZONE_L_FOOT] == coverage[READABLE_ZONE_R_FOOT])
							if((blunt_max[READABLE_ZONE_L_FOOT] == blunt_max[READABLE_ZONE_R_FOOT]) && (slash_max[READABLE_ZONE_L_FOOT] == slash_max[READABLE_ZONE_R_FOOT]) && (stab_max[READABLE_ZONE_L_FOOT] == stab_max[READABLE_ZONE_R_FOOT]))
								coverage.Remove(READABLE_ZONE_L_FOOT, READABLE_ZONE_R_FOOT)
							else
								coverage.Remove(READABLE_ZONE_FEET)
						else
							coverage.Remove(READABLE_ZONE_FEET)		
			for(var/exposedzone in coverage_exposed)	//We also filter out redundancies from the exposed remainder. Mostly L / Rs if there's a combined flag that slipped through.
				switch(exposedzone)
					if(READABLE_ZONE_HANDS)
						coverage_exposed.Remove(READABLE_ZONE_L_HAND, READABLE_ZONE_R_HAND)
					if(READABLE_ZONE_ARMS)
						coverage_exposed.Remove(READABLE_ZONE_L_ARM, READABLE_ZONE_R_ARM)
					if(READABLE_ZONE_LEGS)
						coverage_exposed.Remove(READABLE_ZONE_L_LEG, READABLE_ZONE_R_LEG)
					if(READABLE_ZONE_FEET)
						coverage_exposed.Remove(READABLE_ZONE_L_FOOT, READABLE_ZONE_R_FOOT)
					if(READABLE_ZONE_HEAD)
						coverage_exposed.Remove(READABLE_ZONE_MOUTH, READABLE_ZONE_EYES, READABLE_ZONE_NOSE)

			if(!is_stupid)
				dat += "<b><center>BODY:</center></b><br>"
			if(length(coverage))
				var/str
				if(!is_smart && !is_normal)	//We get a significantly simplified printout if we don't have the stats / trait
					coverage.Remove(READABLE_ZONE_NECK, READABLE_ZONE_MOUTH, READABLE_ZONE_EYES, READABLE_ZONE_NOSE, READABLE_ZONE_FACE, READABLE_ZONE_VITALS, READABLE_ZONE_GROIN, READABLE_ZONE_HANDS, READABLE_ZONE_FEET, READABLE_ZONE_L_FOOT, READABLE_ZONE_R_FOOT, READABLE_ZONE_L_HAND, READABLE_ZONE_R_HAND, READABLE_ZONE_L_ARM, READABLE_ZONE_R_ARM, READABLE_ZONE_L_LEG, READABLE_ZONE_R_LEG)
				if(!is_smart && is_normal)
					coverage.Remove(READABLE_ZONE_NECK, READABLE_ZONE_MOUTH, READABLE_ZONE_EYES, READABLE_ZONE_NOSE, READABLE_ZONE_FACE, READABLE_ZONE_VITALS, READABLE_ZONE_GROIN, READABLE_ZONE_HANDS, READABLE_ZONE_FEET, READABLE_ZONE_L_FOOT, READABLE_ZONE_R_FOOT, READABLE_ZONE_L_HAND, READABLE_ZONE_R_HAND)
				if(!is_stupid)
					if(is_normal || is_smart)
						if(length(coverage_exposed))
							for(var/exposed in coverage_exposed)
								str += "<b>[exposed]</b>: <font color = '#770404'><b>EXPOSED!</B></font><br>"
					for(var/thing in coverage)
						str += "<b>[thing]</b> LAYERS: <b>[coverage[thing]]</b> | [colorgrade_rating("", blunt_max[thing], TRUE)] | [colorgrade_rating("", slash_max[thing], TRUE)] | [colorgrade_rating("", stab_max[thing], TRUE)] | [colorgrade_rating("", piercing_max[thing], TRUE)]"
					dat += str
				else
					dat += "<b><center>I don't know! Just hit them!</center></b>"
			else
				dat += "<b><center>They're wearing nothing.</center></b>"
			dat += "</td>"

			dat += "<td style='width:40%;text-align:center;vertical-align: text-top'>"
			if(!is_guarded && !is_stupid && (!obscured_name || H.client?.prefs.masked_examine))	//We don't see Guarded people's skills at all.
				dat += "<b>SKILLS:</b><br><br>"
				var/list/wornstuff = list(H.backr, H.backl, H.beltl, H.beltr)
				if(!is_normal && !is_smart)	//At minimum we get to see the skills of the weapons the person is holding, if we have them.
					for(var/stuff in wornstuff)
						if(stuff)
							if(istype(stuff, /obj/item))
								var/obj/item/wornthing = stuff
								if(wornthing.associated_skill)
									var/datum/skill/SK = wornthing.associated_skill
									if(user.get_skill_level(SK) > 0)
										dat += "<font size = 4; font color = '#dddada'><b>[SK.name]</b><br></font>"
										var/skilldiff = user.get_skill_level(SK) - H.get_skill_level(SK)
										dat += "[skilldiff_report(skilldiff)] <br>"
										dat += "-----------------------<br>"
					for(var/obj/item/I in held_items)	//Also what's in their hands!
						if(!(I.item_flags & ABSTRACT))
							if(I.associated_skill)
								var/datum/skill/SK = I.associated_skill
								if(user.get_skill_level(SK) > 0)
									dat += "<font size = 4; font color = '#dddada'><b>[SK.name]</b><br></font>"
									var/skilldiff = user.get_skill_level(SK) - H.get_skill_level(SK)
									dat += "[skilldiff_report(skilldiff)] <br>"
									dat += "-----------------------<br>"
				else	//Otherwise, we get to see all of their combat skills
					for(var/S in subtypesof(/datum/skill/combat))
						var/datum/skill/combat/SK = S
						if(user.get_skill_level(S) > 0)
							dat += "<font size = 4; font color = '#dddada'><b>[SK.name]</b><br></font>"
							var/skilldiff = user.get_skill_level(S) - H.get_skill_level(S)
							dat += "[skilldiff_report(skilldiff)] <br>"
							dat += "-----------------------<br>"
					if(is_smart)	//And if we're smart enough, /all/ skills.
						for(var/S in subtypesof(/datum/skill))
							if(user.get_skill_level(S) > 0)
								if(!ispath(S, /datum/skill/combat))	//We already did these.
									var/datum/skill/SL = S
									dat += "<font size = 4; font color = '#dddada'><b>[SL.name]</b><br></font>"
									var/skilldiff = user.get_skill_level(S) - H.get_skill_level(S)
									dat += "[skilldiff_report(skilldiff)] <br>"
									dat += "-----------------------<br>"
								else
									continue
					
			dat += "</td>"
			dat += "</tr>"
			var/datum/browser/popup = new(user, "assess", ntitle = "[src] Assesment", nwidth = 1000, nheight = 600)
			popup.set_content(dat.Join())
			popup.open(FALSE)
		else
			user.visible_message("[user] fails to assess [src]!")
		return

	if(href_list["task"] == "view_rumours_gossip")
		if(!ismob(usr))
			return
		var/msg = ""
		if(rumour && length(rumour))
			var/rumour_display = rumour
			rumour_display = html_encode(rumour_display)
			rumour_display = parsemarkdown_basic(rumour_display, hyperlink = TRUE)
			msg += "<b>You recall what you heard around Town about [src]...</b><br>[rumour_display]"
		if(((HAS_TRAIT(usr, TRAIT_NOBLE)) || observer_privilege) && length(noble_gossip))
			if(msg) 
				msg += "<br><br>"
			var/gossip_display = noble_gossip
			gossip_display = html_encode(gossip_display)
			gossip_display = parsemarkdown_basic(gossip_display, hyperlink = TRUE)
			msg += "<b>You recall what the other Blue-bloods hushed about [src]...</b><br>[gossip_display]"
		if(msg)
			to_chat(usr, "<span class='info'>[msg]</span>")
		else	//Edge-case of there being ONLY noble gossip, but we aren't a noble.
			to_chat(usr, "<span class='info'>Any tales of intrigue of this one are reserved to the nobility...</span>")
		return

	return ..() //end of this massive fucking chain. TODO: make the hud chain not spooky. - Yeah, great job doing that. - I made it worse sorry guys.

//Sorry colorblind folks...
/proc/colorgrade_rating(input, rating, elaborate = FALSE)
	var/str
	if(isnull(rating))
		rating = 0
	switch(rating)
		if(0 to 9)
			var/color = "#f81a1a"
			str = elaborate ? "<font color = '[color]'>[input] (F)</font>" : "<font color = '[color]'>[input] (F)</font>"
		if(10 to 19)
			var/color = "#680d0d"
			str = elaborate ? "<font color = '[color]'>[input] (D)</font>" : "<font color = '[color]'>[input] (D)</font>"
		if(20 to 39)
			var/color = "#753e11"
			str = elaborate ? "<font color = '[color]'>[input] (D+)</font>" : "<font color = '[color]'>[input] (D+)</font>"
		if(40 to 49)
			var/color = "#c0a739"
			str = elaborate ? "<font color = '[color]'>[input] (C)</font>" : "<font color = '[color]'>[input] (C to C+)</font>"
		if(50 to 59)
			var/color = "#e3e63c"
			str = elaborate ? "<font color = '[color]'>[input] (C+)</font>" : "<font color = '[color]'>[input] (C to C+)</font>"
		if(60 to 69)
			var/color = "#425c33"
			str = elaborate ? "<font color = '[color]'>[input] (B)</font>" : "<font color = '[color]'>[input] (B to B+)</font>"
		if(70 to 79)
			var/color = "#1a9c00"
			str = elaborate ? "<font color = '[color]'>[input] (B+)</font>" : "<font color = '[color]'>[input] (B to B+)</font>"
		if(80 to 89)
			var/color = "#0fe021"
			str = elaborate ? "<font color = '[color]'>[input] (A)</font>" : "<font color = '[color]'>[input] (A to A+)</font>"
		if(90 to 99)
			var/color = "#ffffff"
			str = elaborate ? "<font color = '[color]'>[input] (A+)</font>" : "<font color = '[color]'>[input] (A to A+)</font>"
		if(100)
			var/color = "#339dff"
			str = "<font color = '[color]'>[input] (S)</font>"
		if(101 to 200)
			var/color = "#c757af"
			str = "<font color = '[color]'>[input] (S+)</font>"
		else
			str = "[input] (Under 0 or above 200! Contact coders.)"
	return str

/proc/skilldiff_report(var/input)
	switch (input)
		if(-6)
			return "<font color = '#ff4ad2'>I know nothing. They -- everything</font>"
		if(-5)
			return "<font color = '#eb0000'><i>I stand no chance against them</i></font>"
		if(-4)
			return "<font color = '#c53c3c'><i>I am inferior</i></font>"
		if(-3)
			return "<font color = '#db8484'><i>I am notably worse</i></font>"
		if(-2)
			return "<font color = '#e4a1a1'><i>I am worse</i></font>"
		if(-1)
			return "<font color = '#f8d3d3'><i>I am slightly worse</i></font>"
		if(0)
			return "We are equal"
		if(1)
			return "<font color = '#3f6343'>I am slightly better</font>"
		if(2)
			return "<font color = '#49944f'>I am better</font>"
		if(3)
			return "<font color = '#44db51'>I am notably better</font>"
		if(4)
			return"<font color = '#62b4be'>I am superior</font>"
		if(5)
			return "<font color = '#2bdcfc'>They have no chance in this field</font>"
		if(6)
			return "<font color = '#ff4ad2'>They know nothing. A whelp</font>"
