
PROCESSING_SUBSYSTEM_DEF(roguemachine)
	name = "roguemachine"
	wait = 20
	flags = SS_NO_INIT
	priority = 1
	var/list/hermailers = list()
	var/list/cameras = list()
	var/list/scomm_machines = list()
	var/list/broadcaster_machines = list()
	var/list/stock_machines = list()
	var/list/noticeboards = list()
	var/hermailermaster
	var/list/death_queue = list()
	var/last_death_report
	var/obj/item/clothing/head/roguetown/crown/serpcrown/crown
	var/obj/item/rogueweapon/sword/long/martyr/martyrweapon
	var/obj/item/key

/datum/controller/subsystem/processing/roguemachine/fire(resumed = 0)
	. = ..()
	if(death_queue.len)
		if(world.time > last_death_report + 3 SECONDS)
			last_death_report = world.time
			if(SSroguemachine.hermailermaster)
				var/obj/item/roguemachine/mastermail/X = SSroguemachine.hermailermaster
				for(var/I in death_queue)
					var/obj/item/paper/P = new(X.loc)
					P.mailer = "death witness"
					P.mailedto = "steward of roguetown"
					P.update_icon()
					P.info = I
					var/datum/component/storage/STR = X.GetComponent(/datum/component/storage)
					STR.handle_item_insertion(P, prevent_warning=TRUE)
					X.new_mail=TRUE
					X.update_icon()
				playsound(X, 'sound/misc/hiss.ogg', 100, FALSE, -1)
				var/the_track = 'sound/misc/cas1.ogg'
				if(death_queue.len >= 2)
					the_track = 'sound/misc/cas2.ogg'
				if(death_queue.len >= 5)
					the_track = 'sound/misc/cas3.ogg'
				for(var/mob/M in GLOB.player_list)
					if(is_in_roguetown(M))
						M.playsound_local(M.loc, the_track, 100, FALSE)
				death_queue.Cut()

/proc/is_in_roguetown(atom/A)
	if(!A)
		return FALSE
	var/turf/T = get_turf(A)
	if(!T)
		return FALSE
	var/area/the_area = get_area(T)
	var/static/list/safe_areas = typecacheof(list(\
		/area/rogue/outdoors/town,\
		/area/rogue/indoors/town,\
		/area/rogue/under/town,\
		/area/rogue/under/town/basement,\
		/area/rogue/under/town/caverogue,\
	))
	if(is_type_in_typecache(the_area.type, safe_areas))
		return TRUE
	return FALSE
