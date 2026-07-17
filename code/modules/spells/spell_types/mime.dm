/obj/effect/proc_holder/spell/aoe_turf/conjure/mime_wall
	name = "Invisible Wall"
	desc = ""
	school = "mime"
	panel = "Mime"
	summon_type = list(/obj/effect/forcefield/mime)
	invocation_type = "emote"
	invocation_emote_self = "<span class='notice'>I form a wall in front of myself.</span>"
	summon_lifespan = 300
	recharge_time = 300
	clothes_req = FALSE
	antimagic_allowed = TRUE
	range = 0
	cast_sound = null
	human_req = TRUE

	overlay_state = "invisible_wall"
	overlay_alpha = 175

/obj/effect/proc_holder/spell/aoe_turf/conjure/mime_wall/Click()
	if(usr && usr.mind)
		if(!HAS_TRAIT(usr, TRAIT_PERMAMUTE)) // If somehow someone gets ahold of this spell...
			to_chat(usr, span_warning("I am not a mute!"))
			return
		invocations = list("looks as if a wall is in front of [usr.p_them()].")
	else
		invocation_type ="none"
	invocation(usr) // force invocation because invocation() only gets called on a specific spell (not aoe_turf)
	..()

/obj/effect/proc_holder/spell/aoe_turf/conjure/mime_chair
	name = "Invisible Chair"
	desc = ""
	school = "mime"
	panel = "Mime"
	summon_type = list(/obj/structure/chair/mime)
	invocation_type = "emote"
	invocation_emote_self = "<span class='notice'>I conjure an invisible chair and sit down.</span>"
	summon_lifespan = 250
	recharge_time = 300
	clothes_req = FALSE
	antimagic_allowed = TRUE
	range = 0
	cast_sound = null
	human_req = TRUE

	overlay_state = "invisible_chair"
	overlay_alpha = 175

/obj/effect/proc_holder/spell/aoe_turf/conjure/mime_chair/Click()
	if(usr && usr.mind)
		if(!HAS_TRAIT(usr, TRAIT_PERMAMUTE))
			to_chat(usr, span_warning("I am not a mute!"))
			return
		invocations = list("pulls out an invisible chair and sits down.")
	else
		invocation_type ="none"
	invocation(usr)
	..()

/obj/effect/proc_holder/spell/aoe_turf/conjure/mime_chair/cast(list/targets,mob/user = usr)
	..()
	var/turf/T = user.loc
	for (var/obj/structure/chair/A in T)
		if (is_type_in_list(A, summon_type))
			A.setDir(user.dir)
			A.buckle_mob(user)


/obj/effect/proc_holder/spell/targeted/mime/speak
	name = "Speech"
	desc = ""
	school = "mime"
	panel = "Mime"
	clothes_req = FALSE
	human_req = TRUE
	antimagic_allowed = TRUE
	recharge_time = 3000
	range = -1
	include_user = TRUE

	action_icon_state = "mime_speech"
	action_background_icon_state = "bg_mime"

/obj/effect/proc_holder/spell/targeted/mime/speak/Click()
	if(!usr)
		return
	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/H = usr
	if(H.mind.miming)
		still_recharging_msg = "<span class='warning'>I can't break your vow of silence that fast!</span>"
	else
		still_recharging_msg = "<span class='warning'>You'll have to wait before you can give your vow of silence again!</span>"
	..()

/obj/effect/proc_holder/spell/targeted/mime/speak/cast(list/targets,mob/user = usr)
	for(var/mob/living/carbon/human/H in targets)
		H.mind.miming=!H.mind.miming
		if(H.mind.miming)
			to_chat(H, "<span class='notice'>I make a vow of silence.</span>")
		else
			to_chat(H, "<span class='notice'>I break your vow of silence.</span>")

// These spells can only be gotten from the "Guide for Advanced Mimery series" for Mime Traitors.

/obj/effect/proc_holder/spell/targeted/mime/blockade
	name = "Invisible Blockade"
	desc = ""
	school = "mime"
	panel = "Mime"
	invocation_type = "emote"
	invocation_emote_self = "<span class='notice'>I form a blockade in front of myself.</span>"
	recharge_time = 600
	sound =  null
	clothes_req = FALSE
	antimagic_allowed = TRUE
	range = -1
	include_user = TRUE

	action_icon_state = "invisible_blockade"
	action_background_icon_state = "bg_mime"
	var/wall_type = /obj/effect/forcefield/mime/advanced

/obj/effect/proc_holder/spell/targeted/mime/blockade/cast(list/targets, mob/user = usr)
	new wall_type(get_turf(user))
	if(user.dir == SOUTH || user.dir == NORTH)
		new wall_type(get_step(user, EAST))
		new wall_type(get_step(user, WEST))
	else
		new wall_type(get_step(user, NORTH))
		new wall_type(get_step(user, SOUTH))

/obj/effect/proc_holder/spell/targeted/mime/blockade/Click()
	if(usr && usr.mind)
		if(!usr.mind.miming)
			to_chat(usr, "<span class='warning'>I must dedicate myself to silence first!</span>")
			return
		invocations = list("looks as if a blockade is in front of [usr.p_them()].")
	else
		invocation_type ="none"
	..()

/obj/item/book/granter/spell/mimery_blockade
	spell = /obj/effect/proc_holder/spell/targeted/mime/blockade
	spellname = "Invisible Blockade"
	name = "Guide to Advanced Mimery Vol 1"
	desc = ""
	icon_state ="bookmime"
	remarks = list("...")

/obj/item/book/granter/spell/mimery_blockade/attack_self(mob/user)
	. = ..()
	if(!.)
		return
	if(!locate(/obj/effect/proc_holder/spell/targeted/mime/speak) in user.mind.spell_list)
		user.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/mime/speak)
