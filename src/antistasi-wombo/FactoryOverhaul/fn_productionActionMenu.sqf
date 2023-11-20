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


params ["_useGUI"];


FO_addedActions = [];


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
		FO_addedActions pushBack (player addAction [itemName, {call FO_fn_setFactoryProductionAction}, [_x[IDX_ITEM], _x[IDX_AMOUNT], _x[IDX_TICKS], _x[IDX_MAGAZINE], _factory]]);
	} forEach call FO_fn_getUnlockedItems;

	FO_addedActions pushBack (player addAction ["Back", {call FO_fn_createFactoryManagementActions}, [factory]]);
};


FO_fn_addClearAction = {
	FO_addedActions pushBack (player addAction ["Back", {call FO_fn_clearProductionActions}]);
};


FO_fn_clearProductionActions = {
	{
		player removeAction _x;
	} forEach FO_addedActions;
	FO_addedActions = [];
};


FO_fn_createFactoryManagementActions = {
	private factory = _this[3][0];
	call FO_fn_clearProductionActions;

	FO_addedActions pushBack (player addAction ["Set Production", {call FO_fn_addSetProductionActions}, [factory]]);
	FO_addedActions pushBack (player addAction ["Back", {call FO_fn_createFactorySelection}]);
};


FO_fn_createFactorySelection = {
	private factories = call FO_fn_getOwnedFactories;
	call FO_fn_clearProductionActions;

	{
		FO_addedActions pushBack (player addAction [[_x] call FO_fn_getNearestTown, {call FO_fn_createFactoryManagementActions}, [_x]]);
	} forEach factories;

	call FO_fn_addClearAction;
};


private fn_init = {
	params ["_usingGUI"];

	removeAllActions player;
	[0] call A3A_fnc_productionHandler;
	call A3A_fnc_productionUnlocks;

	if (_usingGUI) exitWith {
		ARSENAL_BOX addAction [format ["<img image='\A3\ui_f\data\map\mapcontrol\PowerSolar_CA.paa' size='1.6' shadow=2 /> <t>%1</t>", "Factory Management"], {
				if ((count (call FO_fn_getOwnedFactories)) > 0) then {
					createDialog "FactoryGUI";
				} else {
					systemChat "You don't own any factories.";
				};
			},
		3, 1, true, true, "", "true", 3, true, "", ""];
	};

	ARSENAL_BOX addAction ["Factory Management", {call FO_fn_createFactorySelection}, nil, 1, true, true, "", "true", 3, true, "", ""];
};


[_useGUI] call fn_init;