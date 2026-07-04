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
	var/atom/movable/broadcaster = visible_holder()
	var/source_desc
	if(broadcaster == src)
		source_desc = "the zad in [src]"
	else if(ismob(broadcaster))
		source_desc = "a zadcage on [broadcaster]"
	else
		source_desc = "[broadcaster]"
	broadcaster.visible_message(span_notice("A strange blue glow emits from [source_desc]."))
	add_filter("zad_voyeur_glow", 2, list("type" = "outline", "size" = 1, "color" = "#4488ff"))
	set_light(2, 2, 2, l_color = "#1b7bf1")
	var/mob/dead/observer/screye/zadcote_voyeur/S = spawn_zad_screye(operator)
	if(!S)
		end_voyeur_visuals()
		return
	S.bonded_cage = WEAKREF(src)
	active_voyeur_screye = WEAKREF(S)
	if(holder)
		active_voyeur_holder = WEAKREF(holder)
	S.ManualFollow(target)
	operator.visible_message(span_danger("[operator] stares into the zadcote, [operator.p_their()] eyes rolling back into [operator.p_their()] head."))
	to_chat(S, span_notice("You see through the zad's eyes. Click <b>Stop Scrying</b> in the IC tab to return early; otherwise the bond breaks on its own after [ZAD_VOYEUR_DURATION / (1 MINUTES)] minute\s."))
	if(holder && holder.stat != DEAD && holder.stat != UNCONSCIOUS)
		holder.throw_alert("scryingeye", /atom/movable/screen/alert/scryingeye, override = TRUE)
		to_chat(holder, span_warning("The zad in your zadcage stirs - you feel a pair of eyes peering through it."))
		holder.balloon_alert_to_viewers("<font color='#b388ff'>scried!</font>")
		holder.playsound_local(holder, 'sound/magic/scryed_on.ogg', 75, TRUE)
	addtimer(CALLBACK(src, PROC_REF(finish_voyeur)), ZAD_VOYEUR_DURATION)

/obj/item/zadcage/proc/finish_voyeur()
	var/mob/dead/observer/screye/zadcote_voyeur/S = active_voyeur_screye?.resolve()
	var/mob/holder = active_voyeur_holder?.resolve()
	active_voyeur_screye = null
	active_voyeur_holder = null
	end_voyeur_visuals()
	if(holder)
		holder.clear_alert("scryingeye", TRUE)
	if(S && !QDELETED(S))
		S.bonded_cage = null
		S.reenter_corpse()

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
	var/datum/weakref/bonded_cage

/mob/dead/observer/screye/zadcote_voyeur/Initialize()
	. = ..()
	add_verb(src, /mob/dead/observer/screye/zadcote_voyeur/proc/end_zad_voyeur)

/mob/dead/observer/screye/zadcote_voyeur/proc/end_zad_voyeur()
	set category = "IC"
	set name = "Stop Scrying"
	set desc = "End the zad-scrying and return to your body."
	var/obj/item/zadcage/cage = bonded_cage?.resolve()
	if(cage)
		cage.finish_voyeur()
	else
		reenter_corpse()
