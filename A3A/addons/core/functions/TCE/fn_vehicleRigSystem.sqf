TCE_explosivesInInv = [];
TCE_explosives = ["IEDLandSmall_Remote_Mag", "IEDUrbanSmall_Remote_Mag", "rhs_ec75_mag", "rhs_ec75_sand_mag", "rhssaf_tm100_mag", "rhsusf_m112_mag",
"DemoCharge_Remote_Mag", "rhs_charge_M2tet_x2_mag", "rhssaf_tm200_mag", "rhs_ec200_mag", "rhs_ec200_sand_mag",
"SatchelCharge_Remote_Mag", "IEDLandBig_Remote_Mag", "IEDUrbanBig_Remote_Mag", "rhsusf_m112x4_mag", "rhs_ec400_mag", "rhs_ec400_sand_mag", "rhssaf_tm500_mag"];


TCE_fn_detonateVehicleBomb = {
	params ["_veh"];
	private _explosive = _veh getVariable "TCE_vehicleExplosive";
	private _detonated = _veh getVariable "TCE_vehicleDetonated";

	if (isNil "_detonated") then {
		private _ammoType = _explosive regexReplace ["_.ag", "_ammo"];
		private _charge = _ammoType createVehicle position _veh;

		if (isNull _charge) then {
			systemChat "Failed to create charge, trying default ammo type.";
			_charge = "DemoCharge_Remote_Ammo" createVehicle position _veh;
		};

		_veh setDamage 1;
		_charge setDamage 1;
		_veh setVariable ["TCE_vehicleDetonated", true];
	};
};


TCE_fn_remoteDetonateVehicleBomb = {
	// addAction param, see TCE_fn_rigVehicle for more info
	private _veh = _this select 3 select 0; 
	private _action = _this select 2;
	
	_veh call TCE_fn_detonateVehicleBomb;

	player removeAction _action;
	call TCE_fn_updateVehicleActions;
};


TCE_fn_rigVehicle = {
	// dogshit addAction can't take more than one argument
	// these are parameters.
	private _veh = _this select 3 select 0;
	private _explosive = _this select 3 select 1;

	private _vehName = getText (configFile >> "CfgVehicles" >> typeOf _veh >> "displayName");
	private _vehActions = _veh getVariable "TCE_vehicleActions";

	if (!isNil "_vehActions") then {
		{
			_veh removeAction _x;
		} forEach _vehActions;
	};

	player removeMagazine _explosive;

	// You can interrupt this by just entering the vehicle, can't say I care.
	player playMove "MountSide";
	sleep 9;

	private _action = player addAction [format ["Detonate rigged %1", _vehName], { call TCE_fn_remoteDetonateVehicleBomb; }, [_veh], 5.1, true, true, "", "true", 3];
	_veh setVariable ["TCE_vehicleExplosive", _explosive];
	_veh setVariable ["TCE_vehicleDetonateAction", _action];

	_veh addEventHandler ["Killed", {
		params ["_unit", "_killer", "_instigator", "_useEffects"];
		
		private _action = _unit getVariable "TCE_vehicleDetonateAction";
		player removeAction _action;

		_unit call TCE_fn_detonateVehicleBomb;
	}];
};


TCE_fn_isActuallyVehicle = {
	params ["_obj"];
	private _vehicleTypes = ["Car", "Tank", "Helicopter", "Plane"];
	private _isValidVehicle = false;
	{
		if (_obj isKindOf _x) exitWith {
			_isValidVehicle = true;
		};
	} forEach _vehicleTypes;

	_isValidVehicle;
};


TCE_fn_validForRigging = {
	params ["_veh"];
	private _crew = crew _veh;
	private _hostilesInside = false;

	{
		if (alive _x && side _x != side player) then {
			_hostilesInside = true;
		};
	} forEach _crew;

	if (_veh call TCE_fn_isActuallyVehicle && !_hostilesInside && alive _veh && isNil {_veh getVariable "TCE_vehicleExplosive"}) exitWith {
		true;
	};
	
	false;
};


TCE_fn_getExplosivesInInv = {
	private _explosives = [];
	{
		if (_x in magazines player) then {
			_explosives pushBack _x;
		};
	} forEach TCE_explosives;

	_explosives;
};


TCE_fn_updateVehicleActions = {
	private _explosivesInInv = call TCE_fn_getExplosivesInInv;
	private _explosivesChanged = !(_explosivesInInv isEqualTo TCE_explosivesInInv);

	{
		private _veh = _x;
		private _vehActions = _veh getVariable "TCE_vehicleActions";
		private _vehAlreadyProcessed = !isNil "_vehActions";

		// Just stop if nothing's changed since we last processed this vehicle
		if (_vehAlreadyProcessed) then {
			if (_explosivesChanged) then {
				TCE_explosivesInInv = _explosivesInInv;
			} else {
				break;
			};

			{
				_veh removeAction _x;
			} forEach _vehActions;
		};
		
		private _actions = [];
		if ((_veh call TCE_fn_validForRigging) && (isNull objectParent player)) then {
			{
				private _name = getText (configFile >> "CfgMagazines" >> _x >> "DisplayName");
				_actions pushBack (_veh addAction [format ["Rig with %1", _name], { call TCE_fn_rigVehicle; }, [_veh, _x], 5.1, true, true, "", "true", 3]);
			} forEach TCE_explosivesInInv;
			_veh setVariable ["TCE_vehicleActions", _actions];	
		};
	} forEach vehicles;
};


TCE_fn_init = {	
	["loadout", { call TCE_fn_updateVehicleActions; }, true] call CBA_fnc_addPlayerEventHandler;
	while { true } do {
		waitUntil { alive player };
		
		// Reset this in case the player respawns and somehow instantly
		// re-aquires the explosives they had before they died.
		TCE_explosivesInInv = [];

		player addEventHandler ["GetInMan", {
			params ["_unit", "_role", "_vehicle", "_turret"];
			_vehicle call TCE_fn_updateVehicleActions;
		}];

		player addEventHandler ["GetOutMan", {
			params ["_unit", "_role", "_vehicle", "_turret", "_isEject"];
			_vehicle call TCE_fn_updateVehicleActions;
		}];

		// I absolutely fucking hate this but whatever, can't be that bad, right?
		while {alive player} do {
			call TCE_fn_updateVehicleActions;
			sleep 3;
		};
	};
};


if (hasInterface) then {
	0 spawn {
		call TCE_fn_init;
	};
};