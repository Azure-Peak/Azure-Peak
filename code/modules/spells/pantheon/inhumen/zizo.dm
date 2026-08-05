/*//////////////
// T0: Enochian
A cantrip miracle that lets you delve towards Engineering, Sorcery and (evil) Medicine by using your Holy skill level.

Main ingredients are going to be blood, organs, bones for catalysts, and normal run-up-the-mill ingredients.

This miracle will interact with Artificer tools, enhancing them, but clearly showing that you're not doing this
'naturally' anymore. It will be conspicuous when you "improve" something (or someone).

Similar to Matthios, the big point of this is to help reduce clutter on the map, so it'll work around deleting/recycling
corpses and discarded junk*/

/datum/action/cooldown/spell/enochian
	name = "Enochian"
	desc = "A primordial arcyne language used by the Cabal to shape and command the immaterial forces of Mana in ways that modern arcyne can't come close to replicate. When invoked as a profane miracle, even a simple utterance can weave ephemeral tools of Progress into existence, answering the speaker's need.<br><br>It is said that Zizo has oft made use of this before her Ascension, and modern Arcyne is but a bastardization of such."
	button_icon = 'icons/mob/actions/zizomiracles.dmi'
	button_icon_state = "churn_living"
	associated_skill = /datum/skill/magic/holy
	click_to_activate = FALSE
	self_cast_possible = TRUE
	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CANTRIP
	charge_required = FALSE
	cooldown_time = 10 SECONDS
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z
	var/list/options = list(
		"Corrupted Chalk" = list(
			path = /obj/item/chalk/zizo,
			m_cooldown = 0, // Only one available, if you lose it, tough luck.
			m_rank = SKILL_LEVEL_NONE, // This is a normal arcyne chalk, just spooky and red glowy. Requires arcyne trait to use, as you'd expect.
			m_devotion = 100,
			category = "Sepulchral Relics",
			lines = list("Ol sonf vorsg, hoath zir.","Madriax soba-lonshi od zorge.","Faxs to faxs-sobol athan."),
		),
		"Profane Rite Chalk" = list(
			path = /obj/item/ritechalk_zizo,
			m_cooldown = 0, // Ditto.
			m_rank = SKILL_LEVEL_NONE, // This is a special chalk that lets you create runes without TRAIT_RITUALIST. In less than Expert+ hands, it's just a grafitti tool, except for the melding ritual.
			m_devotion = 100,
			category = "Sepulchral Relics",
			lines = list("Ol sonf vorsg, hoath zir.","Madriax soba-lonshi od zorge.","Faxs to faxs-sobol athan.","Velor ixan thrae-zho vel.","Korvath en'zul miraxis thren.","Thren val'kora ix ven.","Zai'ul phoros vekh tor.","Morath xi'en thul var.","Vael kor zin'athra vel.","Thul'kor imnaza vekh dor.","En'ra zolth ix venak.","Zhorath kal'mir vex ul.","Ul ix zizo vel'kra.","Sothra vel ixan thul.","Zor'en valix thrae kor.","Vel'zan morath ix ul.","Threx ul ven'kai zhor.","Ix zol ven'ra thul kor.","Vorath ixen kal zor.","Zizo ul thren val'ix.")
		),
		"Profane Riteblade" = list(
			path = /obj/item/rogueweapon/huntingknife/idagger/zizo,
			m_cooldown = 0, // Ditto, but this might be changed into a touch_attack in the future.
			m_rank = SKILL_LEVEL_JOURNEYMAN, // It's just a weaker iron dagger that will probably have more to it when I figure out exactly what it should get.
			m_devotion = 50,
			category = "Rite Instruments",
			lines = list("Ol sonf vorsg, hoath zir.","Madriax soba-lonshi od zorge.","Faxs to faxs-sobol athan.","Velor ixan thrae-zho vel.","Korvath en'zul miraxis thren.","Thren val'kora ix ven.","Zai'ul phoros vekh tor.","Morath xi'en thul var.","Vael kor zin'athra vel.","Thul'kor imnaza vekh dor.","En'ra zolth ix venak.","Zhorath kal'mir vex ul.","Ul ix zizo vel'kra.","Sothra vel ixan thul.","Zor'en valix thrae kor.","Vel'zan morath ix ul.","Threx ul ven'kai zhor.","Ix zol ven'ra thul kor.","Vorath ixen kal zor.","Zizo ul thren val'ix.")
		),
		"Enochian Artificer's Bag" = list(
			path = /obj/item/storage/magebag/zizo,
			m_cooldown = 0, // And ditto.
			m_rank = SKILL_LEVEL_NONE, // Spooky glowy Mage's Bag for Artificer/Alchemy ingredients. Nothing out of the world here.
			m_devotion = 50,
			category = "Sepulchral Relics",
			lines = list("Ol sonf vorsg, hoath zir.","Madriax soba-lonshi od zorge.","Faxs to faxs-sobol athan.","Velor ixan thrae-zho vel.","Korvath en'zul miraxis thren.","Thren val'kora ix ven.","Zai'ul phoros vekh tor.","Morath xi'en thul var.","Vael kor zin'athra vel.","Thul'kor imnaza vekh dor.","En'ra zolth ix venak.","Zhorath kal'mir vex ul.","Ul ix zizo vel'kra.","Sothra vel ixan thul.","Zor'en valix thrae kor.","Vel'zan morath ix ul.","Threx ul ven'kai zhor.","Ix zol ven'ra thul kor.","Vorath ixen kal zor.","Zizo ul thren val'ix.")
		),
		"Enochian Grasp" = list(
			path = /obj/item/melee/touch_attack/enochian_force,
			m_cooldown = 3 MINUTES, // Cooldown should be higher to refresh than waiting it out with it on your hand.
			m_rank = SKILL_LEVEL_EXPERT, // The main purpose of this is to help move corpses remotely without having to go through the drag game. I added four intents to it to emphasize that Enochian is still magic, in its base.
			m_devotion = 200,
			category = "Enochian Artificery",
			lines = list("Ol sonf vorsg, hoath zir.","Madriax soba-lonshi od zorge.","Faxs to faxs-sobol athan.","Velor ixan thrae-zho vel.","Korvath en'zul miraxis thren.","Thren val'kora ix ven.","Zai'ul phoros vekh tor.","Morath xi'en thul var.","Vael kor zin'athra vel.","Thul'kor imnaza vekh dor.","En'ra zolth ix venak.","Zhorath kal'mir vex ul.","Ul ix zizo vel'kra.","Sothra vel ixan thul.","Zor'en valix thrae kor.","Vel'zan morath ix ul.","Threx ul ven'kai zhor.","Ix zol ven'ra thul kor.","Vorath ixen kal zor.","Zizo ul thren val'ix.")
		),
		"Profane Rope" = list(
			path = /obj/item/rope/zizo,
			m_cooldown = 2 MINUTES,
			m_rank = SKILL_LEVEL_NONE, // This is to help capture enemies for certain rituals that require them to be alive. No different than normal rope. Can even be used to make handcards or meathooks!
			m_devotion = 100,
			category = "Rite Instruments",
			lines = list("Ol sonf vorsg, hoath zir.","Madriax soba-lonshi od zorge.","Faxs to faxs-sobol athan.","Velor ixan thrae-zho vel.","Korvath en'zul miraxis thren.","Thren val'kora ix ven.","Zai'ul phoros vekh tor.","Morath xi'en thul var.","Vael kor zin'athra vel.","Thul'kor imnaza vekh dor.","En'ra zolth ix venak.","Zhorath kal'mir vex ul.","Ul ix zizo vel'kra.","Sothra vel ixan thul.","Zor'en valix thrae kor.","Vel'zan morath ix ul.","Threx ul ven'kai zhor.","Ix zol ven'ra thul kor.","Vorath ixen kal zor.","Zizo ul thren val'ix.")
		),
		"Vial of Corrosion" = list(
			path = /obj/item/matthios_canister/zizo_corrosive,
			m_cooldown = 5 MINUTES,
			m_rank = SKILL_LEVEL_EXPERT, // This is likely going to be removed, it was an in-development vision I had that ended up too close to Matthios. We'll see.
			m_devotion = 200,
			category = "Enochian Artificery",
			lines = list("Ol sonf vorsg, hoath zir.","Madriax soba-lonshi od zorge.","Faxs to faxs-sobol athan.","Velor ixan thrae-zho vel.","Korvath en'zul miraxis thren.","Thren val'kora ix ven.","Zai'ul phoros vekh tor.","Morath xi'en thul var.","Vael kor zin'athra vel.","Thul'kor imnaza vekh dor.","En'ra zolth ix venak.","Zhorath kal'mir vex ul.","Ul ix zizo vel'kra.","Sothra vel ixan thul.","Zor'en valix thrae kor.","Vel'zan morath ix ul.","Threx ul ven'kai zhor.","Ix zol ven'ra thul kor.","Vorath ixen kal zor.","Zizo ul thren val'ix.")
		),
	)

	var/list/item_cooldowns = list()

/datum/action/cooldown/spell/enochian/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/skill = H.get_skill_level(associated_skill)

	var/list/valid = list()
	for(var/name in options)
		var/list/entry = options[name]
		if(!islist(entry))
			continue
		if(skill >= entry["m_rank"])
			valid[name] = entry

	if(!valid.len)
		return FALSE

	var/list/categories = list(
		"Enochian Artificery",
		"Rite Instruments",
		"Sepulchral Relics"
	)

	var/category = tgui_input_list(H, "Choose your path", "Enochian", categories)
	if(!category)
		return FALSE

	var/list/display = list()

	for(var/name in valid)
		var/list/entry = valid[name]

		if(entry["category"] != category)
			continue

		var/cd = item_cooldowns[name]
		var/display_name

		var/devotion_cost = entry["m_devotion"] || 0

		if(cd == -1)
			display_name = "[name] (UNAVAILABLE)"
		else
			var/time_left = cd ? max(0, cd - world.time) : 0
			if(time_left > 0)
				display_name = "[name] ([round(time_left/10, 1)]s | [devotion_cost] Devotion)"
			else
				display_name = "[name] ([devotion_cost] Devotion)"

		display[display_name] = name

	if(!display.len)
		to_chat(H, span_warning("Nothing available in this category."))
		return FALSE

	// CHOICE
	var/choice_display = tgui_input_list(H, "Choose your tool", "Enochian", display)
	if(!choice_display)
		return FALSE

	var/choice = display[choice_display]
	if(!choice)
		return FALSE

	var/list/entry = valid[choice]
	var/item_path = entry["path"]
	var/m_cd = entry["m_cooldown"]
	var/list/lines = entry["lines"]
	var/devotion_cost = entry["m_devotion"] || 0

	if(!item_path)
		return FALSE

	// COOLDOWN CHECK
	if(item_cooldowns[choice] == -1)
		to_chat(H, span_warning("[choice] cannot be used again."))
		return FALSE

	if(item_cooldowns[choice] && world.time < item_cooldowns[choice])
		to_chat(H, span_warning("[choice] is on cooldown for [round((item_cooldowns[choice] - world.time)/10, 1)] seconds."))
		return FALSE

	// DEVOTION CHECK
	if(devotion_cost > 0)
		src.devotion_cost = devotion_cost
		if(!H.devotion?.check_devotion(src))
			to_chat(H, span_warning("Your connection to the Lady of Progress is faint. Don't ask favors you cannot commit to."))
			return FALSE

	// SPAWN ITEM
	var/obj/item/I = new item_path(H.drop_location())
	if(!I)
		return FALSE

	H.put_in_hands(I)

	if(lines && lines.len)
		H.say(pick(lines), language = /datum/language/common)

	// APPLY DEVOTION COST
	if(devotion_cost > 0)
		H.devotion.update_devotion(-devotion_cost)

	// APPLY COOLDOWN
	if(m_cd == 0) // if this is 0, it means it can only be used once then becomes 'unavailable'.
		item_cooldowns[choice] = -1
	else
		item_cooldowns[choice] = world.time + m_cd

	StartCooldown()
	return TRUE

// T0: Snuffs out fires/lights around area of the caster, greater range with higher HOLY skill. Also made it give you darksight for a few seconds, since I assume this being an escape tool.


/datum/action/cooldown/spell/zizo/snuff_lights/cast(atom/cast_on)
	. = ..()

	if(!ishuman(owner))
		return FALSE

	var/mob/living/L = owner
	var/skill_level = owner.get_skill_level(/datum/skill/magic/holy)
	var/checkrange = snuff_range + skill_level

	for(var/obj/O in range(checkrange, owner))
		if(istype(O, /obj/item/flashlight/flare/torch/lantern/psycenser))
			continue
		if(istype(O, /obj/item/flashlight/flare/light))
			qdel(O)
		O.extinguish()

	for(var/mob/M in range(checkrange, owner))
		for(var/obj/O in M.contents)
			if(istype(O, /obj/item/flashlight/flare/torch/lantern/psycenser))
				continue
			if(istype(O, /obj/item/flashlight/flare/light))
				qdel(O)
			O.extinguish()

	var/bonus_duration = 10 SECONDS + ((max(skill_level - 1, 0)) * 30 SECONDS)
	L.apply_status_effect(/datum/status_effect/buff/snuff_lights, bonus_duration)
	owner.visible_message(span_purple("[owner] exhales a cold fog that smothers nearby lights."))
	return TRUE

/atom/movable/screen/alert/status_effect/buff/snuff_lights
	name = "Embracing Darkness"
	desc = "My eyes can see clearly in darkness. No secrets can hide from my prying gaze."
	icon_state = "darkvision"

/datum/status_effect/buff/snuff_lights
	id = "snuff_lights"
	duration = 5 SECONDS
	status_type = STATUS_EFFECT_REPLACE
	alert_type = /atom/movable/screen/alert/status_effect/buff/snuff_lights

/datum/status_effect/buff/snuff_lights/on_creation(mob/living/new_owner, bonus_duration)
	if(bonus_duration)
		duration = bonus_duration
	return ..()

/datum/status_effect/buff/snuff_lights/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_NITEVISION, "snuff_lights")
	owner.update_sight()

/datum/status_effect/buff/snuff_lights/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_NITEVISION, "snuff_lights")
	owner.update_sight()

/////////////////////////////////
// T1 - Zizo Miracle Selection //
/////////////////////////////////

/datum/action/cooldown/spell/zizo/stripknowledgeorprofane
	name = "Means of Progress"
	desc = "Choose between Zizo's Knowledge at the price of your sanity and perception (Insight), or Zizo's Power for offensively embedding bone lances into victims at range (Profane Bone)."
	fluff_desc = "There is always a cost to Progress, if there's anything every follower of Zizo knows; 'Progress commands sacrifice'."
	button_icon_state = "firstspellpack"

	click_to_activate = FALSE
	cast_range = SPELL_RANGE_ADJACENT

	primary_resource_cost = SPELLCOST_MIRACLE_MINOR

	secondary_resource_cost = SPELLCOST_MINOR_PROJECTILE

	invocation_type = INVOCATION_NONE //It has seperate message ON USE

	charge_required = FALSE
	cooldown_time = 10 SECONDS//Does not matter it's single use

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/chosen_spell
	var/zizo_stripknowledge = /datum/action/cooldown/spell/zizo/stripknowledge
	var/zizo_profane = /datum/action/cooldown/spell/projectile/zizo/profane
	var/choosingspell = FALSE

/datum/action/cooldown/spell/zizo/stripknowledgeorprofane/cast(atom/cast_on)
	. = ..()
	if(choosingspell == TRUE)
		to_chat(owner, span_warning("I'm already choosing a spell!"))
	else
		var/choice = chosen_spell
		choosingspell = TRUE
		if(!chosen_spell)
			choice = alert(owner, "What shalt you take from them? Knowledge or Lyfe", "PROGRESS COMMANDS SACRIFICE", "Knowledge - Strip Wisdom", "Lyfe - Profane Bone")
			chosen_spell = choice
		switch(choice)
			if("Knowledge - Strip Wisdom")
				owner.mind?.AddSpell(new zizo_stripknowledge, owner)
				owner.mind?.RemoveSpell(src.type)
			if("Lyfe - Profane Bone")
				owner.mind?.AddSpell(new zizo_profane, owner)
				owner.mind?.RemoveSpell(src.type)
			else
				return FALSE

///////////////////////
// T1 - Strip Wisdom. //
///////////////////////
// Reverse-enlightenment, as a twisted mockery of Noc's miracle. This one debuffs the int of whoever you cast it upon. -2 to be precise. sire.

/datum/action/cooldown/spell/zizo/stripknowledge
	name = "Strip Wisdom"
	desc = "Invoke Zizo's will onto a target, stripping their unworthy knowledge and dulling their mynd."
	fluff_desc = "Truth, Inzanity, Progress, the Absolute mandate of her Design. It is a difficult matter for the ignorant masses to even comprehend the means, but even Zizo knows not all are beyond the grasp of her ultimate truth, no matter how much they deny it."
	button_icon_state = "stripknowledge"
	sound = 'sound/magic/baotha_blessdrink.ogg'
	glow_intensity = GLOW_INTENSITY_LOW

	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = FALSE

	primary_resource_cost = 30 //slightly more expensive vs profane
	secondary_resource_cost = 20

	invocations = list("Zizo! Zizo! Strip away this unworthy mynd!") //Slightly louder whisper than Noc
	invocation_type = INVOCATION_WHISPER

	spell_flags = SPELL_PSYDON

	charge_required = TRUE
	charge_time = 1 SECONDS
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/chargingold.ogg'
	cooldown_time = 2 MINUTES

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/zizo/stripknowledge/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	if(!isliving(cast_on))
		to_chat(H, span_warning("That is not a valid target!"))
		return FALSE

	if(HAS_TRAIT(cast_on, TRAIT_DEADITE)) //unique funny easter egg for deadites
		to_chat(H, span_warning("My target lacks any signs of intelligence to strip!"))
		return FALSE

	var/mob/living/spelltarget = cast_on

	H.visible_message("[H] mutters a profane incantation and [spelltarget]'s glint of intelligence dulls'.")
	spelltarget.apply_status_effect(/datum/status_effect/buff/zizo_knowledge)
	spelltarget.add_stress(/datum/stressevent/zizo_knowledge)
	return TRUE

/atom/movable/screen/alert/status_effect/buff/zizo_knowledge
	name = "Stripped Knowledge"
	desc = "Profane magic is hindering my intelligence."
	icon_state = "stripknowledge"

/datum/status_effect/buff/zizo_knowledge
	id = "zizo_knowledge"
	alert_type = /atom/movable/screen/alert/status_effect/buff/zizo_knowledge
	duration = 2 MINUTES
	effectedstats = list(STATKEY_INT = -2)

/datum/stressevent/zizo_knowledge
	timer = 2 MINUTES
	stressadd = 3
	desc = span_red("I feel a shiver down my spine as unnatural magicka dulls my mynd.")

////////////////
//T1 - PROFANE//
////////////////
/datum/action/cooldown/spell/projectile/zizo/profane
	name = "Profane"
	desc = "Instantly launch a cursed bone shard that pierces any armor and always lodges into its victim."
	fluff_desc = "An early Cabal sacrament: bone, profaned through Zizo's teachings, proved a willing conduit for Avantyne's anti-life qualities. Splinters touched by Her grace pierce any ward and bury themselves deep in living flesh, a lasting testament to Her cruelty."
	button_icon_state = "profane"
	projectile_type = /obj/projectile/magic/profane
	cast_range = SPELL_RANGE_PROJECTILE
	primary_resource_cost = 15
	secondary_resource_cost = 15
	charge_required = FALSE
	cooldown_time = 30 SECONDS

	spell_flags = SPELL_PSYDON
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

/obj/item/bone/profane_splinter
	name = "profaned splinter"
	desc = "A jagged shard of bone pulsing with malignant energy."
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "chronobolt"
	embedding = list("embed_chance" = 100, "embedded_fall_chance" = 0, "embedded_ignore_throwspeed_threshold" = TRUE)

/obj/item/bone/profane_splinter/Initialize()
	. = ..()
	spawn(1)
		if(QDELETED(src))
			return
		if(!is_embedded)
			crumble()

/obj/item/bone/profane_splinter/Exited(atom/movable/gone, direction)
	. = ..()
	if(!is_embedded)
		crumble()

/obj/item/bone/profane_splinter/dropped(mob/user)
	. = ..()
	crumble()

/obj/item/bone/profane_splinter/Moved()
	. = ..()
	if(QDELETED(src))
		return
	if(!is_embedded)
		crumble()

/obj/item/bone/profane_splinter/proc/crumble()
	if(QDELETED(src))
		return
	visible_message(span_purple("[src] crumbles into dust..."), span_purple("[src] crumbles into dust..."))
	new /obj/item/ash(get_turf(src))
	qdel(src)

/obj/projectile/magic/profane
	name = "profaned bone shard"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "chronobolt"
	damage = 15
	damage_type = BRUTE
	nodamage = FALSE
	expose_caster_on_deflect = TRUE
	armor_penetration = PEN_BSTEEL
	range = SPELL_RANGE_PROJECTILE
	speed = MAGE_PROJ_FAST
	accuracy = 40
	var/embed_chance = 100

/obj/projectile/magic/profane/on_hit(atom/target, blocked)
	. = ..()

	if(!isliving(target))
		qdel(src)
		return

	var/mob/living/L = target

	if(L.anti_magic_check())
		visible_message(span_warning("[src] shatters harmlessly against [target]!"))
		playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
		qdel(src)
		return BULLET_ACT_BLOCK

	if(out_of_effective_range())
		return
	if(blocked >= 100)
		qdel(src)
		return
	try_embed_target(L)
	qdel(src)

/obj/projectile/magic/profane/proc/try_embed_target(mob/living/L)
	if(!prob(embed_chance))
		return

	if(!iscarbon(L))
		return

	var/mob/living/carbon/C = L

	if(!length(C.bodyparts))
		return

	var/obj/item/bodypart/limb = pick(C.bodyparts)
	if(!limb)
		return

	var/obj/item/bone/profane_splinter/S = new
	limb.add_embedded_object(S, FALSE, TRUE, TRUE)
	playsound(get_turf(L),pick('sound/combat/fracture/fracturedry (1).ogg','sound/combat/fracture/fracturedry (2).ogg','sound/combat/fracture/fracturedry (3).ogg'),80,TRUE)

// RAISE LESSER SKELETON SWARM (T2)
/datum/action/cooldown/spell/conjure_summon/zizo/skeleton_swarm
	name = "Raise Lesser Skeletons"
	desc = "Invoke raw Enochian magicka to bind loose bones into two simple skeletal thralls. Their crude physiology is held together purely by magic; unable to be incapacitated, they shall stand until they crumble into spare bones. Toggle their armaments with Shift+G: Sword and Shield, Spear, or Two Daggers. Each one killed gives a partial recoil."
	fluff_desc = "The faithful of Zizo do not raise the dead, they mock life by proving how little of it is truly required. Flesh decays, thought falters, and souls flee screaming into the arms of Necra, yet bone remains obedient. Through the language of ancient Enochian words of power, scattered remains are lashed together into a parody of mortal form, animated not by purpose or memory, but by the simple joy of defying the natural order."

	button_icon = 'icons/mob/actions/zizomiracles.dmi'
	button_icon_state = "skeleton_formation"
	background_icon = 'icons/mob/actions/zizomiracles.dmi'
	spell_color = GLOW_COLOR_ZIZO

	primary_resource_type = SPELL_COST_DEVOTION
	primary_resource_cost = 60
	secondary_resource_type = SPELL_COST_ENERGY
	secondary_resource_cost = 40

	charge_required = TRUE
	weapon_cast_penalized = FALSE
	charge_time = 2 SECONDS
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/chargingold.ogg'
	cooldown_time = 30 SECONDS

	associated_skill = /datum/skill/magic/holy
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

	summon_noun = "skeleton"
	max_summons = 4
	summons_per_cast = 1

	recoil_energy_floor = 500
	recoil_severity = CONJURE_RECOIL_PARTIAL

	invocation_type = null
	invocations = null
	modes = list(list("name" = "Sword and Shield", "tag" = "SWD", "loadout" = "sword_shield", "color" = GLOW_COLOR_ZIZO, "invocation" = ",w Liga Ossum, Eleva Scutum et Gladius!"),
		list("name" = "Spear", "tag" = "SPR", "loadout" = "spear", "color" = GLOW_COLOR_ZIZO, "invocation" = ",w Liga Ossum, Eleva Hasta!"),
		list("name" = "Two Daggers", "tag" = "2DG", "loadout" = "dual_daggers", "color" = GLOW_COLOR_ZIZO, "invocation" = ",w Liga Ossum, Eleva Pugiones!"),
	)

/datum/action/cooldown/spell/conjure_summon/zizo/skeleton_swarm/spawn_summon(turf/T, mob/living/user)
	var/turf/dest = T
	var/list/open = list()

	for(var/turf/open/candidate in range(1, T))
		if(!candidate.is_blocked_turf())
			open += candidate

	if(length(open))
		dest = pick(open)

	var/mob/living/carbon/human/species/skeleton/conjured/skeleton = new(dest)
	skeleton.summoner_ref = WEAKREF(user)
	skeleton.arcane_scale = clamp(user.get_skill_level(/datum/skill/magic/holy), 1, 6)
	skeleton.gear_tier = get_summon_tier(user)
	skeleton.loadout = modes[current_mode]["loadout"]

	skeleton.add_filter("zizo_conjure_glow", 2, list("outline", "size" = 2, "color" = "#9B59FF"))

	return skeleton

/datum/action/cooldown/spell/conjure_summon/zizo/skeleton_swarm/cast(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	return TRUE

/datum/action/cooldown/spell/conjure_summon/zizo/skeleton_swarm/dismiss_summons(list/mobs)
	for(var/mob/living/M in mobs)
		dismiss_zizo_skeleton(M)

/proc/dismiss_zizo_skeleton(mob/living/M)
	if(QDELETED(M))
		return

	var/datum/component/conjured_minion/minion = M.GetComponent(/datum/component/conjured_minion)
	if(minion)
		minion.dismissing = TRUE

	M.ai_controller?.set_ai_status(AI_STATUS_OFF)

	M.visible_message(span_notice("[M] collapses into a heap of bones and dust."))

	var/turf/T = get_turf(M)

	// Preserve the actual human remains before deleting the skeleton.
	new /obj/effect/decal/remains/human(T)

	qdel(M)

// TAME UNDEAD (T3) - I don't know why this is a T3, being just a forced Gravemark on a hostile NPC undead.
/datum/action/cooldown/spell/tame_undead/zizo
	associated_skill = /datum/skill/magic/holy
	primary_resource_cost = 100
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN
	charge_sound = 'sound/magic/chargingold.ogg'


///////////////////////
// T4 - Bewstow Chant //
///////////////////////
// Give any fellow Zizo worshipper the ability to speak and understand Zizocant. Exclusive to antagonists at T4, soft or converted acolytes (if clergy somehow convert to Zizo).

/datum/action/cooldown/spell/zizo/bestowcant
	name = "Bestow Zizocant"
	desc = "Bestow the forbidden tongue of Zizo's chant, requires a semi-lengthy ritual and a fellow Cabalist of Zizo's faith. You must remain still during the ritual."
	fluff_desc = "A tongue known to the initated of Zizo's Cabal, as well as the reanimated by those whom serve in her name. To the ignorant it is but gibberish with an eerie resemblance to the elven tongue; but to the enlightened it is a hallowed tongue reborn from the reminants of all that were lost."
	button_icon_state = "zizocant"
	sound = 'sound/magic/baotha_blessdrink.ogg'
	glow_intensity = GLOW_INTENSITY_LOW

	cast_range = 2 //We want to be very close, no sniping people with Zizospeak.
	self_cast_possible = FALSE //Use rituos, she COMMANDS sacrifice.

	primary_resource_cost = 75
	secondary_resource_cost = 30

	invocation_type = INVOCATION_NONE

	charge_required = TRUE
	charge_time = 5 SECONDS
	charge_slowdown = CHARGING_SLOWDOWN_HEAVY
	charge_sound = 'sound/magic/chargingold.ogg'
	cooldown_time = 1 MINUTES

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z | SPELL_REQUIRES_NO_MOVE

/datum/action/cooldown/spell/zizo/bestowcant/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	if(!isliving(cast_on))
		to_chat(H, span_warning("That is not a valid target!"))
		return FALSE

	var/mob/living/spelltarget = cast_on

	if(spelltarget != H && !HAS_TRAIT(spelltarget, TRAIT_CABAL))
		to_chat(H, span_warning("They do not hold Zizo's blessing! The rites reject them!"))
		return FALSE

	if(spelltarget != H && HAS_TRAIT(spelltarget, TRAIT_CABAL))
		to_chat(H, span_warning("I bestow Zizo's sacred tongue upon [spelltarget]!"))
		to_chat(spelltarget, span_warning("A strange chant settles into familarity in my mind. I can use ,W to speak Zizo's tongue, however its best I do so carefully as to not draw attention."))
		spelltarget.grant_language(/datum/language/undead)
	return TRUE

//Lich has cost-free version. So they can recruit people proper.
/datum/action/cooldown/spell/zizo/bestowcant/lich
	primary_resource_type = SPELL_COST_ENERGY //just so we hop off the devotion system.
	primary_resource_cost = 30
	associated_skill = /datum/skill/magic/arcane
	required_items = null

///////////////////
// T3 - Rituos  //
///////////////////
// - Zizo's Lesser Work. A single painful ritual that grants the caster a choice:

// Progress: Arcyne knowledge (2 minor aspects, 4 utilities). No skeletonization. -- Kunai: I made this more distinctive from Undeath, now it also gives you some traits to give a better progress vibe.
// Unlife: Full skeletonization (minus head) + MOB_UNDEAD, grants bonechill and raise_deadite. -- Kunai: We already have raise_deadite, so it's a moot point to give them the Necromancer version of it. Just gave them bonemend and a few more traits to give the vibe of a 'half-lich'.
// Both paths grant undead language and TRAIT_ARCYNE. One-time use - cannot be cast again after completion.

//SOEP -- Undeath gets: miracle-raise undead, bone catacalysm + raise deadite + classic undeath traits. Offensive varient w/ silver weakness and stamina-control for functional immortality.
//SOEP -- Progress gets: rapid skill leveling, ability to consume lux into health and stamina, more utility points for casting. Defensive varient w/ focus on talent and assistance.

/datum/action/cooldown/spell/zizo/rituos
	name = "Rituos"
	desc = "Enact one of the Lesser Work of Zizo - a single, agonizing ritual that tears open a path to power. Choose Progress to gain arcyne knowledge, or Unlife to embrace undeath."
	fluff_desc = "The holiest of Zizo's Lesser Works among the Cabal. A rite of surrendering weakness and mortality to embrace your purpose in Her design. Through agony, the faithful offer either mind or flesh, allowing Zizo to strip away mortal frailty and shape them into reflections of her ascension. Some surrender thought for forbidden understanding. Others surrender flesh for the stillness of unlife. Few endure enough to become what She envisioned. When the gifts fade, the faithful are taught only one truth: they have not sacrificed enough."
	button_icon_state = "rituos"
	charge_sound = 'sound/magic/chargingold.ogg'
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_NO_MOVE
	click_to_activate = FALSE
	self_cast_possible = TRUE
	charge_message = "<font color=red>ZIZO! ZIZO! ZIZO!"
	charge_required = TRUE
	charge_time = 10 SECONDS
	charge_slowdown = CHARGING_SLOWDOWN_HEAVY
	cooldown_time = 3 MINUTES
	primary_resource_cost = 100
	secondary_resource_cost = 100
	sound = 'sound/magic/swap.ogg'
	var/exploit_this

/datum/action/cooldown/spell/zizo/rituos/cast(atom/cast_on)
	. = ..()

	if(!ishuman(owner))
		return FALSE

	var/mob/living/carbon/human/user = owner

	// exploit protection / backlash
	if(exploit_this)
		user.zizo_spam_rejection()
		cooldown_time = 99 MINUTES
		return TRUE

	exploit_this = TRUE

	var/path_choice = tgui_alert(user, "What path of the Lesser Work do you seek?", "THE LESSER WORK", list("Progress", "Unlife", "Cancel"))

	if(!path_choice || path_choice == "Cancel")
		reset_spell_cooldown()
		exploit_this = FALSE
		return TRUE

	if(user.stat != CONSCIOUS)
		return FALSE

	user.visible_message(span_boldwarning("[user] throws back [user.p_their()] head, arcyne energy crackling across [user.p_their()] body!"))
	user.grant_language(/datum/language/undead)

	if(!src.run_ritual_chant(user, path_choice))
		exploit_this = FALSE
		return TRUE

	ADD_TRAIT(user, TRAIT_ARCYNE, "[type]")
	playsound(user, 'sound/vo/mobs/ghost/death.ogg', 100, FALSE, -1)

	if(user.mind?.has_antag_datum(/datum/antagonist/vampire))
		user.zizo_vampire_rejection()
		exploit_this = FALSE
		return TRUE

	switch(path_choice)
		if("Progress")
			src.apply_progress_path(user)
		if("Unlife")
			src.apply_unlife_path(user)

	user.mind?.RemoveSpell(src)
	qdel(src)
	exploit_this = FALSE
	return TRUE


/// T? - Undeath Path: Bone Cataclysm - Pretty much pops your summons into sad remains of their former selves. Shouldn't do a lot of damage, but it frags someone with bone splinters if they're close enough.
/datum/action/cooldown/spell/zizo/bone_cataclysm
	name = "Bone Cataclysm"
	desc = "Detonate all of your nearby skeletons in a wave of profane bone shrapnel. You and Gravemarked allies will not be harmed by it.<br><br>If used outside Combat Mode, you will disintegrate them and restore your energy."
	fluff_desc = "Zizo taught her faithful that the dead must always serve twice: once in unlife, and once more when their bones are shattered in her name."
	button_icon_state = "cataclysm"
	click_to_activate = FALSE
	self_cast_possible = TRUE
	charge_required = TRUE
	charge_time = 3 SECONDS
	charge_slowdown = CHARGING_SLOWDOWN_HEAVY
	charge_message = "I begin unraveling my undead servants..."
	cooldown_time = 1.5 MINUTES
	primary_resource_cost = 50
	secondary_resource_cost = 50
	invocations = list(",w Solve ossa, redite ad pulverem!")
	invocation_type = INVOCATION_SHOUT
	sound = 'sound/magic/swap.ogg'
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

/datum/action/cooldown/spell/zizo/bone_cataclysm/cast(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE

	var/list/valid_skeletons = list()
	var/mob/living/caster = owner

	for(var/mob/living/carbon/human/species/skeleton/conjured/S in view(9, owner))
		if(QDELETED(S))
			continue
		if(S.stat == DEAD)
			continue

		var/datum/component/conjured_minion/minion = S.GetComponent(/datum/component/conjured_minion)
		if(!minion)
			continue

		var/mob/living/summoner = minion.summoner_ref?.resolve()
		if(summoner != owner)
			continue

		valid_skeletons += S

	if(!length(valid_skeletons))
		owner.balloon_alert(owner, "No bound skeletons nearby!")
		return FALSE

	if(owner.cmode)
		owner.visible_message(
			span_danger("[owner] raises their hand as nearby skeletons begin violently rattling apart!"),
			span_userdanger("I prime my undead servants to violently explode.")
		)

		for(var/mob/living/S in valid_skeletons)
			S.Jitter(100)
			var/datum/beam/B = caster.Beam(S, icon_state = "necra_beam", time = 50, maxdistance = 20)
			addtimer(CALLBACK(src, PROC_REF(explode_skeleton), S, caster, B), rand(3 SECONDS, 6 SECONDS))

		return TRUE

	owner.visible_message(
		span_danger("[owner] raises their hand as nearby skeletons begin calmly rattling apart!"),
		span_userdanger("I sacrifice my undead servants, and sap their energy.")
	)

	for(var/mob/living/S in valid_skeletons)
		S.Jitter(100)
		var/datum/beam/B = caster.Beam(S, icon_state = "necra_beam", time = 30, maxdistance = 20)
		addtimer(CALLBACK(src, PROC_REF(despawn_skeleton), S, caster, B), rand(2 SECONDS, 3 SECONDS))

	return TRUE

/datum/action/cooldown/spell/zizo/bone_cataclysm/proc/explode_skeleton(mob/living/S, mob/living/caster, datum/beam/B)
	if(B)
		B.End()

	if(!S || QDELETED(S))
		return
	if(!caster || QDELETED(caster))
		return

	var/turf/T = get_turf(S)
	if(!T)
		return

	var/faction_tag = "[caster.real_name]_faction"

	S.visible_message(span_danger("[S] erupts into a storm of bone fragments!"))
	new /obj/effect/temp_visual/explosion(T)
	playsound(T, 'sound/misc/explode/explosion.ogg', 50)

	var/list/thrownatoms = list()
	for(var/turf/nearby in get_hear(1, T))
		for(var/atom/movable/AM in nearby)
			thrownatoms += AM

	for(var/atom/movable/AM in thrownatoms)
		if(QDELETED(AM))
			continue
		if(AM == S)
			continue
		if(AM.anchored)
			continue

		if(isliving(AM))
			var/mob/living/M = AM
			if(M == owner)
				continue

			if(M.mind?.current)
				if(faction_tag in M.mind.current.faction)
					continue
			else
				if(faction_tag in M.faction)
					continue

			if(!M.mind && M.resting && M.stat != CONSCIOUS)
				M.gib(TRUE, TRUE, TRUE, FALSE)

			if(!M.mind)
				M.Stun(50)

			M.set_resting(TRUE, TRUE)
			to_chat(M, span_danger("The blast hurls you backwards!"))

		var/atom/throwtarget = get_edge_target_turf(T, get_dir(T, get_step_away(AM, T)))
		AM.safe_throw_at(throwtarget, 2, 1, owner, force = MOVE_FORCE_EXTREMELY_STRONG)

	for(var/mob/living/carbon/C in view(4, T))
		if(C.stat == DEAD && C.mind)
			continue
		if(C == owner)
			continue

		if(C.mind?.current)
			if(faction_tag in C.mind.current.faction)
				continue
		else
			if(faction_tag in C.faction)
				continue

		var/dist = get_dist(C, T)
		var/min_splinters
		var/max_splinters

		switch(dist)
			if(0, 1)
				min_splinters = 3
				max_splinters = 4
			if(2)
				min_splinters = 1
				max_splinters = 3
			if(3)
				min_splinters = 1
				max_splinters = 2
			else
				continue

		var/splinter_count = rand(min_splinters, max_splinters)
		C.adjustBruteLoss(rand(10, 20))

		for(var/i in 1 to splinter_count)
			if(!length(C.bodyparts))
				break

			var/obj/item/bodypart/limb = pick(C.bodyparts)
			var/obj/item/bone/profane_splinter/P = new
			limb.add_embedded_object(P, FALSE, TRUE)

		C.apply_status_effect(/datum/status_effect/debuff/clickcd, 8 SECONDS)
		C.apply_status_effect(/datum/status_effect/debuff/exposed, 10 SECONDS)
		to_chat(C, span_userdanger("Bone splinters bury themselves deep into your flesh!"))

	new /obj/effect/decal/remains/human(T)
	qdel(S)

/datum/action/cooldown/spell/zizo/bone_cataclysm/proc/despawn_skeleton(mob/living/S, mob/living/caster, datum/beam/B)
	if(B)
		B.End()

	if(!S || QDELETED(S))
		return
	if(!caster || QDELETED(caster))
		return

	var/turf/T = get_turf(S)
	if(!T)
		return

	S.visible_message(
		span_warning("[S] crumbles apart into pale dust as its essence is siphoned away!"),
		span_warning("Ashes to ashes, dust to dust...")
	)

	playsound(T, 'sound/magic/swap.ogg', 50, TRUE)
	caster.energy_add(120)
	caster.stamina_add(-50)

	new /obj/item/ash(T)
	new /obj/item/ash(T)

	qdel(S)

//Reskin + Flavor of diagnose spell w/ some different flavor. Used for Necromancers/Lich.
/obj/effect/proc_holder/spell/invoked/diagnose/secular/zizo
	name = "Arcane Diagnosis"
	desc = "A highly-practiced reading of the body's humors and hidden ailments performed afar with left-handed magicks. Reveals a target's condition, with greater skill in medicine granting deeper detail. By embedding a Forceps on your patient, you may even identify substances within the blood; but even the most unskilled physicker can tell from a Cheele or Leech's reactions."
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	range = SPELL_RANGE_GROUND //Longer than regular diagnosis range. Progress Baby!
	antimagic_allowed = FALSE //Arcane, duh.

// Diagnosis (T?) - Progress Path: Reflavored version of Pestra's diagnosis, it basically does what you'd expect. Has a highly inefficent cost for some unique perks like extra range.
/obj/effect/proc_holder/spell/invoked/diagnose/zizo
	name = "Profane Diagnosis"
	desc = "Call upon Enochian magicka and Zizo's stolen medical knowledge to read the body's humors and hidden ailments at a sizable distance. Reveals a target's condition with perfect clarity. To perceive one's blood content, all you'll need is but an incision."
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	range = SPELL_RANGE_GROUND //Longer than regular diagnosis range. Progress Baby!
	devotion_cost = 15 //Significantly more expensive (3x)

// Enochian Analyze (T?) - Progress Path: A long-range miracle version of the spell engineering goggles give you, Progress Baby!
/obj/effect/proc_holder/spell/invoked/engineeranalyze/zizo
	desc = "Examine a structure's details through invoking Enochian magicka to see the world through Zizo's design without the need of specialised tools, close or afar."
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	range = SPELL_RANGE_GROUND
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	miracle = TRUE
	devotion_cost = 15 //Progress
