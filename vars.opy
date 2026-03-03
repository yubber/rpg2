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
globalvar statCosts = []

globalvar goldPlayers
globalvar gold_i

macro startStats = [100,100,100,100,100,0]
macro statHardCaps = [5000000,5000000,5000000,2500,600,5000000,100,1]
macro rebirthCapIncrease = []
macro statStartCaps = []

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

enum QUEST:
	NONE = -1,
	KILL,
	BLOOD,
	BOUNTY,
	GOLD,
	DAMAGE,
	ALTAR,

macro questText = ["kill players", "fill the blood chalice", "kill player", "dig up gold", "damage players", "activate the ancient altar"]
# todo subtext
macro NumQuests = [QUEST.KILL, QUEST.BLOOD, QUEST.GOLD, QUEST.DAMAGE]

playervar questGoal
playervar questProg
playervar questType
macro questRewardScales = [50, 0.15, 25, 0.6, 90]
macro questReward(Player):
	(questRewardScales[Player.questType]
		* Player.questGoal # non num quests set to 1 for completion
		* (2 if Player.guild == GUILD.MERC else 1)
		* MoneyMult(Player))

playervar pkTimer
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