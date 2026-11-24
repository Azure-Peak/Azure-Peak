GLOBAL_LIST_INIT(political_factions, init_political_factions())

/proc/init_political_factions()
	var/list/result = list()
	for(var/datum/political_faction/faction_type as anything in subtypesof(/datum/political_faction))
		var/datum/political_faction/faction = new faction_type()
		result[faction.id] = faction
	return result

/datum/political_faction
	var/id
	var/name
	var/color_name
	var/color
	var/motto
	var/description
	var/members
	var/goals
	var/wiki_url
	var/psydonite_only = FALSE
	var/examine_text
	var/commoner_examine_text
	var/self_examine_text

/datum/political_faction/proc/examine_line(noble, self = FALSE)
	if(self && self_examine_text)
		return self_examine_text
	if(!noble && commoner_examine_text)
		return commoner_examine_text
	return examine_text || "Of the [name] faction."

/datum/political_faction/proc/allows_patron(datum/patron/patron)
	if(!psydonite_only)
		return TRUE
	return istype(patron, /datum/patron/old_god)

/datum/political_faction/neutral
	id = POLITICAL_FACTION_NEUTRAL
	name = "Neutral"
	color = "#9a9a9a"
	examine_text = "A despicable neutral."
	commoner_examine_text = "A neutral in the politics of this land."
	self_examine_text = "A neutral in the politics of this land."
	motto = "And irresolute princes, to avoid present dangers, generally follow the neutral path, and are generally ruined."
	description = "By circumstances, or because you truly do not hold an opinion, you do not declare your allegiance to any of the existing political factions in Azuria. A normal path for a wandering sort, a peasant, or perhaps one of the Church. But a rather odd choice if you're a noble, for there is none as perfidious as one who refuses to choose any side. For the victorious shall build a bond of amity with those who were on their side out of gratitude, and should those you ally with lose, you shall be sheltered and aided by them when they are able, and you become companions on a fortune that may rise again."

	// Paraphrased from Machiavelli's The Prince

/datum/political_faction/azurosa
	id = POLITICAL_FACTION_AZUROSA
	name = "Azurosa"
	color_name = "Blue"
	color = "#4a78d4"
	wiki_url = "https://azurepeak.miraheze.org/wiki/Azuria#Azurosa_(Blue)"
	motto = "Royal Power is the foundation of this country, and without a strong Court and army to back it up, the realm of Azuria will surely be destroyed by its many enemies."
	description = "The faction of royal power. The Azurosa faction has been ascendant in Azurian politics ever since the War of the Valley. They believe in centralizing more power around the Grand Duke and their appointed court, dominated by the lower gentries and budding bureaucrats, and that under the Grand Duke's guidance Azuria will prosper forevermore."
	members = "Nobles of the central Azurian court, budding bureaucrats, lower gentries, minor nobles and some burghers of Kingsfield, Kingshold and Rockhill, knights and retainers without land of their own, certain protectionist craftsmen"
	goals = "Centralization, professionalization of Azuria's army and navy, taxation and land improvements"

/datum/political_faction/heartfelt
	id = POLITICAL_FACTION_HEARTFELT
	name = "Heartfelt"
	color_name = "Red"
	color = "#c43b3b"
	wiki_url = "https://azurepeak.miraheze.org/wiki/Azuria#Heartfelt_(Red)"
	motto = "Only through the strength of arms and the blood of the Heartfeltian has this country been saved from utter destruction. The rights of the armed nobility who protect the denizens of this land are paramount."
	description = "The faction of decentralization. Once dominant for nearly two centuries since the end of the Anarchy, the Heartfelt faction was behind the stability of Azuria for the last two centuries, and its elective succession system. They believe that Royal Power is prone to being abused, and that the Azurosa faction's expansion of royal power will only lead to ruination. They hold that both the great magnates of Azuria and its cities and towns deserve autonomy, and that Azuria's frontier is best managed and defended by the valiant knights and armsmen who live there. The aftermath of the War of the Valley led to the Heartfelt faction abandoning its Psydonite members and becoming a bitter, staunchly Tennite faction."
	members = "Nobles of Heartfelt, nobles with large landed estates in Rockhill and Central Azuria, knights and armsmen from the western part of Azuria, burghers of western and central Azuria"
	goals = "Fortification rights, lower taxation for the \"Common defense of the realm\", restoring land grants for defenses, expulsion of the Inquisition"

/datum/political_faction/rosawood
	id = POLITICAL_FACTION_ROSAWOOD
	name = "Rosawood"
	color_name = "White"
	color = "#e8e4d8"
	wiki_url = "https://azurepeak.miraheze.org/wiki/Azuria#Rosawood_(White)"
	motto = "A stronger Azuria protects the elves from the dominion of Grenzelhoft, but only so much as it respects our right and our traditions."
	description = "The Rosawood faction is led by the Count of Rosawood and, since the early 1400s, allied with the rising Azurian Trading Company. The merchants of the company and the Rossan elves found common cause in curbing excessive royal and noble power, and maintaining the autonomy of their interests. It is the only faction that can truly claim to be in favor of free trade, whereas the other two more dominant factions are more mercantilist in nature, seeing merchant interests as one way to further their own. The Rosawood faction has generally played kingmaker for most of Azuria's history, and may wish to see an elf or half-elf on the throne to secure their interests."
	members = "Elves of Rosawood, Rhu Rosha, Eveswood, Azurian Trading Company, burghers and merchants interested in property rights and devolution of Crown powers"
	goals = "City charters and merchant and elven privileges, continued recognition of Eveswood and Rosawood's autonomy and their right to manage their land, securing succession of elves or half-elven heirs or dukes"

/datum/political_faction/benedictus
	id = POLITICAL_FACTION_BENEDICTUS
	name = "Benedictus"
	color_name = "Green"
	color = "#4f9a4f"

	wiki_url = "https://azurepeak.miraheze.org/wiki/Azuria#Benedictus"
	motto = "Here, in Psydon's HOLIEST land, His faithful are few, yet we endure in the test of the faith. All will turn to the worship of the one true benevolent god of this world, so long as we persist."
	description = "The Benedictus faction, or the greens as others call them, are the least established and the most recent of all political factions, having only really come into being after the War of the Valley in 1492. They also uniquely do not use a Rosa as their insignia. The aftermath of the war saw the Heartfelters abandon the cause of supporting Psydonite religious rights, tolerance and autonomy, and rendered the Psydonites of Azuria politically homeless. The arrival of the Inquisition gave a small amount of military and political backing to the Psydonites' cause - but also made them reviled by the rest of Azuria."
	members = "Psydonites from all social and economic strata, possibly members of the Inquisition"
	goals = "Rights of the Psydonite minority, survival at all cost"
	psydonite_only = TRUE

/mob/living/carbon/human/proc/political_faction_seen_by(mob/viewer)
	if(HAS_TRAIT(src, TRAIT_OUTLAW))
		return null
	var/datum/political_faction/faction = GLOB.political_factions[political_faction]
	if(!faction)
		return null
	if(faction.id == POLITICAL_FACTION_NEUTRAL && is_political_noble(src))
		if(viewer == src || isobserver(viewer) || is_political_noble(viewer))
			return faction
		return null
	if(viewer == src || isobserver(viewer))
		return faction
	if(HAS_TRAIT(src, TRAIT_DECEIVING_MEEKNESS))
		return null
	if(is_political_noble(src) && is_political_noble(viewer))
		return faction
	var/mob/living/carbon/human/human_viewer = viewer
	if(istype(human_viewer) && !HAS_TRAIT(human_viewer, TRAIT_OUTLAW) && human_viewer.political_faction == political_faction)
		return faction
	return null

/proc/is_political_noble(mob/M)
	return HAS_TRAIT(M, TRAIT_NOBLE) || HAS_TRAIT(M, TRAIT_DEFILED_NOBLE)

/proc/announce_ruling_faction(mob/living/carbon/human/ruler)
	if(!istype(ruler) || HAS_TRAIT(ruler, TRAIT_OUTLAW))
		return
	var/datum/political_faction/faction = GLOB.political_factions[ruler.political_faction]
	if(!faction || faction.id == POLITICAL_FACTION_NEUTRAL)
		return
	to_world("<b><span class='notice'>The [faction.name] faction is ascendant.</span></b>")
