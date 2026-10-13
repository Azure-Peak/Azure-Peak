/datum/reagent/consumable/brew/bogtea
	name = "Bog Tea"
	description = "Before the bog guard was dissolved, this was their unofficial drink of choice. Doesn't addle the mind"
	color = "#addfad"
	taste_description = "resinous herbaceousness"

/datum/reagent/consumable/brew/minttea
	cuisine = CUISINE_ETRUSCAN
	quality = DRINK_NICE
	name = "Mint Tea"
	description = "Steeped minthra. Etruscans love this stuff before going out for courting."
	color = "#e5ffe5"
	taste_description = "peppermint"
	brew_buff = /datum/status_effect/buff/brew/intelligence

/datum/reagent/consumable/brew/wormwoodtea
	name = "Wormwood Tea"
	description = "Usually this is used as an intense bittering herb. Why would you drink this pure?"
	color = "#2f4f4f"
	taste_description = "extreme bitterness"

/datum/reagent/consumable/brew/wormwoodtea/on_mob_life(mob/living/carbon/M)
	. = ..()
	if(ishuman(M))
		var/mob/living/carbon/human/HM = M
		if(!(HM.favorite_drink & drink_type))
			M.add_stress(/datum/stressevent/bittertea)

/datum/reagent/consumable/brew/sagetea
	cuisine = CUISINE_NORTH_IMPERIAL
	quality = DRINK_NICE
	name = "Sage Tea"
	description = "A pungent flavour, but favoured by Grenzelhoftian grandmothers to cure the sniffles."
	color = "#c2b280"
	taste_description = "herbal pepperiness"

/datum/reagent/consumable/brew/valeriantea
	cuisine = CUISINE_SOUTH_IMPERIAL
	quality = DRINK_NICE
	name = "Valerian Tea"
	description = "Most people don’t drink this for its taste, but because it is reputed to ward off nightmares."
	color = "#967117"
	taste_description = "musky bitterness"

/datum/reagent/consumable/brew/baothatea
	name = "Baothan Tea"
	description = "Those with little regard for their lyfe or Baothans drink this."
	color = "#ba55d3"
	taste_description = "sweet oblivion"

/datum/reagent/consumable/brew/baothatea/on_mob_life(mob/living/carbon/M)
	. = ..()
	if(!HAS_TRAIT(M, TRAIT_DEPRAVED) && volume > 0.09)
		if(isdwarf(M))
			M.add_nausea(1)
			M.adjustToxLoss(1)
		else
			M.add_nausea(3)
			M.adjustToxLoss(2.5)

/datum/reagent/consumable/brew/eyebrighttea
	cuisine = CUISINE_SOUTH_IMPERIAL
	quality = DRINK_NICE
	name = "Euphrasia Tea"
	description = "Old people drink this to keep their eyes sharp. Some say elves distill its oil for a better effect."
	color = "#f3e5ab"
	taste_description = "astringent, herbal bitterness"
	brew_buff = /datum/status_effect/buff/brew/perception

/datum/reagent/consumable/caffeine/bloomtea
	cuisine = CUISINE_NORTH_IMPERIAL|CUISINE_NORTHERN
	quality = DRINK_NICE
	name = "Bloom Tea"
	description = "The drink of choice of the Celestial Academy, reputed to recover magical fatigue. Everyone knows they just like the pretty, deep blue colour."
	reagent_state = LIQUID
	color = "#000080"
	taste_description = "tingling lightning"
	overdose_threshold = 0
	metabolization_rate = REAGENTS_METABOLISM

/datum/reagent/consumable/brew/eorantea
	cuisine = CUISINE_OTAVAIS|CUISINE_ETRUSCAN
	quality = DRINK_NICE
	name = "Eoran Tea"
	description = "Every child from Gronn to Naledi knows - if you are sick, drink this. You will feel better. At least that is what parents insist on."
	color = "#e9d66b"
	taste_description = "citric earthiness"

/datum/reagent/consumable/brew/eorantea/on_mob_life(mob/living/carbon/M)
	. = ..()
	brew_mend(M, 0.1, 0.1)

/datum/reagent/consumable/brew/ashtea
	name = "Ash Tea"
	description = "This is like zig ends steeped in hot water. Yummy."
	color = "#4b5320"
	taste_description = "zig stubs"

/datum/reagent/consumable/brew/ashtea/on_mob_life(mob/living/carbon/M)
	. = ..()
	M.add_nausea(1)

/datum/reagent/consumable/brew/psytea
	cuisine = CUISINE_OTAVAIS|CUISINE_RANESHENI
	quality = DRINK_NICE
	name = "Pilgrim Tea"
	description = "A favourite among psydonic pilgrims, the hardy plant makes for a surprisingly palatable tea."
	color = "#87a96b"
	taste_description = "nostalgic herbaceousness"
	brew_buff = /datum/status_effect/buff/brew/willpower

/datum/reagent/consumable/brew/dandelioncoffee
	name = "Dandelion Coffee"
	description = "Ravoxians and Graggarites alike drink this when not feasting, for it's reputed to give you a lion’s heart."
	color = "#fdee00"
	taste_description = "dark, nutty bitterness"
	brew_buff = /datum/status_effect/buff/brew/constitution

/datum/reagent/consumable/brew/nettletea
	cuisine = CUISINE_NORTH_IMPERIAL|CUISINE_NORTHERN
	quality = DRINK_NICE
	name = "Nettle Tea"
	description = "Drunk by soldiers who want to freshen up their water rations in the field."
	color = "#87a96b"
	taste_description = "mild herbaceousness"

/datum/reagent/consumable/brew/chamomiletea
	cuisine = CUISINE_NORTH_IMPERIAL|CUISINE_SOUTH_IMPERIAL|CUISINE_NORTHERN|CUISINE_ETRUSCAN
	quality = DRINK_NICE
	name = "Chamomile Tea"
	description = "Nine barber-surgeons in ten prescribe this for tooth aches. The tenth just pulls it out."
	color = "#b8860b"
	taste_description = "herbaceous grassiness"
