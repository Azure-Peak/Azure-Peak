/datum/action/cooldown/spell/form_blade/form_hammer
	name = "Form Hammer"
	desc = "Shape raw mana into a massive arcyne maul, the Grôzehamer. Only one conjured form may exist at a time."
	button_icon = 'icons/mob/actions/mage_ferramancy.dmi'
	button_icon_state = "form_blade"
	shared_cooldown = "form_hammer"
	invocations = list("Forma Der Grôzehamer!!")
	forms = list(
		list("label" = "Grand Maul", "weapon" = /obj/item/rogueweapon/mace/maul/grand/ferramancy, "say" = null),
	)

/obj/item/rogueweapon/mace/maul/grand/ferramancy
	name = "Grôzehamer"
	desc = "A grand maul of condensed arcyne force, conjured from raw mana by a Ferramancer's will."
	color = "#3b5bdb"
	minstr = 0
	unenchantable = TRUE
	anvilrepair = null
	smeltresult = null
	associated_skill = /datum/skill/combat/arcyne
