/datum/action/cooldown/spell/telegraphed_strike/mob_ability/ground/hurled_rock/stone_throw
	name = "Stone Throw"
	desc = "Rips a stone from the earth and hurls it at a distant foe."
	button_icon_state = "stone_throw"
	cooldown_time = 20 SECONDS
	npc_min_range = 2
	npc_max_range = 7
	cast_range = 7
	use_chance = 45
	required_zones = list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)

	windup_time = TELEGRAPH_AREA_DENIAL
	telegraph_sound = list('sound/items/dig_shovel.ogg')
	recovery_time = 5 SECONDS
	recovery_slowdown = CHARGING_SLOWDOWN_MEDIUM
	recovery_status = /datum/status_effect/debuff/vulnerable

	blast_radius = 1
	damage = 40
	strike_sound = 'sound/combat/shieldraise.ogg'
	hit_sound = list('sound/combat/hits/smashlimb (1).ogg','sound/combat/hits/smashlimb (2).ogg','sound/combat/hits/smashlimb (3).ogg')
	impact_sound = list('sound/foley/smash_rock.ogg')
	rock_type = /obj/effect/temp_visual/stone_throw

/obj/effect/temp_visual/stone_throw
	icon = 'icons/roguetown/items/natural.dmi'
	icon_state = "stonebig1"
	name = "stone"
	desc = "You should scram..."
	layer = FLY_LAYER
	plane = GAME_PLANE_UPPER
	randomdir = FALSE
