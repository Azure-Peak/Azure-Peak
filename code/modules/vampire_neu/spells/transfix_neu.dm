/obj/effect/proc_holder/spell/targeted/transfix_neu
	name = "Transfix"
	action_icon = 'icons/mob/actions/vampspells.dmi'
	overlay_state = "transfix"

	associated_skill = /datum/skill/magic/blood

	range = 6
	chargetime = 0
	releasedrain = 100
	recharge_time = 20 SECONDS //Do not increase this, allow me to explain:

/* Transfix currently, how it works:
- You cast the spell, it gives you a list of everyone nearby
- You transfix someone, after typing sufficent characters (10+ letters)
- If they/you have cmode on, you full stop cannot use it. Yes, you have to play along with this to start with.
- They can just walk away, seriously, this is a thing and why I want this short again.
- Surprisingly, yes. Drowsiness wears off over time so we need to account for that.
- It builds in stacks, lickers and thinbloods have it as a 3-4 tap move if RNG is nice to you. So-> 60 (1 minute) -> 80 (1 minute, 20 seconds)

- Vampires, are all inherently antagonistic and need a non-frag way to take people out and drink them/turn them potentally.
- Currently people deathgasp through all Z levels which can be heard afar, this probably isn't intended but yes.

- If you rework transfix to something else entirely or our combat system de-neuters grabs to the point of absolutely useless, then feel free to. Don't touch it for now.
- Even wretchpires need to being able to take people out before others show up, that's why it's short.
*/

	/// Ignore crosses and give a different message
	var/powerful = FALSE
	/// Willpower divisor from INT
	var/int_divisor = 3.3
	/// Faces of blood die
	var/blood_dice = 9
	/// Faces of will die
	var/will_dice = 6

	var/transfix_msg

/obj/effect/proc_holder/spell/targeted/transfix_neu/choose_targets(mob/user = usr)
	var/list/selection = list()
	for(var/mob/living/carbon/human/target in get_hearers_in_view(6, usr))
		if(!target.mind || target.stat != CONSCIOUS)
			continue
		if(target.mind.has_antag_datum(/datum/antagonist/vampire))
			continue
		if(target.mind.has_antag_datum(/datum/antagonist/zombie))
			continue
		if(target.mind.has_antag_datum(/datum/antagonist/skeleton))
			continue
		if(target.mind.has_antag_datum(/datum/antagonist/werewolf))
			continue
		if(target.mind.has_antag_datum(/datum/antagonist/lich))
			continue
		//Full-antagonists only and supernatural ones only too.
		//Yes, Gnolls aren't immune. They can just use cmode, but this gives hunted vampires a card to play to maybe get (1/2 free escapes)

		//Again, do not give it to virtues. Not blackblooded, not rotcured. Period. This is your quiet take-a-person-down unsuspectingly ability. If you want protection get a silver cross.
		//Do not give people inherent and unexplainable protection, period. Not even constructs/reverents, it doesn't need to make sense or realistic here. Its a mechanical nessessity.
		selection += target

	if(!selection.len)
		revert_cast(user)
		return

	perform(selection, user=user)

/obj/effect/proc_holder/spell/targeted/transfix_neu/cast(list/targets, mob/user = usr)
	if(user.cmode)
		to_chat(user, span_warning("I can't focus on that right now!"))
		revert_cast(user)
		return

	if(!length(targets))
		to_chat(user, span_warning("There are no mortals nearby..."))
		revert_cast(user)
		return

	transfix_msg = input(user, "Soothe them. Dominate them. Speak and they will succumb.", "Transfix") as message|null
	if(!transfix_msg || length(transfix_msg) < 10)
		to_chat(user, span_userdanger("This not enough to ensnare their mind!"))
		revert_cast()
		return

	if(!powerful)
		var/mob/selected = input(user, "Ensnare the mind of which mortal?", "Transfix") as null|anything in targets
		if(QDELETED(src) || QDELETED(user) || QDELETED(selected))
			revert_cast(user)
			return
		targets = list(selected)

	var/bloodskill = user.get_skill_level(/datum/skill/magic/blood)
	var/bloodroll = roll(bloodskill, blood_dice)
	user.say(transfix_msg, forced = "spell ([name])")
	if(powerful)
		user.visible_message("<font color='red'>[user]'s eyes glow a ghastly red as they project their will outwards!</font>")

	for(var/mob/living/carbon/human/target as anything in targets)
		if(target.cmode)
			to_chat(user, span_userdanger("[target] is far too tense for that!"))
			break

		var/willpower = round(target.STAINT / int_divisor, 1)
		var/willroll = roll(willpower, will_dice)

		// If the vampire failed badly
		var/knowledgable = (willroll - bloodroll) >= 3

		if(!powerful)
			for(var/obj/item/clothing/neck/roguetown/psicross/silver/I in target.contents) //Subpath fix.
				var/extra = "!"
				if(knowledgable)
					extra = ", I sense the caster was [user]!"
				to_chat(target, "<font color='white'>The silver psycross shines and protects me from unholy magic[extra]</font>")
				to_chat(user, span_userdanger("[target] has my BANE! It causes me to fail to ensnare their mind!"))
				break

		if(bloodroll >= willroll)
			target.drowsyness = min(target.drowsyness + 50, 150)
			switch(target.drowsyness)
				if(0 to 50)
					to_chat(target, "You feel slightly drowsy, as though a curtain is coming over your mind.")
					to_chat(user, "The mind of [target] gives way slightly.")
					target.Slowdown(20)
				if(51 to 90)
					to_chat(target, "Your eyelids weigh heavy as you feel intense lethargy.")
					to_chat(user, "[target] will not be able to resist much more.")
					target.Slowdown(30)
				if(91 to INFINITY)
					to_chat(target, span_userdanger("You can't take it anymore. Your legs give out as you collapse into a long slumber."))
					to_chat(user, "[target] is mine now.")
					target.eyesclosed = TRUE //You're pretty much FUCKED at this point, we make it obvious
					target.become_blind("eyelids")
					if(target.hud_used)
						for(var/atom/movable/screen/eye_intent/eyet in target.hud_used.static_inventory)
							eyet.update_icon(target)
					target.Slowdown(50)
					addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living, Sleeping), 1 MINUTES), 5 SECONDS)
			continue

		if(!powerful)
			var/holypower = target.get_skill_level(/datum/skill/magic/holy)
			var/magicpower = target.get_skill_level(/datum/skill/magic/arcane)
			var/roll = roll(1 + holypower + magicpower, 5)
			if(roll > bloodroll)
				to_chat(target, "I sense fell, mind-altering magicks emanate from [user], but I remain steadfast.")

		to_chat(user, span_userdanger("I fail to ensnare the mind of [target]!"))
