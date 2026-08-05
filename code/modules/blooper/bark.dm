GLOBAL_LIST_INIT(bark_list, init_bark_list())
GLOBAL_LIST_INIT(bark_random_list, init_random_bark_list())

/proc/init_bark_list()
	. = list()
	for(var/path in subtypesof(/datum/bark))
		var/datum/bark/B = new path()
		.[B.id] = path
		qdel(B)

/proc/init_random_bark_list()
	. = list()
	for(var/path in subtypesof(/datum/bark))
		var/datum/bark/B = new path()
		if(B.allow_random)
			.[B.id] = path
		qdel(B)

//Datums for barks and bark accessories
/datum/bark
	var/name = "None"
	var/id = "None"
	var/soundpath //Path for the actual sound file used for the bark

	// Pitch vars. The actual range for a bark is [(pitch - (maxvariance*0.5)) to (pitch + (maxvariance*0.5))]
	// Make absolutely sure to take variance into account when curating a sound for bark purposes.
	var/minpitch = BARK_DEFAULT_MINPITCH
	var/maxpitch = BARK_DEFAULT_MAXPITCH
	var/minvariance = BARK_DEFAULT_MINVARY
	var/maxvariance = BARK_DEFAULT_MAXVARY

	// Speed vars. Speed determines the number of characters required for each bark, with lower speeds being faster with higher bark density
	var/minspeed = BARK_DEFAULT_MINSPEED
	var/maxspeed = BARK_DEFAULT_MAXSPEED

	// Visibility vars. Regardless of what's set below, these can still be obtained via adminbus and genetics. Rule of fun.
	var/list/ckeys_allowed
	var/ignore = FALSE //Controls whether or not this can be chosen in chargen
	var/allow_random = FALSE //Allows chargen randomization to use this. This is mainly to restrict the pool to sounds that fit well for most characters

/datum/bark/mutedc2
	name = "Muted String (Low)"
	id = "mutedc2"
	soundpath = 'code/modules/blooper/voice/bloopers/misc/guitar_crisis_muted/C2.ogg'
	allow_random = TRUE

/datum/bark/mutedc3
	name = "Muted String (Medium)"
	id = "mutedc3"
	soundpath = 'code/modules/blooper/voice/bloopers/misc/guitar_crisis_muted/C3.ogg'
	allow_random = TRUE

/datum/bark/mutedc4
	name = "Muted String (High)"
	id = "mutedc4"
	soundpath = 'code/modules/blooper/voice/bloopers/misc/guitar_crisis_muted/C4.ogg'
	allow_random = TRUE

/datum/bark/banjoc3
	name = "Banjo (Medium)"
	id = "banjoc3"
	soundpath = 'code/modules/blooper/voice/bloopers/misc/banjo/Cn3.ogg'
	allow_random = TRUE

/datum/bark/banjoc4
	name = "Banjo (High)"
	id = "banjoc4"
	soundpath = 'code/modules/blooper/voice/bloopers/misc/banjo/Cn4.ogg'
	allow_random = TRUE

/datum/bark/squeaky
	name = "Squeaky"
	id = "squeak"
	soundpath = 'code/modules/blooper/voice/bloopers/misc/toysqueak1.ogg'
	maxspeed = 4

/datum/bark/chitter
	name = "Chittery"
	id = "chitter"
	minspeed = 4 //Even with the sound being replaced with a unique, shorter sound, this is still a little too long for higher speeds
	soundpath = 'code/modules/blooper/voice/bloopers/chitter.ogg'

/datum/bark/bullet
	name = "Windy"
	id = "bullet"
	maxpitch = 1.6
	soundpath = 'code/modules/blooper/voice/bloopers/bulletflyby.ogg'

/datum/bark/coggers
	name = "Brassy"
	id = "coggers"
	soundpath = 'code/modules/blooper/voice/bloopers/integration_cog_install.ogg'

/datum/bark/moff/short
	name = "Moff squeak"
	id = "moffsqueak"
	soundpath = 'code/modules/blooper/voice/bloopers/mothsqueak.ogg'
	allow_random = TRUE
	ignore = FALSE

/datum/bark/meow //Meow bark?
	name = "Meow"
	id = "meow"
	allow_random = TRUE
	soundpath = 'code/modules/blooper/voice/bloopers/meow1.ogg'
	minspeed = 5
	maxspeed = 11

/datum/bark/chirp
	name = "Chirp"
	id = "chirp"
	allow_random = TRUE
	soundpath = 'code/modules/blooper/voice/bloopers/chirp.ogg'

/datum/bark/caw
	name = "Caw"
	id = "caw"
	allow_random = TRUE
	soundpath = 'code/modules/blooper/voice/bloopers/caw.ogg'

//Undertale
/datum/bark/alphys
	name = "Alphys"
	id = "alphys"
	soundpath = 'code/modules/blooper/voice/bloopers/undertale/voice_alphys.ogg'
	minvariance = 0

/datum/bark/asgore
	name = "Asgore"
	id = "asgore"
	soundpath = 'code/modules/blooper/voice/bloopers/undertale/voice_asgore.ogg'
	minvariance = 0

/datum/bark/flowey
	name = "Flowey (normal)"
	id = "flowey1"
	soundpath = 'code/modules/blooper/voice/bloopers/undertale/voice_flowey_1.ogg'
	minvariance = 0

/datum/bark/flowey/evil
	name = "Flowey (evil)"
	id = "flowey2"
	soundpath = 'code/modules/blooper/voice/bloopers/undertale/voice_flowey_2.ogg'
	minvariance = 0

/datum/bark/papyrus
	name = "Papyrus"
	id = "papyrus"
	soundpath = 'code/modules/blooper/voice/bloopers/undertale/voice_papyrus.ogg'
	minvariance = 0

/datum/bark/ralsei
	name = "Ralsei"
	id = "ralsei"
	soundpath = 'code/modules/blooper/voice/bloopers/undertale/voice_ralsei.ogg'
	minvariance = 0


/datum/bark/toriel
	name = "Toriel"
	id = "toriel"
	soundpath = 'code/modules/blooper/voice/bloopers/undertale/voice_toriel.ogg'
	minvariance = 0
	maxpitch = BARK_DEFAULT_MAXPITCH*2

/datum/bark/undyne
	name = "Undyne"
	id = "undyne"
	soundpath = 'code/modules/blooper/voice/bloopers/undertale/voice_undyne.ogg'
	minvariance = 0

/datum/bark/temmie
	name = "Temmie"
	id = "temmie"
	soundpath = 'code/modules/blooper/voice/bloopers/undertale/voice_temmie.ogg'
	minvariance = 0

/datum/bark/susie
	name = "Susie"
	id = "susie"
	soundpath = 'code/modules/blooper/voice/bloopers/undertale/voice_susie.ogg'
	minvariance = 0

/datum/bark/gaster
	name = "Gaster"
	id = "gaster"
	soundpath = 'code/modules/blooper/voice/bloopers/undertale/voice_gaster_1.ogg'
	minvariance = 0

/datum/bark/gen_monster
	name = "Generic Monster 1"
	id = "gen_monster_1"
	soundpath = 'code/modules/blooper/voice/bloopers/undertale/voice_monster1.ogg'
	minvariance = 0

/datum/bark/gen_monster/alt
	name = "Generic Monster 2"
	id = "gen_monster_2"
	soundpath = 'code/modules/blooper/voice/bloopers/undertale/voice_monster2.ogg'
	minvariance = 0

/datum/bark/wilson
	name = "Wilson"
	id = "wilson"
	soundpath = 'code/modules/blooper/voice/bloopers/dont_starve/wilson_blooper.ogg'

/datum/bark/wolfgang
	name = "Wolfgang"
	id = "wolfgang"
	soundpath = 'code/modules/blooper/voice/bloopers/dont_starve/wolfgang_blooper.ogg'
	minspeed = 4
	maxspeed = 10

/datum/bark/woodie
	name = "Woodie"
	id = "woodie"
	soundpath = 'code/modules/blooper/voice/bloopers/dont_starve/woodie_blooper.ogg'
	minspeed = 4
	maxspeed = 10

/datum/bark/wurt
	name = "Wurt"
	id = "wurt"
	soundpath = 'code/modules/blooper/voice/bloopers/dont_starve/wurt_blooper.ogg'

/datum/bark/blub
	name = "Blub"
	id = "blub"
	soundpath = 'goon/sound/blub.ogg'

/datum/bark/buwoo
	name = "Buwoo"
	id = "buwoo"
	soundpath = 'goon/sound/buwoo.ogg'

/datum/bark/cow
	name = "Cow"
	id = "cow"
	soundpath = 'goon/sound/cow.ogg'

/datum/bark/lizard
	name = "Lizard"
	id = "lizard"
	soundpath = 'goon/sound/lizard.ogg'

/datum/bark/pug
	name = "Pug"
	id = "pug"
	soundpath = 'goon/sound/pug.ogg'

/datum/bark/pugg
	name = "Pugg"
	id = "pugg"
	soundpath = 'goon/sound/pugg.ogg'

/datum/bark/roach //Turkish characters be like
	name = "Roach"
	id = "roach"
	soundpath = 'goon/sound/roach.ogg'

/datum/bark/skelly
	name = "Skelly"
	id = "skelly"
	soundpath = 'goon/sound/skelly.ogg'

/datum/bark/speak
	name = "Speak 1"
	id = "speak1"
	soundpath = 'goon/sound/speak_1.ogg'

/datum/bark/speak/alt1
	name = "Speak 2"
	id = "speak2"
	soundpath = 'goon/sound/speak_2.ogg'

/datum/bark/speak/alt2
	name = "Speak 3"
	id = "speak3"
	soundpath = 'goon/sound/speak_3.ogg'

/datum/bark/speak/alt3
	name = "Speak 4"
	id = "speak4"
	soundpath = 'goon/sound/speak_4.ogg'

/datum/bark/chitter/alt
	name = "Chittery Alt"
	id = "chitter2"
	soundpath = 'code/modules/blooper/voice/bloopers/moth/mothchitter2.ogg'

// The Mayhem Special
/datum/bark/whistle
	name = "Whistle 1"
	id = "whistle1"
	soundpath = 'code/modules/blooper/voice/bloopers/kazooie/birdwhistle.ogg'

/datum/bark/whistle/alt1
	name = "Whistle 2"
	id = "whistle2"
	soundpath = 'code/modules/blooper/voice/bloopers/kazooie/birdwhistle2.ogg'

/datum/bark/caw/alt1
	name = "Caw 2"
	id = "caw2"
	soundpath = 'code/modules/blooper/voice/bloopers/kazooie/caw.ogg'
	minspeed = 4
	maxspeed = 9

/datum/bark/caw/alt2
	name = "Caw 3"
	id = "caw3"
	soundpath = 'code/modules/blooper/voice/bloopers/kazooie/caw2.ogg'
	minspeed = 3
	maxspeed = 9

/datum/bark/caw/alt3
	name = "Caw 4"
	id = "caw4"
	soundpath = 'code/modules/blooper/voice/bloopers/kazooie/caw3.ogg'
	minspeed = 3
	maxspeed = 9

/datum/bark/ehh
	name = "Ehh 1"
	id = "ehh1"
	soundpath = 'code/modules/blooper/voice/bloopers/kazooie/ehh.ogg'
	minspeed = 3
	maxspeed = 9

/datum/bark/ehh/alt1
	name = "Ehh 2"
	id = "ehh2"
	soundpath = 'code/modules/blooper/voice/bloopers/kazooie/ehh2.ogg'

/datum/bark/ehh/alt2
	name = "Ehh 3"
	id = "ehh3"
	soundpath = 'code/modules/blooper/voice/bloopers/kazooie/ehh3.ogg'

/datum/bark/ehh/alt3
	name = "Ehh 4"
	id = "ehh4"
	soundpath = 'code/modules/blooper/voice/bloopers/kazooie/ehh4.ogg'
	minspeed = 3
	maxspeed = 9

/datum/bark/ehh/alt5
	name = "Ehh 5"
	id = "ehh5"
	soundpath = 'code/modules/blooper/voice/bloopers/kazooie/ehh5.ogg'

/datum/bark/ribbit
	name = "Ribbit"
	id = "ribbit"
	soundpath = 'code/modules/blooper/voice/bloopers/kazooie/ribbit.ogg'

/datum/bark/hoot
	name = "Hoot"
	id = "hoot"
	soundpath = 'code/modules/blooper/voice/bloopers/kazooie/hoot.ogg'
	minspeed = 4
	maxspeed = 9

/datum/bark/tweet
	name = "Tweet"
	id = "tweet"
	soundpath = 'code/modules/blooper/voice/bloopers/kazooie/tweet.ogg'
	
/datum/bark/uhm
	name = "Uhm"
	id = "uhm"
	soundpath = 'code/modules/blooper/voice/bloopers/kazooie/uhm.ogg'

/datum/bark/wurtesh
	name = "Wurtesh"
	id = "wurtesh"
	soundpath = 'code/modules/blooper/voice/bloopers/kazooie/wurble1.ogg'

/datum/bark/chitter2
	name = "Chitter2"
	id = "chitter2"
	soundpath = 'code/modules/blooper/voice/bloopers/kazooie/chitter1.ogg'
