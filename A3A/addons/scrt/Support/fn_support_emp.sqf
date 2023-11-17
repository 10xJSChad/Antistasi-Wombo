private _positionOrigin = getMarkerPos [supportMarkerOrigin, true];

if (!isNil "petros" && {alive petros}) then {
    petros sideChat "EMP incoming. ETA 30 seconds.";
};

private _timeOut = time + 30;
waitUntil {sleep 1; time > _timeOut };

{
    [petros, "support", "EMP deployed!"] remoteExec ["A3A_fnc_commsMP", _x];
} forEach ([500, _positionOrigin] call SCRT_fnc_common_getNearPlayers);


private _randomizedPosition = [(_positionOrigin select 0), (_positionOrigin select 1), (_positionOrigin select 2)];
private _smokeRound = "Smoke_82mm_AMOS_White" createVehicle _randomizedPosition;

isSupportMarkerPlacingLocked = false;
publicVariable "isSupportMarkerPlacingLocked";

// There's a juuuge sleep here, so let's make sure we're not waiting for it to finish
// before handling the marker.
_smokeRound remoteExec ["A3A_fnc_empBlast", 0];
