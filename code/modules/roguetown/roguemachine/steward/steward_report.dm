/obj/item/paper/steward_report
	name = "steward's morning report"
	desc = "A crisply-stamped sheet summarising yesternight's dispatches to the Nerve Master. Meant for the Steward's eyes on rising."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "scroll"
	info = ""
	resistance_flags = FIRE_PROOF

/// Called at the end of SSeconomy.daily_tick. Prints a report onto the Nerve Master's tile.
/// `diff` is a /list produced by SSeconomy across the tick; see build_steward_report_body.
/proc/print_steward_report(list/diff)
	if(!diff)
		return
	var/obj/structure/roguemachine/steward/nm = SStreasury?.steward_machine
	if(!nm)
		return
	var/turf/drop = get_turf(nm)
	if(!drop)
		return
	var/obj/item/paper/steward_report/R = new(drop)
	R.info = build_steward_report_body(diff)
	R.update_icon()
	playsound(drop, 'sound/misc/coindispense.ogg', 40, FALSE, -1)

/proc/build_steward_report_body(list/diff)
	var/list/events_fired = diff["events_fired"]
	var/list/events_expired = diff["events_expired"]
	var/list/blockades_fired = diff["blockades_fired"]
	var/list/blockades_cleared = diff["blockades_cleared"]
	var/list/banditry_lines = diff["banditry_drain_lines"]
	var/banditry_total = diff["banditry_drain_total"] || 0
	var/banditry_burned = diff["banditry_drain_burned"] || 0
	var/banditry_debt_accrued = diff["banditry_drain_accrued_debt"] || 0
	var/orders_rolled = diff["orders_rolled"] || 0
	var/urgent_rolled = diff["urgent_rolled"] || 0
	var/day = diff["day"] || GLOB.dayspassed

	var/body = "<center><b>STEWARD'S MORNING REPORT</b></center><br>"
	body += "<center><i>Day [day]</i></center><br><hr>"

	if(length(blockades_fired))
		body += "<b>New blockades:</b><br>"
		for(var/line in blockades_fired)
			body += "&nbsp;&nbsp;- [line]<br>"
		body += "<br>"
	if(length(blockades_cleared))
		body += "<b>Blockades lifted:</b><br>"
		for(var/line in blockades_cleared)
			body += "&nbsp;&nbsp;- [line]<br>"
		body += "<br>"
	if(length(events_fired))
		body += "<b>New economic events:</b><br>"
		for(var/line in events_fired)
			body += "&nbsp;&nbsp;- [line]<br>"
		body += "<br>"
	if(length(events_expired))
		body += "<b>Events returned to normal:</b><br>"
		for(var/line in events_expired)
			body += "&nbsp;&nbsp;- [line]<br>"
		body += "<br>"
	if(banditry_total > 0)
		body += "<b>Financial losses from banditry:</b> <font color='#c44'>-[banditry_total]m</font><br>"
		for(var/line in banditry_lines)
			body += "&nbsp;&nbsp;- [line]<br>"
		if(banditry_debt_accrued > 0)
			body += "<i>Treasury could not absorb the full hit. <font color='#c44'>[banditry_debt_accrued]m</font> accrued as banditry debt: future inflow shall be skimmed against it until paid. ([banditry_burned]m drawn from purse, [banditry_debt_accrued]m owed.)</i><br>"
		body += "<br>"
	if(orders_rolled)
		body += "<b>Standing orders posted this morning:</b> [orders_rolled]"
		if(urgent_rolled)
			body += " ([urgent_rolled] urgent)"
		body += "<br><br>"
	if(!length(blockades_fired) && !length(blockades_cleared) && !length(events_fired) && !length(events_expired) && !orders_rolled && banditry_total <= 0)
		body += "<i>The roads are quiet. No shipment was disturbed overnight.</i><br>"

	body += "<hr><center><i>Consult the Contract Ledger to commission a response.</i></center>"
	return body
