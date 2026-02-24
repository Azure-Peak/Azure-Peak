/mob/proc/lord_marriage_choice()
	
	var/datum/job/suitor_job = SSjob.GetJob("Suitor")

	if (suitor_job.total_positions > 0) //Safety for if the duke far travels and another duke replaces them.
		return

	if(!client)
		addtimer(CALLBACK(src, PROC_REF(lord_marriage_choice)), 50)
		return
	var/marriage_choice = list("dismissed (Suitors Disabled)","welcome (Suitors Enabled)")
	var/choice = input(src, "Suitors are...", "ROGUETOWN - Suitor Options") as anything in marriage_choice
	switch(choice)
		if("welcome (Suitors Enabled)")
			suitor_job.total_positions = 2
			suitor_job.spawn_positions = 2
