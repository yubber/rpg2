#!mainFile "main.opy"

enum STATS:
	DMG,
	HP,
	HEAL,
	PROJ,
	SPEED,
	INCOME,
	INTEREST,
	MIN_ULT,
	FLIGHT

globalvar i
# user facing * statmult = actual change
globalvar statMults = [0.2,0.2,0.2,0.2,1,1]
# 0.82
globalvar statPos = [vect(-5.77, 1, 2.2), vect(-6.05, 1, 4.2), vect(-6.27, 1, 6.21), vect(-20.29, 1, 0.41), vect(-20.72, 1, 2.4), vect(-21.15, 1, 4.39), vect(-15.63, 1, 21.54)]
globalvar statCosts = [25, 25, 25, 5, 100, 7, 1000, 5000000]

globalvar goldPlayers
globalvar gold_i
macro goldMined = 10

macro startStats =  		[100,	100, 100,	100,	100,	100,	10,		0,	0]
globalvar statHardCaps =	[50000,50000,50000, 500,	600,	5000000,100,	100,1]
macro rebirthCapIncrease = 	[15000,15000,15000, 0,		0,		10000,	50,		25,	1]
macro startStatCaps =		[20000,20000,20000, 500, 	600, 	10000,	100,	25,	0]

playervar stats
playervar statCaps
macro MoneyMult(Player):
	Player.stats[STATS.INCOME] / 100

macro startingGold = round(5000 * 1.2 ** floor(getTotalTimeElapsed() / 60))
macro diamondValue = floor(getTotalTimeElapsed() / 6)

enum OATH:
	NONE=-1,
	SUMMER,
	AUTUMN,
	WINTER,
	SPRING

enum GUILD:
	ROLLER,
	MERC,
	FARM

playervar guild
macro foragerMult = 2

enum QUEST:
	NONE = -1,
	KILL, # first pvp quest
	BOUNTY,
	DAMAGE, # last pvp quest
	BLOOD,
	GOLD,
	ALTAR # last

# todo subtext
# macro NumQuests = [QUEST.KILL, QUEST.BLOOD, QUEST.GOLD, QUEST.DAMAGE, QUEST.ALTAR]

playervar questGoal
playervar questProg
playervar questType
playervar questRerollLock

globalvar questRewardScales = [30, 150, 0.06, 0.15, 2, 110]
macro questReward(Player):
	round(questRewardScales[Player.questType]
		* (Player.questGoal if Player.questType != QUEST.BOUNTY else 1)
		* (2 if Player.guild == GUILD.MERC else 1)
		* MoneyMult(Player))

playervar pkExpiry
playervar pkBounty
playervar level
playervar cash

playervar bank
macro sliderScalar(Player):
	max(0, min(1, Player.getVerticalFacingAngle() / -40 + 0.5))

macro sliderLength = 1.5
macro baseSliderPos = (localPlayer.getEyePosition() + 3 * normalize(localPlayer.getFacingDirection() * vect(1,0,1)) - (0.6 * Vector.UP))

playervar collide_i # for phasing, shop buy calcs and bank txn calcs
playervar interact_i # for oaths/sins and shop items
playervar detectedShop

playervar oath

playervar currentChalice
playervar bloodscan_i
playervar currentShop

enum SINS:
	PRIDE,
	SLOTH,
	LUST,
	ENVY,
	WRATH,
	USAGI
playervar sins = [false for x in SINS.toArray()]

globalvar antiCrashOn

# shrines
enum SHRINES:
	MOUNTAIN,
	GREED,
	ULT,
	DIAMOND
globalvar shrineOwners = [null,null,null]
globalvar shrineCappers = [null,null,null]
globalvar shrineProgress = [0,0,0]
globalvar shrine_i
globalvar shrineTemp