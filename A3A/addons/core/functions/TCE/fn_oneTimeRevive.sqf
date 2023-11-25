// One time per life revive function.
params ["_player"];

_player setVariable ["oneTimeRevive",true,true];
_player setVariable ["incapacitated",false,true];
_player setDamage 0.25;

["One Time Revive", "You have used your one-time revive for the current life!"] call A3A_fnc_customHint;
playSound "A3AP_UiSuccess";