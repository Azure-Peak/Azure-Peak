
/datum/action/cooldown/spell/tame_undead
	name = "Tame Undead"
	desc = "Oftentymes, husks and shamblers walk aimlessly - uncertain of their future. They need not look further, any longer.\nRequires the target to be within four tiles. Works on undead animals, too."
	background_icon = 'icons/mob/actions/zizomiracles.dmi'
	button_icon = 'icons/mob/actions/zizomiracles.dmi'
	button_icon_state = "deadite_tame"
	cast_range = 4
	primary_resource_cost = 40
	primary_resource_type = SPELL_COST_STAMINA
	cooldown_time = 60 SECONDS
	charge_required = TRUE
	charge_time = 5 SECONDS
	charge_slowdown = 1
	associated_skill = /datum/skill/magic/arcane
	self_cast_possible = FALSE
	zizo_spell = TRUE

/datum/action/cooldown/spell/tame_undead/is_valid_target(atom/cast_on)
	return isliving(cast_on)

/datum/action/cooldown/spell/tame_undead/cast(atom/cast_on)
	. = ..()

	var/mob/living/target = cast_on

	if(!(target.mob_biotypes & MOB_UNDEAD))
		to_chat(owner, span_warning("[target]'s soul is not Hers, yet. I cannot do anything."))
		reset_spell_cooldown()
		return FALSE

	if(target.mind)
		to_chat(owner, span_warning("[target]'s mind resists your goadings. It will not do."))
		reset_spell_cooldown()
		return FALSE

	target.faction |= list("cabal", "[owner.mind.current.real_name]_faction")
	target.visible_message(span_notice("[target] turns its head to pay heed to [owner]!"))
	if(!target.ai_controller)
		target.ai_controller = /datum/ai_controller/undead
		target.InitializeAIController()
		if(issimple(target))
			var/mob/living/simple_animal/simple_target = target
			simple_target.tamed()

	return TRUE
