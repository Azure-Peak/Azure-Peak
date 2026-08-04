/obj/structure/vampire/scryingorb
	name = "Eye of Night"
	icon_state = "scrying"
	desc = "An unholy creation of impossible design, floats before you. Upon its surface flashes countless images and shapes beyond your understanding, places that shouldn't exist. Merely being in its vicinity sends a shiver down your spine."
/obj/structure/vampire/scryingorb/attack_hand(mob/living/carbon/human/user)
	if(user?.mind.has_antag_datum(/datum/antagonist/vampire/lord))
		user.visible_message("<font color='red'>[user]'s eyes turn dark red, as they channel the [src]</font>", "<font color='red'>I begin to channel my consciousness into a Predator's Eye.</font>")
		if(do_after(user, 6 SECONDS, src))
			user.scry_ghost(/mob/dead/observer/eye/arcane)
	else
		to_chat(user, span_warning("I don't have the power to use this!"))

/obj/structure/vampire/scryingorb/examine(mob/user)
	. = ..()
	if(user.mind?.has_antag_datum(/datum/antagonist/vampire/lord))
		. += span_bloody("Your scrying eye; spy upon the mortal or immortal realms alyke, peer through all languages and places. Just be careful whom walks past your eye. Your presence is powerful enough to be noticed even lyke this.")

/mob/dead/observer/eye/arcane
	icon_state = "arcaneeye"
	see_in_dark = 2
	hud_type = /datum/hud/eye

/mob/dead/observer/eye/arcane/proc/scry_tele()
	set category = "RoleUnique.Arcane Eye"
	set name = "Teleport"
	set desc= "Teleport to a location"
	set hidden = 0

	if(!isobserver(usr))
		to_chat(usr, span_warning("You're not an Eye!"))
		return
	area_tele()

/mob/dead/observer/eye/arcane/Initialize()
	. = ..()
	add_verb(src, list(
		/mob/dead/observer/eye/arcane/proc/scry_tele,
		/mob/dead/observer/eye/arcane/proc/cancel_scry,
		/mob/dead/observer/eye/arcane/proc/eye_down,
		/mob/dead/observer/eye/arcane/proc/eye_up,
		/mob/dead/observer/eye/arcane/proc/vampire_telepathy))
	name = "Arcane Eye"

/mob/dead/observer/eye/arcane/proc/cancel_scry()
	set category = "RoleUnique.Arcane Eye"
	set name = "Cancel Eye"
	set desc= "Return to Body"

	if(reenter_corpse())
		qdel(src)

/mob/dead/observer/eye/arcane/Crossed(mob/living/L)
	if(istype(L, /mob/living/carbon/human))
		var/mob/living/carbon/human/V = L
		var/holyskill = V.get_skill_level(/datum/skill/magic/holy)
		var/magicskill = V.get_skill_level(/datum/skill/magic/arcane)
		if(magicskill >= 2)
			to_chat(V, "<font color='red'>An ancient and unusual magic looms in the air around you.</font>")
			return
		if(holyskill >= 2)
			to_chat(V, "<font color='red'>An ancient and unholy magic looms in the air around you.</font>")
			return
		if(prob(20))
			to_chat(V, "<font color='red'>You feel like someone is watching you, or something.</font>")
			return

/mob/dead/observer/eye/arcane/proc/vampire_telepathy()
	set name = "Telepathy"
	set category = "RoleUnique.Arcane Eye"

	var/msg = sanitize(input("Send a message.", "Command") as text|null)
	if(!msg)
		return
	for(var/datum/mind/V in SSmapping.retainer.vampires)
		to_chat(V, span_boldnotice("A message from [src.real_name]:[msg]"))
	for(var/datum/mind/D in SSmapping.retainer.death_knights)
		to_chat(D, span_boldnotice("A message from [src.real_name]:[msg]"))
	for(var/mob/dead/observer/eye/arcane/A in GLOB.mob_list)
		to_chat(A, span_boldnotice("A message from [src.real_name]:[msg]"))

/mob/dead/observer/eye/arcane/proc/eye_up()
	set category = "RoleUnique.Arcane Eye"
	set name = "Move Up"

	if(zMove(UP, TRUE))
		to_chat(src, span_notice("I move upwards."))

/mob/dead/observer/eye/arcane/proc/eye_down()
	set category = "RoleUnique.Arcane Eye"
	set name = "Move Down"

	if(zMove(DOWN, TRUE))
		to_chat(src, span_notice("I move down."))

