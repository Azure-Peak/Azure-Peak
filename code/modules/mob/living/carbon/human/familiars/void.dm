/mob/living/carbon/human/species/familiar/void
	name = "Void Drakeling"
	desc = "A small draconic being, gazing inquisitively at the world around it. It pulses with an unfamiliar power." // we don't put all the details here bcs this can be seen by nonmages
	summoning_emote = "The drakeling opens its eyes... they gleam with a voracious hunger!" // not an actual summoning emote since that's handled in the aurafarm session
	icon_state = "drakeling"
	race = /datum/species/familiar/void
	speak_emote = list("growls","murmurs")
	tutorial_message = span_notice("You are a new being, weak and without any notable traits. This will not do! Summon and consume weak (first-Circle) planar beings to grow your powers. One from each plane will suffice, for now. Add their natures to your own, and grow strong.")
	var/list/essences_consumed = list()
	var/list/beam_parts = list()
	inherent_spell = list(/datum/action/cooldown/spell/consume)
	valid_healing_items = list(/obj/item/magic/fae, /obj/item/magic/elemental, /obj/item/magic/infernal) // hungy
	planar_origin = "void"
	voiceclips = list('sound/vo/mobs/wwolf/idle (1).ogg', 'sound/vo/mobs/vdragon/drgnroar.ogg')
	voice_desc = "potent"
	voice_desc_prefix = CUSTOM_PREFIX_HAS_A
	trait_desc = "arcyne"
	trait_desc_prefix = CUSTOM_PREFIX_HAS_AN
	stature_desc = "drake"
	stature_desc_prefix = CUSTOM_PREFIX_HAS_A

/datum/species/familiar/void
	name = "Void Drakeling"
	id = "void_drakeling"
	origin = "The Void"
	origin_default = /datum/virtue/origin/unselectable/void
	blood_color = "#0c0c3f" // void blood

/mob/living/carbon/human/species/familiar/void/is_aligned_leyline(obj/structure/leyline/ley)
	return !istype(ley, /obj/structure/leyline/tamed)

/mob/living/carbon/human/species/familiar/void/fire_act(added, maxstacks)
	if(essences_consumed.Find("infernal"))
		return FALSE
	. = ..()

/mob/living/carbon/human/species/familiar/void/examine(mob/user)
	if(istype(user, /mob/living/carbon/human/species/familiar) || (user.mind.mage_aspect_config && user.mind.mage_aspect_config["major"]))
		desc = span_greentext("\[Arcyna: Success\]") + ": A fragment of a void aberrant's power, torn away and fashioned into a familiar; its eyes shine with a voracious hunger. What work of hubris has been wrought, here? Who would—or even could—create such a thing?"
	var/list/ret = ..()
	desc = initial(desc)
	return ret

// not really 'villain' but, yk
/mob/living/carbon/human/species/familiar/void/get_villain_text(mob/examiner)
	if(istype(examiner, /mob/living/carbon/human/species/familiar) || (examiner.mind.mage_aspect_config && examiner.mind.mage_aspect_config["major"]))
		return span_userdanger("AN ABERRANT...?")
	. = ..()

/mob/living/carbon/human/species/familiar/void/proc/grant_essence(type)
	switch(type)
		if("fae") // faerie movement, inherits spell
			to_chat(src, span_notice("As you absorb the essence of the faewyld, you take on some of its nature. You can now fly, and you've gained the ability to cloak your form and retrieve objects at a distance."))
			src.pass_flags = PASSTABLE | PASSMOB
			src.movement_type = FLYING
			TryAddFlight()
			src.mind.AddSpell(new /datum/action/cooldown/spell/projectile/fetch/fae/void)
			src.mind.AddSpell(new /datum/action/cooldown/spell/invisibility/fae)
		if("infernal") // nerfed aberrant beam, fire res
			to_chat(src, span_notice("As you absorb the essence of the hells, you take on some of their nature. Flames will harm you no more, and you can now manifest an aberrant beam to blast your foes."))
			src.mind.AddSpell(new /datum/action/cooldown/spell/void_beam/familiar)
		if("elemental") // stat buff, inherits spell
			to_chat(src, span_notice("As you absorb the essence of the depths, you take on some of its nature. Your body grows sturdier, and you can now tear stones from the earth itself, or reshape your form."))
			src.STACON += 5 // = 10 con total
			src.mind.AddSpell(new /datum/action/cooldown/spell/magicians_stone/elemental/void)
			src.mind.AddSpell(new /datum/action/cooldown/spell/earthen_forge/void)

/mob/living/carbon/human/species/familiar/void/revive(full_heal, admin_revive)
	if(..()) // successful revive
		if(essences_consumed.Find("fae")) // flight is lost on death
			movement_type = FLYING
		. = TRUE
