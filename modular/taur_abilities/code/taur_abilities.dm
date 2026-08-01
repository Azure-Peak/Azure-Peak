// Taur lower-body abilities, ported from Emerald Summit PR #167 (drider tweaks + venom to lamia
// & drider).
//
// ES hangs these off standalone Drider and Lamia species. Valmorian Isle has no such species -
// a drider here is any character wearing the taur/spider lower body (Beastvolk, Godtouched and
// dark elves all offer it via allowed_taur_types), and a lamia is taur/lamia. So the abilities
// live on the bodypart instead of the species: they follow the lower body, which means a
// surgically swapped or amputated taur body takes its abilities with it.

/// Trait source for anything granted by a taur lower body.
#define TAUR_BODY_TRAIT "taur_body"

/obj/item/bodypart/taur
	/// Traits granted to the owner while this lower body is attached.
	var/list/granted_traits
	/// Spell type granted to the owner while this lower body is attached.
	var/granted_spell
	/// Natural armor placed in the owner's skin_armor slot while this lower body is attached.
	/// null = bare hide, which is what the plain hoofed taur bodies get.
	var/leg_armor_type

/obj/item/bodypart/taur/lamia
	granted_traits = list(TRAIT_VENOMOUS, TRAIT_TAIL_KICK)
	leg_armor_type = /obj/item/clothing/suit/roguetown/armor/regenerating/skin/lamia_legs

/obj/item/bodypart/taur/spider
	granted_traits = list(TRAIT_VENOMOUS, TRAIT_WEBWALK)
	granted_spell = /obj/effect/proc_holder/spell/self/weaveweb
	leg_armor_type = /obj/item/clothing/suit/roguetown/armor/regenerating/skin/lamia_legs/drider

/obj/item/bodypart/taur/attach_limb(mob/living/carbon/C, special)
	. = ..()
	if(!. || !owner)
		return
	for(var/trait in granted_traits)
		ADD_TRAIT(owner, trait, TAUR_BODY_TRAIT)
	// Guard against a double grant - fully_heal and species changes can re-attach the same body.
	if(granted_spell && !owner.HasSpell(granted_spell))
		owner.AddSpell(new granted_spell)
	if(leg_armor_type && ishuman(owner))
		var/mob/living/carbon/human/H = owner
		// Only claim an empty slot. Gnoll hide and werewolf pelt also live in skin_armor, and
		// clobbering one of those would quietly delete a whole transformation's armor.
		if(!H.skin_armor)
			H.skin_armor = new leg_armor_type(H)

/obj/item/bodypart/taur/drop_limb(special)
	var/mob/living/carbon/was_owner = owner
	. = ..()
	if(!was_owner)
		return
	for(var/trait in granted_traits)
		REMOVE_TRAIT(was_owner, trait, TAUR_BODY_TRAIT)
	if(granted_spell)
		was_owner.RemoveSpell(granted_spell)
	// Strip the natural armor with the limb, so it can't persist onto ordinary legs attached later.
	if(leg_armor_type && ishuman(was_owner))
		var/mob/living/carbon/human/H = was_owner
		if(istype(H.skin_armor, leg_armor_type))
			qdel(H.skin_armor)
			H.skin_armor = null

// Natural lower-body armor, ported from ES's /armor/skin_armor/lamian_legs. VI has no skin_armor
// base - the equivalent here is /armor/regenerating/skin, which already supplies TRAIT_NODROP on
// Initialize and qdel-on-drop, so ES's Initialize/dropped overrides aren't needed.
//
// ES had to list TAIL_LAMIA in body_parts_covered because its zone2covered() matched the tail's own
// zone against that flag. VI needs no equivalent: get_best_worn_armor() remaps BODY_ZONE_TAUR onto a
// leg zone before it checks coverage, so FEET|LEGS already catches hits landing on the lower body.
/obj/item/clothing/suit/roguetown/armor/regenerating/skin/lamia_legs
	slot_flags = null
	name = "scaled tail"
	desc = ""
	icon_state = null
	body_parts_covered = FEET|LEGS
	body_parts_inherent = FEET|LEGS
	// Translated from ES's raw 0-100 scale (90/90/50/20) onto VI's tiers, matching the harpy's
	// feet skin: strong against blunt and slash, middling stab, poor against piercing, no fire.
	armor = list("blunt" = DR_SUPER, "slash" = DBLOCK_HEAVY, "stab" = DBLOCK_MEDIUM, "piercing" = DBLOCK_LIGHT, "fire" = DR_NONE)
	prevent_crits = list(BCLASS_CUT, BCLASS_CHOP, BCLASS_STAB, BCLASS_BLUNT, BCLASS_TWIST) //inert for now - nothing reads this var yet, it's ES-port scaffolding
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	sewrepair = FALSE
	max_integrity = 125
	resistance_flags = FIRE_PROOF
	// Must be set: the base regenerates 20% of max per repair_time, and a null interval would make
	// addtimer fire on the next tick and spam the mend messages.
	repair_time = 30 SECONDS

// Deliberately no ..() - the parent deconstructs the obj, and this skin has to survive at 0
// integrity so it can regrow. get_best_worn_armor() already skips armor at 0, so it stops
// protecting in the meantime.
/obj/item/clothing/suit/roguetown/armor/regenerating/skin/lamia_legs/obj_destruction(damage_flag)
	visible_message("The scaled hide is torn!", span_bloody("<b>THE SCALES ON MY TAIL ARE TORN!!</b>"))

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/lamia_legs/drider
	name = "chitinous legs"

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/lamia_legs/drider/obj_destruction(damage_flag)
	visible_message("The chitin cracks!", span_bloody("<b>THE CHITIN ON MY LEGS CRACKS!!</b>"))

#undef TAUR_BODY_TRAIT
