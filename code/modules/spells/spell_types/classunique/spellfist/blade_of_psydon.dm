/datum/action/cooldown/spell/blade_of_psydon
	button_icon = 'icons/mob/actions/classuniquespells/spellfist.dmi'
	name = "Blade of Psydon"
	desc = "The manifestation of the higher concept of a blade itself. Said to be drawn upon from Noc's treasury of wisdom, each casting a poor facsimile of the perfect weapon They hold.\n\n\
	Centuries ago, the wise Yogi of Naledi travelled to the city of Tarichea, to learn their arts of Spellbladery, and perfected the art of arcyne weapon conjuration, to lend the fists of Psydon a blade when time calls for a cutting edge..."
	button_icon_state = "boundkatar"
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = FALSE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_SUMMON

	charge_required = FALSE
	cooldown_time = 1 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/drawmessage = "I imagine the perfect weapon, forged by arcyne knowledge, it's edge flawless. \
	I feel it in my mind's eye -- but it's just out of reach. I pull away it's shadow, a bad copy, and yet it is one of a great weapon nonetheless... "
	var/dropmessage = "Letting go, I watch the blade lose it's form, unable to stay stable without my energy rooting it to this world..."
	var/obj/item/melee/touch_attack/rogueweapon/bladeofpsydon/summoned_blade

/datum/action/cooldown/spell/blade_of_psydon/Destroy()
	if(summoned_blade && !QDELETED(summoned_blade))
		UnregisterSignal(summoned_blade, COMSIG_PARENT_QDELETING)
		QDEL_NULL(summoned_blade)
	return ..()

/datum/action/cooldown/spell/blade_of_psydon/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/user = owner
	if(!istype(user))
		return FALSE

	if(summoned_blade && !QDELETED(summoned_blade))
		qdel(summoned_blade)
		to_chat(user, span_notice("[dropmessage]"))
		return FALSE

	summoned_blade = new(user)
	summoned_blade.attached_spell = null
	RegisterSignal(summoned_blade, COMSIG_PARENT_QDELETING, PROC_REF(on_blade_destroyed))
	if(!user.put_in_hands(summoned_blade))
		qdel(summoned_blade)
		if(user.get_num_arms() <= 0)
			to_chat(user, span_warning("I don't have any usable hands!"))
		else
			to_chat(user, span_warning("My hands are full!"))
		return FALSE
	to_chat(user, span_notice("[drawmessage]"))
	return TRUE

/datum/action/cooldown/spell/blade_of_psydon/proc/on_blade_destroyed(datum/source)
	SIGNAL_HANDLER
	summoned_blade = null

/obj/item/melee/touch_attack/rogueweapon/bladeofpsydon
	name = "\improper arcyne katar"
	desc = "This blade throbs, translucent and iridiscent, blueish arcyne energies running through its translucent surface..."
	catchphrase = null
	icon = 'icons/mob/actions/roguespells.dmi'
	icon_state = "katar_bound"
	charges = 20
	force = 24
	possible_item_intents = list(/datum/intent/katar/cut, /datum/intent/katar/thrust)
	gripsprite = FALSE
	wlength = WLENGTH_SHORT
	w_class = WEIGHT_CLASS_HUGE
	parrysound = list('sound/combat/parry/bladed/bladedsmall (1).ogg','sound/combat/parry/bladed/bladedsmall (2).ogg','sound/combat/parry/bladed/bladedsmall (3).ogg')
	max_blade_int = 999
	max_integrity = 50
	swingsound = list('sound/combat/wooshes/bladed/wooshsmall (1).ogg','sound/combat/wooshes/bladed/wooshsmall (2).ogg','sound/combat/wooshes/bladed/wooshsmall (3).ogg')
	associated_skill = /datum/skill/combat/unarmed
	pickup_sound = 'sound/foley/equip/swordsmall2.ogg'
	wdefense = 0
	wbalance = WBALANCE_SWIFT
	can_parry = TRUE

/obj/item/melee/touch_attack/rogueweapon/bladeofpsydon/attack_self()
	qdel(src)
