/**
 * Performance Stress Test
 *
 * Tests the damage overlay system and icon update performance
 * by spawning hundreds of mobs with various wounds, damage states, and clothing
 */

GLOBAL_LIST_EMPTY(stress_test_mobs)

/client/proc/performance_stress_test()
	set name = "Performance Stress Test"
	set category = "Debug"

	if(!check_rights(R_DEBUG))
		return

	var/mob_count = input(usr, "How many test mobs to spawn?", "Stress Test", 300) as num|null
	if(!mob_count || mob_count <= 0)
		return

	var/auto_cleanup = alert(usr, "Automatically delete mobs after test?", "Cleanup", "Yes", "No") == "Yes"

	var/radius = round(sqrt(mob_count) / 2) + 5
	var/turf/center = get_turf(mob)

	if(!center)
		to_chat(src, span_warning("You must be in a valid location to run this test."))
		return

	to_chat(src, span_notice("Starting performance stress test with [mob_count] mobs..."))

	var/list/spawned_mobs = list()
	var/start_time = world.timeofday

	var/spawned = 0
	for(var/x_offset = -radius to radius)
		for(var/y_offset = -radius to radius)
			if(spawned >= mob_count)
				break

			var/turf/spawn_loc = locate(center.x + x_offset, center.y + y_offset, center.z)
			if(!spawn_loc || spawn_loc.density)
				continue

			var/mob/living/carbon/human/species/human/northern/H = new(spawn_loc)
			spawned_mobs += H
			spawned++

			H.gender = prob(50) ? MALE : FEMALE
			if(H.dna)
				H.dna.update_dna_identity()
			H.update_body()
			H.update_hair()

			equip_stress_test_clothing(H)

			apply_random_damage_state(H)

			if(spawned % 50 == 0)
				to_chat(src, span_notice("Spawned [spawned]/[mob_count] test subjects..."))

			CHECK_TICK

	var/spawn_time = world.timeofday - start_time
	to_chat(src, span_notice("Spawned [length(spawned_mobs)] mobs in [spawn_time/10] seconds."))
	to_chat(src, span_notice("Beginning damage update cycles..."))

	addtimer(CALLBACK(src, PROC_REF(stress_test_damage_wave), spawned_mobs, 1), 5 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(stress_test_damage_wave), spawned_mobs, 2), 15 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(stress_test_damage_wave), spawned_mobs, 3), 30 SECONDS)

	if(auto_cleanup)
		addtimer(CALLBACK(src, PROC_REF(stress_test_cleanup), spawned_mobs), 45 SECONDS)
	else
		to_chat(src, span_warning("Test mobs will remain spawned. Use 'Cleanup Stress Test' verb to remove them later."))
		GLOB.stress_test_mobs = spawned_mobs

/client/proc/stress_test_damage_wave(list/mobs, wave_number)
	if(!mobs || !length(mobs))
		return

	to_chat(src, span_boldnotice("=== DAMAGE WAVE [wave_number] ==="))
	var/start_time = world.timeofday

	for(var/mob/living/carbon/human/H as anything in mobs)
		if(QDELETED(H))
			continue

		apply_random_damage_state(H)
		if(prob(30))
			var/obj/item/bodypart/BP = pick(H.bodyparts)
			if(BP.bandage)
				BP.remove_bandage()
			else if(prob(60))
				var/obj/item/natural/cloth/bandage = new()
				bandage.color = pick("#FFFFFF", "#F5F5DC", "#FFE4E1", "#8B0000")
				BP.try_bandage(bandage)

		H.update_damage_overlays()

	var/update_time = world.timeofday - start_time
	to_chat(src, span_notice("Wave [wave_number] complete. Updated [length(mobs)] mobs in [update_time/10] seconds."))

/client/proc/stress_test_cleanup(list/mobs)
	if(!mobs)
		return

	to_chat(src, span_boldnotice("=== STRESS TEST COMPLETE ==="))
	to_chat(src, span_notice("Cleaning up [length(mobs)] test subjects..."))

	var/cleaned = 0
	for(var/mob/living/carbon/human/H as anything in mobs)
		if(!QDELETED(H))
			qdel(H)
			cleaned++

	to_chat(src, span_notice("Stress test cleanup complete. Deleted [cleaned] mobs."))
	to_chat(src, span_notice("Check server profiler for performance data."))

/client/proc/equip_stress_test_clothing(mob/living/carbon/human/H)

	var/list/shirts = list(
		/obj/item/clothing/suit/roguetown/shirt/undershirt,
		/obj/item/clothing/suit/roguetown/shirt/undershirt/sailor,
		/obj/item/clothing/suit/roguetown/shirt/undershirt/puritan
	)
	var/shirt_type = pick(shirts)
	H.equip_to_slot_or_del(new shirt_type(H), SLOT_SHIRT)


	var/list/pants = list(
		/obj/item/clothing/under/roguetown/trou,
		/obj/item/clothing/under/roguetown/trou/leather
	)
	var/pants_type = pick(pants)
	H.equip_to_slot_or_del(new pants_type(H), SLOT_PANTS)


	if(prob(50))
		var/list/armors = list(
			/obj/item/clothing/suit/roguetown/armor/leather,
			/obj/item/clothing/suit/roguetown/armor/leather/hide,
			/obj/item/clothing/suit/roguetown/armor/chainmail,
			/obj/item/clothing/suit/roguetown/armor/plate
		)
		var/armor_type = pick(armors)
		H.equip_to_slot_or_del(new armor_type(H), SLOT_ARMOR)


	var/list/shoes = list(
		/obj/item/clothing/shoes/roguetown/boots,
		/obj/item/clothing/shoes/roguetown/boots/leather
	)
	var/shoes_type = pick(shoes)
	H.equip_to_slot_or_del(new shoes_type(H), SLOT_SHOES)


	if(prob(30))
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/roguetown/leather(H), SLOT_GLOVES)


	if(prob(40))
		var/list/headgear = list(
			/obj/item/clothing/head/roguetown/helmet/leather,
			/obj/item/clothing/head/roguetown/roguehood
		)
		var/head_type = pick(headgear)
		H.equip_to_slot_or_del(new head_type(H), SLOT_HEAD)


	if(prob(20))
		H.equip_to_slot_or_del(new /obj/item/clothing/neck/roguetown/coif(H), SLOT_NECK)


	if(prob(30))
		H.equip_to_slot_or_del(new /obj/item/clothing/cloak/raincloak/brown(H), SLOT_CLOAK)


	H.update_body()
	H.update_hair()
	H.regenerate_icons()

/client/proc/apply_random_damage_state(mob/living/carbon/human/H)
	if(!H || QDELETED(H))
		return


	for(var/obj/item/bodypart/BP as anything in H.bodyparts)

		var/brute = rand(0, 60)
		if(brute > 0)
			BP.receive_damage(brute, 0)


		var/burn = rand(0, 40)
		if(burn > 0)
			BP.receive_damage(0, burn)


		if(prob(30))
			var/list/possible_wounds = list()


			possible_wounds += list(
				/datum/wound/dynamic/bruise,
				/datum/wound/dynamic/slash,
				/datum/wound/dynamic/puncture,
				/datum/wound/dynamic/bite
			)


			if(prob(20))
				possible_wounds += list(
					/datum/wound/fracture,
					/datum/wound/dislocation,
					/datum/wound/artery
				)

			var/wound_type = pick(possible_wounds)
			BP.add_wound(wound_type, silent = TRUE)


		if(prob(20))
			BP.bleeding = rand(1, 5)


		if(prob(5) && BP.body_zone != BODY_ZONE_HEAD)
			var/obj/item/arrow = new /obj/item/ammo_casing/caseless/rogue/arrow(BP)
			BP.add_embedded_object(arrow, silent = TRUE)

		if(prob(25) && !BP.bandage)
			var/obj/item/natural/cloth/bandage = new()
			bandage.color = pick("#FFFFFF", "#F5F5DC", "#FFE4E1", "#8B0000") // white, beige, pink, blood-red
			BP.try_bandage(bandage)


		if(prob(1))
			BP.skeletonized = TRUE

	H.updatehealth()
	for(var/obj/item/bodypart/BP as anything in H.bodyparts)
		BP.update_bodypart_damage_state()


/client/proc/cleanup_stress_test_mobs()
	set name = "Cleanup Stress Test"
	set category = "Debug"

	if(!check_rights(R_DEBUG))
		return

	if(!GLOB.stress_test_mobs || !length(GLOB.stress_test_mobs))
		to_chat(src, span_warning("No stress test mobs found to clean up."))
		return

	var/mob_count = length(GLOB.stress_test_mobs)
	if(alert(usr, "Delete [mob_count] stress test mobs?", "Confirm Cleanup", "Yes", "No") != "Yes")
		return

	to_chat(src, span_notice("Cleaning up [mob_count] stress test mobs..."))

	var/cleaned = 0
	for(var/mob/living/carbon/human/H as anything in GLOB.stress_test_mobs)
		if(!QDELETED(H))
			qdel(H)
			cleaned++

	GLOB.stress_test_mobs = list()
	to_chat(src, span_notice("Cleanup complete. Deleted [cleaned] mobs."))
