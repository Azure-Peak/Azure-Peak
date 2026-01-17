/datum/mob_descriptor/stature
	abstract_type = /datum/mob_descriptor/stature
	slot = MOB_DESCRIPTOR_SLOT_STATURE

/datum/mob_descriptor/stature/man
	name = "Man/Woman"

/datum/mob_descriptor/stature/man/get_description(mob/living/described)
	switch(described.pronouns)
		if(SHE_HER)
			return "woman"
		if(SHE_HER_M)
			return "woman"
		if(HE_HIM)
			return "man"
		if(HE_HIM_F)
			return "man"
		if(THEY_THEM)
			return "person"
		if(THEY_THEM_F)
			return "person"
		else
			return "creacher"


/datum/mob_descriptor/stature/gentleman
	name = "Gentleman/Gentlewoman"
/datum/mob_descriptor/stature/gentleman/get_description(mob/living/described)
	switch(described.pronouns)
		if(SHE_HER)
			return "gentlewoman"
		if(SHE_HER_M)
			return "gentlewoman"
		if(HE_HIM)
			return "gentleman"
		if(HE_HIM_F)
			return "gentleman"
		if(THEY_THEM)
			return "gentleperson"
		if(THEY_THEM_F)
			return "gentleperson"
		else
			return "gentlecreacher"
/datum/mob_descriptor/stature/patriarch
	name = "Patriarch/Matriarch"
/datum/mob_descriptor/stature/patriarch/get_description(mob/living/described)
	switch(described.pronouns)
		if(SHE_HER)
			return "matriarch"
		if(HE_HIM)
			return "patriarch"
		if(THEY_THEM)
			return "hierarch"
		if(THEY_THEM_F)
			return "hierarch"
		else
			return "hierarch"
/datum/mob_descriptor/stature/hag
	name = "Hag/Codger"
/datum/mob_descriptor/stature/hag/get_description(mob/living/described)
	switch(described.pronouns)
		if(SHE_HER)
			return "hag"
		if(HE_HIM)
			return "codger"
		if(THEY_THEM)
			return "senior"
		if(THEY_THEM_F)
			return "senior"
		else
			return "elder"
/datum/mob_descriptor/stature/villain
	name = "Villain/Villainess"
/datum/mob_descriptor/stature/villain/get_description(mob/living/described)
	switch(described.pronouns)
		if(SHE_HER)
			return "villainess"
		if(HE_HIM)
			return "villain"
		if(THEY_THEM)
			return "antagonist"
		if(THEY_THEM_F)
			return "antagonist"
		else
			return "antagonist"

/datum/mob_descriptor/stature/thug
	name = "Thug"
/datum/mob_descriptor/stature/knave
	name = "Knave"
/datum/mob_descriptor/stature/wench
	name = "Wench"
/datum/mob_descriptor/stature/snob
	name = "Snob"
/datum/mob_descriptor/stature/slob
	name = "Slob"
/datum/mob_descriptor/stature/brute
	name = "Brute"
/datum/mob_descriptor/stature/highbrow
	name = "Highbrow"
/datum/mob_descriptor/stature/scholar
	name = "Scholar"
/datum/mob_descriptor/stature/rogue
	name = "Rogue"
/datum/mob_descriptor/stature/hermit
	name = "Hermit"
/datum/mob_descriptor/stature/pushover
	name = "Pushover"
/datum/mob_descriptor/stature/beguiler
	name = "Beguiler"
/datum/mob_descriptor/stature/daredevil
	name = "Daredevil"
/datum/mob_descriptor/stature/valiant
	name = "Valiant"
/datum/mob_descriptor/stature/adventurer
	name = "Adventurer"
/datum/mob_descriptor/stature/fiend
	name = "Fiend"
/datum/mob_descriptor/stature/stoic
	name = "Stoic"
/datum/mob_descriptor/stature/stooge
	name = "Stooge"
/datum/mob_descriptor/stature/fool
	name = "Fool"
/datum/mob_descriptor/stature/bookworm
	name = "Bookworm"
/datum/mob_descriptor/stature/lowlife
	name = "Lowlife"

/datum/mob_descriptor/stature/dignitary
	name = "Dignitary"

/datum/mob_descriptor/stature/degenerate
	name = "Degenerate"

/datum/mob_descriptor/stature/zealot
	name = "Zealot"

/datum/mob_descriptor/stature/churl
	name = "Churl"

/datum/mob_descriptor/stature/archon
	name = "Archon"

/datum/mob_descriptor/stature/vizier
	name = "Vizier"

/datum/mob_descriptor/stature/blaggard
	name = "Blaggard"

/datum/mob_descriptor/stature/creep
	name = "Creep"

/datum/mob_descriptor/stature/freek
	name = "Freek"

/datum/mob_descriptor/stature/weerdoe
	name = "Weerdoe"

/datum/mob_descriptor/stature/plump
	name = "Plump figure"

/datum/mob_descriptor/stature/savant
	name = "Savant"

/datum/mob_descriptor/stature/wanderer
	name = "Wanderer"

/datum/mob_descriptor/stature/hustler
	name = "Hustler"

/datum/mob_descriptor/stature/samaritan
	name = "Samaritan"

/datum/mob_descriptor/stature/pupil
	name = "Pupil"

/datum/mob_descriptor/stature/soldier
	name = "Soldier"

/datum/mob_descriptor/stature/recluse
	name = "Recluse"

/datum/mob_descriptor/stature/socialite
	name = "Socialite"

/datum/mob_descriptor/stature/shitheel
	name = "Shitheel"

/datum/mob_descriptor/stature/critter
	name = "Critter"

// this one technically already exists but it was a very specific selection choice & i've got a request to add it
/datum/mob_descriptor/stature/creacher
	name = "Creacher"

/datum/mob_descriptor/stature/cur
	name = "Cur"

/datum/mob_descriptor/stature/wretch
	name = "Wretch"

/datum/mob_descriptor/stature/dullard
	name = "Dullard"

// basterd. specifically basterd. it is funnier this way.
/datum/mob_descriptor/stature/basterd
	name = "Basterd"
