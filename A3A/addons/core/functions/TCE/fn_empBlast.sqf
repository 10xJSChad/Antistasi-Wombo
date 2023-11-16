

params ["_unit"];

TCE_fn_getLights = {
	params ["_unit"];
	private _lights  = [];

	{
		if ((lightIsOn _x) in ["ON", "AUTO"]) then {
			_lights pushBack _x;
		};

	} forEach (nearestObjects [_unit, [], 200]) call BIS_fnc_arrayShuffle;

	_lights;
};


TCE_fn_flickerLights = {
	params ["_lights", "_duration", "_endState"];
	
	{
		_x setVariable ["TCE_flickerDuration", _duration];
		_x setVariable ["TCE_flickerEndState", _endState];

		_x spawn {
			private _endState  =  _this getVariable "TCE_flickerEndState";

			if (_endState isEqualTo "RESTORE") then {
				_endState = _this getVariable "TCE_initialLightState";
			};

			sleep random 0.5;
			playSound3D [call TCE_fn_getSparkSound, _this];

			for "_i" from 0 to (_this getVariable "TCE_flickerDuration") do {
				_this switchLight "OFF";
				sleep 0.1;
				_this switchLight "ON";
				sleep 0.1;
			};

			_this switchLight _endState;
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
	private _sounds  = ["a3\sounds_f\sfx\special_sfx\sparkles_wreck_1.wss",
					  "a3\sounds_f\sfx\special_sfx\sparkles_wreck_2.wss",
					  "a3\sounds_f\sfx\special_sfx\sparkles_wreck_3.wss"];

	_sounds call BIS_fnc_selectRandom;
};


TCE_fn_explosionLightSequence = {
	params ["_unit"];

	private _light  = "#lightpoint" createVehicle position _unit;
	_light setPosWorld getPosWorld _unit;

	_light setLightAmbient [0.25,0.5,1];  
	_light setLightColor   [0.25,0.5,1];  
	_light setLightAttenuation [200, 0, 0, 0, 1, 200];
	_light setLightIntensity 0;  

	_light spawn {
		private _intensity  = 0;
		private _attenuation  = 200;

		while { _intensity < 50 } do {
			_this setLightIntensity _intensity;
			_intensity = _intensity + 10;
			sleep 0.01;
		};

		while { _intensity > 0 } do {
			_this setLightIntensity _intensity;
			_intensity = _intensity - 10;
			sleep 0.01;
		};

		while { _attenuation > 0 } do {
			_this setLightAttenuation [200, 0, 0, 0, 1, _attenuation];
			_attenuation = _attenuation - 5;
			sleep 0.01;
		};

		deleteVehicle _this;
	};
};


TCE_fn_getNearbyUnits = {
	params ["_unit"];
	private _nearbyUnits  = [];

	{
		_nearbyUnits pushBack _x;

	} forEach (_unit nearEntities ["Man", 200]);

	_nearbyUnits;
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
	systemChat "Starting EMP sequence" ;


	sleep 1;
	private _lights  = [_unit] call TCE_fn_getLights;
	private _nearbyUnits  = [_unit] call TCE_fn_getNearbyUnits;

	playSound3D ["A3\Sounds_f\sfx\explosion1.wss", _unit, false, getPosASL _unit, 2, 1, 0];
	sleep 0.4;
	_unit call TCE_fn_explosionLightSequence;
	sleep 0.5;
	
	[_nearbyUnits, true] remoteExec ["TCE_fn_setUnitsJammed", 0];
	[_lights] call TCE_fn_storeLightStates;

	[_lights, 1, "ON"] call TCE_fn_flickerLights;
	sleep 1;
	[_lights, 2, "ON"] call TCE_fn_flickerLights;
	sleep 2;
	[_lights, 1, "OFF"] call TCE_fn_flickerLights;
	sleep 1;
	[_lights, 1, "ON"] call TCE_fn_flickerLights;
	sleep 0.5;
	[_lights, 1, "OFF"] call TCE_fn_flickerLights;
	sleep 0.5;
	[_lights, 7, "ON"] call TCE_fn_flickerLights;
	sleep 2;
	[_lights, 1, "OFF"] remoteExec ["TCE_fn_flickerLights", 0];


	sleep 600;
	[_nearbyUnits, false] remoteExec ["TCE_fn_setUnitsJammed", 0];
	[_lights, 1, "RESTORE"] remoteExec ["TCE_fn_flickerLights", 0];
	
};

_unit call TCE_fn_empSequence;