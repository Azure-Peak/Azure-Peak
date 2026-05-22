/datum/action/cooldown/spell/fridigitation
	button_icon = 'icons/mob/actions/mage_cryomancy.dmi'
	name = "Fridigitation"
	desc = "An advanced version of Chill Food.\n\
	Greatly prolongs shelf life by entirely freezing it solid\n\
	(OOC Note: it does not work on produce, only foods, removes rot timer entirely.)."
	fluff_desc = "A recent improvement on the ancient cantrip 'Chill Food'. During one of the many famines in Grenzelhoft, \
	the Celestial Academy looked to improve the widely used 'Chill Food' cantrip. After a multi-year espionage campaign against \
	the Etrusia Merchantile Guild and their Wyzards (and a brief trade embargo on Apfelweinheim trade to Kazengun by the Etruscan Merchantile Guild), \
	the Celestial Academy managed to recreate and improve upon 'Greater Chill Food' (Now named Fridigitation). The effects of 'Fridigitation' are quite simple, \
	the food is deeply frozen to the point of being neigh rock-solid, however its shelf life (if properly maintained) can last for many years. \
	The benifits to this have come at a cost which Wyzards are still looking to improve upon, the effect labled 'fridgid burn' \
	causes some foods to lose most (if not all) flavor, fruits/produce/ingredients are heavily effected."
	button_icon_state = "fridigitation"
	sound = 'sound/misc/bamf.ogg'
	spell_color = GLOW_COLOR_ICE
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = TRUE
	self_cast_possible = FALSE
	cast_range = 5

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CANTRIP

	invocations = list("Clamor glacialis!") // Icy Scream/Cry (get it, ice scream, ice cream.)
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = CHARGETIME_POKE
	cooldown_time = 30 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE

	point_cost = 2

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/fridigitation/cast(atom/cast_on, mob/user = usr)
	. = ..()
	if(istype(cast_on, /obj/item/reagent_containers/food/snacks/rogue))
		var/obj/item/reagent_containers/food/snacks/rogue/F = cast_on
		var/turf/T = get_turf(F)
		F.rotprocess = null
		F.add_filter("fridigitation_glow", 2, list("type" = "outline", "color" = "#87CEEB", "alpha" = 150, "size" = 1))
		if(T)
			var/mutable_appearance/chilly = mutable_appearance('icons/effects/effects.dmi', "mist", layer = 10)
			T.add_overlay(chilly)
			addtimer(CALLBACK(T, TYPE_PROC_REF(/atom, cut_overlay), chilly), 1 SECONDS)
		to_chat(user, "The [F.name] is frozen, greatly extending its shelf life.")
		F.name = "[F.name] (frozen)"
		return TRUE
	else
		to_chat(user, span_warning("That is not a valid target for Fridigitation."))
		return FALSE
