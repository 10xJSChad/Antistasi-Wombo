#export "../../../A3A/addons/core/functions/TCE/fn_empBlast.sqf"
#import "../include.sqf"

params ["_unit"];
#define EMP_RADIUS 200

TCE_fn_getLights = {
	params ["_unit"];
	private lights = [];

	{
		if ((lightIsOn _x) in ["ON", "AUTO"]) then {
			lights pushBack _x;
		};

	} forEach (nearestObjects [_unit, [], EMP_RADIUS]) call BIS_fnc_arrayShuffle;

	lights;
};


TCE_fn_flickerLights = {
	params ["_lights", "_duration", "_endState"];
	
	{
		_x setVariable ["TCE_flickerDuration", _duration];
		_x setVariable ["TCE_flickerEndState", _endState];

		_x spawn {
			private endState =  _this getVariable "TCE_flickerEndState";

			if (endState isEqualTo "RESTORE") then {
				endState = _this getVariable "TCE_initialLightState";
			};

			sleep random 0.5;
			playSound3D [call TCE_fn_getSparkSound, _this];

			for "_i" from 0 to (_this getVariable "TCE_flickerDuration") do {
				_this switchLight "OFF";
				sleep 0.1;
				_this switchLight "ON";
				sleep 0.1;
			};

			_this switchLight endState;
		};
		
	} forEach _lights;
};


TCE_fn_storeLightStates = {
	params ["_lights"];

	{
		_x setVariable ["TCE_initialLightState", lightIsOn _x];
	} forEach _lights;
};


TCE_fn_getSparkSound = {
	private sounds = ["a3\sounds_f\sfx\special_sfx\sparkles_wreck_1.wss",
					  "a3\sounds_f\sfx\special_sfx\sparkles_wreck_2.wss",
					  "a3\sounds_f\sfx\special_sfx\sparkles_wreck_3.wss"];

	sounds call BIS_fnc_selectRandom;
};


TCE_fn_explosionLightSequence = {
	params ["_unit"];

	private light = "#lightpoint" createVehicle position _unit;
	light setPosWorld getPosWorld _unit;

	light setLightAmbient [0.25,0.5,1];  
	light setLightColor   [0.25,0.5,1];  
	light setLightAttenuation [200, 0, 0, 0, 1, 200];
	light setLightIntensity 0;  

	light spawn {
		private intensity = 0;
		private attenuation = 200;

		while { intensity < 50 } do {
			_this setLightIntensity intensity;
			intensity = intensity + 10;
			sleep 0.01;
		};

		while { intensity > 0 } do {
			_this setLightIntensity intensity;
			intensity = intensity - 10;
			sleep 0.01;
		};

		while { attenuation > 0 } do {
			_this setLightAttenuation [200, 0, 0, 0, 1, attenuation];
			attenuation = attenuation - 5;
			sleep 0.01;
		};

		deleteVehicle _this;
	};
};


TCE_fn_getNearbyUnits = {
	params ["_unit"];
	private nearbyUnits = [];

	{
		nearbyUnits pushBack _x;

	} forEach (_unit nearEntities ["Man", EMP_RADIUS]);

	nearbyUnits;
};


TCE_fn_setUnitsJammed = {
	params ["_units", "_state"];
	
	{
		_x setVariable ["TCE_unitJammed", _state];

		if ((_state isEqualTo true) && (side _x in [west, east])) then {
			_x setCombatMode "RED";
			_x setBehaviour "AWARE";
		};

	} forEach _units;
};


TCE_fn_empSequence = {
	params ["_unit"];
	DEBUG_PRINT "Starting EMP sequence";


	sleep 1;
	private lights = [_unit] call TCE_fn_getLights;
	private nearbyUnits = [_unit] call TCE_fn_getNearbyUnits;

	playSound3D ["A3\Sounds_f\sfx\explosion1.wss", _unit, false, getPosASL _unit, 2, 1, 0];
	sleep 0.4;
	_unit call TCE_fn_explosionLightSequence;
	sleep 0.5;
	
	[nearbyUnits, true] remoteExec ["TCE_fn_setUnitsJammed", 0];
	[lights] call TCE_fn_storeLightStates;

	[lights, 1, "ON"] call TCE_fn_flickerLights;
	sleep 1;
	[lights, 2, "ON"] call TCE_fn_flickerLights;
	sleep 2;
	[lights, 1, "OFF"] call TCE_fn_flickerLights;
	sleep 1;
	[lights, 1, "ON"] call TCE_fn_flickerLights;
	sleep 0.5;
	[lights, 1, "OFF"] call TCE_fn_flickerLights;
	sleep 0.5;
	[lights, 7, "ON"] call TCE_fn_flickerLights;
	sleep 2;
	[lights, 1, "OFF"] remoteExec ["TCE_fn_flickerLights", 0];


	sleep 600;
	[nearbyUnits, false] remoteExec ["TCE_fn_setUnitsJammed", 0];
	[lights, 1, "RESTORE"] remoteExec ["TCE_fn_flickerLights", 0];
	
};

_unit call TCE_fn_empSequence;