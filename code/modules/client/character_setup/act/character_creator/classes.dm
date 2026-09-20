/datum/preferences/proc/ui_act_character_creator_classes(action, list/params, datum/tgui/ui, datum/ui_state/state)
	var/mob/user = ui.user

	switch(action)
		if("select_joblessrole")
			switch(joblessrole)
				if(RETURNTOLOBBY)
					joblessrole = BERANDOMJOB
				if(BERANDOMJOB)
					joblessrole = RETURNTOLOBBY
			verbose_pref_log_change(user, "notice", "If Role Unavailable", joblessrole == RETURNTOLOBBY ? "Get Random Job" : "Return To Lobby", joblessrole == BERANDOMJOB ? "Get Random Job" : "Return To Lobby")
			return CHARACTER_ACT_DATA_UPDATE
		if("set_job_preference")
			if(SSticker.job_change_locked)
				to_chat(user, span_warning("Try again later, SSticker is busy spawning players."))
				return CHARACTER_ACT_DATA_UPDATE

			var/title = params["job"]
			var/level = params["level"]

			if(level != null && level != JP_LOW && level != JP_MEDIUM && level != JP_HIGH)
				return CHARACTER_ACT_DATA_UPDATE

			if(!istext(title))
				return CHARACTER_ACT_DATA_UPDATE

			var/datum/job/job = SSjob.GetJob(title)
			if(!job)
				return CHARACTER_ACT_DATA_UPDATE

			verbose_pref_log_notification(user, "notice", "[title] preference set to [level == JP_HIGH ? "High" : level == JP_MEDIUM ? "Medium" : level == JP_LOW ? "Low" : "Never"]")
			SetJobPreferenceLevel(job, level)
			return CHARACTER_ACT_DATA_UPDATE // note: change this if we ever readd job clothing preview
		if("subprefs")
			var/title = params["job"]
			if(!istext(title))
				return CHARACTER_ACT_DATA_UPDATE

			var/datum/job/job = SSjob.GetJob(title)
			if(!job || !job.has_subprefs)
				return CHARACTER_ACT_DATA_UPDATE

			job.update_subprefs_window(user)
			return CHARACTER_ACT_DATA_UPDATE
		if("explainjob")
			var/title = params["job"]
			if(!istext(title))
				return CHARACTER_ACT_DATA_UPDATE

			var/datum/job/job = SSjob.GetJob(title)
			if(!job)
				return CHARACTER_ACT_DATA_UPDATE

			job.show_explain(user)
			return CHARACTER_ACT_DATA_UPDATE

/datum/preferences/proc/SetJobPreferenceLevel(datum/job/job, level)
	if (!job)
		return FALSE

	if (level == JP_HIGH) // to high
		//Set all other high to medium
		for(var/j in job_preferences)
			if(job_preferences[j] == JP_HIGH)
				job_preferences[j] = JP_MEDIUM
				//technically break here
		// update topjob
		topjob = job.title
		// for new_player too
		if(isnewplayer(parent))
			var/mob/dead/new_player/N = parent
			N.topjob = job.title

	job_preferences[job.title] = level
	return TRUE

/datum/preferences/proc/ResetJobs()
	job_preferences = list()
	topjob = null
