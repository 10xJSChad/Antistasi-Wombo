#export "../../../A3A/addons/core/functions/FactoryOverhaul/fn_productionActionMenu.sqf"
#import "../include.sqf"


#define DEBUG
#define DEBUG_PRINTF @debug systemChat format $@
#define ARSENAL_BOX         boxX

#define IDX_ITEM            0
#define IDX_AMOUNT          1
#define IDX_TICKS           2
#define IDX_MAGAZINE        3

#define BASE_TICKS          5

#define actionTarget player


FO_addedActions = [];
FO_unlockedItems = [
	["rhs_weap_l1a1_wood", 1, BASE_TICKS, "rhs_mag_20Rnd_762x51_m80_fnfal"],
	["rhsusf_weap_MP7A2", 1, BASE_TICKS, "rhsusf_mag_40Rnd_46x30_FMJ"],
	["V_PlateCarrier1_rgr", 1, BASE_TICKS, ""]
];


FO_fn_setFactoryProductionAction = {
	private item = _this[3][IDX_ITEM];
	private amount = _this[3][IDX_AMOUNT];
	private ticks = _this[3][IDX_TICKS];
	private magazine = _this[3][IDX_MAGAZINE];
	private factory = _this[3][4];
	private itemName = getText (configFile >> "CfgWeapons" >> _item >> "displayName");

	[factory, item, amount, ticks, magazine] remoteExec ["FO_fn_setFactoryProduction", 2];
	systemChat format ["%1 has started producing %2", [factory] call FO_fn_getNearestTown, itemName];
	
	call FO_fn_clearProductionActions;
};


FO_fn_addSetProductionActions = {
	private factory = _this[3][0];

	call FO_fn_clearProductionActions;
	{
		private itemName = getText (configFile >> "CfgWeapons" >> _x[IDX_ITEM] >> "displayName");
		FO_addedActions pushBack (actionTarget addAction [itemName, {call FO_fn_setFactoryProductionAction}, [_x[IDX_ITEM], _x[IDX_AMOUNT], _x[IDX_TICKS], _x[IDX_MAGAZINE], _factory]]);
	} forEach FO_unlockedItems;

	FO_addedActions pushBack (actionTarget addAction ["Back", {call FO_fn_createFactoryManagementActions}, [factory]]);
};


FO_fn_addClearAction = {
	FO_addedActions pushBack (actionTarget addAction ["Back", {call FO_fn_clearProductionActions}]);
};


FO_fn_clearProductionActions = {
	{
		actionTarget removeAction _x;
	} forEach FO_addedActions;
	FO_addedActions = [];
};


FO_fn_createFactoryManagementActions = {
	private factory = _this[3][0];
	call FO_fn_clearProductionActions;

	FO_addedActions pushBack (actionTarget addAction ["Set Production", {call FO_fn_addSetProductionActions}, [factory]]);
	FO_addedActions pushBack (actionTarget addAction ["Back", {call FO_fn_createFactorySelection}]);
};


FO_fn_createFactorySelection = {
	private factories = call FO_fn_getOwnedFactories;
	call FO_fn_clearProductionActions;

	{
		FO_addedActions pushBack (actionTarget addAction [[_x] call FO_fn_getNearestTown, {call FO_fn_createFactoryManagementActions}, [_x]]);
	} forEach factories;

	call FO_fn_addClearAction;
};


private fn_init = {
	removeAllActions actionTarget;
	[0] call A3A_fnc_productionHandler;
	ARSENAL_BOX addAction ["Factory Management", {call FO_fn_createFactorySelection}, nil, 1, true, true, "", "true", 3, true, "", ""];
};


call fn_init;