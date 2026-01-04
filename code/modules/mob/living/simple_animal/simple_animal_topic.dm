
/mob/living/simple_animal/Topic(href, href_list)
	. = ..()
	if(href_list["inspect_animal"] && (isobserver(usr) || usr.canUseTopic(src, BE_CLOSE, NO_DEXTERITY)))
		var/list/msg = list()
		if(length(simple_wounds))
			msg += "<B>Wounds:</B>"
			for(var/datum/wound/wound as anything in simple_wounds)
				msg += wound.get_visible_name(usr)

		if(length(simple_embedded_objects))
			msg += "<B>Embedded objects:</B>"
			for(var/obj/item/embedded in simple_embedded_objects)
				msg += "<a href='?src=[REF(src)];embedded_object=[REF(embedded)]'>[embedded.name]</a>"

		to_chat(usr, span_info("[msg.Join("\n")]"))

	if(href_list["embedded_object"] && usr.canUseTopic(src, BE_CLOSE, NO_DEXTERITY))
		var/obj/item/I = locate(href_list["embedded_object"]) in simple_embedded_objects
		if(QDELETED(I) || !simple_remove_embedded_object(I))
			return
		usr.put_in_hands(I)
		playsound(loc, 'sound/foley/flesh_rem.ogg', 100, TRUE, -2)
		if(usr == src)
			usr.visible_message(span_notice("[usr] rips [I] out of [usr.p_them()]self!"), span_notice("I remove [I] from myself."))
		else
			usr.visible_message(span_notice("[usr] rips [I] out of [src]!"), span_notice("I rip [I] from [src]."))

/mob/living/simple_animal/pet/familiar/Topic(href, href_list)
    . = ..()
    if(href_list["task"] == "view_fam_headshot")
        if(!ismob(usr))
            return
        var/mob/user = usr
        var/list/dat = list()
        var/datum/familiar_prefs/prefy = src.client.prefs.familiar_prefs


        dat += "<div align='center'><font size = 5; font color = '#dddddd'><b>[prefy.familiar_name]</b></font></div>"

        // Add species name below the title, centered
        var/specie_type = GLOB.familiar_display_names[prefy.familiar_specie]
        dat += "<div align='center'><font size=4 color='#bbbbbb'>[specie_type]</font></div>"

        // Add pronouns below species name
        var/list/pronoun_display = list(
            HE_HIM = "he/him",
            SHE_HER = "she/her",
            THEY_THEM = "they/them",
            IT_ITS = "it/its"
        )
        var/selected_pronoun = pronoun_display[prefy.familiar_pronouns] ? pronoun_display[prefy.familiar_pronouns] : "they/them"
        dat += "<div align='center'><font size=3 color='#bbbbbb'>[selected_pronoun]</font></div>"

        if(valid_headshot_link(null, prefy.familiar_headshot_link, TRUE))
            dat += ("<div align='center'><img src='[prefy.familiar_headshot_link]' width='325px' height='325px'></div>")
        if(prefy.familiar_flavortext_display)
            dat += "<div align='left'>[prefy.familiar_flavortext_display]</div>"
        if(prefy.familiar_ooc_notes_display)
            dat += "<br>"
            dat += "<div align='center'><b>OOC notes</b></div>"
            dat += "<div align='left'>[prefy.familiar_ooc_notes_display]</div>"
        if(prefy.familiar_ooc_extra)
            dat += "[prefy.familiar_ooc_extra]"
        var/datum/browser/popup = new(user, "[src]", nwidth = 600, nheight = 800)
        popup.set_content(dat.Join())
        popup.open(FALSE)
        return
