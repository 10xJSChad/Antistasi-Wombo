/*
Author: Seed and ChatGPT
    Updates the player's camo coefficient based on what the player is wearing.

Arguments:
    [unit]

Return Value:
    Nothing

Example:
    Hook it up to the loadout changed event handler in initClient, if you're using CBA.
    ["loadout", {_this execVM QPATHTOFOLDER(functions\Base\fn_updateCamoCoef.sqf);}, true] call CBA_fnc_addPlayerEventHandler;
*/

#include "..\..\script_component.hpp"

params ["_unit"];
if (isNull _unit) exitWith {
    Error("ERROR: updateCamoCoef called with a null unit");
};

private _camoCoef = 0.7; // base camouflage coefficient

// Adjust camo coefficient based on gear
if (vest _unit != "") then {_camoCoef = _camoCoef + 0.15};
if (headgear _unit != "") then {_camoCoef = _camoCoef + 0.05};
if (backpack _unit != "") then {_camoCoef = _camoCoef + 0.20};
if ((uniform _unit in (A3A_faction_civ get "uniforms"))) then {_camoCoef = _camoCoef + 0.20};

// Apply the new camo coefficient to the unit
_unit setUnitTrait ["camouflageCoef", _camoCoef];

// Print new coef
// systemChat format ["Camouflage: %1", _camoCoef];
