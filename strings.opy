#!mainFile "main.opy"

macro barista = heroIcon(Hero.ZENYATTA)
macro inspectPrompt = f"{buttonToString(Button.CROUCH)} {iconString(Icon.QUESTION_MARK)}"

macro questText = ["kill players", "kill player", "damage players", "fill blood chalice", "dig up gold", "activate ancient altar"]
macro questQuips = [
	[
        "wouldn't be an rpg gamemode without murder.",
		"go make some enemies! watching you all sing kumbaya around the gold mine is so boring.",
		"i gotta drive up demand for my stat drinks somehow."
	],[
		"i want that bitch dead. go.",
		"go \"befriend\" that guy's mom",
		"i don't actually know that person, i just want to see you both struggle.",
		"slime this guy out"
	],[
        "i'm bored, go shoot some people so i can watch the catfight.",
        "you better not ask to farm damage like a coward",
        "i love me some violence.",
        "peace is overrated. this isn't a \&black_heart;chill friendly vc ekitten\&black_heart; lobby."
	],[
		"sometimes i wonder how those vampires got so much gold.",
		"how else do you think i make the beer that gives you max health?",
		"i love those things. helps me sell health and healing."
	],[
		"go dig up some gold. if you find a phone in there do not open the photos!!!",
		"there's lots of gold in that car wreck.",
		"don't bother looting the car's catalytic converter. i already sold it."
	],[
		"remember to have enough gold on hand to use it.",
		"i don't like how that thing's giving out stats like candy. it's hurting my business."
	]
]

globalvar statNames = ["damage", "health", "healing received", "projectile speed", "move speed", "income", "interest", "flight"]
globalvar statColors = [Color.RED, Color.GREEN, Color.YELLOW, Color.AQUA, Color.LIME_GREEN, Color.YELLOW, Color.ROSE, Color.WHITE]

globalvar oathNames = ["summer","autumn","winter","spring"]
macro oathDescs = [
	f"you take and deal 30% more damage to players.\n\nyou must have 300% damage stat.",
	f"800% jump height (7s cooldown), 500% gravity.\n\nyou must have 150% speed stat.",
	f"crouch and stay still for 1s:\nfreeze enemies within 15m for 5s and yourself for 1s.\n\n30s cooldown. you must have 300% hp stat.",
	f"heal 10hp/s if without murderer status.\nmurderer duration doubled.\n\nyou must have 250% healing stat."
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
	"quest reroll cooldown is 0.5s. good way to learn the game's mechanics."
	"quests will only be bounty targets and grant 2x money. reroll cooldown is 5s",
	f"cannot receive quests. {foragerMult}x rewards from world objectives."
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