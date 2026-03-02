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
macro statHardCaps = [5000000,5000000,5000000,2500,600,1]
macro statStartCaps = []

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
	KILL,
	BLOOD,
	BOUNTY

playervar questGoal
playervar questProg
playervar questType

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