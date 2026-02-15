// Race list means RESTRICTED from the LISTED races.
/datum/virtue/origin
	var/granted_language = null
	var/origin_name = "Unknown"

/datum/virtue/origin/unknown
	name = "Unknown"
	desc = "I hail from nowhere in particular, thus I know no regional tongue in particular.<br>"
	origin_desc = "Wanderers, peasantry, abandoned orphans or souls left to wander the bygone world, with no identity associated with them."

/datum/virtue/origin/proc/apply_language(mob/living/carbon/human/recipient)
	if(granted_language && recipient && recipient.mind)
		recipient.grant_language(granted_language)

/datum/virtue/origin/azuria
	name = "Azurian"
	origin_name = "Azuria"
	desc = "I originate from the settled lands of Azuria, an independent domain sandwiched between Otava and Grenzelhoft. Famed for its delicious waffles and many ancient ruins, it is neither prosperous nor well-respected.<br>"
	restricted = FALSE
	granted_language = /datum/language/oldazurian
	origin_desc = "PING THE LORE TEAM TO ADD THIS"

/datum/virtue/origin/grenzelhoft
	name = "Grenzelhoftian"
	origin_name = "Grenzelhoft"
	granted_language = /datum/language/grenzelhoftian
	desc = "I originate from the dark boreal woods of Grenzelhoft, the birthplace of humanity. The Empire has a long history of conflict with Otava. Long live emperor Kovel II!<br>"
	origin_desc = "Believed to be the birthplace of humanity, the Grenzelhoft region is steeped in tradition and history.<br> Loosely organized under Emperor Kövel II, the \
	Grenzelhoft Empire once spanned all the way from the Hammerhold mountains to the Southern Sea. Its current state is far smaller, reduced to a decentralized body of \
	principalities which vie for control over the Imperial electorate.<br> Grenzelhoft is unique in that it maintains a professional army, funded by contracting its soldiers \
	out as imperial mercenaries during peacetime. The Empire has a long history of conflict with Otava, though recent decades have finally seen a tentative peace between \
	the two powers."

/datum/virtue/origin/etrusca
	name = "Etruscan"
	origin_name = "Etrusca"
	granted_language = /datum/language/etruscan
	desc = "I originate from tropical Etrusca, an archipelago of maritime city-states located off the eastern coast of Otava. Skilled traders and sailors, Etruscans have probably rubbed shoulders (or other parts) with more races than most humens know exist.<br>"
	origin_desc = "An archipelago of maritime city-states located off the eastern coast of the Otavan countryside.<br> Etrusca is not one unified state, existing instead as \
	many different polities, each with their own regional traditions and dialects. Etruscans are known for their seafaring technology and typically make for strong \
	sailors, but many Etruscans are also unafraid to raise the black flag and turn to piracy, resulting in a reputation that is dubious at best."

/datum/virtue/origin/otava
	name = "Otavan"
	origin_name = "Otava"
	granted_language = /datum/language/otavan
	desc = "I originate from the gently rolling hills of Otava, a religious union of duchies and counties who answer to the Patriarch of the Otavan Archdiocese.<br>"
	origin_desc = "A religious union of duchies and counties who answer to the Patriarch of the Otavan Archdiocese.<br> Otava is a deeply devout country and exists as a \
	Psydonian theocracy. It's most famous for its winemaking and textile industries, as well as its rich culture and cuisine. The Otavan countryside is well-known for \
	its idyllic landscape and warm climate. However, Otavan society is deeply feudalistic, with serfdom rigidly enforced among its people. Otava technically abolished \
	slavery centuries ago during the Psydonian Renewal, but lasting effects can still be seen in Otavan society.<br> While Otava is populated by all manner of races, the \
	blue-blooded dark elves enjoy a uniquely privileged position in Otavan society, and were among the first groups of people to adopt Psydonian worship during its \
	revival in the schism.<br> The unsanctioned use of magic is illegal in Otava, punishable by branding and the removal of one's tongue."

/datum/virtue/origin/gronn
	name = "Gronnic"
	origin_name = "Gronn"
	granted_language = /datum/language/gronnic
	desc = "I originate from the brisk grasslands of Gronn, a tribal confederation of northmen and half-orcs nestled in the Skol River Valley. Gronnic culture is fierce, martial and vengeful, and blood feuds still split the clans to this day.<br>"
	origin_desc = "A tribal confederation of northmen and half-orcs nestled in the Skol River Valley.<br> Centuries of war between humen and orcs have stained these grassy \
	plains, but a shaky peace was eventually brought when the half-orc warlord Gronn used a clever mix of force and diplomacy to unite the people of the valley into one \
	loose confederation. Many years after the warlord's death, the League still remains, though it is still prone to constant small-scale internal conflict. At the same \
	time, the skirmishes between these loosely-aligned tribes has brought its own form of assimilation.<br> Full-blooded orcs are exceedingly rare in the modern day, and it \
	is not uncommon in Gronn to see half-orcs and humens living in coexistence. The region is a vital source of salt, iron, and timber, and is known for a love of \
	fermented foods and strong, bitter liquor."

/datum/virtue/origin/raneshen
	name = "Ranesheni"
	origin_name = "Raneshan"
	granted_language = /datum/language/celestial
	desc = "I originate from the lush valleys and harsh badlands of Raneshen. Home to the zealous sun elves, the region sits at the gateway between the East and West. Recently engulfed in a violent holy war between the followers of the Old God and the Solarin.<br>"
	origin_desc = "Home to the zealous sun elves, the region of Raneshen sits at the gateway between the East and West.<br> Its lands were once ruled by the Solarin, a divine \
	caste of Astratan sun elf paladins who deeply venerated Astrata and practiced widespread humen slavery. The empire met its end when an Otavan missionary brought the \
	word of PSYDON to Raneshen, sparking a slave rebellion that saw the reign of the Solarin fractured into disconnected elven and humen states. Religious violence \
	between Astratan and Psydonians is even more widespread in Raneshen than it is in the West.<br> The region itself is known for lush river-valleys, with lethally-hot \
	deserts and harsh, rocky badlands forming natural borders. Most trade from Kazengun and Naledi flows through Raneshen, and Ranesheni merchants are said to be just as \
	vicious as their sword-sworn Janissaries."

/datum/virtue/origin/naledi
	name = "Naledian"
	origin_name = "Naledi"
	granted_language = /datum/language/celestial
	desc = "I originate from the sandy dunes of Naledi, known for its mages and scholars. Its people keep to the traditions of the Old God, even in the empire's dying age.<br>"
	origin_desc = "When the Tennite faith first swept through the world many centuries ago, the people of Naledi were left entirely untouched.<br> Though knowledge of PSYDON \
	had faded under Astrata's eye, for the Naledi people, the traditions of the Old God have remained alive and well since the dawn of time - a fact that their libraries \
	have carefully recorded. The Naledi are poorly known to the West, and most travelers from the region come as traders or scholars. What is known is that the region is \
	rich in gold, and that its people look to the stars for divine knowledge of our world.<br> It is rumored that the Naledi Emir is over five hundred years old, owing his \
	long lifespan to closely-guarded alchemical secrets."

/datum/virtue/origin/kazengun
	name = "Kazengite"
	origin_name = "Kazengun"
	granted_language = /datum/language/kazengunese
	desc = "I originate from the temperate forests of Kazengun, a region poorly known to the West. Its people worship a syncretic variation of the Divine Pantheon, often percieved as heretical.<br>"
	origin_desc = "PLEASE PING THE LORE TEAM TO ADD LORE FOR THIS"

/datum/virtue/origin/hammerhold
	name = "Hammerholdian"
	origin_name = "Hammerhold"
	granted_language = /datum/language/dwarvish
	desc = "I originate from mountainous Hammerhold, a frigid archipelago in the far north. The region is considered the homeland of the Dwarves.<br>"
	origin_desc = "PLEASE PING THE LORE TEAM TO ADD LORE FOR THIS"

/datum/virtue/origin/avar
	name = "Aavnic"
	origin_name = "Avar"
	granted_language = /datum/language/aavnic
	desc = "I originate from the open plains of Avar, a nomadic people residing the Aavnic steppes. The only settled land consists of small, independent city-states, often engulfed in war with eachother.<br>"
	origin_desc = "PLEASE PING THE LORE TEAM TO ADD LORE FOR THIS"

/datum/virtue/origin/racial/underdark
	name = "Underdweller"
	granted_language = /datum/language/otavan
	origin_name = "the Underdark"
	desc = "I originate from the treacherous Underdark, a cavernous region beneath Otava and Grenzelhoft. This unforgiving land is dominated by the prosperous and cruel dark elves and their pets. Most surfacedwellers only come here in chains.<br>"
	restricted = TRUE
	races = list(/datum/species/elf/dark,
				/datum/species/moth,
				/datum/species/kobold,
				/datum/species/halforc,
				/datum/species/goblinp,
				/datum/species/anthromorph,
				/datum/species/anthromorphsmall
)
	origin_desc = "PLEASE PING THE LORE TEAM TO ADD LORE FOR THIS"

/datum/virtue/origin/apply_to_human(mob/living/carbon/human/recipient)
	addtimer(CALLBACK(src, .proc/apply_language, recipient), 50)
	recipient.dna.species.origin = origin_name
