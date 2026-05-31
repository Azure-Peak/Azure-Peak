/datum/noticeboard_posting
	var/posting_id
	var/tier
	var/title
	var/body
	var/poster_name
	var/poster_title
	var/truename
	var/poster_job
	var/posted_at
	var/expiry_timer_id
	var/signature_attested

/datum/noticeboard_posting/New(tier, title, body, poster_name, poster_title, truename, poster_job)
	src.tier = tier
	src.title = title
	src.body = body
	src.poster_name = poster_name
	src.poster_title = poster_title
	src.truename = truename
	src.poster_job = poster_job
	src.posted_at = world.time
	src.posting_id = "[world.time]_[ref(src)]"
	src.signature_attested = (poster_name == truename) && (poster_title == poster_job)

/datum/noticeboard_posting/Destroy()
	if(expiry_timer_id)
		deltimer(expiry_timer_id)
		expiry_timer_id = null
	return ..()

/proc/noticeboard_get_list_for_tier(tier)
	switch(tier)
		if(POSTING_TIER_NOTICE)
			return GLOB.noticeboard_notices
		if(POSTING_TIER_LISTING)
			return GLOB.noticeboard_listings
	return null

/proc/noticeboard_find_post_by_truename(tier, truename)
	var/list/target = noticeboard_get_list_for_tier(tier)
	if(!target)
		return null
	for(var/datum/noticeboard_posting/P in target)
		if(P.truename == truename)
			return P
	return null

/proc/noticeboard_find_post_by_id(posting_id)
	for(var/datum/noticeboard_posting/P in GLOB.noticeboard_notices)
		if(P.posting_id == posting_id)
			return P
	for(var/datum/noticeboard_posting/P in GLOB.noticeboard_listings)
		if(P.posting_id == posting_id)
			return P
	return null

/proc/noticeboard_add_posting(tier, title, body, poster_name, poster_title, mob/living/carbon/human/poster)
	if(!poster || !ishuman(poster))
		return null
	if(tier != POSTING_TIER_NOTICE && tier != POSTING_TIER_LISTING)
		return null
	var/list/target_list = noticeboard_get_list_for_tier(tier)
	if(!target_list)
		return null
	var/datum/noticeboard_posting/existing = noticeboard_find_post_by_truename(tier, poster.real_name)
	if(existing)
		noticeboard_remove_posting(existing)
	var/datum/noticeboard_posting/new_post = new(tier, title, body, poster_name, poster_title, poster.real_name, poster.job)
	target_list += new_post
	if(tier == POSTING_TIER_NOTICE)
		new_post.expiry_timer_id = addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(noticeboard_remove_posting), new_post), NOTICEBOARD_NOTICE_LIFETIME, TIMER_STOPPABLE)
	noticeboard_broadcast_post_change(poster)
	return new_post

/proc/noticeboard_remove_posting(datum/noticeboard_posting/post)
	if(!post)
		return
	var/list/target_list = noticeboard_get_list_for_tier(post.tier)
	if(target_list)
		target_list -= post
	qdel(post)
	noticeboard_broadcast_post_change()

/proc/noticeboard_broadcast_post_change(mob/excluding)
	var/turf/excluding_turf = excluding ? get_turf(excluding) : null
	for(var/obj/structure/roguemachine/noticeboard/board in SSroguemachine.noticeboards)
		board.update_icon()
		SStgui.update_uis(board)
		if(excluding_turf && get_dist(board, excluding_turf) <= 1)
			continue
		playsound(board, 'sound/ambience/noises/birds (7).ogg', 50, FALSE, -1)
		board.visible_message(span_smallred("A ZAD lands, delivering a new posting!"))
