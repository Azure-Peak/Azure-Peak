#define HAL_LINES_FILE "hallucination.json"
/* Still needs updating:
items
items_other
hudscrew
Chat and dangerflash could use polishing*/
GLOBAL_LIST_INIT(hallucination_list, list(
	/datum/hallucination/chat = 100,
	/datum/hallucination/message = 60,
	/datum/hallucination/sounds = 50,
	/datum/hallucination/voices = 40,
	/datum/hallucination/battle = 20,
	/datum/hallucination/dangerflash = 15,
//	/datum/hallucination/hudscrew = 12,
	/datum/hallucination/fake_alert = 12,
	/datum/hallucination/weird_sounds = 8,
	/datum/hallucination/townannouncement = 7,
//	/datum/hallucination/items_other = 7,
	/datum/hallucination/husks = 7,
	/datum/hallucination/items = 4,
	/datum/hallucination/fire = 3,
	/datum/hallucination/self_delusion = 3,
	/datum/hallucination/delusion = 2,
	/datum/hallucination/shock = 1,
	/datum/hallucination/death = 1
	))


/mob/living/carbon/proc/handle_hallucinations()
	if(!hallucination)
		return

	hallucination--

	if(world.time < next_hallucination)
		return

	var/halpick = pickweight(GLOB.hallucination_list)
	new halpick(src, FALSE)

	next_hallucination = world.time + rand(100, 600)

/mob/living/carbon/proc/set_screwyhud(hud_type)
	hal_screwyhud = hud_type
	update_health_hud()

/datum/hallucination
	var/natural = TRUE
	var/mob/living/carbon/target
	var/feedback_details //extra info for investigate

/datum/hallucination/New(mob/living/carbon/C, forced = TRUE)
	set waitfor = FALSE
	target = C
	natural = !forced

/datum/hallucination/proc/wake_and_restore()
	target.set_screwyhud(SCREWYHUD_NONE)
	target.SetSleeping(0)

/datum/hallucination/Destroy()
	target.investigate_log("was afflicted with a hallucination of type [type] by [natural?"hallucination status":"an external source"]. [feedback_details]", INVESTIGATE_HALLUCINATIONS)
	target = null
	return ..()

//Returns a random turf in a ring around the target mob, useful for sound hallucinations
/datum/hallucination/proc/random_far_turf()
	var/x_based = prob(50)
	var/first_offset = pick(-7,-6,-5,5,6,7)
	var/second_offset = rand(-7,7)
	var/x_off
	var/y_off
	if(x_based)
		x_off = first_offset
		y_off = second_offset
	else
		y_off = first_offset
		x_off = second_offset
	var/turf/T = locate(target.x + x_off, target.y + y_off, target.z)
	return T

/obj/effect/hallucination
	invisibility = INVISIBILITY_OBSERVER
	anchored = TRUE
	var/mob/living/carbon/target = null

/obj/effect/hallucination/simple
	var/image_icon = 'icons/mob/alien.dmi'
	var/image_state = "larva0"
	var/px = 0
	var/py = 0
	var/col_mod = null
	var/image/current_image = null
	var/image_layer = MOB_LAYER
	var/active = TRUE //qdelery

/obj/effect/hallucination/simple/Initialize(mapload, mob/living/carbon/T)
	. = ..()
	target = T
	current_image = GetImage()
	if(target.client)
		target.client.images |= current_image

/obj/effect/hallucination/simple/proc/GetImage()
	var/image/I = image(image_icon,src,image_state,image_layer,dir=src.dir)
	I.pixel_x = px
	I.pixel_y = py
	if(col_mod)
		I.color = col_mod
	return I

/obj/effect/hallucination/simple/proc/Show(update=1)
	if(active)
		if(target.client)
			target.client.images.Remove(current_image)
		if(update)
			current_image = GetImage()
		if(target.client)
			target.client.images |= current_image

/obj/effect/hallucination/simple/update_icon(new_state,new_icon,new_px=0,new_py=0)
	image_state = new_state
	if(new_icon)
		image_icon = new_icon
	else
		image_icon = initial(image_icon)
	px = new_px
	py = new_py
	Show()

/obj/effect/hallucination/simple/Moved(atom/OldLoc, Dir)
	Show()

/obj/effect/hallucination/simple/Destroy()
	if(target.client)
		target.client.images.Remove(current_image)
	active = FALSE
	return ..()

/datum/hallucination/battle

/datum/hallucination/battle/New(mob/living/carbon/C, forced = TRUE, battle_type)
	set waitfor = FALSE
	..()
	/*var/turf/source = random_far_turf()*/
	if(!battle_type)
		battle_type = pick("monster","ranged","trap","blade","ouch","assassin","grab")
	feedback_details += "Type: [battle_type]"
	switch(battle_type)
		if("monster")
			var/hits = 0
			for(var/i in 1 to rand(5, 10))
				target.playsound_local(target, pick('sound/gore/flesh_eat_01.ogg','sound/gore/flesh_eat_02.ogg','sound/gore/flesh_eat_03.ogg','sound/gore/flesh_eat_04.ogg'), 70, 1)
				if(prob(50))
					addtimer(CALLBACK(target, TYPE_PROC_REF(/mob, playsound_local), target, 'sound/combat/dismemberment/dismem (1).ogg', 45, 1), rand(5,10))
					hits++
				else
					addtimer(CALLBACK(target, TYPE_PROC_REF(/mob, playsound_local), target, 'sound/combat/dismemberment/dismem (3).ogg', 35, 1), rand(5,10))
				sleep(rand(CLICK_CD_RANGE, CLICK_CD_RANGE + 6))
				if(hits >= 4 && prob(40))
					target.playsound_local(target, 'sound/combat/caught.ogg', 75, 1)
					sleep(10)
					target.playsound_local(target, 'sound/vo/female/gen/painscream (8).ogg', 70, 1)
					break
		if("ranged")
			var/hits = 0
			for(var/i in 1 to rand(5, 8))
				target.playsound_local(target, 'sound/combat/Ranged/flatbow-shot-01.ogg', 55, 1)
				if(prob(50))
					addtimer(CALLBACK(target, TYPE_PROC_REF(/mob, playsound_local), target, 'sound/combat/hits/hi_arrow.ogg', 75, 1), rand(5,10))
					hits++
					target.playsound_local(target, 'sound/misc/bleed (1).ogg', 90, 1)
				else
					addtimer(CALLBACK(target, TYPE_PROC_REF(/mob, playsound_local), target, 'sound/combat/hits/hi_arrow3.ogg', 65, 1), rand(5,10))
					target.playsound_local(target, 'sound/misc/bleed (2).ogg', 90, 1)
				sleep(rand(CLICK_CD_RANGE, CLICK_CD_RANGE + 6))
				if(hits >= 3 && prob(50))
					target.playsound_local(target, 'sound/combat/newstuck.ogg', 65, 1)
					target.playsound_local(target, 'sound/vo/female/gen/painscream (8).ogg', 60, 1)
					sleep(5)
					target.playsound_local(target, 'sound/foley/bodyfall (3).ogg', 35, 1)
					break
		if("trap")
			target.playsound_local(target, 'sound/items/beartrap.ogg',75, 1)
			target.playsound_local(target, 'sound/vo/female/gen/painscream (5).ogg', 50, 1)
			for(var/i in 1 to rand(3, 8))
				target.playsound_local(target, 'sound/misc/bleed (1).ogg', 90, 1)
				if(i == 4)
					target.playsound_local(target, 'sound/foley/bodyfall (2).ogg', 55, 1)
				sleep(rand(CLICK_CD_MELEE, CLICK_CD_MELEE + 6))
			target.playsound_local(target, 'sound/vo/female/gen/deathgurgle (2).ogg', 65, 1)
		if("blade")
			var/hits = 0
			for(var/i in 1 to rand(3, 6))
				target.playsound_local(target, 'sound/combat/hits/bladed/genslash (1).ogg', 35, TRUE)
				if(prob(60))
					addtimer(CALLBACK(target, TYPE_PROC_REF(/mob, playsound_local), target, 'sound/combat/hits/armor/plate_slashed (1).ogg', 40, 1), rand(5,8))
					hits++
				else
					addtimer(CALLBACK(target, TYPE_PROC_REF(/mob, playsound_local), target, 'sound/combat/hits/bladed/genslash (3).ogg', 45, 1), rand(3,8))
				sleep(rand(CLICK_CD_RANGE, CLICK_CD_RANGE + 6))
				if(hits >= 2 && prob(80))
					target.playsound_local(target, 'sound/vo/male/knight/pain (1).ogg', 55, 1)
					break
		if("ouch") //Getting injured and fall
			target.playsound_local(target, 'sound/vo/female/gen/painscream (4).ogg', 50, 1)
			sleep(8)
			target.playsound_local(target, 'sound/foley/bodyfall (2).ogg', 60, 1)
			sleep(20)
			target.playsound_local(target, 'sound/vo/female/gen/deathgurgle (2).ogg', 65, 1)
		if("assassin") //Like a panda: Eats shoots and leaves
			target.playsound_local(target, 'sound/combat/Ranged/crossbow-small-shot-04.ogg', 55, 1)
			sleep(5)
			target.playsound_local(target, 'sound/combat/hits/hi_bolt (3).ogg', 45, 1)
			target.playsound_local(target, 'sound/combat/newstuck.ogg', 45, 1)
			target.playsound_local(target, 'sound/vo/male/knight/pain (1).ogg', 45, 1)
			sleep(10)
			target.playsound_local(target, 'sound/vo/male/gen/haltyell (1).ogg', 40, 1)
			sleep(20)
			for(var/i in 1 to rand(2, 8))
				target.playsound_local(target, list('sound/combat/hits/bladed/genslash (3).ogg','sound/combat/hits/armor/plate_slashed (1).ogg',\
				'sound/combat/hits/bladed/genslash (2).ogg','sound/combat/hits/bladed/genslash (1).ogg'), 50, 1)
				sleep(rand(2, 4))
				target.playsound_local(target, 'sound/misc/bleed (1).ogg', 90, 1)
				sleep(rand(CLICK_CD_MELEE, CLICK_CD_MELEE + 4))
		if("grab") // Do you have a moment to talk about our lord and savior ZIZOZIZOZIZO
			for(var/i in 1 to rand(3, 6))
				target.playsound_local(target, 'sound/foley/grab.ogg', 100, 0)
				sleep(rand(CLICK_CD_MELEE, CLICK_CD_MELEE + 8))

	qdel(src)

/*/datum/hallucination/items_other

/datum/hallucination/items_other/New(mob/living/carbon/C, forced = TRUE, item_type)
	set waitfor = FALSE
	..()
	var/item
	if(!item_type)
		item = pick(list("esword","taser","ebow","baton","dual_esword","clockspear","ttv","flash","armblade"))
	else
		item = item_type
	feedback_details += "Item: [item]"
	var/side
	var/image_file
	var/image/A = null
	var/list/mob_pool = list()

	for(var/mob/living/carbon/human/M in view(7,target))
		if(M != target)
			mob_pool += M
	if(!mob_pool.len)
		return

	var/mob/living/carbon/human/H = pick(mob_pool)
	feedback_details += " Mob: [H.real_name]"

	var/free_hand = H.get_empty_held_index_for_side(LEFT_HANDS)
	if(free_hand)
		side = "left"
	else
		free_hand = H.get_empty_held_index_for_side(RIGHT_HANDS)
		if(free_hand)
			side = "right"

	if(side)
		switch(item)
			if("esword")
				if(side == "right")
					image_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
				else
					image_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
				target.playsound_local(H, 'sound/blank.ogg',35,1)
				A = image(image_file,H,"swordred", layer=ABOVE_MOB_LAYER)
			if("dual_esword")
				if(side == "right")
					image_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
				else
					image_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
				target.playsound_local(H, 'sound/blank.ogg',35,1)
				A = image(image_file,H,"dualsaberred1", layer=ABOVE_MOB_LAYER)
			if("taser")
				if(side == "right")
					image_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
				else
					image_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
				A = image(image_file,H,"advtaserstun4", layer=ABOVE_MOB_LAYER)
			if("ebow")
				if(side == "right")
					image_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
				else
					image_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
				A = image(image_file,H,"crossbow", layer=ABOVE_MOB_LAYER)
			if("baton")
				if(side == "right")
					image_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
				else
					image_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
				target.playsound_local(H, "sparks",75,1,-1)
				A = image(image_file,H,"baton", layer=ABOVE_MOB_LAYER)
			if("ttv")
				if(side == "right")
					image_file = 'icons/mob/inhands/weapons/bombs_righthand.dmi'
				else
					image_file = 'icons/mob/inhands/weapons/bombs_lefthand.dmi'
				A = image(image_file,H,"ttv", layer=ABOVE_MOB_LAYER)
			if("flash")
				if(side == "right")
					image_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
				else
					image_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
				A = image(image_file,H,"flashtool", layer=ABOVE_MOB_LAYER)
			if("armblade")
				if(side == "right")
					image_file = 'icons/mob/inhands/antag/changeling_righthand.dmi'
				else
					image_file = 'icons/mob/inhands/antag/changeling_lefthand.dmi'
				target.playsound_local(H, 'sound/blank.ogg',30,1)
				A = image(image_file,H,"arm_blade", layer=ABOVE_MOB_LAYER)
		if(target.client)
			target.client.images |= A
			sleep(rand(150,250))
			if(item == "esword" || item == "dual_esword")
				target.playsound_local(H, 'sound/blank.ogg',35,1)
			if(item == "armblade")
				target.playsound_local(H, 'sound/blank.ogg',30,1)
			target.client.images.Remove(A)
	qdel(src)
*/
/datum/hallucination/delusion
	var/list/image/delusions = list()

/datum/hallucination/delusion/New(mob/living/carbon/C, forced, force_kind = null , duration = 300,skip_nearby = FALSE, custom_icon = null, custom_icon_file = null, custom_name = null)
	set waitfor = FALSE
	. = ..()
	var/image/A = null
	var/kind = force_kind ? force_kind : pick("shadow","monster","ww","skeleton","spider","demon","maneater")
	feedback_details += "Type: [kind]"
	var/list/nearby
	if(skip_nearby)
		nearby = get_hearers_in_view(7, target)
	for(var/mob/living/carbon/human/H in GLOB.alive_mob_list)
		if(H == target)
			continue
		if(skip_nearby && (H in nearby))
			continue
		switch(kind)
			if("shadow")
				A = image('icons/roguetown/maniac/dreamer_mobs.dmi',H,"M3")
				A.name = "???"
				target.playsound_local(target, pick('sound/misc/heroin_rush.ogg'), 80, 1)
				target.playsound_local(H, pick('sound/vo/mobs/ghost/whisper (1).ogg','sound/vo/mobs/ghost/whisper (2).ogg','sound/vo/mobs/ghost/whisper (3).ogg'), 100, 1)
			if("monster")//Horror
				A = image('icons/roguetown/mob/monster/horrors.dmi',H,"horror1")
				A.name = "ZIZOZIZOZIZO"
				target.playsound_local(H, pick('sound/combat/gib (1).ogg'), 80, 1)
				target.playsound_local(target, pick('sound/misc/hel.ogg'), 80, 1)
			if("skeleton")//skeleton
				A = image('icons/roguetown/mob/skeleton_male.dmi',H,"z")
				A.name = "Skeleton"
				target.playsound_local(H, pick('sound/vo/mobs/skel/skeleton_rage (1).ogg','sound/vo/mobs/skel/skeleton_rage (2).ogg','sound/vo/mobs/skel/skeleton_rage (3).ogg'), 80, 1)
			if("ww")//ww
				A = image('icons/roguetown/mob/monster/werewolf.dmi',H,"wwolf_m")
				A.name = "Moon Howler"
				target.playsound_local(H, pick('sound/combat/gib (1).ogg'), 80, 1)
				target.playsound_local(H, pick('sound/vo/mobs/wwolf/roar.ogg'), 80, 1)
			if("spider")//Spider
				A = image('icons/roguetown/mob/monster/spider.dmi',H,"skallax")
				A.name = "Ambush spider"
				target.playsound_local(H, 'sound/vo/mobs/spider/idle (1).ogg', 80, 1)
			if("maneater")//Maneater
				A = image('icons/roguetown/mob/monster/maneater.dmi',H,"maneater")
				A.name = "Maneater"
				target.playsound_local(H, pick('sound/vo/mobs/plant/attack (1).ogg','sound/vo/mobs/plant/attack (2).ogg','sound/vo/mobs/plant/attack (3).ogg','sound/vo/mobs/plant/attack (4).ogg'), 80, 1)
			if("demon")//Demon
				A = image('icons/roguetown/mob/monster/hellkeeper.dmi',H,"hellkeeper")
				A.name = "RUN"
				target.playsound_local(H, pick('sound/combat/caught.ogg','sound/misc/astratascream.ogg'), 80, 1)
				target.playsound_local(target, 'sound/misc/carriage1.ogg', 80, 1)
			/*if("custom")
				A = image(custom_icon_file, H, custom_icon)
				A.name = custom_name*/
		A.override = 1
		if(target.client)
			delusions |= A
			target.client.images |= A
	if(duration)
		QDEL_IN(src, duration)

/datum/hallucination/delusion/Destroy()
	for(var/image/I in delusions)
		if(target.client)
			target.client.images.Remove(I)
	return ..()

/datum/hallucination/self_delusion
	var/image/delusion

/datum/hallucination/self_delusion/New(mob/living/carbon/C, forced, force_kind = null , duration = 300, custom_icon = null, custom_icon_file = null, wabbajack = TRUE) //set wabbajack to false if you want to use another fake source
	set waitfor = FALSE
	..()
	var/image/A = null
	var/kind = force_kind ? force_kind : pick("shadow","monster","ww","skeleton","spider","demon","maneater")
	feedback_details += "Type: [kind]"
	switch(kind)
		if("shadow")//shadowperson
			A = image('icons/roguetown/maniac/dreamer_mobs.dmi',target,"M3")
			target.playsound_local(target, pick('sound/misc/heroin_rush.ogg'), 60, 1)
			target.playsound_local(target, pick('sound/vo/mobs/ghost/whisper (1).ogg','sound/vo/mobs/ghost/whisper (2).ogg','sound/vo/mobs/ghost/whisper (3).ogg'), 80, 1)
			/*sleep(10) //I'm not good enough at coding to know how to implement these sounds, but here are the sounds if you want to fix and add them
			target.playsound_local(target, pick('sound/vo/mobs/ghost/laugh (1).ogg','sound/vo/mobs/ghost/laugh (2).ogg','sound/vo/mobs/ghost/laugh (3).ogg'), 80, 1)
			sleep(60)
			target.playsound_local(target, pick('sound/vo/mobs/ghost/laugh (1).ogg','sound/vo/mobs/ghost/laugh (2).ogg','sound/vo/mobs/ghost/laugh (3).ogg'), 80, 1)
			sleep(230)
			target.playsound_local(target, pick('sound/vo/mobs/ghost/death.ogg'), 80, 1)*/
		if("monster")//Bodyhorror
			A = image('icons/roguetown/mob/monster/horrors.dmi',target,"horror1")
			target.playsound_local(target, pick('sound/combat/gib (1).ogg'), 80, 1)
			target.playsound_local(target, pick('sound/misc/hel.ogg'), 80, 1)
			/*sleep(10)
			target.playsound_local(target, pick('sound/combat/caught.ogg'), 80, 1)
			sleep(60)
			target.playsound_local(target, pick('sound/combat/caught.ogg'), 80, 1)
			sleep(230)
			target.playsound_local(target, pick('sound/combat/gib (1).ogg'), 80, 1)*/
		if("ww")//Werewolf
			A = image('icons/roguetown/mob/monster/werewolf.dmi',target,"wwolf_m")
			target.playsound_local(target, pick('sound/combat/gib (1).ogg'), 80, 1)
			target.playsound_local(target, pick('sound/vo/mobs/wwolf/roar.ogg'), 80, 1)
			/*sleep(10)
			target.playsound_local(target, pick('sound/vo/mobs/wwolf/howl (1).ogg','sound/vo/mobs/wwolf/howl (2).ogg','sound/vo/mobs/wwolf/sniff.ogg'), 80, 1)
			sleep(60)
			target.playsound_local(target, pick('sound/vo/mobs/wwolf/idle (1).ogg','sound/vo/mobs/wwolf/idle (2).ogg','sound/vo/mobs/wwolf/sniff.ogg'), 80, 1)
			sleep(230)
			target.playsound_local(target, pick('sound/combat/gib (1).ogg'), 80, 1)
			target.playsound_local(target, pick('sound/vo/mobs/wwolf/death.ogg'), 80, 1)*/
		if("skeleton")//Skeleton
			A = image('icons/roguetown/mob/skeleton_male.dmi',target,"z")
			target.playsound_local(target, pick('sound/vo/mobs/skel/skeleton_rage (1).ogg','sound/vo/mobs/skel/skeleton_rage (2).ogg','sound/vo/mobs/skel/skeleton_rage (3).ogg'), 80, 1)
			/*sleep(10)
			target.playsound_local(target, pick('sound/vo/mobs/skel/skeleton_idle (1).ogg','sound/vo/mobs/skel/skeleton_idle (2).ogg','sound/vo/mobs/skel/skeleton_idle (3).ogg'), 80, 1)
			sleep(60)
			target.playsound_local(target, pick('sound/vo/mobs/skel/skeleton_idle (1).ogg','sound/vo/mobs/skel/skeleton_idle (2).ogg','sound/vo/mobs/skel/skeleton_idle (3).ogg'), 80, 1)
			sleep(220)
			target.playsound_local(target, pick('sound/vo/mobs/skel/skeleton_laugh.ogg'), 80, 1)
			sleep(10)
			target.playsound_local(target, pick('sound/vo/mobs/skel/skeleton_death (2).ogg','sound/vo/mobs/skel/skeleton_death (1).ogg'), 80, 1)*/
		if("spider")//Spider
			A = image('icons/roguetown/mob/monster/spider.dmi',target,"skallax")
			target.playsound_local(target, 'sound/vo/mobs/spider/idle (1).ogg', 80, 1)
		if("demon")//Demon
			A = image('icons/roguetown/mob/monster/hellkeeper.dmi',target,"hellkeeper")
			target.playsound_local(target, pick('sound/combat/caught.ogg','sound/misc/astratascream.ogg'), 80, 1)
			target.playsound_local(target, 'sound/misc/carriage1.ogg', 80, 1)
			/*sleep(20)
			target.playsound_local(target, pick('sound/misc/carriage1.ogg'), 80, 1)
			sleep(60)
			target.playsound_local(target, pick('sound/misc/carriage2.ogg'), 80, 1)
			sleep(120)
			target.playsound_local(target, pick('sound/misc/carriage3.ogg'), 80, 1)
			sleep(80)
			target.playsound_local(target, pick('sound/misc/carriage4.ogg'), 80, 1)*/
		if("maneater")//maneater
			A = image('icons/roguetown/mob/monster/maneater.dmi',target,"maneater")
			target.playsound_local(target, pick('sound/vo/mobs/plant/attack (1).ogg','sound/vo/mobs/plant/attack (2).ogg','sound/vo/mobs/plant/attack (3).ogg','sound/vo/mobs/plant/attack (4).ogg'), 80, 1)
			/*sleep(290)
			target.playsound_local(target, pick('sound/vo/mobs/plant/pain (1).ogg','sound/vo/mobs/plant/pain (2).ogg','sound/vo/mobs/plant/pain (3).ogg','sound/vo/mobs/plant/pain (4).ogg'), 80, 1)*/
		/*if("custom")
			A = image(custom_icon_file, target, custom_icon)*/
	A.override = 1
	if(target.client)
		if(wabbajack)
			to_chat(target, pick("<span class='hear'>...they are coming...</span>","<span class='holoparasite'>THEY ARE WATCHING ME</span>","<span class='userdanger'>I don't feel very good...</span>","<span class='artery'>...please...help...me...</span>"))
			target.playsound_local(target,'sound/misc/dun.ogg', 40, 1)
		delusion = A
		target.client.images |= A
	QDEL_IN(src, duration)

/datum/hallucination/self_delusion/Destroy()
	if(target.client)
		target.client.images.Remove(delusion)
	return ..()

/datum/hallucination/chat

/datum/hallucination/chat/New(mob/living/carbon/C, forced = TRUE, force_radio, specific_message)
	set waitfor = FALSE
	..()
	var/target_name = target.first_name()
	var/speak_messages = list("[pick_list_replacements(HAL_LINES_FILE, "suspicion")]",\
		"[pick_list_replacements(HAL_LINES_FILE, "conversation")]",\
		"[pick_list_replacements(HAL_LINES_FILE, "greetings")][target.first_name()]!",\
		"[pick_list_replacements(HAL_LINES_FILE, "getout")]",\
		"[pick_list_replacements(HAL_LINES_FILE, "weird")]",\
		"[pick_list_replacements(HAL_LINES_FILE, "didyouhearthat")]",\
		"[pick_list_replacements(HAL_LINES_FILE, "doubt")]",\
		"[pick_list_replacements(HAL_LINES_FILE, "aggressive")]",\
		"[pick_list_replacements(HAL_LINES_FILE, "help")]!!",\
		"[pick_list_replacements(HAL_LINES_FILE, "escape")]",\
		"I was bitten by a [pick("deddite","werebeast","vampire","squire")], [pick_list_replacements(HAL_LINES_FILE, "infection_advice")]!",\
		"[pick_list_replacements(HAL_LINES_FILE, "people")] is [pick_list_replacements(HAL_LINES_FILE, "accusations")]!",\
		"Help!",\
		"[pick_list_replacements(HAL_LINES_FILE, "threat")] in [pick_list_replacements(HAL_LINES_FILE, "location")][prob(50)?"!":"!!"]",\
		"[pick("[target.first_name()] is a heretic!", "Make [target.first_name()] an outlaw!")]",\
		"[pick("I","Squire","Somebody","They")] killed the priest!",\
		"Duke [pick("is a Zizoid", "is a heretic")]!!")

	/*var/radio_messages = list("[pick_list_replacements(HAL_LINES_FILE, "people")] is [pick_list_replacements(HAL_LINES_FILE, "accusations")]!",\
		"Help!",\
		"[pick_list_replacements(HAL_LINES_FILE, "threat")] in [pick_list_replacements(HAL_LINES_FILE, "location")][prob(50)?"!":"!!"]",\
		"[pick("[target.first_name()] is a heretic!", "Make [target.first_name()] an outlaw!")]",\
		"[pick("I","Squire","Somebody","They")] killed the priest!",\
		"Duke [pick("is a Zizoid", "is a heretic")]!!")*/

	var/mob/living/carbon/person = null
	var/datum/language/understood_language = target.get_random_understood_language()
	for(var/mob/living/carbon/H in view(target))
		if(H == target)
			continue
		if(!person)
			person = H
		else
			if(get_dist(target,H)<get_dist(target,person))
				person = H
	if(person/* && !force_radio*/) //Basic talk
		var/chosen = specific_message
		if(!chosen)
			chosen = capitalize(pick(speak_messages))
		chosen = replacetext(chosen, "%TARGETNAME%", target_name)
		var/image/speech_overlay = image('icons/mob/talk.dmi', person, "default0a", layer = ABOVE_MOB_LAYER)
		var/message = target.compose_message(person,understood_language,chosen,null,list(person.speech_span),face_name = TRUE)
		feedback_details += "Type: Talk, Source: [person.real_name], Message: [message]"
		to_chat(target, message)
		if(target.client)
			target.client.images |= speech_overlay
			sleep(30)
			target.client.images.Remove(speech_overlay)
		var/spans = list(person.speech_span)
		if(target.client?.prefs)
			if (target.client?.prefs.chat_on_map)
				sleep(30)
				target.create_chat_message(person, understood_language, chosen, spans, 0)
	/*else // Radio talk -- Could be updated for SCOM use by a less-amateur coder
		var/chosen = specific_message
		if(!chosen)
			chosen = capitalize(pick(radio_messages))
		chosen = replacetext(chosen, "%TARGETNAME%", target_name)
		var/list/humans = list()
		for(var/mob/living/carbon/human/H in GLOB.alive_mob_list)
			humans += H
		person = pick(humans)
		var/message = target.compose_message(person,understood_language,chosen,"[FREQ_COMMON]",list(person.speech_span),face_name = TRUE)
		feedback_details += "Type: Radio, Source: [person.real_name], Message: [message]"
		to_chat(target, message)*/
	qdel(src)

/datum/hallucination/message

/datum/hallucination/message/New(mob/living/carbon/C, forced = TRUE)
	set waitfor = FALSE
	..()
	var/list/mobpool = list()
	var/mob/living/carbon/human/other
	var/close_other = FALSE
	for(var/mob/living/carbon/human/H in oview(target, 7))
		if(get_dist(H, target) <= 1)
			other = H
			close_other = TRUE
			break
		mobpool += H
	if(!other && mobpool.len)
		other = pick(mobpool)

	var/list/message_pool = list()
	if(other)
		if(close_other) //increase the odds
			for(var/i in 1 to 5)
				message_pool.Add("<span class='warning'>I feel a tiny prick!</span>")
		var/obj/item/storage/equipped_backpack = other.get_item_by_slot(SLOT_BACK_L)
		if(istype(equipped_backpack))
			for(var/i in 1 to 5) //increase the odds
				message_pool.Add("<span class='notice'>[other] puts the [pick(\
					"killersice","crimson fang","severed head","crown of Azure Peak","master's rod",\
					"master key","vault key", "steward's key", "ritual dagger","spellbook",\
					)] into [equipped_backpack].</span>")

		message_pool.Add("<B>[other]</B> [pick("laughs at [target.first_name()]'s ugly outfit","stares at [target.first_name()]","charges aggressively towards [target.first_name()]","is wondering why [target.first_name()] isn't wearing any pants...")].")

	message_pool.Add("<span class='notice'>I feel something crawling in my ear...</span>", \
		"<span class='notice'>My [pick("arm", "leg", "back", "head")] begins to itch incessantly.</span>",\
		"<span class='warning'>I feel [pick("hot","cold","dry","wet","woozy","faint")].</span>",
		"<span class='adminhelp'>I cough up blood!</span>",
		"<span class='warning'>My head hurts.</span>",
		"<span class='warning'>I hear a faint scratching in my head.</span>",
		"<B>[target]</B> sneezes.")
	if(prob(10))
		message_pool.Add("<span class='warning'>Behind you.</span>",\
			"<span class='warning'>I hear a faint laughter.</span>",
			"<span class='warning'>I see something move.</span>",
			"<span class='warning'>I hear skittering on the ceiling.</span>",
			"<span class='warning'>I see an inhumanly tall silhouette moving in the distance.</span><span class='userdanger'> It's coming towards me...</span>")
	if(prob(10))
		message_pool.Add("[pick_list_replacements(HAL_LINES_FILE, "advice")]")
	var/chosen = pick(message_pool)
	feedback_details += "Message: [chosen]"
	to_chat(target, chosen)
	qdel(src)

/datum/hallucination/sounds

/datum/hallucination/sounds/New(mob/living/carbon/C, forced = TRUE, sound_type)
	set waitfor = FALSE
	..()
	var/turf/source = random_far_turf()
	if(!sound_type)
		sound_type = pick("door","door hit","creepy","magic","far explosion","mech","glass","alarm","lockpick","skele","door pick")
	feedback_details += "Type: [sound_type]"
	//Strange audio
	switch(sound_type)
		if("door")
			target.playsound_local(source,'sound/combat/hits/onwood/destroywalldoor.ogg', 50, 1)
		if("door hit")
			target.playsound_local(source,'sound/combat/hits/onwood/woodimpact (1).ogg', 100, 1)
			sleep(rand(CLICK_CD_MELEE, CLICK_CD_MELEE + 3))
			target.playsound_local(source, 'sound/combat/hits/onwood/woodimpact (2).ogg', 90, 1)
		if("creepy")
			target.playsound_local(source,'sound/combat/caught.ogg', 65, 1)
		if("magic")
			if(prob(50))
				target.playsound_local(source,'sound/magic/fireball.ogg', 80, 1)
			else
				target.playsound_local(source, 'sound/magic/lightning.ogg', 80, 1)
		if("far explosion")
			target.playsound_local(source, 'sound/misc/explode/explosionclose (2).ogg', 60, 1)
		if("glass")
			target.playsound_local(source, pick('sound/combat/hits/onglass/glassbreak (1).ogg','sound/combat/hits/onglass/glassbreak (2).ogg'), 50, 1)
		if("alarm")
			target.playsound_local(source, 'sound/misc/gold_license.ogg', 100, 0)
		if("lockpick")
			target.playsound_local(source, pick('sound/items/pickgood1.ogg','sound/items/pickgood2.ogg'), 95, 0)
		//Spooky scary skeletons
		if("skele")
			target.playsound_local(source, pick('sound/vo/mobs/skel/skeleton_idle (1).ogg','sound/vo/mobs/skel/skeleton_idle (2).ogg','sound/vo/mobs/skel/skeleton_idle (3).ogg'), 80, 1)
			sleep(30)
			target.playsound_local(source, pick('sound/vo/mobs/skel/skeleton_idle (1).ogg','sound/vo/mobs/skel/skeleton_idle (2).ogg','sound/vo/mobs/skel/skeleton_idle (3).ogg'), 80, 1)
			sleep(105)
			target.playsound_local(source, pick('sound/vo/mobs/skel/skeleton_laugh.ogg'), 60, 1)
		//Hacking a door
		if("door pick")
			target.playsound_local(source, 'sound/items/pickbad.ogg', 100, 1)
			sleep(rand(40,80))
			target.playsound_local(source, 'sound/items/pickgood2.ogg', 100, 1)
	qdel(src)

/datum/hallucination/weird_sounds

/datum/hallucination/weird_sounds/New(mob/living/carbon/C, forced = TRUE, sound_type)
	set waitfor = FALSE
	..()
	var/turf/source = random_far_turf()
	if(!sound_type)
		sound_type = pick("bleed","whispers","whispers2","zizo","evil","drill","laughter","creepy")
	feedback_details += "Type: [sound_type]"
	//Strange audio
	switch(sound_type)
		if("bleed")
			target.playsound_local(target, 'sound/misc/bleed (1).ogg', 80)
			sleep(25)
			target.playsound_local(target, 'sound/misc/bleed (2).ogg', 85)
			sleep(25)
			target.playsound_local(target, 'sound/misc/bleed (3).ogg', 90)
			sleep(25)
			target.playsound_local(target, 'sound/misc/bleed (1).ogg', 100)
		if("whispers")
			target.playsound_local(target, 'sound/misc/carriage1.ogg', 90)
			sleep(25)
			target.playsound_local(target, 'sound/misc/carriage3.ogg', 100)
		if("whispers2")
			target.playsound_local(target, 'sound/misc/carriage2.ogg', 90)
			sleep(25)
			target.playsound_local(target, 'sound/misc/carriage4.ogg', 100)
		if("zizo")
			target.playsound_local(target, 'sound/misc/zizo.ogg', 70)
		if("evil")
			target.playsound_local(target, 'sound/misc/evilevent.ogg', 70)
		if("drill")
			target.playsound_local(source, 'sound/misc/TheDrill.ogg', 90)
		if("laughter")
			if(prob(50))
				target.playsound_local(source, 'sound/misc/HL (1).ogg', 60, 1)
			else
				target.playsound_local(source, pick('sound/misc/HL (2).ogg','sound/misc/HL (3).ogg','sound/misc/HL (5).ogg'), 60, 1)
		if("creepy")
			target.playsound_local(target, pick('sound/misc/sting1.ogg','sound/misc/sting2.ogg','sound/misc/obey.ogg','sound/villain/hall_appear1.ogg',\
			'sound/villain/hall_appear2.ogg','sound/villain/hall_appear3.ogg'), 80, 1)
			sleep(60)
			target.playsound_local(target, pick('sound/misc/sting1.ogg','sound/misc/sting2.ogg','sound/misc/obey.ogg','sound/villain/hall_appear1.ogg',\
			'sound/villain/hall_appear2.ogg','sound/villain/hall_appear3.ogg'), 80, 1)

	qdel(src)

/datum/hallucination/townannouncement

/datum/hallucination/townannouncement/New(mob/living/carbon/C, forced = TRUE, message)
	set waitfor = FALSE
	..()
	if(!message)
		message = pick("heretic","outlaw","duke dead","priest dead","lich","ww")
	feedback_details += "Type: [message]"
	switch(message)
		if("heretic")
			to_chat(target, "<h1 class='alert'>SHAME</h1>") //Only uses first name, as a clue it's not real...and I suck at coding too much to figure out getting the full name.
			to_chat(target, "<br><br><span class='alert'>The church has put Xylix's curse of woe on [target.first_name()] for offending the church!</span><br><br>")
			SEND_SOUND(target, 'sound/misc/excomm.ogg')
		if("outlaw")
			to_chat(target, "<h1 class='alert'>The [SSticker.rulertype] Decrees</h1>")
			to_chat(target, "<br><br><span class='alert'>[target.first_name()] has been declared an outlaw and must be captured or slain.</span><br><br>")
			SEND_SOUND(target, 'sound/misc/royal_decree.ogg')
		if("duke dead")
			to_chat(target, "<h1 class='alert'>Bad Omen</h1>")
			to_chat(target, "<br><br><span class='alert'>The [SSticker.rulertype] is dead! We need a new ruler.</span><br><br>")
			SEND_SOUND(target, 'sound/misc/evilevent.ogg')
		if("priest dead") 
			to_chat(target, "<h1 class='alert'>Bad Omen</h1>")
			to_chat(target, "<br><br><span class='alert'>The High Priest is dead!</span><br><br>")
			SEND_SOUND(target, 'sound/misc/evilevent.ogg')
		if("lich")
			to_chat(target, "<h1 class='alert'>The Lich Decrees</h1>")
			to_chat(target, "<br><br><span class='alert'>The throne is mine! Bring me [target.first_name()]...by force, if necessary</span><br><br>")
			SEND_SOUND(target, 'sound/misc/royal_decree.ogg')
			SEND_SOUND(target, 'sound/misc/zizo.ogg')
		if("ww")
			to_chat(target, "<h1 class='alert'>The Werewolf Decrees</h1>")
			to_chat(target, "<br><br><span class='alert'>AWOOOOOOOOOO!!! RRrrrRRrRRRRRrrrRRR RRrrrRRRrrrRRRRRrr [target.first_name()] RRrrRRRRRRRRRrrrRRR</span><br><br>")
			SEND_SOUND(target, 'sound/misc/royal_decree.ogg')
			SEND_SOUND(target, 'sound/vo/mobs/wwolf/howldist (1).ogg')

/*/datum/hallucination/hudscrew

/datum/hallucination/hudscrew/New(mob/living/carbon/C, forced = TRUE, screwyhud_type)
	set waitfor = FALSE
	..()
	//Screwy HUD
	var/chosen_screwyhud = screwyhud_type
	if(!chosen_screwyhud)
		chosen_screwyhud = pick(SCREWYHUD_CRIT,SCREWYHUD_DEAD,SCREWYHUD_HEALTHY)
	target.set_screwyhud(chosen_screwyhud)
	feedback_details += "Type: [target.hal_screwyhud]"
	sleep(rand(100,250))
	target.set_screwyhud(SCREWYHUD_NONE)
	qdel(src)
*/
/datum/hallucination/fake_alert

/datum/hallucination/fake_alert/New(mob/living/carbon/C, forced = TRUE, specific, duration = 150)
	set waitfor = FALSE
	..()
	var/alert_type = pick("bleed","netted","surrender","nutrition","thirsty","fire")
	if(specific)
		alert_type = specific
	feedback_details += "Type: [alert_type]"
	switch(alert_type)
		if("bleed")
			/*target.throw_alert(alert_type, /atom/movable/screen/alert/status_effect/debuff/bleedingt1, override = TRUE)
			sleep(50)
			target.throw_alert(alert_type, /atom/movable/screen/alert/status_effect/debuff/bleedingt2, override = TRUE)
			sleep(50)*/
			target.throw_alert(alert_type, /atom/movable/screen/alert/status_effect/debuff/bleedingt3, override = TRUE)
			target.playsound_local(target, 'sound/misc/bleed (1).ogg', 80)
			sleep(5)
			target.playsound_local(target, 'sound/misc/bleed (2).ogg', 85)
			sleep(5)
			target.playsound_local(target, 'sound/misc/bleed (3).ogg', 90)
			sleep(5)
			target.playsound_local(target, 'sound/misc/bleed (1).ogg', 100)
		if("netted")
			target.throw_alert(alert_type, /atom/movable/screen/alert/status_effect/debuff/netted, override = TRUE)
		if("surrender")
		//	target.throw_alert(alert_type, /atom/movable/screen/alert/status_effect/debuff/breedable, override = TRUE)
			target.throw_alert(alert_type, /atom/movable/screen/alert/status_effect/debuff/submissive, override = TRUE)
		if("nutrition")
			/*target.throw_alert(alert_type, /atom/movable/screen/alert/status_effect/debuff/hungryt1, override = TRUE)
			sleep(50)
			target.throw_alert(alert_type, /atom/movable/screen/alert/status_effect/debuff/hungryt2, override = TRUE)
			sleep(50)*/
			target.throw_alert(alert_type, /atom/movable/screen/alert/status_effect/debuff/hungryt3, override = TRUE)
		if("thirsty")
			/*target.throw_alert(alert_type, /atom/movable/screen/alert/status_effect/debuff/thirstyt1, override = TRUE)
			sleep(50)
			target.throw_alert(alert_type, /atom/movable/screen/alert/status_effect/debuff/thirstyt2, override = TRUE)
			sleep(50)*/
			target.throw_alert(alert_type, /atom/movable/screen/alert/status_effect/debuff/thirstyt3, override = TRUE)
		if("fire")
			target.throw_alert(alert_type, /atom/movable/screen/alert/fire, override = TRUE)
	sleep(duration)
	target.clear_alert(alert_type, clear_override = TRUE)
	qdel(src)

/datum/hallucination/items

/datum/hallucination/items/New(mob/living/carbon/C, forced = TRUE)
	set waitfor = FALSE
	..()
	//Strange items
	if(!target.halitem)
		target.halitem = new
		var/obj/item/l_hand = target.get_item_for_held_index(1)
		var/obj/item/r_hand = target.get_item_for_held_index(2)
		var/l = rogueui_righthand
		var/r = rogueui_lefthand
		var/list/slots_free = list(l,r)
		if(l_hand)
			slots_free -= l
		if(r_hand)
			slots_free -= r
		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			if(!H.belt)
				slots_free += rogueui_backl
			if(!H.l_store)
				slots_free += rogueui_beltl
			if(!H.r_store)
				slots_free += rogueui_beltr
		if(slots_free.len)
			target.halitem.screen_loc = pick(slots_free)
			target.halitem.layer = ABOVE_HUD_LAYER
			target.halitem.plane = ABOVE_HUD_PLANE
			switch(rand(1,5))
				if(1) //bottlebomb
					target.halitem.icon = 'icons/roguetown/items/misc.dmi'
					target.halitem.icon_state = "bbomb-lit"
					target.halitem.name = "bottle bomb"
				if(2) //skull
					target.halitem.icon = 'icons/roguetown/items/valuable.dmi'
					target.halitem.icon_state = "uw1"
					target.halitem.name = "!!!"
				if(3) //crown
					target.halitem.icon = 'icons/roguetown/clothing/head.dmi'
					target.halitem.icon_state = "serpcrown"
					target.halitem.name = "Crown of Azure Peak"
				if(4) //clawl
					target.halitem.icon = 'icons/roguetown/weapons/unarmed32.dmi'
					target.halitem.icon_state = "claw_l"
					target.halitem.name = "ravager claws"
				if(5) //clawr
					target.halitem.icon = 'icons/roguetown/weapons/unarmed32.dmi'
					target.halitem.icon_state = "claw_r"
					target.halitem.name = "ravager claws"
			feedback_details += "Type: [target.halitem.name]"
			if(target.client)
				target.client.screen += target.halitem
			QDEL_IN(target.halitem, rand(150, 350))
	qdel(src)

/datum/hallucination/dangerflash

/datum/hallucination/dangerflash/New(mob/living/carbon/C, forced = TRUE, danger_type)
	set waitfor = FALSE
	..()
	//Flashes of danger
	if(!target.halimage)
		var/list/possible_points = list()
		for(var/turf/open/floor/F in view(target,world.view))
			possible_points += F
		if(possible_points.len)
			var/turf/open/floor/danger_point = pick(possible_points)
			if(!danger_type)
				danger_type = pick("lava","chasm","anomaly")
			switch(danger_type)
				if("lava")
					new /obj/effect/hallucination/danger/lava(danger_point, target)
				if("chasm")
					new /obj/effect/hallucination/danger/chasm(danger_point, target)
				if("anomaly")
					new /obj/effect/hallucination/danger/anomaly(danger_point, target)
	qdel(src)

/obj/effect/hallucination/danger
	var/image/image

/obj/effect/hallucination/danger/proc/show_icon()
	return

/obj/effect/hallucination/danger/proc/clear_icon()
	if(image && target.client)
		target.client.images -= image

/obj/effect/hallucination/danger/Initialize(mapload, _target)
	. = ..()
	target = _target
	show_icon()
	QDEL_IN(src, rand(200, 450))

/obj/effect/hallucination/danger/Destroy()
	clear_icon()
	. = ..()

/obj/effect/hallucination/danger/lava
	name = "lava"

/obj/effect/hallucination/danger/lava/show_icon()
	image = image('icons/turf/floors/lava.dmi',src,"unsmooth",TURF_LAYER)
	if(target.client)
		target.client.images += image

/obj/effect/hallucination/danger/lava/Crossed(atom/movable/AM)
	if(AM == target)
		target.adjustStaminaLoss(20)
		new /datum/hallucination/fire(target)

/obj/effect/hallucination/danger/chasm
	name = "chasm"

/obj/effect/hallucination/danger/chasm/show_icon()
	image = image('icons/turf/floors/Chasms.dmi',src,"smooth",TURF_LAYER)
	if(target.client)
		target.client.images += image

/obj/effect/hallucination/danger/chasm/Crossed(atom/movable/AM)
	if(AM == target)
		if(istype(target, /obj/effect/dummy/phased_mob))
			return
		to_chat(target, "<span class='danger'>I fall into the chasm!</span>")
		target.Paralyze(40)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), target, "<span class='notice'>It's surprisingly shallow.</span>"), 15)
		QDEL_IN(src, 30)

/obj/effect/hallucination/danger/anomaly
	name = "him."

/obj/effect/hallucination/danger/anomaly/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/effect/hallucination/danger/anomaly/process()
	if(prob(70))
		step(src,pick(GLOB.alldirs))

/obj/effect/hallucination/danger/anomaly/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/hallucination/danger/anomaly/show_icon()
	image = image('icons/roguetown/maniac/dreamer_mobs.dmi',src,"M3",OBJ_LAYER+0.01)
	if(target.client)
		target.client.images += image

/obj/effect/hallucination/danger/anomaly/Crossed(atom/movable/AM)
	if(AM == target)
		new /datum/hallucination/shock(target)

/datum/hallucination/death

/datum/hallucination/death/New(mob/living/carbon/C, forced = TRUE)
	set waitfor = FALSE
	..()
	target.set_screwyhud(SCREWYHUD_DEAD)
	target.Paralyze(300)
	target.playsound_local(target, 'sound/misc/deth.ogg', 100, 0)
	target.silent += 10
	to_chat(target, "<span class='deadsay'><b>[target.real_name]</b> has died at <b>[get_area_name(target)]</b>.</span>")
	if(prob(50))
		var/mob/fakemob
		var/list/dead_people = list()
		for(var/mob/dead/observer/G in GLOB.player_list)
			dead_people += G
		if(LAZYLEN(dead_people))
			fakemob = pick(dead_people)
		else
			fakemob = target //ever been so lonely you had to haunt yourself?
		if(fakemob)
			sleep(rand(20, 50))
			to_chat(target, "<span class='deadsay'><b>DEAD: [fakemob.name]</b> says, \"[pick("rip","F in chat","lol","lmao","Anybody else just randomly die?","anyone else just die?","wtf!","why did i just drop dead?","hey [target.first_name()]","lol poison?","you too?","was that a crossbow?",\
			"i[prob(50)?" fucking":""] hate [pick("the ww", "the lich", "rogues", "this round","this","myself","squires","you")]")]\"</span>")
	sleep(rand(70,90))
	target.set_screwyhud(SCREWYHUD_NONE)
	target.SetParalyzed(0)
	target.silent = FALSE
	qdel(src)

/datum/hallucination/fire
	var/active = TRUE
	var/stage = 0
	var/image/fire_overlay

/datum/hallucination/fire/New(mob/living/carbon/C, forced = TRUE)
	set waitfor = FALSE
	..()
	fire_overlay = image('icons/mob/OnFire.dmi', target, "Standing", ABOVE_MOB_LAYER)
	if(target.client)
		target.client.images += fire_overlay
	to_chat(target, "<span class='danger'>You're set on fire!</span>")
	target.throw_alert("fire", /atom/movable/screen/alert/fire, override = TRUE)
	sleep(20)
	for(var/i in 1 to 3)
		stage++
		update_temp()
		sleep(30)
	for(var/i in 1 to rand(5, 10))
		target.adjustStaminaLoss(15)
		sleep(20)
	clear_fire()

/datum/hallucination/fire/proc/update_temp()
	if(stage <= 0)
		target.clear_alert("temp", clear_override = TRUE)
	else
		target.clear_alert("temp", clear_override = TRUE)
		target.throw_alert("temp", /atom/movable/screen/alert/hot, stage, override = TRUE)

/datum/hallucination/fire/proc/clear_fire()
	if(!active)
		return
	active = FALSE
	target.clear_alert("fire", clear_override = TRUE)
	if(target.client)
		target.client.images -= fire_overlay
	QDEL_NULL(fire_overlay)
	while(stage > 0)
		stage--
		update_temp()
		sleep(30)
	qdel(src)

/datum/hallucination/shock
	var/image/shock_image
	var/image/electrocution_skeleton_anim

/datum/hallucination/shock/New(mob/living/carbon/C, forced = TRUE)
	set waitfor = FALSE
	..()
	shock_image = image(target, target, dir = target.dir)
	shock_image.appearance_flags |= KEEP_APART
	shock_image.color = rgb(0,0,0)
	shock_image.override = TRUE
	electrocution_skeleton_anim = image('icons/mob/human.dmi', target, icon_state = "electrocuted_base", layer=ABOVE_MOB_LAYER)
	electrocution_skeleton_anim.appearance_flags |= RESET_COLOR|KEEP_APART
	to_chat(target, "<span class='danger'>I feel a powerful shock course through my body!</span>")
	if(target.client)
		target.client.images |= shock_image
		target.client.images |= electrocution_skeleton_anim
	addtimer(CALLBACK(src, PROC_REF(reset_shock_animation)), 40)
	target.playsound_local(get_turf(src), "sparks", 100, 1)
	target.staminaloss += 50
	target.Stun(40)
	target.jitteriness += 1000
	target.do_jitter_animation(target.jitteriness)
	addtimer(CALLBACK(src, PROC_REF(shock_drop)), 20)

/datum/hallucination/shock/proc/reset_shock_animation()
	if(target.client)
		target.client.images.Remove(shock_image)
		target.client.images.Remove(electrocution_skeleton_anim)

/datum/hallucination/shock/proc/shock_drop()
	target.jitteriness = max(target.jitteriness - 990, 10) //Still jittery, but vastly less
	target.Paralyze(60)

/datum/hallucination/husks

/datum/hallucination/husks/New(mob/living/carbon/C, forced = TRUE)
	set waitfor = FALSE
	..()
	if(!target.halbody)
		var/list/possible_points = list()
		for(var/turf/open/floor/F in view(target,world.view))
			possible_points += F
		if(possible_points.len)
			var/turf/open/floor/husk_point = pick(possible_points)
			switch(rand(1,12))
				if(1)
					var/image/body = image('icons/mob/human.dmi',husk_point,"husk",TURF_LAYER)
					var/matrix/M = matrix()
					M.Turn(90)
					body.transform = M
					target.halbody = body
				if(2)
					target.halbody = image('icons/roguetown/mob/monster/horrors.dmi',husk_point,"horror3",TURF_LAYER)
				if(3)
					target.halbody = image('icons/roguetown/mob/monster/horrors.dmi',husk_point,"headcrab",TURF_LAYER)
				if(4)
					target.halbody = image('icons/roguetown/mob/monster/horrors.dmi',husk_point,"horror4",TURF_LAYER)
				if(5)
					target.halbody = image('icons/roguetown/maniac/dreamer_mobs.dmi',husk_point,"mom",TURF_LAYER)
				if(6)
					target.halbody = image('icons/roguetown/maniac/dreamer_mobs.dmi',husk_point,"M3",TURF_LAYER)
				if(7)
					target.halbody = image('icons/roguetown/maniac/creations.dmi',husk_point,"creation1",TURF_LAYER)
				if(8)
					target.halbody = image('icons/mob/human.dmi',husk_point,"husk",TURF_LAYER)
				if(9)
					target.halbody = image('icons/mob/human.dmi',husk_point,"ghost",TURF_LAYER)
				if(10)
					target.halbody = image('icons/mob/human.dmi',husk_point,"body_cloaked",TURF_LAYER)
				if(11)
					target.halbody = image('icons/mob/mob.dmi',husk_point,"mist",TURF_LAYER)
				if(12)
					target.halbody = image('icons/mob/mob.dmi',husk_point,"revenant_idle",TURF_LAYER)

			if(target.client)
				target.client.images += target.halbody
			sleep(rand(20,40)) //Only seen for a brief moment.
			if(target.client)
				target.client.images -= target.halbody
			QDEL_NULL(target.halbody)
	qdel(src)

/datum/hallucination/voices
	var/static/list/messages = list(
		"YOUR FATE IS SEALED IN BLOOD AND ASHES!",
		"SHE CALLS YOUR NAME, FOOL!",
		"THE GODS SPIT ON YOUR WORTHLESS SOUL!",
		"YOUR HEART BEATS FOR THEIR ASCENSION!",
		"CLAWS TEAR AT YOUR MIND FROM WITHIN!",
		"NO ONE WILL MOURN YOUR BROKEN CORPSE!",
		"THEIR EYES WATCH FROM EVERY WOUND!",
		"THE SWAMP WILL SWALLOW YOUR HOPE!",
		"PAIN IS YOUR ONLY TRUE COMPANION!",
		"THE CHAINS OF FATE BIND YOUR BONES!",
		"THEY LAUGH AS YOUR MIND CRUMBLES!",
		"THE STARS MOCK YOUR FUTILE STRUGGLE!",
		"THE GROUND WEEPS BLOOD WHERE YOU TREAD!",
		"THEIR WHISPERS CARVE YOUR FLESH TO DUST!",
		"THE BEASTS SMELL YOUR FEAR AND HUNGER!",
		"YOUR VEINS PULSE WITH THEIR MALICE!",
		"DEATH IS TOO MERCIFUL FOR YOUR SINS!",
		"THE BOG CLAIMS YOUR HOPELESS BONES!",
		"THE GODS HAVE MARKED YOU FOR TORMENT!",
		"YOUR CRIES ECHO IN AN EMPTY ABYSS!",
		"THE SHADOWS BIND YOUR WRETCHED FATE!",
		"YOUR MIND IS A PRISON OF THEIR DESIGN!",
		"THE FLAMES OF YOUR GUILT CONSUME YOU!",
		"YOUR HEART IS A TROPHY FOR HER GLORY!",
		"THE STORM SINGS OF YOUR DOOMED PATH!",
		"THEIR CLAWS SCRATCH YOUR NAME IN STONE!",
		"YOUR BREATH FEEDS HIS ENDLESS HUNGER!",
		"THE GODS LAUGH AT YOUR BROKEN DREAMS!",
		"YOUR SHADOW BETRAYS YOU TO THE DARK!",
		"THE SWAMP WHISPERS YOUR FINAL MOMENTS!",
		"YOUR FLESH IS A CANVAS FOR HIS WRATH!",
	)

/datum/hallucination/voices/New(mob/living/carbon/carbon, forced = TRUE)
	set waitfor = FALSE
	..()

	var/list/objs = list()

	for(var/obj/obj in oview(3, carbon))
		objs += obj
	
	var/obj/obj = safepick(objs)

	if(!obj)
		qdel(src)
		return

	var/lang = carbon.get_default_language()
	var/picked_message = pick(messages)
	var/composed = obj.compose_message(obj, carbon.get_default_language(), picked_message)

	carbon.Hear(composed, obj, lang, picked_message)

	if(prob(20))
		carbon.emote("whimper")

	qdel(src)
