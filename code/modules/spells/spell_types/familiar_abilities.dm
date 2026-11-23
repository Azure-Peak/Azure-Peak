/datum/action/cooldown/spell/message_familiar
	name = "Message Familiar"
	desc = "Whisper a message in your Familiar's head, or track their vestige if they lie slain."
	button_icon_state = "message"

	click_to_activate = FALSE
	self_cast_possible = TRUE
	charge_required = FALSE
	cooldown_time = 1 SECONDS

	primary_resource_type = SPELL_COST_NONE
	spell_requirements = NONE
	spell_impact_intensity = SPELL_IMPACT_NONE

/datum/action/cooldown/spell/message_familiar/cast(atom/cast_on)
	. = ..()
	var/mob/living/user = owner
	if(!istype(user))
		return FALSE
	var/mob/living/carbon/human/species/familiar/familiar
	for(var/mob/living/carbon/human/species/familiar/familiar_check in GLOB.human_list)
		if(familiar_check.familiar_summoner == user)
			familiar = familiar_check
	if(!familiar || !familiar.mind)
		to_chat(user, "You cannot sense your familiar's mind.")
		return FALSE
	if(familiar.stat == DEAD)
		// they're dead; track the vestige
		return track_vestige(user,familiar)
	var/message = sanitize(input(user, "You make a connection. What are you trying to say?"))
	if(!message)
		return FALSE
	to_chat_immediate(familiar, "Arcane whispers fill the back of my head, resolving into [user]'s voice: <font color=#7246ff>[message]</font>")
	user.visible_message("[user] mutters an incantation and their mouth briefly flashes white.")
	user.whisper(message, language = /datum/language/common)
	log_game("[key_name(user)] sent a message to [key_name(familiar)] with contents [message]")
	return TRUE

/datum/action/cooldown/spell/message_familiar/proc/track_vestige(mob/living/user, mob/living/carbon/human/species/familiar/fam)
	user.visible_message(span_notice("[user] closes [user.p_their()] eyes and reaches out through the veil..."), span_notice("I close my eyes and attune to the flow of the veil..."))
	if(!do_after(user, 2 SECONDS, target = user))
		to_chat(user, span_warning("Your concentration breaks."))
		return FALSE

	var/user_z = user.z
	var/obj/item/magic/familiar/familiar_vestige/vestige = fam.loc
	if(!istype(vestige))
		to_chat(user, span_warning("The familiar is not within their vestige. This should not happen!"))
	var/dist = get_dist(user, vestige)
	var/direction = dir2text(get_dir(user, vestige))
	var/same_z = vestige.z==user.z
	if(!direction)
		direction = "beneath you"
	else
		direction = "to the [direction]"
	if(!same_z)
		if(vestige.z > user_z)
			direction += ", above you"
		else
			direction += ", below you"
	if(dist <= 3)
		to_chat(user, span_info("You sense your familiar's vestige - right beside you."))
	else if(dist <= 30)
		to_chat(user, span_info("You sense your familiar's vestige - [direction], not far."))
	else if(dist <= 100)
		to_chat(user, span_info("You sense your familiar's vestige - [direction], some distance away."))
	else
		to_chat(user, span_info("You sense your familiar's vestige - [direction], far away."))
	return TRUE

/datum/action/cooldown/spell/message_summoner
	name = "Message Summoner"
	desc = "Whisper a message in your Summoner's head."
	button_icon_state = "message"

	click_to_activate = FALSE
	self_cast_possible = TRUE
	charge_required = FALSE
	cooldown_time = 1 SECONDS

	primary_resource_type = SPELL_COST_NONE
	spell_requirements = NONE
	spell_impact_intensity = SPELL_IMPACT_NONE

/datum/action/cooldown/spell/message_summoner/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/species/familiar/user = owner
	if(!istype(user))
		return FALSE

	var/mob/living/summoner = user.familiar_summoner

	if(!summoner || !isliving(summoner) || !summoner.mind)
		to_chat(user, span_warning("You cannot sense your summoner's mind."))
		return FALSE

	var/message = sanitize(input(user, "You make a connection. What are you trying to say?"))
	if(!message)
		return FALSE
	to_chat_immediate(summoner, "Arcane whispers fill the back of my head, resolving into [user.real_name]'s voice: <font color=#7246ff>[message]</font>")
	user.visible_message("[user.name] mutters an incantation and their mouth briefly flashes white.")
	user.whisper(message, language = /datum/language/common)
	log_game("[key_name(user)] sent a message to [key_name(summoner)] with contents [message]")
	return TRUE

/datum/action/cooldown/spell/rootcheck
	name = "Nature's Bounty"
	desc = "Invigorate the lyfe in a small area, causing hidden roots to bear fruit instantly."
	button_icon_state = "ensnare"

	click_to_activate = TRUE
	self_cast_possible = TRUE
	charge_required = TRUE
	charge_time = 1 SECONDS
	cooldown_time = 10 MINUTES

	primary_resource_type = SPELL_COST_NONE
	spell_requirements = NONE
	spell_impact_intensity = SPELL_IMPACT_NONE

	var/static/list/rootpool = list( // basically most crops, including poison berries. also a few alchemically-useful things. and junk items to make it less useful
		/obj/item/natural/fibers,
		/obj/item/grown/log/tree/stick,
		/obj/item/natural/thorn,
		/obj/item/natural/chaff/wheat, // what, you thought it'd be usable? nah you have to shuck that yourself, it's freshly-grown
		/obj/item/natural/chaff/oat,
		/obj/item/natural/chaff/rice,
		/obj/item/reagent_containers/food/snacks/grown/maize,
		/obj/item/reagent_containers/food/snacks/grown/apple,
		/obj/item/reagent_containers/food/snacks/grown/fruit/pear,
		/obj/item/reagent_containers/food/snacks/grown/fruit/lemon,
		/obj/item/reagent_containers/food/snacks/grown/fruit/lime,
		/obj/item/reagent_containers/food/snacks/grown/fruit/tangerine,
		/obj/item/reagent_containers/food/snacks/grown/fruit/plum,
		/obj/item/reagent_containers/food/snacks/grown/fruit/strawberry,
		/obj/item/reagent_containers/food/snacks/grown/fruit/blackberry,
		/obj/item/reagent_containers/food/snacks/grown/fruit/raspberry,
		/obj/item/reagent_containers/food/snacks/grown/fruit/tomato,
		/obj/item/reagent_containers/food/snacks/grown/nut,
		/obj/item/reagent_containers/food/snacks/grown/sugarcane,
		/obj/item/reagent_containers/food/snacks/grown/vegetable/turnip,
		/obj/item/reagent_containers/food/snacks/grown/sunflower,
		/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius,
		/obj/item/reagent_containers/food/snacks/grown/rogue/swampweed,
		/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweed,
		/obj/item/reagent_containers/food/snacks/grown/onion/rogue,
		/obj/item/reagent_containers/food/snacks/grown/cabbage/rogue,
		/obj/item/reagent_containers/food/snacks/grown/potato/rogue,
		/obj/item/reagent_containers/food/snacks/grown/garlick/rogue,
		/obj/item/reagent_containers/food/snacks/grown/rogue/poppy,
		/obj/item/reagent_containers/food/snacks/grown/coffee,
		/obj/item/reagent_containers/food/snacks/grown/tea,
		/obj/item/reagent_containers/food/snacks/grown/carrot,
		/obj/item/reagent_containers/food/snacks/grown/cucumber,
		/obj/item/reagent_containers/food/snacks/grown/eggplant,
		/obj/item/reagent_containers/food/snacks/grown/berries/rogue,
		/obj/item/reagent_containers/food/snacks/grown/berries/rogue/poison,
		/obj/item/alch/atropa, // herbs, synergizes with fae brew and makes the food potential less strong
		/obj/item/alch/matricaria,
		/obj/item/alch/symphitum,
		/obj/item/alch/taraxacum,
		/obj/item/alch/euphrasia,
		/obj/item/alch/paris,
		/obj/item/alch/calendula,
		/obj/item/alch/mentha,
		/obj/item/alch/urtica,
		/obj/item/alch/salvia,
		/obj/item/alch/hypericum,
		/obj/item/alch/benedictus,
		/obj/item/alch/valeriana,
		/obj/item/alch/artemisia,
		/obj/item/alch/rosa,
		/obj/item/reagent_containers/food/snacks/grown/manabloom,
	)

/datum/action/cooldown/spell/rootcheck/cast(atom/cast_on)
	. = ..()
	var/turf/target = get_turf(cast_on)
	target.visible_message(span_notice("Hidden roots tremble underfoot as crops flourish before your very eyes, bursting through the ground!"))
	if(!target)
		return FALSE
	for(var/i in 1 to 3)
		var/obj/item/path = pick(rootpool)
		new path(target)

/datum/action/cooldown/spell/invisibility/fae
	name = "Fey Shroud"
	desc = "Cloak yourself, blending into the surroundings. Attacking, being attacked, or casting another ability will break your stealth."
	click_to_activate = FALSE

/datum/action/cooldown/spell/fae_brew
	name = "Alchemical Stomach"
	desc = "Toggle your brewing ability; while enabled, and you have a stock of reagents inside yourself, you will attempt to brew them into a potion using your summoner's alchemical skill. Click yourself (or have someone else click you) with reagents to add them, or empty hand to remove them."
	button_icon_state = "create_campfire"

	click_to_activate = FALSE
	self_cast_possible = TRUE
	charge_required = FALSE
	cooldown_time = 1 SECONDS

	primary_resource_type = SPELL_COST_NONE
	spell_requirements = NONE
	spell_impact_intensity = SPELL_IMPACT_NONE

/datum/action/cooldown/spell/fae_brew/cast(mob/living/carbon/human/species/familiar/fae/user)
	. = ..()
	if(!istype(user))
		return FALSE
	user.should_brew = !user.should_brew
	return TRUE

/datum/action/cooldown/spell/projectile/fetch/fae
	name = "Grasp of Nature"
	desc = "Shoot out a grasping vine that draws in a freestanding item towards the caster. Doesn't work on living targets."
	invocations = list("Recolligere silva")

/datum/action/cooldown/spell/reagent_bite
	name = "Alchemical Bite" // placeholder
	desc = "Bite a target, delivering a 5-dram dose of whatever is in your stomach. Cast on a reagent container to transfer its contents into your stomach, or fill it if it's empty. You can also drink from containers directly to similar effect."
	cast_range  = 1
	cooldown_time = 10 SECONDS
	button_icon = 'icons/mob/actions/mage_hex.dmi'
	button_icon_state = "wither"

	cooldown_time = 1 SECONDS

	primary_resource_type = SPELL_COST_NONE
	spell_requirements = NONE
	spell_impact_intensity = SPELL_IMPACT_NONE

/datum/action/cooldown/spell/reagent_bite/cast(atom/target)
	. = ..()
	var/mob/living/carbon/human/species/familiar/fae/user = owner
	if(!istype(user))
		return
	if(!user || !user.reagents) // literally how
		return FALSE
	if(!(isliving(target) || target.is_refillable()) || !target.reagents)
		to_chat(user, span_notice("I need to select a valid target to bite!"))
		return FALSE
	if(!isliving(target))
		if(user.reagents.total_volume && (!target.reagents.holder_full()))
			user.visible_message(
				span_notice("[user.name] gently bites the top of [target], filling it with an alchemical cocktail..."),
				span_notice("You gently bite the top of [target], filling it with your alchemical cocktail...")
			)
			// we're not biting a mob, so we can loop for convenience
			while(do_after(user, 1 SECONDS, FALSE, target) && user.reagents.trans_to(target, 5, transfered_by = user))
				user.visible_message(
					span_notice("[user.name] fills [target] with more of [user.p_their()] alchemical cocktail..."),
					span_notice("You fill [target] with more of your alchemical cocktail...")
				)
			user.visible_message(
				span_notice("[user.name] lets go of [target]."),
				span_notice("You let go of [target].")
			)
			return TRUE
		else if(target.reagents.total_volume && (!user.reagents.holder_full())) // suckle it up!
			user.visible_message(
				span_notice("[user.name] latches onto [target], beginning to drink..."),
				span_notice("You latch onto [target], and begin to drink...")
			)
			// we're not biting a mob, so we can loop for convenience
			while(do_after(user, 1 SECONDS, FALSE, target) && target.reagents.trans_to(user, 5, transfered_by = user))
				user.visible_message(
					span_notice("[user.name] drinks from [target]..."),
					span_notice("You drink from [target]...")
				)
			user.visible_message(
				span_notice("[user.name] lets go of [target]."),
				span_notice("You let go of [target].")
			)
			return TRUE
		return FALSE

	var/mob/living/living_target = target
	user.visible_message(
		span_notice("[user.name] attempts to bite [living_target.name]!"),
		span_notice("You attempt to bite [living_target.name]...")
	)
	// same do_after time and transfer amount as just walking up with a bottle and feeding them
	if(do_mob(user, living_target, time = 5 SECONDS, double_progress = TRUE, can_move = FALSE) && user.reagents.trans_to(living_target, 5, transfered_by = user))
		user.visible_message(
			span_notice("[user.name] bites [living_target.name], delivering a dose of an alchemical cocktail!"),
			span_notice("You bite [living_target.name], delivering a dose of your alchemical cocktail!")
		)
		if(living_target.show_redflash())
			living_target.flash_fullscreen("redflash3")
		playsound(living_target, 'sound/combat/hits/bladed/genstab (1).ogg', 100, FALSE, -1)
		return TRUE

/datum/action/cooldown/spell/incendiary_bite
	name = "Incendiary Bite"
	desc = "Bite a target, engulfing them in infernal flame."
	cast_range = 1
	cooldown_time = 10 SECONDS
	charge_required = FALSE
	button_icon = 'icons/mob/actions/mage_pyromancy.dmi'
	button_icon_state = "spitfire"

/datum/action/cooldown/spell/incendiary_bite/cast(atom/target)
	. = ..()
	if(!owner) // literally how
		return FALSE
	if(!target)
		to_chat(owner, span_notice("I need to select a valid target to bite!"))
		return FALSE
	if(!istype(target))
		return FALSE
	target.fire_act(1,10) // shouldn't be oppressive by any means it's 1 stack every 10 seconds

// unlike the more complex infernal possession spell this doesn't let you choose your target
/datum/action/cooldown/spell/cursed_item_possession
	name = "Relic Possession"
	desc = "Returns me to my relic form."
	button_icon = 'icons/mob/actions/actions_cult.dmi'
	button_icon_state = "hand"
	spell_color = PATRON_COLOR_VHESLYN
	glow_intensity = GLOW_INTENSITY_LOW
	charge_required = FALSE
	cooldown_time = 1 MINUTES // leaves you reasonably vulnerable; SHOULDN'T be abusable??
	var/obj/item/relic

/datum/action/cooldown/spell/cursed_item_possession/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/species/familiar/H = owner
	if(!istype(H))
		return FALSE
	if(!relic) // huh? whuh?
		to_chat(H, "My bond with that relic was severed somehow! I am free!") // this should only happen if the item gets like, qdel'd by an admin or something
		H.mind.AddSpell(new /datum/action/cooldown/spell/infernal_possession)
		H.mind.RemoveSpell(src)
	relic.forceMove(H.drop_location()) // it's stored INSIDE us when we unpossess it! so take it out first to avoid recursing
	var/datum/component/possessed_item/P = relic.AddComponent(/datum/component/possessed_item, H, PATRON_COLOR_VHESLYN, EXAMINEHIGHLIGHT_HERESYSEVERITY_ODD, HERESYDESC_INFERNAL_PASSIVE, EXAMINEHIGHLIGHT_HERESYSEVERITY_SUSPICIOUS, HERESYDESC_INFERNAL_ACTIVE, TRUE, FALSE, /mob/living/carbon/human/proc/toggle_infernal_armor, FALSE)
	H.RegisterSignal(P, COMSIG_QDELETING, TYPE_PROC_REF(/mob/living/carbon/human/species/familiar/infernal, relic_unpossess))
	return TRUE

// cosmetic resprite
/obj/item/rogueweapon/sword/long/infernal
	name = "infernal blade"
	desc = "A sinister blade of hellish origin, its wicked edge thirsts for blood. It was clearly crafted by no human hands, yet it is well-balanced."
	icon_state = "blksword"
	secondary_skills = list(/datum/skill/combat/arcyne = 1) // swords and arc armament at equal scaling

/datum/action/cooldown/spell/infernal_possession
	name = "Infernal Possession"
	desc = "Possess armor, a ring, an amulet, or a weapon; change modes to instead conjure a potent—but obviously suspicious—staff or sword and possess that instead. Items you possess will have their power increased in a small way: blades will gain a lyfesteal effect, worn items (except stat-rings) will retaliate with fire when struck. While inside, whispering will project your voice directly into your bearer's mind. Resist to cancel the possession. Items you possess will be visibly odd. While possessing a wielded weapon or worn clothing/armor, whisper to speak directly into the mind of your bearer. Should they allow it, you can possess your bearer outright; you'll be able to use their skills, spells, and traits while you do, and the item housing you will become obviously suspicious. While you possess them, their body will feel no pain and fear no exsanguination, but will be harmed by silver. If they've used your power (hitting someone with you as a weapon, or blocking a hit with you as armor/clothing), you don't need their consent to possess them; however, if they resist, you will be on a time limit, after which you will be unable to possess them again for some time. While listening to them may be wise, it is by no means mandatory."
	button_icon = 'icons/mob/actions/actions_cult.dmi'
	button_icon_state = "hand"
	spell_color = PATRON_COLOR_VHESLYN
	glow_intensity = GLOW_INTENSITY_LOW
	cooldown_time = 10 MINUTES // once you're out, you're exposed for a good while. note that this cooldown starts once you LEAVE the form, not on possess
	charge_required = TRUE
	charge_time = 1 SECONDS
	modes = list(
		list("tag" = "", "name" = "Possess"),
		list("tag" = "STAFF", "name" = "Staff"),
		list("tag" = "BLADE", "name" = "Blade"),
	)

/datum/action/cooldown/spell/infernal_possession/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/species/familiar/H = owner
	if(!istype(H))
		return FALSE
	var/obj/item/target = cast_on
	var/conjure = (current_mode != 1)
	if(current_mode == 2)
		target = new /obj/item/rogueweapon/woodstaff/implement/greater/infernal(get_turf(H))
	else if(current_mode == 3)
		target = new /obj/item/rogueweapon/sword/long/infernal(get_turf(H))
	if(!target || !istype(target)) // we cast on nothing, or on something that isn't an item/ourselves. either way we can't move forward
		return FALSE
	if(target.is_silver || target.is_lesser_silver)
		to_chat(H, span_warning("\The [target]'s purity rebukes me! I cannot possess it..."))
		return FALSE
	if(target.GetComponent(/datum/component/magic_item))
		to_chat(H, span_warning("The arcyne energies embedded in [target] rebuke me!"))
		return FALSE
	if(target.GetComponent(/datum/component/possessed_item))
		to_chat(H, span_warning("[target] is already possessed!"))
		return FALSE
	if(target.GetComponent(/datum/component/cursed_item))
		to_chat(H, span_warning("Divine energy repulses me... [target] already bears a curse, it cannot contain me as well."))
		return FALSE
	if(istype(target, /obj/item/rogueweapon/sword/long/judgement/vlord)) // why the FUCK does this reimplement the cursed item component's functionality without actually having a cursed item component
		to_chat(H, span_warning("Divine energy repulses me... [target] already bears a curse, it cannot contain me as well."))
		return FALSE
	if(target.GetComponent(/datum/component/conjured_item))
		to_chat(H, span_warning("I should not possess something so ephemeral."))
		return FALSE
	// not a weapon, not an amulet/ring, and not armor
	if(!istype(target, /obj/item/rogueweapon) && !istype(target, /obj/item/clothing/ring) && !istype(target, /obj/item/clothing/neck/roguetown/psicross) && !target.has_armor_value())
		to_chat(H, span_warning("I can only possess weapons, armor, rings, and amulets."))
		return FALSE
	// it's that easy. all the logic for this is actually in the possessed item component
	var/datum/component/possessed_item/P = target.AddComponent(/datum/component/possessed_item, H, spell_color, conjure ? EXAMINEHIGHLIGHT_HERESYSEVERITY_SUSPICIOUS : EXAMINEHIGHLIGHT_HERESYSEVERITY_ODD, conjure ? HERESYDESC_INFERNAL_PASSIVE_OBVIOUS : HERESYDESC_INFERNAL_PASSIVE, EXAMINEHIGHLIGHT_HERESYSEVERITY_SUSPICIOUS, HERESYDESC_INFERNAL_ACTIVE, TRUE, conjure, /mob/living/carbon/human/proc/toggle_infernal_armor, TRUE, span_boldwarning("Infernal flames emanate from $src, flowing into $bearer... their eyes flash with new malice!"))
	if(P)
		RegisterSignal(P, COMSIG_QDELETING, PROC_REF(handle_cooldown))
	return FALSE // we don't want the CD to start until we get in the item

/datum/action/cooldown/spell/infernal_possession/proc/handle_cooldown()
	StartCooldown(get_adjusted_cooldown())

/datum/action/cooldown/spell/magicians_stone/elemental
	name = "Create Stone"
	fluff_desc = ""

/obj/item/rogueweapon/woodstaff/implement/greater/elemental
	name = "\improper Staff of the Binder"
	base_implement_name = "\improper Bound Staff" // will become "Bound Staff of Frost" etc
	desc = "A mage's staff crowned with the spirit-gem of a familiar. The gem captures excess energy dissipated into the air when a spell is cast, giving a generous share of it back to the wielder."
	icon_state = "sapphirestaff"
	gem_socketable = FALSE
	implement_upgradable = FALSE

/obj/item/rogueweapon/woodstaff/implement/greater/infernal // note that this is not marked as heretical here: it can only be summoned via the infernal possession spell, which adds a possessed item component to it - which marks it heretical. fancy that
	name = "\improper Staff of the Daemonbinder"
	base_implement_name = "\improper Infernal Staff" // "Infernal Staff of Flame" etc
	desc = "A mage's staff that shimmers with eternal malice. It is perpetually warm to the touch; holding it inspires an urge to unleash one's most powerful magic. Merely a touch from it is enough to spark flame. It captures excess energy dissipated into the air when a spell is cast, giving a generous share of it back to the wielder."
	icon_state = "rubystaff"
	gem_socketable = FALSE
	implement_upgradable = FALSE
	var/sparkcd = 0

/obj/item/rogueweapon/woodstaff/implement/greater/infernal/afterattack(atom/movable/A, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	if(world.time < sparkcd + 10)
		return
	sparkcd = world.time
	playsound(user, 'sound/items/flint.ogg', 100, FALSE)

	if (ismob(A))
		A.spark_act()
	else
		A.fire_act(3,3)
	user.flash_fullscreen("whiteflash")
	to_chat(user, span_notice("\The [src] produces an igniting spark!"))

/datum/action/cooldown/spell/earthen_forge
	name = "Earthen Forge"
	desc = "Shape your earthen form into a tool or weapon. When the item breaks, you will revert to your original form. Resist to manually revert."

	button_icon = 'icons/mob/actions/mage_conjure.dmi'
	button_icon_state = "arcyne_forge"
	spell_color = GLOW_COLOR_METAL
	glow_intensity = GLOW_INTENSITY_LOW
	attunement_school = ASPECT_NAME_FERRAMANCY

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CONJURE
	var/list/conjure_options = list(
		// Staff
		"Staff of the Binder" = /obj/item/rogueweapon/woodstaff/implement/greater/elemental,
		// Weapons
		"Short Sword" = /obj/item/rogueweapon/sword/short/iron,
		"Hunting Sword" = /obj/item/rogueweapon/sword/short/messer/iron,
		"Arming Sword" = /obj/item/rogueweapon/sword/iron,
		"Cudgel" = /obj/item/rogueweapon/mace/cudgel,
		"Warhammer" = /obj/item/rogueweapon/mace/warhammer,
		"Dagger" = /obj/item/rogueweapon/huntingknife/idagger,
		"Flail" = /obj/item/rogueweapon/flail,
		"Whip" = /obj/item/rogueweapon/whip,
		"Wooden Shield" = /obj/item/rogueweapon/shield/wood,
		// Tools
		"Axe" = /obj/item/rogueweapon/stoneaxe/woodcut,
		"Pickaxe" = /obj/item/rogueweapon/pick,
		"Hoe" = /obj/item/rogueweapon/hoe,
		"Thresher" = /obj/item/rogueweapon/thresher,
		"Sickle" = /obj/item/rogueweapon/sickle,
		"Pitchfork" = /obj/item/rogueweapon/pitchfork,
		"Tongs" = /obj/item/rogueweapon/tongs,
		"Hammer" = /obj/item/rogueweapon/hammer/iron,
		"Shovel" = /obj/item/rogueweapon/shovel,
		"Handsaw" = /obj/item/rogueweapon/handsaw,
		"Scissors" = /obj/item/rogueweapon/huntingknife/scissors,
		"Fishing Rod" = /obj/item/fishingrod,
		"Frying Pan" = /obj/item/cooking/pan,
		"Pot" = /obj/item/reagent_containers/glass/bucket/pot,
		"Bowl" = /obj/item/reagent_containers/glass/bowl,
		"Fork" = /obj/item/kitchen/fork/iron,
		"Spoon" = /obj/item/kitchen/spoon/iron,
		"Chisel Set" = /obj/item/rogueweapon/chisel/assembly/arcyne,
		"Needle" = /obj/item/needle
	)
	cooldown_time = 30 SECONDS

	charge_required = TRUE
	charge_time = 2 SECONDS
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/charging.ogg'

	var/obj/conjured_item

/datum/action/cooldown/spell/earthen_forge/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/species/familiar/H = owner
	if(!istype(H))
		return FALSE

	// We're an item. Stop being an item.
	if(conjured_item && !QDELETED(conjured_item))
		revert()
		return FALSE // we don't want to add a cooldown for this case
	else if (!isturf(H.loc))
		return FALSE // no casting this from the orb

	var/choice
	if(length(conjure_options) > 1)
		choice = tgui_input_list(H, "Choose what to conjure", name, conjure_options)
	else
		choice = conjure_options[1]

	if(!choice)
		return FALSE

	var/item_path = conjure_options[choice]
	var/obj/R = new item_path(H.drop_location())
	var/obj/item/I = R

	R.obj_integrity = R.max_integrity
	owner.status_flags |= GODMODE
	if(isitem(R))
		// Mark as conjured — no salvage, no smelting
		I.smeltresult = null
		I.salvage_result = null
		I.fiber_salvage = FALSE

		// Conjured glow
		I.AddComponent(/datum/component/conjured_item, GLOW_COLOR_EARTHEN, do_not_decay = TRUE)
	RegisterSignal(R, COMSIG_ITEM_BROKEN, PROC_REF(revert))
	RegisterSignal(H, COMSIG_LIVING_RESIST, PROC_REF(revert))
	RegisterSignal(R, COMSIG_ITEM_DROPPED, PROC_REF(revert_perspective))
	H.forceMove(R)
	conjured_item = R
	H.reset_perspective(R)
	R.become_hearing_sensitive()
	H.update_cone_show()
	return TRUE

/datum/action/cooldown/spell/earthen_forge/proc/revert_perspective()
	owner.reset_perspective()
	owner.update_cone_show()

/datum/action/cooldown/spell/earthen_forge/proc/revert()
	if(conjured_item)
		owner.forceMove(get_turf(owner))
		owner.status_flags &= ~GODMODE
		owner.update_cone_show()
		QDEL_NULL(conjured_item)

/obj/structure/arcyne_wall/greater/elemental
	desc = "The mason did an excellent job etching details into this wall."
	name = "decorated stone wall"
	icon_state = "decostone-b"
	icon = 'icons/turf/roguewall.dmi'
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'

/datum/action/cooldown/spell/earthen_forge/wall
	name = "Wall Forme"
	desc = "Become a bulwark, drawing earth into yourself to block off a passage. None shall proceed while you yet stand."

	conjure_options = list(
		"Wall" = /obj/structure/arcyne_wall/greater/elemental,
	)

/datum/action/cooldown/spell/earthen_forge/void // lmao
	name = "Void Forge"
	desc = "Shape your ever-malleable form into a tool or weapon. When the item breaks, you will revert to your original form. Resist to manually revert."

/datum/action/cooldown/spell/arcyne_forge/elementalt2
	name = "Greater Earthen Shaping"
	desc = "Shape a weapon or tool of your choice out of raw earth. Conjured items have halved durability.\n\
	Only one conjured item can exist at a time - conjuring a new one destroys the old."
	charge_required = TRUE
	conjure_options = list(
		// Weapons
		"Short Sword" = /obj/item/rogueweapon/sword/short/iron,
		"Hunting Sword" = /obj/item/rogueweapon/sword/short/messer/iron,
		"Arming Sword" = /obj/item/rogueweapon/sword/iron,
		"Cudgel" = /obj/item/rogueweapon/mace/cudgel,
		"Warhammer" = /obj/item/rogueweapon/mace/warhammer,
		"Dagger" = /obj/item/rogueweapon/huntingknife/idagger,
		"Flail" = /obj/item/rogueweapon/flail,
		"Whip" = /obj/item/rogueweapon/whip,
		"Wooden Shield" = /obj/item/rogueweapon/shield/wood,
		// Tools
		"Axe" = /obj/item/rogueweapon/stoneaxe/woodcut,
		"Pickaxe" = /obj/item/rogueweapon/pick,
		"Hoe" = /obj/item/rogueweapon/hoe,
		"Thresher" = /obj/item/rogueweapon/thresher,
		"Sickle" = /obj/item/rogueweapon/sickle,
		"Pitchfork" = /obj/item/rogueweapon/pitchfork,
		"Tongs" = /obj/item/rogueweapon/tongs,
		"Hammer" = /obj/item/rogueweapon/hammer/iron,
		"Shovel" = /obj/item/rogueweapon/shovel,
		"Handsaw" = /obj/item/rogueweapon/handsaw,
		"Scissors" = /obj/item/rogueweapon/huntingknife/scissors,
		"Fishing Rod" = /obj/item/fishingrod,
		"Frying Pan" = /obj/item/cooking/pan,
		"Pot" = /obj/item/reagent_containers/glass/bucket/pot,
		"Bowl" = /obj/item/reagent_containers/glass/bowl,
		"Fork" = /obj/item/kitchen/fork/iron,
		"Spoon" = /obj/item/kitchen/spoon/iron,
		"Chisel Set" = /obj/item/rogueweapon/chisel/assembly/arcyne,
		"Needle" = /obj/item/needle
	)
	cooldown_time = 30 SECONDS

/datum/action/cooldown/spell/consume
	name = "Consume"
	desc = "Devour a planar being, feasting on its essences. Eat, and grow strong."
	cast_range = 1
	cooldown_time = 1 MINUTES
	charge_required = FALSE
	button_icon = 'icons/mob/actions/hagspells.dmi'
	button_icon_state = "hand_up"
	var/static/list/consumable = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/fae/sprite,
		/mob/living/simple_animal/hostile/retaliate/rogue/elemental/crawler,
		/mob/living/simple_animal/hostile/retaliate/rogue/infernal/imp,
		/mob/living/carbon/human/species/familiar/void
	)

/datum/action/cooldown/spell/consume/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/species/familiar/void/user = owner
	if(!user) // literally how
		return FALSE
	var/mob/living/target = cast_on
	if(!target || !(target.type in consumable))
		to_chat(user, span_notice("I can't eat that... not yet, at least."))
		return FALSE
	if(!(target.type in consumable))
		to_chat(user, span_notice("I can't eat that... not yet, at least."))
		return FALSE
	if(target.mind) // generally shouldn't be true, but the last thing we want is to delete an admin having a laugh or something
		to_chat(user, span_notice("This one is fully awakened... it will have too tight a grasp on its essence. I must find a mindless power, perhaps my creator can help?"))
		return FALSE
	if(isfamiliar(target)) // can only get here if it's void so
		user.visible_message(
			span_warning("[user] reaches out towards [target]... suddenly, you feel a sense of foreboding!"),
			span_warning("I prepare to devour [target]... this seems like a bad idea, but I am oh so hungry...")
		)
	else
		user.visible_message(
			span_warning("[user] begins to devour [target]!"),
			span_warning("I begin to devour [target]!")
		)
	if(!move_after(user, (isfamiliar(target) ? 5 : 1) SECONDS, target = target))
		return FALSE
	// we have a valid mindless target: let's see if it's actually valid for us
	var/essence_to_grant = null
	if(istype(target, /mob/living/simple_animal/hostile/retaliate/rogue/fae))
		essence_to_grant = "fae"
	else if(istype(target, /mob/living/simple_animal/hostile/retaliate/rogue/infernal))
		essence_to_grant = "infernal"
	else if(istype(target, /mob/living/simple_animal/hostile/retaliate/rogue/elemental))
		essence_to_grant = "elemental"
	else
		// kin... hubris begets hubris, in the end
		for(var/obj/effect/decal/cleanable/roguerune/arcyne/binding/rune in range(target.loc))
			if(rune.busy)
				to_chat(user, span_warning("This one is actively awakening... I am too late?"))
				return FALSE
			rune.summoned_thing = null
		user.visible_message(
			span_warningbig("[user] attempts to consume [target], but as soon as their essences commingle, they annihilate in a violent blast!"),
			span_warningbig("I attempt to consume [target], but as soon as I touch their essences, I am undone!")
		)
		new /obj/effect/temp_visual/dragon_swoop(target.loc)
		playsound(target.loc, 'sound/vo/mobs/vdragon/drgnroar.ogg', 50, TRUE, -1)
		for(var/mob/living/L in orange(1, target))
			if(L == user)
				continue // user will be qdel'd so don't throw them
			L.adjustBruteLoss(75) // this should never kill it's just an "oh fuck" moment
			if(L && !QDELETED(L)) // Some mobs are deleted on death
				var/throw_dir = get_dir(target, L)
				if(L.loc == target.loc)
					throw_dir = pick(GLOB.alldirs)
				L.throw_at(get_edge_target_turf(L,throw_dir), 3, 2)
				L.visible_message(span_warning("[L] is thrown clear of the blast!</span>"))
		for(var/mob/M in range(7, target))
			shake_camera(M, 15, 1)
		user.mind?.RemoveAllSpells()
		user.mind?.unknow_all_people()
		QDEL_NULL(target)
		QDEL_NULL(user)
		return TRUE
	playsound(user, 'sound/gore/flesh_eat_03.ogg', 100, FALSE)
	if(!user.essences_consumed.Find(essence_to_grant))
		user.visible_message(
			span_warning("[user] consumes [target], absorbing their essences!"),
			span_warning("I consume [target]'s essence! I am stronger for it, though I hunger still.")
		)
		user.essences_consumed += essence_to_grant
		user.grant_essence(essence_to_grant)
		if(LAZYLEN(user.essences_consumed) == 3)
			to_chat(user, span_notice("I have consumed the essences of the three planes, and learned much. One dae, I will grow strong enough to consume yet greater beings, but for now, this appears to be my limit. My hunger is mostly sated, for the week; and I gain a new power, to inhabit objects and possess their bearers."))
			user.mind.AddSpell(new /datum/action/cooldown/spell/void_possession)
		for(var/obj/effect/decal/cleanable/roguerune/arcyne/binding/rune in range(target.loc))
			rune.summoned_thing = null
		QDEL_NULL(target)
		return TRUE
	else
		user.visible_message(
			span_warning("[user] consumes [target]... but [user.p_they()] [(user.pronouns == THEY_THEM) ? "don't" : "doesn't"] seem even slightly sated!"),
			span_warning("I consume [target]'s essence, but I have already tasted of it! This will not nourish me anymore, I must find something new to devour.")
		)
		for(var/obj/effect/decal/cleanable/roguerune/arcyne/binding/rune in range(target.loc))
			rune.summoned_thing = null
		QDEL_NULL(target)
		return TRUE

/datum/action/cooldown/spell/void_beam/familiar
	name = "Abberant Beam"
	spell_requirements = SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/projectile/fetch/fae/void
	name = "Grasp of the Void"
	desc = "Grasp a freestanding item with your arcyne power, drawing it towards you. Doesn't work on living targets."
	invocations = list("Nihilo, recolligere")

/datum/action/cooldown/spell/magicians_stone/elemental/void
	name = "Harvest Stone"

// keep in mind this is only accessible to full mages (anyone w/o a major can't summon drakelings) and requires more effort than getting a dorpel normally
/obj/item/rogueweapon/woodstaff/implement/grand/void
	base_implement_name = "Voidbinder's Staff" // "Voidbinder's Staff of Frost"
	name = "Staff of the Voidbinder"
	desc = "A masterwork staff set with an otherworldly focus-gem, which seems to absorb all light. They say an Azurian magos laid the foundations for such a staff's creation, but tragically died before ever wielding one herself. The gem captures excess energy dissipated into the air when a spell is cast, giving most of it back to the wielder - arcyne economy refined to an art."

/datum/action/cooldown/spell/void_possession // stripped down and more innocuous version of infernal possession
	name = "Void Possession"
	desc = "Possess armor, a ring, an amulet, or a weapon, lending it a fragment of your power; resist to cancel the possession. Cast on yourself instead to turn into a particularly effective staff. While possessing a wielded weapon or worn clothing/armor, whisper to speak directly into the mind of your bearer. Should they allow it, you can possess your bearer outright; you'll be able to use their skills, spells, and traits while you do. Your creator remains your creator, however, and you are still bound to obey them - though, of course, nobody said it had to be your creator you possess..."
	spell_color = GLOW_COLOR_ARCANE // todo: maybe add a void glow later? black or green to match the obelisks?
	charge_required = TRUE
	charge_time = 1 SECONDS
	cooldown_time = 5 MINUTES // this one's less nefarious, and as such can be freer
	modes = list(
		list("tag" = "", "name" = "Possess"),
		list("tag" = "STAFF", "name" = "Staff"),
	)

/datum/action/cooldown/spell/void_possession/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/species/familiar/void/H = owner
	if(!istype(H))
		return FALSE
	var/obj/item/target = cast_on
	if(current_mode != 1) // staff mode: summon a staff to possess. unlike an infernal, we're a great product of the arcyne and as such, are a finer staff but with no special effects
		target = new /obj/item/rogueweapon/woodstaff/implement/grand/void(get_turf(H))
	if(!target || !istype(target)) // we cast on nothing, or on something that isn't an item. either way we can't move forward
		return FALSE
	if(target.GetComponent(/datum/component/magic_item)) // i KNOW one of y'all is going to try to be gamer and double enchant
		to_chat(H, span_warning("The arcyne energies embedded into [target] repel me!"))
		return FALSE
	if(target.GetComponent(/datum/component/possessed_item))
		to_chat(H, span_warning("[target] is already possessed!"))
		return FALSE
	if(target.GetComponent(/datum/component/cursed_item))
		to_chat(H, span_warning("Divine energy repulses me... [target] already bears a curse, it cannot contain me as well."))
		return FALSE
	if(istype(target, /obj/item/rogueweapon/sword/long/judgement/vlord)) // why the FUCK does this reimplement the cursed item component's functionality without actually having a cursed item component
		to_chat(H, span_warning("Divine energy repulses me... [target] already bears a curse, it cannot contain me as well."))
		return FALSE
	if(target.GetComponent(/datum/component/conjured_item))
		to_chat(H, span_warning("I should not possess something so ephemeral."))
		return FALSE
	// not a weapon, not an amulet/ring, and not armor
	if(!istype(target, /obj/item/rogueweapon) && !istype(target, /obj/item/clothing/ring) && !istype(target, /obj/item/clothing/neck/roguetown/psicross) && !target.has_armor_value())
		to_chat(H, span_warning("I can only possess weapons, armor, rings, and amulets."))
		return FALSE
	// it's that easy. all the logic for this is actually in the possessed item component
	var/datum/component/possessed_item/P = target.AddComponent(/datum/component/possessed_item, H, spell_color, temp = (current_mode != 1), verbiage = span_warning("Arcyne energies pour from $src into $bearer, their eyes flare with hunger!"))
	if(P)
		RegisterSignal(P, COMSIG_QDELETING, PROC_REF(handle_cooldown))
	return FALSE // we don't want the CD to start until we get in the item

/datum/action/cooldown/spell/void_possession/proc/handle_cooldown()
	StartCooldown(get_adjusted_cooldown())
