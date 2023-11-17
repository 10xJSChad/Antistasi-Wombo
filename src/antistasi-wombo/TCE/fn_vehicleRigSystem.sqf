#export "../../../A3A/addons/core/functions/TCE/fn_vehicleRigSystem.sqf"
#import "../include.sqf"


TCE_explosivesInInv = [];
TCE_explosives = ["IEDLandSmall_Remote_Mag", "IEDUrbanSmall_Remote_Mag", "rhs_ec75_mag", "rhs_ec75_sand_mag", "rhssaf_tm100_mag", "rhsusf_m112_mag",
"DemoCharge_Remote_Mag", "rhs_charge_M2tet_x2_mag", "rhssaf_tm200_mag", "rhs_ec200_mag", "rhs_ec200_sand_mag",
"SatchelCharge_Remote_Mag", "IEDLandBig_Remote_Mag", "IEDUrbanBig_Remote_Mag", "rhsusf_m112x4_mag", "rhs_ec400_mag", "rhs_ec400_sand_mag", "rhssaf_tm500_mag"];


TCE_fn_detonateVehicleBomb = {
	params ["_veh"];
	private explosive = _veh getVariable "TCE_vehicleExplosive";
	private detonated = _veh getVariable "TCE_vehicleDetonated";

	if (isNil "_detonated") then {
		private ammoType = explosive regexReplace ["_.ag", "_ammo"];
		private charge = ammoType createVehicle position _veh;

		if (isNull charge) then {
			systemChat "Failed to create charge, trying default ammo type.";
			charge = "DemoCharge_Remote_Ammo" createVehicle position _veh;
		};

		charge setDamage 1;

		_veh setDamage 1;
		_veh setVariable ["TCE_vehicleDetonated", true];
	};
};


TCE_fn_remoteDetonateVehicleBomb = {
	// addAction param, see TCE_fn_rigVehicle for more info
	private veh = _this[3][0]; 
	private detonateAction = _this[2];
	
	veh call TCE_fn_detonateVehicleBomb;

	player removeAction detonateAction;
	call TCE_fn_updateVehicleActions;
};


TCE_fn_rigVehicle = {
	// dogshit addAction can't take more than one argument
	// these are parameters.
	private veh = _this[3][0];
	private explosive = _this[3][1];

	private vehName = getText (configFile >> "CfgVehicles" >> typeOf veh >> "displayName");
	private vehActions = veh getVariable "TCE_vehicleActions";

	if (!isNil "_vehActions") then {
		{
			veh removeAction _x;
		} forEach vehActions;
	};

	player removeMagazine explosive;

	// You can interrupt this by just entering the vehicle, can't say I care.
	player playMove "MountSide";
	sleep 9;

	private detonateAction = player addAction [format ["Detonate rigged %1", vehName], { call TCE_fn_remoteDetonateVehicleBomb; }, [veh], 5.1, true, true, "", "true", 3];
	veh setVariable ["TCE_vehicleExplosive", explosive];
	veh setVariable ["TCE_vehicleDetonateAction", detonateAction];

	veh addEventHandler ["Killed", {
		params ["_unit", "_killer", "_instigator", "_useEffects"];
		
		private detonateAction = _unit getVariable "TCE_vehicleDetonateAction";
		player removeAction detonateAction;

		_unit call TCE_fn_detonateVehicleBomb;
	}];
};


TCE_fn_isActuallyVehicle = {
	params ["_obj"];
	private vehicleTypes = ["Car", "Tank", "Helicopter", "Plane"];
	private isValidVehicle = false;
	{
		if (_obj isKindOf _x) exitWith {
			isValidVehicle = true;
		};
	} forEach vehicleTypes;

	isValidVehicle;
};


TCE_fn_validForRigging = {
	params ["_veh"];
	private hostilesInside = false;

	{
		if (alive _x && {side _x != side player}) then {
			hostilesInside = true;
		};
	} forEach crew _veh;

	if (_veh call TCE_fn_isActuallyVehicle && {!hostilesInside && {alive _veh && isNil {_veh getVariable "TCE_vehicleExplosive"}}}) exitWith {
		true;
	};
	
	false;
};


TCE_fn_getExplosivesInInv = {
	private explosives = [];
	{
		if (_x in magazines player) then {
			explosives pushBack _x;
		};
	} forEach TCE_explosives;

	explosives;
};


TCE_fn_updateVehicleActions = {
	private explosivesInInv = call TCE_fn_getExplosivesInInv;
	private explosivesChanged = !(explosivesInInv isEqualTo TCE_explosivesInInv);

	{
		private veh = _x;
		private vehActions = veh getVariable "TCE_vehicleActions";
		private vehAlreadyProcessed = !isNil "_vehActions";

		// Just stop if nothing's changed since we last processed this vehicle
		if (vehAlreadyProcessed) then {
			if (explosivesChanged) then {
				TCE_explosivesInInv = explosivesInInv;
			} else {
				break;
			};

			{
				veh removeAction _x;
			} forEach _vehActions;
		};
		
		private actions = [];
		if ((veh call TCE_fn_validForRigging) && {isNull objectParent player}) then {
			{
				private name = getText (configFile >> "CfgMagazines" >> _x >> "DisplayName");
				actions pushBack (veh addAction [format ["Rig with %1", _name], { call TCE_fn_rigVehicle; }, [veh, _x], 5.1, true, true, "", "true", 3]);
			} forEach TCE_explosivesInInv;
			veh setVariable ["TCE_vehicleActions", actions];	
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


call TCE_fn_init;