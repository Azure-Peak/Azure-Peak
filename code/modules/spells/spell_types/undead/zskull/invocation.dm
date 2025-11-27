/obj/effect/proc_holder/spell/invoked/invocation
	name = "Amethyst Invocation"
	desc = "Use it on yourself to summon a wave of lesser undead.\n\
	Otherwise, mark the area 3x3, which will be cursed in a couple of moments."
	base_icon_state = "spellzizo"
	overlay_state = "amethyst"
	clothes_req = FALSE
	range = 10
	recharge_time = 0
	chargedloop = /datum/looping_sound/invokegen
	action_icon_state = "summons"
	invocations = list("Invocatio")
	invocation_type = "whisper"

/obj/effect/proc_holder/spell/invoked/invocation/cast(list/targets, mob/living/carbon/human/user = usr)
	if(user.has_status_effect(/datum/status_effect/buff/zskull_cooldown))
		return
	if(!("[user.mind.current.real_name]_faction" in user.faction))
		user.faction |= "[user.mind.current.real_name]_faction"
	user.apply_status_effect(/datum/status_effect/buff/zskull_cooldown)
	var/turf/T = get_turf(targets[1])
	var/turf/source_turf = get_turf(user)
	
	var/skill = (user.get_skill_level(/datum/skill/magic/holy) + user.get_skill_level(/datum/skill/magic/arcane))
	var/round = 0
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		T = get_turf(target)
	for(var/mob/living/L in T.contents) //On self
		if(L == user)
			for(var/turf/affect in range(3, source_turf))
				if(round <= skill+3)
					if(affect == T)
						continue
					if(prob(50))
						continue
					var/obj/effect/temp_visual/trap/necromancy/N = new /obj/effect/temp_visual/trap/necromancy(affect)
					N.user = user
					round++
					sleep(3)
			return TRUE
	if(istype(T, /turf/open/transparent/openspace) || istype(T, /turf/open))
		for(var/turf/affect in range(1, T))
			new /obj/effect/temp_visual/trap/withernecro(affect)
		return TRUE
	else
		return FALSE

/obj/effect/temp_visual/trap/necromancy
	icon = 'icons/effects/effects.dmi'
	icon_state = "trap"
	color = "#7300ffff"
	light_outer_range = 2
	light_color = "#b884f8"
	duration = 3 SECONDS
	var/user = null
	var/cabal_affine = TRUE

/obj/effect/temp_visual/trap/necromancy/Initialize(mapload, list/flame_hit)
	..()
	INVOKE_ASYNC(src, PROC_REF(bam), flame_hit)

/obj/effect/temp_visual/trap/necromancy/proc/bam(list/flame_hit)
	var/turf/T = get_turf(src)
	sleep(duration)
	playsound(get_turf(src), 'sound/vo/mobs/ghost/skullpile_hit.ogg', 30, TRUE, soundping = TRUE)
	new /mob/living/simple_animal/hostile/rogue/skeleton(T, user, cabal_affine)

/obj/effect/temp_visual/trap/withernecro
	icon = 'icons/effects/effects.dmi'
	icon_state = "trap"
	color = "#7300ffff"
	light_outer_range = 2
	light_color = "#b884f8"
	layer = BELOW_MOB_LAYER
	plane = GAME_PLANE
	duration = 2 SECONDS
	var/explode_sound = list('sound/misc/explode/incendiary (1).ogg','sound/misc/explode/incendiary (2).ogg')

/obj/effect/temp_visual/trap/withernecro/Initialize(mapload, list/flame_hit)
	..()
	INVOKE_ASYNC(src, PROC_REF(bam), flame_hit)

/obj/effect/temp_visual/trap/withernecro/proc/bam(list/flame_hit)
	var/turf/T = get_turf(src)
	sleep(duration)
	playsound(get_turf(src), 'sound/vo/mobs/ghost/skullpile_hit.ogg', 30, TRUE, soundping = TRUE)

	for(var/mob/living/L in T.contents)
		L.adjustFireLoss(40)
		L.apply_status_effect(/datum/status_effect/buff/witherd/)

/obj/effect/proc_holder/spell/invoked/invocation/toper
	name = "Toper Invocation"
	desc = "Use it on yourself to mark the nearest living targets and hit them with a cursed lightning bolt in a couple of moments.\n\
	Otherwise, concentrate all the power of the toper, and hit the area with a powerful blow from the sky."
	overlay_state = "topaz"
	clothes_req = FALSE
	range = 10
	recharge_time = 0
	chargedloop = /datum/looping_sound/invokegen
	action_icon_state = "summons"
	invocations = list("Invocatio")
	invocation_type = "whisper"

/obj/effect/proc_holder/spell/invoked/invocation/toper/cast(list/targets, mob/living/carbon/human/user = usr)
	if(user.has_status_effect(/datum/status_effect/buff/zskull_cooldown))
		return
	user.apply_status_effect(/datum/status_effect/buff/zskull_cooldown)
	var/turf/T = get_turf(targets[1])
	var/turf/source_turf = get_turf(user)
	
	var/skill = (user.get_skill_level(/datum/skill/magic/holy) + user.get_skill_level(/datum/skill/magic/arcane))
	var/round = 0
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		T = get_turf(target)
	playsound(source_turf,'sound/weather/rain/thunder_1.ogg', 80, TRUE)
	source_turf.visible_message(span_boldwarning("The air feels crackling and charged!"))
	for(var/mob/living/L in T.contents) //On self
		if(L == user)
			for(var/mob/living/ltarget in range(skill, source_turf))
				if(round <= skill)
					if(ltarget == user)
						continue
					if("[user.mind.current.real_name]_faction" in ltarget.mind?.current.faction) //for players
						continue
					if("[user.mind.current.real_name]_faction" in ltarget.faction) //for simple
						continue
					if(ltarget.stat == DEAD)
						continue
					round++
					new /obj/effect/temp_visual/trap/zizolightning/lesser(get_turf(ltarget))
					sleep(2)
			return TRUE
	if(istype(T, /turf/open/transparent/openspace) || istype(T, /turf/open))
		for(var/turf/affect in range(1, T))
			if(affect == T)
				new/obj/effect/temp_visual/trap/zizolightning(affect)
			else
				new/obj/effect/temp_visual/trap(affect)
		return TRUE
	else
		return FALSE

/obj/effect/temp_visual/trap/zizolightning
	icon = 'icons/effects/effects.dmi'
	icon_state = "trap"
	color = "#FF0000"
	light_color = "#FF0000"
	layer = BELOW_MOB_LAYER
	plane = GAME_PLANE
	light_outer_range = 2
	duration = 10
	var/explode_sound = list('sound/misc/explode/incendiary (1).ogg','sound/misc/explode/incendiary (2).ogg')
	var/lesser = FALSE

/obj/effect/temp_visual/lightning/zizo
	color = "#FF0000"

/obj/effect/temp_visual/trap/zizolightning/Initialize(mapload, list/flame_hit)
	..()
	INVOKE_ASYNC(src, PROC_REF(storm), flame_hit)

/obj/effect/temp_visual/trap/zizolightning/proc/storm(list/flame_hit)
	var/turf/T = get_turf(src)
	sleep(duration)
	playsound(T,'sound/magic/lightning.ogg', 80, TRUE)
	new /obj/effect/temp_visual/lightning/zizo(T)

	for(var/mob/living/L in T.contents)
		if(L.anti_magic_check())
			continue
		if(lesser == TRUE)
			L.electrocute_act(35)
		else
			L.electrocute_act(75)
		to_chat(L, span_userdanger("You're hit by lightning!!!"))
		if(lesser == FALSE)
			for(var/mob/living/S in range(1, T))
				if(S == L)
					continue
				S.electrocute_act(45)
				to_chat(S, span_userdanger("You're hit by lightning!!!"))
	if(lesser == FALSE)
		explosion(T, -1, 0, 0, 5, 0, flame_range = 1, smoke = TRUE, soundin = 'sound/magic/lightning.ogg')

/obj/effect/temp_visual/trap/zizolightning/lesser
	lesser = TRUE

/obj/effect/proc_holder/spell/invoked/invocation/gemerald
	name = "Gemerald Invocation"
	desc = "Use it on yourself to trigger a chaotic acid attack.\n\
	Otherwise, direct the steadily moving acid wave in one of the 8 fixed directions."
	overlay_state = "emerald"
	clothes_req = FALSE
	range = 10
	recharge_time = 0
	chargedloop = /datum/looping_sound/invokegen
	action_icon_state = "summons"
	invocations = list("Invocatio")
	invocation_type = "whisper"

/obj/effect/proc_holder/spell/invoked/invocation/gemerald/cast(list/targets, mob/living/carbon/human/user = usr)
	if(user.has_status_effect(/datum/status_effect/buff/zskull_cooldown))
		return
	user.apply_status_effect(/datum/status_effect/buff/zskull_cooldown)
	var/turf/T = get_turf(targets[1])
	var/turf/source_turf = get_turf(user)
	
	var/skill = (user.get_skill_level(/datum/skill/magic/holy) + user.get_skill_level(/datum/skill/magic/arcane))
	var/round = 0
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		T = get_turf(target)
	for(var/mob/living/L in T.contents) //On self
		if(L == user)
			for(var/turf/tturf in range(12,source_turf))
				if(round <= skill*3)
					if(!tturf)
						continue
					if(prob(75))
						continue
					new/obj/effect/temp_visual/trap/acid(tturf)
					round++
					sleep(1)
			return TRUE
	if(istype(T, /turf/open/transparent/openspace) || istype(T, /turf/open))
		if(!do_after(user,0.5 SECONDS, user))
			return
		if(!T)
			return
		var/dir_to_target = get_dir(user, T)

		var/turf/current = get_step(get_turf(user), dir_to_target)

		var/list/firewave_rows = list()
		for(var/i = 1, i <= 6, i++)
			if(!current)
				break
			var/list/row = list()
			row += current
			row += get_step(current, turn(dir_to_target, 90))
			row += get_step(current, turn(dir_to_target, -90))

			firewave_rows += list(row)
			current = get_step(current, dir_to_target)

		var/delay = 3
		for(var/row_index = 1, row_index <= firewave_rows.len, row_index++)
			var/list/row = firewave_rows[row_index]
			spawn(delay * (row_index - 1))
				for(T in row)
					if(!T)
						continue
					for(var/mob/living/L in T)
						if(L == src)
							continue
						if (!L.mind && istype(L, /mob/living/simple_animal))
							L.adjustFireLoss(40) //x2 VS mobs
						L.adjustFireLoss(40)
						L.apply_status_effect(/datum/status_effect/buff/acidsplash)
					new /obj/effect/temp_visual/acidsplash(T, dir_to_target)
	else
		return FALSE

/obj/effect/temp_visual/trap/acid
	icon = 'icons/effects/effects.dmi'
	icon_state = "trap"
	light_color = "#16b311ff"
	layer = BELOW_MOB_LAYER
	plane = GAME_PLANE
	light_outer_range = 2
	duration = 6.3 SECONDS

/obj/effect/temp_visual/trap/acid/Initialize(mapload, list/flame_hit)
	..()
	INVOKE_ASYNC(src, PROC_REF(bam), flame_hit)

/obj/effect/temp_visual/trap/acid/proc/bam(list/flame_hit)
	var/turf/T = get_turf(src)
	sleep(3 SECONDS)
	playsound(T, 'sound/misc/drink_blood.ogg', 100)
	new /obj/effect/temp_visual/acidblob(T)
	sleep(1 SECONDS) //POP

	for(var/mob/living/L in range(1, T))
		if(L.anti_magic_check())
			continue
		L.adjustFireLoss(40)
		L.apply_status_effect(/datum/status_effect/buff/acidsplash)
	for(var/turf/turf in range(1, T))
		new /obj/effect/temp_visual/acidsplash(turf)

/obj/effect/temp_visual/acidblob
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "acidglob"
	name = "horrible acrid brine"
	desc = "Best not touch this."
	randomdir = TRUE
	duration = 5 SECONDS
	layer = ABOVE_ALL_MOB_LAYER

/obj/effect/temp_visual/acidblob/Initialize()
	..()
	alpha = 0
	animate(src, alpha = 255, time = 3 SECONDS, easing = EASE_IN)
	icon_state = "acidglob"
	sleep(4 SECONDS)
	icon_state = "[icon_state]_pop"

/obj/effect/proc_holder/spell/invoked/invocation/saffira
	name = "Saffira Invocation"
	desc = "Apply to yourself or another live target to mark the point where it is located, to which the target will be moved as time passes.\n\
	Otherwise, create a two-way portal.\n\
	When you can create a second one, they will connect automatically."
	overlay_state = "sapphire"
	clothes_req = FALSE
	range = 10
	recharge_time = 0
	chargedloop = /datum/looping_sound/invokegen
	action_icon_state = "summons"
	invocations = list("Invocatio")
	invocation_type = "whisper"

/obj/effect/proc_holder/spell/invoked/invocation/saffira/cast(list/targets, mob/living/carbon/human/user = usr)
	if(user.has_status_effect(/datum/status_effect/buff/zskull_cooldown))
		return
	user.apply_status_effect(/datum/status_effect/buff/zskull_cooldown)
	var/turf/T = get_turf(targets[1])
	var/turf/source_turf = get_turf(user)
	
	var/skill = (user.get_skill_level(/datum/skill/magic/holy) + user.get_skill_level(/datum/skill/magic/arcane))
	var/dyr = skill * 5 SECONDS
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		T = get_turf(target)
	for(var/mob/living/L in T.contents) //On self
		//timeshift
		if(L == user)
			user.visible_message("<span class='warning'>[user] shake the saffira runic skull!</span>")
			sleep(dyr)
			user.Immobilize(4 SECONDS)
			new/obj/effect/temp_visual/blinksaffira(get_turf(L))
			sleep(3 SECONDS)
			do_teleport(user, source_turf, channel = TELEPORT_CHANNEL_QUANTUM)
			new/obj/effect/temp_visual/blinksaffira(source_turf)
			return TRUE
		else
			to_chat(user,span_notice("<span class='warning'>I shake the saffira runic skull, and point on [L]!</span>"))
			sleep(dyr)
			L.Immobilize(4 SECONDS)
			new/obj/effect/temp_visual/blinksaffira(get_turf(L))
			sleep(3 SECONDS)
			do_teleport(L, T, channel = TELEPORT_CHANNEL_QUANTUM)
			new/obj/effect/temp_visual/blinksaffira(T)
			return TRUE
	if(istype(T, /turf/open/transparent/openspace) || istype(T, /turf/open))
		//portal creation
		new/obj/effect/temp_visual/trap(T)
		sleep(10)
		var/obj/structure/fluff/zizoprotal/portal = new /obj/structure/fluff/zizoprotal(T)
		playsound(T, 'sound/misc/evilevent.ogg', 100)
		portal.dur = (1 MINUTES * skill)
		portal.key = "[user.mind.current.real_name]_portal"
		return TRUE
	else
		return FALSE

/obj/effect/temp_visual/blinksaffira
	icon = 'icons/effects/effects.dmi'
	icon_state = "hierophant_squares"
	name = "gravity magic"
	desc = "Get out of the way!"
	color = "#00eaffff"
	randomdir = FALSE
	duration = 3 SECONDS
	layer = MASSIVE_OBJ_LAYER
	light_color = "#0095ffff"
	light_outer_range = 5

/obj/effect/temp_visual/gravity/Initialize()
	animate(src, transform = matrix()*3, alpha = 0, time = 5, flags = ANIMATION_END_NOW) //fade out	
	sleep(3 SECONDS)
	animate(src, transform = matrix(), alpha = 255, time = 0, flags = ANIMATION_END_NOW)


/obj/effect/proc_holder/spell/invoked/invocation/blortz
	name = "Blortz Invocation"
	desc = "Apply it on yourself to surround your body with a draining and damaging frosty aura.\n\
	Otherwise, start a small ritual of casting a frost storm."
	overlay_state = "quartz"
	clothes_req = FALSE
	range = 10
	recharge_time = 0
	chargedloop = /datum/looping_sound/invokegen
	action_icon_state = "summons"
	invocations = list("Invocatio")
	invocation_type = "whisper"

/obj/effect/proc_holder/spell/invoked/invocation/blortz/cast(list/targets, mob/living/carbon/human/user = usr)
	if(user.has_status_effect(/datum/status_effect/buff/zskull_cooldown))
		return
	user.apply_status_effect(/datum/status_effect/buff/zskull_cooldown)
	var/turf/T = get_turf(targets[1])
	var/turf/source_turf = get_turf(user)
	
	var/skill = (user.get_skill_level(/datum/skill/magic/holy) + user.get_skill_level(/datum/skill/magic/arcane))
	var/round = 0
	var/trange = 4
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		T = get_turf(target)
	for(var/mob/living/L in T.contents) //On self
		//timeshift
		if(L == user)
			if(!isliving(user))
				revert_cast()
				return
			var/mob/living/spelltarget = user
			playsound(source_turf, 'sound/magic/haste.ogg', 80, TRUE, soundping = TRUE)

			if(spelltarget.has_status_effect(/datum/status_effect/buff/iceaura))
				spelltarget.remove_status_effect(/datum/status_effect/buff/iceaura)
			else
				spelltarget.visible_message("[user] The body begins to be covered with ice patterns. The cold of the grave is spreading!")
				spelltarget.apply_status_effect(/datum/status_effect/buff/iceaura)
			return TRUE
	if(istype(T, /turf/open/transparent/openspace) || istype(T, /turf/open))
		for(var/i in 1 to 500)
			if(round > skill)
				return
			if(!do_after(user, 0.6 SECONDS))
				return
			var/last_dist = 0
			for(var/t in spiral_range_turfs(trange, T))
				var/turf/tturf = t
				if(!T)
					continue
				var/dist = get_dist(tturf, T)
				if(dist > last_dist)
					last_dist = dist
					sleep(2 + min(trange - last_dist, 12) * 0.5) //gets faster
				new /obj/effect/temp_visual/snap_freeze(tturf)
				for(var/mob/living/ltarget in tturf)
					if(ltarget.anti_magic_check())
						continue
					if(ltarget.has_status_effect(/datum/status_effect/buff/frostbite))
						continue
					else
						if(ltarget.has_status_effect(/datum/status_effect/buff/frost))
							playsound(tturf, 'sound/combat/fracture/fracturedry (1).ogg', 80, TRUE, soundping = TRUE)
							ltarget.remove_status_effect(/datum/status_effect/buff/frost)
							ltarget.apply_status_effect(/datum/status_effect/buff/frostbite)
						else
							ltarget.apply_status_effect(/datum/status_effect/buff/frost)
					if(ishuman(ltarget))
						ltarget.adjustFireLoss(30)
					else
						ltarget.adjustFireLoss(30 + 30)
				round++
			return TRUE
	else
		return FALSE

#define ICEAURA_FILTER "iceaura_glow"

/atom/movable/screen/alert/status_effect/buff/iceaura
	name = "Ice Aura"
	desc = "Ice dancing around me while all living things are froze nearby!"
	icon_state = "debuff"

/datum/status_effect/buff/iceaura
	id = "iceaura"
	alert_type = /atom/movable/screen/alert/status_effect/buff/iceaura
	effectedstats = list(STATKEY_WIL = -2)
	examine_text = "<font color='blue'>Emit Ice Aura!"
	duration = 1 MINUTES
	var/outline_colour ="#00fbffff"

/datum/status_effect/buff/iceaura/on_apply()
	. = ..()
	var/filter = owner.get_filter(ICEAURA_FILTER)
	if (!filter)
		owner.add_filter(ICEAURA_FILTER, 1, list("type" = "outline", "color" = outline_colour, "alpha" = 50, "size" = 1))
	to_chat(owner, span_warning("My skin cold like ice."))

/datum/status_effect/buff/iceaura/tick()
	var/mob/living/user = owner
	user.adjustFireLoss(1)
	for(var/mob/living/L in view(3, get_turf(user)))
		if(L.stat == DEAD || L.stat != CONSCIOUS || get_dist(L, user) > 3)
			L.remove_status_effect(/datum/status_effect/buff/iceaurabad)
			return FALSE
		if(L == user)
			continue
		if("[user.mind.current.real_name]_faction" in L.mind?.current.faction) //for players
			continue
		if("[user.mind.current.real_name]_faction" in L.faction) //for simple
			continue
		L.apply_status_effect(/datum/status_effect/buff/iceaurabad)

/datum/status_effect/buff/iceaura/on_remove()
	. = ..()
	to_chat(owner, span_warning("The ice shell fades away."))
	owner.remove_filter(ICEAURA_FILTER)

/datum/status_effect/buff/iceaurabad
	id = "iceaurabad"
	duration = -1
	effectedstats = list(STATKEY_CON = -1, STATKEY_WIL = -1)
	alert_type = /atom/movable/screen/alert/status_effect/iceaurabad

/atom/movable/screen/alert/status_effect/iceaurabad
	name = "Magical Freeze"
	desc = "A magical ice is devouring my body! We need to move away from the source!"
	icon_state = "debuff"

/datum/status_effect/buff/iceaurabad/on_apply()
	. = ..()
	to_chat(owner, span_warning("A magical ice is devouring my body! We need to move away from the source!"))

/datum/status_effect/buff/iceaurabad/tick()
	var/mob/living/target = owner
	target.adjustFireLoss(5)
	if(prob(25))
		target.stamina_add(25)

#undef ICEAURA_FILTER

/obj/effect/proc_holder/spell/invoked/invocation/rontz
	name = "Rontz Invocation"
	desc = "Use it on yourself to steal the life from the creatures around you, the power of healing depends on the number of sources.\n\
	Otherwise, mark the 3x3 area, and all creatures trapped in it will become a target for your life-draining ability."
	overlay_state = "ruby"
	clothes_req = FALSE
	range = 10
	recharge_time = 0
	chargedloop = /datum/looping_sound/invokegen
	action_icon_state = "summons"
	invocations = list("Invocatio")
	invocation_type = "whisper"

/obj/effect/proc_holder/spell/invoked/invocation/rontz/cast(list/targets, mob/living/carbon/human/user = usr)
	if(user.has_status_effect(/datum/status_effect/buff/zskull_cooldown))
		return
	user.apply_status_effect(/datum/status_effect/buff/zskull_cooldown)
	var/turf/T = get_turf(targets[1])
	var/turf/source_turf = get_turf(user)
	var/buff_strength = 0
	var/skill = (user.get_skill_level(/datum/skill/magic/holy) + user.get_skill_level(/datum/skill/magic/arcane))
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		T = get_turf(target)
	for(var/mob/living/L in T.contents) //On self
		if(L == user)
			for(var/mob/living/S in range(skill, source_turf))
				if(S == user)
					continue
				if("[user.mind.current.real_name]_faction" in S.mind?.current.faction) //for players
					continue
				if("[user.mind.current.real_name]_faction" in S.faction) //for simple
					continue
				if(S.stat == DEAD)
					continue
				var/obj/projectile/magic/heal/P = new /obj/projectile/magic/heal(S.loc)
				buff_strength += 1
				P.firer = S
				P.preparePixelProjectile(user, S)
				P.fire()
				S.adjustBruteLoss(20)
			if(buff_strength != 0)
				user.apply_status_effect(/datum/status_effect/buff/healing/zizoblood, buff_strength)
				user.adjustBruteLoss(-10*buff_strength)
				user.adjustFireLoss(-10*buff_strength)
			return TRUE
	if(istype(T, /turf/open/transparent/openspace) || istype(T, /turf/open))
		for(var/mob/living/L in view(1, T))
			if(L.stat == DEAD || L.stat != CONSCIOUS || get_dist(L, user) > range)
				return FALSE
			if(L == user)
				continue
			L.apply_status_effect(/datum/status_effect/buff/lifestealtarget)
			user.apply_status_effect(/datum/status_effect/buff/lifestealuser)
		return TRUE
	else
		return FALSE

/obj/projectile/magic/heal
	name = "profaned bone splinter"
	icon_state = "chronobolt"
	color = "#941010"
	damage = -20 //heal
	damage_type = BRUTE
	nodamage = FALSE
	arcshot = TRUE

#define LIFESTEAL_FILTER "lifesteal_glow"

/atom/movable/screen/alert/status_effect/buff/lifestealuser
	name = "Lifesteal"
	desc = ""
	icon_state = "debuff"

/datum/status_effect/buff/lifestealuser
	id = "lifesteal"
	alert_type = /atom/movable/screen/alert/status_effect/buff/lifestealuser
	duration = 10 SECONDS
	var/outline_colour ="#ff0000ff"

/datum/status_effect/buff/lifestealuser/on_apply()
	. = ..()
	var/filter = owner.get_filter(LIFESTEAL_FILTER)
	if (!filter)
		owner.add_filter(LIFESTEAL_FILTER, 1, list("type" = "outline", "color" = outline_colour, "alpha" = 50, "size" = 1))

/datum/status_effect/buff/lifestealuser/tick()
	var/mob/living/user = owner
	for(var/mob/living/L in view(10, get_turf(user)))
		if(L == user)
			continue
		if(!(L.has_status_effect(/datum/status_effect/buff/lifestealtarget)))
			continue
		if(!(user.has_status_effect(/datum/status_effect/buff/lifestealuser)))
			return TRUE
		sleep(1)
		var/datum/beam/hbeam = user.Beam(L,icon_state="blood",time=9 SECONDS)
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(H.blood_volume >= (BLOOD_VOLUME_SURVIVE))
				H.blood_volume = H.blood_volume - 5
				user.blood_volume = user.blood_volume + 5
			else
				user.visible_message(span_warning("Severs the bloodlink from [L]!"))
				hbeam.End()
				return TRUE
		if(L.stat == DEAD || L.stat != CONSCIOUS || get_dist(L, user) > 10)
			L.remove_status_effect(/datum/status_effect/buff/lifestealtarget)
			hbeam.End()
			return FALSE
		L.adjustFireLoss(5)
		user.adjustFireLoss(-5)
		user.adjustBruteLoss(-5)
		user.apply_status_effect(/datum/status_effect/buff/healing/zizoblood)

/datum/status_effect/buff/lifestealuser/on_remove()
	. = ..()
	owner.remove_filter(LIFESTEAL_FILTER)

/datum/status_effect/buff/lifestealtarget
	id = "lifestealtarget"
	duration = -1
	effectedstats = list(STATKEY_CON = -2)
	alert_type = /atom/movable/screen/alert/status_effect/lifestealtarget

/atom/movable/screen/alert/status_effect/lifestealtarget
	name = "Lifesteal"
	icon_state = "debuff"

/datum/status_effect/buff/lifestealtarget/on_apply()
	. = ..()
	to_chat(owner, span_warning("Someone devouring my body! We need to move away from the source!"))

#undef LIFESTEAL_FILTER
