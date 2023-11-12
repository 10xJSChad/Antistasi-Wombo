#include "..\..\script_component.hpp"
FIX_LINE_NUMBERS()

params ["_markerX"];

//Mission: Liberate Town
if (!isServer and hasInterface) exitWith{};

private _difficultX = random 10 < tierWar;
private _positionX = getMarkerPos _markerX;

private _limit = (60 call SCRT_fnc_misc_getTimeLimit);
_limit params ["_dateLimitNum", "_displayTime"];

private _radiusX = [_markerX] call A3A_fnc_sizeMarker;
private _houses = (nearestObjects [_positionX, ["house"], _radiusX]) select {!((typeOf _x) in A3A_buildingBlacklist)};
private _posHouse = [];
private _houseX = _houses select 0;
while {count _posHouse < 3} do {
	_houseX = selectRandom _houses;
	_posHouse = _houseX buildingPos -1;
	if (count _posHouse < 3) then {_houses = _houses - [_houseX]};
};

private _max = (count _posHouse) - 1;
private _rnd = floor random _max;

private _posAmmobox = _posHouse select _rnd;

private _posGuard1 = _posHouse select (_rnd + 1);
private _posGuard2 = (_houseX buildingExit 0);
private _groupGuards = createGroup Occupants;
private _guardClass = [FactionGet(occ,"unitRifle")] call SCRT_fnc_unit_getTiered;

private _nameDest = [_markerX] call A3A_fnc_localizar;

private _base = [_arrayAirports, _positionX] call BIS_Fnc_nearestPosition;
private _posBase = getMarkerPos _base;

private _guard1 = [_groupGuards, _guardClass, _posGuard1, [], 0, "NONE"] call A3A_fnc_createUnit;
private _guard2 = [_groupGuards, _guardClass, _posGuard2, [], 0, "NONE"] call A3A_fnc_createUnit;
_groupGuards selectLeader _guard1;

private _posTsk = (position _houseX) getPos [random 100, random 360];

private _taskId = "AS" + str A3A_taskCount;
[
	[teamPlayer,civilian],
	_taskID,
	[
		format ["Description: fac: %1, dest: %2, time: %3", FactionGet(occ,"name"), _nameDest, _displayTime],
		"Liberate Town",
		_markerX
	],
	_posTsk,
	false,
	0,
	true,
	"Kill",
	true
] call BIS_fnc_taskCreate;
[_taskId, "AS", "CREATED"] remoteExecCall ["A3A_fnc_taskUpdate", 2];


{[_x,""] call A3A_fnc_NATOinit; _x allowFleeing 0} forEach units _groupGuards;
{_x disableAI "MOVE"; _x setUnitPos "UP"}          forEach units _groupGuards;


// Objective group creation
private _groupX = [_positionX, Occupants, selectRandom (A3A_faction_riv get "groupsFireteam")] call A3A_fnc_spawnGroup;
sleep 1; // Not sure what the purpose of this is.

[_groupX, "Patrol_Area", 25, 50, 100, false, [], false] call A3A_fnc_patrolLoop;
{[_x,""] call A3A_fnc_NATOinit} forEach units _groupX;


// Create ammobox
private _ammoBoxType = A3A_faction_riv get "ammobox";
private _ammoBox = [_ammoBoxType, _posAmmobox, 15, 5, true] call A3A_fnc_safeVehicleSpawn;
_ammoBox addEventHandler ["Killed", { [_this#0] spawn { sleep 10; deleteVehicle (_this#0) } }];
[_ammoBox] spawn A3A_fnc_fillLootCrate;
[_ammoBox] call A3A_Logistics_fnc_addLoadAction;

waitUntil  {
	sleep 1;
	private _activeGroupMembers = (units _groupX) select {_x call A3A_fnc_canFight};
	(dateToNumber date > _dateLimitNum || count _activeGroupMembers == 0)
};

if (dateToNumber date < _dateLimitNum) then {
	[_taskId, "AS", "SUCCEEDED", true] call A3A_fnc_taskSetState;

	[0,300] remoteExec ["A3A_fnc_resourcesFIA",2];
	{
		[300,_x] call A3A_fnc_addMoneyPlayer;
		[15,_x] call A3A_fnc_addScorePlayer;
	} forEach (call SCRT_fnc_misc_getRebelPlayers);

	[5,theBoss] call A3A_fnc_addScorePlayer;
	[200,theBoss, true] call A3A_fnc_addMoneyPlayer;
	[-20 ,20, _markerX] remoteExec ["A3A_fnc_citySupportChange",2];
}
else
{
	[_taskId, "AS", "FAILED", true] call A3A_fnc_taskSetState;
	if (_difficultX) then {[-20,theBoss] call A3A_fnc_addScorePlayer} else {[-10,theBoss] call A3A_fnc_addScorePlayer};
};

sleep 30;

[_taskId, "AS", 1200, true] spawn A3A_fnc_taskDelete;

[_groupX] spawn A3A_fnc_groupDespawner;
[_groupGuards] spawn A3A_fnc_groupDespawner;