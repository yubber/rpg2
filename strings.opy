#!mainFile "main.opy"

macro inspectPrompt = f"{buttonToString(Button.CROUCH)} {iconString(Icon.QUESTION_MARK)}"

macro bartenderquips = [
	"i have no idea why people call this sort of custom game \"minecraft\"",
	"no fighting in the tavern!",
	"what can i get ya?"
]

globalvar statNames = ["damage", "health", "healing received", "projectile speed", "move speed", "income", "interest", "flight"]
globalvar statColors = [Color.RED, Color.GREEN, Color.YELLOW, Color.AQUA, Color.LIME_GREEN, Color.YELLOW, Color.ROSE, Color.WHITE]

globalvar oathNames = ["summer","autumn","winter","spring"]
macro oathDescs = [
	f"you take and deal 30% more damage to players.\nyou must have 300% damage stat.",
	f"1000% jump height, 500% gravity.\njump has a 7s cooldown.\nyou must have 200% speed stat.",
	f"crouch and stay still for 1s:\nfreeze enemies within 15m for 5s and yourself for 1s.\n30s cooldown. you must have 300% hp stat.",
	f"heal 10hp/s if without murderer status.\nmurderer duration doubled.\nyou must have 250% healing stat."
]
globalvar oathIcons = [
	abilityIconString(Hero.ILLARI, Button.ULTIMATE),
	abilityIconString(Hero.ECHO, Button.JUMP),
	abilityIconString(Hero.MEI, Button.ULTIMATE),
	abilityIconString(Hero.LIFEWEAVER, Button.PRIMARY_FIRE)
]
globalvar oathColors = [
	Color.YELLOW,
	Color.LIGHT_RED,
	Color.AQUA,
	Color.LIME_GREEN
]
globalvar guildNames = ["freelancer", "mercenary", "forager"]

globalvar guildDescs = [
	"quest reroll cooldown is 0.5s"
	"quests will only be killing and grant 2x money. reroll cooldown is 5s",
	"cannot receive quests. 2x rewards from world objectives."
]

globalvar sinNames = ["pride", "sloth", "lust", "envy", "wrath", "gluttony"]
globalvar sinDescs = [
	"cannot take oaths. and your barrier size is doubled.",
	"lose 5% ult per second.",
	"every second heal enemies within 30m for 5% of your hp.\nblood chalice income is halved,\nbecause your lust gave you a certain bloodborne disease...",
	"start with debt equal to half of your starting income bonus.\ncan't mine gold if other players are mining.",
	"20% of damage you deal also affects you.",
	"you lose 1% of your upgrades to a random stat on kill."
]

macro rebirthDesc = f"give yourself to sin and i shall reward you.\n- start with +900% income mod per sin.\n- sins are locked in until your next rebirth.\n\n[{buttonToString(Button.CROUCH)}] kneel and be reborn"