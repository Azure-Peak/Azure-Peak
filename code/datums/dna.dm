/////////////////////////// DNA DATUM
/datum/dna
	var/unique_enzymes
	var/uni_identity
	var/blood_type
	var/datum/species/species = new /datum/species/human //The type of mutant race the player is if applicable (i.e. potato-man)
	var/list/features = MANDATORY_FEATURE_LIST
	var/real_name //Stores the real name of the person who originally got this dna datum. Used primarely for changelings,
	var/list/temporary_mutations = list() //Temporary changes to the UE
	var/list/previous = list() //For temporary name/ui/ue/blood_type modifications
	var/mob/living/holder
	var/delete_species = TRUE //Set to FALSE when a body is scanned by a cloner to fix #38875
	var/stability = 100
	var/scrambled = FALSE //Did we take something like mutagen? In that case we cant get our genes scanned to instantly cheese all the powers.
	var/list/organ_dna = list()
	///Body markings of the DNA's owner. This is for storing their original state for re-creating the character. They'll get changed on species mutation
	var/list/list/body_markings = list()
	///Current body size, used for proper re-sizing and keeping track of that
	var/current_body_size = BODY_SIZE_NORMAL

/datum/dna/New(mob/living/new_holder)
	if(istype(new_holder))
		holder = new_holder

/datum/dna/Destroy()
	if(iscarbon(holder))
		var/mob/living/carbon/cholder = holder
		if(cholder.dna == src)
			cholder.dna = null
	holder = null

	if(delete_species)
		QDEL_NULL(species)

	temporary_mutations.Cut()		//^
	previous.Cut()					//^

	return ..()

/datum/dna/proc/transfer_identity(mob/living/carbon/destination, transfer_SE = 0)
	if(!istype(destination))
		return
	destination.dna.unique_enzymes = unique_enzymes
	destination.dna.uni_identity = uni_identity
	destination.dna.blood_type = blood_type
	destination.set_species(species.type, icon_update=0)
	destination.dna.body_markings = deepCopyList(body_markings)
	destination.dna.features = features.Copy()
	destination.dna.real_name = real_name
	destination.dna.temporary_mutations = temporary_mutations.Copy()
	destination.dna.organ_dna = organ_dna.Copy()
	destination.regenerate_organs()
	var/obj/item/bodypart/head/my_head = holder?.get_bodypart(BODY_ZONE_HEAD)
	var/obj/item/bodypart/head/their_head = destination?.get_bodypart(BODY_ZONE_HEAD)
	if(my_head && their_head)
		their_head.bodypart_features = my_head.bodypart_features?.Copy()
	destination.dna.body_markings = deepCopyList(body_markings)
	destination.dna.update_body_size()

/datum/dna/proc/copy_dna(datum/dna/new_dna)
	new_dna.unique_enzymes = unique_enzymes
	new_dna.uni_identity = uni_identity
	new_dna.blood_type = blood_type
	new_dna.body_markings = deepCopyList(body_markings)
	new_dna.features = features.Copy()
	new_dna.species = new species.type
	new_dna.real_name = real_name

/datum/dna/proc/generate_uni_identity()
	. = ""
	var/list/L = new /list(DNA_UNI_IDENTITY_BLOCKS)

	switch(holder.gender)
		if(MALE)
			L[DNA_GENDER_BLOCK] = construct_block(G_MALE, 3)
		if(FEMALE)
			L[DNA_GENDER_BLOCK] = construct_block(G_FEMALE, 3)
		else
			L[DNA_GENDER_BLOCK] = construct_block(G_PLURAL, 3)
	if(ishuman(holder))
		var/mob/living/carbon/human/H = holder
		L[DNA_SKIN_TONE_BLOCK] = H.skin_tone
		L[DNA_EYE_COLOR_BLOCK] = H.eye_color

	for(var/i=1, i<=DNA_UNI_IDENTITY_BLOCKS, i++)
		if(L[i])
			. += L[i]
		else
			. += random_string(DNA_BLOCK_SIZE,GLOB.hex_characters)
	return .

/datum/dna/proc/generate_dna_blocks()
	var/bonus
	var/list/mutations_temp = GLOB.good_mutations + GLOB.bad_mutations + GLOB.not_good_mutations + bonus
	if(!LAZYLEN(mutations_temp))
		return
	shuffle_inplace(mutations_temp)

/datum/dna/proc/generate_unique_enzymes()
	. = ""
	if(istype(holder))
		real_name = holder.real_name
		. += md5(holder.real_name)
	else
		. += random_string(DNA_UNIQUE_ENZYMES_LEN, GLOB.hex_characters)
	return .

/datum/dna/proc/update_ui_block(blocknumber)
	if(!blocknumber || !ishuman(holder))
		return
	var/mob/living/carbon/human/H = holder
	switch(blocknumber)
		if(DNA_SKIN_TONE_BLOCK)
			setblock(uni_identity, blocknumber, sanitize_hexcolor(H.skin_tone))
		if(DNA_EYE_COLOR_BLOCK)
			setblock(uni_identity, blocknumber, sanitize_hexcolor(H.eye_color))
		if(DNA_GENDER_BLOCK)
			switch(H.gender)
				if(MALE)
					setblock(uni_identity, blocknumber, construct_block(G_MALE, 3))
				if(FEMALE)
					setblock(uni_identity, blocknumber, construct_block(G_FEMALE, 3))
				else
					setblock(uni_identity, blocknumber, construct_block(G_PLURAL, 3))

/datum/dna/proc/is_same_as(datum/dna/D)
	if(uni_identity == D.uni_identity && real_name == D.real_name)
		if(species.type == D.species.type && features == D.features && blood_type == D.blood_type)
			return 1
	return 0

//used to update dna UI, UE, and dna.real_name.
/datum/dna/proc/update_dna_identity()
	uni_identity = generate_uni_identity()
	unique_enzymes = generate_unique_enzymes()

/datum/dna/proc/initialize_dna(newblood_type, skip_index = FALSE)
	if(newblood_type)
		blood_type = newblood_type
	unique_enzymes = generate_unique_enzymes()
	uni_identity = generate_uni_identity()
	if(!skip_index) //I hate this
		generate_dna_blocks()
	features = random_features()


/datum/dna/stored //subtype used by brain mob's stored_dna

/////////////////////////// DNA MOB-PROCS //////////////////////

/mob/proc/set_species(datum/species/mrace, icon_update = 1)
	return

/mob/living/brain/set_species(datum/species/mrace, icon_update = 1)
	if(mrace)
		if(ispath(mrace))
			stored_dna.species = new mrace()
		else
			stored_dna.species = mrace //not calling any species update procs since we're a brain, not a monkey/human


/mob/living/carbon/set_species(datum/species/mrace, icon_update = TRUE, datum/preferences/pref_load = null)
	if(mrace && has_dna())
		var/datum/species/new_race
		if(ispath(mrace))
			new_race = new mrace
		else if(istype(mrace))
			new_race = mrace
		else
			return
		deathsound = new_race.deathsound
		dna.species.on_species_loss(src, new_race, pref_load)
		var/datum/species/old_species = dna.species
		dna.species = new_race
		//BODYPARTS AND FEATURES
		if(pref_load)
			dna.features = pref_load.features.Copy()
			dna.body_markings = deepCopyList(pref_load.body_markings)
			dna.real_name = pref_load.real_name
		dna.species.on_species_gain(src, old_species, pref_load)

/mob/living/carbon/human/set_species(datum/species/mrace, icon_update = TRUE, datum/preferences/pref_load = null)
	set waitfor = 0
	
	if(pref_load)
		skin_tone = pref_load.skin_tone
	..()
	if(icon_update)
		update_body()
		update_hair()
		update_body_parts(TRUE)	

/mob/proc/has_dna()
	return

/mob/living/carbon/has_dna()
	return dna


/mob/living/carbon/human/proc/hardset_dna(ui, list/mutation_index, newreal_name, newblood_type, datum/species/mrace, newfeatures, list/mutations, force_transfer_mutations)
//Do not use force_transfer_mutations for stuff like cloners without some precautions, otherwise some conditional mutations could break (timers, drill hat etc)
	if(newfeatures)
		dna.features = newfeatures

	if(mrace)
		var/datum/species/newrace = new mrace.type
		newrace.copy_properties_from(mrace)
		set_species(newrace, icon_update=0)

	if(newreal_name)
		real_name = newreal_name
		dna.generate_unique_enzymes()

	if(newblood_type)
		dna.blood_type = newblood_type

	if(ui)
		dna.uni_identity = ui
		updateappearance(icon_update=0)

	if(mrace || newfeatures || ui)
		update_body()
		update_hair()
		update_body_parts()

/mob/living/carbon/proc/create_dna()
	dna = new /datum/dna(src)
	if(!dna.species)
		var/rando_race = pick(GLOB.roundstart_races)
		dna.species = new rando_race()

//proc used to update the mob's appearance after its dna UI has been changed
/mob/living/carbon/proc/updateappearance(icon_update=1, mutcolor_update=0, mutations_overlay_update=0)
	if(!has_dna())
		return

	switch(deconstruct_block(getblock(dna.uni_identity, DNA_GENDER_BLOCK), 3))
		if(G_MALE)
			gender = MALE
		if(G_FEMALE)
			gender = FEMALE
		else
			gender = PLURAL

/mob/living/carbon/human/updateappearance(icon_update=1, mutcolor_update=0, mutations_overlay_update=0)
	..()
//	var/structure = dna.uni_identity
//	hair_color = getblock(structure, DNA_HAIR_COLOR_BLOCK)
//	facial_hair_color = getblock(structure, DNA_FACIAL_HAIR_COLOR_BLOCK)
//	skin_tone = getblock(structure, DNA_SKIN_TONE_BLOCK)
//	eye_color = getblock(structure, DNA_EYE_COLOR_BLOCK)
//	facial_hairstyle = GLOB.facial_hairstyles_list[deconstruct_block(getblock(structure, DNA_FACIAL_HAIRSTYLE_BLOCK), GLOB.facial_hairstyles_list.len)]
//	hairstyle = GLOB.hairstyles_list[deconstruct_block(getblock(structure, DNA_HAIRSTYLE_BLOCK), GLOB.hairstyles_list.len)]
	if(icon_update)
		update_body()
		update_hair()
		if(mutcolor_update)
			update_body_parts()



/mob/proc/domutcheck()
	return

/datum/dna/proc/update_body_size()
	if(!holder || current_body_size == features["body_size"])
		return
	var/change_multiplier = features["body_size"] / current_body_size
	//We update the translation to make sure our character doesn't go out of the southern bounds of the tile
	var/translate = ((change_multiplier-1) * 32)/2
	holder.transform = holder.transform.Scale(change_multiplier, change_multiplier)
	holder.transform = holder.transform.Translate(0, translate)
	current_body_size = features["body_size"]


/////////////////////////// DNA HELPER-PROCS //////////////////////////////

/proc/getleftblocks(input,blocknumber,blocksize)
	if(blocknumber > 1)
		return copytext(input,1,((blocksize*blocknumber)-(blocksize-1)))

/proc/getrightblocks(input,blocknumber,blocksize)
	if(blocknumber < (length(input)/blocksize))
		return copytext(input,blocksize*blocknumber+1,length(input)+1)

/proc/getblock(input, blocknumber, blocksize=DNA_BLOCK_SIZE)
	return copytext(input, blocksize*(blocknumber-1)+1, (blocksize*blocknumber)+1)

/proc/setblock(istring, blocknumber, replacement, blocksize=DNA_BLOCK_SIZE)
	if(!istring || !blocknumber || !replacement || !blocksize)
		return 0
	return getleftblocks(istring, blocknumber, blocksize) + replacement + getrightblocks(istring, blocknumber, blocksize)



/mob/living/carbon/proc/randmuti()
	if(!has_dna())
		return
	var/num = rand(1, DNA_UNI_IDENTITY_BLOCKS)
	var/newdna = setblock(dna.uni_identity, num, random_string(DNA_BLOCK_SIZE, GLOB.hex_characters))
	dna.uni_identity = newdna
	updateappearance(mutations_overlay_update=1)


/proc/scramble_dna(mob/living/carbon/M, ui=FALSE, se=FALSE, probability)
	if(!M.has_dna())
		return 0
	if(se)
		for(var/i=1, i<=DNA_MUTATION_BLOCKS, i++)
			if(prob(probability))
				M.dna.generate_dna_blocks()
		M.domutcheck()
	if(ui)
		for(var/i=1, i<=DNA_UNI_IDENTITY_BLOCKS, i++)
			if(prob(probability))
				M.dna.uni_identity = setblock(M.dna.uni_identity, i, random_string(DNA_BLOCK_SIZE, GLOB.hex_characters))
		M.updateappearance(mutations_overlay_update=1)
	return 1

//value in range 1 to values. values must be greater than 0
//all arguments assumed to be positive integers
/proc/construct_block(value, values, blocksize=DNA_BLOCK_SIZE)
	var/width = round((16**blocksize)/values)
	if(value < 1)
		value = 1
	value = (value * width) - rand(1,width)
	return num2hex(value, blocksize)

//value is hex
/proc/deconstruct_block(value, values, blocksize=DNA_BLOCK_SIZE)
	var/width = round((16**blocksize)/values)
	value = round(hex2num(value) / width) + 1
	if(value > values)
		value = values
	return value
