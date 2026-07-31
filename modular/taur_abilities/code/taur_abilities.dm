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

/obj/item/bodypart/taur/lamia
	granted_traits = list(TRAIT_VENOMOUS)

/obj/item/bodypart/taur/spider
	granted_traits = list(TRAIT_VENOMOUS, TRAIT_WEBWALK)
	granted_spell = /obj/effect/proc_holder/spell/self/weaveweb

/obj/item/bodypart/taur/attach_limb(mob/living/carbon/C, special)
	. = ..()
	if(!. || !owner)
		return
	for(var/trait in granted_traits)
		ADD_TRAIT(owner, trait, TAUR_BODY_TRAIT)
	// Guard against a double grant - fully_heal and species changes can re-attach the same body.
	if(granted_spell && !owner.HasSpell(granted_spell))
		owner.AddSpell(new granted_spell)

/obj/item/bodypart/taur/drop_limb(special)
	var/mob/living/carbon/was_owner = owner
	. = ..()
	if(!was_owner)
		return
	for(var/trait in granted_traits)
		REMOVE_TRAIT(was_owner, trait, TAUR_BODY_TRAIT)
	if(granted_spell)
		was_owner.RemoveSpell(granted_spell)

#undef TAUR_BODY_TRAIT
