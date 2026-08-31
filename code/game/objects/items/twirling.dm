/*
TWIRL CODE
*/

/obj/item
	/// Skill level needed to twirl this safely. Falsy means it can't be twirled at all.
	var/twirly
	var/twirl_speed = 4
	var/fumble_chance = 40
	var/twirl_verb = "twirl"
	var/twirl_cmode = FALSE
	var/twirl_sound = 'sound/foley/equip/swordsmall1.ogg'
	/// TRUE while a spin visual stands in for our static in-hand overlay.
	var/inhand_spinning = FALSE
	/// Store the viscontent to cut spins short.
	var/atom/movable/flick_visual/spin_visual

	COOLDOWN_DECLARE(twirl_cooldown)

/obj/item/rmb_self(mob/user, keybind = FALSE)
	. = ..()
	try_twirl(user)

/obj/item/proc/try_twirl(mob/living/user)
	if(!twirly || !isliving(user))
		return FALSE
	if(twirl_cmode && !user.cmode)
		return FALSE
	if(wielded || altgripped)
		balloon_alert(user, "one-handed only!")
		return FALSE
	if(!COOLDOWN_FINISHED(src, twirl_cooldown))
		return FALSE
	COOLDOWN_START(src, twirl_cooldown, 3 SECONDS)

	SpinAnimation(twirl_speed, 1)
	if(iscarbon(user))
		var/mob/living/carbon/twirler = user
		twirler.start_spin(src, twirl_speed)

	if((user.get_wskill(src) < twirl_skill_needed()) && prob(fumble_chance))
		twirl_fumble(user)
	else
		twirl_success(user)
	return TRUE

/obj/item/proc/twirl_skill_needed()
	return twirly

/obj/item/proc/twirl_success(mob/living/user)
	user.visible_message(
		span_notice("[user] twirls [src] in a dramatic flourish!"),
		span_notice("You twirl [src] dramatically."),
	)
	playsound(src, twirl_sound, 20, FALSE)

/obj/item/proc/twirl_fumble(mob/living/user)
	user.visible_message(
		span_danger("While trying to [twirl_verb] [src] [user] drops it instead!"),
		span_userdanger("While trying to [twirl_verb] [src] you drop it instead!"),
	)
	user.apply_damage(force, BRUTE, pick(BODY_ZONE_PRECISE_L_FOOT, BODY_ZONE_PRECISE_R_FOOT))
	user.dropItemToGround(src, TRUE)

/obj/item/proc/twirl_fumble_bonk(mob/living/user, fumble_sound = 'sound/misc/bonk.ogg')
	var/crit = prob(60)
	var/critmsg = " <span class='crit'><b>Critical hit!</b> [user] is knocked out!</span>"
	user.visible_message(
		span_danger("While trying to [twirl_verb] [src] [user] flings it instead, hitting [user.p_themselves()] in the head![crit ? critmsg : ""]"),
		span_userdanger("While trying to [twirl_verb] [src] you fling it instead, hitting yourself in the head![crit ? critmsg : ""]"),
	)
	user.apply_damage(force, BRUTE, BODY_ZONE_PRECISE_SKULL)
	if(crit)
		user.flash_fullscreen("whiteflash3")
		user.Unconscious(5 SECONDS)
		playsound(get_turf(user), 'sound/combat/tf2crit.ogg', 100, FALSE)
	playsound(get_turf(user), fumble_sound, 100, FALSE)
	user.dropItemToGround(src, TRUE)
