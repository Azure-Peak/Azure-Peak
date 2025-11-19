/datum/customizer/bodypart_feature/hair
	abstract_type = /datum/customizer/bodypart_feature/hair

/datum/customizer_choice/bodypart_feature/hair
	abstract_type = /datum/customizer_choice/bodypart_feature/hair
	customizer_entry_type = /datum/customizer_entry/hair
	allows_accessory_color_customization = FALSE //Customized through hair color
	var/allows_natural_gradient = TRUE
	var/allows_dye_gradient = TRUE

/datum/customizer_choice/bodypart_feature/hair/customize_feature(datum/bodypart_feature/feature, mob/living/carbon/human/human, datum/preferences/prefs, datum/customizer_entry/hair/entry)
	var/datum/bodypart_feature/hair/hair_feature = feature
	hair_feature.hair_color = entry.hair_color
	hair_feature.accessory_colors = entry.hair_color
	hair_feature.natural_color = entry.natural_color
	hair_feature.hair_dye_color = entry.dye_color
	hair_feature.natural_gradient = entry.natural_gradient
	hair_feature.hair_dye_gradient = entry.dye_gradient

/datum/customizer_choice/bodypart_feature/hair/validate_entry(datum/preferences/prefs, datum/customizer_entry/entry)
	..()
	var/datum/customizer_entry/hair/hair_entry = entry
	hair_entry.hair_color = sanitize_hexcolor(hair_entry.hair_color, 6, TRUE, initial(hair_entry.hair_color))
	hair_entry.natural_color = sanitize_hexcolor(hair_entry.natural_color, 6, TRUE, initial(hair_entry.natural_color))
	hair_entry.dye_color = sanitize_hexcolor(hair_entry.dye_color, 6, TRUE, initial(hair_entry.dye_color))

/datum/customizer_choice/bodypart_feature/hair/generate_pref_choices(list/dat, datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	..()
	var/datum/customizer_entry/hair/hair_entry = entry
	dat += "<br>Hair Color: <a href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=hair_color''><span class='color_holder_box' style='background-color:[hair_entry.hair_color]'></span></a>"
	if(allows_natural_gradient)
		var/datum/hair_gradient/gradient = HAIR_GRADIENT(hair_entry.natural_gradient)
		dat += "<br>Natural Gradient: <a href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=natural_gradient'>[gradient.name]</a>"
		if(hair_entry.natural_gradient != /datum/hair_gradient/none)
			dat += "<br>Natural Color: <a href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=natural_gradient_color''><span class='color_holder_box' style='background-color:[hair_entry.natural_color]'></span></a>"
	if(allows_dye_gradient)
		var/datum/hair_gradient/gradient = HAIR_GRADIENT(hair_entry.dye_gradient)
		dat += "<br>Dye Gradient: <a href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=dye_gradient'>[gradient.name]</a>"
		if(hair_entry.dye_gradient != /datum/hair_gradient/none)
			dat += "<br>Dye Color: <a href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=dye_gradient_color''><span class='color_holder_box' style='background-color:[hair_entry.dye_color]'></span></a>"

/datum/customizer_choice/bodypart_feature/hair/handle_topic(mob/user, list/href_list, datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	..()
	var/datum/customizer_entry/hair/hair_entry = entry
	switch(href_list["customizer_task"])
		if("hair_color")
			var/new_color = color_pick_sanitized(user, "Choose your hair color:", "Character Preference", hair_entry.hair_color)
			if(!new_color)
				return
			hair_entry.hair_color = sanitize_hexcolor(new_color, 6, TRUE)
		if("natural_gradient")
			if(!allows_natural_gradient)
				return
			var/list/choice_list = hair_gradient_name_to_type_list()
			var/chosen_input = input(user, "Choose your natural gradient:", "Character Preference")  as null|anything in choice_list
			if(!chosen_input)
				return
			hair_entry.natural_gradient = choice_list[chosen_input]
		if("natural_gradient_color")
			if(!allows_natural_gradient)
				return
			var/new_color = color_pick_sanitized(user, "Choose your natural gradient color:", "Character Preference", hair_entry.natural_color)
			if(!new_color)
				return
			hair_entry.natural_color = sanitize_hexcolor(new_color, 6, TRUE)
		if("dye_gradient")
			if(!allows_dye_gradient)
				return
			var/list/choice_list = hair_gradient_name_to_type_list()
			var/chosen_input = input(user, "Choose your dye gradient:", "Character Preference")  as null|anything in choice_list
			if(!chosen_input)
				return
			hair_entry.dye_gradient = choice_list[chosen_input]
		if("dye_gradient_color")
			if(!allows_dye_gradient)
				return
			var/new_color = color_pick_sanitized(user, "Choose your dye gradient color:", "Character Preference", hair_entry.dye_color)
			if(!new_color)
				return
			hair_entry.dye_color = sanitize_hexcolor(new_color, 6, TRUE)

/datum/customizer_entry/hair
	var/hair_color = "#FFFFFF"
	var/natural_gradient = /datum/hair_gradient/none
	var/natural_color = "#FFFFFF"
	var/dye_gradient = /datum/hair_gradient/none
	var/dye_color = "#FFFFFF"

/datum/customizer_entry/hair/facial

/datum/customizer/bodypart_feature/hair/head
	abstract_type = /datum/customizer/bodypart_feature/hair/head
	name = "Hair"

/datum/customizer_choice/bodypart_feature/hair/head
	abstract_type = /datum/customizer_choice/bodypart_feature/hair/head
	name = "Hair"
	feature_type = /datum/bodypart_feature/hair/head

/datum/customizer/bodypart_feature/hair/facial
	abstract_type = /datum/customizer/bodypart_feature/hair/facial
	name = "Facial Hair"

/datum/customizer/bodypart_feature/hair/facial/is_allowed(datum/preferences/prefs)
	return (prefs.gender == MALE)

/datum/customizer_choice/bodypart_feature/hair/facial
	abstract_type = /datum/customizer_choice/bodypart_feature/hair/facial
	name = "Facial Hair"
	feature_type = /datum/bodypart_feature/hair/facial
	customizer_entry_type = /datum/customizer_entry/hair/facial

/datum/customizer/bodypart_feature/hair/head/humanoid
	customizer_choices = list(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)

/datum/customizer_choice/bodypart_feature/hair/head/humanoid
	sprite_accessories = list(
		/datum/sprite_accessory/hair/head/bald,
		/datum/sprite_accessory/hair/head/shorthaireighties,
		/datum/sprite_accessory/hair/head/shorthaireighties_alt,
		/datum/sprite_accessory/hair/head/afro,
		/datum/sprite_accessory/hair/head/afro2,
		/datum/sprite_accessory/hair/head/afro_large,
		/datum/sprite_accessory/hair/head/astolfo,
		/datum/sprite_accessory/hair/head/antenna,
		/datum/sprite_accessory/hair/head/balding,
		/datum/sprite_accessory/hair/head/bedhead,
		/datum/sprite_accessory/hair/head/bedhead2,
		/datum/sprite_accessory/hair/head/bedhead3,
		/datum/sprite_accessory/hair/head/bedheadlong,
		/datum/sprite_accessory/hair/head/badlycut,
		/datum/sprite_accessory/hair/head/beehive,
		/datum/sprite_accessory/hair/head/beehive2,
		/datum/sprite_accessory/hair/head/bob,
		/datum/sprite_accessory/hair/head/bob2,
		/datum/sprite_accessory/hair/head/bob3,
		/datum/sprite_accessory/hair/head/bob4,
		/datum/sprite_accessory/hair/head/bobcurl,
		/datum/sprite_accessory/hair/head/boddicker,
		/datum/sprite_accessory/hair/head/bowlcut,
		/datum/sprite_accessory/hair/head/bowlcut2,
		/datum/sprite_accessory/hair/head/braid,
		/datum/sprite_accessory/hair/head/front_braid,
		/datum/sprite_accessory/hair/head/not_floorlength_braid,
		/datum/sprite_accessory/hair/head/lowbraid,
		/datum/sprite_accessory/hair/head/shortbraid,
		/datum/sprite_accessory/hair/head/braided,
		/datum/sprite_accessory/hair/head/braidtail,
		/datum/sprite_accessory/hair/head/bun,
		/datum/sprite_accessory/hair/head/bun2,
		/datum/sprite_accessory/hair/head/bun3,
		/datum/sprite_accessory/hair/head/lowbun,
		/datum/sprite_accessory/hair/head/largebun,
		/datum/sprite_accessory/hair/head/manbun,
		/datum/sprite_accessory/hair/head/tightbun,
		/datum/sprite_accessory/hair/head/business,
		/datum/sprite_accessory/hair/head/business2,
		/datum/sprite_accessory/hair/head/business3,
		/datum/sprite_accessory/hair/head/business4,
		/datum/sprite_accessory/hair/head/buzz,
		/datum/sprite_accessory/hair/head/cia,
		/datum/sprite_accessory/hair/head/coffeehouse,
		/datum/sprite_accessory/hair/head/combover,
		/datum/sprite_accessory/hair/head/comet,
		/datum/sprite_accessory/hair/head/cornrows1,
		/datum/sprite_accessory/hair/head/cornrows2,
		/datum/sprite_accessory/hair/head/cornrowbraid,
		/datum/sprite_accessory/hair/head/cornrowbun,
		/datum/sprite_accessory/hair/head/cornrowdualtail,
		/datum/sprite_accessory/hair/head/crew,
		/datum/sprite_accessory/hair/head/cut,
		/datum/sprite_accessory/hair/head/dandpompadour,
		/datum/sprite_accessory/hair/head/devillock,
		/datum/sprite_accessory/hair/head/doublebun,
		/datum/sprite_accessory/hair/head/dreadlocks,
		/datum/sprite_accessory/hair/head/drillhair,
		/datum/sprite_accessory/hair/head/drillhairextended,
		/datum/sprite_accessory/hair/head/emo,
		/datum/sprite_accessory/hair/head/emo2,
		/datum/sprite_accessory/hair/head/emofringe,
		/datum/sprite_accessory/hair/head/longemo,
		/datum/sprite_accessory/hair/head/nofade,
		/datum/sprite_accessory/hair/head/lowfade,
		/datum/sprite_accessory/hair/head/medfade,
		/datum/sprite_accessory/hair/head/highfade,
		/datum/sprite_accessory/hair/head/baldfade,
		/datum/sprite_accessory/hair/head/father,
		/datum/sprite_accessory/hair/head/feather,
		/datum/sprite_accessory/hair/head/flair,
		/datum/sprite_accessory/hair/head/flattop,
		/datum/sprite_accessory/hair/head/flattop_big,
		/datum/sprite_accessory/hair/head/flow_hair,
		/datum/sprite_accessory/hair/head/gelled,
		/datum/sprite_accessory/hair/head/gentle,
		/datum/sprite_accessory/hair/head/halfbang,
		/datum/sprite_accessory/hair/head/halfbang2,
		/datum/sprite_accessory/hair/head/halfshaved,
		/datum/sprite_accessory/hair/head/hedgehog,
		/datum/sprite_accessory/hair/head/himecut,
		/datum/sprite_accessory/hair/head/himecut2,
		/datum/sprite_accessory/hair/head/shorthime,
		/datum/sprite_accessory/hair/head/himeup,
		/datum/sprite_accessory/hair/head/hitop,
		/datum/sprite_accessory/hair/head/jade,
		/datum/sprite_accessory/hair/head/jensen,
		/datum/sprite_accessory/hair/head/joestar,
		/datum/sprite_accessory/hair/head/keanu,
		/datum/sprite_accessory/hair/head/kusangi,
		/datum/sprite_accessory/hair/head/long,
		/datum/sprite_accessory/hair/head/long2,
		/datum/sprite_accessory/hair/head/long3,
		/datum/sprite_accessory/hair/head/long_over_eye,
		/datum/sprite_accessory/hair/head/longbangs,
		/datum/sprite_accessory/hair/head/longfringe,
		/datum/sprite_accessory/hair/head/sidepartlongalt,
		/datum/sprite_accessory/hair/head/megaeyebrows,
		/datum/sprite_accessory/hair/head/messy,
		/datum/sprite_accessory/hair/head/modern,
		/datum/sprite_accessory/hair/head/modern2,
		/datum/sprite_accessory/hair/head/mohawk,
		/datum/sprite_accessory/hair/head/reversemohawk,
		/datum/sprite_accessory/hair/head/shavedmohawk,
		/datum/sprite_accessory/hair/head/unshavenmohawk,
		/datum/sprite_accessory/hair/head/mulder,
		/datum/sprite_accessory/hair/head/nitori,
		/datum/sprite_accessory/hair/head/newyou,
		/datum/sprite_accessory/hair/head/odango,
		/datum/sprite_accessory/hair/head/ombre,
		/datum/sprite_accessory/hair/head/oneshoulder,
		/datum/sprite_accessory/hair/head/over_eye,
		/datum/sprite_accessory/hair/head/oxton,
		/datum/sprite_accessory/hair/head/parted,
		/datum/sprite_accessory/hair/head/partedside,
		/datum/sprite_accessory/hair/head/pigtails,
		/datum/sprite_accessory/hair/head/pigtails2,
		/datum/sprite_accessory/hair/head/pigtails3,
		/datum/sprite_accessory/hair/head/kagami,
		/datum/sprite_accessory/hair/head/pixie,
		/datum/sprite_accessory/hair/head/pompadour,
		/datum/sprite_accessory/hair/head/bigpompadour,
		/datum/sprite_accessory/hair/head/ponytail1,
		/datum/sprite_accessory/hair/head/ponytail2,
		/datum/sprite_accessory/hair/head/ponytail3,
		/datum/sprite_accessory/hair/head/ponytail4,
		/datum/sprite_accessory/hair/head/ponytail5,
		/datum/sprite_accessory/hair/head/ponytail6,
		/datum/sprite_accessory/hair/head/ponytail7,
		/datum/sprite_accessory/hair/head/ponytail8,
		/datum/sprite_accessory/hair/head/highponytail,
		/datum/sprite_accessory/hair/head/longponytail,
		/datum/sprite_accessory/hair/head/stail,
		/datum/sprite_accessory/hair/head/countryponytail,
		/datum/sprite_accessory/hair/head/fringetail,
		/datum/sprite_accessory/hair/head/sidetail,
		/datum/sprite_accessory/hair/head/sidetail2,
		/datum/sprite_accessory/hair/head/sidetail3,
		/datum/sprite_accessory/hair/head/sidetail4,
		/datum/sprite_accessory/hair/head/spikyponytail,
		/datum/sprite_accessory/hair/head/poofy,
		/datum/sprite_accessory/hair/head/quiff,
		/datum/sprite_accessory/hair/head/ronin,
		/datum/sprite_accessory/hair/head/shaved,
		/datum/sprite_accessory/hair/head/shavedpart,
		/datum/sprite_accessory/hair/head/shortbangs,
		/datum/sprite_accessory/hair/head/short,
		/datum/sprite_accessory/hair/head/shorthair2,
		/datum/sprite_accessory/hair/head/shorthair3,
		/datum/sprite_accessory/hair/head/shorthair6,
		/datum/sprite_accessory/hair/head/shorthair7,
		/datum/sprite_accessory/hair/head/rosa,
		/datum/sprite_accessory/hair/head/shoulderlength,
		/datum/sprite_accessory/hair/head/sidecut,
		/datum/sprite_accessory/hair/head/skinhead,
		/datum/sprite_accessory/hair/head/protagonist,
		/datum/sprite_accessory/hair/head/spiky,
		/datum/sprite_accessory/hair/head/spiky2,
		/datum/sprite_accessory/hair/head/spiky3,
		/datum/sprite_accessory/hair/head/swept,
		/datum/sprite_accessory/hair/head/swept2,
		/datum/sprite_accessory/hair/head/thinning,
		/datum/sprite_accessory/hair/head/thinningfront,
		/datum/sprite_accessory/hair/head/thinningrear,
		/datum/sprite_accessory/hair/head/topknot,
		/datum/sprite_accessory/hair/head/tressshoulder,
		/datum/sprite_accessory/hair/head/trimmed,
		/datum/sprite_accessory/hair/head/trimflat,
		/datum/sprite_accessory/hair/head/twintails,
		/datum/sprite_accessory/hair/head/undercut,
		/datum/sprite_accessory/hair/head/undercutleft,
		/datum/sprite_accessory/hair/head/undercutright,
		/datum/sprite_accessory/hair/head/unkept,
		/datum/sprite_accessory/hair/head/updo,
		/datum/sprite_accessory/hair/head/longer,
		/datum/sprite_accessory/hair/head/longest,
		/datum/sprite_accessory/hair/head/longest2,
		/datum/sprite_accessory/hair/head/veryshortovereye,
		/datum/sprite_accessory/hair/head/longestalt,
		/datum/sprite_accessory/hair/head/volaju,
		/datum/sprite_accessory/hair/head/wisp,
		/datum/sprite_accessory/hair/head/hyenamane,
		/datum/sprite_accessory/hair/head/forelock,
		/datum/sprite_accessory/hair/head/pirate,
		/datum/sprite_accessory/hair/head/shavedmohawk,
		/datum/sprite_accessory/hair/head/baldfade,
		/datum/sprite_accessory/hair/head/rogue,
		/datum/sprite_accessory/hair/head/romantic,
		/datum/sprite_accessory/hair/head/runt,
		/datum/sprite_accessory/hair/head/son,
		/datum/sprite_accessory/hair/head/bog,
		/datum/sprite_accessory/hair/head/scout,
		/datum/sprite_accessory/hair/head/son2,
		/datum/sprite_accessory/hair/head/long4,
		/datum/sprite_accessory/hair/head/amazon,
		/datum/sprite_accessory/hair/head/longstraightponytail,
		/datum/sprite_accessory/hair/head/barmaid,
		/datum/sprite_accessory/hair/head/bob_rt,
		/datum/sprite_accessory/hair/head/messy_rt,
		/datum/sprite_accessory/hair/head/homely,
		/datum/sprite_accessory/hair/head/longtails,
		/datum/sprite_accessory/hair/head/hime,
		/datum/sprite_accessory/hair/head/tied,
		/datum/sprite_accessory/hair/head/tied2,
		/datum/sprite_accessory/hair/head/fatherless,
		/datum/sprite_accessory/hair/head/fatherless2,
		/datum/sprite_accessory/hair/head/kepthair,
		/datum/sprite_accessory/hair/head/singlebraid,
		/datum/sprite_accessory/hair/head/gloomy,
		/datum/sprite_accessory/hair/head/gloomylong,
		/datum/sprite_accessory/hair/head/shortmessy,
		/datum/sprite_accessory/hair/head/mediumessy,
		/datum/sprite_accessory/hair/head/zone,
		/datum/sprite_accessory/hair/head/inari,
		/datum/sprite_accessory/hair/head/ziegler,
		/datum/sprite_accessory/hair/head/gronnbraid,
		/datum/sprite_accessory/hair/head/grenzelcut,
		/datum/sprite_accessory/hair/head/fluffy,
		/datum/sprite_accessory/hair/head/fluffyshort,
		/datum/sprite_accessory/hair/head/fluffylong,
		/datum/sprite_accessory/hair/head/jay,
		/datum/sprite_accessory/hair/head/hairfre,
		/datum/sprite_accessory/hair/head/dawn,
		/datum/sprite_accessory/hair/head/morning,
		/datum/sprite_accessory/hair/head/kobeni_1,
		/datum/sprite_accessory/hair/head/kobeni_2,
		/datum/sprite_accessory/hair/head/kobeni_tail,
		/datum/sprite_accessory/hair/head/gloomy_short,
		/datum/sprite_accessory/hair/head/gloomy_medium,
		/datum/sprite_accessory/hair/head/gloomy_long,
		/datum/sprite_accessory/hair/head/emo_long,
		/datum/sprite_accessory/hair/head/twintail_floor,
		/datum/sprite_accessory/hair/head/sideways_ponytail,
		/datum/sprite_accessory/hair/head/dreadlocks_long,
		/datum/sprite_accessory/hair/head/rows1,
		/datum/sprite_accessory/hair/head/rows2,
		/datum/sprite_accessory/hair/head/rowbraid,
		/datum/sprite_accessory/hair/head/rowdualtail,
		/datum/sprite_accessory/hair/head/rowbun,
		/datum/sprite_accessory/hair/head/long_over_eye_alt,
		/datum/sprite_accessory/hair/head/diagonalbangs,
		/datum/sprite_accessory/hair/head/sabitsuki,
		/datum/sprite_accessory/hair/head/sabitsuki_ponytail,
		/datum/sprite_accessory/hair/head/cotton,
		/datum/sprite_accessory/hair/head/cottonalt,
		/datum/sprite_accessory/hair/head/bushy,
		/datum/sprite_accessory/hair/head/bushy_alt,
		/datum/sprite_accessory/hair/head/curtains,
		/datum/sprite_accessory/hair/head/glamourh,
		/datum/sprite_accessory/hair/head/emma,
		/datum/sprite_accessory/hair/head/damsel,
		/datum/sprite_accessory/hair/head/wavylong,
		/datum/sprite_accessory/hair/head/wavyovereye,
		/datum/sprite_accessory/hair/head/straightovereye,
		/datum/sprite_accessory/hair/head/straightside,
		/datum/sprite_accessory/hair/head/straightshort,
		/datum/sprite_accessory/hair/head/straightlong,
		/datum/sprite_accessory/hair/head/fluffball,
		/datum/sprite_accessory/hair/head/halfshave_long,
		/datum/sprite_accessory/hair/head/halfshave_long_alt,
		/datum/sprite_accessory/hair/head/halfshave_messy,
		/datum/sprite_accessory/hair/head/halfshave_messylong,
		/datum/sprite_accessory/hair/head/halfshave_messy_alt,
		/datum/sprite_accessory/hair/head/halfshave_messylong_alt,
		/datum/sprite_accessory/hair/head/halfshave_glamorous,
		/datum/sprite_accessory/hair/head/halfshave_glamorous_alt,
		/datum/sprite_accessory/hair/head/thicklong,
		/datum/sprite_accessory/hair/head/thickshort,
		/datum/sprite_accessory/hair/head/thickcurly,
		/datum/sprite_accessory/hair/head/thicklong_alt,
		/datum/sprite_accessory/hair/head/baum,
		/datum/sprite_accessory/hair/head/mcsqueeb,
		/datum/sprite_accessory/hair/head/highlander,
		/datum/sprite_accessory/hair/head/royalcurls,
		/datum/sprite_accessory/hair/head/dreadlocksmessy,
		/datum/sprite_accessory/hair/head/suave,
		/datum/sprite_accessory/hair/head/dave,
		/datum/sprite_accessory/hair/head/mediumbraid,
		/datum/sprite_accessory/hair/head/countryponytailalt,
		/datum/sprite_accessory/hair/head/ponytailwitcher,
		/datum/sprite_accessory/hair/head/spicy,
		/datum/sprite_accessory/hair/head/stacy,
		/datum/sprite_accessory/hair/head/stacybun,
		/datum/sprite_accessory/hair/head/zoey,
		/datum/sprite_accessory/hair/head/kusanagi_alt,
		/datum/sprite_accessory/hair/head/bubblebraids,
		/datum/sprite_accessory/hair/head/bubblebraids_v2,
		/datum/sprite_accessory/hair/head/heiress,
		/datum/sprite_accessory/hair/head/playful,
		/datum/sprite_accessory/hair/head/adventurer,
		/datum/sprite_accessory/hair/head/amazon_f,
		/datum/sprite_accessory/hair/head/archivist,
		/datum/sprite_accessory/hair/head/barbarian_f,
		/datum/sprite_accessory/hair/head/beartails_f,
		/datum/sprite_accessory/hair/head/berserker,
		/datum/sprite_accessory/hair/head/bob_f,
		/datum/sprite_accessory/hair/head/boss,
		/datum/sprite_accessory/hair/head/buns_f,
		/datum/sprite_accessory/hair/head/cavehead,
		/datum/sprite_accessory/hair/head/conscript,
		/datum/sprite_accessory/hair/head/courtier,
		/datum/sprite_accessory/hair/head/curly_f,
		/datum/sprite_accessory/hair/head/darkknight,
		/datum/sprite_accessory/hair/head/dome,
		/datum/sprite_accessory/hair/head/druid,
		/datum/sprite_accessory/hair/head/empress_f,
		/datum/sprite_accessory/hair/head/fancy_elf,
		/datum/sprite_accessory/hair/head/fancy_elf_f,
		/datum/sprite_accessory/hair/head/forester,
		/datum/sprite_accessory/hair/head/foreigner,
		/datum/sprite_accessory/hair/head/forged,
		/datum/sprite_accessory/hair/head/forsaken,
		/datum/sprite_accessory/hair/head/grumpy_f,
		/datum/sprite_accessory/hair/head/gnomish_f,
		/datum/sprite_accessory/hair/head/graceful,
		/datum/sprite_accessory/hair/head/heroic,
		/datum/sprite_accessory/hair/head/hearth_f,
		/datum/sprite_accessory/hair/head/hunter,
		/datum/sprite_accessory/hair/head/homely_f,
		/datum/sprite_accessory/hair/head/junia_tief_f,
		/datum/sprite_accessory/hair/head/lady_f,
		/datum/sprite_accessory/hair/head/landlord,
		/datum/sprite_accessory/hair/head/lion,
		/datum/sprite_accessory/hair/head/loosebraid_f,
		/datum/sprite_accessory/hair/head/lover_tief_m,
		/datum/sprite_accessory/hair/head/maid_f,
		/datum/sprite_accessory/hair/head/maiden_f,
		/datum/sprite_accessory/hair/head/martial,
		/datum/sprite_accessory/hair/head/majestic,
		/datum/sprite_accessory/hair/head/majestic_dwarf,
		/datum/sprite_accessory/hair/head/majestic_elf,
		/datum/sprite_accessory/hair/head/majestic_f,
		/datum/sprite_accessory/hair/head/messy_f,
		/datum/sprite_accessory/hair/head/monk,
		/datum/sprite_accessory/hair/head/miner,
		/datum/sprite_accessory/hair/head/mystery_f,
		/datum/sprite_accessory/hair/head/mysterious_elf,
		/datum/sprite_accessory/hair/head/nobility,
		/datum/sprite_accessory/hair/head/noblesse_f,
		/datum/sprite_accessory/hair/head/nomadic,
		/datum/sprite_accessory/hair/head/orc_f,
		/datum/sprite_accessory/hair/head/performer_tief_f,
		/datum/sprite_accessory/hair/head/plain_f,
		/datum/sprite_accessory/hair/head/princely,
		/datum/sprite_accessory/hair/head/pixie_f,
		/datum/sprite_accessory/hair/head/scribe,
		/datum/sprite_accessory/hair/head/soilbride_f,
		/datum/sprite_accessory/hair/head/shrine_f,
		/datum/sprite_accessory/hair/head/southern,
		/datum/sprite_accessory/hair/head/swain,
		/datum/sprite_accessory/hair/head/squire_f,
		/datum/sprite_accessory/hair/head/squire,
		/datum/sprite_accessory/hair/head/tails_f,
		/datum/sprite_accessory/hair/head/troubadour,
		/datum/sprite_accessory/hair/head/tiedlong,
		/datum/sprite_accessory/hair/head/tsidecut,
		/datum/sprite_accessory/hair/head/tied_f,
		/datum/sprite_accessory/hair/head/tiedup_f,
		/datum/sprite_accessory/hair/head/updo_f,
		/datum/sprite_accessory/hair/head/warrior,
		/datum/sprite_accessory/hair/head/wisp_f,
		/datum/sprite_accessory/hair/head/wildside,
		/datum/sprite_accessory/hair/head/woodsman_elf,
		/datum/sprite_accessory/hair/head/queenly_f,
		/datum/sprite_accessory/hair/head/zybantu,
		/datum/sprite_accessory/hair/head/chair_ponytail6,
		/datum/sprite_accessory/hair/head/chair_manbun,
		/datum/sprite_accessory/hair/head/fatherless_elf_f,
		/datum/sprite_accessory/hair/head/samurai,
		/datum/sprite_accessory/hair/head/yakuza,
		/datum/sprite_accessory/hair/head/novice,
		/datum/sprite_accessory/hair/head/steppeman,
		/datum/sprite_accessory/hair/head/bishonen,
		/datum/sprite_accessory/hair/head/emperor,
		/datum/sprite_accessory/hair/head/female,
		/datum/sprite_accessory/hair/head/empress,
		/datum/sprite_accessory/hair/head/warlady,
		/datum/sprite_accessory/hair/head/waterfield,
		/datum/sprite_accessory/hair/head/homewaifu,
		/datum/sprite_accessory/hair/head/casual,
		/datum/sprite_accessory/hair/head/martyr,
		/datum/sprite_accessory/hair/head/neuter,
		/datum/sprite_accessory/hair/head/hprotagonist,
		/datum/sprite_accessory/hair/head/alsoprotagonist,
		/datum/sprite_accessory/hair/head/ghast,
		)

/datum/customizer_choice/bodypart_feature/hair/head/humanoid/get_random_accessory(datum/customizer_entry/entry, datum/preferences/prefs)
	return pick(sprite_accessories)

/datum/customizer_choice/bodypart_feature/hair/head/humanoid/on_randomize_entry(datum/customizer_entry/entry, datum/preferences/prefs)
	var/datum/customizer_entry/hair/hair_entry = entry
	var/color = pick(HAIR_COLOR_LIST)
	hair_entry.hair_color = color

/datum/customizer/bodypart_feature/hair/head/humanoid/bald_default
	customizer_choices = list(/datum/customizer_choice/bodypart_feature/hair/head/humanoid/bald_default)

/datum/customizer_choice/bodypart_feature/hair/head/humanoid/bald_default/get_random_accessory(datum/customizer_entry/entry, datum/preferences/prefs)
	return /datum/sprite_accessory/hair/head/bald

/datum/customizer/bodypart_feature/hair/facial/humanoid
	customizer_choices = list(/datum/customizer_choice/bodypart_feature/hair/facial/humanoid)

/datum/customizer_choice/bodypart_feature/hair/facial/humanoid
	sprite_accessories = list(
		/datum/sprite_accessory/hair/facial/shaved,
		/datum/sprite_accessory/hair/facial/abe,
		/datum/sprite_accessory/hair/facial/brokenman,
		/datum/sprite_accessory/hair/facial/chinstrap,
		/datum/sprite_accessory/hair/facial/dwarf,
		/datum/sprite_accessory/hair/facial/fullbeard,
		/datum/sprite_accessory/hair/facial/croppedfullbeard,
		/datum/sprite_accessory/hair/facial/gt,
		/datum/sprite_accessory/hair/facial/hip,
		/datum/sprite_accessory/hair/facial/jensen,
		/datum/sprite_accessory/hair/facial/neckbeard,
		/datum/sprite_accessory/hair/facial/vlongbeard,
		/datum/sprite_accessory/hair/facial/muttonmus,
		/datum/sprite_accessory/hair/facial/martialartist,
		/datum/sprite_accessory/hair/facial/chinlessbeard,
		/datum/sprite_accessory/hair/facial/moonshiner,
		/datum/sprite_accessory/hair/facial/longbeard,
		/datum/sprite_accessory/hair/facial/volaju,
		/datum/sprite_accessory/hair/facial/threeoclock,
		/datum/sprite_accessory/hair/facial/fiveoclock,
		/datum/sprite_accessory/hair/facial/sevenoclock,
		/datum/sprite_accessory/hair/facial/sevenoclockm,
		/datum/sprite_accessory/hair/facial/stubble,
		/datum/sprite_accessory/hair/facial/pipe,
		/datum/sprite_accessory/hair/facial/knightly,
		/datum/sprite_accessory/hair/facial/manly,
		/datum/sprite_accessory/hair/facial/viking,
		/datum/sprite_accessory/hair/facial/moustache,
		/datum/sprite_accessory/hair/facial/fiveoclockmoustache,
		/datum/sprite_accessory/hair/facial/pencilstache,
		/datum/sprite_accessory/hair/facial/smallstache,
		/datum/sprite_accessory/hair/facial/walrus,
		/datum/sprite_accessory/hair/facial/fu,
		/datum/sprite_accessory/hair/facial/hogan,
		/datum/sprite_accessory/hair/facial/selleck,
		/datum/sprite_accessory/hair/facial/chaplin,
		/datum/sprite_accessory/hair/facial/vandyke,
		/datum/sprite_accessory/hair/facial/watson,
		/datum/sprite_accessory/hair/facial/sideburn,
		/datum/sprite_accessory/hair/facial/burns,
		/datum/sprite_accessory/hair/facial/elvis,
		/datum/sprite_accessory/hair/facial/mutton,
		)

/datum/customizer_choice/bodypart_feature/hair/facial/humanoid/get_random_accessory(datum/customizer_entry/entry, datum/preferences/prefs)
	if(prefs.gender == MALE)
		return pick(sprite_accessories)
	else
		return /datum/sprite_accessory/hair/facial/shaved

/datum/customizer_choice/bodypart_feature/hair/facial/humanoid/on_randomize_entry(datum/customizer_entry/entry, datum/preferences/prefs)
	var/datum/customizer_entry/hair/hair_entry = entry
	var/color = pick(HAIR_COLOR_LIST)
	hair_entry.hair_color = color

/datum/customizer/bodypart_feature/hair/facial/humanoid/shaved_default
	customizer_choices = list(/datum/customizer_choice/bodypart_feature/hair/facial/humanoid/shaved_default)

/datum/customizer_choice/bodypart_feature/hair/facial/humanoid/shaved_default/get_random_accessory(datum/customizer_entry/entry, datum/preferences/prefs)
	return /datum/sprite_accessory/hair/facial/shaved

/datum/customizer/bodypart_feature/hair/head/humanoid/vulpkian
	customizer_choices = list(/datum/customizer_choice/bodypart_feature/hair/head/humanoid/vulpkian)

/datum/customizer_choice/bodypart_feature/hair/head/humanoid/vulpkian
	sprite_accessories = list(
		/datum/sprite_accessory/hair/head/bald,
		/datum/sprite_accessory/hair/head/shorthaireighties,
		/datum/sprite_accessory/hair/head/shorthaireighties_alt,
		/datum/sprite_accessory/hair/head/afro,
		/datum/sprite_accessory/hair/head/afro2,
		/datum/sprite_accessory/hair/head/afro_large,
		/datum/sprite_accessory/hair/head/antenna,
		/datum/sprite_accessory/hair/head/balding,
		/datum/sprite_accessory/hair/head/bedhead,
		/datum/sprite_accessory/hair/head/bedhead2,
		/datum/sprite_accessory/hair/head/bedhead3,
		/datum/sprite_accessory/hair/head/bedheadlong,
		/datum/sprite_accessory/hair/head/badlycut,
		/datum/sprite_accessory/hair/head/beehive,
		/datum/sprite_accessory/hair/head/beehive2,
		/datum/sprite_accessory/hair/head/bob,
		/datum/sprite_accessory/hair/head/bob2,
		/datum/sprite_accessory/hair/head/bob3,
		/datum/sprite_accessory/hair/head/bob4,
		/datum/sprite_accessory/hair/head/bobcurl,
		/datum/sprite_accessory/hair/head/boddicker,
		/datum/sprite_accessory/hair/head/bowlcut,
		/datum/sprite_accessory/hair/head/bowlcut2,
		/datum/sprite_accessory/hair/head/braid,
		/datum/sprite_accessory/hair/head/front_braid,
		/datum/sprite_accessory/hair/head/not_floorlength_braid,
		/datum/sprite_accessory/hair/head/lowbraid,
		/datum/sprite_accessory/hair/head/shortbraid,
		/datum/sprite_accessory/hair/head/braided,
		/datum/sprite_accessory/hair/head/braidtail,
		/datum/sprite_accessory/hair/head/bun,
		/datum/sprite_accessory/hair/head/bun2,
		/datum/sprite_accessory/hair/head/bun3,
		/datum/sprite_accessory/hair/head/lowbun,
		/datum/sprite_accessory/hair/head/largebun,
		/datum/sprite_accessory/hair/head/manbun,
		/datum/sprite_accessory/hair/head/tightbun,
		/datum/sprite_accessory/hair/head/business,
		/datum/sprite_accessory/hair/head/business2,
		/datum/sprite_accessory/hair/head/business3,
		/datum/sprite_accessory/hair/head/business4,
		/datum/sprite_accessory/hair/head/buzz,
		/datum/sprite_accessory/hair/head/cia,
		/datum/sprite_accessory/hair/head/coffeehouse,
		/datum/sprite_accessory/hair/head/combover,
		/datum/sprite_accessory/hair/head/comet,
		/datum/sprite_accessory/hair/head/cornrows1,
		/datum/sprite_accessory/hair/head/cornrows2,
		/datum/sprite_accessory/hair/head/cornrowbraid,
		/datum/sprite_accessory/hair/head/cornrowbun,
		/datum/sprite_accessory/hair/head/cornrowdualtail,
		/datum/sprite_accessory/hair/head/crew,
		/datum/sprite_accessory/hair/head/cut,
		/datum/sprite_accessory/hair/head/dandpompadour,
		/datum/sprite_accessory/hair/head/devillock,
		/datum/sprite_accessory/hair/head/doublebun,
		/datum/sprite_accessory/hair/head/dreadlocks,
		/datum/sprite_accessory/hair/head/drillhair,
		/datum/sprite_accessory/hair/head/drillhairextended,
		/datum/sprite_accessory/hair/head/emo,
		/datum/sprite_accessory/hair/head/emo2,
		/datum/sprite_accessory/hair/head/emofringe,
		/datum/sprite_accessory/hair/head/longemo,
		/datum/sprite_accessory/hair/head/nofade,
		/datum/sprite_accessory/hair/head/lowfade,
		/datum/sprite_accessory/hair/head/medfade,
		/datum/sprite_accessory/hair/head/highfade,
		/datum/sprite_accessory/hair/head/baldfade,
		/datum/sprite_accessory/hair/head/father,
		/datum/sprite_accessory/hair/head/feather,
		/datum/sprite_accessory/hair/head/flair,
		/datum/sprite_accessory/hair/head/flattop,
		/datum/sprite_accessory/hair/head/flattop_big,
		/datum/sprite_accessory/hair/head/flow_hair,
		/datum/sprite_accessory/hair/head/gelled,
		/datum/sprite_accessory/hair/head/gentle,
		/datum/sprite_accessory/hair/head/halfbang,
		/datum/sprite_accessory/hair/head/halfbang2,
		/datum/sprite_accessory/hair/head/halfshaved,
		/datum/sprite_accessory/hair/head/hedgehog,
		/datum/sprite_accessory/hair/head/himecut,
		/datum/sprite_accessory/hair/head/himecut2,
		/datum/sprite_accessory/hair/head/shorthime,
		/datum/sprite_accessory/hair/head/himeup,
		/datum/sprite_accessory/hair/head/hitop,
		/datum/sprite_accessory/hair/head/jade,
		/datum/sprite_accessory/hair/head/jensen,
		/datum/sprite_accessory/hair/head/joestar,
		/datum/sprite_accessory/hair/head/keanu,
		/datum/sprite_accessory/hair/head/kusangi,
		/datum/sprite_accessory/hair/head/long,
		/datum/sprite_accessory/hair/head/long2,
		/datum/sprite_accessory/hair/head/long3,
		/datum/sprite_accessory/hair/head/long_over_eye,
		/datum/sprite_accessory/hair/head/longbangs,
		/datum/sprite_accessory/hair/head/longfringe,
		/datum/sprite_accessory/hair/head/sidepartlongalt,
		/datum/sprite_accessory/hair/head/megaeyebrows,
		/datum/sprite_accessory/hair/head/messy,
		/datum/sprite_accessory/hair/head/modern,
		/datum/sprite_accessory/hair/head/mohawk,
		/datum/sprite_accessory/hair/head/reversemohawk,
		/datum/sprite_accessory/hair/head/shavedmohawk,
		/datum/sprite_accessory/hair/head/unshavenmohawk,
		/datum/sprite_accessory/hair/head/mulder,
		/datum/sprite_accessory/hair/head/nitori,
		/datum/sprite_accessory/hair/head/odango,
		/datum/sprite_accessory/hair/head/ombre,
		/datum/sprite_accessory/hair/head/oneshoulder,
		/datum/sprite_accessory/hair/head/over_eye,
		/datum/sprite_accessory/hair/head/oxton,
		/datum/sprite_accessory/hair/head/parted,
		/datum/sprite_accessory/hair/head/partedside,
		/datum/sprite_accessory/hair/head/pigtails,
		/datum/sprite_accessory/hair/head/pigtails2,
		/datum/sprite_accessory/hair/head/pigtails3,
		/datum/sprite_accessory/hair/head/kagami,
		/datum/sprite_accessory/hair/head/pixie,
		/datum/sprite_accessory/hair/head/pompadour,
		/datum/sprite_accessory/hair/head/bigpompadour,
		/datum/sprite_accessory/hair/head/ponytail1,
		/datum/sprite_accessory/hair/head/ponytail2,
		/datum/sprite_accessory/hair/head/ponytail3,
		/datum/sprite_accessory/hair/head/ponytail4,
		/datum/sprite_accessory/hair/head/ponytail5,
		/datum/sprite_accessory/hair/head/ponytail6,
		/datum/sprite_accessory/hair/head/ponytail7,
		/datum/sprite_accessory/hair/head/highponytail,
		/datum/sprite_accessory/hair/head/longponytail,
		/datum/sprite_accessory/hair/head/stail,
		/datum/sprite_accessory/hair/head/countryponytail,
		/datum/sprite_accessory/hair/head/fringetail,
		/datum/sprite_accessory/hair/head/sidetail,
		/datum/sprite_accessory/hair/head/sidetail2,
		/datum/sprite_accessory/hair/head/sidetail3,
		/datum/sprite_accessory/hair/head/sidetail4,
		/datum/sprite_accessory/hair/head/spikyponytail,
		/datum/sprite_accessory/hair/head/poofy,
		/datum/sprite_accessory/hair/head/quiff,
		/datum/sprite_accessory/hair/head/ronin,
		/datum/sprite_accessory/hair/head/shaved,
		/datum/sprite_accessory/hair/head/shavedpart,
		/datum/sprite_accessory/hair/head/shortbangs,
		/datum/sprite_accessory/hair/head/short,
		/datum/sprite_accessory/hair/head/shorthair2,
		/datum/sprite_accessory/hair/head/shorthair3,
		/datum/sprite_accessory/hair/head/shorthair7,
		/datum/sprite_accessory/hair/head/rosa,
		/datum/sprite_accessory/hair/head/shoulderlength,
		/datum/sprite_accessory/hair/head/sidecut,
		/datum/sprite_accessory/hair/head/skinhead,
		/datum/sprite_accessory/hair/head/protagonist,
		/datum/sprite_accessory/hair/head/spiky,
		/datum/sprite_accessory/hair/head/spiky2,
		/datum/sprite_accessory/hair/head/spiky3,
		/datum/sprite_accessory/hair/head/swept,
		/datum/sprite_accessory/hair/head/swept2,
		/datum/sprite_accessory/hair/head/thinning,
		/datum/sprite_accessory/hair/head/thinningfront,
		/datum/sprite_accessory/hair/head/thinningrear,
		/datum/sprite_accessory/hair/head/topknot,
		/datum/sprite_accessory/hair/head/tressshoulder,
		/datum/sprite_accessory/hair/head/trimmed,
		/datum/sprite_accessory/hair/head/trimflat,
		/datum/sprite_accessory/hair/head/twintails,
		/datum/sprite_accessory/hair/head/undercut,
		/datum/sprite_accessory/hair/head/undercutleft,
		/datum/sprite_accessory/hair/head/undercutright,
		/datum/sprite_accessory/hair/head/unkept,
		/datum/sprite_accessory/hair/head/updo,
		/datum/sprite_accessory/hair/head/longer,
		/datum/sprite_accessory/hair/head/longest,
		/datum/sprite_accessory/hair/head/longest2,
		/datum/sprite_accessory/hair/head/veryshortovereye,
		/datum/sprite_accessory/hair/head/longestalt,
		/datum/sprite_accessory/hair/head/volaju,
		/datum/sprite_accessory/hair/head/wisp,
		/datum/sprite_accessory/hair/head/hyenamane,
		/datum/sprite_accessory/hair/head/forelock,
		/datum/sprite_accessory/hair/head/pirate,
		/datum/sprite_accessory/hair/head/shavedmohawk,
		/datum/sprite_accessory/hair/head/baldfade,
		/datum/sprite_accessory/hair/head/rogue,
		/datum/sprite_accessory/hair/head/romantic,
		/datum/sprite_accessory/hair/head/runt,
		/datum/sprite_accessory/hair/head/son,
		/datum/sprite_accessory/hair/head/bog,
		/datum/sprite_accessory/hair/head/scout,
		/datum/sprite_accessory/hair/head/son2,
		/datum/sprite_accessory/hair/head/long4,
		/datum/sprite_accessory/hair/head/amazon,
		/datum/sprite_accessory/hair/head/longstraightponytail,
		/datum/sprite_accessory/hair/head/barmaid,
		/datum/sprite_accessory/hair/head/bob_rt,
		/datum/sprite_accessory/hair/head/messy_rt,
		/datum/sprite_accessory/hair/head/homely,
		/datum/sprite_accessory/hair/head/longtails,
		/datum/sprite_accessory/hair/head/hime,
		/datum/sprite_accessory/hair/head/tied,
		/datum/sprite_accessory/hair/head/tied2,
		/datum/sprite_accessory/hair/head/fatherless,
		/datum/sprite_accessory/hair/head/fatherless2,
		/datum/sprite_accessory/hair/head/kepthair,
		/datum/sprite_accessory/hair/head/singlebraid,
		/datum/sprite_accessory/hair/head/gloomy,
		/datum/sprite_accessory/hair/head/gloomylong,
		/datum/sprite_accessory/hair/head/shortmessy,
		/datum/sprite_accessory/hair/head/mediumessy,
		/datum/sprite_accessory/hair/head/zone,
		/datum/sprite_accessory/hair/head/inari,
		/datum/sprite_accessory/hair/head/ziegler,
		/datum/sprite_accessory/hair/head/gronnbraid,
		/datum/sprite_accessory/hair/head/grenzelcut,
		/datum/sprite_accessory/hair/head/fluffy,
		/datum/sprite_accessory/hair/head/fluffyshort,
		/datum/sprite_accessory/hair/head/fluffylong,
		/datum/sprite_accessory/hair/head/jay,
		/datum/sprite_accessory/hair/head/hairfre,
		/datum/sprite_accessory/hair/head/dawn,
		/datum/sprite_accessory/hair/head/morning,
		/datum/sprite_accessory/hair/head/kobeni_1,
		/datum/sprite_accessory/hair/head/kobeni_2,
		/datum/sprite_accessory/hair/head/vulpkian/anita,
		/datum/sprite_accessory/hair/head/vulpkian/jagged,
		/datum/sprite_accessory/hair/head/vulpkian/kajam1,
		/datum/sprite_accessory/hair/head/vulpkian/kajam2,
		/datum/sprite_accessory/hair/head/vulpkian/keid,
		/datum/sprite_accessory/hair/head/vulpkian/mizar,
		/datum/sprite_accessory/hair/head/vulpkian/raine,
		)


/datum/customizer/bodypart_feature/hair/head/vox
	customizer_choices = list(/datum/customizer_choice/bodypart_feature/hair/head/vox)

/datum/customizer_choice/bodypart_feature/hair/head/vox
	sprite_accessories = list(
		/datum/sprite_accessory/hair/head/bald,
		/datum/sprite_accessory/hair/head/vox/afro,
		/datum/sprite_accessory/hair/head/vox/crestedquills,
		/datum/sprite_accessory/hair/head/vox/emperorquills,
		/datum/sprite_accessory/hair/head/vox/horns,
		/datum/sprite_accessory/hair/head/vox/keelquills,
		/datum/sprite_accessory/hair/head/vox/keetquills,
		/datum/sprite_accessory/hair/head/vox/kingly,
		/datum/sprite_accessory/hair/head/vox/mohawk,
		/datum/sprite_accessory/hair/head/vox/nights,
		/datum/sprite_accessory/hair/head/vox/razorclipped,
		/datum/sprite_accessory/hair/head/vox/razor,
		/datum/sprite_accessory/hair/head/vox/shortquills,
		/datum/sprite_accessory/hair/head/vox/tielquills,
		/datum/sprite_accessory/hair/head/vox/yasu,
		)

/datum/customizer/bodypart_feature/hair/facial/vox
	customizer_choices = list(/datum/customizer_choice/bodypart_feature/hair/facial/vox)

/datum/customizer_choice/bodypart_feature/hair/facial/vox
	sprite_accessories = list(
		/datum/sprite_accessory/hair/facial/shaved,
		/datum/sprite_accessory/hair/facial/vox/beard,
		/datum/sprite_accessory/hair/facial/vox/colonel,
		/datum/sprite_accessory/hair/facial/vox/fu,
		/datum/sprite_accessory/hair/facial/vox/neck,
		)
