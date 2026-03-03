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

macro startStats = [100,100,100,100,100,0]
macro statHardCaps = [5000000,5000000,5000000,2500,600,5000000,100,1]
macro rebirthCapIncrease = []
macro statStartCaps = []

macro startingGold = round(5000 * 1.2 ** floor(getTotalTimeElapsed() / 60))
macro diamondValue = floor(getTotalTimeElapsed() / 6)

playervar stats
playervar statCaps

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

macro NumQuests = [QUEST.KILL, QUEST.BLOOD, QUEST.GOLD, QUEST.DAMAGE,]
macro questReward = (
	questRewards[eventPlayer.questType]
	* (2 if eventPlayer.guild == GUILD.MERC else 1)
	* MoneyMult
)

playervar questGoal
playervar questProg
playervar questType

macro questRewards = []

playervar pkTimer
playervar pkBounty
playervar level
playervar cash

playervar bank

playervar collide_i
playervar interact_i

playervar oath

enum SINS:
	PRIDE,
	SLOTH,
	LUST,
	ENVY,
	WRATH,
	USAGI
playervar sins = [false for x in SINS.toArray()]

globalvar antiCrashOn