#!mainFile "main.opy"
# oaths
rule "spring":
	@Event eachPlayer
	@Condition eventPlayer.oath == OATH.SPRING
	@Condition eventPlayer.pkExpiry < getTotalTimeElapsed()
	heal(eventPlayer, null, 10/0.64)
	wait(0.64)
	if ruleCondition:
		loop()

rule "winter":
	@Event eachPlayer
	@Condition eventPlayer.oath == OATH.WINTER
	@Condition eventPlayer.isAlive()
	@Condition eventPlayer.isHoldingButton(Button.CROUCH)
	@Condition eventPlayer.getThrottle() == vect(0,0,0)
	wait(1, Wait.ABORT_WHEN_FALSE)
	playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.AQUA, eventPlayer.getPosition(), 15)
	getRealPlayersInRadius(eventPlayer.getPosition(), 15, Team.ALL, LosCheck.SURFACES_AND_ENEMY_BARRIERS).setStatusEffect(eventPlayer, Status.FROZEN, 5)
	wait(1)
	eventPlayer.clearStatusEffect(Status.FROZEN)
	wait(29, Wait.IGNORE_CONDITION)
	alignSmallMsg(eventPlayer, "oath of winter ability ready")

rule "autumn":
	@Event eachPlayer
	@Condition eventPlayer.oath == OATH.AUTUMN
	@Condition eventPlayer.isJumping()
	eventPlayer.setJumpVerticalSpeed(100)
	wait(AutumnCd)
	if eventPlayer.oath == OATH.AUTUMN:
		eventPlayer.setJumpVerticalSpeed(800)