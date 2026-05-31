/obj/item/zadcage/proc/begin_bomb_arrival(datum/zad_flight/flight)
	if(!flight || flight.bombs <= 0)
		return
	var/turf/start_turf = get_turf(src)
	var/mob/holder = holder_mob()
	var/bomb_word = flight.bombs > 1 ? "BOMBS" : "BOMB"
	var/zad_word = flight.zads_used > 1 ? "zads" : "zad"
	var/descend_time = rand(ZAD_FLIGHT_BOMB_LANDING_MIN, ZAD_FLIGHT_BOMB_LANDING_MAX)
	play_zad_bomb_descend(src, flight.zads_used, flight.bombs, descend_time)
	balloon_alert_to_viewers("<font color='#ff2222'><b>[bomb_word]!!!</b></font>")
	if(flight.bomb_caw)
		say("<font color='#ff2222'>[flight.bomb_caw]</font>")
	playsound(src, 'sound/items/blackeye_warn.ogg', 80, FALSE, 4)
	playsound(src, pick('sound/vo/mobs/bird/CROW_01.ogg','sound/vo/mobs/bird/CROW_02.ogg','sound/vo/mobs/bird/CROW_03.ogg'), 70, TRUE, 3)
	if(holder)
		to_chat(holder, "<span class='userdanger'>[bomb_word] dangle from the [zad_word] above your zadcage!</span>")
	for(var/mob/living/M in range(3, src))
		if(M == holder)
			continue
		to_chat(M, "<span class='userdanger'>Above [src]: [bomb_word]!</span>")
	log_zad_bomb_dispatch(flight, start_turf)
	addtimer(CALLBACK(src, PROC_REF(detonate_bombs), flight.bombs), descend_time)

/obj/item/zadcage/proc/detonate_bombs(count)
	var/turf/where = get_turf(src)
	if(!where)
		return
	for(var/i in 1 to count)
		var/delay = (i - 1) * 10
		addtimer(CALLBACK(src, PROC_REF(spawn_and_pop_bomb), where), delay)

/obj/item/zadcage/proc/spawn_and_pop_bomb(turf/anchor_turf)
	var/turf/target_turf = get_turf(src) || anchor_turf
	if(!target_turf)
		return
	var/list/tiles = list(target_turf)
	for(var/turf/T in orange(1, target_turf))
		tiles += T
	var/turf/landing = pick(tiles)
	var/obj/item/bomb/B = new(landing)
	B.lit = TRUE
	B.explode(TRUE)

/proc/log_zad_bomb_dispatch(datum/zad_flight/flight, turf/origin_turf)
	if(!flight)
		return
	var/datum/zadlink/link = flight.resolve_target_link()
	var/obj/item/zadcage/cage = link ? link.resolve_cage() : null
	var/mob/holder = cage ? cage.holder_mob() : null
	var/sender_ckey = flight.sender_ckey || "<UNKNOWN>"
	var/recipient_ckey = (holder && holder.client) ? holder.client.ckey : "<UNATTENDED>"
	var/turf/cage_turf = cage ? get_turf(cage) : null
	var/log_line = "ZAD BOMB: [sender_ckey] -> [recipient_ckey], [flight.bombs] bombs, origin [AREACOORD(origin_turf)], cage at [AREACOORD(cage_turf)]"
	message_admins("[log_line]")
	log_game(log_line)
