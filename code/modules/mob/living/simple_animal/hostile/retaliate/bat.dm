/mob/living/simple_animal/hostile/retaliate/bat
	name = "bat"
	desc = ""
	icon_state = "bat"
	icon_living = "bat"
	icon_dead = "bat_dead"
	icon_gib = "bat_dead"
	turns_per_move = 1
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "flails at"
	response_disarm_simple = "flail at"
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	speak_chance = 0
	maxHealth = 50
	health = 50
	see_in_dark = 10
	harm_intent_damage = 6
	melee_damage_lower = 6
	melee_damage_upper = 5
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 1)
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
	faction = list(FACTION_HOSTILE)
	attack_sound = 'sound/blank.ogg'
	obj_damage = 0
	environment_smash = ENVIRONMENT_SMASH_NONE
	ventcrawler = VENTCRAWLER_ALWAYS
	mob_size = MOB_SIZE_TINY
	movement_type = FLYING
	speak_emote = list("squeaks")
	base_intents = list(/datum/intent/bite)
	sight = (SEE_TURFS|SEE_MOBS|SEE_OBJS|SEE_SELF)
	see_in_dark = 8
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
	STASTR = 1 // You are not charging or bumping anyone down
	STACON = 1 // No charging!

	fly_time = 5 //5 ticks because vampire bats are agile

	var/max_co2 = 0 //to be removed once metastation map no longer use those for Sgt Araneus
	var/min_oxy = 0
	var/max_tox = 0


	//Space bats need no air to fly in.
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0

/mob/living/simple_animal/hostile/retaliate/bat/Initialize()
	. = ..()
	add_verb(src, list(/mob/living/simple_animal/proc/fly_up,
	/mob/living/simple_animal/proc/fly_down)) 

/mob/living/simple_animal/hostile/retaliate/bat/crow
	name = "zad"
	desc = ""
	icon = 'icons/roguetown/mob/monster/crow.dmi'
	icon_state = "crow_flying"
	icon_living = "crow_flying"
	icon_dead = "crow1"
	icon_gib = "crow1"
	speak_emote = list("caws")
	base_intents = list(/datum/intent/unarmed/help)
	harm_intent_damage = 0
	melee_damage_lower = 0
	melee_damage_upper = 0
	remains_type = /obj/effect/decal/remains/crow
	fly_time = 3 SECONDS // slowing down crow for witches
	sight = 0
	/// Whether the zad is perched (stationary sprite, cannot move) rather than flying.
	var/sitting = FALSE

/mob/living/simple_animal/hostile/retaliate/bat/crow/Initialize()
	. = ..()
	add_verb(src, list(/mob/living/simple_animal/hostile/retaliate/bat/crow/proc/change_stance,
	/mob/living/simple_animal/hostile/retaliate/bat/crow/proc/emote_caw))

/mob/living/simple_animal/hostile/retaliate/bat/crow/proc/change_stance()
	set category = "RoleUnique.Winged Form"
	set name = "Change Stance"
	sitting = !sitting
	update_icon()
	//Hack to make sprite update after hitting the verb
	setDir(EAST)
	setDir(SOUTH)

/mob/living/simple_animal/hostile/retaliate/bat/crow/update_icon_state()
	icon_state = sitting ? "crow" : "crow_flying"

/mob/living/simple_animal/hostile/retaliate/bat/crow/Move()
	if(sitting)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/retaliate/bat/crow/proc/emote_caw()
	set category = "RoleUnique.Winged Form"
	set name = "Caw"
	emote("caw", intentional = TRUE, animal = TRUE)

/mob/living/simple_animal/hostile/retaliate/bat/crow/get_sound(input)
	if(input == "caw")
		return pick('sound/vo/mobs/bird/CROW_01.ogg', 'sound/vo/mobs/bird/CROW_02.ogg', 'sound/vo/mobs/bird/CROW_03.ogg')

/obj/effect/decal/remains/crow
	name = "zad remains"
	desc = "Nevermore..."
	gender = PLURAL
	icon_state = "crow1"
	icon = 'icons/roguetown/mob/monster/crow.dmi'
