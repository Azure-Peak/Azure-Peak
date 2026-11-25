GLOBAL_LIST_EMPTY(dream_fragments) // list of paths, autopopulated at roundstart. will be picked from at random when a valid abyssorite sleeps.
GLOBAL_DATUM_INIT(dream_omens_handler, /datum/dream_omens_handler, new)
#define DREAM_BUFF_DURATION 15 MINUTES // not too short, but they're not very big buffs either
#define DEATH_OMEN_EXPIRY 20 MINUTES // no sense in telling you about someone that's already long recovered

/// simple singleton that stores a bunch of data for use in dream fragment template-filling
/datum/dream_omens_handler
	// death omen: keeps track of who died last, but doesn't give very accurate info
	var/last_death_species
	var/area/last_death_area
	var/last_death_time
	// drowning omen: much more rare than death omens, so you get a better description
	var/last_drown_desc
	var/area/last_drown_area
	var/datum/status_effect/effect

/datum/dream_omens_handler/proc/handle_death(mob/living/carbon/human/unfortunate_soul)
	last_death_time = world.time
	last_death_species = unfortunate_soul.dna?.species
	last_death_area = get_area(unfortunate_soul)

/datum/dream_omens_handler/proc/handle_drown(mob/living/carbon/human/unfortunate_soul)
	var/list/d_list = unfortunate_soul.get_mob_descriptors()
	var/trait_desc = "[capitalize(build_coalesce_description_nofluff(d_list, unfortunate_soul, list(MOB_DESCRIPTOR_SLOT_TRAIT), "%DESC1%"))]"
	var/stature_desc = "[capitalize(build_coalesce_description_nofluff(d_list, unfortunate_soul, list(MOB_DESCRIPTOR_SLOT_STATURE), "%DESC1%"))]"
	last_drown_desc = "[trait_desc] [stature_desc]" // you don't get a name, even if they're unmasked
	last_drown_area = get_area(unfortunate_soul)

/datum/status_effect/buff/dream_fragment
	id = "dream_fragment"
	alert_type = /atom/movable/screen/alert/status_effect/buff/dream_fragment
	duration = DREAM_BUFF_DURATION

/datum/status_effect/buff/dream_fragment/on_creation(mob/living/new_owner, list/stats_affected)
	effectedstats = stats_affected
	. = ..()

/atom/movable/screen/alert/status_effect/buff/dream_fragment
	name = "Oneiric Guidance"
	desc = "A glimmer of light shines through the dream, easing your path."
	icon_state = "buff"

/// component for abyssor dream fragments. each mob can only ever have one of these,
/datum/component/dream_fragment
	abstract_type = /datum/component/dream_fragment
	dupe_mode = COMPONENT_DUPE_HIGHLANDER			// applying a new fragment will remove the old
	can_transfer = TRUE								// this is how we handle the buffing
	var/active = FALSE								// this is set to true when an abyssorite bestows the component to someone else (transfers it); they don't get the buffs themselves just for dreaming it up
	var/dream_text									// this is generated in-round, as it depends on
	var/dream_blurb	= "a dream of divine mishaps"	// a short description of what the dream is about. should be reasonably esoteric for example a dream that gives a speed buff might be called "a dream of pursuit" and depict you fleeing a pale wolf or something

/// called when the fragment is picked by the dreamer to be their one-per-night. many dreams will just have static text here, but others might contain dynamic info such as a portent of doom telling you the area of the most recent death
/datum/component/dream_fragment/proc/generate_dream_text()
	return "You see a brief vision of a powerful being in a dark room. They touch a strange device, and a feeling of wrongness washes over you; you feel that they've maid a terrible mistake, and that you should 'report this to the devs', whatever that means." // this is not a typo

/datum/component/dream_fragment/Initialize()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	dream_text = generate_dream_text()
	to_chat(parent, span_purple(dream_text))

/// transfer handler: apply buffs here, instead of on creation, as we CREATE the component on the abyssorite but TRANSFER it to the recipient
/datum/component/dream_fragment/PostTransfer()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	var/mob/living/carbon/human/H = parent
	H.apply_status_effect(/datum/status_effect/debuff/mishap_blindness/abyssor) // instead of putting you to sleep we just blind you for a bit so it's less jarring/abusable (not that it's rly that abusable in the first place)
	to_chat(parent, span_purple(dream_text))
	apply_buff()
	QDEL_IN(src, DREAM_BUFF_DURATION) // only start the timer once the buff is actually applied

/atom/movable/screen/alert/status_effect/waking_dream
	name = "Waking Dream"
	desc = "A wave of drowsiness overtakes me, a dream flashing through my mind...!"
	icon_state = "sleepy"

/datum/status_effect/debuff/mishap_blindness/abyssor
	id = "dream_blindness"
	duration = 3 SECONDS // it's just for aura
	alert_type = /atom/movable/screen/alert/status_effect/waking_dream

/datum/component/dream_fragment/Destroy(force, silent)
	to_chat(parent, span_warning("The guidance of dream fades..."))
	remove_buff()
	return ..()

/datum/component/dream_fragment/proc/apply_buff()
	return

/datum/component/dream_fragment/proc/remove_buff()
	var/mob/living/carbon/human/H = parent
	H.remove_status_effect(/datum/status_effect/buff/dream_fragment)

// actual dream fragment definitions start here
/datum/component/dream_fragment/spd
	dream_blurb = "a dream of pursuit"

// good example of how the dream text works. if there's a relevant omen available (in this case, a recent death), a dreamer can pick up on it and get some vague information. if not, they'll get a generic dream, and can still give the buff out
/datum/component/dream_fragment/spd/generate_dream_text()
	if(GLOB.dream_omens_handler.last_death_time && (world.time < (GLOB.dream_omens_handler.last_death_time + DEATH_OMEN_EXPIRY)))
		. = "You run frantically through [GLOB.dream_omens_handler.last_death_area.deathsight_message ? GLOB.dream_omens_handler.last_death_area.deathsight_message : "an endless plain wreathed in fog"]. Your body feels unfamiliar, and you trip; the last things you see are an unfamiliar body - the body of \a [(GLOB.dream_omens_handler.last_death_species || "nondescript soul")] - and the pale volf's jaws closing around your throat. You wake with the burning terror still fresh in your mind, filled with the primal urge to flee..."
	return "You run frantically through a strange forest, chased by a terrible beast. Your steps are swift as the wind as you leap over fallen logs and dive gracefully into a river, swept far away where it cannot reach you..."

// the buffs aren't incredibly impactful, but they ARE nice to have
/datum/component/dream_fragment/spd/apply_buff()
	var/mob/living/carbon/human/H = parent
	H.apply_status_effect(/datum/status_effect/buff/dream_fragment, list(STATKEY_SPD = 1))

/datum/component/dream_fragment/per
	dream_blurb = "a dream of ruin"

// various things to "look" out for - hence the per boost. the realm's going bankrupt soon, or there are antags, or 'stuff is just going to go poorly in general be careful'
/datum/component/dream_fragment/per/generate_dream_text()
	if(SStreasury.discretionary_fund.balance < (SStreasury.get_expected_wage_outlay() * 2)) // abyssor can predict the stock market, because it's funny. this takes priority over 'the antag' because i say so
		return "You soar over the capital of Azuria, where all and sundry are in the streets weeping. 'Malum has forsaken us,' they cry, 'for our work now earns no reward, and the treasury runs dry.' You wake with a keener eye for opportunity..."
	if(length(SSmapping.retainer.dreamwalkers)) // these uniquely get a special message as they're also connected to the Dream
		return "You see a strange sight indeed: Azure Peak, and all its bustling souls, deep within a lightless abyss. Its buildings and inhabitants alike shimmer like illusions as it is all subsumed into Dream, and you wake with a feeling of foreboding..."
	var/major_antags = (SSmapping.retainer.vampire_lord || length(SSmapping.retainer.bandits) || length(SSmapping.retainer.werewolves) || length(SSmapping.retainer.liches))
	var/plural = (isnum(major_antags) && major_antags > 1)
	if(major_antags) // note that this doesn't tell you the type, or who they are. never said the omens would be USEFUL information!
		return "You see a terrible sight indeed: the streets of the city drenched in blood. [plural ? "Indiscernable figures" : "A hazy silhouette"] herald[plural ? "" : "s"] the sanguine tide, crushing citizens underfoot; you wake with a foreboding feeling..."
	return "Myriad images flicker past your mind: a farmer wakes to tend to his crops, only to find them locust-eaten... a warrior dodges a strike, only to trip over a rock... a smith misses the anvil, shattering their knee... you wake with a feeling of wariness." // default

/datum/component/dream_fragment/per/apply_buff()
	var/mob/living/carbon/human/H = parent
	H.apply_status_effect(/datum/status_effect/buff/dream_fragment, list(STATKEY_PER = 1))

/datum/component/dream_fragment/swimming
	dream_blurb = "a dream of abyssal predation"

/datum/component/dream_fragment/swimming/generate_dream_text()
	if(GLOB.dream_omens_handler.last_drown_desc)
		. = "You are dragged beneath the surface near [GLOB.dream_omens_handler.last_drown_area.deathsight_message ? GLOB.dream_omens_handler.last_drown_area.deathsight_message : "a city beneath the waves"], thrashing and struggling to reach the air. A great eel swims around you, circling, its whirlpool dragging you deeper; in your desperation you nearly break free, but it catches up; you see your reflection in its eyes—no, not yours, the reflection of a [GLOB.dream_omens_handler.last_drown_desc]—and you wake with a start."
	return "You run frantically through a strange forest, chased by a terrible beast. Your steps are swift as the wind as you leap over fallen logs and dive gracefully into a river, swept far away where it cannot reach you..."

/datum/status_effect/buff/dream_fragment/swim
	alert_type = /atom/movable/screen/alert/status_effect/buff/dream_fragment/swim

/atom/movable/screen/alert/status_effect/buff/dream_fragment/swim
	name = "Oneiric Guidance"
	desc = "A glimmer of light shines through the dream, easing your path. The waters part before you."
	icon_state = "buff"

/datum/component/dream_fragment/swimming/apply_buff()
	var/mob/living/carbon/human/H = parent
	H.apply_status_effect(/datum/status_effect/buff/dream_fragment/swim, list())
	ADD_TRAIT(parent, TRAIT_ABYSSOR_SWIM, TRAIT_MIRACLE)

/datum/component/dream_fragment/swimming/remove_buff()
	var/mob/living/carbon/human/H = parent
	H.remove_status_effect(/datum/status_effect/buff/dream_fragment/swim)
	REMOVE_TRAIT(parent, TRAIT_ABYSSOR_SWIM, TRAIT_MIRACLE)

/datum/component/dream_fragment/lck
	dream_blurb = "a dream of divine intervention"

// a glimpse at the workings of the gods brings fortune. this one's a long one because we basically have to check one by one for the god intervention events. this gets run very rarely though at least
/datum/component/dream_fragment/lck/generate_dream_text()
	var/god_intervention_text = ""
	if(has_world_trait(/datum/world_trait/dendor_fertility))
		god_intervention_text = "You dream of a forest, bustling with lyfe. Dendor's blessing descends, and the foliage grows more vibrant..."

	else if(has_world_trait(/datum/world_trait/dendor_drought))
		god_intervention_text = "You dream of a forest, bustling with lyfe. Dendor's curse descends, and the foliage wilts..."

	else if(has_world_trait(/datum/world_trait/pestra_mercy))
		god_intervention_text = "You dream of a clinic, filled with the dead. Pestra's blessing descends, and Her hand is stayed, allowing the chirurgeons more time to work..."

	else if(has_world_trait(/datum/world_trait/necra_requiem))
		god_intervention_text = "You dream of a battlefield, littered with fresh corpses. Necra's blessing descends, and though much time passes, none of the fallen arise..."

	else if(has_world_trait(/datum/world_trait/zizo_defilement))
		god_intervention_text = "You dream of the church clinic, faithful tending to the dead on hallowed ground. Zizo's influence descends, and a scream rings out, as one by one, they rise..."

	else if(has_world_trait(/datum/world_trait/zizo_pet_cementery))
		god_intervention_text = "You dream of a hunting-party, who've just felled a great beast. As they drag it off to butcher, Zizo's influence swells, and it rises to slay them all..."

	else if(has_world_trait(/datum/world_trait/abyssor_rage))
		god_intervention_text = "You dream of being encased within a bubble, a small pocket of safety within a maelstrom. Abyssor's gaze stirs, the waves crash, and many by the sea are swallowed whole..."

	else if(has_world_trait(/datum/world_trait/malum_diligence))
		god_intervention_text = "You dream of a mine, deep within the earth. Malum's blessing shines, guiding you to a deposit of precious ore..."

	else if(has_world_trait(/datum/world_trait/baotha_revelry))
		god_intervention_text = "You dream of a tavern full of weary souls, seeking respite from their ails. Baotha's blessings fall upon them, and all cares melt away..."

	if(god_intervention_text)
		return god_intervention_text + " You wake with a feeling of enlightenment."

	// if there's no god interventions, we can check which god is the most influential right now instead
	var/most_influential
	var/highest_influence = -1

	for(var/storyteller_name in SSgamemode.storytellers)
		var/datum/storyteller/initialized_storyteller = SSgamemode.storytellers[storyteller_name]
		if(!initialized_storyteller)
			continue
		if(istype(initialized_storyteller, /datum/storyteller/gamemode))
			continue

		var/influence = SSgamemode.calculate_storyteller_influence(initialized_storyteller.type)
		if(influence > highest_influence)
			highest_influence = influence
			most_influential = initialized_storyteller.name

	if(most_influential)
		return "You dream of the Ten in council, the Four in their schemes, PSYDON in his rest... the tides draw you closer to [most_influential], who seems to outshine the rest; you wake with a sliver of understanding..."
	return "You dream of the Ten in council, the Four in their schemes, PSYDON in his rest... a quiet wind blows, and all seem equal, for a time. You wake with a feeling of enlightenment." // default; probably won't be reached?

/datum/component/dream_fragment/lck/apply_buff()
	var/mob/living/carbon/human/H = parent
	H.apply_status_effect(/datum/status_effect/buff/dream_fragment, list(STATKEY_LUC = 3)) // equivalent to a luck potion, which are easy to make - and FOR isn't really impactful beyond 1-2 anyway

// tells you what category of thing has been killed most, like the roundend "blood toll" chronicle. useful? no. potentially interesting? yes. this gives you WIL because you're inspired to courage, or something
/datum/component/dream_fragment/wil
	dream_blurb = "a dream of stalwart defenders"

/datum/component/dream_fragment/wil/generate_dream_text()
	var/static/list/pretty_names = list(
		STATS_KILLED_HIGHWAYMEN = "highwaymen",
		STATS_KILLED_BOGMEN = "bogmen",
		STATS_KILLED_LESSER_BEASTS = "lesser beasts",
		STATS_KILLED_GREATER_BEASTS = "greater beasts",
		STATS_KILLED_TROLLMINOTAUR = "trolls and minotaurs",
		STATS_KILLED_DRAKKYN = "drakes",
		STATS_KILLED_GOBLINS = "goblins",
		STATS_KILLED_ORCS = "orcs",
		STATS_KILLED_GRONNMEN = "gronnmen",
		STATS_KILLED_DROWS = "drow",
		STATS_KILLED_DEADITES = "deadites",
		STATS_KILLED_INFERNALS = "infernals",
		STATS_KILLED_ELEMENTALS = "elementals",
		STATS_KILLED_FAE = "fae",
		STATS_KILLED_LIVESTOCK = "livestock", // it's going to be REALLY funny if this one ever procs but it shows up on the blood toll chronicle so it counts
	)

	var/highest
	var/highest_toll = 0

	for(var/id in pretty_names)
		if(GLOB.azure_round_stats[id] > highest_toll)
			highest = id
			highest_toll = GLOB.azure_round_stats[id]

	if(!highest)
		highest = "shadowy figures, wreathed in enigmatic mist"
	else
		highest = pretty_names[highest]

	return "You dream of a great tide of [highest], swelling towards the Peak. Then, you see a band of warriors: nameless, featureless, yet stalwart, standing between the horde and the city. They break the horde, spearheading a fearless charge... you awake, a sliver of their courage imparted to you."

/datum/component/dream_fragment/int
	dream_blurb = "a dream of a great sage"

/datum/component/dream_fragment/int/generate_dream_text()
	var/alch_sage = get_sage_name(FEATURED_STATS_ALCHEMISTS)
	var/craft_sage = get_sage_name(FEATURED_STATS_CRAFTERS)
	var/fish_sage = get_sage_name(FEATURED_STATS_FISHERS)
	var/farm_sage = get_sage_name(FEATURED_STATS_FARMERS)
	var/cha_sage = get_sage_name(FEATURED_STATS_SPEAKERS)
	var/list/sages = list("alchemy" = alch_sage, "diligence" = craft_sage, "eloquence" = cha_sage, "Abyssor's bounty" = fish_sage, "Dendor's toil" = farm_sage)
	for(var/key in sages) // unlikely as it is, we might actually have a round where this fires before anyone farms/fishes/alchemy...iess...? whatever
		if(!sages[key])
			sages -= key
	if(!LAZYLEN(sages)) // VERY VERY UNLIKELY this means nobody has  crafteed/fished/farmed/spoken/etc this round
		return "You dream of a wise sage, hovering in an empty void. They shake their head sadly, and you hear their words—though you do not see their lips move—\"Noc's wisdom and Malum's diligence forsake you and yours. Go forth and fill the void; learn, create, and see the truth of the world.\" You wake with a brief glimmer of moonlight behind your eyes..."
	. = "You dream of a wise sage, hovering in an empty void. You hear their words, though you do not see their lips move: \""
	for(var/i in 1 to min(3, LAZYLEN(sages)))
		var/discipline = pick(sages)
		. += "To learn the way of [discipline], seek the guidance of [sages[discipline]]... "
		sages -= discipline
	. = copytext(., 0, -1) + "\". You wake with a fleeting sliver of moonlight behind your eyes..." // trim the trailing space, finish the quote

/datum/component/dream_fragment/int/proc/get_sage_name(stat)
	if(!GLOB.featured_stats[stat] || !LAZYLEN(GLOB.featured_stats[stat]["entries"]))
		return
	var/list/stat_data = GLOB.featured_stats[stat]
	var/list/entries = list()
	for(var/key in stat_data["entries"])
		entries += list(list("name" = key, "count" = stat_data["entries"][key]))

	sortTim(entries, GLOBAL_PROC_REF(cmp_stat_count_desc))

	return splittext(entries[1]["name"], "(")[1] // basicaly we just trim off the (job title) here bcs we just want the name

/datum/component/dream_fragment/int/apply_buff()
	var/mob/living/carbon/human/H = parent
	H.apply_status_effect(/datum/status_effect/buff/dream_fragment, list(STATKEY_INT = 1))

/datum/component/dream_fragment/con
	dream_blurb = "a dream of a boundary"

// no round info in this one! just a big wall built "glacially" (which doesn't necessarily mean it's maid of ice)
/datum/component/dream_fragment/con/generate_dream_text()
	return "You dream of a great field, from which rises a great wall. Workers come by in a line, each one depositing a block onto the wall, which grows glacially ever-taller. Some leave, passing over the horizon; some climb atop the wall, and begin to man it. It is slow, thankless work; but the wall grows all the same, and stands strong in the face of all beyond. You wake with a feeling of resolution, the boundaries of the world appear sharper."

/datum/component/dream_fragment/con/apply_buff()
	var/mob/living/carbon/human/H = parent
	H.apply_status_effect(/datum/status_effect/buff/dream_fragment, list(STATKEY_CON = 1))

/datum/component/dream_fragment/str
	dream_blurb = "a dream of struggle"
	var/mob/living/carbon/human/rival
	var/removed = FALSE // we can end up calling remove_buff twice if you find your target and fight them, then the duration expires. so we add a check to prevent double debuffing

// instead of giving you esoteric world-knowledge fragments this one actually just assigns you a quest to go fight someone, like the graggar god's chosen but less evil-flavor; it tries to give you an equal matchup, thanks ravox. also this text here is just for the abyssorite, we personalize it to the fated rivals once it's bestowed
/datum/component/dream_fragment/str/generate_dream_text()
	return "You dream of... nothing. There is probably scenery around you; you no longer even perceive it. Your focus has narrowed the world to the edge of your blade as you face your rival, heart pounding, body straining. A feeling of exhilarating purity washes over you as you clash again and again, each intent on ending the other. You unleash a blinding flurry of blows and they respond in kind, pushing each other past your limits... you awake, feeling invigorated."

// unlike most dream datums, we actually change the dream desc here. this is because when we assign a rival, we want to measure them up to the recipient of the boon
// we DO NOT call parent here, as we want this one to have a different del timer attached
/datum/component/dream_fragment/str/PostTransfer()
	var/mob/living/carbon/human/H = parent
	if(!ishuman(parent)) // should be impossible but just in case admins do something weird
		return COMPONENT_INCOMPATIBLE
	// tldr for this algo is we take your statweight and adjust it by whether you have a combat trait (armor training, dexpert, etc) and what your highest wskill is to get a general 'power level'
	// then we pick a batch of players, find the one closest to your 'power level', and send you at each other
	var/target_weight = estimate_power(H)
	var/closest_diff = 300 // arbitrary high number
	var/mob/living/carbon/human/closest
	for(var/mob/living/carbon/human/candidate in GLOB.player_list)
		if(candidate.stat) // can't fight someone that's dead
			continue
		if(candidate.contents && candidate.contents.len < 4) // they're probably ERPing
			continue
		if(istype(get_area(candidate), /area/rogue/indoors/town/bath)) // if they're not ERPing they almost certainly don't want to go duel you
			continue
		var/weight = estimate_power(candidate)
		if(weight == target_weight)
			closest = candidate
			break
		if(abs(weight - target_weight) < closest_diff)
			closest = candidate
			closest_diff = abs(weight - target_weight)
	if(!closest) // how
		return
	dream_text = "You dream of... nothing. There is probably scenery around you; you no longer even perceive it. Your focus has narrowed the world to the edge of your blade as you face your rival, heart pounding, body straining. You know their name, their face: [closest.real_name], as much a warrior as yourself. A feeling of exhilarating purity washes over you as you clash again and again, each intent on ending the other. You unleash a blinding flurry of blows and they respond in kind, both pushing each other past your limits... you awake, feeling invigorated. Whispers of [H.patron.associated_faith == /datum/faith/inhumen ? "a chance to grow strong through sanguine delight" : "a chance to hone your skills in the sight of Malum and Ravox"] linger in your mind, pointing you towards [closest.prepare_deathsight_message(H)]."
	to_chat(closest, span_info("A wave of drowsiness washes over you, a waking dream overtaking you momentarily..."))
	to_chat(closest, span_purple("You dream of... nothing. There is probably scenery around you; you no longer even perceive it. Your focus has narrowed the world to the edge of your blade as you face your rival, heart pounding, body straining. You know their name, their face: [H.real_name], as much a warrior as yourself. A feeling of exhilarating purity washes over you as you clash again and again, each intent on ending the other. You unleash a blinding flurry of blows and they respond in kind, both pushing each other past your limits... you awake, feeling invigorated. Whispers of [closest.patron.associated_faith == /datum/faith/inhumen ? "a chance to grow strong through sanguine delight" : "a chance to hone your skills in the sight of Malum and Ravox"] linger in your mind, pointing you towards [H.prepare_deathsight_message(closest)]."))
	closest.apply_status_effect(/datum/status_effect/buff/dream_fragment, list(STATKEY_STR = 1))
	rival = closest
	RegisterSignal(H, COMSIG_MOB_CHECKDEFENSE, PROC_REF(handle_clash))
	RegisterSignal(closest, COMSIG_MOB_CHECKDEFENSE, PROC_REF(handle_clash))
	H.Sleeping(3 SECONDS) // aura
	to_chat(parent, span_purple(dream_text))
	apply_buff()
	addtimer(CALLBACK(src, PROC_REF(remove_buff)), DREAM_BUFF_DURATION) // the buff fades after the usual timer, but we keep the datum around for the rival quest!

/datum/component/dream_fragment/str/proc/handle_clash(mob/living/carbon/human/attacked, datum/intent/attack_intent, mob/living/attacker)
	if((attacked == rival && attacker == parent) || (attacker == rival && attacked == parent)) // let's die.
		UnregisterSignal(parent, COMSIG_MOB_CHECKDEFENSE)
		UnregisterSignal(rival, COMSIG_MOB_CHECKDEFENSE)
		to_chat(list(parent, rival), span_green("You clash with your rival, as was fated; the gods smile upon your bout!"))
		attacked.adjust_triumphs(3) // decent boon, because it's often _hard_ to track people down for this kind of thing. ik from experience playing graggarite
		attacker.adjust_triumphs(3)
		QDEL_IN(src, 5 MINUTES) // don't end immediately, we want you to have the buff for the actual fight!

/datum/component/dream_fragment/str/proc/estimate_power(mob/living/carbon/human/H)
	var/statweight = H.STACON + H.STAINT + H.STALUC + H.STAPER + H.STASPD * 2 + H.STASTR * 2 + H.STAWIL - 90 // standard statweight calc, each stat - 10 added up except str and spd count for 2 pts each
	var/combat_trait_weight = H.has_combat_trait() ? 5 : 0
	var/highest_wskill_weight = 0
	for(var/i in subtypesof(/datum/skill/combat))
		if((H.get_skill_level(i) * 2) > highest_wskill_weight)
			highest_wskill_weight = (H.get_skill_level(i) * 2)
	return statweight + combat_trait_weight + highest_wskill_weight

/datum/component/dream_fragment/str/apply_buff()
	var/mob/living/carbon/human/H = parent
	H.apply_status_effect(/datum/status_effect/buff/dream_fragment, list(STATKEY_STR = 1))

/datum/component/dream_fragment/str/remove_buff()
	if(removed)
		return
	removed = TRUE
	var/mob/living/carbon/human/H = parent
	H.remove_status_effect(/datum/status_effect/buff/dream_fragment)
	if(rival)
		rival.remove_status_effect(/datum/status_effect/buff/dream_fragment)

#undef DREAM_BUFF_DURATION
#undef DEATH_OMEN_EXPIRY
