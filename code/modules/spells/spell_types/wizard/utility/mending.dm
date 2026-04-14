/datum/action/cooldown/spell/mending
	button_icon = 'icons/mob/actions/roguespells.dmi'
	name = "Mending"
	desc = "Uses arcyne energy to mend an item progressively, after initial focusing any movement will break concentration and force the spell into cooldown."
	button_icon_state = "mending"
	sound = 'sound/magic/whiteflame.ogg'
	spell_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = TRUE
	self_cast_possible = FALSE
	cast_range = SPELL_RANGE_GROUND
	charge_required = FALSE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CANTRIP

	invocations = list("Reficio")
	invocation_type = INVOCATION_SHOUT

	cooldown_time = 12 SECONDS // the wait time is now mostly on the repairing process, too long with the 4 seconds concentration to properly make any repairs in the middle of combat

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE

	point_cost = 2

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/repair_percent = 0.08

/datum/action/cooldown/spell/mending/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	if(!istype(cast_on, /obj/item))
		if(owner)
			to_chat(owner, span_warning("I need to target an item!"))
		return FALSE
	var/obj/item/I = cast_on
	if(!I.anvilrepair && !I.sewrepair)
		if(owner)
			to_chat(owner, span_warning("Not even magic can mend this item!"))
		return FALSE
	if(I.obj_integrity >= I.max_integrity && I.body_parts_covered_dynamic == I.body_parts_covered)
		if(owner)
			to_chat(owner, span_info("[I] appears to be in perfect condition."))
		return FALSE
	return TRUE

/datum/action/cooldown/spell/mending/cast(atom/cast_on)
    . = ..()
    var/mob/living/user = owner
    if(!istype(user))
        return FALSE

    var/obj/item/I = cast_on

    user.visible_message(
        span_warning("[user] begins to concentrate on [I]!"),
        span_notice("I begin to concentrate on [I]..")
    )
    if(do_after(user, 2 SECONDS, TRUE, I, TRUE))
        for(var/i = 1, i <= 20, i++)
            if(do_after(user, 1.6 SECONDS, TRUE, I, TRUE))
                repair_percent = initial(repair_percent)
                repair_percent *= I.max_integrity

                I.obj_integrity = min(I.obj_integrity + repair_percent, I.max_integrity)
                user.visible_message(span_info("[I] glows in a faint mending light."))
                playsound(I, 'sound/magic/mending.ogg', 20, TRUE, -2)

                if(I.obj_integrity >= I.max_integrity)
                    if(I.obj_broken)
                        I.obj_fix()
                    if(I.body_parts_covered_dynamic != I.body_parts_covered)
                        I.repair_coverage()
                        to_chat(user, span_info("[I]'s shorn layers mend together, completely."))
                    break
            else
                break
        return TRUE
    else
        to_chat(user, span_warning("My concentration breaks! I could not repair [I]."))
    return FALSE


/datum/action/cooldown/spell/mending/lesser
	name = "Guided Mending"
	repair_percent = 0.05
	cooldown_time = 20 SECONDS // one full repair cycle would takes around 27 seconds and each repairs seperated with 20 seconds of cooldown
	point_cost = 1
