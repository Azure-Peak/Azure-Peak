/// Residual Focus — a spell implement held during casting leaves a trace of the caster's focus
/// behind, which seeps back as recovered energy over the next few seconds.
/// Duration refreshes on each cast; pool additively grows.
/// Math: per-tick refund = remaining_pool / ticks_remaining. Final tick drains whatever is left,
/// so rounding drift never leaves residue and the pool always fully returns across its duration.
/datum/status_effect/buff/residual_focus
	id = "residual_focus"
	duration = 20 SECONDS
	tick_interval = 1 SECONDS
	status_type = STATUS_EFFECT_REFRESH
	alert_type = /atom/movable/screen/alert/status_effect/buff/residual_focus
	var/pool = 0

/datum/status_effect/buff/residual_focus/on_creation(mob/living/new_owner, added_pool = 0)
	pool = added_pool
	return ..()

/datum/status_effect/buff/residual_focus/refresh(mob/living/new_owner, added_pool = 0)
	pool += added_pool
	return ..()

/datum/status_effect/buff/residual_focus/tick()
	if(pool <= 0 || !owner)
		qdel(src)
		return
	// tick_interval has been mutated to an absolute world.time by base status_effect, so use initial()
	var/ticks_remaining = max(1, round((duration - world.time) / initial(tick_interval)))
	var/refund = pool / ticks_remaining
	pool -= refund
	owner.energy_add(refund)

/atom/movable/screen/alert/status_effect/buff/residual_focus
	name = "Residual Focus"
	desc = "My implement holds a trace of my focus, seeping back as recovered energy."
	icon_state = "buff"

/atom/movable/screen/alert/status_effect/buff/residual_focus/examine_ui(mob/user)
	var/datum/status_effect/buff/residual_focus/effect = attached_effect
	var/list/inspec = list("----------------------")
	inspec += "<br><span class='notice'><b>[name]</b></span>"
	if(desc)
		inspec += "<br>[desc]"
	if(istype(effect))
		inspec += "<br><span class='notice'>Remaining energy to recover: [round(effect.pool, 0.1)]</span>"
	inspec += "<br>----------------------"
	to_chat(user, "[inspec.Join()]")
