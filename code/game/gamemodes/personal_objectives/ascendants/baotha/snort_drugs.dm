/datum/objective/snort_drugs
	name = "Snort Drugs"
	triumph_count = 0
	var/sniff_count = 0
	var/required_count = 2

/datum/objective/snort_drugs/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(owner.current, COMSIG_DRUG_SNIFFED, PROC_REF(on_drug_sniffed))
	update_explanation_text()

/datum/objective/snort_drugs/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_DRUG_SNIFFED)
	return ..()

/datum/objective/snort_drugs/proc/on_drug_sniffed(datum/source, mob/living/sniffer)
	SIGNAL_HANDLER
	if(completed)
		return

	sniff_count++
	if(sniff_count >= required_count)
		to_chat(owner.current, span_greentext("You have snorted enough drugs to complete Baotha's objective!"))
		owner.current.adjust_triumphs(1)
		completed = TRUE
		adjust_storyteller_influence("Baotha", 10)
		escalate_objective()
		UnregisterSignal(owner.current, COMSIG_DRUG_SNIFFED)
	else
		to_chat(owner.current, span_notice("Drug snorted! Snort [required_count - sniff_count] more to complete Baotha's objective."))

/datum/objective/snort_drugs/update_explanation_text()
	explanation_text = "Snort [required_count] drugs for Baotha's pleasure!"
