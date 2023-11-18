This is a modification of Antistasi intended to be used by myself and whoever I play with. <br>
I do not care if you have problems with it. <br>
Feel free to use it.


Gameplay notes:
* Wombostasi is intended to be played with **BOTH** CUP and RHS!
It won't work well without both, it may not really work at all.
That said, bad things will probably happen if you mix CUP and RHS factions, so configure
your campaign around just one of the mods, but be sure to have both.

* You should play this with people you trust to behave like decent human beings, because
a lot of the default Antistasi behaviour of not trusting players (e.g. non-commander not 
being allowed to withdraw funds) may be removed. I play with a small group, and that's
what this mod is designed for.

* Antistasi does a good job of supporting a large variety of gameplay altering
mods, Wombostasi does not. Play with only CUP, RHS, and CBA you want to have a 
stable experience.

* Don't use ACE.


There are some additional tools present in ./src, this is what they do:
* a3builder: builds addons, linux only.
* preprocessor: preprocesses sqf files, this is separate from and incompatible with <br>
the standard Arma 3 preprocessor. You shouldn't use this unless you're prepared to <br>
rip your hair out, it's very opinionated.

Additionally, src/antistasi-wombo contains the scripts that need to be ran through the <br>
preprocessor, if you change these, you have to run the preprocessor afterwards.


```
Antistasi Wombo Edition
-----------------------

Features:
- Vehicle rigging system
  Rig vehicles with explosives! All (god willing) vanilla + rhs charges can be used to
  turn vehicles into remotely activated boom machines.
  Open the action menu on a vehicle while carrying a charge, select "Rig with $charge",
  then trigger it from anywhere with the "Detonate rigged $vehicle" action.

- "Dynamic" camo system
  Your visibility to enemies now changes depending on what you're wearing,
  civ clothes, backpacks, vests, and helmets will all increase your visibility.
  This will obviously conflict with other camo mods. You can't disable this :).

- EMP
  Call in an EMP via the support menu to kill off all radio communication and light
  near the blast zone, it may or may not be a bit too powerful, but at least you
  won't get mortared immediately, right?
  It has cool visuals.


General Changes:
- Engineer can construct anywhere.

- Losing undercover by offroading too far no longer reports your vehicle.

- Enemies will no longer call in mortar strikes on you in response to 
  squadmates dying if your exact location is unknown.

- Black market temporarily disabled. 
  (might become permanent if a replacement is developed)

- Rivals will no longer call in roving mortars on your HQ or black market.

- Commander no longer loses points when withdrawing money from faction.

- Removed "driver in all your vehicles" fast travel requirement.

- Increased the fast travel valid click radius from 50 to 150 meters.
  This means that you can now click 3x further away from the marker
  than before when fast traveling.


Missions:
- New Mission: "Liberate Town"
  A local warlord has taken over a town, and with the help of corrupt occupier soldiers
  looking to make a quick buck, has started to sell weapons to criminal organizations around
  Altis. Kill the bandits and liberate the town, but feel free to take their weapons cache on
  your way out!

- Completing a 'Kill the Traitor'  mission now lowers the occupant aggression. 
- Completing a 'Kill the Official' mission now lowers the aggression of the target faction.


Templates:
- RHS NAPA:
  - Starting gear:
    - Added a bunch of CUP Takistani vests/uniforms
    - Replaced all starting primaries with a CUP Slamfire Shotgun
    - Replaced all starting secondaries with a Glock 17
    - Other stuff and things.

  - Vehicles:
    - Replaced Offroad with SUV
    - Replaced RHIB with RHIB (but with a gun!)
    - Added Hilux Full Armor Mode
    - Added civ RHIB
    - Added M-900 Helicopter (civ little bird)


Groups:
- Removed chance for Spec Ops and Rival units to spawn as Explosives Experts.
  They just spam landmines while patrolling. If you go afk for a bit while they're 
  active, you're in for a fun time when you discover the minefield they've created.
  It's just annoying.


Altis:
  - Removed Rifleman and Team Leader roles.
```
