settings {
	"main": {
		"description": "that one rpg mode that's everywhere and been remade a million times but you can get bigger number and there's more content and way less bugs and jank\n\nyubz made it",
		"modeName": "\"Minecraft\" expanded"
	},
	"lobby": {
		"allowPlayersInQueue": true,
		"mapRotation": "afterGame",
		"enableMatchVoiceChat": true,
		"spectatorSlots": 12,
		"returnToLobby": "never"
	},
    "gamemodes": {
        "ffa": {
            "enabledMaps": [
                "eichenwalde"
            ],
            "enablePerks": true,
            "perkEliminationCatchupLevelAmount%": 100,
            "scoreToWin": 5000,
            "tankPassiveHealthBonus": "disabled"
        },
        "general": {
            "healthPackRespawnTime%": 60,
            "spawnHealthPacks": "enabled",
            "heroLimit": "off",
            "gamemodeStartTrigger": "immediately"
        }
    },
    "heroes": {
        "allTeams": {
            "mercy": {
                "combatUltGen%": 17,
                "passiveUltGen%": 500,
                "ultGen%": 300
            },
            "zenyatta": {
                "combatUltGen%": 120
            },
            "general": {
                "damageDealt%": 500,
                "healingReceived%": 500,
                "health%": 500,
                "projectileSpeed%": 500,
                "combatUltGen%": 50,
                "passiveUltGen%": 400
            }
        }
    }
}

macro alignSmallMsg(player, message):
	smallMessage(player, "    {}".format(message))

#!include "vars.opy"
#!include "strings.opy"
#!include "adds.opy"
#!include "poosaytions.opy"

macro MoneyMult = eventPlayer.stats[STATS.INCOME] / 100

def setStats():
	eventPlayer.setDamageDealt(eventPlayer.stats[STATS.DMG] * statMults[STATS.DMG])
	eventPlayer.setMaxHealth(eventPlayer.stats[STATS.HP] * statMults[STATS.HP])
	eventPlayer.setHealingReceived(eventPlayer.stats[STATS.HEAL] * statMults[STATS.HEAL])
	eventPlayer.setMoveSpeed(eventPlayer.stats[STATS.SPEED] * statMults[STATS.SPEED])
	eventPlayer.setProjectileSpeed(eventPlayer.stats[STATS.PROJ] * statMults[STATS.PROJ])

rule "init":
	if isAssemblingHeroes():
		setMatchTime(1)
	waitUntil(not isAssemblingHeroes(), 69)
	pauseMatchTime()
	disableGamemodeCompletion()
	disableScoring()

	# debug
	hudText(localPlayer, iconString(Icon.EYE), "eye position", localPlayer.getEyePosition(), HudPosition.ACTUALLY_LEFT, 6969, Color.SKY_BLUE, Color.SKY_BLUE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
	hudText(localPlayer, abilityIconString(Hero.HAMMOND, Button.CROUCH), "player position", localPlayer.getPosition(), HudPosition.ACTUALLY_LEFT, 6969, Color.LIME_GREEN, Color.LIME_GREEN, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
	hudText(localPlayer, abilityIconString(Hero.WIDOWMAKER, Button.ULTIMATE), "facing direction", localPlayer.getFacingDirection(), HudPosition.ACTUALLY_LEFT, 6969, Color.RED, Color.RED, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)

rule "visuals":
	### player
	hudText(getAllPlayers(), heroIcon(localPlayer.getHero()), f"level {localPlayer.level}", f"{localPlayer.cash}{'' if localPlayer.cash == 0 else '00'} gold", HudPosition.ACTUALLY_LEFT, -1)

	progressBarHud(localPlayer, 100 * localPlayer.questProg / localPlayer.questGoal,
        "get a quest in the tavern" if localPlayer.questType == QUEST.NONE
        else " {}{}\&fullwidth_space;\&fullwidth_space;\&fullwidth_space;\&fullwidth_space;reward: {} gold".format(questText[localPlayer.questType], b"{} / {} ".format(localPlayer.questProg, localPlayer.questGoal) if localPlayer.questType in NumQuests else b"{} ".format(localPlayer.questGoal), questReward), HudPosition.TOP, 1, Color.GRAY if localPlayer.questType == -1 else Color.ORANGE, Color.GRAY if localPlayer.questType == -1 else Color.ORANGE, ProgressHudReeval.VISIBILITY_VALUES_AND_COLOR, SpecVisibility.DEFAULT)

	### world
	# gold
	createEffect(getAllPlayers(), Effect.RING, Color.YELLOW, goldPos, goldRadius, EffectReeval.VISIBILITY)
	# bloods
	for i in range(len(bloodPos)):
		createEffect(getAllPlayers(), Effect.RING, Color.RED, bloodPos[i], bloodRad, EffectReeval.VISIBILITY)
		createEffect(getAllPlayers(), Effect.CLOUD, Color.RED, bloodPos[i], bloodRad, EffectReeval.VISIBILITY)
		createEffect(getAllPlayers(), Effect.ORB, Color.RED, evalOnce(bloodPos[i]) + Vector.UP * (2 + sinDeg(getTotalTimeElapsed() * 90)), true, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)

	# stats
	for i in range(len(statNames)):
		# shops
		createEffect(getAllPlayers(), Effect.RING, statColors[i], statPos[i], 0.82, EffectReeval.VISIBILITY)
		createInWorldText(getAllPlayers(), statNames[i], statPos[i]+Vector.UP, 1.3, Clip.SURFACES, WorldTextReeval.VISIBILITY, statColors[i])

		# hud
		if statHardCaps[i] == 1:
			hudSubheader(localPlayer if localPlayer.stats[evalOnce(i)] else null, statNames[i], HudPosition.ACTUALLY_LEFT, i, Color.SKY_BLUE, HudReeval.VISIBILITY)
		else:
			hudSubheader(localPlayer, f"{statNames[i]}: {localPlayer.stats[i]}%", HudPosition.ACTUALLY_LEFT, i, Color.SKY_BLUE, HudReeval.VISIBILITY)

		wait()
	# oaths
	for i in range(len(oathNames)):
		createEffect(getAllPlayers(), Effect.RING, oathColors[i], oathPos[i], 1.5, EffectReeval.VISIBILITY)
		createEffect(getAllPlayers(), Effect.SPARKLES, oathColors[i], oathPos[i], 1.5, EffectReeval.VISIBILITY)
		createInWorldText(getAllPlayers(), oathIcons[i], oathPos[i]+Vector.UP * 3, 2, Clip.SURFACES, WorldTextReeval.VISIBILITY, oathColors[i])
		createInWorldText(getAllPlayers(), f"oath of {oathNames[i]}", oathPos[i]+Vector.UP * 2, 2.5, Clip.SURFACES, WorldTextReeval.VISIBILITY, oathColors[i])
		createInWorldText(getAllPlayers(), inspectPrompt if localPlayer.isHoldingButton(Button.CROUCH) == false else f"{evalOnce(oathDescs[i])}\n\n[{buttonToString(Button.INTERACT)}] pledge", oathPos[i]+Vector.UP, 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_AND_STRING, Color.WHITE)
		wait()
	# sins

	# tp
	for i in range(len(phasePos)):
		createInWorldText(localPlayer if distance(localPlayer.getPosition(), evalOnce(phasePos[i])) < 10 else null, abilityIconString(Hero.KIRIKO, Button.ABILITY_1), phasePos[i] + Vector.UP * 1.5, 1, Clip.NONE, WorldTextReeval.VISIBILITY, Color.WHITE, SpecVisibility.ALWAYS)

rule "player init":
	@Event eachPlayer
	eventPlayer.disableGamemodeHud()
	eventPlayer.setAllowedHeroes(getAllHeroes())
	wait()
	eventPlayer.stats = startStats
	eventPlayer.cash = startingGold
	setStats()
### player interactions
# shop walks
# mines
rule "blood loop":
rule "gold loop":
rule "":
# interacts
rule "oath":
	@Event eachPlayer
	@Condition eventPlayer.isAlive()
	@Condition eventPlayer.isHoldingButton(Button.INTERACT)
	@Condition not eventPlayer.isInSpawnRoom()
	for eventPlayer.interact_i in range(len(oathNames)):
		if distance(eventPlayer.getPosition(), oathPos[eventPlayer.interact_i]) < 1.5:
			if eventPlayer.oath == eventPlayer.interact_i:
				alignSmallMsg(eventPlayer, f"forswore the oath of {oathNames[eventPlayer.oath]}.")
				eventPlayer.oath = OATH.NONE
			else:
				alignSmallMsg(eventPlayer, f"{'swore' if eventPlayer.oath == OATH.NONE else 'switched to'} the oath of {oathNames[eventPlayer.interact_i]}.")
				eventPlayer.oath = eventPlayer.interact_i
			break
	wait(0.48)

rule "shop":
	pass
# zones
rule "in a spawn":
	@Event eachPlayer
	@Condition eventPlayer.isAlive()
	@Condition eventPlayer.isInSpawnRoom()
	eventPlayer.setDamageDealt(0)
	eventPlayer.setMoveSpeed(200)
	if distance(eventPlayer.getPosition(), townPos) < 20:
		bigMessage(eventPlayer, "welcome to the tavern! (safe zone)")

	waitUntil(not eventPlayer.isInSpawnRoom(), 99999)
	bigMessage(eventPlayer, "entered the ruins (pvp enabled)")
	setStats()
	wait(0.12, Wait.RESTART_WHEN_TRUE)
	heal(eventPlayer, null, 70)

rule "phase":
	@Event eachPlayer
	@Condition eventPlayer.isAlive()
	@Condition not eventPlayer.isInSpawnRoom()
	if distance(eventPlayer.getPosition(), phasePos[eventPlayer.collide_i]) < phaseRadii[eventPlayer.collide_i]:
		eventPlayer.disableEnvironmentCollision(false)
		waitUntil(distance(eventPlayer.getPosition(), phasePos[eventPlayer.collide_i]) > phaseRadii[eventPlayer.collide_i] or eventPlayer.getPosition().y < phasePos[eventPlayer.collide_i].y - 0.5, 5)
		eventPlayer.enableEnvironmentCollision()
	wait(0.048)
	eventPlayer.collide_i += 1
	if eventPlayer.collide_i > len(phasePos):
		eventPlayer.collide_i = 0

	if ruleCondition:
		loop()
# questing
rule "reroll quest":
	@Event eachPlayer
	@Condition eventPlayer.isInSpawnRoom()
	@Condition eventPlayer.isHoldingButton(Button.INTERACT)

rule "quest complete":
	@Event eachPlayer
	@Condition eventPlayer.questProg >= eventPlayer.questGoal
	eventPlayer.cash += questReward
	eventPlayer.questType = QUEST.NONE
	eventPlayer.questProg = 0
### world clock stuff
rule "interest":
	@Event eachPlayer
	wait(60)
	eventPlayer.bank += round(eventPlayer.bank * eventPlayer.stats[STATS.INTEREST])
	loop()
# kills
rule "kill":
	@Event playerDealtFinalBlow

	# quest
	if eventPlayer.questType == QUEST.KILL:
		eventPlayer.questProg++
	elif eventPlayer.questType == QUEST.BOUNTY and victim == eventPlayer.questGoal:
		eventPlayer.questGoal = -1

	# steal

	# pk
	if victim.pkBounty > 0:
		eventPlayer.cash += victim.pkBounty

	eventPlayer.pkBounty += round(20 * MoneyMult)
	eventPlayer.pkTimer = 30

rule "ded":
	@Event playerDied
	if eventPlayer.pkBounty > 0:
		eventPlayer.cash -= eventPlayer.pkBounty
		alignSmallMsg(eventPlayer, "murderer penalty: -{} gold".format(eventPlayer.pkBounty))
	eventPlayer.pkBounty = 0
	eventPlayer.pkTimer = 0

rule "respawn in tavern":
	@Event eachPlayer
	@Condition eventPlayer.hasSpawned()
	@Condition eventPlayer.isAlive()
	wait()
	eventPlayer.teleport(townPos)
# events
# misc
rule "anti crash on":
    @Condition not antiCrashOn
    @Condition getServerLoad() > 235
    wait(0.8, Wait.ABORT_WHEN_FALSE)
    setSlowMotion(50)
    # smallMessage(getAllPlayers(), "server load high. anti crash on.")
    antiCrashOn = true

rule "anti crash off":
    @Condition antiCrashOn
    @Condition getServerLoad() < 200
    do:
        wait(0.16, Wait.ABORT_WHEN_FALSE)
        setSlowMotion(100)
        antiCrashOn = false
    while RULE_CONDITION