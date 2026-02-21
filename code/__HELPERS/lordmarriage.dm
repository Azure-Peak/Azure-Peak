/mob/proc/lord_marriage_choice()
	
	var/datum/job/suitor_job = SSjob.GetJob("Suitor")
	var/datum/job/consort_job = SSjob.GetJob("Consort")

	if (consort_job.total_positions > 0 || suitor_job.total_positions > 0) //Safety for if the duke far travels and another duke replaces them.
		return

	if(!client)
		addtimer(CALLBACK(src, PROC_REF(lord_marriage_choice)), 50)
		return
	var/marriage_choice = list("Married (Consort)","Single (Suitors)")
	var/choice = input(src, "I am...", "Marriage Options") as anything in marriage_choice
	switch(choice)
		if("Married (Consort)")
			consort_job.total_positions = 1
			consort_job.spawn_positions = 1
		if("Single (Suitors)")
			suitor_job.total_positions = 3
			suitor_job.spawn_positions = 3
