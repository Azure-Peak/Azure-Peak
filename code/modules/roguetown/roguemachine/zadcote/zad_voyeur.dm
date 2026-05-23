/obj/item/roguemachine/zadcote/proc/begin_voyeur(datum/zadlink/link, mob/living/carbon/human/operator)
	if(!allows_voyeur)
		to_chat(operator, span_warning("This zadcote does not bind for scrying."))
		return FALSE
	if(!link || link.severed)
		to_chat(operator, span_warning("That zadlink is severed."))
		return FALSE
	var/obj/item/zadcage/cage = link.resolve_cage()
	if(!cage)
		to_chat(operator, span_warning("That zadlink has no bonded zadcage."))
		return FALSE
	if(voyeur_fund < ZAD_VOYEUR_COST_MAMMON)
		to_chat(operator, span_warning("The zadcote's scrying fund is empty. Feed it mammon coins to scry."))
		return FALSE
	voyeur_fund -= ZAD_VOYEUR_COST_MAMMON
	to_chat(operator, span_notice("You whisper into the zadcote. The bonded zad stirs from afar... ([voyeur_fund]m left for scrying.)"))
	if(!do_after(operator, ZAD_VOYEUR_DOAFTER, target = src))
		voyeur_fund += ZAD_VOYEUR_COST_MAMMON
		return FALSE
	cage.start_voyeur(operator)
	return TRUE

/obj/item/zadcage/proc/start_voyeur(mob/living/carbon/human/operator)
	if(!operator || !operator.key)
		return
	var/mob/holder = holder_mob()
	var/atom/movable/target = holder || src
	var/turf/cage_turf = get_turf(src)
	message_admins("ZAD VOYEUR: [operator.real_name] ([operator.ckey]) scryed via zadcage on [holder ? "[holder.real_name] ([holder.ckey])" : "the empty cage at [AREACOORD(cage_turf)]"]")
	log_game("ZAD VOYEUR: [operator.real_name] ([operator.ckey]) scryed via zadcage on [holder ? "[holder.real_name] ([holder.ckey])" : "the empty cage"]")
	visible_message(span_notice("A strange blue glow emits from the zad in [src]."))
	add_filter("zad_voyeur_glow", 2, list("type" = "outline", "size" = 1, "color" = "#4488ff"))
	set_light(2, 2, 2, l_color = "#1b7bf1")
	var/mob/dead/observer/screye/zadcote_voyeur/S = spawn_zad_screye(operator)
	if(!S)
		remove_filter("zad_voyeur_glow")
		set_light(0)
		return
	S.ManualFollow(target)
	operator.visible_message(span_danger("[operator] stares into the zadcote, [operator.p_their()] eyes rolling back into [operator.p_their()] head."))
	to_chat(S, span_notice("You see through the zad's eyes. Click <b>Stop Scrying</b> in the IC tab to return early; otherwise the bond breaks on its own after [time2text(ZAD_VOYEUR_DURATION)]."))
	if(holder && holder.stat != DEAD && holder.stat != UNCONSCIOUS)
		holder.throw_alert("scryingeye", /atom/movable/screen/alert/scryingeye, override = TRUE)
		to_chat(holder, span_warning("The zad in your zadcage stirs - you feel a pair of eyes peering through it."))
		holder.playsound_local(holder, 'sound/magic/scryed_on.ogg', 75, TRUE)
	addtimer(CALLBACK(S, TYPE_PROC_REF(/mob/dead/observer, reenter_corpse)), ZAD_VOYEUR_DURATION)
	if(holder)
		addtimer(CALLBACK(holder, TYPE_PROC_REF(/mob/, clear_alert), "scryingeye", TRUE), ZAD_VOYEUR_DURATION)
	addtimer(CALLBACK(src, PROC_REF(end_voyeur_visuals)), ZAD_VOYEUR_DURATION)

/obj/item/zadcage/proc/end_voyeur_visuals()
	remove_filter("zad_voyeur_glow")
	set_light(0)

/proc/spawn_zad_screye(mob/operator)
	if(!operator || !operator.key)
		return null
	if(operator.client)
		SSdroning.kill_rain(operator.client)
		SSdroning.kill_loop(operator.client)
		SSdroning.kill_droning(operator.client)
	operator.stop_sound_channel(CHANNEL_HEARTBEAT)
	var/mob/dead/observer/screye/zadcote_voyeur/ghost = new(operator)
	ghost.ghostize_time = world.time
	SStgui.on_transfer(operator, ghost)
	ghost.can_reenter_corpse = TRUE
	ghost.key = operator.key
	return ghost

/mob/dead/observer/screye/zadcote_voyeur
	name = "scrying through a zad"

/mob/dead/observer/screye/zadcote_voyeur/Initialize()
	. = ..()
	verbs += /mob/dead/observer/screye/zadcote_voyeur/proc/end_zad_voyeur

/mob/dead/observer/screye/zadcote_voyeur/proc/end_zad_voyeur()
	set category = "IC"
	set name = "Stop Scrying"
	set desc = "End the zad-scrying and return to your body."
	reenter_corpse()
