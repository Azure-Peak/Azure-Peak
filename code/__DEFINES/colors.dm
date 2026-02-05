// This is eventually for wjohn to add more color standardization stuff like I keep asking him >:(

#define COLOR_INPUT_DISABLED "#000000"
#define COLOR_INPUT_ENABLED "#231d1d"

#define COLOR_DARKMODE_BACKGROUND "#202020"
#define COLOR_DARKMODE_DARKBACKGROUND "#171717"
#define COLOR_DARKMODE_TEXT "#a4bad6"

#define COLOR_WHITE			"#EEEEEE"
#define COLOR_SILVER			 "#C0C0C0"
#define COLOR_GRAY			 "#808080"
#define COLOR_FLOORTILE_GRAY	 "#8D8B8B"
#define COLOR_ALMOST_BLACK		 "#333333"
#define COLOR_BLACK			"#000000"
#define COLOR_RED				"#FF0000"
#define COLOR_RED_LIGHT		"#FF3333"
#define COLOR_MAROON			 "#800000"
#define COLOR_YELLOW			 "#FFFF00"
#define COLOR_OLIVE			"#808000"
#define COLOR_LIME			 "#32CD32"
#define COLOR_GREEN			"#008000"
#define COLOR_CYAN			 "#00FFFF"
#define COLOR_TEAL			 "#008080"
#define COLOR_BLUE			 "#0000FF"
#define COLOR_BLUE_LIGHT		 "#33CCFF"
#define COLOR_NAVY			 "#000080"
#define COLOR_PINK			 "#FFC0CB"
#define COLOR_MAGENTA			"#FF00FF"
#define COLOR_PURPLE			 "#800080"
#define COLOR_ORANGE			 "#FF9900"
#define COLOR_BEIGE			"#CEB689"
#define COLOR_BLUE_GRAY		"#75A2BB"
#define COLOR_BROWN			"#BA9F6D"
#define COLOR_DARK_BROWN		 "#997C4F"
#define COLOR_DARK_ORANGE		"#C3630C"
#define COLOR_GREEN_GRAY		 "#99BB76"
#define COLOR_RED_GRAY		 "#B4696A"
#define COLOR_PALE_BLUE_GRAY	 "#98C5DF"
#define COLOR_PALE_GREEN_GRAY	"#B7D993"
#define COLOR_PALE_RED_GRAY	"#D59998"
#define COLOR_PALE_PURPLE_GRAY "#CBB1CA"
#define COLOR_PURPLE_GRAY		"#AE8CA8"

//Color defines used by the assembly detailer.
#define COLOR_ASSEMBLY_BLACK	 "#545454"
#define COLOR_ASSEMBLY_BGRAY	 "#9497AB"
#define COLOR_ASSEMBLY_WHITE	 "#E2E2E2"
#define COLOR_ASSEMBLY_RED	 "#CC4242"
#define COLOR_ASSEMBLY_ORANGE	"#E39751"
#define COLOR_ASSEMBLY_BEIGE	 "#AF9366"
#define COLOR_ASSEMBLY_BROWN	 "#97670E"
#define COLOR_ASSEMBLY_GOLD	"#AA9100"
#define COLOR_ASSEMBLY_YELLOW	"#CECA2B"
#define COLOR_ASSEMBLY_GURKHA	"#999875"
#define COLOR_ASSEMBLY_LGREEN	"#789876"
#define COLOR_ASSEMBLY_GREEN	 "#44843C"
#define COLOR_ASSEMBLY_LBLUE	 "#5D99BE"
#define COLOR_ASSEMBLY_BLUE	"#38559E"
#define COLOR_ASSEMBLY_PURPLE	"#6F6192"


//roguetown
#define CLOTHING_RED				"#8b2323"
#define CLOTHING_PURPLE				"#8747b1"
#define CLOTHING_BLACK				"#2b292e"
#define CLOTHING_GREY				"#6c6c6c"
#define CLOTHING_BROWN				"#61462c"
#define CLOTHING_GREEN				"#428138"
#define CLOTHING_DARK_GREEN			"#264d26"
#define CLOTHING_BLUE				"#173266"
#define CLOTHING_YELLOW				"#ffcd43"
#define CLOTHING_TEAL				"#249589"
#define CLOTHING_AZURE				"#007fff"
#define CLOTHING_WHITE				"#ffffff"
#define CLOTHING_ORANGE				"#df8405"
#define CLOTHING_MAGENTA			"#962e5c"

//extended dye
#define CLOTHING_BURLAP				"#a09571"
#define CLOTHING_CHALK_WHITE		"#f4ecde"
#define CLOTHING_CHESTNUT			"#613613"
#define CLOTHING_CREAM				"#fffdd0"
#define CLOTHING_DARK_GREY			"#505050"
#define CLOTHING_DIRT				"#7c6d5c"
#define CLOTHING_DUNKED_WATER		"#bbbbbb"
#define CLOTHING_EGGPLANT			"#5d4356"
#define CLOTHING_GOLD				"#f9a602"
#define CLOTHING_GOLD_METALLIC		"#b0955d"
#define CLOTHING_GULF_BLUE			"#7bb6b0"
#define CLOTHING_LIGHT_GREY			"#999999"
#define CLOTHING_MADDER				"#d74c34"
#define CLOTHING_MAGE_BLUE			"#4756d8"
#define CLOTHING_MAGE_GREEN			"#759259"
#define CLOTHING_MAGE_GREY			"#6c6c6c"
#define CLOTHING_MAGE_YELLOW		"#c1b144"
#define CLOTHING_MUDDY_YELLOW		"#b5b004"
#define CLOTHING_MAROON				"#550000"
#define CLOTHING_OLIVE				"#98bf64"
#define CLOTHING_ORCHIL				"#66023c"
#define CLOTHING_PEASANT_BROWN		"#685542"
#define CLOTHING_PERIWINKLE_BLUE	"#8f99fb"
#define CLOTHING_RED_OCHRE			"#913831"
#define CLOTHING_RUSSET				"#7f461b"
#define CLOTHING_SCARLET			"#b8252c"
#define CLOTHING_TAN				"#d6a790"
#define CLOTHING_VIOLET				"#5b2294"
#define CLOTHING_WOAD_BLUE			"#597fb9"
#define CLOTHING_WISTERIA			"#b07bb6"
#define CLOTHING_WINE_RED			"#995264"
#define CLOTHING_YELLOW_OCHRE		"#cb9d06"
#define CLOTHING_YELLOW_WELD		"#f4c430"
#define CLOTHING_YARROW				"#f0cb76"

#define CLOTHING_WET CLOTHING_DUNKED_WATER

/* Core */
#define CLOTHING_COLOR_MAP list(	\
	"Red" = CLOTHING_RED,			\
	"Purple" = CLOTHING_PURPLE,		\
	"Black" = CLOTHING_BLACK,		\
	"Brown" = CLOTHING_BROWN,		\
	"Green" = CLOTHING_GREEN,		\
	"Blue" = CLOTHING_BLUE,			\
	"Yellow" = CLOTHING_YELLOW,		\
	"Teal" = CLOTHING_TEAL,			\
	"Azure" = CLOTHING_AZURE,		\
	"White" = CLOTHING_WHITE,		\
	"Orange" = CLOTHING_ORANGE,		\
	"Magenta" = CLOTHING_MAGENTA	\
)	
/* Extended */
#define EXTENDED_COLOR_MAP list(					\
	"Burlap" = CLOTHING_BURLAP,						\
	"Chalk White" = CLOTHING_CHALK_WHITE,			\
	"Chestnut" = CLOTHING_CHESTNUT,					\
	"Cream" = CLOTHING_CREAM,						\
	"Dark Grey" = CLOTHING_DARK_GREY,				\
	"Dirt" = CLOTHING_DIRT,							\
	"Dunked in Water" = CLOTHING_DUNKED_WATER,		\
	"Eggplant" = CLOTHING_EGGPLANT,					\
	"Gold" = CLOTHING_GOLD,							\
	"Gold Metallic" = CLOTHING_GOLD_METALLIC,		\
	"Gulf Blue" = CLOTHING_GULF_BLUE,				\
	"Light Grey" = CLOTHING_LIGHT_GREY,				\
	"Madder" = CLOTHING_MADDER,						\
	"Mage Blue" = CLOTHING_MAGE_BLUE,				\
	"Mage Green" = CLOTHING_MAGE_GREEN,				\
	"Mage Grey" = CLOTHING_MAGE_GREY,				\
	"Mage Yellow" = CLOTHING_MAGE_YELLOW,			\
	"Muddy Yellow" = CLOTHING_MUDDY_YELLOW,			\
	"Maroon" = CLOTHING_MAROON,						\
	"Olive" = CLOTHING_OLIVE,						\
	"Orchil" = CLOTHING_ORCHIL,						\
	"Peasant Brown" = CLOTHING_PEASANT_BROWN,		\
	"Periwinkle Blue" = CLOTHING_PERIWINKLE_BLUE,	\
	"Red Ochre" = CLOTHING_RED_OCHRE,				\
	"Russet" = CLOTHING_RUSSET,						\
	"Scarlet" = CLOTHING_SCARLET,					\
	"Tan" = CLOTHING_TAN,							\
	"Violet" = CLOTHING_VIOLET,						\
	"Woad Blue" = CLOTHING_WOAD_BLUE,				\
	"Wisteria" = CLOTHING_WISTERIA,					\
	"Wine Red" = CLOTHING_WINE_RED,					\
	"Yellow Ochre" = CLOTHING_YELLOW_OCHRE,			\
	"Yellow Weld" = CLOTHING_YELLOW_WELD,			\
	"Yarrow" = CLOTHING_YARROW						\
)

#define COLOR_MAP (CLOTHING_COLOR_MAP + EXTENDED_COLOR_MAP)
