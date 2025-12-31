/*
	Defines for use in saycode and text formatting.
	Currently contains speech spans and message modes
*/

//Message modes. Each one defines a radio channel, more or less.
#define MODE_HEADSET "headset"
#define MODE_ROBOT "robot"

#define MODE_R_HAND "right hand"
#define MODE_KEY_R_HAND "r"

#define MODE_L_HAND "left hand"
#define MODE_KEY_L_HAND "l"

#define MODE_INTERCOM "intercom"
#define MODE_KEY_INTERCOM "i"

#define MODE_BINARY "binary"
#define MODE_KEY_BINARY "b"
#define MODE_TOKEN_BINARY ":b"

#define MODE_WHISPER "whisper"
#define MODE_WHISPER_CRIT "whispercrit"

#define MODE_SING "%"

#define MODE_DEPARTMENT "department"
#define MODE_KEY_DEPARTMENT "h"
#define MODE_TOKEN_DEPARTMENT ":h"

#define MODE_ADMIN "admin"
#define MODE_KEY_ADMIN "p"

#define MODE_DEADMIN "deadmin"
#define MODE_KEY_DEADMIN "d"

#define MODE_HOLOPAD "holopad"

#define MODE_CHANGELING "changeling"
#define MODE_KEY_CHANGELING "g"
#define MODE_TOKEN_CHANGELING ":g"

#define MODE_VOCALCORDS "cords"
#define MODE_KEY_VOCALCORDS "x"

#define MODE_MONKEY "monkeyhive"

//Spans. Robot speech, italics, etc. Applied in compose_message().
#define SPAN_ROBOT "robot"
#define SPAN_YELL "yell"
#define SPAN_ITALICS "italics"
#define SPAN_SANS "sans"
#define SPAN_PAPYRUS "papyrus"
#define SPAN_REALLYBIG "reallybig"
#define SPAN_COMMAND "command_headset"
#define SPAN_CLOWN "clown"
#define SPAN_SINGING "singing"


#define SPAN_GEN "say"
#define SPAN_ORATOR "orator"
#define SPAN_DWARF "dwarf"
#define SPAN_ELF "elf"
#define SPAN_SAND "sandspeak"
#define SPAN_DELF "delf"
#define SPAN_HELL "hellspeak"
#define SPAN_GRENZELHOFTIAN "grenzelhoftian"
#define SPAN_OTAVAN "otavan"
#define SPAN_ETRUSCAN "etruscan"
#define SPAN_GRONNIC "gronnic"
#define SPAN_BEAST "beast"
#define SPAN_ORC "orc"
#define SPAN_DRACONIC "reptile"
#define SPAN_KAZENGUNESE "kazengunese"
#define SPAN_AAVNIC "aavnic"
#define SPAN_UNDEAD "undead"
#define SPAN_CAT "cat"		 //nyi but file found
#define SPAN_PULSEDEATH "pulsedeath"

#define LANGUAGE_SPANS list(SPAN_GEN,SPAN_ORATOR, SPAN_DWARF, SPAN_ELF, SPAN_SAND, SPAN_DELF, SPAN_HELL, SPAN_GRENZELHOFTIAN, SPAN_OTAVAN, SPAN_ETRUSCAN, SPAN_GRONNIC, SPAN_BEAST, SPAN_ORC, SPAN_DRACONIC, SPAN_KAZENGUNESE, SPAN_AAVNIC, SPAN_UNDEAD, SPAN_CAT, SPAN_PULSEDEATH)

//bitflag #defines for return value of the radio() proc.
#define ITALICS 1
#define REDUCE_RANGE 2
#define NOPASS 4

//Eavesdropping
#define EAVESDROP_EXTRA_RANGE 1 //how much past the specified message_range does the message get starred, whispering only

// A link given to ghost alice to follow bob
#define FOLLOW_LINK(alice, bob) "<a href=?src=[REF(alice)];follow=[REF(bob)]>(F)</a>"
#define TURF_LINK(alice, turfy) "<a href=?src=[REF(alice)];x=[turfy.x];y=[turfy.y];z=[turfy.z]>(T)</a>"
#define FOLLOW_OR_TURF_LINK(alice, bob, turfy) "<a href=?src=[REF(alice)];follow=[REF(bob)];x=[turfy.x];y=[turfy.y];z=[turfy.z]>(F)</a>"

#define LINGHIVE_NONE 0
#define LINGHIVE_OUTSIDER 1
#define LINGHIVE_LING 2
#define LINGHIVE_LINK 3

//Don't set this very much higher then 1024 unless you like inviting people in to dos your server with message spam
#define MAX_MESSAGE_BIGME		4096
#define MAX_MESSAGE_LEN			2048
#define MAX_NAME_LEN			42
#define MAX_BROADCAST_LEN		512
#define MAX_CHARTER_LEN			80

// Is something in the IC chat filter? This is config dependent.
#define CHAT_FILTER_CHECK(T) (config.ic_filter_regex && findtext(T, config.ic_filter_regex))

// Audio/Visual Flags. Used to determine what sense are required to notice a message.
#define MSG_VISUAL (1<<0)
#define MSG_AUDIBLE (1<<1)

/// Removes characters incompatible with file names.
#define SANITIZE_FILENAME(text) (GLOB.filename_forbidden_chars.Replace(text, ""))
/// Simply removes the < and > characters, and limits the length of the message.
#define STRIP_HTML_SIMPLE(text, limit) (GLOB.angular_brackets.Replace(copytext(text, 1, limit), ""))

GLOBAL_LIST_INIT(correct_punctuation, list("!" = TRUE, "." = TRUE, "?" = TRUE, "-" = TRUE, "~" = TRUE, \
											"*" = TRUE, "/" = TRUE, ">" = TRUE, "'" = TRUE, "|" = TRUE, \
											"," = TRUE, ":" = TRUE, ";" = TRUE, "\"" = TRUE, "+" = TRUE))
