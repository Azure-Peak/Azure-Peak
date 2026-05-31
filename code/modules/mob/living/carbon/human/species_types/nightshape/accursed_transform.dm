/datum/component/night_form
	var/transformed = FALSE
	var/transforming = FALSE
	var/untransforming = FALSE
	var/chosen_form_path
	var/datum/mind/owner_mind
	var/random_form = FALSE

	var/static/list/possible_forms = list(
		"Wolf" = /mob/living/carbon/human/species/wildshape/night_volf,
		"Vernard" = /mob/living/carbon/human/species/wildshape/night_fox,
		"Saiga" = /mob/living/carbon/human/species/wildshape/night_saiga,
		"Cat" = /mob/living/carbon/human/species/wildshape/night_cat)

	var/static/list/form_paths = list(
		/mob/living/carbon/human/species/wildshape/night_volf,
		/mob/living/carbon/human/species/wildshape/night_fox,
		/mob/living/carbon/human/species/wildshape/night_saiga,
		/mob/living/carbon/human/species/wildshape/night_cat
	)

/datum/component/night_form/Initialize()
	if(!istype(parent, /datum/mind))
		return COMPONENT_INCOMPATIBLE

	owner_mind = parent
	var/mob/living/carbon/human/H = owner_mind.current

	if(!istype(H))
		return COMPONENT_INCOMPATIBLE

	choose_form(H)
	START_PROCESSING(SSprocessing, src)

/datum/component/night_form/proc/choose_form(mob/living/carbon/human/H)
	if(!H.client)
		random_form = TRUE
		chosen_form_path = null
		return

	var/list/options = list()
	for(var/name in possible_forms)
		options[name] = possible_forms[name]
	options["Random each time"] = "RANDOM"

	var/chosen_name = input(H, "What shape did the Wild One force upon your soul?", "Bestial Form") as null|anything in options

	if(!chosen_name)
		random_form = TRUE
		chosen_form_path = null
		to_chat(H, span_warning("You hesitated, and the wilds chose for you. Your form shall be unpredictable."))
		return

	if(options[chosen_name] == "RANDOM")
		random_form = TRUE
		chosen_form_path = null
		to_chat(H, span_notice("You have chosen an unpredictable nature. Each night you shall take a different form."))
	else
		random_form = FALSE
		chosen_form_path = options[chosen_name]
		to_chat(H, span_notice("You have chosen the path of the [chosen_name]."))

/datum/component/night_form/proc/get_transform_path()
	if(random_form)
		return pick(form_paths)
	return chosen_form_path

/datum/component/night_form/process()
	if(!owner_mind)
		qdel(src)
		return

	var/mob/living/carbon/human/H = owner_mind.current
	if(!istype(H))
		return

	if(H.stat == DEAD)
		return
	if(H.advsetup)
		return
	
	if(H.mind?.has_antag_datum(/datum/antagonist/werewolf))
		to_chat(H, span_userdanger("The beast's curse overwhelms the moon's call! Your old affliction is consumed by a darker power..."))
		qdel(src)
		return

	if(!transformed && !transforming)
		if(GLOB.tod == "night")
			if(isturf(H.loc))
				var/turf/loc = H.loc
				if(loc.can_see_sky())
					to_chat(H, span_warning("The moonlight stirs something within you..."))
					H.playsound_local(get_turf(H), 'sound/music/wolfintro.ogg', 80, FALSE, pressure_affected = FALSE)
					if(H.show_redflash())
						H.flash_fullscreen("redflash3")
					transforming = world.time

	else if(transforming)
		if(world.time >= transforming + 20 SECONDS)
			var/form_to_use = get_transform_path()
			H.wildshape_transformation(form_to_use)
			transforming = FALSE
			transformed = TRUE
			untransforming = FALSE

		else if(world.time >= transforming + 15 SECONDS)
			if(H.show_redflash())
				H.flash_fullscreen("redflash3")
			H.emote("pain", forced = TRUE)
			to_chat(H, span_danger("Your body twists and reforms!"))
			H.Stun(20)
			H.Knockdown(20)

		else if(world.time >= transforming + 5 SECONDS)
			to_chat(H, span_warning("Your muscles begin to ache..."))

	else if(transformed)
		if(GLOB.tod != "night")
			if(!untransforming)
				untransforming = world.time

			if(world.time >= untransforming + 20 SECONDS)
				var/mob/living/carbon/human/species/wildshape/current_form = H
				if(istype(current_form) && current_form.stored_mob)
					current_form.wildshape_untransform()
				transformed = FALSE
				untransforming = FALSE

			else if(world.time >= untransforming + 10 SECONDS)
				to_chat(H, span_warning("The daylight weakens your bestial form..."))

/datum/component/night_form/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	owner_mind = null
	return ..()
