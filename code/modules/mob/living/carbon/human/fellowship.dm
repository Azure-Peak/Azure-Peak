/mob/living/carbon/human/verb/fellowship_verb()
	set name = "Fellowship"
	set category = "IC"
	set desc = "Manage your fellowship."
	if(HAS_TRAIT(src, TRAIT_CONJURED_SUMMON))
		to_chat(src, span_warning("A conjured servant cannot lead a fellowship."))
		return
	var/datum/fellowship_ui/ui = new(src)
	ui.ui_interact(src)
