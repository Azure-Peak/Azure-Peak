/obj/item/book/granter/arcane_aspect
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "scrollpurple"
	oneuse = TRUE
	drop_sound = 'sound/foley/dropsound/paper_drop.ogg'
	pickup_sound = 'sound/blank.ogg'
	var/aspect_key
	var/aspect_value = 1

/obj/item/book/granter/arcane_aspect/already_known(mob/user)
	if(!HAS_TRAIT(user, TRAIT_ARCYNE))
		to_chat(user, span_warning("I don't understand what any of this means."))
		return TRUE
	if(!LAZYLEN(user.mind?.mage_aspect_config))
		to_chat(user, span_warning("I lack the training to absorb this."))
		return TRUE
	return ..()

/obj/item/book/granter/arcane_aspect/on_reading_finished(mob/user)
	if(!aspect_key)
		return
	if(!LAZYLEN(user.mind?.mage_aspect_config))
		return
	user.mind.mage_aspect_config[aspect_key] += aspect_value
	to_chat(user, span_notice("I feel my arcyne conduits expand as the scroll's power flows through me!"))
	user.mind.check_learnspell()
	onlearned(user)

/obj/item/book/granter/arcane_aspect/onlearned(mob/living/carbon/user)
	..()
	if(oneuse)
		name = "siphoned scroll"
		desc = "A scroll once inscribed with magical scripture. The surface is now barren of knowledge, siphoned by someone else. It's utterly useless."
		icon_state = "scroll"
		user.visible_message(span_warning("[src] has had its magic ink ripped from the scroll!"))

/obj/item/book/granter/arcane_aspect/utility
	name = "Scroll of Temporal Cantrip Enhancing"
	desc = "A scroll inscribed with rune words that temporarily expands one's arcyne conduits, enabling attunement to more cantrips and utility spells."
	icon_state = "scrollpurple"
	aspect_key = "utilities"
	aspect_value = 3

/obj/item/book/granter/arcane_aspect/minor
	name = "Scroll of Temporal Minor Arcyne Enhancing"
	desc = "A scroll inscribed with powerful rune words that temporarily expands one's arcyne conduits, enabling attunement to an additional minor aspect."
	icon_state = "scrollpurple"
	aspect_key = "minor"
	aspect_value = 1

/obj/item/book/granter/arcane_aspect/major
	name = "Scroll of Temporal Greater Arcyne Enhancing"
	desc = "A scroll inscribed with potent rune words that temporarily expands one's arcyne conduits, enabling attunement to an additional major aspect."
	icon_state = "scrollred"
	aspect_key = "major"
	aspect_value = 1

/obj/item/book/granter/arcane_aspect/mastery
	name = "Scroll of Temporal Arcyne Mastery"
	desc = "A scroll inscribed with ancient rune words of tremendous power. It expands one's arcyne conduits to their absolute limit, granting mastery over attuned aspects and an additional major aspect."
	icon_state = "scrollred"
	aspect_key = "major"
	aspect_value = 1

/obj/item/book/granter/arcane_aspect/mastery/on_reading_finished(mob/user)
	if(!LAZYLEN(user.mind?.mage_aspect_config))
		return
	user.mind.mage_aspect_config["major"] += 1
	user.mind.mage_aspect_config["mastery"] = TRUE
	to_chat(user, span_notice("I feel my arcyne conduits expand as the scroll's power flows through me!"))
	user.mind.check_learnspell()
	// Call granter onlearned directly, skip parent on_reading_finished to avoid double-granting major
	onlearned(user)
