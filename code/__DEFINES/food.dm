#define MEAT 		(1<<0)
#define VEGETABLES 	(1<<1)
#define RAW 		(1<<2)
#define JUNKFOOD 	(1<<3)
#define GRAIN 		(1<<4)
#define FRUIT 		(1<<5)
#define DAIRY 		(1<<6)
#define FRIED 		(1<<7)
#define ALCOHOL 	(1<<8)
#define SUGAR 		(1<<9)
#define GROSS 		(1<<10)
#define TOXIC 		(1<<11)
#define PINEAPPLE	(1<<12)
#define BREAKFAST	(1<<13)
#define CLOTH 		(1<<14)

#define DRINK_NICE	1
#define DRINK_GOOD	2
#define DRINK_VERYGOOD	3
#define DRINK_FANTASTIC	4
#define FOOD_AMAZING 5

#define FARE_IMPOVERISHED 1
#define FARE_POOR 2
#define FARE_NEUTRAL 3
#define FARE_FINE 4
#define FARE_LAVISH 5

// Consuming an item that meets the minimum quality requirements pop a heart and a mood boost
#define FAVORITE_FOOD_MINFARE FARE_FINE
#define FAVORITE_DRINK_MINQUALITY DRINK_NICE

// Originally, we had a system from Vanderlin with an individual specific Favorite Food and Drink, but it was at once, too broad and too narrow. Hated Food / Drink is a cherry on top and mechanically didn't matter, and favorite food / drink without quality gating is extremely narrow and leans you toward 1 or 3 powergaming options optimistically. The new one gate you to favorite cuisine, favorite dish type and favorite drinks - positive only.

// Cuisines are designed to not be broad universal catch all, so North Imperial (Grenzelhoftian) has a lot of pies and bread and land food, whereas South Imperial exclude most pies but includes seafood and some foreign and elven fare. Northern is Hammerhold + Gronn. Southeastern is Kazengun / Gronn.
#define CUISINE_NORTH_IMPERIAL	(1<<0)
#define CUISINE_SOUTH_IMPERIAL	(1<<1)
#define CUISINE_OTAVAIS			(1<<2)
#define CUISINE_NORTHERN		(1<<3)
#define CUISINE_ETRUSCAN		(1<<4)
#define CUISINE_SOUTHEASTERN	(1<<5)
#define CUISINE_RANESHENI		(1<<6)

// Dish type flags - food only.
#define DISH_MEAT		(1<<0)
#define DISH_POULTRY	(1<<1)
#define DISH_SEAFOOD	(1<<2)
#define DISH_VEGETABLE	(1<<3)
#define DISH_FRUIT		(1<<4)
#define DISH_BREAD		(1<<5)
#define DISH_DAIRY		(1<<6)
#define DISH_PASTRY		(1<<7)
#define DISH_PIE		(1<<8)
#define DISH_SWEET		(1<<9)
#define DISH_EGG		(1<<10)
#define DISH_NOODLES	(1<<11)

// Drink type flags - drink only.
#define DRINKTYPE_WINE		(1<<0)
#define DRINKTYPE_ALE		(1<<1)
#define DRINKTYPE_SPIRIT	(1<<2)
#define DRINKTYPE_MEAD		(1<<3)
#define DRINKTYPE_CIDER		(1<<4)
#define DRINKTYPE_CAFFEINE	(1<<5)
#define DRINKTYPE_JUICE	(1<<6)
#define DRINKTYPE_RICEWINE	(1<<7)
