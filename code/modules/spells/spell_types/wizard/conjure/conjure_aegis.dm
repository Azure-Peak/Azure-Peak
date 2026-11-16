#define AEGIS_NPC_RECAST_DISTANCE 5
#define AEGIS_NPC_RECAST_SCORE 80

/datum/action/cooldown/spell/conjure_aegis
	name = "Arcyne Aegis"
	desc = "Project a shield of arcyne force into your offhand. It scales to Arcyne Armament rather than Shields. It stays until dispelled, destroyed, or you are parted from it for too long. Cast again with a free offhand to renew it."
	button_icon = 'icons/mob/actions/mage_conjure.dmi'
	button_icon_state = "conjure_aegis"
	sound = 'sound/magic/whiteflame.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_MEDIUM

	click_to_activate = FALSE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_ENERGY
	primary_resource_cost = 100

	invocations = list("Scutum Congrego!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = 5 SECONDS
	charge_swingdelay_type = SWINGDELAY_PENALTY
	charge_slowdown = CHARGING_SLOWDOWN_HEAVY
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 5 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	point_cost = 2
	spell_impact_intensity = SPELL_IMPACT_NONE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/obj/item/rogueweapon/shield/arcyne_aegis/conjured_aegis
	var/aegis_type = /obj/item/rogueweapon/shield/arcyne_aegis

/datum/action/cooldown/spell/conjure_aegis/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE
	var/obj/item/offhand = H.get_inactive_held_item()
	if(offhand && offhand != conjured_aegis)
		to_chat(H, span_warning("I need my offhand free to project the Aegis!"))
		return FALSE
	if(conjured_aegis && !QDELETED(conjured_aegis))
		conjured_aegis.visible_message(span_warning("[conjured_aegis] shimmers and fades away!"))
		qdel(conjured_aegis)
	if(!manifest_aegis(H))
		to_chat(H, span_warning("I fail to conjure the Aegis in my offhand."))
		return FALSE
	H.visible_message(span_notice("[H] projects a shimmering arcyne shield!"))
	return TRUE

/datum/action/cooldown/spell/conjure_aegis/proc/manifest_aegis(mob/living/carbon/human/H)
	var/obj/item/rogueweapon/shield/arcyne_aegis/S = new aegis_type(H.drop_location())
	S.AddComponent(/datum/component/conjured_item, GLOW_COLOR_ARCANE, FALSE, H, src)
	if(!H.put_in_inactive_hand(S))
		qdel(S)
		return FALSE
	conjured_aegis = S
	return TRUE

/datum/action/cooldown/spell/conjure_aegis/npc_on_spawn(mob/living/carbon/human/H)
	if(!H.get_active_held_item() && H.get_inactive_held_item())
		H.swap_hand()
	if(!H.get_inactive_held_item())
		manifest_aegis(H)

/datum/action/cooldown/spell/conjure_aegis/before_cast(atom/cast_on)
	if(npc_controlled() && ishuman(owner))
		var/mob/living/carbon/human/H = owner
		var/obj/item/main = H.get_active_held_item()
		if(main?.wielded)
			main.ungrip(H, FALSE)
	return ..()

/datum/action/cooldown/spell/conjure_aegis/can_use(atom/target)
	return isliving(owner)

/datum/action/cooldown/spell/conjure_aegis/npc_cast_target(atom/target)
	return owner

/datum/action/cooldown/spell/conjure_aegis/npc_is_big_spell()
	return FALSE

/datum/action/cooldown/spell/conjure_aegis/npc_use_chance(atom/target)
	var/mob/living/carbon/human/H = owner
	if(!istype(H) || H.get_inactive_held_item())
		return 0
	if(conjured_aegis && !QDELETED(conjured_aegis) && H.is_holding(conjured_aegis))
		return 0
	if(target && get_dist(H, target) < AEGIS_NPC_RECAST_DISTANCE)
		return 0
	return AEGIS_NPC_RECAST_SCORE

#undef AEGIS_NPC_RECAST_DISTANCE
#undef AEGIS_NPC_RECAST_SCORE

/datum/action/cooldown/spell/conjure_aegis/Destroy()
	if(conjured_aegis && !QDELETED(conjured_aegis))
		qdel(conjured_aegis)
	conjured_aegis = null
	return ..()

/obj/item/rogueweapon/shield/arcyne_aegis
	name = "arcyne aegis"
	desc = "A rare hunk of arcyne energy projected in front of the caster. Slower and more deliberate movement by blades and melee weapons easily pierce through to the squishy Magi behind."
	icon = 'icons/roguetown/weapons/prismatic_weapons64.dmi'
	icon_state = "moonlight_shield"
	pixel_x = -16
	bigboy = TRUE
	force = 15
	wdefense = 10
	coverage = 30
	max_integrity = 220
	special = null
	unenchantable = TRUE
	sellprice = 0
	static_price = TRUE
	parrysound = list('sound/combat/parry/shield/magicshield (1).ogg', 'sound/combat/parry/shield/magicshield (2).ogg', 'sound/combat/parry/shield/magicshield (3).ogg')
	associated_skill = /datum/skill/combat/arcyne

/obj/item/rogueweapon/shield/arcyne_aegis/obj_break(damage_flag)
	. = ..()
	if(!QDELETED(src))
		visible_message(span_warning("[src] shatters!"))
		playsound(get_turf(src), 'sound/magic/magic_nulled.ogg', 80)
		qdel(src)
