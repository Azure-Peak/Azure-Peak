/datum/admins/proc/admin_show_heal_panel(mob/living/M in GLOB.mob_list)
	set name = "Show Health Panel"
	set category = "-GameMaster-"

	if(!check_rights(R_ADMIN))
		return

	show_heal_panel(M)

/client/proc/show_heal_panel(mob/M)
	holder?.show_heal_panel(M)

/datum/admins/proc/show_heal_panel(mob/living/M)
	log_admin("[key_name(usr)] opened heal panel for [key_name(M)]")
	
	if(!M)
		return

	var/body = "<html><head><title>Heal - [M.name]</title>"
	body += "<style>"
	body += "table { border-collapse: collapse; width: 100%; }"
	body += "th, td { border: 1px solid black; padding: 5px; text-align: left; }"
	body += "th { background-color: #ddd; }"
	body += "</style>"
	body +="</head><body>"
	
	body += "<b>Heal Panel: [M.name]</b><br><br>"
	body += "<A href='?_src_=holder;[HrefToken()];heal_target=[REF(M)]'>Full Heal</A> | "
	body += "<A href='?_src_=holder;[HrefToken()];heal_revive=[REF(M)]'>Revive</A> | "
	body += "<A href='?_src_=holder;[HrefToken()];heal_refresh=[REF(M)]'>Refresh</A>"
	if(ishuman(M))
		body += " | <A href='?_src_=holder;[HrefToken()];heal_modify_organs=[REF(M)]'>Modify Organs</A>"
	body += "<br><br>"
	
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		
		// Blood Volume
		body += "<b>Blood Volume:</b> [H.blood_volume] / [BLOOD_VOLUME_NORMAL] units<br>"
		body += "<A href='?_src_=holder;[HrefToken()];heal_blood_add100=[REF(M)]'>+100</A> | "
		body += "<A href='?_src_=holder;[HrefToken()];heal_blood_add50=[REF(M)]'>+50</A> | "
		body += "<A href='?_src_=holder;[HrefToken()];heal_blood_sub50=[REF(M)]'>-50</A> | "
		body += "<A href='?_src_=holder;[HrefToken()];heal_blood_sub100=[REF(M)]'>-100</A> | "
		body += "<A href='?_src_=holder;[HrefToken()];heal_blood_set=[REF(M)]'>Set Amount</A>"
		body += "<br><br>"
		
		// Overall Damage (no label)
		body += "TOXIN:<A href='?_src_=holder;[HrefToken()];heal_edit_overall=[REF(M)];damage_type=toxin'>[H.getToxLoss()]</A> | "
		body += "OXY:<A href='?_src_=holder;[HrefToken()];heal_edit_overall=[REF(M)];damage_type=oxy'>[H.getOxyLoss()]</A>"
		body += "<br><br>"
		
		// Bodypart Damage
		body += "<b>Bodypart Damage:</b><br>"
		body += "<table><tr><th>Body Part</th><th>Brute</th><th>Burn</th><th>Actions</th></tr>"
		for(var/obj/item/bodypart/BP in H.bodyparts)
			var/limb_name = BP.name
			if(BP.status == BODYPART_ROBOTIC)
				limb_name += " (prosthetic)"
			body += "<tr>"
			body += "<td>[limb_name]</td>"
			body += "<td>BRUTE:<A href='?_src_=holder;[HrefToken()];heal_edit_damage=[REF(M)];bodypart=[REF(BP)];damage_type=brute'>[BP.brute_dam]</A></td>"
			body += "<td>BURN:<A href='?_src_=holder;[HrefToken()];heal_edit_damage=[REF(M)];bodypart=[REF(BP)];damage_type=burn'>[BP.burn_dam]</A></td>"
			body += "<td>"
			body += "<A href='?_src_=holder;[HrefToken()];heal_fix_bodypart=[REF(M)];bodypart=[REF(BP)]'>Heal</A> | "
			body += "<A href='?_src_=holder;[HrefToken()];heal_add_wound=[REF(M)];bodypart=[REF(BP)]'>Add Wound</A> | "
			body += "<A href='?_src_=holder;[HrefToken()];heal_remove_bodypart=[REF(M)];bodypart=[REF(BP)]'>Remove</A>"
			body += "</td>"
			body += "</tr>"
		body += "</table>"
		body += "<br>"
	else
		// Simplified menu for non-human mobs
		body += "<b>Health:</b> [M.health] / [M.maxHealth]<br>"
		body += "BRUTE:<A href='?_src_=holder;[HrefToken()];heal_edit_simple=[REF(M)];damage_type=brute'>[M.getBruteLoss()]</A> | "
		body += "BURN:<A href='?_src_=holder;[HrefToken()];heal_edit_simple=[REF(M)];damage_type=burn'>[M.getFireLoss()]</A> | "
		body += "TOXIN:<A href='?_src_=holder;[HrefToken()];heal_edit_simple=[REF(M)];damage_type=toxin'>[M.getToxLoss()]</A> | "
		body += "OXY:<A href='?_src_=holder;[HrefToken()];heal_edit_simple=[REF(M)];damage_type=oxy'>[M.getOxyLoss()]</A>"
		body += "<br><br>"
	
	body += "<b>Wounds:</b><br>"
	
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/list/all_wounds = list()
		
		for(var/obj/item/bodypart/BP in H.bodyparts)
			if(BP.wounds && BP.wounds.len)
				for(var/datum/wound/W in BP.wounds)
					all_wounds += list(list("bodypart" = BP, "wound" = W))
		
		if(all_wounds.len)
			body += "<table><tr><th>Body Part</th><th>Wound Type</th><th>Actions</th></tr>"
			for(var/list/wound_data in all_wounds)
				var/obj/item/bodypart/BP = wound_data["bodypart"]
				var/datum/wound/W = wound_data["wound"]
				body += "<tr>"
				body += "<td>[BP.name]</td>"
				body += "<td>[W.name]</td>"
				body += "<td><A href='?_src_=holder;[HrefToken()];heal_remove_wound=[REF(M)];wound=[REF(W)]'>Remove</A></td>"
				body += "</tr>"
			body += "</table>"
		else
			body += "No wounds detected<br>"
	else
		body += "Wound system only available for humanoid mobs<br>"
	
	body += "</body></html>"

	usr << browse(body, "window=adminplayeropts-heal[REF(M)];size=650x550")
