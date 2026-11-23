// Mapfetchable sell prices
#define LEYLINE_SELLPRICE 30
#define VOIDSTONE_SELLPRICE 40

// Magical resources for the Ratwood ported Mage Gameplay Loop system
// Chose to not use /natural typepath because it didn't make much sense and this
// Let me use another .dmi
/obj/item/magic
	name = "magic resource"
	desc = "You shouldn't be seeing this."
	icon = 'icons/roguetown/items/magic_resources.dmi'
	resistance_flags = FIRE_PROOF
	w_class = WEIGHT_CLASS_TINY
	grid_width = 32
	grid_height = 32
	var/tier = 0 //used for determining potency for mob healing
	dropshrink = 0.85

/obj/item/magic/familiar
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/mob/living/carbon/human/species/familiar/stored_familiar

/obj/item/magic/familiar/dropped(mob/user, silent)
	. = ..()
	if(stored_familiar)
		stored_familiar.reset_perspective()

// vestige - needed to revive a familiar. sort of like a carbon's head, but magic-style
/obj/item/magic/familiar/familiar_vestige
	name = "Planar Vestige"
	icon_state = "abberant"
	desc = "The vestige of a planar creature, departed from this plane. Likely worth a lot to the magos that summoned them!"

//mapfetchable items
/obj/item/magic/obsidian
	name = "obsidian fragment"
	icon = 'icons/obj/shards.dmi'
	icon_state = "obsidian"
	desc = "Volcanic glass cooled from molten lava rapidly."
	sellprice = 0

/obj/item/magic/leyline
	name = "leyline shards"
	icon_state = "leyline"
	desc = "A shard of a fractured leyline, it glows with lost power."
	sellprice = LEYLINE_SELLPRICE

/obj/item/reagent_containers/food/snacks/grown/manabloom
	name = "mana bloom"
	icon_state = "manabloom"
	desc = "Dense mana that has taken the form of plant life."
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head_items.dmi'
	seed = /obj/item/herbseed/manabloom
	resistance_flags = FLAMMABLE
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	body_parts_covered = NONE
	alternate_worn_layer	= 8.9
	materia = list(/datum/materia_aspect/arcyne, /datum/materia_aspect/herb)

/obj/item/magic/manacrystal
	name = "crystalized mana"
	icon_state = "manacrystal"
	desc = "A crystal made of mana, woven into an artifical structure."
	w_class = WEIGHT_CLASS_SMALL

/obj/item/magic/artifact
	name = "runed artifact"
	icon_state = "runedartifact"
	desc = "An old stone from age long ago, marked with glowing sigils."
	w_class = WEIGHT_CLASS_SMALL
	dropshrink = 0.8

/obj/item/magic/artifact/Initialize(mapload)
	.=..()
	var/list/listy = list("runedartifact", "runedartifact1")
	var/newicon = pick(listy)
	icon_state = newicon

/obj/item/magic/voidstone
	name = "voidstone"
	icon_state = "voidstone"
	desc = "A piece of blackstone, it feels off to stare at it for long."
	w_class = WEIGHT_CLASS_SMALL
	sellprice = VOIDSTONE_SELLPRICE

// INFERNAL
/obj/item/magic/infernal
	w_class = WEIGHT_CLASS_SMALL

/obj/item/magic/infernal/examine(mob/user)
	. = ..()
	. += span_notice("It can be used to heal Infernal summons.")


/obj/item/magic/infernal/ash//T1 mage summon loot
	name = "infernal ash"
	icon_state = "infernalash"
	desc = "Ash burnt and burnt once again. Smells of brimstone and hellfire. Still has embers within."
	tier = 1

/obj/item/magic/infernal/fang//T2 mage summon loot
	name = "hellhound fang"
	icon_state = "hellhound_fang"
	desc = "A sharp fang that glows bright red, no matter how long it's left to cool."
	tier = 2

/obj/item/magic/infernal/core// T3 mage summon loot
	name = "infernal core"
	icon_state = "infernal_core"
	desc = "A molten orb of rock and magick. It gives off waves of magical heat and energy."
	tier = 3

/obj/item/magic/infernal/flame//T4 mage summon loot
	name = "abyssal flame"
	icon_state = "abyssalflame"
	desc = "A	flickering, black flame contained in a crystal; the heart of an archfiend. Or atleast, what passes for one. It pulses with dense thrums of magick."
	tier = 4

//FAIRY
/obj/item/magic/fae
	w_class = WEIGHT_CLASS_SMALL
	tier = 1

/obj/item/magic/fae/examine(mob/user)
	. = ..()
	. += span_notice("It can be used to heal Fae summons.")

/obj/item/magic/fae/fairydust	//T1 mage summon loot
	name = "fairy dust"
	icon_state = "fairy_dust"
	desc = "A glittering powder from a fae sprite."
	tier = 1

/obj/item/magic/fae/iridescentscale	//T2 mage summon loot
	name = "iridescent scales"
	icon_state = "iridescent_scale"
	desc = "Tiny, colorful scales from a glimmerwing, they shine with inate magic"
	tier = 2

/obj/item/magic/fae/heartwoodcore	//T3 mage summon loot
	name = "heartwood core"
	icon_state = "heartwood_core"
	desc = "A piece of enchanted wood imbued with the dryad’s essence. Merely holding it transports one's mind to ancient times."
	tier = 3

/obj/item/magic/fae/sylvanessence	//T4 mage summon loot
	name = "sylvan essence"
	icon_state = "sylvanessence"
	desc = "A swirling, multicolored liquid with emitting a dizzying array of lights."
	tier = 4

//ELEMENTAL
/obj/item/magic/elemental
	w_class = WEIGHT_CLASS_SMALL

/obj/item/magic/elemental/examine(mob/user)
	. = ..()
	. += span_notice("It can be used to heal Elemental summons.")

/obj/item/magic/elemental/mote
	name = "elemental mote"
	icon_state = "mote"
	desc = "A mystical essence imbued with the power of Dendor. Merely holding it transports one's mind to ancient times."
	tier = 1

/obj/item/magic/elemental/shard
	name = "elemental shard"
	icon_state = "shard"
	desc = "A mystical essence imbued with the power of Dendor. Merely holding it transports one's mind to ancient times."
	tier = 2

/obj/item/magic/elemental/fragment
	name = "elemental fragment"
	icon_state = "fragment"
	desc = "A mystical essence imbued with the power of Dendor. Merely holding it transports one's mind to ancient times."
	tier = 3

/obj/item/magic/elemental/relic
	name = "elemental relic"
	icon_state = "relic"
	desc = "A mystical essence imbued with the power of Dendor. Merely holding it transports one's mind to ancient times."
	tier = 4

// now this might look like a lot. however, these items all come at a cost, namely an antagonistic force is possessing them and will possess YOU if you use them
// so it's really not all that insane considering; more of an enabler for cursed object stories than a meta thing
/obj/item/cursed_item_spawner
	name = "shimmering relic"
	desc = "A strange item whose form cannot quite be discerned. It pulses with an ominous power, as if inviting you to pick it up and claim its power for your own."
	icon = 'icons/roguetown/items/magic_resources.dmi'
	icon_state = "abberant"
	resistance_flags = FIRE_PROOF
	w_class = WEIGHT_CLASS_TINY
	grid_width = 32
	grid_height = 32
	var/obj/item/form // type path not instance
	var/static/list/transformation_options = list( // a few notably good/popular weapons, a staff, non-secret stat ring, or chest armor for each of the 3 armor classes. feel free to add to this!
		/obj/item/rogueweapon/sword/long::name = /obj/item/rogueweapon/sword/long,
		/obj/item/rogueweapon/sword/rapier::name = /obj/item/rogueweapon/sword/rapier,
		/obj/item/rogueweapon/sword/sabre::name = /obj/item/rogueweapon/sword/sabre,
		/obj/item/rogueweapon/halberd::name = /obj/item/rogueweapon/halberd,
		/obj/item/rogueweapon/woodstaff/implement/grand::name = /obj/item/rogueweapon/woodstaff/implement/grand,
		/obj/item/clothing/ring/statamythortz::name = /obj/item/clothing/ring/statamythortz,
		/obj/item/clothing/ring/statgemerald::name = /obj/item/clothing/ring/statgemerald,
		/obj/item/clothing/ring/statonyx::name = /obj/item/clothing/ring/statonyx,
		/obj/item/clothing/ring/statrontz::name = /obj/item/clothing/ring/statrontz,
		/obj/item/clothing/suit/roguetown/armor/plate/full/fluted::name = /obj/item/clothing/suit/roguetown/armor/plate/full/fluted,
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted::name = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted,
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer::name = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer,
	)
	examine_highlight_severity = EXAMINEHIGHLIGHT_HERESYSEVERITY_ODD
	examine_highlight_desc = "It beckons with a strange malice, inspiring a palpable feeling of unease."

/obj/item/cursed_item_spawner/Initialize(mapload)
	. = ..()
	filters += filter(type = "drop_shadow", x=0, y=0, size=1, offset = 2, color = PATRON_COLOR_VHESLYN)

/obj/item/cursed_item_spawner/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/unsellable, "radiates foreboding power") // just in case. this is a very-limited avenue for ghostmobs we don't want people rushing it and RRing it

/obj/item/cursed_item_spawner/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Right-click this item in your hand to select what form the relic will take, then left-click to awaken its power. From stat rings to weapons and armor, it can be quite a boon.")
	. += span_info("However, such power comes at a price. Something malevolent dwells within that may threaten to overtake you.")

/obj/item/cursed_item_spawner/attack_self(mob/user)
	if(!ishuman(user) || isfamiliar(user)) // nuh uh
		to_chat(user, "The relic rejects me!")
		return FALSE
	var/mob/living/carbon/human/H = user
	if(!form)
		to_chat(user, span_warning("You need to identify the relic before you can awaken it!"))
		return ..()
	to_chat(user, span_notice("You attempt to awaken the relic's power..."))
	var/mob/living/carbon/human/species/familiar/infernal/inhabitant = awaken_familiar(user, FAMILIAR_PLANE_INFERNAL, "cursed [form::name]", null) // we put the familiar in nullspace TEMPORARILY because they should not be visible to the user for a moment lmao; they get moved inside the relic during the component init
	if(!inhabitant)
		to_chat(user, span_warning("...but it remains silent. Perhaps an attempt later would bear more fruit?"))
		return ..()
	var/obj/item/relic = new form(user.drop_location())
	var/datum/component/possessed_item/P = relic.AddComponent(/datum/component/possessed_item, inhabitant, PATRON_COLOR_VHESLYN, EXAMINEHIGHLIGHT_HERESYSEVERITY_ODD, HERESYDESC_INFERNAL_PASSIVE, EXAMINEHIGHLIGHT_HERESYSEVERITY_SUSPICIOUS, HERESYDESC_INFERNAL_ACTIVE, TRUE, FALSE, /mob/living/carbon/human/proc/toggle_infernal_armor, FALSE)
	user.dropItemToGround(src, TRUE, TRUE)
	user.put_in_hands(relic)
	var/datum/action/cooldown/spell/cursed_item_possession/spell = new
	spell.relic = relic
	inhabitant.mind.RemoveSpell(/datum/action/cooldown/spell/infernal_possession)
	inhabitant.mind.AddSpell(spell)
	inhabitant.RegisterSignal(relic, COMSIG_OBJ_DECONSTRUCT, TYPE_PROC_REF(/mob/living/carbon/human/species/familiar/infernal, relic_destroyed))
	inhabitant.RegisterSignal(P, COMSIG_QDELETING, TYPE_PROC_REF(/mob/living/carbon/human/species/familiar/infernal, relic_unpossess))
	// tutorial GO
	to_chat(inhabitant, span_notice("I am an infernal, bound within this relic by a longago magos. Long have I rested within these rotting halls, before being found by [H.get_unmasked_name()], who has foolishly unleashed my power..."))
	to_chat(inhabitant, span_notice("I am not obligated to obey [H.get_unmasked_name()]. If their goals align with mine, I will help them; if not, I may hinder them. I am only bound by my own malice, and the limits of my power. I should remember that I am weak, ultimately; I will have a much easier time of things if my bearer trusts me."))
	to_chat(inhabitant, span_notice("I am still bound to this relic, more or less. If it is damaged, I will be fine, but if it is destroyed entirely I will be irrevocably banished from whence I came. I can break free for a time by resisting (X by default), but doing so puts my true body at risk. My relic grants a boon to its bearer: it will [isstatring(relic) ? "increase their basal attributes" : (isweapon(relic) ? "drain the lyfe of those struck" : "retaliate with flames when they are struck")]."))
	to_chat(inhabitant, span_notice("Whispering while in relic-form will project my voice into the mind of my bearer. I can possess my bearer (which needs not be the one that freed me...), though I will need their consent until they use me for some time. While I am possessing them, their body will feel no pain and fear no exsanguination, but silver will harm us both. Once [isweapon(relic) ? "they strike someone with me" : (relic.has_armor_value()?"I protect them from a blow":"they begin wearing me")], my power over them will begin to grow; this will be interrupted and reset should they drop me. I will know when it is done. Once the possession is broken - either by me releasing them, them resisting and some time passing, or me being removed from their person - I will need to wait some time before I can possess them again."))

	qdel(src)
	return TRUE

/obj/item/cursed_item_spawner/rmb_self(mob/user)
	if(!ishuman(user) || isfamiliar(user)) // nuh uh
		to_chat(user, "The relic rejects me!")
		return ..()
	var/mob/living/carbon/human/H = user
	var/had_form = form
	var/choice = tgui_input_list(H, "What manner of relic is this?", "WHISPERS OF POWER", transformation_options)
	if(!choice) // again should only happen if they DC while doing this
		return ..()
	form = transformation_options[choice]
	to_chat(H, span_notice("[had_form?"I was wrong, before; it's clearly":"Ah, of course! It's"] \a [form::name]!"))
	desc = "A strange [form::name]. It whispers promises of power, begging to be awakened..." // convey this step is done
	return TRUE

#undef LEYLINE_SELLPRICE
#undef VOIDSTONE_SELLPRICE
