/* ROLL EMOTES */
// Everything that settles an action with a roll: the freeform dice emote, the stat roll
// emotes, and contests of one stat against another.
//
// The freeform roll and the contest are verbs first. `/mob/proc/emote()` does not split a parameter
// off the key, so anything typed after it is eaten by the custom (`*me`) emote and never reaches an
// emote datum - `*dice d20` cannot carry `d20` as an argument the way the verb can. `*dice`, `*stat`
// and `*contested` exist anyway, as bare shortcuts that open the same prompts as their verbs.
//
// Results are reported as a short coloured token in chat carrying the whole breakdown in a hover
// tooltip.

/// Explains the freeform roll syntax. Shown whenever a roll arrives empty or unreadable.
#define DICE_SYNTAX_HELP "A roll is written as (number of dice)D(faces)(+ or - bonus)/(difficulty). \
	Only the faces are required. D20 throws one twenty-sided die. 2D6+3 throws two six-sided dice and \
	adds three. D20-5/DC15 throws one twenty-sided die, subtracts five, and compares the result against a \
	difficulty of fifteen."

/// Sanity caps on a freeform roll, so nobody throws 9999d9999 and floods the chat.
#define DICE_MAX_COUNT 24
#define DICE_MAX_SIDES 99
#define DICE_MAX_BONUS 99
/// Most dice a freeform roll writes out one by one in its sum. Beyond this they are added up first.
#define DICE_SUM_MAX_TERMS 6

/// Time before another roll can be made.
#define DICE_ROLL_COOLDOWN (10 SECONDS)

/// The die every stat roll throws, alone or against another in a contest. The stat and
/// traits are added on top of it.
#define STAT_ROLL_DIE 20

/// The higher of willpower and fortune.
#define STAT_CHARISMA "charisma"

/// Every stat that can be rolled or contested, by display name. The values double as the
/// `key` of the matching stat roll emote.
GLOBAL_LIST_INIT(rollable_stats, list(
	"Strength" = STAT_STRENGTH,
	"Perception" = STAT_PERCEPTION,
	"Intelligence" = STAT_INTELLIGENCE,
	"Constitution" = STAT_CONSTITUTION,
	"Willpower" = STAT_WILLPOWER,
	"Speed" = STAT_SPEED,
	"Fortune" = STAT_FORTUNE,
	"Charisma" = STAT_CHARISMA,
))

///////////////////////////////// SHARED //////////////////////////////////

/// Maps a roll key onto the stat actually read off the mob.
/mob/living/proc/resolve_stat_key(stat_key)
	// We compare willpower and fortune and use the highest. Not the best way to handle charisma
	// actions, may be subject to change in the future.
	if(stat_key == STAT_CHARISMA)
		return (get_stat(STAT_WILLPOWER) > get_stat(STAT_FORTUNE)) ? STAT_WILLPOWER : STAT_FORTUNE
	return stat_key

/// Shared gate for the rolling verbs - conscious, not emote-muted, and off cooldown.
/mob/living/proc/can_roll_dice()
	if(stat)
		return FALSE
	if(world.time < next_emote)
		return FALSE
	if(HAS_TRAIT(src, TRAIT_EMOTEMUTE))
		return FALSE
	if(client && (client.prefs.muted & MUTE_IC))
		to_chat(src, span_warning("I cannot send IC messages. (muted)"))
		return FALSE
	return TRUE

/// Colours a stat by the god who watches over it. Falls back to neutral for anything unknown.
/proc/stat_span(stat_key, str)
	switch(stat_key)
		if(STAT_STRENGTH)
			return span_ravox(str)
		if(STAT_PERCEPTION)
			return span_dendor(str)
		if(STAT_INTELLIGENCE)
			return span_noc(str)
		if(STAT_WILLPOWER)
			return span_graggar(str)
		if(STAT_CONSTITUTION)
			return span_malum(str)
		if(STAT_SPEED)
			return span_matthios(str)
		if(STAT_FORTUNE)
			return span_xylix(str)
		if(STAT_CHARISMA)
			return span_baotha(str)
	return span_xylix(str)

/// Colours roll text by outcome: `TRUE` success (Astrata), `FALSE` failure (Zizo), `null` neutral (Xylix).
/proc/roll_outcome_span(outcome, str)
	if(isnull(outcome))
		return span_xylix(str)
	return outcome ? span_astrata(str) : span_zizo(str)

/// Returns the tooltip body for a roll: one `LABEL: value` row per entry. The token already says
/// what happened, so a headline is only worth passing when the tooltip has something new to add.
/proc/roll_tooltip(outcome, headline, list/rows)
	var/body = jointext(rows, "<br>")
	if(headline)
		return roll_outcome_span(outcome, "<b>[headline]</b>") + "<br>" + body
	return body

/// Returns the token a roll leaves in chat. Short and coloured, with `tooltip` behind it.
/proc/roll_token(outcome, label, tooltip)
	return SPAN_TOOLTIP_DANGEROUS_HTML(tooltip, roll_outcome_span(outcome, "<b>[label]</b>"))

/**
	* Returns a token whose tooltip draws the dice that were thrown.
	* * dice - a list of throws, each a list of faces already inside 1..sides. One throw for a plain
	*   roll, one per side in a contest.
	* * sides - faces on each die. Up to six are drawn as pips, anything larger is numbered.
	* * throw_labels - optional text shown above each throw, in the same order as `dice`.
	* * throw_footers - optional text under a line below each throw, in the same order as `dice`.
	* Labels and footers may carry markup, so anything player-chosen in them must be encoded first.
	* * throw_stats - optional stat key of each throw, in the same order as `dice`. A throw
	*   with one is drawn in that stat's colour, and an outcome of `FALSE` only dims it.
	* * throw_outcomes - optional outcome of each throw (`TRUE`, `FALSE` or `null`), in the same order
	*   as `dice`, colouring each throw's dice. Without it every throw takes `outcome`.
	* The dice are drawn by the interface, so `tooltip` should not list them again.
	*/
/proc/roll_dice_token(outcome, label, tooltip, list/dice, sides, list/throw_labels, list/throw_outcomes, list/throw_stats, list/throw_footers)
	var/outcome_class = isnull(outcome) ? "neutral" : (outcome ? "good" : "bad")
	var/list/throws = list()
	for(var/list/throw_faces in dice)
		throws += jointext(throw_faces, "-")
	// `|` is what the interface splits on, so it cannot be allowed inside a label.
	var/list/safe_labels = list()
	for(var/throw_label in throw_labels)
		safe_labels += replacetext("[throw_label]", "|", "")
	var/list/safe_footers = list()
	for(var/throw_footer in throw_footers)
		safe_footers += replacetext("[throw_footer]", "|", "")
	var/list/outcome_classes = list()
	for(var/i in 1 to length(throw_outcomes))
		var/throw_outcome = throw_outcomes[i]
		outcome_classes += isnull(throw_outcome) ? "neutral" : (throw_outcome ? "good" : "bad")
	return "<span data-component=\"RollTooltip\" data-html=\"[html_encode(tooltip)]\" data-dice=\"[html_encode(jointext(throws, "|"))]\" data-labels=\"[html_encode(jointext(safe_labels, "|"))]\" data-sides=\"[sides]\" data-outcome=\"[outcome_class]\" data-outcomes=\"[jointext(outcome_classes, "|")]\" data-stats=\"[html_encode(jointext(throw_stats || list(), "|"))]\" data-footers=\"[html_encode(jointext(safe_footers, "|"))]\" class=\"tooltip\">[roll_outcome_span(outcome, "<b>[label]</b>")]</span>"

/**
	* Announces a roll where everyone can see it, in the same voice and from the same place an emote
	* would come from.
	* * chat_message - the line shown in chat. May carry HTML.
	* * runechat - the line shown over the roller's head. Must be plain text, runechat is maptext.
	* * show_name - whether the roller's name leads the chat line. Off when the line names someone itself.
	*/
/mob/living/proc/announce_roll(chat_message, runechat, show_name = TRUE)
	var/atom/movable/emotelocation = src
	var/mob/living/carbon/human/human = ishuman(src) ? src : null

	// A headless dullahan speaks from whichever half is doing the looking.
	if(isdullahan(src))
		var/datum/species/dullahan/dullahan = human.dna.species
		var/obj/item/organ/dullahan_vision/vision = human.getorganslot(ORGAN_SLOT_HUD)
		if(dullahan.headless && vision.viewing_head)
			emotelocation = dullahan.my_head

	var/styled_name = "<b>[emotelocation]</b>"
	if(human?.voice_color)
		var/color_to_use = human.voicecolor_override || human.voice_color
		styled_name = "<span style='color:[color_to_use];text-shadow:-1px -1px 0 #000,1px -1px 0 #000,-1px 1px 0 #000,1px 1px 0 #000;'><b>[emotelocation]</b></span>"

	log_message(chat_message, LOG_EMOTE)
	emotelocation.visible_message(show_name ? "[styled_name] [chat_message]" : chat_message, runechat_message = runechat, log_seen = SEEN_LOG_EMOTE)

///////////////////////////////// ROLL DICE EMOTE //////////////////////////////////

/mob/living/carbon/human/verb/roll_dice(expression as text|null)
	set name = "Roll Dice"
	set desc = "Throw dice, optionally against a difficulty and with modifiers."
	set category = "Emotes.Rolling"

	if(!can_roll_dice())
		return

	// Nothing typed after the verb, so explain the syntax in the prompt rather than in chat.
	if(!expression)
		expression = tgui_input_text(src, DICE_SYNTAX_HELP, "PRAISE XYLIX", max_length = 32)
		if(!expression)
			return

	if(!do_dice_roll(expression))
		return

	next_emote = world.time + DICE_ROLL_COOLDOWN

/**
	* Parses a freeform dice expression and announces the result.
	*
	* Accepts `[count]d<sides>[+/-bonus][/[dc]difficulty]`, case and whitespace insensitive, so all
	* of `d20`, `2D6 + 3`, `d20-1/15` and `d20+5/DC15` are understood. Returns TRUE if dice were
	* thrown, FALSE if the expression was rejected.
	*/
/mob/living/proc/do_dice_roll(expression)
	var/static/regex/dice_expression = regex(@"^(\d*)d(\d+)([+-]\d+)?(?:/?(?:dc)?(\d+))?$", "i")
	var/cleaned = replacetext(LOWER_TEXT(expression), " ", "")

	if(!dice_expression.Find(cleaned))
		to_chat(src, span_warning("That is not a roll I know how to make."))
		to_chat(src, span_notice(DICE_SYNTAX_HELP))
		return FALSE

	// An omitted count means a single die, an omitted bonus means none at all. An omitted difficulty
	// stays null, which is how we tell "no difficulty" apart from "a difficulty of zero".
	var/count = text2num(dice_expression.group[1]) || 1
	var/sides = text2num(dice_expression.group[2])
	var/bonus = text2num(dice_expression.group[3]) || 0
	var/dc = text2num(dice_expression.group[4])

	if(count > DICE_MAX_COUNT)
		to_chat(src, span_warning("I cannot throw more than [DICE_MAX_COUNT] dice at once."))
		return FALSE
	if(sides < 2 || sides > DICE_MAX_SIDES)
		to_chat(src, span_warning("A die has between 2 and [DICE_MAX_SIDES] faces."))
		return FALSE
	if(abs(bonus) > DICE_MAX_BONUS)
		to_chat(src, span_warning("That bonus is beyond reckoning."))
		return FALSE

	var/list/results = list()
	var/total = bonus
	for(var/i in 1 to count)
		var/result = rand(1, sides)
		results += result
		total += result

	// Rebuilt from the parsed numbers rather than echoed back, so no markup can be smuggled in.
	var/dice_string = "[count]d[sides]"
	if(bonus)
		dice_string += (bonus > 0 ? "+[bonus]" : "[bonus]")

	// null until a difficulty is set - that's the neutral case, not a loss.
	var/outcome = null
	if(!isnull(dc))
		outcome = (total >= dc)

	// Laid out like every other roll: what was thrown and added, the dice, a line, then the sum.
	var/header = "<b>[count]D[sides]</b>"
	if(bonus)
		header += "<br>Bonus <b>[signed_number(bonus)]</b>"
	// A fistful of dice would make for a sum too long to read, so past a few they are added up first.
	var/list/terms = (count > DICE_SUM_MAX_TERMS) ? list(total - bonus) : results.Copy()
	terms += bonus
	var/footer = roll_sum(outcome, terms)
	if(!isnull(dc))
		footer += "<br>Needs [dc] or more"

	var/verdict = ""
	var/runechat_verdict = ""
	if(!isnull(outcome))
		verdict = " — " + roll_outcome_span(outcome, outcome ? "<b>Success!</b>" : "<b>Failure!</b>")
		runechat_verdict = outcome ? " — success" : " — failure"

	announce_roll("rolls [roll_dice_token(outcome, "[dice_string] = [total]", "", list(results), sides, list(header), throw_footers = list(footer))][verdict]", "rolls [dice_string] for [total][runechat_verdict]")
	return TRUE

/// Bare `*dice` shortcut - takes no expression, just opens the same prompt as the Roll Dice verb.
/datum/emote/living/roll_dice_emote
	key = "dice"
	mob_type_allowed_typecache = /mob/living/carbon/human

/datum/emote/living/roll_dice_emote/run_emote(mob/user, params, type_override, intentional = FALSE)
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/human/human = user
	human.roll_dice()

///////////////////////////////// STAT ROLL //////////////////////////////////
// One emote per stat, each testing it against the odds and narrating the outcome. Still
// reachable as `*strength`, `*str` and so on; the verb below is the point-and-click route.

/datum/emote/living/stat_roll
	var/delay = 2.5 SECONDS
	var/list/attempt_message_list
	var/list/success_message_list
	var/list/failure_message_list

	/**
		* An assoc list of character traits which will affect the outcome of rolls by the defined values if the rolling player has them. If empty, this process will be ignored.
		* This basically determines the difficulty class in rolls (see: `/mob/living/proc/stat_roll()`)
		* -1 value means decreased difficulty class, one more point on the stat, otherwise vice versa.
		*/
	var/list/modifiers_list = list()

/// Points a mob's traits add to this stat when rolling it, negative if they get in the way.
/// A trait that lowers the difficulty class raises the roll, so the sign is flipped.
/datum/emote/living/stat_roll/proc/get_trait_effect(mob/living/rolling)
	var/total = 0
	var/list/sources = get_trait_sources(rolling)
	for(var/trait_key in sources)
		total += sources[trait_key]
	return total

/// Each trait of `rolling` that bears on this stat, mapped to the points it adds (negative if
/// it takes them away). The trait's key is its name.
/datum/emote/living/stat_roll/proc/get_trait_sources(mob/living/rolling)
	var/list/sources = list()
	for(var/trait_key in modifiers_list)
		if(HAS_TRAIT(rolling, trait_key))
			sources[trait_key] = -modifiers_list[trait_key]
	return sources

/// Points this mob's traits add when it rolls `stat_key`. Stat rolls and contests both use this, so
/// the same traits count wherever the stat is put to the test.
/mob/living/proc/get_roll_trait_effect(stat_key)
	for(var/datum/emote/living/stat_roll/roller in GLOB.emote_list[stat_key])
		return roller.get_trait_effect(src)
	return 0

/// The traits behind `get_roll_trait_effect()`, each mapped to the points it contributes.
/mob/living/proc/get_roll_trait_sources(stat_key)
	for(var/datum/emote/living/stat_roll/roller in GLOB.emote_list[stat_key])
		return roller.get_trait_sources(src)
	return list()

/datum/emote/living/stat_roll/run_emote(mob/user, params, type_override, intentional = FALSE)
	. = ..()
	if(!.)
		return

	var/mob/living/living = user
	// Set before the sleep below, not after - otherwise next_emote stays stale for the whole delay
	// and the roll can be spammed into a pile of overlapping announcements.
	living.next_emote = world.time + delay
	sleep(delay)

	// Our key is the stat being rolled, so no lookup table is needed.
	var/rolled_stat = living.resolve_stat_key(key)

	// The die plus the stat and traits must come out over the die's highest face. Every point
	// of stat is one more face of the die that gets there, which is the same 5% per point that
	// `/mob/living/proc/stat_roll()` works out as a percentage - 10 is an even chance, 20 is certain.
	var/stat_value = living.get_stat(rolled_stat)
	var/trait_effect = get_trait_effect(living)
	var/die = rand(1, STAT_ROLL_DIE)
	var/total = die + stat_value + trait_effect
	var/success = (total > STAT_ROLL_DIE)

	// Laid out like every other roll: the stat and its traits, the die, a line, then the sum and
	// what it has to beat. The token says whether it passed.
	var/list/trait_sources = get_trait_sources(living)
	var/header = stat_header(rolled_stat, stat_value, trait_sources)
	var/footer = roll_sum(success, list(die, stat_value, trait_effect)) + "<br>Needs over [STAT_ROLL_DIE]"
	// Several traits only show as a total under the stat, so name them here.
	var/tooltip = stat_trait_breakdown(trait_sources) || ""
	var/token = roll_dice_token(success, success ? "SUCCEEDS" : "FAILS", tooltip, list(list(die)), STAT_ROLL_DIE, list(header), throw_stats = list(key), throw_footers = list(footer))
	var/flavour = replace_pronoun(user, pick(success ? success_message_list : failure_message_list))

	living.announce_roll("[token] and [flavour]", show_runechat ? "[success ? "SUCCEEDS" : "FAILS"] and [flavour]" : null)

/datum/emote/living/stat_roll/select_message_type(mob/user, msg, intentional)
	return pick(attempt_message_list)

/mob/living/carbon/human/verb/emote_stat_roll()
	set name = "Roll Stat"
	set desc = "Roll one of your stats with traits taken into account."
	set category = "Emotes.Rolling"

	if(!can_roll_dice())
		return

	var/choice = tgui_input_list(src, "Which stat will you roll?", "PRAISE XYLIX", GLOB.rollable_stats)
	if(!choice)
		return

	emote(GLOB.rollable_stats[choice], intentional = TRUE)

/// Bare `*stat` shortcut - opens the same stat prompt as the Roll Stat verb.
/datum/emote/living/stat_pick_emote
	key = "stat"
	mob_type_allowed_typecache = /mob/living/carbon/human

/datum/emote/living/stat_pick_emote/run_emote(mob/user, params, type_override, intentional = FALSE)
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/human/human = user
	human.emote_stat_roll()

/datum/emote/living/stat_roll/strength
	key = STAT_STRENGTH
	key_third_person = "str"
	modifiers_list = list(
		TRAIT_BIGGUY = -1,
		TRAIT_STRENGTH_UNCAPPED = -1,
		TRAIT_STRONG_GRABBER = -1,
		TRAIT_CURSE_GRAGGAR = 2,
		TRAIT_CURSE_RAVOX = 2,
	)

	attempt_message_list = list(
		"tests their strength...",
		"puts their back into it...",
		"begins to flex...",
	)

	success_message_list = list(
		"is brimming with power!",
		"is truly beefy!",
		"shows off their muscle!",
	)

	failure_message_list = list(
		"is a little wet noodle...",
		"would lose in an arm wrestling match against a rous...",
		"should eat more sausage...",
	)

/// Preserved so `*str`/`*strength` keep a dedicated command-panel verb, same as every other stat roll.
/mob/living/carbon/human/verb/emote_strength_roll()
	set name = "Roll Strength"
	set category = "Emotes"

	emote(STAT_STRENGTH, intentional = TRUE)

/datum/emote/living/stat_roll/perception
	key = STAT_PERCEPTION
	key_third_person = "per"
	modifiers_list = list(
		TRAIT_KEENEARS = -1,
		TRAIT_COMBAT_AWARE = -1,
		TRAIT_PERFECT_TRACKER = -1,
		TRAIT_DEAF = 1,
		TRAIT_NEARSIGHT = 1,
		TRAIT_CYCLOPS_LEFT = 1,
		TRAIT_CYCLOPS_RIGHT = 1,
		TRAIT_BLIND = 2,
		TRAIT_CURSE_DENDOR = 2,
	)

	attempt_message_list = list(
		"takes a good, long look...",
		"focuses in...",
		"squints...",
	)

	success_message_list = list(
		"has eyes like a hawk!",
		"sees what others don't!",
		"has perfect 20/20 vision!",
	)

	failure_message_list = list(
		"is totally oblivious...",
		"has cataracts in their eyes...",
		"is blind...",
	)

/mob/living/carbon/human/verb/emote_perception_roll()
	set name = "Roll Perception"
	set category = "Emotes"

	emote(STAT_PERCEPTION, intentional = TRUE)

/datum/emote/living/stat_roll/intelligence
	key = STAT_INTELLIGENCE
	key_third_person = "int"
	modifiers_list = list(
		TRAIT_INTELLECTUAL = -1,
		TRAIT_ARCYNE = -1,
		TRAIT_SENTINELOFWITS = -1,
		TRAIT_DUMB = 1,
		TRAIT_SIMPLESPEECH = 1,
		TRAIT_CURSE_ZIZO = 2,
		TRAIT_CURSE_NOC = 2,
	)

	attempt_message_list = list(
		"thinks hard...",
		"furrows their brows...",
		"rubs their chin...",
	)

	success_message_list = list(
		"is a genius!",
		"has a mind sharp as a whip!",
		"knows what they're doing!",
	)

	failure_message_list = list(
		"is as dumb as a rock...",
		"has an empty head...",
		"couldn't put 2 and 2 together...",
	)

/mob/living/carbon/human/verb/emote_intelligence_roll()
	set name = "Roll Intelligence"
	set category = "Emotes"

	emote(STAT_INTELLIGENCE, intentional = TRUE)

/datum/emote/living/stat_roll/constitution
	key = STAT_CONSTITUTION
	key_third_person = "con"
	modifiers_list = list(
		TRAIT_NOPAIN = -1,
		TRAIT_NOPAINSTUN = -1,
		TRAIT_CRITICAL_RESISTANCE = -1,
		TRAIT_BLOOD_RESISTANCE = -1,
		TRAIT_CRITICAL_WEAKNESS = 1,
		TRAIT_CURSE_NECRA = 2,
		TRAIT_CURSE_MALUM = 2,
	)

	attempt_message_list = list(
		"tests their toughness...",
		"braces for impact...",
		"prepares to endure...",
	)

	success_message_list = list(
		"doesn't even flinch!",
		"is solid as an oak!",
		"is one tough nut to crack!",
	)

	failure_message_list = list(
		"has paper skin...",
		"would be torn to shreds by a light breeze...",
		"has a glass jaw...",
	)

/mob/living/carbon/human/verb/emote_constitution_roll()
	set name = "Roll Constitution"
	set category = "Emotes"

	emote(STAT_CONSTITUTION, intentional = TRUE)

/datum/emote/living/stat_roll/willpower
	key = STAT_WILLPOWER
	key_third_person = "wil"
	modifiers_list = list(
		TRAIT_FEARLESS = -1,
		TRAIT_PSYDONITE = -1,
		TRAIT_STEELHEARTED = -1,
		TRAIT_EORAN_CALM = -1,
		TRAIT_PSYCHOSIS = 1,
		TRAIT_CURSE_GRAGGAR = 2,
	)

	attempt_message_list = list(
		"tests their willpower...",
		"gathers their courage...",
		"prepares to use their determination...",
	)

	success_message_list = list(
		"proves mighty!",
		"never gives up!",
		"persists through anything!",
	)

	failure_message_list = list(
		"is a weak willed chicken...",
		"gives up trying...",
		"faints when they get a splinter...",
	)

/mob/living/carbon/human/verb/emote_willpower_roll()
	set name = "Roll Willpower"
	set category = "Emotes"

	emote(STAT_WILLPOWER, intentional = TRUE)

/datum/emote/living/stat_roll/speed
	key = STAT_SPEED
	key_third_person = "spd"
	modifiers_list = list(
		TRAIT_LEAPER = -1,
		TRAIT_LIGHT_STEP = -1,
		TRAIT_IGNORESLOWDOWN = -1,
		TRAIT_DODGEEXPERT = -1,
		TRAIT_ARMOR_NOSPDCAP = -1,
		TRAIT_CLUMSY = 1,
		TRAIT_PARALYSIS_L_LEG = 1,
		TRAIT_PARALYSIS_R_LEG = 1,
		TRAIT_NORUN = 2,
		TRAIT_CURSE_MATTHIOS = 2,
	)

	attempt_message_list = list(
		"prepares their moves...",
		"starts to get limber...",
		"tries to get speedy...",
	)

	success_message_list = list(
		"is in perfect control!",
		"is as agile as a cat!",
		"is very flexible!",
	)

	failure_message_list = list(
		"has two left feet...",
		"trips over themselves...",
		"is slower than a snail...",
	)

/mob/living/carbon/human/verb/emote_speed_roll()
	set name = "Roll Speed"
	set category = "Emotes"

	emote(STAT_SPEED, intentional = TRUE)

/datum/emote/living/stat_roll/fortune
	key = STAT_FORTUNE
	key_third_person = "for"
	modifiers_list = list(
		TRAIT_XYLIX_DEVOTEE = -1,
		TRAIT_CURSE_XYLIX = 2,
	)

	attempt_message_list = list(
		"tries their fortune...",
		"takes a chance...",
		"prepares to gamble...",
	)

	success_message_list = list(
		"could make an arrow turn around and climb back into the bow!",
		"has a rabbit's paw in their pocket!",
		"persists through pure luck!",
	)

	failure_message_list = list(
		"realizes the game was rigged from the start...",
		"gets dealt a bad hand...",
		"has the odds stacked against them...",
	)

/mob/living/carbon/human/verb/emote_fortune_roll()
	set name = "Roll Fortune"
	set category = "Emotes"

	emote(STAT_FORTUNE, intentional = TRUE)

/datum/emote/living/stat_roll/charisma
	key = STAT_CHARISMA
	key_third_person = "chr"
	modifiers_list = list(
		TRAIT_BEAUTIFUL = -1,
		TRAIT_BEAUTIFUL_UNCANNY = -1,
		TRAIT_EMPATH = -1,
		TRAIT_GOODLOVER = -1,
		TRAIT_INSPIRING_MUSICIAN = -1,
		TRAIT_CICERONE = -1,
		TRAIT_NOBLE = -1,
		TRAIT_EORAN_SERENE = -1,
		TRAIT_UNSEEMLY = 1,
		TRAIT_COMICSANS = 1,
		TRAIT_MISSING_NOSE = 1,
		TRAIT_DISFIGURED = 2,
		TRAIT_LEPROSY = 2,
		TRAIT_CURSE_BAOTHA = 2,
	)

	attempt_message_list = list(
		"tries to maintain their composure...",
		"attempts to appear impressive...",
		"starts contemplating their next move...",
	)

	success_message_list = list(
		"is brimming with self-confidence!",
		"has a true poker face!",
		"is the first crack in the sheer face of god, from them it will spread!",
	)

	failure_message_list = list(
		"is brimming with self-doubt...",
		"can't quite sell it...",
		"is holding it together with string and prayer...",
	)

/mob/living/carbon/human/verb/emote_charisma_roll()
	set name = "Roll Charisma"
	set category = "Emotes"

	emote(STAT_CHARISMA, intentional = TRUE)

///////////////////////////////// CONTESTED ROLL //////////////////////////////////

/**
	* The defender's half of a contest: the stat they're being challenged with in large
	* lettering, a big Decline button, then every stat laid out in a single row beneath it.
	* Self-contained rather than a generic `tgui_alert` - neither of those lay out a dedicated
	* "opt out" button separately from the options it sits above.
	*/
/datum/contest_response_prompt
	var/title
	var/challenger_name
	var/attacking_stat
	var/list/stats
	var/choice
	/// Set once the window has been answered, so a second click can't fire the callback again.
	var/answered = FALSE
	var/datum/callback/callback
	var/datum/ui_state/state

/datum/contest_response_prompt/New(mob/user, challenger_name, attacking_stat, title, list/stats, datum/callback/callback, timeout, ui_state)
	src.challenger_name = challenger_name
	src.attacking_stat = attacking_stat
	src.title = title
	// Flattened to a plain list, the same way /datum/tgui_list_input does it - an associative
	// list (GLOB.rollable_stats maps display name to stat key) serializes to the UI as a
	// JSON object rather than an array, not the string list the interface expects.
	src.stats = list()
	for(var/stat_name in stats)
		src.stats += stat_name
	src.callback = callback
	src.state = ui_state
	if(timeout)
		QDEL_IN(src, timeout)

/datum/contest_response_prompt/Destroy(force, ...)
	SStgui.close_uis(src)
	state = null
	stats = null
	QDEL_NULL(callback)
	return ..()

/datum/contest_response_prompt/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ContestResponse")
		ui.open()

/datum/contest_response_prompt/ui_state(mob/user)
	return state

/datum/contest_response_prompt/ui_static_data(mob/user)
	return list(
		"title" = title,
		"challengerName" = challenger_name,
		"attackingStat" = attacking_stat,
		"stats" = stats,
	)

/datum/contest_response_prompt/ui_act(action, list/params)
	if(..())
		return
	if(answered)
		return
	switch(action)
		if("choose")
			if(params["stat"] in stats)
				choice = params["stat"]
		if("decline")
			choice = null
		else
			return
	if(action == "choose" && isnull(choice))
		return
	answered = TRUE
	SStgui.close_uis(src)
	callback.InvokeAsync(choice)
	qdel(src)
	return TRUE

/// Opens the contest response window - fires `callback` with the chosen stat, or `null` if declined.
/proc/contest_response_async(mob/user, challenger_name, attacking_stat, title, list/stats, datum/callback/callback, timeout = 2 MINUTES)
	if(isnull(user?.client))
		return
	var/datum/contest_response_prompt/prompt = new(user, challenger_name, attacking_stat, title, stats, callback, timeout, GLOB.tgui_always_state)
	prompt.ui_interact(user)

/mob/living/carbon/human/verb/contested_roll()
	set name = "Contested Roll"
	set desc = "Pit one of your stats against another's."
	set category = "Emotes.Rolling"

	if(!can_roll_dice())
		return

	var/list/nearby = list()
	for(var/mob/living/carbon/human/opponent in range(src, 2))
		if(opponent == src || opponent.stat || !opponent.client)
			continue
		nearby |= opponent

	if(!length(nearby))
		to_chat(src, span_warning("There is nobody nearby to measure myself against!"))
		return

	var/mob/living/carbon/human/defender = tgui_input_list(src, "Who will you challenge?", "PRAISE XYLIX", nearby)
	// The handgames rules are what we want here: standing, out of combat mode, and within reach
	// across a table. Said out loud here so the challenger learns why, and rechecked silently below.
	if(!defender)
		return
	if(defender.cmode)
		to_chat(src, span_warning("[defender] is too tense for that!"))
		return
	if(!hand_games_check(src, defender))
		return

	var/challenger_choice = tgui_input_list(src, "Which of your stats will you stake?", "PRAISE XYLIX", GLOB.rollable_stats)
	if(!challenger_choice)
		return
	if(!hand_games_check(src, defender))
		return

	var/challenger_stat = GLOB.rollable_stats[challenger_choice]

	to_chat(src, span_notice("Setting my [challenger_stat] against [defender]. Awaiting their answer..."))
	// Neutral (xylix) styling here, same as the result tokens below - this is the "attempt" half of
	// a paired roll, the coloured outcome is the other half once the contest resolves.
	announce_roll("challenges [defender] to a contest of [stat_span(challenger_stat, challenger_stat)]!", "challenges [defender] to a contest of [challenger_stat]")
	to_chat(defender, span_notice("[src] sets their [challenger_stat] against you. Answer with one of your own stats, or let it pass."))

	// The defender picks their own stake rather than having the challenger pick it for them, and
	// does so through a window that neither grabs focus nor sits on top of the viewport - this is
	// a request, not an interruption.
	contest_response_async(
		defender,
		name,
		challenger_choice,
		"ALEA IACTA EST",
		GLOB.rollable_stats,
		CALLBACK(src, PROC_REF(on_contested_roll_response), defender, challenger_stat),
	)

/// Bare `*contested` shortcut - opens the same target/stat prompts as the Contested Roll verb.
/datum/emote/living/contested_roll_emote
	key = "contested"
	mob_type_allowed_typecache = /mob/living/carbon/human

/datum/emote/living/contested_roll_emote/run_emote(mob/user, params, type_override, intentional = FALSE)
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/human/human = user
	human.contested_roll()

/// Called once the defender answers (or ignores) the window from contested_roll(). `src` is still the challenger.
/mob/living/carbon/human/proc/on_contested_roll_response(mob/living/carbon/human/defender, challenger_stat, response)
	if(!response)
		to_chat(src, span_warning("[defender] declines the contest."))
		return
	if(!hand_games_check(src, defender))
		to_chat(src, span_warning("My contest with [defender] comes to nothing."))
		return

	var/defender_stat = GLOB.rollable_stats[response]
	// Same neutral pairing treatment as the challenge announcement - the coloured half of the pair
	// is resolve_contested_roll()'s result token.
	defender.announce_roll("answers with [stat_span(defender_stat, defender_stat)]!", "answers with [defender_stat]")

	resolve_contested_roll(defender, challenger_stat, defender_stat)
	next_emote = world.time + DICE_ROLL_COOLDOWN
	defender.next_emote = world.time + DICE_ROLL_COOLDOWN

/// The top of one side of a contest: who it is, then their stat and traits.
/proc/contest_side_header(mob/living/who, stat_key, stat_value, list/trait_sources)
	return "<b>[html_encode("[who]")]</b><br>" + stat_header(stat_key, stat_value, trait_sources)

/// What a stat is worth, then what the roller's traits add to it, on one line so a header never
/// runs past two. A single trait is named. Several would not fit, so they show as a total and
/// `stat_trait_breakdown()` names them elsewhere. Nothing is written for a roller with no
/// traits. Shared by every roll that uses a stat.
/proc/stat_header(stat_key, stat_value, list/trait_sources)
	var/header = "[stat_span(stat_key, "<b>[uppertext(stat_key)]</b>")] <b>[stat_value]</b>"
	if(length(trait_sources) == 1)
		var/trait_key = trait_sources[1]
		header += "<br>[trait_key] <b>[signed_number(trait_sources[trait_key])]</b>"
	else if(length(trait_sources) > 1)
		var/trait_total = 0
		for(var/trait_key in trait_sources)
			trait_total += trait_sources[trait_key]
		header += "<br>Traits <b>[signed_number(trait_total)]</b>"
	return header

/// Every trait behind a header that had to fold them into a total, with the points each adds, or
/// null when the header already named its one trait.
/proc/stat_trait_breakdown(list/trait_sources)
	if(length(trait_sources) < 2)
		return null
	var/list/entries = list()
	for(var/trait_key in trait_sources)
		entries += "[trait_key] <b>[signed_number(trait_sources[trait_key])]</b>"
	return jointext(entries, ", ")

/// A roll written out as an addition: `8 + 13 + 1 = 22`. The first term always shows, a term of
/// nothing after it does not, and a negative one is taken away. The total takes the outcome's colour.
/proc/roll_sum(outcome, list/terms)
	var/total = 0
	var/sum = ""
	var/added = FALSE
	for(var/i in 1 to length(terms))
		var/term = terms[i]
		total += term
		if(i == 1)
			sum = "[term]"
		else if(term)
			sum += " [term > 0 ? "+" : "-"] [abs(term)]"
			added = TRUE
	// With nothing added to it the first term is already the total, so there is no sum to show.
	if(!added)
		return roll_outcome_span(outcome, "<b>[total]</b>")
	return "[sum] = " + roll_outcome_span(outcome, "<b>[total]</b>")

/// `+3`, `-2` or `+0`, so a number always shows which way it pushes.
/proc/signed_number(number)
	return "[number >= 0 ? "+" : "-"][abs(number)]"

/// Throws a die for each side, adds their stat, and announces who came out on top.
/mob/living/proc/resolve_contested_roll(mob/living/defender, challenger_stat, defender_stat)
	var/challenger_stat_value = get_stat(resolve_stat_key(challenger_stat))
	var/defender_stat_value = defender.get_stat(defender.resolve_stat_key(defender_stat))
	// The same traits that help or hinder a stat roll count here too.
	var/list/challenger_trait_sources = get_roll_trait_sources(challenger_stat)
	var/list/defender_trait_sources = defender.get_roll_trait_sources(defender_stat)
	var/challenger_bonus = challenger_stat_value + get_roll_trait_effect(challenger_stat)
	var/defender_bonus = defender_stat_value + defender.get_roll_trait_effect(defender_stat)
	var/challenger_die = rand(1, STAT_ROLL_DIE)
	var/defender_die = rand(1, STAT_ROLL_DIE)
	var/challenger_total = challenger_die + challenger_bonus
	var/defender_total = defender_die + defender_bonus

	// null for a draw - the only genuinely neutral result in a contest.
	var/result = null
	var/verdict = "Neither prevails!"
	if(challenger_total != defender_total)
		result = (challenger_total > defender_total)
		var/mob/living/winner = result ? src : defender
		verdict = "[winner] prevails!"

	// Both totals are already under each name, and the dice are coloured by who came out ahead. All
	// that is left is naming the traits of anyone who has too many to fit under their name.
	var/list/trait_rows = list()
	var/challenger_breakdown = stat_trait_breakdown(challenger_trait_sources)
	if(challenger_breakdown)
		trait_rows += "<b>[html_encode("[src]")]</b> [challenger_breakdown]"
	var/defender_breakdown = stat_trait_breakdown(defender_trait_sources)
	if(defender_breakdown)
		trait_rows += "<b>[html_encode("[defender]")]</b> [defender_breakdown]"
	var/tooltip = roll_tooltip(result, null, trait_rows)
	// Both sides are laid out the same way: stat, traits, the die, a line, then the result.
	var/list/throw_labels = list(
		contest_side_header(src, challenger_stat, challenger_stat_value, challenger_trait_sources),
		contest_side_header(defender, defender_stat, defender_stat_value, defender_trait_sources),
	)
	var/challenger_outcome = result
	var/defender_outcome = isnull(result) ? null : !result
	var/list/throw_footers = list(
		roll_sum(challenger_outcome, list(challenger_die, challenger_stat_value, challenger_bonus - challenger_stat_value)),
		roll_sum(defender_outcome, list(defender_die, defender_stat_value, defender_bonus - defender_stat_value)),
	)
	var/token = roll_dice_token(result, html_encode(verdict), tooltip, list(list(challenger_die), list(defender_die)), STAT_ROLL_DIE, throw_labels, list(challenger_outcome, defender_outcome), list(challenger_stat, defender_stat), throw_footers)
	announce_roll(token, verdict, show_name = FALSE)

#undef DICE_SYNTAX_HELP
#undef DICE_MAX_COUNT
#undef DICE_MAX_SIDES
#undef DICE_MAX_BONUS
#undef DICE_SUM_MAX_TERMS
#undef DICE_ROLL_COOLDOWN
#undef STAT_ROLL_DIE
#undef STAT_CHARISMA
