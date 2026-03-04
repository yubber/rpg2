#!mainFile "main.opy"

enum STATS:
	DMG,
	HP,
	HEAL,
	PROJ,
	SPEED,
	INCOME,
	INTEREST,
	FLIGHT

globalvar i
# user facing * statmult = actual change
globalvar statMults = [0.2,0.2,0.2,0.2,1,1]
# 0.82
globalvar statPos = [vect(-5.77, 1, 2.2), vect(-6.05, 1, 4.2), vect(-6.27, 1, 6.21), vect(-20.29, 1, 0.41), vect(-20.72, 1, 2.4)]
globalvar statCosts = [25, 25, 25, 5, 100, 7, ]

globalvar goldPlayers
globalvar gold_i
macro goldMined = 25

macro startStats =  		[100,	100,	100,		100,	100,100,	10,0]
macro statHardCaps =		[5000000,5000000,5000000,	2500,	600,5000000,100,1]
macro rebirthCapIncrease = 	[30000, 30000, 30000, 0,	0,		0,	30000,	10,0]
macro startStatCaps =		[10000, 10000, 10000, 2500, 600, 	1,	10000,	50,1]

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
macro NumQuests = [QUEST.KILL, QUEST.BLOOD, QUEST.GOLD, QUEST.DAMAGE, QUEST.ALTAR]

playervar questGoal
playervar questProg
playervar questType
playervar questRerollLock

macro questRewardScales = [30, 50, 0.06, 0.15, 2, 110]
macro questReward(Player):
	round(questRewardScales[Player.questType]
		* Player.questGoal # non num quests set to 1 for completion
		* (2 if Player.guild == GUILD.MERC else 1)
		* MoneyMult(Player))

playervar pkExpiry
playervar pkBounty
playervar level
playervar cash

playervar bank

playervar collide_i
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