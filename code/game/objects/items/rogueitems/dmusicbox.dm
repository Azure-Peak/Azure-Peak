
/datum/looping_sound/dmusloop
	mid_sounds = list()
	mid_length = 2400
	volume = 100
	falloff = 2
	extra_range = 5
	var/stress2give = /datum/stressevent/musicbox
	persistent_loop = TRUE
	channel = CHANNEL_CMUSIC

/datum/looping_sound/dmusloop/on_hear_sound(mob/M)
	. = ..()
	if(stress2give)
		if(isliving(M))
			var/mob/living/carbon/L = M
			L.add_stress(stress2give)

/obj/item/dmusicbox
	name = "dwarven music box"
	desc = "It is essential that the deepest caves be tuned to the right frequency of vibrations. Activated \
	by the insertion of a copper coin."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "mbox0"
	gripped_intents = list(INTENT_GENERIC)
	w_class = WEIGHT_CLASS_HUGE
	twohands_required = TRUE
	force = 20
	throwforce = 20
	throw_range = 2
	var/datum/looping_sound/dmusloop/soundloop
	var/curfile
	var/playing = FALSE
	var/loaded = TRUE
	var/lastfilechange = 0
	var/curvol = 100
	anvilrepair = /datum/skill/craft/blacksmithing

/obj/item/dmusicbox/Initialize(mapload)
	soundloop = new(src, FALSE)
//	soundloop.start()
	update_icon()
	. = ..()

/obj/item/dmusicbox/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("This device can be used to play any song uploaded to it, insofar as it is \
	within the .ogg format and around six megabytes or less in size.")
	. += span_info("Load the device by <b>left-clicking</b> it with a copper coin!")
	. += span_info("This device can be activated with a <b>right click<b>, once it is loaded \
	with a copper coin!")

/obj/item/dmusicbox/update_icon()
	if(playing)
		icon_state = "mboxon"
	else
		icon_state = "mbox[loaded]"

/obj/item/dmusicbox/attackby(obj/item/P, mob/user, params)
	if(!loaded)
		if(istype(P, /obj/item/roguecoin/copper))
			loaded=TRUE
			qdel(P)
			update_icon()
			playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
			return
	. = ..()

/obj/item/dmusicbox/rmb_self(mob/user)
	attack_right(user)
	return

/obj/item/dmusicbox/attack_right(mob/user)
	. = ..()
	if(.)
		return
	if(loc != user)
		return
	if(!user.ckey)
		return
	if(playing)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	if(lastfilechange)
		if(world.time < lastfilechange + 3 MINUTES)
			say("NOT YET!")
			return
	if(!loaded)
		say("ONE COIN, A COPPER COIN FOR AN AFTERNOON OF JOY!")
		return
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	var/newfile = music_upload(user, src, 6 * 1024 * 1024)
	if(!newfile)
		return
	if(!loaded || playing || loc != user)
		return

	lastfilechange = world.time
	curfile = newfile
	soundloop.mid_length = rustg_sound_length("[curfile]")

	loaded = FALSE
	update_icon()


/obj/item/dmusicbox/attack_self(mob/living/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	if(!playing)
		if(curfile)
			playing = TRUE
			soundloop.set_mid_sounds(list(curfile))
			soundloop.start()
	else
		playing = FALSE
		soundloop.stop()
	update_icon()
