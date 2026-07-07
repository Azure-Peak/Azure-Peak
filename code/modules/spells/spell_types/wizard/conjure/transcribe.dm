/datum/action/cooldown/spell/transcribe
	button_icon = 'icons/mob/actions/mage_conjure.dmi'
	name = "Transcribe"
	desc = "Conjure a parchment and a magical quill to write for you. \n\
	This magical parchment will listen for up to ten minutes and transcribe what it has heard onto itself \n\
	(use in your hand, and then use again to stop the recording)."	
	button_icon_state = "transcribe"
	sound = 'sound/magic/whiteflame.ogg'
	spell_color = GLOW_COLOR_LIGHT
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = FALSE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CANTRIP

	invocations = list("Hoc scribe.")
	invocation_type = INVOCATION_WHISPER

	charge_required = TRUE
	charge_time = 0.5 SECONDS
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 30 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE

	point_cost = 1

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/obj/item/item
	var/item_type = /obj/item/paper/magictranscription
	var/delete_old = TRUE //TRUE to delete the last summoned object if it's still there, FALSE for infinite item stream weeeee

/datum/action/cooldown/spell/transcribe/cast(list/targets, mob/user = usr)
	. = ..()
	if (delete_old && item && !QDELETED(item))
		QDEL_NULL(item)
	if(user.dropItemToGround(user.get_active_held_item()))
		user.put_in_hands(make_item(), TRUE)
		user.visible_message(span_info("A parchment and blue magical quill appears in [user]'s hand!"), span_info("You summon a parchment and magical quill!"))
	return TRUE

/datum/action/cooldown/spell/transcribe/Destroy()
	if(item)
		qdel(item)
	return ..()

/datum/action/cooldown/spell/transcribe/proc/make_item()
	item = new item_type
	var/mutable_appearance/magic_overlay = mutable_appearance('icons/roguetown/items/misc.dmi', "magicquill")
	item.add_overlay(magic_overlay)
	return item
	
/obj/item/paper/transcript
	name = "Transcription"
	desc = "A magical piece of paper that has been transcribed upon."

/obj/item/paper/transcript/read(mob/user)
	if(!user.client || !user.hud_used)
		return
	if(!user.hud_used.reads)
		return
	if(!user.can_read(src))
		if(info)
			user.adjust_experience(/datum/skill/misc/reading, 2, FALSE)
		return
	if(in_range(user, src) || isobserver(user))
//		var/obj/screen/read/R = user.hud_used.reads
		user << browse_rsc('html/book.png')
		var/dat = {"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
			<html><head><style type=\"text/css\">
			body { background-image:url('book.png');background-repeat: repeat; }</style></head><body scroll=yes>"}
		dat += info
		dat += "<br>"
		dat += "<a href='?src=[REF(src)];close=1' style='position:absolute;right:50px'>Close</a>"
		dat += "</body></html>"
		user << browse(dat, "window=reading;size=500x400;can_close=1;can_minimize=0;can_maximize=0;can_resize=1;titlebar=0;border=0")
		onclose(user, "reading", src)
	else
		return span_warning("I'm too far away to read it.")

/obj/item/paper/magictranscription
	name = "Magical Transcription" //this is essentially just modern TG's tape recorder clumped together with our parchment code c:
	desc = "A mystical parchment that records spoken words when activated, and can transcribe them when deactivated."
	icon_state = "paper"
	var/recording = FALSE
	var/list/storedinfo = list()
	var/list/timestamp = list()
	var/used_capacity = 0
	var/max_capacity = 6000 // 10 minutes
	var/time_warned = FALSE
	var/time_left_warning = 600 // 60 seconds
	var/canprint = TRUE

/obj/item/paper/magictranscription/Initialize(mapload)
	. = ..()
	pixel_y = rand(-8, 8)
	pixel_x = rand(-9, 9)

/obj/item/paper/magictranscription/attack_self(mob/user)
	if(recording)
		stop_recording(user)
	else
		start_recording(user)

/obj/item/paper/magictranscription/proc/start_recording(mob/user)
	if(recording)
		to_chat(user, span_warning("The parchment is already recording!"))
		return
	if(used_capacity >= max_capacity)
		to_chat(user, span_warning("The parchment is full of magical energy!"))
		return
	recording = TRUE
	become_hearing_sensitive()
	to_chat(user, span_notice("The parchment begins to glow faintly as a magical quill records the surrounding words..."))
	update_icon()
	while(recording && used_capacity < max_capacity)
		used_capacity += 10
		if(max_capacity - used_capacity < time_left_warning && !time_warned)
			time_warned = TRUE
			to_chat(user, span_warning("The parchment's glow is fading... [(max_capacity - used_capacity) / 10] seconds of magic remain."))
		sleep(10)
	if(used_capacity >= max_capacity)
		to_chat(user, span_warning("The parchment's magic is exhausted!"))
		stop_recording(user)

/obj/item/paper/magictranscription/proc/stop_recording(mob/user)
	if(!recording)
		return
	
	recording = FALSE
	time_warned = FALSE
	lose_hearing_sensitivity()
	update_icon()
	to_chat(user, span_notice("The parchment stops glowing."))
	if(storedinfo.len > 0)
		print_transcript(user)
		qdel(src)
	else
		to_chat(user, span_warning("The parchment is blank - nothing was recorded."))

/obj/item/paper/magictranscription/Hear(message, atom/movable/speaker, message_langs, raw_message, list/spans, message_mods)
	. = ..()
	if(!recording)
		return		
	if(speaker == src)
		return
	timestamp += used_capacity
	var/speaker_description = "Unknown"
	var/speaker_stature = "Person"
	if(ismob(speaker))
		var/mob/living/carbon/human/target = speaker
		var/list/d_list = target.get_mob_descriptors()
		var/descriptor_voice = build_coalesce_description_nofluff(d_list, speaker, list(MOB_DESCRIPTOR_SLOT_VOICE), "%DESC1%")
		var/descriptor_stature = build_coalesce_description_nofluff(d_list, speaker, list(MOB_DESCRIPTOR_SLOT_STATURE), "%DESC1%")
		speaker_description = descriptor_voice
		speaker_stature = descriptor_stature
	else if(speaker)
		speaker_description = speaker.name
	storedinfo += "\[[time2text(used_capacity,"mm:ss")]\] [speaker_description] [speaker_stature]: [raw_message]"

/obj/item/paper/magictranscription/proc/print_transcript(mob/user)
	if(!storedinfo.len)
		return
	if(!canprint)
		to_chat(user, span_warning("The parchment needs time to replenish its magic before printing again!")) //failsafe incase it fails or something
		return
	var/transcribed_text = "<b>Magical Transcription:</b><br><br>"
	var/paper_name = "Magical Transcription"
	var/list/pages = list()
	for(var/excerpt in storedinfo)
		var/excerpt_length = length(excerpt)
		if(excerpt_length > maxlen)
			continue
		if((length(transcribed_text) + excerpt_length) > maxlen)
			pages += transcribed_text
			transcribed_text = "<b>Magical Transcription (continued):</b><br><br>"
		transcribed_text += "[excerpt]<br>"
	if(transcribed_text != "<b>Magical Transcription (continued):</b><br><br>")
		pages += transcribed_text
	var/page_index = 1
	var/obj/item/paper/first_page = null
	for(var/page_text in pages)
		var/obj/item/paper/transcript = new /obj/item/paper/transcript(get_turf(src))
		if(pages.len > 1)
			transcript.name = "[paper_name] - Page [page_index]/[pages.len]"
		else
			transcript.name = paper_name
		transcript.info = page_text
		transcript.update_icon()
		transcript.updateinfolinks()
		if(page_index == 1)
			first_page = transcript
		page_index++
	if(first_page)
		user.put_in_hands(first_page)
	to_chat(user, span_notice("The quill magically transcribes its contents onto the parchment[pages.len > 1 ? "s" : ""] and crumbles to dust!"))
	if(pages.len > 1)
		to_chat(user, span_notice("[pages.len] pages were created."))

/obj/item/paper/magictranscription/update_icon_state()
	. = ..()
	if(recording)
		add_overlay("paper_onfire_overlay")
	else
		cut_overlay("paper_onfire_overlay")

/obj/item/paper/magictranscription/examine(mob/user)
	. = ..()
	if(recording)
		. += span_notice("It's currently recording the words said around it, glowing with a faint magical aura.")
	else if(storedinfo.len > 0)
		var/time = used_capacity / 10
		var/mins = round(time / 60)
		var/secs = time - mins * 60
		. += span_notice("It contains [storedinfo.len] recorded speech\s ([mins]m [secs]s of magic remaining).")
	else
		. += span_notice("It's blank and ready to record.")
