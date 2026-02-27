/obj/effect/proc_holder/spell/targeted/touch/lesserknock
	name = "Lesser Knock"
	desc = "A simple spell used to focus the arcyne into an instrument for lockpicking. Can be dispelled by using it on anything that isn't a locked/unlocked door."
	clothes_req = FALSE
	drawmessage = "I prepare to perform a minor arcyne incantation."
	dropmessage = "I release my minor arcyne focus."
	school = "transmutation"
	overlay_state = "rune4"
	chargedrain = 0
	chargetime = 0
	releasedrain = 5 // this influences -every- cost involved in the spell's functionality, if you want to edit specific features, do so in handle_cost
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	hand_path = /obj/item/melee/touch_attack/lesserknock
	spell_tier = 1
	invocations = list("Parvus Pulso")
	invocation_type = "whisper" // It is a fake stealth spell (lockpicking is very loud)
	hide_charge_effect = TRUE
	cost = 2 // Utility and needs lockpicking skills

/obj/item/melee/touch_attack/lesserknock
	name = "Spectral Lockpick"
	desc = "A faintly glowing lockpick that appears to be held together by the mysteries of the arcyne. To dispel it, simply use it on anything that isn't a door."
	catchphrase = null
	possible_item_intents = list(/datum/intent/use)
	icon = 'icons/roguetown/items/keys.dmi'
	icon_state = "lockpick"
	color = "#3FBAFD" // spooky magic blue color that's also used by presti
	picklvl = 0.99
	max_integrity = 30
	destroy_sound = 'sound/items/pickbreak.ogg'
	resistance_flags = FIRE_PROOF

/obj/item/melee/touch_attack/lesserknock/attack_self()
	qdel(src)
