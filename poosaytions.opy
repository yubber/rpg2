#!mainFile "main.opy"

macro townPos = vect(-14.5, 3, 13.4)

macro goldPos = vect(24.73, 4.8, -55)
macro goldRadius = 6

globalvar phasePos = [vect(-12.17, 1.1, -6.46), vect(-25.1, 1.05, -0.21), vect(27.77, 8.3, -87), vect(34.93, 5, -63.4)]
globalvar phaseRadii = [1.6, 1.2, 1.21, 2.74]
globalvar phaseLevels = [0,0,300,300]

globalvar brawlPos = [vect(12.04, 5.8, -71.9)]
globalvar brawlRadii = [9]

macro darkPos = vect(88.15, 12.67, -67.38)
macro darkRad = 3.4

macro diamondPos = vect(1.74, 5, -97)
macro diamondRad = 4

globalvar bloodPos = [vect(-3.58, 2, -37.9),vect(56.52, 21, -68.29)]
globalvar bloodRad = [4,4.84]
globalvar bloodDrain = [10/100,25/100,50/100]
globalvar bloodReturn = [1.5, 1, 0.7]

macro bloodOrb(origin):
	origin + Vector.UP * (2 + sinDeg(getTotalTimeElapsed() * 90))

macro foragePos = vect(19.9, 1, -4.4)
macro forageRad = 5.6

globalvar oathPos = [vect(53.11, 6.5, -60.8), vect(75, 10.5, -118.3), vect(60.3, 4.7, -94.5), vect(104, 12.7, -72.8)]