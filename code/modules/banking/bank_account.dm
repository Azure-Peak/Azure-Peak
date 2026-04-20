/datum/bank_account
	var/mob/living/owner
	var/owner_name
	var/balance = 0
	var/created_at

/datum/bank_account/New(mob/living/new_owner, starting_balance = 0)
	. = ..()
	owner = new_owner
	owner_name = new_owner.real_name
	balance = starting_balance
	created_at = world.time

/datum/bank_account/Destroy()
	owner = null
	return ..()
