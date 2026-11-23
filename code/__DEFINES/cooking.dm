#define FOOD_CAT_COMBINATION "Combination"
#define FOOD_CAT_CAKES "Cakes"
#define FOOD_CAT_BAKED "Baked Goods"
#define FOOD_CAT_RICE "Rice Meals"
#define FOOD_CAT_SANDWICH "Sandwiches"
#define FOOD_CAT_EGGS "Eggs"
#define FOOD_CAT_SEAFOOD "Seafood"
#define FOOD_CAT_DRYING "Drying Rack"
#define FOOD_CAT_STEW "Stew"
#define FOOD_CAT_DEEPFRIED "Deep Fried"
#define FOOD_CAT_BOILED "Boiled"
#define FOOD_CAT_PIES "Pies"
#define FOOD_CAT_BASICS "Basic Ingredients"
#define FOOD_CAT_DOUGHS "Doughs"
#define FOOD_CAT_PRESERVED "Cured & Preserved"
#define FOOD_CAT_DRIED_FRUIT "Dried Fruit"
#define FOOD_CAT_SUGARWORK "Sugarwork"
#define FOOD_CAT_GENERIC "Generic Cooking"
#define FOOD_CAT_OVEN "Oven"
#define FOOD_CAT_PAN "Pan"
#define FOOD_CAT_SMOKED "Smoker"
#define FOOD_CAT_BREWS "Tea & Brews"
#define FOOD_CAT_BLENDS "Blends"

#define COOKSTEP_TOOL "tool"
#define COOKSTEP_SHARP "sharp"
#define COOK_BAKE "bake"
#define COOK_FRY "fry"
#define COOK_DEEPFRY "deepfry"
#define COOK_BOIL "boil"
#define COOK_SMOKE "smoke"

#define STEW_WATER_REQUIRED 30
#define STEW_TEMPERATURE 374

#define JUICE_YIELD 25
#define MORTAR_MAX_ITEMS 4

#define BILL_OF_FARE_MAX_FOOD 15
#define BILL_OF_FARE_MAX_DRINK 15
#define BILL_OF_FARE_MAX_PRICE 999
#define BILL_OF_FARE_TITLE_LEN 42
#define BILL_OF_FARE_LINE_LEN 42
#define BILL_OF_FARE_NOTES_LEN 300
#define BILL_OF_FARE_PEN_NAME_LEN 32
#define BILL_OF_FARE_NAME_TITLE_LEN 24
#define BILL_OF_FARE_SIGN_NAME "name"
#define BILL_OF_FARE_SIGN_JOB "job"
#define BILL_OF_FARE_SIGN_PEN "pen"
#define BILL_OF_FARE_NOTES_MAX_LINES 10
#define BILL_OF_FARE_EXPORT_HEADER "Bill of fare 1"
#define BILL_OF_FARE_IMPORT_MAX_LEN 8000
#define BILL_OF_FARE_IMPORT_FIELD_LEN 200
#define BILL_OF_FARE_IMPORT_PRICE_DIGITS 4
#define BILL_OF_FARE_CARRIAGE_RETURN ascii2text(13)
#define BILL_OF_FARE_IMPORT_REPORT_NAMES 5
#define BILL_OF_FARE_IMPORT_MAX_LINES (2 + BILL_OF_FARE_MAX_FOOD + BILL_OF_FARE_MAX_DRINK + BILL_OF_FARE_NOTES_MAX_LINES + 8)
#define BILL_OF_FARE_IMPORT_COOLDOWN (10 SECONDS)
#define BILL_OF_FARE_PICKER_ROWS 60
#define BILL_OF_FARE_CUP_ICON 'modular/Neu_Food/icons/cookware/cup.dmi'
#define BILL_OF_FARE_CUP_STATE "wooden"
#define BILL_OF_FARE_CUP_FILL_STATE "wooden_filling"

#define BILL_OF_FARE_COLUMNS list( \
	/datum/bill_of_fare_column/food, \
	/datum/bill_of_fare_column/drink, \
)

#define BILL_OF_FARE_DRINK_BASES list( \
	/datum/reagent/consumable/ethanol, \
	/datum/reagent/consumable/juice, \
	/datum/reagent/consumable/virgin_drink, \
	/datum/reagent/consumable/brew, \
	/datum/reagent/consumable/caffeine, \
)

#define BILL_OF_FARE_DRINK_EXACT list( \
	/datum/reagent/consumable/milk, \
	/datum/reagent/water, \
	/datum/reagent/consumable/rosewater, \
	/datum/reagent/consumable/rosewater_spiced, \
	/datum/reagent/consumable/chocolate, \
	/datum/reagent/consumable/spiced_chocolate, \
	/datum/reagent/consumable/golden_calendula_tea, \
	/datum/reagent/consumable/soothing_valerian_tea, \
	/datum/reagent/consumable/azurosa_tea, \
	/datum/reagent/consumable/maizewash, \
)
