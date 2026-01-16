
/obj/item/reagent_containers/glass/bottle/rogue/healthpot
	list_reagents = list(/datum/reagent/medicine/healthpot = 50)

/obj/item/reagent_containers/glass/bottle/rogue/healthpotnew
	list_reagents = list(/datum/reagent/medicine/stronghealth = 50)

/obj/item/reagent_containers/glass/bottle/rogue/manapot
	list_reagents = list(/datum/reagent/medicine/manapot = 50)

/obj/item/reagent_containers/glass/bottle/rogue/poison
	list_reagents = list(/datum/reagent/toxin/killersice = 1)

/obj/item/reagent_containers/glass/bottle/rogue/water
	list_reagents = list(/datum/reagent/water = 50)


/obj/item/reagent_containers/glass/bottle/mercury
	list_reagents = list(/datum/reagent/mercury = 50)

//vanderlin potion stuff//
/obj/item/reagent_containers/glass/bottle/rogue/strongmanapot
	list_reagents = list(/datum/reagent/medicine/strongmana = 50)

/obj/item/reagent_containers/glass/bottle/rogue/stampot
	list_reagents = list(/datum/reagent/medicine/stampot = 50)

/obj/item/reagent_containers/glass/bottle/rogue/strongstampot
	list_reagents = list(/datum/reagent/medicine/strongstam = 50)

/obj/item/reagent_containers/glass/bottle/rogue/antidote
	list_reagents = list(/datum/reagent/medicine/antidote = 50)

/obj/item/reagent_containers/glass/bottle/rogue/strong_antidote
	list_reagents = list(/datum/reagent/medicine/strong_antidote = 50)

/obj/item/reagent_containers/glass/bottle/rogue/berrypoison
	list_reagents = list(/datum/reagent/berrypoison = 15)

/obj/item/reagent_containers/glass/bottle/rogue/strongpoison
	list_reagents = list(/datum/reagent/strongpoison = 15)

/obj/item/reagent_containers/glass/bottle/rogue/stampoison
	list_reagents = list(/datum/reagent/stampoison = 15)

/obj/item/reagent_containers/glass/bottle/rogue/strongstampoison
	list_reagents = list(/datum/reagent/strongstampoison = 15)

/obj/item/reagent_containers/glass/bottle/alchemical/strpot
	list_reagents = list(/datum/reagent/buff/strength = 30)

/obj/item/reagent_containers/glass/bottle/alchemical/perpot
	list_reagents = list(/datum/reagent/buff/perception = 30)

/obj/item/reagent_containers/glass/bottle/alchemical/endpot
	list_reagents = list(/datum/reagent/buff/endurance = 30)

/obj/item/reagent_containers/glass/bottle/alchemical/conpot
	list_reagents = list(/datum/reagent/buff/constitution = 30)

/obj/item/reagent_containers/glass/bottle/alchemical/intpot
	list_reagents = list(/datum/reagent/buff/intelligence = 30)

/obj/item/reagent_containers/glass/bottle/alchemical/spdpot
	list_reagents = list(/datum/reagent/buff/speed = 30)

/obj/item/reagent_containers/glass/bottle/alchemical/lucpot
	list_reagents = list(/datum/reagent/buff/fortune = 30)

/obj/item/reagent_containers/glass/bottle/alchemical/healthpot
	list_reagents = list(/datum/reagent/medicine/healthpot = 30)

/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew
	list_reagents = list(/datum/reagent/medicine/stronghealth = 30)

/obj/item/reagent_containers/glass/bottle/alchemical/blessedwater
	list_reagents = list(/datum/reagent/water/blessed = 30)

/obj/item/reagent_containers/glass/bottle/alchemical/manapot
	list_reagents = list(/datum/reagent/medicine/manapot = 30)

/obj/item/reagent_containers/glass/bottle/alchemical/strongmanapot
	list_reagents = list(/datum/reagent/medicine/strongmana = 30)

/obj/item/reagent_containers/glass/bottle/alchemical/fermented_crab
	list_reagents = list(/datum/reagent/fermented_crab = 15)

//////////////////////////
/// ALCOHOLIC BOTTLES ///
//////////////////////////

// BEER - Cheap, Plentiful, Saviours of Family Life
/obj/item/reagent_containers/glass/bottle/rogue/beer
	name = "bottle of beer"
	icon = 'icons/obj/alcohol.dmi'
	icon_state = "beer_2"
	list_reagents = list(/datum/reagent/consumable/ethanol/beer = 50)
	desc = "A bottle that contains a generic housebrewed small-beer. It has an improvised corkseal made of hardened clay."

/obj/item/reagent_containers/glass/bottle/rogue/beer/zagul
	name = "bottle of Zagul"
	icon_state = "beer_2"
	list_reagents = list(/datum/reagent/consumable/ethanol/zagul = 50)
	desc = "A bottle with the coastal zagul cork-seal. An extremely cheap lager hailing from a local brewery."

/obj/item/reagent_containers/glass/bottle/rogue/beer/blackgoat
	name = "bottle of Blackgoat"
	icon_state = "beer"
	list_reagents = list(/datum/reagent/consumable/ethanol/blackgoat = 50)
	desc = "A bottle with the black goat kriek cork-seal. A fruit-sour beer brewed with jackberries for a tangy taste."

/obj/item/reagent_containers/glass/bottle/rogue/beer/ratkept
	name = "bottle of Ratkept"
	icon_state = "beer"
	list_reagents = list(/datum/reagent/consumable/ethanol/onion = 50)
	desc = "A bottle with surprisingly no cork-seal. On the glass is carved the word \"ONI-N\", the 'O' seems to have been scratched out completely. Dubious. On the glass is a paper glued to it showing an illustration of rats guarding a cellar filled with bottles against a hoard of beggars."

/obj/item/reagent_containers/glass/bottle/rogue/beer/hagwoodbitter
	name = "bottle of Hagwood Bitters"
	icon_state = "beer"
	list_reagents = list(/datum/reagent/consumable/ethanol/hagwoodbitter = 50)
	desc = "A bottle with the hagwood bitters cork-seal. The least bitter thing to be exported from the Grenzelhoft occupied state of Zorn."

/obj/item/reagent_containers/glass/bottle/rogue/beer/aurorian
	name = "bottle of Aurorian Herbal Beer"
	icon_state = "beer"
	list_reagents = list(/datum/reagent/consumable/ethanol/aurorian = 50)
	desc = "A bottle with the aurorian brewhouse cork-seal. An Elvish beer brewed from an herbal gruit."

/obj/item/reagent_containers/glass/bottle/rogue/beer/fireleaf
	name = "bottle of Fireleaf"
	icon_state = "beer"
	list_reagents = list(/datum/reagent/consumable/ethanol/fireleaf= 50)
	desc = "A bottle with a generic leaf cork-seal. An Elvish beer formed by distilling cabbages. You're pretty sure you can make your own with certainly higher quality."

/obj/item/reagent_containers/glass/bottle/rogue/beer/butterhairs
	name = "bottle of Butterhairs"
	icon_state = "ale"
	list_reagents = list(/datum/reagent/consumable/ethanol/butterhairs = 50)
	desc = "A bottle with the Dwarven Federation Trade Alliance cork-seal. This beer, known as butterhairs: is widely considered one of the greatest exported by the Dwarves."

/obj/item/reagent_containers/glass/bottle/rogue/beer/stonebeardreserve
	name = "bottle of Stonebeards Reserve"
	icon_state = "ale"
	list_reagents = list(/datum/reagent/consumable/ethanol/stonebeards = 50)
	desc = "A bottle with the House Stoutenson cork-seal. Stonebeards Reserve is one of the most legendary beers in existence, with only a few hundred barrels made every year."

/obj/item/reagent_containers/glass/bottle/rogue/beer/sazdistal
	name = "bottle of Stoutenson Sazdistal"
	icon = 'icons/obj/alcohol.dmi'
	icon_state = "plum_wine"
	list_reagents = list(/datum/reagent/consumable/ethanol/sazdistal = 50)
	desc = "A bottle with the House Stoutenson cork-seal. This strange liquid is considered as the most spicy and alcoholic drink in all the Mountainhomes. Bought by nobles of all ages, mostly those with a deathwish."

/obj/item/reagent_containers/glass/bottle/rogue/beer/voddena
	list_reagents = list(/datum/reagent/consumable/ethanol/voddena = 50)
	desc = "A bottle with the City of Norwandine cork-seal. It contains a respectably pure, clean voddena."

// WINES - Expensive, Nobleblooded
/obj/item/reagent_containers/glass/bottle/rogue/wine
	name = "bottle of wine"
	icon = 'icons/obj/alcohol.dmi'
	icon_state = "red_wine"
	list_reagents = list(/datum/reagent/consumable/ethanol/wine = 50)
	desc = "A bottle that contains a generic red-wine, likely from Raneshen. It has a red-clay cork-seal."

/obj/item/reagent_containers/glass/bottle/rogue/wine/sourwine
	name = "bottle of Grenzelhoft Sour"
	icon_state = "red_wine"
	list_reagents = list(/datum/reagent/consumable/ethanol/sourwine = 50)
	desc = "A bottle that contains a Grenzelhoftian classic with a black ink cork-seal.. An extremely sour wine that is watered down with mineral water."

/obj/item/reagent_containers/glass/bottle/rogue/redwine
	name = "bottle of Otavan Red"
	icon = 'icons/obj/alcohol.dmi'
	icon_state = "otavan_red"
	list_reagents = list(/datum/reagent/consumable/ethanol/redwine = 50)
	desc = "A bottle with the Otavan Merchant Guild cork-seal. This one appears to be labelled as a relatively young red-wine from the coinlord state."

/obj/item/reagent_containers/glass/bottle/rogue/whitewine
	name = "bottle of Otavan White"
	icon = 'icons/obj/alcohol.dmi'
	icon_state = "white_wine"
	list_reagents = list(/datum/reagent/consumable/ethanol/whitewine = 50)
	desc = "A bottle with the Otavan Merchant Guild cork-seal. This one appears to be labelled as a sweet wine from the colder northern regions."

/obj/item/reagent_containers/glass/bottle/rogue/elfred
	name = "bottle of Elven Red"
	icon = 'icons/obj/alcohol.dmi'
	icon_state = "elven_red"
	list_reagents = list(/datum/reagent/consumable/ethanol/elfred = 50)
	desc = "A bottle gilded with a silver cork-seal. It appears to be labelled as an elvish red wine from Otava. Likely worth more than what an entire village makes!"

/obj/item/reagent_containers/glass/bottle/rogue/elfblue
	name = "bottle of Valmora Blue"
	icon = 'icons/obj/alcohol.dmi'
	icon_state = "valmora_blue"
	list_reagents = list(/datum/reagent/consumable/ethanol/elfblue = 50)
	desc = "A bottle gilded with a golden cork-seal. This is the legendary Valmora Blue from the Vineyard of Valmora, headed by a sainted Dark-Elf swordsmaster. This bottle would swoon Gods over!"

//AZURE DRINKS
/obj/item/reagent_containers/glass/bottle/rogue/beer/jagdtrunk
	name = "bottle of Schnapps"
	icon_state = "red_wine"
	list_reagents = list(/datum/reagent/consumable/ethanol/jagdtrunk = 50)
	desc = "A bottle with a Saigabuck cork-seal. This dark liquid is the strongest alcohol coming out of Grenzelhoft available. A herbal schnapps, sure to burn out any disease."

/obj/item/reagent_containers/glass/bottle/rogue/beer/apfelweinheim
	name = "bottle of Apfelweinheim Cider"
	icon_state = "ale"
	list_reagents = list(/datum/reagent/consumable/ethanol/apfelweinheim = 50)
	desc = "A bottle with the Apfelweinheim cork-seal. A cider from the Grenzelhoftian town of Apfelweinheim. Well received for its addition of pear, alongside crisp apples."

/obj/item/reagent_containers/glass/bottle/rogue/beer/rtoper
	name = "bottle of Lirvas Cider"
	icon_state = "ale"
	list_reagents = list(/datum/reagent/consumable/ethanol/rtoper = 50)
	desc = "A bottle with the Lirvas-crest cork-seal. An especially tart cider from the petty kingdom of Lirvas. Myths say the brewers let the barrels age in the bog, which results in that especially stong flavour."

/obj/item/reagent_containers/glass/bottle/rogue/beer/nred
	name = "bottle of Norwandine Ale"
	icon_state = "ale"
	list_reagents = list(/datum/reagent/consumable/ethanol/nred = 50)
	desc = "A bottle with the City of Norwandine cork-seal. A red ale brewed to perfection in the lands of Hammerhold."

/obj/item/reagent_containers/glass/bottle/rogue/beer/gronnmead
	name = "bottle of Shieldmaiden Mead"
	icon_state = "red_wine"
	list_reagents = list(/datum/reagent/consumable/ethanol/gronnmead = 50)
	desc = "A bottle with a Shieldmaiden Berewrey cork-seal. A deep red honey-wine, refined with the red berries native to Gronns highlands."

/obj/item/reagent_containers/glass/bottle/rogue/beer/avarmead
	name = "bottle of Golden Mead"
	icon_state = "plum_wine"
	list_reagents = list(/datum/reagent/consumable/ethanol/avarmead = 50)
	desc = "A bottle with a simple cork-seal. A golden honey-wine brewed in the Avar Steppes. Manages to keep a proper taste while staying strong."

/obj/item/reagent_containers/glass/bottle/rogue/beer/avarrice
	name = "bottle of Aavnic White"
	icon_state = "white_wine"
	list_reagents = list(/datum/reagent/consumable/ethanol/avarrice = 50)
	desc = "A bottle with a simple cork-seal. A murky, white wine made from rice grown in the steppes of Avar."

/obj/item/reagent_containers/glass/bottle/rogue/beer/saigamilk
	name = "bottle of brewed Saiga Milk"
	icon_state = "plum_wine"
	list_reagents = list(/datum/reagent/consumable/ethanol/saigamilk = 50)
	desc = "A bottle with a Running Saiga cork-seal. A form of alcohol brewed from the milk of a saiga and salt. Common drink of the nomads living in the steppe."

/obj/item/reagent_containers/glass/bottle/rogue/beer/kgunlager
	name = "bottle of Yamaguchi Tea Lager"
	icon_state = "beer"
	list_reagents = list(/datum/reagent/consumable/ethanol/kgunlager = 50)
	desc = "A bottle with a Yamaguchi Brewery cork-seal. A pale lager brewed in the far-away lands of Kazengun, refined with green tea for an unique flavour-profile. Even lighter than elven-brew!"

/obj/item/reagent_containers/glass/bottle/rogue/beer/kgunsake
	name = "bottle of Golden Swan Sake"
	icon_state = "white_wine"
	list_reagents = list(/datum/reagent/consumable/ethanol/kgunsake = 50)
	desc = "A bottle with a Golden Swan cork-seal. A translucient, pale-blue liquid made from rice. A favourite drink of the warlords and nobles of Kazengun."

/obj/item/reagent_containers/glass/bottle/rogue/beer/kgunplum
	name = "bottle of Golden Swan Plum Wine"
	icon_state = "plum_wine"
	list_reagents = list(/datum/reagent/consumable/ethanol/kgunplum = 50)
	desc = "A bottle with a Golden Swan cork-seal. A reddish-golden alcohol made from a fruit commonly found on the Kazengun-isles. A favourite of the commoners."

/obj/item/reagent_containers/glass/bottle/rogue/beer/kgunshochu
	name = "bottle of Kazengun Shochu"
	icon_state = "rice_wine"
	list_reagents = list(/datum/reagent/consumable/ethanol/kgunshochu = 50)
	desc = "A bottle with a Golden Swan cork-seal. A clean alcohol made by distilling rice. With a dry and clean finish. Popular amongst the warrior caste of Kazengun."

// Zhongese Drinks
/obj/item/reagent_containers/glass/bottle/rogue/beer/huangjiu
	name = "bottle of Huangjiu Rice Wine"
	icon_state = "rice_wine"
	list_reagents = list(/datum/reagent/consumable/ethanol/huangjiu = 50)
	desc = "A bottle with a red seal. A strong, sweet yellow rice wine that is often used in cooking."

/obj/item/reagent_containers/glass/bottle/rogue/beer/baijiu
	name = "bottle of Baijiu Rice Wine"
	icon_state = "rice_wine"
	list_reagents = list(/datum/reagent/consumable/ethanol/baijiu = 50)
	desc = "A bottle with a red seal. A strong, clear liquor made from fermented sorghum or rice. The favored drink of wandering warriors."

/obj/item/reagent_containers/glass/bottle/rogue/beer/yaojiu
	name = "bottle of Yaojiu Rice Wine"
	icon_state = "rice_wine"
	list_reagents = list(/datum/reagent/consumable/ethanol/yaojiu = 50)
	desc = "A bottle with a red seal. A strong, sweet rice wine infused with medicinal herbs, including Ginseng. Often prescribed as a medicine on the Zhongese mainland."

/obj/item/reagent_containers/glass/bottle/rogue/beer/shejiu
	name = "bottle of Shejiu Rice Wine"
	icon_state = "rice_wine"
	list_reagents = list(/datum/reagent/consumable/ethanol/shejiu = 50)
	desc = "A bottle with a red seal. A strong rice wine with a dead snake inside. In the land of Zhong, It is believed that drinking this will improve one's virility and blood circulation."

/obj/item/reagent_containers/glass/bottle/rogue/beer/murkwine
	name = "bottle of Possumtail Swampweed Wine"
	icon_state = "plum_wine"
	list_reagents = list(/datum/reagent/consumable/ethanol/murkwine = 50)
	desc = "A bottle with a Possumtail Brewery mark. A special brew made from murky water and swampweed. A Heartfelt special."

/obj/item/reagent_containers/glass/bottle/rogue/beer/nocshine
	name = "bottle of Nocshine"
	icon_state = "valmora_blue"
	list_reagents = list(/datum/reagent/consumable/ethanol/nocshine = 50)
	desc = "A bottle with a blue, Crescent moon mark. A special brew that is extremely potent and toxic, but strengthen the body. If you dare."

/obj/item/reagent_containers/glass/bottle/rogue/beer/whipwine
	name = "bottle of Whipwine"
	icon_state = "beer_2"
	list_reagents = list(/datum/reagent/consumable/ethanol/whipwine = 50)
	desc = "A strange bottle with a concerningly brown color. It bears the seal of a snake's head over a leaf. Markings indicate the contents are supposed to be good for health..."

/obj/item/reagent_containers/glass/bottle/rogue/beer/komuchisake
	name = "bottle of Komuchi Sake"
	icon_state = "rice_wine"
	list_reagents = list(/datum/reagent/consumable/ethanol/komuchisake = 50)
	desc = "A dusty, ancient bottle with a red-ochre coloring. It bears an intricately detailed golden skull seal, and the markings on it are clearly of the Shogunate. It looks to be filled with herbs inside."

		//////////////////////////
		/// CLAY BOTTLES ///
		//////////////////////////

/obj/item/reagent_containers/glass/bottle/claybottle/wine
	list_reagents = list(/datum/reagent/consumable/ethanol/wine = 75)
	desc = "A clay bottle that contains a generic red-wine, likely from Raneshen. It has a red-clay cork-seal."

/obj/item/reagent_containers/glass/bottle/claybottle/water
	list_reagents = list(/datum/reagent/water = 75)
	desc = "A clay bottle with no markings."

/obj/item/reagent_containers/glass/bottle/claybottle/beer
	list_reagents = list(/datum/reagent/consumable/ethanol = 75)
	desc = "A clay bottle that contains a generic housebrewed small-beer. It has an improvised corkseal made of hardened clay."

/obj/item/reagent_containers/glass/bottle/claybottle/nred
	list_reagents = list(/datum/reagent/consumable/ethanol/nred = 75)
	desc = "A clay bottle with the City of Norwandine cork-seal. A red ale brewed to perfection in the lands of Hammerhold."

/obj/item/reagent_containers/glass/bottle/claybottle/gronnmead
	list_reagents = list(/datum/reagent/consumable/ethanol/gronnmead = 75)
	desc = "A clay bottle with a Shieldmaiden Berewrey cork-seal. A deep red honey-wine, refined with the red berries native to Gronns highlands."

/obj/item/reagent_containers/glass/bottle/claybottle/whitewine
	list_reagents = list(/datum/reagent/consumable/ethanol/whitewine = 75)
	desc = "A bottle with the Otavan Merchant Guild cork-seal. This one appears to be labelled as a sweet wine from the colder northern regions."
