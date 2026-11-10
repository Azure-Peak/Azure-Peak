/* ROLL EMOTES */
// Everything that settles an action with a roll: the freeform dice emote, the stat roll
// emotes, and contests of one stat against another.
//
// The freeform roll and the contest are verbs first. `/mob/proc/emote()` does not split a parameter
// off the key, so a roll typed after a `*` is caught earlier, in `/mob/proc/check_emote()`, by
// `try_dice_emote()`: `*5d20/DC15` is thrown on the spot. `*dice`, `*stat` and `*contested` exist as
// bare shortcuts that open the same windows as their verbs.
//
// Results are reported as a short coloured token in chat carrying the whole breakdown in a hover
// tooltip.

/// Explains the freeform roll syntax. Shown whenever a roll arrives empty or unreadable.
#define DICE_SYNTAX_HELP "A roll is written as (number of dice)D(faces), then any bonuses, then /DC and a difficulty. \
	Only the faces are required. D20 throws one twenty-sided die. 2D6+3 throws two six-sided dice and adds \
	three. D20+STR adds your strength, and any of STR, PER, INT, CON, WIL, SPD, FOR and CHA work the same way. \
	3D6+STR+1/DC12 throws three dice, adds your strength and one, and compares the result against a \
	difficulty of twelve. Add /NOCRIT at the end to leave criticals out. You can type any of these after a * to roll right away, like *2D10+STR/DC15."

/// Sanity caps on a freeform roll, so nobody throws 9999d9999 and floods the chat.
#define DICE_MAX_COUNT 24
#define DICE_MAX_SIDES 100
#define DICE_MAX_BONUS 100 
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

/// The same stats by key, for checking one that came from outside.
GLOBAL_LIST_INIT(rollable_stats_by_key, list(
	STAT_STRENGTH,
	STAT_PERCEPTION,
	STAT_INTELLIGENCE,
	STAT_CONSTITUTION,
	STAT_WILLPOWER,
	STAT_SPEED,
	STAT_FORTUNE,
	STAT_CHARISMA,
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
			return span_ravox_plain(str)
		if(STAT_PERCEPTION)
			return span_dendor_plain(str)
		if(STAT_INTELLIGENCE)
			return span_noc_plain(str)
		if(STAT_WILLPOWER)
			return span_graggar_plain(str)
		if(STAT_CONSTITUTION)
			return span_malum_plain(str)
		if(STAT_SPEED)
			return span_matthios_plain(str)
		if(STAT_FORTUNE)
			return span_xylix_plain(str)
		if(STAT_CHARISMA)
			return span_baotha_plain(str)
	return span_xylix_plain(str)

/// Colours roll text by outcome: `TRUE` success (Astrata), `FALSE` failure (Zizo), `null` neutral (Xylix).
/proc/roll_outcome_span(outcome, str)
	if(isnull(outcome))
		return span_xylix_plain(str)
	return outcome ? span_astrata_plain(str) : span_zizo_plain(str)

/// A throw only crits if it is at most this rare, so a lone d6 or a d2 never does.
#define CRIT_MAX_ODDS STAT_ROLL_DIE

/**
	* Whether a throw was a critical: `TRUE` if every die came up its highest face, `FALSE` if every die
	* came up a 1, `null` for anything else. Dice that would crit more often than one time in
	* `CRIT_MAX_ODDS` never do, so a d20, a 2d10 or a 3d6 can, and a d6 or a d10 on its own cannot.
	*/
/proc/natural_crit(list/faces, sides)
	if(!length(faces) || (sides ** length(faces)) < CRIT_MAX_ODDS)
		return null
	var/highest = TRUE
	var/lowest = TRUE
	for(var/face in faces)
		if(face != sides)
			highest = FALSE
		if(face != 1)
			lowest = FALSE
	if(highest)
		return TRUE
	if(lowest)
		return FALSE
	return null

/// Colours roll text by outcome, or in the gods' glow for a critical (`crit` of `TRUE` or `FALSE`).
/proc/roll_label_span(outcome, crit, str)
	if(isnull(crit))
		return roll_outcome_span(outcome, str)
	return crit ? span_astrata(str) : span_zizo(str)

/// What a critical is called, in capitals for a token.
/proc/crit_label(crit)
	return crit ? "CRITICALLY SUCCEEDS" : "CRITICAL FAILS"

/// The line under dice that came up a critical.
/proc/crit_footer(crit)
	return "<br>" + roll_label_span(crit, crit, crit_label(crit))

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
	* * sides - faces on each die, or a list of them with one per throw. Up to six are drawn as pips, anything larger is numbered.
	* * throw_labels - optional text shown above each throw, in the same order as `dice`.
	* * throw_footers - optional text under a line below each throw, in the same order as `dice`.
	* Labels and footers may carry markup, so anything player-chosen in them must be encoded first.
	* * throw_stats - optional stat key of each throw, in the same order as `dice`. A throw
	*   with one is drawn in that stat's colour, and an outcome of `FALSE` only dims it.
	* * throw_outcomes - optional outcome of each throw (`TRUE`, `FALSE` or `null`), in the same order
	*   as `dice`, colouring each throw's dice. Without it every throw takes `outcome`.
	* * crit - `TRUE` or `FALSE` if the roll was decided by a critical, which gives its label the glow.
	* The dice are drawn by the interface, so `tooltip` should not list them again.
	*/
/proc/roll_dice_token(outcome, label, tooltip, list/dice, sides, list/throw_labels, list/throw_outcomes, list/throw_stats, list/throw_footers, crit)
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
	return "<span data-component=\"RollTooltip\" data-html=\"[html_encode(tooltip)]\" data-dice=\"[html_encode(jointext(throws, "|"))]\" data-labels=\"[html_encode(jointext(safe_labels, "|"))]\" data-sides=\"[islist(sides) ? jointext(sides, "|") : sides]\" data-outcome=\"[outcome_class]\" data-outcomes=\"[jointext(outcome_classes, "|")]\" data-stats=\"[html_encode(jointext(throw_stats || list(), "|"))]\" data-footers=\"[html_encode(jointext(safe_footers, "|"))]\" class=\"tooltip\">[roll_label_span(outcome, crit, "<b>[label]</b>")]</span>"

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

/mob/living/carbon/human/verb/roll_dice()
	set name = "Roll Dice"
	set desc = "Throw dice, optionally with a stat added and against a difficulty. Typing *2d10+STR/DC15 does the same."
	set category = "Emotes.Rolling"

	if(!can_roll_dice())
		return

	var/list/parsed = tgui_dice_builder(src, "Xylix's Dice Box", allow_difficulty = TRUE)
	if(!parsed)
		return

	announce_dice_roll(parsed)
	next_emote = world.time + DICE_ROLL_COOLDOWN

/**
	* Catches `*5d20/DC15` and its kind before they are taken for an emote called "5d20/DC15". Anything
	* that begins like a roll is ours, right or wrong, so a typo gets the syntax help rather than being
	* spoken as a custom emote. Returns TRUE if `text` was a roll.
	*/
/mob/proc/try_dice_emote(text)
	return FALSE

/mob/living/carbon/human/try_dice_emote(text)
	var/static/regex/dice_shape = regex(@"^\s*\d*\s*d\s*\d", "i")
	if(!dice_shape.Find(text))
		return FALSE
	if(!can_roll_dice())
		return TRUE
	if(do_dice_roll(text))
		next_emote = world.time + DICE_ROLL_COOLDOWN
	return TRUE

/// What a stat is called in a roll, by every name it may be written with.
GLOBAL_LIST_INIT(dice_stat_names, list(
	"str" = STAT_STRENGTH,
	"strength" = STAT_STRENGTH,
	"per" = STAT_PERCEPTION,
	"perception" = STAT_PERCEPTION,
	"int" = STAT_INTELLIGENCE,
	"intelligence" = STAT_INTELLIGENCE,
	"con" = STAT_CONSTITUTION,
	"constitution" = STAT_CONSTITUTION,
	"wil" = STAT_WILLPOWER,
	"will" = STAT_WILLPOWER,
	"willpower" = STAT_WILLPOWER,
	"spd" = STAT_SPEED,
	"speed" = STAT_SPEED,
	"for" = STAT_FORTUNE,
	"fortune" = STAT_FORTUNE,
	"cha" = STAT_CHARISMA,
	"charisma" = STAT_CHARISMA,
))

/**
	* Reads a freeform dice expression into `list("count", "sides", "bonus", "stat", "dc")`, `stat` and
	* `dc` being null when not given. Tells `src` what was wrong and returns null if it can't be thrown.
	* An omitted count means a single die, an omitted bonus means none at all.
	*/
/mob/living/proc/parse_dice_expression(expression)
	var/static/regex/dice_expression = regex(@"^(\d*)d(\d+)((?:[+-](?:\d+|[a-z]+))*)(?:/?(?:dc)?(\d+))?(/?nocrits?)?$", "i")
	var/static/regex/dice_modifier = regex(@"([+-])(\d+|[a-z]+)", "g")
	var/cleaned = replacetext(LOWER_TEXT(expression), " ", "")

	if(!dice_expression.Find(cleaned))
		to_chat(src, span_warning("That is not a roll I know how to make."))
		to_chat(src, span_notice(DICE_SYNTAX_HELP))
		return null

	var/count = text2num(dice_expression.group[1]) || 1
	var/sides = text2num(dice_expression.group[2])
	var/modifiers = dice_expression.group[3]
	// Null when omitted, which tells "no difficulty" from "a difficulty of zero".
	var/dc = text2num(dice_expression.group[4])
	var/crits = !dice_expression.group[5]

	// What follows the dice is a run of +3, -2 or +STR: numbers add up, and one stat may be named.
	var/bonus = 0
	var/stat = null
	while(dice_modifier.Find(modifiers))
		var/sign = dice_modifier.group[1] == "-" ? -1 : 1
		var/term = dice_modifier.group[2]
		var/term_value = text2num(term)
		if(!isnull(term_value))
			bonus += sign * term_value
			continue
		if(!GLOB.dice_stat_names[term])
			to_chat(src, span_warning("I do not know of any stat called '[html_encode(term)]'."))
			to_chat(src, span_notice(DICE_SYNTAX_HELP))
			return null
		if(stat || sign < 0)
			to_chat(src, span_warning("A roll can have one stat added to it, and not taken away."))
			return null
		stat = GLOB.dice_stat_names[term]

	if(count > DICE_MAX_COUNT)
		to_chat(src, span_warning("I cannot throw more than [DICE_MAX_COUNT] dice at once."))
		return null
	if(sides < 2 || sides > DICE_MAX_SIDES)
		to_chat(src, span_warning("A die has between 2 and [DICE_MAX_SIDES] faces."))
		return null
	if(abs(bonus) > DICE_MAX_BONUS)
		to_chat(src, span_warning("That bonus is beyond reckoning."))
		return null
	return list("count" = count, "sides" = sides, "bonus" = bonus, "stat" = stat, "dc" = dc, "crits" = crits)

/// `2d10+STR+3`, rebuilt from parsed numbers rather than echoed back, so no markup can be smuggled in.
/proc/dice_expression_string(list/parsed)
	var/dice_string = "[parsed["count"]]d[parsed["sides"]]"
	if(parsed["stat"])
		dice_string += "+[stat_code(parsed["stat"])]"
	if(parsed["bonus"])
		dice_string += signed_number(parsed["bonus"])
	return dice_string

/// Three letters for a stat as it is typed in a roll, which is the first three letters of all but speed.
/proc/stat_code(stat_key)
	return (stat_key == STAT_SPEED) ? "SPD" : uppertext(copytext(stat_key, 1, 4))

/**
	* Throws the dice of a parsed expression and adds what goes with them. Returns
	* `list("faces", "sides", "total", "stat", "header", "terms", "trait_sources", "crit")`.
	*
	* Whatever is added reads in the same order everywhere: the stat, then what the traits add to it, then
	* any bonus, and last the dice themselves. `header` is the same order down the page.
	*/
/mob/living/proc/throw_dice(list/parsed)
	var/count = parsed["count"]
	var/sides = parsed["sides"]
	var/bonus = parsed["bonus"]
	var/stat = parsed["stat"]

	var/list/faces = list()
	var/dice_total = 0
	for(var/i in 1 to count)
		var/face = rand(1, sides)
		faces += face
		dice_total += face

	var/stat_value = 0
	var/trait_effect = 0
	var/list/trait_sources = list()
	if(stat)
		stat_value = get_stat(resolve_stat_key(stat))
		trait_effect = get_roll_trait_effect(stat)
		trait_sources = get_roll_trait_sources(stat)

	var/header = "<b>[count]D[sides]</b>"
	if(stat)
		header += "<br>" + stat_header(stat, stat_value, trait_sources)
	if(bonus)
		header += "<br>Bonus <b>[signed_number(bonus)]</b>"

	// Zero terms are left out, so the sum never opens on a lone zero.
	var/list/terms = list()
	for(var/modifier in list(stat_value, trait_effect, bonus))
		if(modifier)
			terms += modifier
	// Past a few dice the sum would be too long, so they are added up first.
	terms += (count > DICE_SUM_MAX_TERMS) ? list(dice_total) : faces

	return list(
		"faces" = faces,
		"sides" = sides,
		"total" = dice_total + stat_value + trait_effect + bonus,
		"stat" = stat,
		"header" = header,
		"terms" = terms,
		"trait_sources" = trait_sources,
		// Criticals count unless the roll opted out.
		"crit" = (parsed["crits"] == FALSE) ? null : natural_crit(faces, sides),
	)

/**
	* Throws a freeform dice expression and announces the result.
	*
	* Accepts `[count]d<sides>` followed by any of `+3`, `-2` and `+STR`, then an optional `/DC<number>`,
	* case and whitespace insensitive, so `d20`, `2D6 + 3`, `d20-1/15`, `d20+5/DC15` and `3d6+STR+1/DC12`
	* are all understood. Returns TRUE if dice were thrown, FALSE if the expression was rejected.
	*/
/mob/living/proc/do_dice_roll(expression)
	var/list/parsed = parse_dice_expression(expression)
	if(!parsed)
		return FALSE
	announce_dice_roll(parsed)
	return TRUE

/// Throws an already parsed expression, and tells everyone in sight how it fell.
/mob/living/proc/announce_dice_roll(list/parsed)
	var/list/side = throw_dice(parsed)
	var/dc = parsed["dc"]
	var/total = side["total"]
	var/crit = side["crit"]
	var/dice_string = dice_expression_string(parsed)

	// null until a difficulty is set - that's the neutral case, not a loss.
	var/outcome = null
	// A critical decides a difficulty on its own, and is worth a mention without one.
	if(!isnull(dc))
		outcome = isnull(crit) ? (total >= dc) : crit

	var/footer = roll_sum(outcome, side["terms"])
	if(!isnull(dc))
		footer += "<br>Needs [dc] or more"
	if(!isnull(crit))
		footer += crit_footer(crit)
	// Several traits only show as a total under the stat, so name them here.
	var/tooltip = stat_trait_breakdown(side["trait_sources"]) || ""

	var/verdict = ""
	var/runechat_verdict = ""
	if(!isnull(crit))
		verdict = " — " + roll_label_span(crit, crit, "<b>[crit_label(crit)]!</b>")
		runechat_verdict = " — [crit_label(crit)]"
	else if(!isnull(outcome))
		verdict = " — " + roll_outcome_span(outcome, outcome ? "<b>Success!</b>" : "<b>Failure!</b>")
		runechat_verdict = outcome ? " — success" : " — failure"

	var/list/throw_stats = side["stat"] ? list(side["stat"]) : null
	announce_roll("rolls [roll_dice_token(outcome, "[dice_string] = [total]", tooltip, list(side["faces"]), side["sides"], list(side["header"]), throw_stats = throw_stats, throw_footers = list(footer), crit = crit)][verdict]", "rolls [dice_string] for [total][runechat_verdict]")

/// Bare `*dice` shortcut - opens the same dice window as the Roll Dice verb.
/datum/emote/living/roll_dice_emote
	key = "dice"
	mob_type_allowed_typecache = /mob/living/carbon/human

/datum/emote/living/roll_dice_emote/run_emote(mob/user, params, type_override, intentional = FALSE)
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/human/human = user
	human.roll_dice()

/**
	* The window dice are built in: how many, how many faces, a stat to add, a bonus, and a difficulty if
	* the roll takes one. Everything is picked rather than typed, so the roll can't be misspelled.
	*/
/datum/dice_builder_prompt
	var/title
	var/allow_difficulty
	/// What was built, in the shape `parse_dice_expression()` returns, once the window is answered.
	var/list/result
	var/closed = FALSE
	var/datum/ui_state/state

/datum/dice_builder_prompt/New(mob/user, title, allow_difficulty, ui_state)
	src.title = title
	src.allow_difficulty = allow_difficulty
	src.state = ui_state

/datum/dice_builder_prompt/Destroy(force, ...)
	SStgui.close_uis(src)
	state = null
	return ..()

/// Waits for the window to be answered or closed.
/datum/dice_builder_prompt/proc/wait()
	while(!closed && !QDELETED(src))
		stoplag(1)

/datum/dice_builder_prompt/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "DiceBuilder")
		ui.open()

/datum/dice_builder_prompt/ui_close(mob/user)
	. = ..()
	closed = TRUE

/datum/dice_builder_prompt/ui_state(mob/user)
	return state

/datum/dice_builder_prompt/ui_static_data(mob/user)
	var/list/stats = list()
	for(var/stat_name in GLOB.rollable_stats)
		stats += list(list("name" = stat_name, "key" = GLOB.rollable_stats[stat_name], "code" = stat_code(GLOB.rollable_stats[stat_name])))
	return list(
		"title" = title,
		"allowDifficulty" = allow_difficulty,
		"stats" = stats,
		"maxCount" = DICE_MAX_COUNT,
		"maxSides" = DICE_MAX_SIDES,
		"maxBonus" = DICE_MAX_BONUS,
	)

/datum/dice_builder_prompt/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	switch(action)
		if("roll")
			// Client input, so it is all validated.
			var/count = text2num(params["count"])
			var/sides = text2num(params["sides"])
			var/bonus = text2num(params["bonus"])
			var/dc = allow_difficulty ? text2num(params["dc"]) : null
			var/stat = params["stat"]
			if(isnull(count) || isnull(sides) || isnull(bonus))
				return
			if(round(count) != count || round(sides) != sides || round(bonus) != bonus || (!isnull(dc) && round(dc) != dc))
				return
			if(count < 1 || count > DICE_MAX_COUNT || sides < 2 || sides > DICE_MAX_SIDES || abs(bonus) > DICE_MAX_BONUS)
				return
			// The window names stats by their key, which is what the roll reads.
			if(stat && !(stat in GLOB.rollable_stats_by_key))
				return
			// Anything but an outright no leaves criticals on.
			var/crits = !(params["crits"] in list(0, "0", "false"))
			result = list("count" = count, "sides" = sides, "bonus" = bonus, "stat" = stat || null, "dc" = dc, "crits" = crits)
			closed = TRUE
			SStgui.close_uis(src)
			return TRUE
		if("cancel")
			closed = TRUE
			SStgui.close_uis(src)
			return TRUE

/// Opens the dice window and waits for it. Returns what was built, or `null` if it was closed.
/proc/tgui_dice_builder(mob/user, title = "Roll Dice", allow_difficulty = TRUE)
	if(isnull(user?.client))
		return null
	var/datum/dice_builder_prompt/prompt = new(user, title, allow_difficulty, GLOB.tgui_always_state)
	prompt.ui_interact(user)
	prompt.wait()
	if(prompt)
		. = prompt.result
		qdel(prompt)

///////////////////////////////// STAT ROLL //////////////////////////////////
// One emote per stat, each testing it against the odds and narrating the outcome. Still
// reachable as `*strength`, `*str` and so on; the verb below is the point-and-click route.

/datum/emote/living/stat_roll
	var/delay = 2.5 SECONDS
	var/list/attempt_message_list
	var/list/success_message_list
	var/list/failure_message_list
	/// Said instead of the lists above when the die comes up a natural 20 or 1.
	var/list/crit_success_message_list
	var/list/crit_failure_message_list

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
	// `/mob/living/proc/stat_roll()` works out as a percentage - 10 is an even chance. A natural 20
	// or 1 settles the roll whatever the stat, so not even a stat of 20 is quite certain.
	var/stat_value = living.get_stat(rolled_stat)
	var/trait_effect = get_trait_effect(living)
	var/die = rand(1, STAT_ROLL_DIE)
	var/total = die + stat_value + trait_effect
	var/crit = natural_crit(list(die), STAT_ROLL_DIE)
	var/success = isnull(crit) ? (total > STAT_ROLL_DIE) : crit

	var/list/trait_sources = get_trait_sources(living)
	var/header = stat_header(rolled_stat, stat_value, trait_sources)
	var/footer = roll_sum(success, list(stat_value, trait_effect, die)) + "<br>Needs over [STAT_ROLL_DIE]"
	if(!isnull(crit))
		footer += crit_footer(crit)
	// Several traits only show as a total under the stat, so name them here.
	var/tooltip = stat_trait_breakdown(trait_sources) || ""
	var/verdict = !isnull(crit) ? crit_label(crit) : (success ? "SUCCEEDS" : "FAILS")
	var/token = roll_dice_token(success, verdict, tooltip, list(list(die)), STAT_ROLL_DIE, list(header), throw_stats = list(key), throw_footers = list(footer), crit = crit)
	var/list/flavour_list = success ? success_message_list : failure_message_list
	if(!isnull(crit))
		flavour_list = (crit ? crit_success_message_list : crit_failure_message_list) || flavour_list
	var/flavour = replace_pronoun(user, pick(flavour_list))

	living.announce_roll("[token] and [flavour]", show_runechat ? "[verdict] and [flavour]" : null)

/datum/emote/living/stat_roll/select_message_type(mob/user, msg, intentional)
	return pick(attempt_message_list)

/mob/living/carbon/human/verb/emote_stat_roll()
	set name = "Roll Stat"
	set desc = "Roll one of your stats with traits taken into account."
	set category = "Emotes.Rolling"

	if(!can_roll_dice())
		return

	var/choice = tgui_input_list(src, "Which stat will you roll?", "Xylix's Dice Box", GLOB.rollable_stats)
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
		"is strong as blacksteel!",
		"shows off their muscle!",
	)

	failure_message_list = list(
		"is a little wet noodle...",
		"would lose in an arm wrestling match against a rous...",
		"ate too many psybuns...",
	)

	crit_success_message_list = list(
		"makes Ravox proud!",
	)

	crit_failure_message_list = list(
		"is limp like a pintle!",
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
		"has eyes like a zad!",
		"sees what others don't!",
		"doesn't need spectacles!",
	)

	failure_message_list = list(
		"is totally oblivious...",
		"has cataracts in their eyes...",
		"is blind...",
	)

	crit_success_message_list = list(
		"sees through Dendor's thickest brush!",
	)

	crit_failure_message_list = list(
		"is lost in the fog!",
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

	crit_success_message_list = list(
		"knows Noc's deepest secret!",
	)

	crit_failure_message_list = list(
		"is the village eejit!",
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

	crit_success_message_list = list(
		"is truly robust!",
	)

	crit_failure_message_list = list(
		"instantly loses!",
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

	crit_success_message_list = list(
		"ENDURES!!",
	)

	crit_failure_message_list = list(
		"folds like wet parchment!",
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
		"is as agile as a cabbit!",
		"is very flexible!",
	)

	failure_message_list = list(
		"has two left feet...",
		"trips over themselves...",
		"is slower than a leech...",
	)

	crit_success_message_list = list(
		"steals a zenny off Matthios!",
	)

	crit_failure_message_list = list(
		"is slow like the jester!",
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
		"has a cabbit's paw in their pocket!",
		"persists through pure luck!",
	)

	failure_message_list = list(
		"realizes the game was rigged from the start...",
		"gets dealt a bad hand...",
		"has the odds stacked against them...",
	)

	crit_success_message_list = list(
		"pleases Xylix!",
	)

	crit_failure_message_list = list(
		"offends Xylix!",
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
		TRAIT_ANNOYINGVOICE = 1,
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

	crit_success_message_list = list(
		"could woo Baotha!",
	)

	crit_failure_message_list = list(
		"makes everything worse by their pure existence.",
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
		to_chat(src, span_warning("There is nobody nearby to challenge!"))
		return

	var/mob/living/carbon/human/defender = tgui_input_list(src, "Who will you challenge?", "Xylix's Dice Box", nearby)
	// The handgames rules are what we want here: standing, out of combat mode, and within reach
	// across a table. Said out loud here so the challenger learns why, and rechecked silently below.
	if(!defender)
		return
	if(defender.cmode)
		to_chat(src, span_warning("[defender] is too tense for games."))
		return
	if(!hand_games_check(src, defender))
		return

	var/challenger_choice = tgui_input_list(src, "Challenging [defender]!", "Xylix's Dice Box", contest_options())
	if(!challenger_choice)
		return
	var/challenger_pick = contest_pick(challenger_choice)
	if(!challenger_pick)
		return
	if(!hand_games_check(src, defender))
		return

	var/challenger_label = contest_pick_label(challenger_pick)

	// A stat is "their STR", dice are just "2D6+CHA".
	var/custom = islist(challenger_pick)
	to_chat(src, span_notice("I challenge [defender] with [custom ? "" : "my "][challenger_label]. Awaiting their defense."))
	// Neutral (xylix) styling here, same as the result tokens below - this is the "attempt" half of
	// a paired roll, the coloured outcome is the other half once the contest resolves.
	announce_roll("challenges [defender] with [custom ? "" : "[p_their()] "][stat_span(challenger_label, challenger_label)]!", "challenges [defender] with [custom ? "" : "[p_their()] "][challenger_label]")
	to_chat(defender, span_notice("[src] challenges me with [custom ? "" : "[p_their()] "][challenger_label]. Defend with a stat or decline."))

	// The defender picks their own stake rather than having the challenger pick it for them, and
	// does so through a window that neither grabs focus nor sits on top of the viewport - this is
	// a request, not an interruption.
	contest_response_async(
		defender,
		name,
		uppertext(challenger_label),
		"ALEA IACTA EST",
		contest_options(),
		CALLBACK(src, PROC_REF(on_contested_roll_response), defender, challenger_pick),
	)

/// Every stake a contest offers: each stat, then custom dice. ContestResponse.tsx draws the custom
/// one by its label.
/proc/contest_options()
	var/list/options = GLOB.rollable_stats.Copy()
	options["Custom Roll"] = "custom"
	return options

/**
	* Turns a chosen option into what a contest side throws: a stat key, or for the custom roll the
	* parsed dice (see `parse_dice_expression()`) the player builds. Null if they back out.
	*/
/mob/living/proc/contest_pick(choice)
	var/stake = contest_options()[choice]
	if(stake != "custom")
		return stake
	return tgui_dice_builder(src, "Xylix's Dice Box", allow_difficulty = FALSE)

/// The stat or dice a side staked, as it reads in chat.
/proc/contest_pick_label(pick)
	return islist(pick) ? dice_expression_string(pick) : pick


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
/mob/living/carbon/human/proc/on_contested_roll_response(mob/living/carbon/human/defender, challenger_pick, response)
	if(!response)
		to_chat(src, span_warning("[defender] declines the contest."))
		return
	if(!hand_games_check(src, defender))
		to_chat(src, span_warning("The contest with [defender] falls through."))
		return

	var/defender_pick = defender.contest_pick(response)
	// Asked for dice and gave none, or took so long the moment passed.
	if(!defender_pick || !hand_games_check(src, defender))
		to_chat(src, span_warning("[defender] declines the contest."))
		return

	var/defender_label = contest_pick_label(defender_pick)
	// Same neutral pairing treatment as the challenge announcement - the coloured half of the pair
	// is resolve_contested_roll()'s result token.
	var/defender_custom = islist(defender_pick)
	defender.announce_roll("retorts with [defender_custom ? "" : "[defender.p_their()] "][stat_span(defender_label, defender_label)]!", "retorts with [defender_custom ? "" : "[defender.p_their()] "][defender_label]")

	resolve_contested_roll(defender, challenger_pick, defender_pick)
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

/**
	* A roll written out as an addition: `13 + 1 + 8 = 22`. Terms are added in the order given. A stat
	* roll reads the stat, then what traits add, then the die, the same order its header is read in.
	* The first term always shows, a term of nothing after it does not, and a negative one is taken
	* away. The total takes the outcome's colour.
	*/
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

/**
	* One side of a contest, thrown: `pick` is a stat key, or parsed dice for a custom roll. Returns
	* `list("faces", "sides", "total", "stat", "header", "terms", "trait_sources")`, `stat` being null for
	* custom dice since they belong to no god.
	*/
/mob/living/proc/contest_throw(pick)
	if(islist(pick))
		var/list/dice_side = throw_dice(pick)
		dice_side["header"] = "<b>[html_encode("[src]")]</b><br>" + dice_side["header"]
		return dice_side

	// The same traits that help or hinder a stat roll count here too.
	var/stat_value = get_stat(resolve_stat_key(pick))
	var/trait_effect = get_roll_trait_effect(pick)
	var/die = rand(1, STAT_ROLL_DIE)
	var/list/faces = list(die)
	return list(
		"faces" = faces,
		"sides" = STAT_ROLL_DIE,
		"total" = stat_value + trait_effect + die,
		"stat" = pick,
		"header" = contest_side_header(src, pick, stat_value, get_roll_trait_sources(pick)),
		"terms" = list(stat_value, trait_effect, die),
		"trait_sources" = get_roll_trait_sources(pick),
		"crit" = natural_crit(faces, STAT_ROLL_DIE),
	)

/// How a critical ranks a side in a contest: above everything, below everything, or not at all.
/proc/contest_crit_rank(crit)
	if(isnull(crit))
		return 0
	return crit ? 1 : -1

/// The note under a contest side's sum if its die was a critical, else nothing.
/proc/contest_crit_footer(list/side)
	if(isnull(side["crit"]))
		return ""
	return crit_footer(side["crit"])

/// Throws for each side, adds what they staked, and announces who came out on top.
/mob/living/proc/resolve_contested_roll(mob/living/defender, challenger_pick, defender_pick)
	var/list/challenger_side = contest_throw(challenger_pick)
	var/list/defender_side = defender.contest_throw(defender_pick)
	var/challenger_total = challenger_side["total"]
	var/defender_total = defender_side["total"]

	// null for a draw - the only genuinely neutral result in a contest.
	var/result = null
	var/verdict = "Neither prevails!"
	// A critical outranks any total: a natural 20 beats everything but another one, and a natural 1
	// loses to everything but another one. Only when both sides rank alike do the totals decide.
	var/challenger_rank = contest_crit_rank(challenger_side["crit"])
	var/defender_rank = contest_crit_rank(defender_side["crit"])
	var/crit = null
	if(challenger_rank != defender_rank)
		result = (challenger_rank > defender_rank)
		// The glow goes to whichever critical decided it, the 20 that won or the 1 that lost.
		crit = (max(challenger_rank, defender_rank) > 0)
	else if(challenger_total != defender_total)
		result = (challenger_total > defender_total)
	if(!isnull(result))
		var/mob/living/winner = result ? src : defender
		verdict = "[winner] [isnull(crit) ? "" : "critically "]prevails!"

	// Both totals are already under each name, and the dice are coloured by who came out ahead. All
	// that is left is naming the traits of anyone who has too many to fit under their name.
	var/list/trait_rows = list()
	var/challenger_breakdown = stat_trait_breakdown(challenger_side["trait_sources"])
	if(challenger_breakdown)
		trait_rows += "<b>[html_encode("[src]")]</b> [challenger_breakdown]"
	var/defender_breakdown = stat_trait_breakdown(defender_side["trait_sources"])
	if(defender_breakdown)
		trait_rows += "<b>[html_encode("[defender]")]</b> [defender_breakdown]"
	var/tooltip = roll_tooltip(result, null, trait_rows)
	var/challenger_outcome = result
	var/defender_outcome = isnull(result) ? null : !result
	var/list/throw_labels = list(challenger_side["header"], defender_side["header"])
	var/list/throw_footers = list(
		roll_sum(challenger_outcome, challenger_side["terms"]) + contest_crit_footer(challenger_side),
		roll_sum(defender_outcome, defender_side["terms"]) + contest_crit_footer(defender_side),
	)
	var/list/throw_sides = list(challenger_side["sides"], defender_side["sides"])
	var/token = roll_dice_token(result, html_encode(verdict), tooltip, list(challenger_side["faces"], defender_side["faces"]), throw_sides, throw_labels, list(challenger_outcome, defender_outcome), list(challenger_side["stat"] || "", defender_side["stat"] || ""), throw_footers, crit)
	announce_roll(token, verdict, show_name = FALSE)

#undef DICE_SYNTAX_HELP
#undef DICE_MAX_COUNT
#undef DICE_MAX_SIDES
#undef DICE_MAX_BONUS
#undef DICE_SUM_MAX_TERMS
#undef DICE_ROLL_COOLDOWN
#undef STAT_ROLL_DIE
#undef CRIT_MAX_ODDS
#undef STAT_CHARISMA
