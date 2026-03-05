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
                "passiveUltGen%": 300
            }
        }
    }
}

macro alignSmallMsg(player, message):
	smallMessage(player, "   {}".format(message))

#!include "vars.opy"
#!include "strings.opy"
#!include "adds.opy"
#!include "poosaytions.opy"

def setStats():
	eventPlayer.setDamageDealt(eventPlayer.stats[STATS.DMG] * statMults[STATS.DMG] * (1.3 if eventPlayer.oath == OATH.SUMMER else 1))
	eventPlayer.setMaxHealth(eventPlayer.stats[STATS.HP] * statMults[STATS.HP])
	eventPlayer.setHealingReceived(eventPlayer.stats[STATS.HEAL] * statMults[STATS.HEAL])
	eventPlayer.setMoveSpeed(200 if eventPlayer.isInSpawnRoom() else (eventPlayer.stats[STATS.SPEED] * statMults[STATS.SPEED]))
	eventPlayer.setProjectileSpeed(eventPlayer.stats[STATS.PROJ] * statMults[STATS.PROJ])
	eventPlayer.setDamageReceived(100)

	if eventPlayer.oath == OATH.AUTUMN:
		eventPlayer.setJumpVerticalSpeed(800)
		eventPlayer.setGravity(500)
	elif eventPlayer.oath == OATH.SUMMER:
		eventPlayer.setDamageReceived(130)

def rerollQuest():
	eventPlayer.questProg = 0

	if eventPlayer.guild == GUILD.MERC:
		if getNumberOfPlayers(Team.ALL) < 2:
			alignSmallMsg(eventPlayer, "failed to get bounty quest: no other players in the lobby.")
			alignSmallMsg(eventPlayer, "you can change your guild in the tavern for a different quest.")
		else:
			eventPlayer.questType = QUEST.BOUNTY
	elif eventPlayer.guild == GUILD.FARM:
		alignSmallMsg(eventPlayer, "you're a forager and can't receive quests.")
		alignSmallMsg(eventPlayer, "you can change your guild in the tavern for quests.")
	else:
		# no altar if player can't access, no pvp if no other players
		eventPlayer.questType = random.randint(QUEST.KILL if getNumberOfPlayers(Team.ALL) > 1 else QUEST.BLOOD, QUEST.ALTAR if eventPlayer.level >= 300 else QUEST.ALTAR - 1)

	switch eventPlayer.questType:
		case QUEST.KILL:
			eventPlayer.questGoal = random.randint(2, 7)
			break
		case QUEST.BOUNTY:
			eventPlayer.questGoal = random.choice(getPlayers(Team.ALL).exclude(eventPlayer))
			break
		case QUEST.DAMAGE:
    		eventPlayer.questGoal = random.randint(500, 1500)
			break
		case QUEST.BLOOD:
			eventPlayer.questGoal = random.randint(eventPlayer.getMaxHealth() * 0.5, eventPlayer.getMaxHealth() * 1)
			break
		case QUEST.GOLD:
			eventPlayer.questGoal = random.randint(10, 75)
			break
		case QUEST.ALTAR:
			eventPlayer.questGoal = 1
			break

	eventPlayer.questRerollLock = getTotalTimeElapsed() + (0.5 if eventPlayer.guild == GUILD.ROLLER else 5)
	playEffect(eventPlayer, DynamicEffect.GOOD_PICKUP_EFFECT, Color.ORANGE, questPos, 2)
	playEffect(eventPlayer, DynamicEffect.BUFF_IMPACT_SOUND, Color.ORANGE, eventPlayer, 30)

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
    hudText(hostPlayer, null,  "peak: {} | average: {}".format(getPeakServerLoad(), getAverageServerLoad()), "server load: {}".format(getServerLoad()), HudPosition.RIGHT, -1, Color.ORANGE, Color.GRAY, Color.GRAY, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.ALWAYS)

	wait(10)
	createDummy(Hero.ROADHOG, Team.ALL, -1, nearestWalkablePosition(Vector.UP), Vector.UP)
	createDummy(Hero.DOMINA, Team.ALL, -1, nearestWalkablePosition(Vector.UP), Vector.UP)
	createDummy(Hero.ZARYA, Team.ALL, -1, nearestWalkablePosition(Vector.UP), Vector.UP)
	createDummy(Hero.ORISA, Team.ALL, -1, nearestWalkablePosition(Vector.UP), Vector.UP)

rule "visuals":
	### player
	hudText(getAllPlayers(), heroIcon(localPlayer.getHero()) if localPlayer.oath == OATH.NONE else oathIcons[localPlayer.oath], f"level {localPlayer.level}", f"{localPlayer.cash} gold", HudPosition.ACTUALLY_LEFT, -1, Color.BLUE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING)

	progressBarHud(localPlayer, 100 * localPlayer.questProg / localPlayer.questGoal,
        "get a quest in the tavern" if localPlayer.questType == QUEST.NONE
        else "{} {}\&fullwidth_space;\&fullwidth_space;reward: {} gold".format(questText[localPlayer.questType], "{} / {}".format(localPlayer.questProg, localPlayer.questGoal) if localPlayer.questType in NumQuests else "{}".format(localPlayer.questGoal), questReward(localPlayer)), HudPosition.TOP, 1, Color.GRAY if localPlayer.questType == -1 else Color.ORANGE, Color.GRAY if localPlayer.questType == -1 else Color.ORANGE, ProgressHudReeval.VISIBILITY_VALUES_AND_COLOR, SpecVisibility.DEFAULT)

	createInWorldText(localPlayer if localPlayer.detectedShop != -1 else null, f"{localPlayer.stats[localPlayer.detectedShop]} / {localPlayer.statCaps[localPlayer.detectedShop]}% {statNames[localPlayer.detectedShop]}", updateEveryFrame(localPlayer.getEyePosition() + localPlayer.getFacingDirection() * 999 + Vector.UP * 99), 1.3, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, statColors[localPlayer.detectedShop])
	createInWorldText(localPlayer if localPlayer.detectedShop != -1 else null, f"{buttonToString(buy1Bind)} buy\n{buttonToString(buyAllBind)} buy maximum", updateEveryFrame(localPlayer.getEyePosition() + localPlayer.getFacingDirection() * 999), 1.3, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.WHITE)

	### world
	# bank
	createInWorldText(getAllPlayers(), "bank", statPos[STATS.INTEREST] + Vector.UP * 4, 3, Clip.SURFACES, WorldTextReeval.VISIBILITY, bankColor)
	createInWorldText(getAllPlayers(), f"balance: {localPlayer.bank} gold", statPos[STATS.INTEREST] + Vector.UP * 3, 1.5, Clip.SURFACES, WorldTextReeval.VISIBILITY_AND_STRING, bankColor)
	for i in range(len(bankPos)):
		# prompt
		createInWorldText(getAllPlayers(), "deposit" if i == 0 else "withdraw", bankPos[i] + Vector.UP * 0.5, 2, Clip.SURFACES, WorldTextReeval.VISIBILITY, bankColor)
		# ring
		createEffect(getAllPlayers(), Effect.RING, bankColor, bankPos[i], bankRad, EffectReeval.VISIBILITY)
		# slider
		createBeam(localPlayer if distance(localPlayer.getPosition(), evalOnce(bankPos[i])) < bankRad else null, Beam.GRAPPLE, baseSliderPos, baseSliderPos + Vector.UP * sliderLength, bankColor, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
		# thumb
		createEffect(localPlayer if distance(localPlayer.getPosition(), evalOnce(bankPos[i])) < bankRad else null, Effect.SPHERE, bankColor,
			baseSliderPos + Vector.UP * (sliderLength * sliderScalar(localPlayer)), 0.06, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
		# 0
		createInWorldText(localPlayer if distance(localPlayer.getPosition(), evalOnce(bankPos[i])) < bankRad else null, 0,
			baseSliderPos - 0.2 * Vector.UP, 1.2, Clip.NONE, WorldTextReeval.VISIBILITY_AND_POSITION, Color.WHITE)
		# max
		createInWorldText(localPlayer if distance(localPlayer.getPosition(), evalOnce(bankPos[i])) < bankRad else null, localPlayer.cash if evalOnce(i == 0) else localPlayer.bank,
			baseSliderPos + Vector.UP * (0.2 + sliderLength), 1.2, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE)
		# current
		createInWorldText(localPlayer if distance(localPlayer.getPosition(), evalOnce(bankPos[i])) < bankRad else null,
			f"{floor(sliderScalar(localPlayer) * (localPlayer.cash if evalOnce(i == 0) else localPlayer.bank))} gold\n{buttonToString(Button.INTERACT)} {'deposit' if evalOnce(i == 0) else 'withdraw'}",
			updateEveryFrame(baseSliderPos + Vector.UP * (sliderLength * sliderScalar(localPlayer) - 0.05)), 1.2, Clip.NONE, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.WHITE)

	# quests
	createEffect(getAllPlayers(), Effect.GOOD_AURA, Color.ORANGE, questPos, 2, EffectReeval.VISIBILITY)
	createInWorldText(getAllPlayers(), barista, questPos, 3, Clip.SURFACES, WorldTextReeval.VISIBILITY)
	createInWorldText(getAllPlayers(), f"{buttonToString(Button.INTERACT)} get a quest" if localPlayer.questRerollLock-1 < getTotalTimeElapsed() else f"reroll cooldown: {localPlayer.questRerollLock-1 - getTotalTimeElapsed()}s", questPos + Vector.UP, 1.2, Clip.SURFACES, WorldTextReeval.VISIBILITY_AND_STRING)
	# gold
	createEffect(getAllPlayers(), Effect.RING, Color.YELLOW, goldPos, goldRadius, EffectReeval.VISIBILITY)
	createEffect(getAllPlayers(), Effect.SPARKLES, Color.YELLOW, goldPos, goldRadius, EffectReeval.VISIBILITY)
	createEffect(getAllPlayers(), Effect.SPARKLES_SOUND, Color.YELLOW, goldPos, goldRadius, EffectReeval.VISIBILITY)
	createInWorldText(getAllPlayers(), "gold mine", goldPos + Vector.UP * 5, 2.5, Clip.SURFACES, WorldTextReeval.VISIBILITY, Color.YELLOW)
	createInWorldText(getAllPlayers(), f"{goldMined} gold /5s\nsplit among miners", goldPos + Vector.UP * 2.5, 1.5, Clip.SURFACES, WorldTextReeval.VISIBILITY)

	# bloods
	for i in range(len(bloodPos)):
		createEffect(getAllPlayers(), Effect.RING, Color.RED, bloodPos[i], bloodRad, EffectReeval.VISIBILITY)
		createEffect(getAllPlayers(), Effect.CLOUD, Color.RED, bloodPos[i], bloodRad, EffectReeval.VISIBILITY)
		createEffect(getAllPlayers(), Effect.ORB, Color.RED, bloodOrb(evalOnce(bloodPos[i])), true, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)

		createInWorldText(getAllPlayers(), "blood chalice", bloodPos[i] + Vector.UP * 2.5, 2.5, Clip.SURFACES, WorldTextReeval.VISIBILITY, Color.RED)
		createInWorldText(getAllPlayers(), f"{bloodDrain[i] * 100}% max hp /s \&right_arrow; {bloodReturn[i]}x sacrifice as gold\nunaffected by income stat", bloodPos[i] + Vector.UP * 1.6, 1, Clip.SURFACES, WorldTextReeval.VISIBILITY, Color.WHITE)
		wait()

	# stats
	for i in range(len(statNames)):
		# shops
		createEffect(getAllPlayers(), Effect.RING, statColors[i], statPos[i], 0.82, EffectReeval.VISIBILITY)
		createInWorldText(getAllPlayers(), statNames[i], statPos[i]+Vector.UP, 1.3, Clip.SURFACES, WorldTextReeval.VISIBILITY, statColors[i])
		createInWorldText(getAllPlayers(), f"{'+1%: ' if statHardCaps[i] != 1 else ''}{statCosts[i]} gold", statPos[i] + Vector.UP * 0.87, 1, Clip.SURFACES, WorldTextReeval.VISIBILITY, Color.WHITE)

		# hud
		if statHardCaps[i] == 1:
			hudSubheader(localPlayer if localPlayer.stats[evalOnce(i)] else null, statNames[i], HudPosition.ACTUALLY_LEFT, i, Color.SKY_BLUE, HudReeval.VISIBILITY)
		else:
			hudSubheader(localPlayer, f"{evalOnce(statNames[i])}: {localPlayer.stats[evalOnce(i)]}%", HudPosition.ACTUALLY_LEFT, i, Color.SKY_BLUE, HudReeval.VISIBILITY_AND_STRING)

		wait()
	# oaths
	for i in range(len(oathNames)):
		createEffect(getAllPlayers(), Effect.RING, oathColors[i], oathPos[i], 1.5, EffectReeval.VISIBILITY)
		createEffect(getAllPlayers(), Effect.SPARKLES, oathColors[i], oathPos[i], 1.5, EffectReeval.VISIBILITY)
		createInWorldText(getAllPlayers(), oathIcons[i], oathPos[i]+Vector.UP * 3, 2, Clip.SURFACES, WorldTextReeval.VISIBILITY, oathColors[i])
		createInWorldText(getAllPlayers(), f"oath of {oathNames[i]}", oathPos[i]+Vector.UP * 2, 2.6, Clip.SURFACES, WorldTextReeval.VISIBILITY, oathColors[i])
		createInWorldText(getAllPlayers(), inspectPrompt if localPlayer.isHoldingButton(Button.CROUCH) == false else f"{evalOnce(oathDescs[i])}\n{buttonToString(Button.INTERACT)} pledge. max 1 oath.", oathPos[i]+Vector.UP, 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_AND_STRING, Color.WHITE)
		wait()
	# sins

	# altar
	createInWorldText(getAllPlayers(), "ancient altar\n", altarPos, 2.3, Clip.SURFACES, WorldTextReeval.VISIBILITY, Color.TURQUOISE)
	createInWorldText(getAllPlayers(), "55 gold for +1-3 to all stats", altarPos, 1.2, Clip.SURFACES, WorldTextReeval.VISIBILITY, Color.WHITE)
	createEffect(getAllPlayers(), Effect.BAD_AURA, Color.TURQUOISE, altarPos, 1.4, EffectReeval.VISIBILITY)

	# phasing
	for i in range(len(phasePos)):
		createInWorldText(localPlayer if distance(localPlayer.getPosition(), evalOnce(phasePos[i])) < 18 else null, abilityIconString(Hero.KIRIKO, Button.ABILITY_1), phasePos[i] + Vector.UP * 1.5, 1.2, Clip.NONE, WorldTextReeval.VISIBILITY, Color.WHITE, SpecVisibility.ALWAYS)
		if phaseLevels[i]:
			createInWorldText(localPlayer if distance(localPlayer.getPosition(), evalOnce(phasePos[i])) < 10 else null, "{} level {}".format(iconString(Icon.CHECKMARK) if localPlayer.level >= evalOnce(phaseLevels[i]) else iconString(Icon.CROSS), evalOnce(phaseLevels[i])), phasePos[i] + Vector.UP, 0.9, Clip.NONE, WorldTextReeval.VISIBILITY_AND_STRING, Color.WHITE, SpecVisibility.ALWAYS)
		wait()

rule "player init":
	@Event eachPlayer
	eventPlayer.disableGamemodeHud()
	eventPlayer.setAllowedHeroes(getAllHeroes())
	wait()
	eventPlayer.stats = startStats
	eventPlayer.statCaps = startStatCaps
	eventPlayer.cash = startingGold
	eventPlayer.oath = OATH.NONE
	eventPlayer.sins = [false for x in SINS.toArray()]
	eventPlayer.currentChalice = -1
	setStats()

	wait()
	# my moni
	createInWorldText(getAllPlayers(), f"level {eventPlayer.level}\n{eventPlayer.cash} gold\n\n", eventPlayer, 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_AND_STRING, Color.YELLOW)

	createInWorldText(getAllPlayers() if eventPlayer.pkExpiry > getTotalTimeElapsed() else null, f"{iconString(Icon.SKULL)} murderer\nbounty: {eventPlayer.pkBounty} gold\n\n\n\n\n", eventPlayer, 1, Clip.SURFACES, WorldTextReeval.VISIBILITY_AND_STRING, Color.RED)

	# blood orb
	createBeam(getAllPlayers() if eventPlayer.currentChalice != -1 and eventPlayer.isAlive() else null, Beam.BAD, eventPlayer, bloodOrb(bloodPos[eventPlayer.currentChalice]), Color.RED, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
### player interactions
# shopping/banking
rule "deposit/withdraw":
	@Event eachPlayer
	@Condition eventPlayer.isHoldingButton(Button.INTERACT)
	@Condition eventPlayer.detectedShop == -1
	@Condition eventPlayer.isInSpawnRoom()
	# *= would be better but stupid rounding
	if distance(eventPlayer.getPosition(), depositPos) < bankRad:
		eventPlayer.collide_i = floor(eventPlayer.cash * sliderScalar(eventPlayer))
		eventPlayer.bank += eventPlayer.collide_i
		eventPlayer.cash -= eventPlayer.collide_i
		alignSmallMsg(eventPlayer, f"withdrew {eventPlayer.collide_i} gold.")
	elif distance(eventPlayer.getPosition(), withdrawPos) < bankRad:
		eventPlayer.collide_i = floor(eventPlayer.bank * sliderScalar(eventPlayer))
		eventPlayer.cash += eventPlayer.collide_i
		eventPlayer.bank -= eventPlayer.collide_i
		alignSmallMsg(eventPlayer, f"deposited {eventPlayer.collide_i} gold.")
	else:
		return
	wait(0.112)
	playEffect(eventPlayer, DynamicEffect.RING_EXPLOSION, bankColor, eventPlayer, bankRad)
	playEffect(eventPlayer, DynamicEffect.RING_EXPLOSION_SOUND, bankColor, eventPlayer.getPosition(), 25)

rule "buy 1":
	@Event eachPlayer
	@Condition eventPlayer.isInSpawnRoom()
	@Condition eventPlayer.detectedShop != -1
	@Condition eventPlayer.isHoldingButton(buy1Bind)
	if eventPlayer.cash < statCosts[eventPlayer.detectedShop]:
		alignSmallMsg(eventPlayer, "out of gold")
		return
	if eventPlayer.stats[eventPlayer.detectedShop] >= eventPlayer.statCaps[eventPlayer.detectedShop]:
		alignSmallMsg(eventPlayer,mammonLure if eventPlayer.stats[eventPlayer.detectedShop] < statHardCaps[eventPlayer.detectedShop] else "reached the limit for this stat.")
		return

	eventPlayer.cash -= statCosts[eventPlayer.detectedShop]
	eventPlayer.stats[eventPlayer.detectedShop]++
	eventPlayer.level++
	playEffect(eventPlayer, DynamicEffect.GOOD_PICKUP_EFFECT, statColors[eventPlayer.detectedShop], statPos[eventPlayer.detectedShop] + Vector.UP, true)
	wait(0.096)
	if eventPlayer.detectedShop and eventPlayer.isHoldingButton(buy1Bind):
		loop()
	else:
		playEffect(eventPlayer, DynamicEffect.BUFF_IMPACT_SOUND, statColors[eventPlayer.detectedShop], eventPlayer, 30)
		setStats()

rule "buy all":
	@Event eachPlayer
	@Condition eventPlayer.isInSpawnRoom()
	@Condition eventPlayer.detectedShop != -1
	@Condition eventPlayer.isHoldingButton(buyAllBind)
	@Condition not eventPlayer.isHoldingButton(buy1Bind)
	eventPlayer.collide_i = min(eventPlayer.statCaps[eventPlayer.detectedShop] - eventPlayer.stats[eventPlayer.detectedShop],\
		floor(eventPlayer.cash / statCosts[eventPlayer.detectedShop]))

	eventPlayer.stats[eventPlayer.detectedShop] += eventPlayer.collide_i
	eventPlayer.cash -= eventPlayer.collide_i * statCosts[eventPlayer.detectedShop]
	eventPlayer.level += eventPlayer.collide_i
	playEffect(eventPlayer, DynamicEffect.BUFF_EXPLOSION_SOUND, statColors[eventPlayer.detectedShop], eventPlayer, 50)
	playEffect(eventPlayer, DynamicEffect.GOOD_EXPLOSION, statColors[eventPlayer.detectedShop], statPos[eventPlayer.detectedShop] + Vector.UP, true)

	if eventPlayer.stats[eventPlayer.detectedShop] == eventPlayer.statCaps[eventPlayer.detectedShop]:
		alignSmallMsg(eventPlayer, mammonLure if eventPlayer.stats[eventPlayer.detectedShop] < statHardCaps[eventPlayer.detectedShop] else "reached the limit for this stat.")
	setStats()
	wait(0.24)

# mines
macro bloodDelay = 0.48
rule "blood chalice":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned()
    @Condition eventPlayer.isAlive()
	@Condition not eventPlayer.isInSpawnRoom()

	# check if not in current chalice or not in any
	if eventPlayer.currentChalice == -1 or distance(eventPlayer.getPosition(), bloodPos[eventPlayer.currentChalice]) > bloodRad[eventPlayer.currentChalice]:
		# scan for chalices if not in chalice
		eventPlayer.currentChalice = -1
		for eventPlayer.bloodscan_i in range(len(bloodPos)):
			if distance(eventPlayer.getPosition(), bloodPos[eventPlayer.bloodscan_i]) < bloodRad[eventPlayer.bloodscan_i]:
				eventPlayer.currentChalice = eventPlayer.bloodscan_i
				break

	if eventPlayer.currentChalice != -1:
		eventPlayer.bloodscan_i = round(bloodDrain[eventPlayer.currentChalice] * eventPlayer.getMaxHealth() * bloodDelay)
		damage(eventPlayer, null, eventPlayer.bloodscan_i)
		eventPlayer.cash += eventPlayer.bloodscan_i * (0.5 if eventPlayer.sins[SINS.LUST] else 1) * (foragerMult if eventPlayer.guild == GUILD.FARM else 1)

		if eventPlayer.questType == QUEST.BLOOD:
			eventPlayer.questProg += eventPlayer.bloodscan_i

	wait(bloodDelay)
	if ruleCondition:
		loop()

rule "gold loop":
	goldPlayers = [x for x in getRealPlayersInRadius(goldPos, goldRadius, Team.ALL, LosCheck.OFF) if not x.sins[SINS.ENVY]]
	alignSmallMsg(goldPlayers, f"dug up {MoneyMult(localPlayer) * goldMined} gold")
	for gold_i in range(len(goldPlayers)):
		goldPlayers[gold_i].cash += MoneyMult(goldPlayers[gold_i]) * goldMined
		if goldPlayers[gold_i].questType == QUEST.GOLD:
			goldPlayers[gold_i].questProg += MoneyMult(goldPlayers[gold_i]) * goldMined
	playEffect(goldPlayers, DynamicEffect.BAD_PICKUP_EFFECT, Color.YELLOW, goldPos, 3)
	playEffect(goldPlayers, DynamicEffect.GOOD_PICKUP_EFFECT, Color.YELLOW, goldPos, 30)
	wait(5)
	loop()
# interacts
macro oathInteractCheck():
	for eventPlayer.interact_i in range(len(oathNames)):
		if distance(eventPlayer.getPosition(), oathPos[eventPlayer.interact_i]) < 1.5:
			# reset oaths
			eventPlayer.setJumpVerticalSpeed(100)
			eventPlayer.setGravity(100)

			if eventPlayer.sins[SINS.PRIDE]:
				alignSmallMsg(eventPlayer, "your pride bellows from inside your heart: the avatars of the seasons are beneath you.")
				goto lbl_0
			elif eventPlayer.oath == eventPlayer.interact_i:
				alignSmallMsg(eventPlayer, f"abandoned your oath.")
				eventPlayer.oath = OATH.NONE
				goto lbl_0
			else:
				switch eventPlayer.interact_i:
					case OATH.SUMMER:
						if eventPlayer.stats[STATS.DMG] < SummerReq:
							alignSmallMsg(eventPlayer, "you need more damage to be worthy of the summer's radiance.")
							goto lbl_0
						break
					case OATH.AUTUMN:
						if eventPlayer.stats[STATS.SPEED] < AutumnReq:
							alignSmallMsg(eventPlayer, "you need more speed to be worthy of the autumn breeze.")
							goto lbl_0
						break
					case OATH.WINTER:
						if eventPlayer.stats[STATS.HP] < WinterReq:
							alignSmallMsg(eventPlayer, "you need more health to be worthy of the winter's chill.")
							goto lbl_0
						break
					case OATH.SPRING:
						if eventPlayer.stats[STATS.HEAL] < SpringReq:
							alignSmallMsg(eventPlayer, "you need more healing received to be worthy of the spring's bounty.")
							goto lbl_0
						break
				alignSmallMsg(eventPlayer, f"swore the oath of {oathNames[eventPlayer.interact_i]}.")
				eventPlayer.oath = eventPlayer.interact_i

			lbl_0:
			setStats()
			break

macro altarInteractCheck():
	if distance(eventPlayer, altarPos) < 2:

		return

rule "outside spawn interacts: oath, sin, altar":
	@Event eachPlayer
	@Condition eventPlayer.isAlive()
	@Condition eventPlayer.isHoldingButton(Button.INTERACT)
	@Condition not eventPlayer.isInSpawnRoom()

	oathInteractCheck()

	altarInteractCheck()

	wait(0.48)

rule "shop detection":
	@Event eachPlayer
	@Condition eventPlayer.hasSpawned()
	@Condition eventPlayer.isInSpawnRoom()
	for eventPlayer.interact_i in range(len(statPos)):
		if distance(eventPlayer.getPosition(), statPos[eventPlayer.interact_i]) < 0.85:
			eventPlayer.detectedShop = eventPlayer.interact_i
			goto lbl_0
		wait()

	eventPlayer.detectedShop = -1

	lbl_0:
	wait(0.08)
	if ruleCondition:
		loop()
# zones
rule "in a spawn":
	@Event eachPlayer
	@Condition eventPlayer.isAlive()
	@Condition eventPlayer.isInSpawnRoom()
	eventPlayer.setDamageDealt(0)
	eventPlayer.setMoveSpeed(200)

	if eventPlayer.pkExpiry > getTotalTimeElapsed():
		alignSmallMsg(eventPlayer, f"{barista} no murderers allowed in the tavern!")
		eventPlayer.applyImpulse(directionTowards(townPos, eventPlayer.getEyePosition()), 20, Relativity.TO_WORLD)
		damage(eventPlayer,null,eventPlayer.getMaxHealth() * 0.4)
		if ruleCondition:
			loop()

	if distance(eventPlayer.getPosition(), townPos) < 20:
		bigMessage(eventPlayer, "welcome to the tavern! (safe zone)")
		eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 99999)

	waitUntil(not eventPlayer.isInSpawnRoom(), 99999)
	bigMessage(eventPlayer, "entered the ruins (pvp enabled)")
	wait(0.24, Wait.RESTART_WHEN_TRUE)
	heal(eventPlayer, null, eventPlayer.getMaxHealth())
	setStats()
	eventPlayer.clearStatusEffect(Status.PHASED_OUT)

rule "phase":
	@Event eachPlayer
	@Condition eventPlayer.isAlive()
	@Condition not eventPlayer.isInSpawnRoom()
	if distance(eventPlayer.getPosition(), phasePos[eventPlayer.collide_i]) < phaseRadii[eventPlayer.collide_i]:
		if eventPlayer.level >= phaseLevels[eventPlayer.collide_i]:
			eventPlayer.disableEnvironmentCollision(false)
			waitUntil(distance(eventPlayer.getPosition(), phasePos[eventPlayer.collide_i]) > phaseRadii[eventPlayer.collide_i] or eventPlayer.getPosition().y < phasePos[eventPlayer.collide_i].y - 0.5, 5)
			eventPlayer.enableEnvironmentCollision()
		else:
			alignSmallMsg(eventPlayer, f"you need to be level {phaseLevels[eventPlayer.collide_i]} to access this area.")
	wait(0.036)
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
	@Condition eventPlayer.detectedShop == -1
	@Condition distance(eventPlayer.getPosition(), questPos) < questRad
	if getTotalTimeElapsed() > eventPlayer.questRerollLock:
		rerollQuest()
		if eventPlayer.questType != QUEST.NONE:
			alignSmallMsg(eventPlayer, f"{barista} {random.choice(questQuips[eventPlayer.questType])}")
	else:
		alignSmallMsg(eventPlayer, f"{iconString(Icon.CROSS)} reroll on cooldown")

rule "quest complete":
	@Event eachPlayer
	@Condition eventPlayer.questProg >= eventPlayer.questGoal
	smallMessage(eventPlayer, f"{barista} good job! quest reward: {questReward(eventPlayer)} gold")
	eventPlayer.cash += questReward(eventPlayer)
	wait()
	eventPlayer.questType = QUEST.NONE
	eventPlayer.questProg = 0

rule "bounty gone":
	@Event eachPlayer
	@Condition eventPlayer.questType == QUEST.BOUNTY
	@Condition not entityExists(eventPlayer.questGoal)
	wait(0.48, Wait.ABORT_WHEN_FALSE)
	alignSmallMsg(eventPlayer, "your bounty left the match. rerolling quest.")
	rerollQuest()

# hero balance
rule "sombruh":
	@Event eachPlayer
	@Condition eventPlayer.getHero() == Hero.SOMBRA or eventPlayer.getHeroOfDuplication() == Hero.SOMBRA
	@Condition eventPlayer.isUsingUltimate()
	eventPlayer.setDamageDealt(100)
	wait(0.8)
	setStats()
# damage procs
rule "dmg quest":
	@Event playerDealtDamage
	@Condition eventPlayer.questType == QUEST.DAMAGE
	eventPlayer.questProg += eventDamage
### world clock stuff
rule "interest":
	@Event eachPlayer
	wait(60)
	eventPlayer.bank += round(eventPlayer.bank * eventPlayer.stats[STATS.INTEREST] / 100)
	loop()
# kills
rule "kill":
	@Event playerDealtFinalBlow
	# steal
	eventPlayer.cash += floor(victim.cash * 0.1)
	alignSmallMsg(eventPlayer, f"stole {floor(victim.cash * 0.1)} gold from victim")
	alignSmallMsg(victim, f"killer looted {floor(victim.cash * 0.1)} gold from you")
	victim.cash = ceil(victim.cash * 0.9)

	# pk reward. penalty handled in death rule
	if victim.pkExpiry > getTotalTimeElapsed():
		eventPlayer.cash += victim.pkBounty
		victim.cash -= victim.pkBounty
		alignSmallMsg(eventPlayer, f"killed a murderer. bounty: {victim.pkBounty}")

	# assign pk
	if victim.pkExpiry < getTotalTimeElapsed() and eventPlayer.questGoal != victim:
		eventPlayer.pkBounty += round(20 * MoneyMult(eventPlayer))
		eventPlayer.pkExpiry = getTotalTimeElapsed() + (60 if eventPlayer.oath == OATH.SPRING else 30)

	# quest
	if eventPlayer.questType == QUEST.KILL:
		eventPlayer.questProg++
	elif eventPlayer.questType == QUEST.BOUNTY and victim == eventPlayer.questGoal:
		eventPlayer.questProg = 1
		eventPlayer.questGoal = 1

	if eventPlayer.questType == QUEST.BOUNTY and victim == eventPlayer.questGoal:
		alignSmallMsg(eventPlayer, f"you killed a player hunting you. + {20*MoneyMult(eventPlayer)} gold")
		eventPlayer.cash += 20*MoneyMult(eventPlayer)

	victim.lastKiller = eventPlayer

rule "ded":
	@Event playerDied
	wait()
	if victim.pkExpiry > getTotalTimeElapsed():
		eventPlayer.cash -= eventPlayer.pkBounty
		alignSmallMsg(eventPlayer, "died as a murderer. penalty: -{} gold".format(eventPlayer.pkBounty))
	eventPlayer.pkBounty = 0
	eventPlayer.pkExpiry = 0

rule "respawn in tavern":
	@Event eachPlayer
	@Condition eventPlayer.hasSpawned()
	@Condition eventPlayer.isAlive()
	@Condition not eventPlayer.isDummy()
	wait()
	eventPlayer.teleport(townPos)
# events
# shrine effects
rule "shrine capturing":
	for shrine_i in range(len(shrineOwners)):
		shrineTemp = getRealPlayersInRadius(shrinePos[shrine_i], 1)
		if len(shrineTemp) == 0:
			shrineProgress[shrine_i] = 0
			shrineOwners[shrine_i] = null
		elif len(shrineTemp) == 1:
			shrineProgress[shrine_i] += 0.18
			shrineOwners[shrine_i] = shrineTemp[0]

	wait(0.36)
	loop()
rule "shrine persistent":
	shrineOwners[SHRINES.ULT].setUltCharge(shrineOwners[SHRINES.ULT].getUltCharge() + 6)
	shrineOwners[SHRINES.GREED].stats[STATS.INCOME] = min(shrineOwners[SHRINES.GREED].stats[STATS.INCOME] + 30, shrineOwners[SHRINES.GREED].statCaps[STATS.INCOME])
	wait(3)
	loop()
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

/**/