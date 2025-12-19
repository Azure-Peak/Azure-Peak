// Race list means RESTRICTED from the LISTED races. Azurian is the only non-restricted origin; its race list is a holdover.

/datum/virtue/origin/racial/azuria
	name = "Azurian"
	desc = "I originate from the settled lands of Azuria, an independent domain sandwiched between Otava and Grenzelhoft. Famed for its delicious waffles and many ancient ruins, it is neither prosperous nor well-respected.<br>"
	custom_text = "Grants free language."
	extra_language = TRUE
	races = list(/datum/species/human/northern,
				/datum/species/demihuman,
				/datum/species/elf/wood,
				/datum/species/human/halfelf,
				/datum/species/anthromorph,
				/datum/species/vulpkanin,
				/datum/species/anthromorphsmall,
				/datum/species/lizardfolk,
				/datum/species/dullahan,
				/datum/species/dwarf/mountain
)
	origin_desc = "An independent domain sandwiched between Otava and Grenzelhoft, positioned the eastern edge of the Greywall mountain range.<br> Azuria sits on a key \
	passageway through the Greywall, and its harbor offers a neutral port for merchants and travelers. As a result, the Reach is host to a number of foreigners, including \
	those from distant lands. Due to this valuable strategic position, however, both the Empire and the Holy Dominion constantly vie for control over the Reach. Yet \
	Scarlet Reach still enjoys a tentative position of neutrality.<br> Both countries are currently locked in a stalemate, as neither the Patriarch of Otava nor the Emperor \
	of Grenzelhoft are willing to see open war break out."

/datum/virtue/origin/grenzelhoft
	name = "Grenzelhoftian"
	desc = "I originate from the dark boreal woods of Grenzelhoft, the birthplace of humanity. The Empire has a long history of conflict with Otava. Long live emperor Kovel II!<br>"
	restricted = TRUE
	races = list(/datum/species/elf/dark,
				/datum/species/halforc,
				/datum/species/tabaxi,
				/datum/species/goblinp,
				/datum/species/akula
)
	origin_desc = "Believed to be the birthplace of humanity, the Grenzelhoft region is steeped in tradition and history.<br> Loosely organized under Emperor Kövel II, the \
	Grenzelhoft Empire once spanned all the way from the Hammerhold mountains to the Southern Sea. Its current state is far smaller, reduced to a decentralized body of \
	principalities which vie for control over the Imperial electorate.<br> Grenzelhoft is unique in that it maintains a professional army, funded by contracting its soldiers \
	out as imperial mercenaries during peacetime. The Empire has a long history of conflict with Otava, though recent decades have finally seen a tentative peace between \
	the two powers."

/datum/virtue/origin/etrusca
	name = "Etruscan"
	desc = "I originate from tropical Etrusca, an archipelago of maritime city-states located off the eastern coast of Otava. Skilled traders and sailors, Etruscans have probably rubbed shoulders (or other parts) with more races than most humens know exist.<br>"
	restricted = TRUE
	races = list(/datum/species/elf/dark,
				/datum/species/moth,
				/datum/species/halforc,
				/datum/species/goblinp
)
	origin_desc = "An archipelago of maritime city-states located off the eastern coast of the Otavan countryside.<br> Etrusca is not one unified state, existing instead as \
	many different polities, each with their own regional traditions and dialects. Etruscans are known for their seafaring technology and typically make for strong \
	sailors, but many Etruscans are also unafraid to raise the black flag and turn to piracy, resulting in a reputation that is dubious at best."

/datum/virtue/origin/otava
	name = "Otavan"
	desc = "I originate from the gently rolling hills of Otava, a religious union of duchies and counties who answer to the Patriarch of the Otavan Archdiocese.<br>"
	restricted = TRUE
	races = list(/datum/species/construct,
				/datum/species/halforc,
				/datum/species/goblinp
)
	origin_desc = "A religious union of duchies and counties who answer to the Patriarch of the Otavan Archdiocese.<br> Otava is a deeply devout country and exists as a \
	Psydonian theocracy. It's most famous for its winemaking and textile industries, as well as its rich culture and cuisine. The Otavan countryside is well-known for \
	its idyllic landscape and warm climate. However, Otavan society is deeply feudalistic, with serfdom rigidly enforced among its people. Otava technically abolished \
	slavery centuries ago during the Psydonian Renewal, but lasting effects can still be seen in Otavan society.<br> While Otava is populated by all manner of races, the \
	blue-blooded dark elves enjoy a uniquely privileged position in Otavan society, and were among the first groups of people to adopt Psydonian worship during its \
	revival in the schism.<br> The unsanctioned use of magic is illegal in Otava, punishable by branding and the removal of one's tongue."

/datum/virtue/origin/racial/gronn
	name = "Gronnic"
	desc = "I originate from the brisk grasslands of Gronn, a tribal confederation of northmen and half-orcs nestled in the Skol River Valley. Gronnic culture is fierce, martial and vengeful, and blood feuds still split the clans to this day.<br>"
	races = list(/datum/species/halforc,
				/datum/species/goblinp,
				/datum/species/human/northern,
				/datum/species/lupian,
				/datum/species/kobold
)
	origin_desc = "A tribal confederation of northmen and half-orcs nestled in the Skol River Valley.<br> Centuries of war between humen and orcs have stained these grassy \
	plains, but a shaky peace was eventually brought when the half-orc warlord Gronn used a clever mix of force and diplomacy to unite the people of the valley into one \
	loose confederation. Many years after the warlord's death, the League still remains, though it is still prone to constant small-scale internal conflict. At the same \
	time, the skirmishes between these loosely-aligned tribes has brought its own form of assimilation.<br> Full-blooded orcs are exceedingly rare in the modern day, and it \
	is not uncommon in Gronn to see half-orcs and humens living in coexistence. The region is a vital source of salt, iron, and timber, and is known for a love of \
	fermented foods and strong, bitter liquor."

/datum/virtue/origin/raneshen
	name = "Ranesheni"
	desc = "I originate from the lush valleys and harsh badlands of Raneshen. Home to the zealous sun elves, the region sits at the gateway between the East and West. Recently engulfed in a violent holy war between the followers of the Old God and the Solarin.<br>"
	restricted = TRUE
	races = list(/datum/species/elf/dark,
				/datum/species/halforc,
				/datum/species/goblinp,
				/datum/species/lupian,
				/datum/species/moth,
				/datum/species/akula,
				/datum/species/kobold,
				/datum/species/vulpkanin,
				/datum/species/dracon
)
	origin_desc = "Home to the zealous sun elves, the region of Raneshen sits at the gateway between the East and West.<br> Its lands were once ruled by the Solarin, a divine \
	caste of Astratan sun elf paladins who deeply venerated Astrata and practiced widespread humen slavery. The empire met its end when an Otavan missionary brought the \
	word of PSYDON to Raneshen, sparking a slave rebellion that saw the reign of the Solarin fractured into disconnected elven and humen states. Religious violence \
	between Astratan and Psydonians is even more widespread in Raneshen than it is in the West.<br> The region itself is known for lush river-valleys, with lethally-hot \
	deserts and harsh, rocky badlands forming natural borders. Most trade from Kazengun and Naledi flows through Raneshen, and Ranesheni merchants are said to be just as \
	vicious as their sword-sworn Janissaries."

/datum/virtue/origin/naledi
	name = "Naledian"
	desc = "I originate from the sandy dunes of Naledi, known for its mages and scholars. Its people keep to the traditions of the Old God, even in the empire's dying age.<br>"
	restricted = TRUE
	races = list(/datum/species/elf/dark,
				/datum/species/halforc,
				/datum/species/goblinp,
				/datum/species/lupian,
				/datum/species/moth,
				/datum/species/akula,
				/datum/species/lizardfolk,
				/datum/species/kobold,
				/datum/species/vulpkanin,
				/datum/species/dracon,
				/datum/species/tieberian
)
	origin_desc = "When the Tennite faith first swept through the world many centuries ago, the people of Naledi were left entirely untouched.<br> Though knowledge of PSYDON \
	had faded under Astrata's eye, for the Naledi people, the traditions of the Old God have remained alive and well since the dawn of time - a fact that their libraries \
	have carefully recorded. The Naledi are poorly known to the West, and most travelers from the region come as traders or scholars. What is known is that the region is \
	rich in gold, and that its people look to the stars for divine knowledge of our world.<br> It is rumored that the Naledi Emir is over five hundred years old, owing his \
	long lifespan to closely-guarded alchemical secrets."

/datum/virtue/origin/kazengun
	name = "Kazengite"
	desc = "I originate from the temperate forests of Kazengun, a region poorly known to the West. Its people worship a syncretic variation of the Divine Pantheon, often percieved as heretical.<br>"
	restricted = TRUE
	races = list(/datum/species/elf/dark,
				/datum/species/halforc,
				/datum/species/moth,
				/datum/species/dwarf/mountain
)
	origin_desc = " "

/datum/virtue/origin/hammerhold
	name = "Hammerholdian"
	desc = "I originate from mountainous Hammerhold, a frigid archipelago in the far north. The region is considered the homeland of the Dwarves.<br>"
	restricted = TRUE
	races = list(/datum/species/elf/dark,
				/datum/species/tabaxi,
				/datum/species/moth,
				/datum/species/lizardfolk,
				/datum/species/tieberian
)
	origin_desc = " "

/datum/virtue/origin/avar
	name = "Aavnic"
	desc = "I originate from the open plains of Avar, a nomadic people residing the Aavnic steppes. The only settled land consists of small, independent city-states, often engulfed in war with eachother.<br>"
	restricted = TRUE
	races = list(/datum/species/elf/dark,
				/datum/species/moth,
				/datum/species/akula,
				/datum/species/lizardfolk,
				/datum/species/dracon
)
	origin_desc = " "

/datum/virtue/origin/racial/underdark
	name = "Underdweller"
	desc = "I originate from the treacherous Underdark, a cavernous region beneath Otava and Grenzelhoft. This unforgiving land is dominated by the prosperous and cruel dark elves and their pets. Most surfacedwellers only come here in chains.<br>"
	races = list(/datum/species/elf/dark,
				/datum/species/moth,
				/datum/species/kobold,
				/datum/species/halforc,
				/datum/species/goblinp,
				/datum/species/anthromorph,
				/datum/species/anthromorphsmall
)
	origin_desc = " "

/datum/virtue/origin/racial/azuria/apply_to_human(mob/living/carbon/human/recipient)
	recipient.dna.species.origin = "Azuria"

/datum/virtue/origin/grenzelhoft/apply_to_human(mob/living/carbon/human/recipient)
	recipient.dna.species.origin = "Grenzelhoft"
	recipient.grant_language(/datum/language/grenzelhoftian)

/datum/virtue/origin/etrusca/apply_to_human(mob/living/carbon/human/recipient)
	recipient.dna.species.origin = "Etrusca"
	recipient.grant_language(/datum/language/etruscan)

/datum/virtue/origin/otava/apply_to_human(mob/living/carbon/human/recipient)
	recipient.dna.species.origin = "Otava"
	recipient.grant_language(/datum/language/otavan)

/datum/virtue/origin/racial/gronn/apply_to_human(mob/living/carbon/human/recipient)
	recipient.dna.species.origin = "Gronn"
	recipient.grant_language(/datum/language/gronnic)

/datum/virtue/origin/raneshen/apply_to_human(mob/living/carbon/human/recipient)
	recipient.dna.species.origin = "Raneshen"
	recipient.grant_language(/datum/language/celestial)

/datum/virtue/origin/naledi/apply_to_human(mob/living/carbon/human/recipient)
	recipient.dna.species.origin = "Naledi"
	recipient.grant_language(/datum/language/celestial)

/datum/virtue/origin/kazengun/apply_to_human(mob/living/carbon/human/recipient)
	recipient.dna.species.origin = "Kazengun"
	recipient.grant_language(/datum/language/kazengunese)

/datum/virtue/origin/hammerhold/apply_to_human(mob/living/carbon/human/recipient)
	recipient.dna.species.origin = "Hammerhold"
	recipient.grant_language(/datum/language/dwarvish)

/datum/virtue/origin/avar/apply_to_human(mob/living/carbon/human/recipient)
	recipient.dna.species.origin = "Avar"
	recipient.grant_language(/datum/language/aavnic)

/datum/virtue/origin/racial/underdark/apply_to_human(mob/living/carbon/human/recipient)
	recipient.dna.species.origin = "the Underdark"
	recipient.grant_language(/datum/language/otavan)
