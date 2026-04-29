/*//////////////
// TO: Enochian
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
	devotion_cost = 20
	var/list/options = list(

		"Corrupted Chalk" = list(
			path = /obj/item/chalk/zizo,
			m_cooldown = -1, // don't lose it! :D
			m_rank = SKILL_LEVEL_NONE,
			category = "Sepulchral Relics",
			lines = list("Ol sonf vorsg, hoath zir.","Madriax soba-lonshi od zorge.","Faxs to faxs-sobol athan."),
		),
		"Profane Rite Chalk" = list(
			path = /obj/item/ritechalk_zizo,
			m_cooldown = -1, // don't lose it! :D
			m_rank = SKILL_LEVEL_NONE,
			category = "Sepulchral Relics",
			lines = list("Ol sonf vorsg, hoath zir.","Madriax soba-lonshi od zorge.","Faxs to faxs-sobol athan.","Velor ixan thrae-zho vel.","Korvath en'zul miraxis thren.","Thren val'kora ix ven.","Zai'ul phoros vekh tor.","Morath xi'en thul var.","Vael kor zin'athra vel.","Thul'kor imnaza vekh dor.","En'ra zolth ix venak.","Zhorath kal'mir vex ul.","Ul ix zizo vel'kra.","Sothra vel ixan thul.","Zor'en valix thrae kor.","Vel'zan morath ix ul.","Threx ul ven'kai zhor.","Ix zol ven'ra thul kor.","Vorath ixen kal zor.","Zizo ul thren val'ix.")
		),
		"Profane Riteblade" = list(
			path = /obj/item/rogueweapon/huntingknife/idagger/zizo,
			m_cooldown = -1, // don't lose it! :D
			m_rank = SKILL_LEVEL_JOURNEYMAN,
			category = "Rite Instruments",
			lines = list("Ol sonf vorsg, hoath zir.","Madriax soba-lonshi od zorge.","Faxs to faxs-sobol athan.","Velor ixan thrae-zho vel.","Korvath en'zul miraxis thren.","Thren val'kora ix ven.","Zai'ul phoros vekh tor.","Morath xi'en thul var.","Vael kor zin'athra vel.","Thul'kor imnaza vekh dor.","En'ra zolth ix venak.","Zhorath kal'mir vex ul.","Ul ix zizo vel'kra.","Sothra vel ixan thul.","Zor'en valix thrae kor.","Vel'zan morath ix ul.","Threx ul ven'kai zhor.","Ix zol ven'ra thul kor.","Vorath ixen kal zor.","Zizo ul thren val'ix.")		
		),
		"Enochian Artificer's Bag" = list(
			path = /obj/item/storage/magebag/zizo,
			m_cooldown = -1, // don't lose it! :D
			m_rank = SKILL_LEVEL_NONE,
			category = "Sepulchral Relics",
			lines = list("Ol sonf vorsg, hoath zir.","Madriax soba-lonshi od zorge.","Faxs to faxs-sobol athan.","Velor ixan thrae-zho vel.","Korvath en'zul miraxis thren.","Thren val'kora ix ven.","Zai'ul phoros vekh tor.","Morath xi'en thul var.","Vael kor zin'athra vel.","Thul'kor imnaza vekh dor.","En'ra zolth ix venak.","Zhorath kal'mir vex ul.","Ul ix zizo vel'kra.","Sothra vel ixan thul.","Zor'en valix thrae kor.","Vel'zan morath ix ul.","Threx ul ven'kai zhor.","Ix zol ven'ra thul kor.","Vorath ixen kal zor.","Zizo ul thren val'ix.")		
		),
		"Enochian Grasp" = list(
			path = /obj/item/melee/touch_attack/sans_undertale,
			m_cooldown = 90 SECONDS,
			m_rank = SKILL_LEVEL_EXPERT,
			category = "Enochian Artificery",
			lines = list("Ol sonf vorsg, hoath zir.","Madriax soba-lonshi od zorge.","Faxs to faxs-sobol athan.","Velor ixan thrae-zho vel.","Korvath en'zul miraxis thren.","Thren val'kora ix ven.","Zai'ul phoros vekh tor.","Morath xi'en thul var.","Vael kor zin'athra vel.","Thul'kor imnaza vekh dor.","En'ra zolth ix venak.","Zhorath kal'mir vex ul.","Ul ix zizo vel'kra.","Sothra vel ixan thul.","Zor'en valix thrae kor.","Vel'zan morath ix ul.","Threx ul ven'kai zhor.","Ix zol ven'ra thul kor.","Vorath ixen kal zor.","Zizo ul thren val'ix.")		
		),
		"Profane Rope" = list(
			path = /obj/item/rope/zizo, // the serial eeper disease
			m_cooldown = 2 MINUTES,
			m_rank = SKILL_LEVEL_NONE,
			category = "Rite Instruments",
			lines = list("Ol sonf vorsg, hoath zir.","Madriax soba-lonshi od zorge.","Faxs to faxs-sobol athan.","Velor ixan thrae-zho vel.","Korvath en'zul miraxis thren.","Thren val'kora ix ven.","Zai'ul phoros vekh tor.","Morath xi'en thul var.","Vael kor zin'athra vel.","Thul'kor imnaza vekh dor.","En'ra zolth ix venak.","Zhorath kal'mir vex ul.","Ul ix zizo vel'kra.","Sothra vel ixan thul.","Zor'en valix thrae kor.","Vel'zan morath ix ul.","Threx ul ven'kai zhor.","Ix zol ven'ra thul kor.","Vorath ixen kal zor.","Zizo ul thren val'ix.")		
		),
		"Vial of Corrosion" = list(
			path = /obj/item/matthios_canister/zizo_corrosive,
			m_cooldown = 5 MINUTES,
			m_rank = SKILL_LEVEL_EXPERT,
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
		to_chat(H, span_warning("You lack the knowledge to invoke this rite."))
		return FALSE

	var/list/categories = list(
		"Sepulchral Relics",
		"Rite Instruments",
		"Enochian Artificery"
	)

	var/category = tgui_input_list(H, "Choose your rite", name, categories)
	if(!category)
		return FALSE

	var/list/display = list()

	for(var/entry_name in valid)
		var/list/entry = valid[entry_name]

		if(entry["category"] != category)
			continue

		var/cd = item_cooldowns[entry_name] || 0
		var/display_name

		if(cd == -1)
			display_name = "[entry_name] (UNAVAILABLE)"
		else
			var/time_left = max(0, cd - world.time)
			display_name = time_left > 0 ? "[entry_name] ([round(time_left/10, 1)]s)" : entry_name

		display[display_name] = entry_name

	if(!display.len)
		to_chat(H, span_warning("Nothing answers from this rite."))
		return FALSE

	var/choice_display = tgui_input_list(H, "Choose your implement", name, display)
	if(!choice_display)
		return FALSE

	var/choice = display[choice_display]
	if(!choice)
		return FALSE

	var/list/entry = valid[choice]
	var/item_path = entry["path"]
	var/m_cd = entry["m_cooldown"]
	var/list/lines = entry["lines"]

	if(!item_path)
		return FALSE

	if(item_cooldowns[choice] == -1)
		to_chat(H, span_warning("[choice] will work again."))
		return FALSE

	if(item_cooldowns[choice] && world.time < item_cooldowns[choice])
		to_chat(H, span_warning("[choice] is on cooldown for [round((item_cooldowns[choice] - world.time)/10, 1)]s."))
		return FALSE

	var/obj/item/I = new item_path(H.drop_location())
	if(!I)
		return FALSE

	H.put_in_hands(I)

	if(lines && lines.len)
		H.say(pick(lines))

	if(m_cd == -1)
		item_cooldowns[choice] = -1
	else
		item_cooldowns[choice] = world.time + m_cd

	StartCooldown()
	return TRUE

// T0: Snuffs out fires/lights around area of the caster, greater range with higher HOLY skill
/obj/effect/proc_holder/spell/self/zizo_snuff
	name = "Snuff Lights"
	desc = "Extinguish all lights in range, with your Miracles skill increasing range."
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "snufflight"
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	chargedloop = /datum/looping_sound/invokeholy
	invocations = list("exhales a dark grey smog, choking any lights nearby.")
	invocation_type = "emote"
	sound = 'sound/magic/zizo_snuff.ogg'
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	recharge_time = 20 SECONDS
	miracle = TRUE
	devotion_cost = 30
	range = 2

/obj/effect/proc_holder/spell/self/zizo_snuff/cast(list/targets, mob/user = usr)
	. = ..()
	if(!ishuman(user))
		revert_cast()
		return FALSE
	var/checkrange = (range + user.get_skill_level(/datum/skill/magic/holy)) //+1 range per holy skill up to a potential of 8.
	for(var/obj/O in range(checkrange, user))
		O.extinguish()
	for(var/mob/M in range(checkrange, user))
		for(var/obj/O in M.contents)
			O.extinguish()
	return TRUE

// T1: (fires a bone splinter at a target for brute and bleeding if you're not holding bones in your other hand, fires a significantly stronger bone lance if you are)

/obj/effect/proc_holder/spell/invoked/projectile/profane
	name = "Profane"
	desc = "Fire forth a splinter of unholy bone, tearing flesh and causing bleeding. If you hold pieces of bone in your other hand, you will coax a much stronger lance of bone into being."
	clothes_req = FALSE
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "profane"
	range = 8
	associated_skill = /datum/skill/magic/arcane
	projectile_type = /obj/projectile/magic/profane
	chargedloop = /datum/looping_sound/invokeholy
	invocation_type = "none"
	releasedrain = 30
	chargedrain = 0
	chargetime = 15
	recharge_time = 10 SECONDS
	hide_charge_effect = TRUE // Left handed magick babe

/obj/effect/proc_holder/spell/invoked/projectile/profane/miracle
	miracle = TRUE
	devotion_cost = 15
	associated_skill = /datum/skill/magic/holy

/obj/effect/proc_holder/spell/invoked/projectile/profane/fire_projectile(mob/living/user, atom/target)
	current_amount--

	var/obj/item/held_item = user.get_active_held_item()
	var/big_cast = FALSE
	if (istype(held_item, /obj/item/natural/bundle/bone))
		var/obj/item/natural/bundle/bone/bonez = held_item
		if (bonez.use(1))
			projectile_type = /obj/projectile/magic/profane/major
			big_cast = TRUE
	else if (istype(held_item, /obj/item/natural/bone))
		qdel(held_item)
		projectile_type = /obj/projectile/magic/profane/major
		big_cast = TRUE
	else if (istype(held_item, /obj/item/natural/bundle/bone))
		var/obj/item/natural/bundle/bone/boney_bundle = held_item
		if (boney_bundle.use(1))
			projectile_type = /obj/projectile/magic/profane/major
			big_cast = TRUE

	var/obj/projectile/P = new projectile_type(user.loc)
	P.firer = user
	P.preparePixelProjectile(target, user)
	P.fire()

	if (big_cast)
		user.visible_message(span_danger("[user] conjures and hurls a vicious lance of bone towards [target]!"), span_notice("I hurl a vicious lance of bone at [target]!")) 						//hehe. vicious lance of bone
	else
		user.visible_message(span_danger("[user] swings their arm in a wide arc, hurling a splinter of bone towards [target]!"), span_notice("I fling a shard of profaned bone at [target]!"))

	projectile_type = initial(projectile_type)

/obj/projectile/magic/profane
	name = "profaned bone splinter"
	icon_state = "chronobolt"
	damage = 20
	damage_type = BRUTE
	nodamage = FALSE
	var/embed_prob = 10

/obj/projectile/magic/profane/major
	name = "profaned bone lance"
	damage = 35
	embed_prob = 30

/obj/projectile/magic/profane/on_hit(atom/target, blocked)
	. = ..()
	if (iscarbon(target) && prob(embed_prob))
		var/mob/living/carbon/carbon_target = target
		var/obj/item/bodypart/victim_limb = pick(carbon_target.bodyparts)
		var/obj/item/bone/splinter/our_splinter = new
		victim_limb.add_embedded_object(our_splinter, FALSE, TRUE)

/obj/item/bone/splinter
	name = "bone splinter"
	embedding = list(
		"embed_chance" = 100,
		"embedded_pain_chance" = 25,
		"embedded_fall_chance" = 5,
	)

/obj/item/bone/splinter/dropped(mob/user, silent)
	. = ..()
	to_chat(user, span_danger("[src] crumbles into dust..."))
	qdel(src)

// T2: just use lesser animate undead for now

/obj/effect/proc_holder/spell/invoked/raise_undead_formation/miracle
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "skeleton_formation"
	miracle = TRUE
	devotion_cost = 75
	cabal_affine = TRUE
	to_spawn = 1

// T2: carbon spawn

/obj/effect/proc_holder/spell/invoked/raise_undead_guard/miracle
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "skeleton"
	name = "Raise Deadite"
	desc = "Raises a singular, weak deadite."
	chargetime = 3 SECONDS
	miracle = TRUE
	devotion_cost = 75

// T3: tames bio_type = undead mobs

/obj/effect/proc_holder/spell/invoked/tame_undead/miracle
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "deadite_tame"
	miracle = TRUE
	devotion_cost = 100

// T3: Rituos - Zizo's Lesser Work. A single painful ritual that grants the caster a choice:
// Progress: Arcyne knowledge (2 minor aspects, 4 utilities). No skeletonization.
// Unlife: Full skeletonization + MOB_UNDEAD, grants bonechill and raise_deadite directly.
// Both paths grant undead language and TRAIT_ARCYNE. One-time use - cannot be cast again after completion.

// Progress: Made it grant the ability to grind for artificery stuff, progress and undeath were not very distinctive aside undeath being more conspicuous, now they are
// Unlife: You forgot that Rituos back then was also used to restore bodyparts, but since we're departing from that, I gave a few extras, and also no-blood, since 90% of their body is fuckin bones now, mostly to avoid weird interactions that'd result from having no organs

/obj/effect/proc_holder/spell/invoked/rituos
	name = "Rituos"
	desc = "Enact one of the Lesser Work of Zizo - a single, agonizing ritual that tears open a path to power. Choose Progress to gain arcyne knowledge, or Unlife to embrace undeath."
	clothes_req = FALSE
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "rituos"
	associated_skill = /datum/skill/magic/arcane
	chargedloop = /datum/looping_sound/invokeholy
	chargedrain = 0
	chargetime = 50
	releasedrain = 90
	no_early_release = TRUE
	movement_interrupt = TRUE
	recharge_time = 5 MINUTES
	hide_charge_effect = TRUE

/obj/effect/proc_holder/spell/invoked/rituos/miracle
	miracle = TRUE
	devotion_cost = 120 // I forgot to revert holy shit 1 job
	associated_skill = /datum/skill/magic/holy

/obj/effect/proc_holder/spell/invoked/rituos/cast(list/targets, mob/living/carbon/human/user)
	var/turf/T = get_turf(user)
	var/obj/structure/ritualcircle/zizo/circle = locate(/obj/structure/ritualcircle/zizo) in T

	if(!circle)
		var/confirm1 = tgui_alert(user,
			"Attempting a Rituos without a Rune of Progress is SUICIDE.\nProceed anyway?",
			"RITUOS WARNING",
			list("Yes", "No"))

		if(confirm1 != "Yes")
			revert_cast()
			return FALSE
			
		var/confirm2 = tgui_alert(user,
			"This will end you. There will be no salvation.\nAre you absolutely certain?",
			"FINAL WARNING",
			list("I accept the risk! FOR ZIZO!", "Progress demands forethought."))

		if(confirm2 != "I accept the risk! FOR ZIZO!")
			revert_cast()
			return FALSE

		var/path_choice = tgui_alert(user,
			"What path of the Lesser Work do you seek?",
			"THE LESSER WORK",
			list("Progress", "Unlife", "Cancel"))

		if(!path_choice || path_choice == "Cancel")
			revert_cast()
			return FALSE

		playsound(user, 'sound/vo/mobs/ghost/whisper (3).ogg', 100, FALSE, -1)
		ADD_TRAIT(user, TRAIT_PSYCHOSIS, TRAIT_GENERIC) // you done
		ADD_TRAIT(user, TRAIT_DNR, TRAIT_GENERIC) // 			goofed
		user.hallucination += 999
		user.visible_message(span_boldwarning("[user] throws back [user.p_their()] head, arcyne energy crackling across [user.p_their()] body!"))
		user.Stun(300)
		user.say("ZIZO! ZIZO! ZI--")
		sleep(25)
		user.say("...zo?")
		sleep(40)
		user.emote("huh")
		user.Jitter(30)

		var/lines = list(
			"How quaint... You thought a circle was optional. I assure you, it is not. You'll know why.",
			"You summon me like a parlor trick and expect dignity in return. How droll. Now dance for me.",
			"I have seen better etiquette from a rotting Deadite. And they at least stay quiet. Just die, filth.",
			"You reached for a queen of undeath with nothing but audacity. That will not suffice. But this, will.",
			"No rite, no structure... Only you, standing there, being… insufficient. Let's amend that.",
			"I was inclined to ignore this, but now I find myself offended. Congratulations.",
			"Do you often present yourself so poorly, or is this a special occasion? Then... I shall make it special.",
			"You have mistaken access for entitlement. An entertaining mistake. Now dance for me.",
			"I felt that tug and thought, <i>surely this is a mistake.</i> Indeed, it was. You.",
			"You've managed to waste my time and your life in a single gesture. Quite efficient.",
			"I do admire the confidence. Not the execution, mind you, just the confidence. Here's your reward.",
			"You call upon progress yet refuse even the basics. How predictably stagnant.",
			"You stand before me uninvited, unprepared, and entirely unremarkable.",
			"I could forgive ignorance. This, however, is effort.",
			"You've reduced a sacred act to something crude and inelegant. I take that personally.",
			"I am being addressed without ceremony. That alone decides your fate.",
			"You wanted my attention. You should have considered the cost more carefully.",
			"I have no interest in teaching you properly. This lesson will have to suffice.",
			"...Next time, try a rite circle. Ah... Wait. No. There won't be a 'next time'."
		)

		to_chat(user, span_userdanger((pick(lines))))
		sleep(30)

		var/list/panic_lines = list(
			"IT'S TEARING— MAKE IT STOP—!!",
			"MY BONES— NO— NO—!!",
			"SOMETHING'S INSIDE— GET IT OUT—!!",
			"I CAN'T HOLD IT— STO—!!",
			"IT'S COMING OUT— MAKE IT STO—!!",
			"NO— NO NO NO—!!",
			"I TAKE IT BACK— I TAKE IT BACK—!!",
			"ZIZO— WAIT— STO—!!",
			"PLEASE— IT HURTS— MAKE IT STOP—!!",
			"NOT LIKE THIS— NOT LIKE THIS—!!",
			"WRONG— WRONG PATH— STO—!!",
			"THE RUNE— I NEEDED THE RUNE—!!",
			"I DIDN'T FINISH— STO—!!",
			"SHE HEARS— SHE HEARS—!!",
			"GET OUT OF ME— GET OUT—!!",
			"IT'S IN MY VEINS— STO—!!",
			"I CAN FEEL IT— I CAN FEEL IT—!!",
			"NO MORE— PLEASE— NO MORE—!!",
			"I CAN'T— I CAN'T—!!",
			"STOP— STOP— STO—!!",
			"IT'S PULLING ME APART—!!",
			"MY SKIN— NO—!!",
			"IT BURNS— MAKE IT STOP—!!",
			"I'M BREAKING— I'M BREAKING—!!",
			"DON'T TAKE ME— DON'T—!!",
			"PLEASE— PLEASE— STO—!!"
		)

		addtimer(CALLBACK(user, TYPE_PROC_REF(/mob/living/carbon, vomit), 0, TRUE), 3 SECONDS)
		spawn()
			user.say("--ZIZO?!")
			user.visible_message(span_purple("<i>Unholy, dense necrotic energy gathers around [user] in crackles of ghastly force! Did they anger someone they should not?..."))

			sleep(20)
			user.emote("agony")

			var/loops = 0
			var/max_loops = 16

			while(user && !QDELETED(user) && loops < max_loops)
				sleep(10)
				user.say(pick(panic_lines))
				if(prob(50))
					user.emote("painscream")
				else
					user.emote("agony")
				user.Jitter(20)
				if(prob(45))
					if(user && !QDELETED(user))
						playsound(user.loc, 'sound/combat/dismemberment/dismem (2).ogg', 50)
				if(prob(25))
					if(user && !QDELETED(user))
						user.vomit(blood = TRUE)
				loops++

		var/turf/origin = get_turf(user)
		if(!origin)
			return FALSE

		var/list/valid_turfs = list()
		for(var/turf/nearby in view(3, user))
			if(!nearby) continue
			if(!isopenturf(nearby)) continue
			if(nearby.density) continue
			valid_turfs += nearby

		if(!length(valid_turfs))
			valid_turfs += origin

		sleep(160)

		explosion(user, 0, 0, 1, 0, FALSE, FALSE, 1, FALSE, FALSE)
		user.visible_message(span_boldwarning("[user] is utterly UNDONE by UNHOLY MAGIC, the shockwave of their bones and leftovers reforming and giving shape to a horde of undead!"))
		user.visible_message(span_userdanger("<b>ZIZO!! ZIZO!! ZIZO!!</b>"))

		user.gib(no_brain = TRUE, no_organs = TRUE, no_bodyparts = FALSE, safe_gib = FALSE)

		for(var/i = 1 to 8)
			var/turf/spawnT = pick(valid_turfs)
			if(!spawnT) continue
			sleep(1)
			new /obj/effect/temp_visual/gib_animation(spawnT, "gibbed-h")
			var/mob/living/skeleton_new = new /mob/living/carbon/human/species/skeleton/npc/bogguard(spawnT, user)
			spawn(10)
				if(skeleton_new)
					skeleton_new.faction |= list("cabal", "[user.mind?.current?.real_name]_faction")

		return FALSE

	var/path_choice = tgui_alert(user, "What path of the Lesser Work do you seek?", "THE LESSER WORK", list("Progress", "Unlife", "Cancel"))
	if(!path_choice || path_choice == "Cancel")
		return FALSE

	user.grant_language(/datum/language/undead)

	// The chant - path-specific invocations
	user.visible_message(span_boldwarning("[user] throws back [user.p_their()] head, arcyne energy crackling across [user.p_their()] body!"))
	playsound(user, 'sound/vo/mobs/ghost/whisper (3).ogg', 100, FALSE, -1)

	var/list/chant_lines
	switch(path_choice)
		if("Progress")
			chant_lines = list(
				"ZIZO! ZIZO! ZIZO! GRANT ME INSIGHT UNSHACKLED!",
				",w TEAR OPEN THE VEIL THAT BINDS MY THOUGHT!",
				"LET NO TRUTH BE HIDDEN, NO PATTERN UNSEEN!",
				",w STRIP ME OF STAGNATION AND IGNORANCE!",
				"BREAK THE CHAINS OF STILLNESS THAT CLING TO MY WILL!",
				",w UNMAKE THE FEAR THAT STAYS MY HAND!",
				"I OFFER THIS MIND TO COMPLETE THY WORK!",
				",w CARVE THY DESIGN INTO MY THINKING!",
				"LET ME BE TOOL, PROCESS, AND RESULT AS ONE! MY MIND IS YOURS, ZIZO!!"
			)

		if("Unlife")
			chant_lines = list(
				"ZIZO! ZIZO! ZIZO! FLENSE FLESH FROM MY BONE!",
				",w PEEL AWAY THE LIE OF WARMTH AND BREATH!",
				"LET BONE AND SINEW BE REVELATION, NOT END!",
				",w STRIP ME OF MORTALITY'S SHACKLE!",
				"SEVER THE TYRANNY OF HEART AND PULSE!",
				",w LET SILENCE TAKE THE PLACE OF BREATH!",
				"I OFFER THIS VESSEL TO THY LESSER WORK!",
				",w HOLLOW ME THAT I MAY BE FILLED ANEW!",
				"GRANT UNTO ME THE PERFECTION OF UNDEATH! THE PERFECTION OF THY GREAT WORK!!"
			)

	for(var/i in 1 to length(chant_lines))
		user.say(chant_lines[i], forced = "spell")
		user.adjustBruteLoss(15)
		playsound(user, 'sound/vo/mobs/ghost/whisper (1).ogg', 25, FALSE, -1)
		if(path_choice == "Progress")
			user.emote(pick("whimper", "painscream", "scream", "breathgasp"))
		else
			user.emote(pick("paincrit", "painscream", "scream", "breathgasp"))
		if(i > 1)
			shake_camera(user, i * 1, i)
		if(!do_after(user, 4 SECONDS, target = user))
			to_chat(user, span_warning("The ritual collapses...! I must do it all over."))
			return FALSE

	ADD_TRAIT(user, TRAIT_ARCYNE, "[type]")
	playsound(user, 'sound/vo/mobs/ghost/death.ogg', 100, FALSE, -1)

	switch(path_choice)
		if("Progress")
			// keep in mind rituos is Heretic/Missionary only, should be fine for an ult
			// the idea is that progress is now for supporting, undeath is the offensive option
			// I'll add more to this based on feedback, but for now I don't want to give it too much
			user.adjust_skillrank(/datum/skill/magic/arcane, 3, TRUE)
			ADD_TRAIT(user, TRAIT_JACKOFALLTRADES, "rituos")
			ADD_TRAIT(user, TRAIT_SMITHING_EXPERT, "rituos")
			ADD_TRAIT(user, TRAIT_SELF_SUSTENANCE, "rituos")
			ADD_TRAIT(user, TRAIT_SQUIRE_REPAIR, "rituos")
			if(user.mind)
				user.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 0, "minor" = 2, "utilities" = 4))
				grant_poke_spell(user)
			user.visible_message(span_boldwarning("Arcyne runes sear themselves across [user]'s skin, glowing with a sickly light before fading beneath the flesh!"), span_notice("THE LESSER WORK IS DONE! Stolen knowledge floods my mind - I can see the threads of magic itself, and progress is all that accurses my mind!"))

		if("Unlife")
			user.mob_biotypes |= MOB_UNDEAD
			user.dna.species.species_traits |= NOBLOOD
			ADD_TRAIT(user, TRAIT_NOHUNGER, "[type]") // already had
			ADD_TRAIT(user, TRAIT_NOBREATH, "[type]") // already had
			ADD_TRAIT(user, TRAIT_FAKEDEATH, "[type]") // for no heartbeat
			ADD_TRAIT(user, TRAIT_TOXIMMUNE, "[type]") // there's nothing left to poison
			ADD_TRAIT(user, TRAIT_LIMBATTACHMENT, "[type]") // you'll need this now that rituos doesn't regrow lost limbs
			ADD_TRAIT(user, TRAIT_ZOMBIE_IMMUNE, "[type]") // just to make sure
			ADD_TRAIT(user, TRAIT_SILVER_WEAK, "[type]") // you are 90% undead

			// got a new transformation cutscene!! thank me later
			to_chat(user, span_artery("Something is wrong. <i><u>Terribly wrong.</i></u>"))

			sleep(15)

			user.emote("agony")

			for(var/obj/item/W in user)
				user.dropItemToGround(W)
				if(prob(50))
					step(W, pick(GLOB.alldirs))

			user.Stun(150)
			user.dir = SOUTH

			user.visible_message(
				span_boldwarning("[user]'s body stiffens violently, fingers curling as something unseen takes hold."),
				span_userdanger("My body...! It won't obey. Something is taking it. Molding it.")
			)

			sleep(20)

			var/obj/item/bodypart/torso = user.get_bodypart(BODY_ZONE_CHEST)
			var/list/parts_to_destroy = list()
			for(var/obj/item/bodypart/part as anything in user.bodyparts)
				if(part.body_zone == BODY_ZONE_HEAD || part == torso)
					continue
				parts_to_destroy += part

			for(var/obj/item/bodypart/part in parts_to_destroy)
				if(!user || QDELETED(user)) break
				part.skeletonize(FALSE)
				user.update_body_parts()
				user.visible_message(
					span_boldwarning("[user]'s [part.name] twists unnaturally--! Flesh splitting as bone forces through."),
					span_userdanger("MY [uppertext(part.name)]—!! IT BURNS!! IT'S BURNING DOWN TO THE BONE!!")
				)
				playsound(user.loc, 'sound/misc/smelter_sound.ogg', 50, FALSE)
				user.emote("painscream")
				user.Jitter(5)
				var/msg = pick("THE PAIN!!", "MAKE IT STOP--!!", "NO- NO NO--!!", "I CAN'T--!!", "GET IT OFF--!!", "ZIZO! ZIZO! ZIZO!--")
				user.visible_message(
					span_boldwarning("Rotting strands slough away from [user]'s [part.name], dissolving into a sickly haze."),
					span_userdanger(msg)
				)
				sleep(35)

			if(user && !QDELETED(user))
				user.visible_message(span_boldwarning("[user] convulses violently as something within their chest shifts."), span_userdanger("My heart— my LUX— something is inside—!!"))

				playsound(user.loc, 'sound/misc/lava_death.ogg', 70, FALSE)
			
				sleep(20)

				torso?.skeletonize(FALSE)
				user.update_body_parts()
				user.visible_message(
					span_boldwarning("[user]'s torso caves inward with a wet collapse-- flesh peeling away in heavy sheets, only to be burned away too."),
					span_userdanger("...I can't feel it anymore.")
				)
				playsound(user.loc, 'sound/misc/smelter_sound.ogg', 50, FALSE)

				sleep(25)

			to_chat(user, span_artery("The pain fades, as if it was never there."))
			sleep(20)
			to_chat(user, span_artery("In its place... stillness. Clarity. Reflection."))
			sleep(20)
			to_chat(user, span_artery("Bodily functions excised. Bodily fluids minimized. Form reinvented in Her perfect image."))
			sleep(20)
			user.emote("cackle")
			user.adjust_skillrank(/datum/skill/magic/arcane, 3, TRUE)

			if(user.mind)
				user.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/bonechill)
				user.mind.AddSpell(new /datum/action/cooldown/spell/bonemend)
				user.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 0, "minor" = 2, "utilities" = 4, "ward" = TRUE)) // gets ward, diff from progress
				grant_poke_spell(user)				

			user.visible_message(
				span_boldwarning("[user] stands... stripped of flesh, yet not dead. A hollow creecher, wreathed in marrow and bone, yet incomplete and mortal from the neck up."),
				span_notice("THE LESSER WORK IS COMPLETE. The flesh is gone, and what remains... is better, faster, stronger. Another step toward Progress.")
			)
			sleep(10)
			to_chat(user, span_small("...I am still incomplete.<br>Vestiges of mortality still cling to me.<br><br>...What have I done?"))

	// The Lesser Work is done - remove the spell
	user.mind?.RemoveSpell(src)
	qdel(src)
