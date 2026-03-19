/datum/hag_boon/spell
	name = "Generic spell boon"
	var/spell_type = /obj/effect/proc_holder/spell/invoked/mark_target

/datum/hag_boon/spell/apply_boon_effect(mob/living/L)
	if(!L.mind || !spell_type)
		return

	// It's a little redundant to check it here too, but it's a failsafe.
	for(var/obj/effect/proc_holder/spell/S in L.mind.spell_list)
		if(S.type == spell_type)
			return

	var/obj/effect/proc_holder/spell/spell_inst = new spell_type()
	if(spell_inst.devotion_cost || spell_inst.miracle)
		// Miracles granted by hags don't care about devotion.
		spell_inst.devotion_cost = 0
		spell_inst.miracle = FALSE
	L.mind.AddSpell(spell_inst)
	to_chat(L, span_notice("A strange, flickering knowledge of <b>[spell_inst.name]</b> takes root in your mind."))
	return

/datum/hag_boon/spell/remove_boon_effect(mob/living/L)
	if(!L.mind)
		return

	var/obj/effect/proc_holder/spell/spell_inst
	for(var/obj/effect/proc_holder/spell/S in L.mind.spell_list)
		if(S.type == spell_type)
			spell_inst = S
			break

	if(spell_inst)
		L.mind.RemoveSpell(spell_inst)
		to_chat(L, span_warning("The knowledge of [spell_inst.name] withers and vanishes from your mind."))
	return

/datum/hag_boon/spell/spider_speak
	name = "Boon of Spider Speak"
	spell_type = /obj/effect/proc_holder/spell/invoked/spiderspeak
	points = 10
