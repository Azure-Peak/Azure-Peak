/datum/flesh_concept
	var/name = "base concept"
	var/list/tier_questions = alist() // Questions for each tier (1-4)
	var/list/answer_keywords = list() // Keywords accepted in answers across all tiers

/datum/flesh_concept/pain
	name = "pain"
	tier_questions = alist(
		1 = list("Hurt? Oww?", "Bad feel?", "Ouch?"),
		2 = list("What is pain?", "Why we hurt?", "Pain good?"),
		3 = list("Does suffering have purpose?", "Is pain a teacher?", "How does pain change us?"),
		4 = list("What truths does agony reveal?", "Is suffering necessary for growth?", "How does pain shape consciousness?")
	)
	answer_keywords = list("hurt", "pain", "suffering", "agony", "ache", "torment", "anguish")

/datum/flesh_concept/blood
	name = "blood"
	tier_questions = alist(
		1 = list("Red wet?", "Life juice?", "Bleed?"),
		2 = list("What is blood?", "Why blood red?", "Blood life?"),
		3 = list("Does blood carry memory?", "Is blood sacred?", "What flows in veins?"),
		4 = list("What ancestral knowledge flows in blood?", "Is blood the river of lineage?", "Does blood remember what the mind forgets?")
	)
	answer_keywords = list("blood", "bleed", "veins", "life", "red", "flow", "sacrifice")

/datum/flesh_concept/fear
	name = "fear"
	tier_questions = alist(
		1 = list("Scary?", "Run hide?", "Bad thing?"),
		2 = list("What is fear?", "Fear good?", "Why afraid?"),
		3 = list("Does fear protect or imprison?", "What lies beneath terror?", "Is fear a warning?"),
		4 = list("What truths does dread unveil?", "Is fear the shadow of survival?", "Does terror reveal hidden realities?")
	)
	answer_keywords = list("fear", "scared", "afraid", "terror", "dread", "panic", "anxiety")

/datum/flesh_concept/hunger
	name = "hunger"
	tier_questions = alist(
		1 = list("Want food?", "Empty tummy?", "Eat now?"),
		2 = list("What is hunger?", "Why we need food?", "Hunger pain?"),
		3 = list("Is hunger more than physical?", "What do we truly crave?", "Does hunger drive creation?"),
		4 = list("What existential void does hunger represent?", "Is craving flesh the engine of being?", "What hungers drive us?")
	)
	answer_keywords = list("hunger", "food", "eat", "crave", "starve", "appetite", "desire")

/datum/flesh_concept/love
	name = "love"
	tier_questions = alist(
		1 = list("Good feel?", "Warm inside?", "Like person?"),
		2 = list("What is love?", "Why love hurt?", "Love good?"),
		3 = list("Is love a binding force?", "Does love transform?", "What sacrifices does love demand?"),
		4 = list("Do we truly require love, or is it inner deceit?", "Is love the fabric binding souls?", "What divine madness is love?")
	)
	answer_keywords = list("love", "care", "affection", "devotion", "passion", "connection", "bond")

/datum/flesh_concept/death
	name = "death"
	tier_questions = alist(
		1 = list("No more?", "Gone away?", "Sleep forever?"),
		2 = list("What is death?", "After death?", "Why die?"),
		3 = list("Is death an ending or transformation?", "What awaits beyond the veil?", "Does death give life meaning?"),
		4 = list("What mysteries lie in the great silence?", "Is death the final teacher?", "What rebirth follows dissolution?")
	)
	answer_keywords = list("death", "die", "dead", "end", "afterlife", "mortality", "rebirth")

/datum/flesh_concept/time
	name = "time"
	tier_questions = alist(
		1 = list("Now when?", "Before after?", "Day night?"),
		2 = list("What is time?", "Time flow?", "Can stop time?"),
		3 = list("Does time heal or erode?", "Is the past alive in us?", "What is the weight of moments?"),
		4 = list("What eternal now contains all of time?", "Is memory time's anchor?", "What dances in the spaces between moments?")
	)
	answer_keywords = list("time", "past", "future", "now", "moment", "memory", "eternity")

/datum/flesh_concept/dreams
	name = "dreams"
	tier_questions = alist(
		1 = list("Sleep pictures?", "Night stories?", "Not real?"),
		2 = list("What are dreams?", "Dreams real?", "Why dream?"),
		3 = list("Do dreams show hidden truths?", "What world exists behind closed eyes?", "Are we different in dreams?"),
		4 = list("What realms do sleeping minds wander?", "Do dreams connect collective unconscious?", "What prophecies sleep in dreamscapes?")
	)
	answer_keywords = list("dream", "sleep", "vision", "nightmare", "unconscious", "fantasy", "prophecy")

/datum/flesh_concept/memory
	name = "memory"
	tier_questions = alist(
		1 = list("Remember thing?", "Before now?", "Old picture?"),
		2 = list("What is memory?", "Why forget?", "Memory true?"),
		3 = list("Do memories shape reality?", "What is forgotten but still felt?", "Are we our memories?"),
		4 = list("What echoes linger in ancestral memory?", "Do memories exist outside time?", "What truths do forgotten things hold?")
	)
	answer_keywords = list("memory", "remember", "forget", "past", "recall", "nostalgia", "echo")

/datum/flesh_concept/truth
	name = "truth"
	tier_questions = alist(
		1 = list("Real thing?", "Not lie?", "True true?"),
		2 = list("What is truth?", "Truth hurt?", "Always truth?"),
		3 = list("Are there multiple truths?", "What lies hide behind facts?", "Does truth change?"),
		4 = list("What absolute reality underlies apparent truth?", "Is truth subjective experience?", "What remains when all lies are stripped away?")
	)
	answer_keywords = list("truth", "real", "true", "fact", "honest", "reality", "authentic")

/datum/flesh_concept/lies
	name = "lies"
	tier_questions = alist(
		1 = list("Not true?", "Make believe?", "False story?"),
		2 = list("What are lies?", "Why lie?", "Lies bad?"),
		3 = list("Do lies protect or harm?", "What truth hides in deception?", "Are some lies necessary?"),
		4 = list("What fundamental deceptions shape reality?", "Do lies create new truths?", "What hides behind the veil of falsehood?")
	)
	answer_keywords = list("lie", "false", "deceive", "illusion", "trick", "untrue", "fiction")

/datum/flesh_concept/power
	name = "power"
	tier_questions = alist(
		1 = list("Strong?", "Make do?", "Boss?"),
		2 = list("What is power?", "Get power how?", "Power good?"),
		3 = list("Does power corrupt or reveal?", "What is true strength?", "Can power be shared?"),
		4 = list("What cosmic forces manifest as power?", "Is power responsibility or freedom?", "What ultimate authority governs existence?")
	)
	answer_keywords = list("power", "strong", "control", "authority", "dominance", "influence", "might")

/datum/flesh_concept/weakness
	name = "weakness"
	tier_questions = alist(
		1 = list("Not strong?", "Can't do?", "Small?"),
		2 = list("What is weakness?", "Weakness bad?", "Help weak?"),
		3 = list("Is vulnerability strength?", "What grows from limitation?", "Does weakness teach compassion?"),
		4 = list("What profound truths emerge from fragility?", "Is surrender sometimes victory?", "What power resides in acceptance?")
	)
	answer_keywords = list("weak", "vulnerable", "fragile", "helpless", "limited", "frail", "dependent")

/datum/flesh_concept/creation
	name = "creation"
	tier_questions = alist(
		1 = list("Make new?", "Build thing?", "From nothing?"),
		2 = list("What is creation?", "Why create?", "Create how?"),
		3 = list("Does creation require destruction?", "What spark begins making?", "Is all art born of pain?"),
		4 = list("What divine impulse drives creation?", "Does the universe dream through makers?", "What emerges from the void of potential?")
	)
	answer_keywords = list("create", "make", "build", "form", "art", "invent", "generate")

/datum/flesh_concept/destruction
	name = "destruction"
	tier_questions = alist(
		1 = list("Break thing?", "No more?", "Smash?"),
		2 = list("What is destruction?", "Why destroy?", "Destroy good?"),
		3 = list("Does destruction make space for creation?", "What beauty exists in ruin?", "Is ending necessary?"),
		4 = list("What cosmic cycle requires dissolution?", "Does destruction reveal essential forms?", "Must all be ended for us to begin anew?")
	)
	answer_keywords = list("destroy", "break", "ruin", "end", "demolish", "shatter", "obliterate")

/datum/flesh_concept/order
	name = "order"
	tier_questions = alist(
		1 = list("Things neat?", "Place for thing?", "Not messy?"),
		2 = list("What is order?", "Why order good?", "Make order?"),
		3 = list("Does order limit or protect?", "What patterns govern reality?", "Is chaos the enemy of order?"),
		4 = list("What cosmic structures maintain existence?", "Does order emerge from chaos?", "What divine mathematics govern all thing?")
	)
	answer_keywords = list("order", "pattern", "system", "structure", "arrange", "organize", "method")

/datum/flesh_concept/chaos
	name = "chaos"
	tier_questions = alist(
		1 = list("All messy?", "No pattern?", "Things random?"),
		2 = list("What is chaos?", "Chaos bad?", "Why chaos?"),
		3 = list("Does chaos create freedom?", "What order emerges from randomness?", "Is chaos the source of novelty?"),
		4 = list("What infinite possibilities dwell in disorder?", "Does chaos birth new realities?", "What dances in the space between laws?")
	)
	answer_keywords = list("chaos", "random", "disorder", "confusion", "unpredictable", "entropy", "anarchy")

/datum/flesh_concept/beauty
	name = "beauty"
	tier_questions = alist(
		1 = list("Pretty thing?", "Nice see?", "Good look?"),
		2 = list("What is beauty?", "Why beautiful?", "Beauty where?"),
		3 = list("Is beauty subjective or universal?", "What makes something beautiful?", "Does beauty require imperfection?"),
		4 = list("What divine harmony manifests as beauty?", "Does beauty reveal truths?", "What eternal forms underlie apparent beauty?")
	)
	answer_keywords = list("beauty", "beautiful", "pretty", "lovely", "aesthetic", "harmony", "grace")

/datum/flesh_concept/ugliness
	name = "ugliness"
	tier_questions = alist(
		1 = list("Not pretty?", "Bad look?", "Wrong shape?"),
		2 = list("What is ugly?", "Why ugly?", "Ugly bad?"),
		3 = list("Does ugliness have its own beauty?", "What truths hide in unpleasant forms?", "Is ugliness necessary?"),
		4 = list("What profound realities manifest as ugliness?", "Does horror contain its own awe?", "What sacred truths wear masks of disgust?")
	)
	answer_keywords = list("ugly", "unpleasant", "grotesque", "hideous", "repulsive", "disfigured", "monstrous")

/datum/flesh_concept/sacrifice
	name = "sacrifice"
	tier_questions = alist(
		1 = list("Give up?", "Lose for other?", "Hurt for good?"),
		2 = list("What is sacrifice?", "Why sacrifice?", "Sacrifice worth?"),
		3 = list("Does sacrifice create meaning?", "What transformations require offering?", "Is loss necessary for gain?"),
		4 = list("What exchanges demand sacrifice?", "Does giving away create abundance?", "What divine economy governs offering?")
	)
	answer_keywords = list("sacrifice", "offer", "give", "lose", "surrender", "offerings", "devotion")

/datum/flesh_concept/greed
	name = "greed"
	tier_questions = alist(
		1 = list("Want more?", "Not share?", "All mine?"),
		2 = list("What is greed?", "Why greedy?", "Greed good?"),
		3 = list("Does greed drive progress?", "What emptiness creates wanting?", "Is accumulation a form of poverty?"),
		4 = list("What existential lack manifests as greed?", "Does infinite desire create finite beings?", "What void do possessions attempt to fill?")
	)
	answer_keywords = list("greed", "want", "desire", "possess", "accumulate", "hoard", "covet")

/datum/flesh_concept/justice
	name = "justice"
	tier_questions = alist(
		1 = list("Fair thing?", "Good get good?", "Bad get bad?"),
		2 = list("What is justice?", "Justice fair?", "Make justice?"),
		3 = list("Is justice absolute or relative?", "Does vengeance serve justice?", "Can mercy be just?"),
		4 = list("What balance manifests as justice?", "Does universal law require equilibrium?", "What scales measure deeds?")
	)
	answer_keywords = list("justice", "fair", "right", "law", "balance", "equity", "retribution")

/datum/flesh_concept/mercy
	name = "mercy"
	tier_questions = alist(
		1 = list("Not punish?", "Forgive?", "Be kind?"),
		2 = list("What is mercy?", "Why mercy?", "Mercy weak?"),
		3 = list("Is mercy strength or weakness?", "What healing comes from forgiveness?", "Does mercy transform both given and receiver?"),
		4 = list("What grace manifests as mercy?", "Does compassion transcend justice?", "What kindness flows through existence?")
	)
	answer_keywords = list("mercy", "forgive", "compassion", "kindness", "pity", "clemency", "grace")

/datum/flesh_concept/loneliness
	name = "loneliness"
	tier_questions = alist(
		1 = list("All alone?", "No friend?", "Empty inside?"),
		2 = list("What is loneliness?", "Why lonely?", "Loneliness hurt?"),
		3 = list("Is solitude different from loneliness?", "What connections alleviate isolation?", "Does loneliness reveal our need for others?"),
		4 = list("What existential separation creates loneliness?", "Does the soul yearn for connection?", "What divine unity do we remember in isolation?")
	)
	answer_keywords = list("lonely", "alone", "isolated", "solitude", "abandoned", "empty", "separation")

/datum/flesh_concept/companionship
	name = "companionship"
	tier_questions = alist(
		1 = list("With other?", "Not alone?", "Friend?"),
		2 = list("What is companionship?", "Why together?", "Alone bad?"),
		3 = list("Does connection define identity?", "What bonds transform individuals?", "Is companionship necessary for growth?"),
		4 = list("If nothing is alive, can one still achieve companionship?", "Do souls recognize each other?", "What communion exists between beings?")
	)
	answer_keywords = list("companion", "friend", "together", "bond", "connection", "relationship", "unity")

/datum/flesh_concept/hope
	name = "hope"
	tier_questions = alist(
		1 = list("Maybe good?", "Think better?", "Not give up?"),
		2 = list("What is hope?", "Why hope?", "Hope help?"),
		3 = list("Does hope create reality?", "What sustains hope in darkness?", "Is hope a choice or feeling?"),
		4 = list("What potential manifests as hope?", "Does hope glimpse future possibilities?", "What promise fuels expectation?")
	)
	answer_keywords = list("hope", "optimism", "expect", "faith", "belief", "anticipation", "possibility")

/datum/flesh_concept/despair
	name = "despair"
	tier_questions = alist(
		1 = list("No hope?", "All bad?", "Give up?"),
		2 = list("What is despair?", "Why despair?", "Despair end?"),
		3 = list("Does despair reveal truth?", "What growth comes from hopelessness?", "Is despair a necessary depth?"),
		4 = list("What existential truths manifest as despair?", "Does the abyss gaze back?", "What revelations come from absolute surrender?")
	)
	answer_keywords = list("despair", "hopeless", "desperate", "defeat", "sorrow", "anguish", "misery")

/datum/flesh_concept/courage
	name = "courage"
	tier_questions = alist(
		1 = list("Not scared?", "Do anyway?", "Be brave?"),
		2 = list("What is courage?", "Why brave?", "Courage good?"),
		3 = list("Does courage require fear?", "What actions define bravery?", "Is courage a choice or quality?"),
		4 = list("What strength manifests as courage?", "Does valor transcend self-preservation?", "What overcomes terror?")
	)
	answer_keywords = list("courage", "brave", "fearless", "bold", "valor", "heroism", "fortitude")

/datum/flesh_concept/cowardice
	name = "cowardice"
	tier_questions = alist(
		1 = list("Too scared?", "Run away?", "Not do?"),
		2 = list("What is cowardice?", "Why coward?", "Coward bad?"),
		3 = list("Does cowardice preserve life?", "What wisdom hides in caution?", "Is fear sometimes wise?"),
		4 = list("What survival instinct manifests as cowardice?", "Does prudence disguise as fear?", "What feeling guides retreat?")
	)
	answer_keywords = list("coward", "fearful", "timid", "afraid", "hesitant", "retreat", "caution")

/datum/flesh_concept/wisdom
	name = "wisdom"
	tier_questions = alist(
		1 = list("Know things?", "Smart?", "Understand?"),
		2 = list("What is wisdom?", "Get wisdom?", "Wise good?"),
		3 = list("Does wisdom come from experience?", "Can wisdom be taught?", "Is wisdom different from knowledge?"),
		4 = list("What understanding manifests as wisdom?", "Does truth resonate through ages?", "What eternal patterns do sages perceive?")
	)
	answer_keywords = list("wisdom", "wise", "knowledge", "understanding", "insight", "enlightenment", "sagacity")

/datum/flesh_concept/ignorance
	name = "ignorance"
	tier_questions = alist(
		1 = list("Not know?", "Dumb?", "No understand?"),
		2 = list("What is ignorance?", "Why ignorant?", "Ignorance bad?"),
		3 = list("Does ignorance protect or limit?", "What freedoms come from not knowing?", "Is some ignorance bliss?"),
		4 = list("What necessary veils manifest as ignorance?", "Does unknowing create space for wonder?", "What mysteries require not knowing?")
	)
	answer_keywords = list("ignorance", "ignore", "unknowing", "unaware", "naive", "innocent", "uninformed")

/datum/flesh_concept/freedom
	name = "freedom"
	tier_questions = alist(
		1 = list("Do anything?", "No rules?", "Free?"),
		2 = list("What is freedom?", "Why free?", "Freedom good?"),
		3 = list("Does freedom require responsibility?", "Can one be free alone?", "Is absolute freedom possible?"),
		4 = list("What liberation manifests as freedom?", "Does the soul yearn for unbounded existence?", "What divine autonomy underlies being?")
	)
	answer_keywords = list("freedom", "free", "liberty", "autonomy", "independence", "unbound", "release")

/datum/flesh_concept/bondage
	name = "bondage"
	tier_questions = alist(
		1 = list("Not free?", "Trapped?", "Can't move?"),
		2 = list("What is bondage?", "Why trapped?", "Bondage bad?"),
		3 = list("Do limitations create meaning?", "What freedoms exist within constraints?", "Are all beings bound in some way?"),
		4 = list("What necessary structures manifest as bondage?", "Does form require limitation?", "What divine laws bind existence?")
	)
	answer_keywords = list("bondage", "bound", "trapped", "restricted", "prison", "captive", "constrained")

/datum/flesh_concept/growth
	name = "growth"
	tier_questions = alist(
		1 = list("Get bigger?", "Change good?", "Learn more?"),
		2 = list("What is growth?", "Why grow?", "Grow how?"),
		3 = list("Does growth require discomfort?", "What transformations are necessary?", "Can growth be forced?"),
		4 = list("What evolution manifests as growth?", "Does being unfold through becoming?", "What divine potential seeks expression?")
	)
	answer_keywords = list("growth", "grow", "develop", "evolve", "mature", "progress", "transform")

/datum/flesh_concept/decay
	name = "decay"
	tier_questions = alist(
		1 = list("Get old?", "Break down?", "Not work?"),
		2 = list("What is Pestra?", "Why Pestra?", "Pestra bad?"),
		3 = list("Does Pestra's decay make space for new life?", "What beauty exists in deterioration?", "Is ending part of cycles?"),
		4 = list("What is Pestra's greatest gift?", "Does Pestra's dissolution serve renewal?", "What ancient patterns does Pestra require return to source?")
	)
	answer_keywords = list("decay", "rot", "decompose", "deteriorate", "wither", "fade", "corrupt", "pestra")

/datum/flesh_concept/transformation
	name = "transformation"
	tier_questions = alist(
		1 = list("Change thing?", "Become different?", "Not same?"),
		2 = list("What is transformation?", "Why change?", "Transform how?"),
		3 = list("Does transformation require destruction?", "What remains constant through change?", "Are we the same after transformation?"),
		4 = list("What metamorphosis manifests as change?", "Does being dance between forms?", "What eternal essence wears temporary shapes?")
	)
	answer_keywords = list("transform", "change", "become", "metamorphosis", "evolve", "shift", "alter")

/datum/flesh_concept/identity
	name = "identity"
	tier_questions = alist(
		1 = list("Who me?", "I am?", "Self?"),
		2 = list("What is identity?", "Why self?", "Identity change?"),
		3 = list("Are we our memories or actions?", "What defines personhood?", "Does identity exist independently?"),
		4 = list("What eternal self manifests as identity?", "Does consciousness wear temporary masks?", "What divine spark animates being?")
	)
	answer_keywords = list("identity", "self", "who", "person", "individual", "essence", "soul")

/datum/flesh_concept/unity
	name = "unity"
	tier_questions = alist(
		1 = list("All one?", "Together same?", "Not separate?"),
		2 = list("What is unity?", "Why together?", "Unity good?"),
		3 = list("Does unity require diversity?", "What connects all things?", "Can individuality exist in unity?"),
		4 = list("What oneness manifests as unity?", "Can seperation be kept from bringing destruction?", "What divine whole contains all parts?")
	)
	answer_keywords = list("unity", "one", "together", "whole", "united", "connected", "harmony")
