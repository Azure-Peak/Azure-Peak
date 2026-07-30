//Subtype of wolf, but non-hostile until attacked instead of default hostile.
/mob/living/simple_animal/hostile/retaliate/rogue/fox
	icon = 'icons/roguetown/mob/monster/fox.dmi'
	name = "venard"
	desc = "A majestic beast of Dendor's realm, hopping through the local fauna."
	icon_state = "fox"
	icon_living = "fox"
	icon_dead = "fox_dead"
	gender = MALE
	emote_hear = null
	emote_see = null
	speak_chance = 1
	turns_per_move = 3
	see_in_dark = 6
	move_to_delay = 3
	base_intents = list(/datum/intent/simple/bite/volf)	//Same as volf, simplicity is key
	aggressive = 1
	threat_point = THREAT_TRASH
	ambush_faction = "wildlife"
	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 1, /obj/item/alch/viscera = 1, /obj/item/natural/bone = 3)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 2,
						/obj/item/natural/hide = 1,
						/obj/item/alch/sinew = 2,
						/obj/item/alch/bone = 1,
						/obj/item/alch/viscera = 1,
						/obj/item/natural/fur/fox = 1,
						/obj/item/natural/bone = 4)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 3,
						/obj/item/natural/hide = 2,
						/obj/item/alch/sinew = 2,
						/obj/item/alch/bone = 1,
						/obj/item/alch/viscera = 1,
						/obj/item/natural/fur/fox = 2,
						/obj/item/natural/bone = 4)
	head_butcher = /obj/item/natural/head/fox
	faction = list(FACTION_WOLFS, FACTION_ZOMBIE)
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	remains_type = /obj/effect/decal/remains/fox
	health = FOX_HEALTH
	maxHealth = FOX_HEALTH		//Wolf is 120
	melee_damage_lower = 10		//Wolf is 19
	melee_damage_upper = 20		//Wolf is 29
	vision_range = 7
	aggro_vision_range = 9
	environment_smash = ENVIRONMENT_SMASH_NONE
	retreat_distance = 0
	minimum_distance = 0
	milkies = FALSE
	food_type = list(/obj/item/reagent_containers/food/snacks,
					//obj/item/bodypart,
					//obj/item/organ,
					/obj/item/natural/bone,
					/obj/item/natural/hide)
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	pooptype = null
	STACON = 6
	STASTR = 5
	STASPD = 13	//Fast
	ai_controller = null
	simple_detect_bonus = 20
	deaggroprob = 0
	defprob = 40
	del_on_deaggro = 44 SECONDS
	retreat_health = 0.3
	food = 0
	attack_sound = list('sound/vo/mobs/vw/attack (1).ogg','sound/vo/mobs/vw/attack (2).ogg','sound/vo/mobs/vw/attack (3).ogg','sound/vo/mobs/vw/attack (4).ogg')
	dodgetime = 30
	aggressive = 1
	eat_forever = TRUE

//new ai, old ai off
	AIStatus = AI_OFF
	can_have_ai = FALSE
	ai_controller = /datum/ai_controller/volf
	melee_cooldown = WOLF_ATTACK_SPEED

/mob/living/simple_animal/hostile/retaliate/rogue/fox/Initialize()
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)

//Mapped tame foxes (aggressive = 0, e.g. Mimi) predate the volf controller, which never reads
//that var. Keep the Emerald Summit behavior: docile, but fights back when struck.
/mob/living/simple_animal/hostile/retaliate/rogue/fox/InitializeAIController()
	if(!aggressive)
		tame = TRUE	//enables the retaliate-parent petting/friends handling
		ai_controller = /datum/ai_controller/generic/pet_retaliate
		AddElement(/datum/element/ai_retaliate)
	return ..()

//Two gaps the parent chain leaves for tame foxes: relay_attackers only registers punches from
//attackers in cmode, and the parent's pet-to-calm only clears the legacy enemies list, not the
//AI controller's retaliate list.
///The Guild of Craft raised her — its members are always her friends.
/mob/living/simple_animal/hostile/retaliate/rogue/fox/proc/is_guild_family(mob/living/carbon/human/M)
	return M.mind?.assigned_role in list("Guildmaster", "Guildsman")

/mob/living/simple_animal/hostile/retaliate/rogue/fox/attack_hand(mob/living/carbon/human/M)
	var/is_guild = is_guild_family(M)
	var/was_friend = (M in friends)
	var/legacy_announced = length(enemies)	//the retaliate parent only says "calms down" if its own enemies list was filled
	if(!aggressive && M.used_intent.type == INTENT_HELP && !was_friend && is_guild)
		friends += M
		was_friend = TRUE
	. = ..()
	if(aggressive)
		return
	switch(M.used_intent.type)
		if(INTENT_HARM)
			if(!HAS_TRAIT(M, TRAIT_PACIFISM))
				ai_controller?.insert_blackboard_key_lazylist(BB_BASIC_MOB_RETALIATE_LIST, M)
		if(INTENT_HELP)
			if(stat != CONSCIOUS)
				return
			//The retaliate parent befriends anyone who pets her while calm; strangers must earn it with food instead.
			if(!was_friend && !is_guild && (M in friends))
				friends -= M
			if(LAZYLEN(ai_controller?.blackboard[BB_BASIC_MOB_RETALIATE_LIST]))
				if(!(M in friends))	//the parent already told them she doesn't react
					return
				ai_controller.clear_blackboard_key(BB_BASIC_MOB_RETALIATE_LIST)
				ai_controller.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET)
				ai_controller.CancelActions()
				LoseTarget()	//the new-AI attack sets the legacy target var too — it drives the "is currently targeting you!" examine line
				if(!legacy_announced)
					visible_message(span_notice("[src] calms down."))
			if(M in friends)
				new /obj/effect/temp_visual/heart(loc)

//Feeding her a sausage is how outsiders win her over.
/mob/living/simple_animal/hostile/retaliate/rogue/fox/attackby(obj/item/O, mob/living/user, params)
	var/offering_treat = !aggressive && stat == CONSCIOUS && istype(O, /obj/item/reagent_containers/food/snacks/rogue/meat/sausage)
	. = ..()
	if(!offering_treat || !QDELETED(O))	//QDELETED means she actually ate it
		return
	if(ishuman(user) && !(user in friends))
		friends += user
		visible_message(span_notice("[src] happily gobbles up the treat and nuzzles [user]."), null, null, COMBAT_MESSAGE_RANGE)
	new /obj/effect/temp_visual/heart(loc)

/obj/effect/decal/remains/fox
	name = "remains"
	desc = "A wily fox perished here. Never is a beast spry or clever enough, in the end."
	gender = PLURAL
	icon_state = "bones"
	icon = 'icons/roguetown/mob/monster/fox.dmi'

/mob/living/simple_animal/hostile/retaliate/rogue/fox/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/vw/aggro (1).ogg','sound/vo/mobs/vw/aggro (2).ogg')
		if("pain")
			return pick('sound/vo/mobs/vw/pain (1).ogg','sound/vo/mobs/vw/pain (2).ogg','sound/vo/mobs/vw/pain (3).ogg')
		if("death")
			return pick('sound/vo/mobs/vw/death (1).ogg','sound/vo/mobs/vw/death (2).ogg','sound/vo/mobs/vw/death (3).ogg','sound/vo/mobs/vw/death (4).ogg','sound/vo/mobs/vw/death (5).ogg')
		if("idle")
			return pick('sound/vo/mobs/vw/idle (1).ogg','sound/vo/mobs/vw/idle (2).ogg','sound/vo/mobs/vw/idle (3).ogg','sound/vo/mobs/vw/idle (4).ogg')
		if("cidle")
			return pick('sound/vo/mobs/vw/bark (1).ogg','sound/vo/mobs/vw/bark (2).ogg','sound/vo/mobs/vw/bark (3).ogg','sound/vo/mobs/vw/bark (4).ogg','sound/vo/mobs/vw/bark (5).ogg','sound/vo/mobs/vw/bark (6).ogg','sound/vo/mobs/vw/bark (7).ogg')

/mob/living/simple_animal/hostile/retaliate/rogue/fox/taunted(mob/user)
	if(aggressive == FALSE)
		return
	else
		emote("aggro")
		Retaliate()
		GiveTarget(user)
		return

/mob/living/simple_animal/hostile/retaliate/rogue/fox/Life()
	..()
	if(aggressive == FALSE)
		return
	else
		if(pulledby)
			Retaliate()
			GiveTarget(pulledby)


/mob/living/simple_animal/hostile/retaliate/rogue/fox/simple_limb_hit(zone)
	if(!zone)
		return ""
	switch(zone)
		if(BODY_ZONE_PRECISE_R_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_L_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_NOSE)
			return "nose"
		if(BODY_ZONE_PRECISE_MOUTH)
			return "mouth"
		if(BODY_ZONE_PRECISE_SKULL)
			return "head"
		if(BODY_ZONE_PRECISE_EARS)
			return "head"
		if(BODY_ZONE_PRECISE_NECK)
			return "neck"
		if(BODY_ZONE_PRECISE_L_HAND)
			return "foreleg"
		if(BODY_ZONE_PRECISE_R_HAND)
			return "foreleg"
		if(BODY_ZONE_PRECISE_L_FOOT)
			return "leg"
		if(BODY_ZONE_PRECISE_R_FOOT)
			return "leg"
		if(BODY_ZONE_PRECISE_STOMACH)
			return "stomach"
		if(BODY_ZONE_PRECISE_GROIN)
			return "tail"
		if(BODY_ZONE_HEAD)
			return "head"
		if(BODY_ZONE_R_LEG)
			return "leg"
		if(BODY_ZONE_L_LEG)
			return "leg"
		if(BODY_ZONE_R_ARM)
			return "foreleg"
		if(BODY_ZONE_L_ARM)
			return "foreleg"
	return ..()

/mob/living/simple_animal/hostile/retaliate/rogue/fox/guildpet
	name = "Mimi the Fox"
	desc = "An adorable creechur adopted by the Guild of Craft as their mascot."
	density = 0 // You can walk through them
	aggressive = FALSE
	ai_controller = /datum/ai_controller/generic

/mob/living/simple_animal/hostile/retaliate/rogue/fox/guildpet/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/vw/aggro (1).ogg','sound/vo/mobs/vw/aggro (2).ogg')
		if("pain")
			return pick('sound/vo/mobs/vw/pain (1).ogg','sound/vo/mobs/vw/pain (2).ogg','sound/vo/mobs/vw/pain (3).ogg')
		if("death")
			return pick('sound/vo/mobs/vw/death (1).ogg','sound/vo/mobs/vw/death (2).ogg','sound/vo/mobs/vw/death (3).ogg','sound/vo/mobs/vw/death (4).ogg','sound/vo/mobs/vw/death (5).ogg')
		if("idle")
			return pick('sound/vo/mobs/venard/fox1.ogg','sound/vo/mobs/venard/fox2.ogg','sound/vo/mobs/venard/fox3.ogg','sound/vo/mobs/venard/fox4.ogg','sound/vo/mobs/venard/fox5.ogg','sound/vo/mobs/venard/fox6.ogg','sound/vo/mobs/venard/fox7.ogg','sound/vo/mobs/venard/fox8.ogg','sound/vo/mobs/venard/fox9.ogg','sound/vo/mobs/venard/fox10.ogg','sound/vo/mobs/venard/fox11.ogg','sound/vo/mobs/venard/fox12.ogg','sound/vo/mobs/venard/fox13.ogg')
		if("cidle")
			return pick('sound/vo/mobs/vw/bark (1).ogg','sound/vo/mobs/vw/bark (2).ogg','sound/vo/mobs/vw/bark (3).ogg','sound/vo/mobs/vw/bark (4).ogg','sound/vo/mobs/vw/bark (5).ogg','sound/vo/mobs/vw/bark (6).ogg','sound/vo/mobs/vw/bark (7).ogg')

/mob/living/simple_animal/hostile/retaliate/rogue/fox/death(gibbed)
	. = ..()
	if(!QDELETED(src) && !gibbed)
		src.AddComponent(/datum/component/deadite_animal_reanimation)
