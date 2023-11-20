#include "fn_productionUnlocks.sqf"

#define IDX_FACTORY_GUI     6969
#define IDC_FACTORY_LIST    69691
#define IDC_FACTORY_WEPS    69692

#define IDC_ITEM            69693
#define IDC_QTY             69694

#define IDC_STARTSTOP_BTN   69695
#define IDC_EXIT_BUTTON     69696

#define DEBUG 1


FO_fn_GUI_addFactoriesToListbox = {
    // Clear the list box in case it already has items
#ifdef DEBUG
    systemChat "Initialising GUI controls...";
#endif

    disableSerialization; 
    lbClear IDC_FACTORY_LIST;
    lbClear IDC_FACTORY_WEPS;
    ctrlSetText [IDC_ITEM, ""];
    ctrlSetText [IDC_QTY, ""];

    { 
      _town = _x select 1;
      lbAdd[IDC_FACTORY_LIST, _town];
    } forEach call FO_fn_GUI_createFactoryTownPairs;
};


FO_fn_GUI_createFactoryTownPairs = {
    private _ownedFactories = []; // [_factory,townName];

    {
      _town = [_x] call FO_fn_getNearestTown;
      _ownedFactories pushBack [_x,_town];
    } forEach call FO_fn_getOwnedFactories;

    _ownedFactories;

};


FO_fn_GUI_addWeaponsToListbox = {
    {
		private _itemName  = getText (configFile >> "CfgWeapons" >> _x select 0 >> "displayName");
		lbAdd [IDC_FACTORY_WEPS, _itemName];
	} forEach call FO_fn_getUnlockedItems;
};


FO_fn_GUI_lookupFactoryIDbyName = {
    params ["_factoryTownPairs", "_text"];

    private _selectedFactoryFromTownname = "";
    {
        if ((_x select 1) isEqualTo _text) then {
            _selectedFactoryFromTownname = _x select 0;
        };
    } forEach _factoryTownPairs;

    _selectedFactoryFromTownname;
};


/* TODO
FO_fn_GUI_lookupItemClassbyName = {
    params ["_unlockedItemsArray","_displayName"];

    private _selectedItemClassname = "";
    {
        if ((_x select 1) isEqualTo _text) then {
            _selectedItemClassname = _x select 0;
        };
    } forEach _factoryTownPairs;

    _selectedItemClassname;
};
*/


FO_fn_GUI_clearLabels = {
    ctrlSetText [IDC_ITEM, ""];
    ctrlSetText [IDC_QTY, ""];
};


FO_fn_GUI_updateLabels = {
    params["_factoryID"];
    private _structure = [_factoryID] call FO_fn_getFactoryStructure;
    
    private _selectedItem = lbText [IDC_FACTORY_WEPS, lbCurSel IDC_FACTORY_WEPS];
    private _item = _structure select 1;
    private _itemDisplayName = getText (configFile >> "CfgWeapons" >> _item >> "displayName");


    systemChat format ["Selected item: %1", _selectedItem];
    if (([_structure] call FO_fn_factoryIsProducing) isEqualTo true) exitWith {
        private _qty = str (_structure select 2);

        ctrlSetText [IDC_ITEM, _itemDisplayName];
        ctrlSetText [IDC_QTY, _qty];

        if (_selectedItem isEqualTo _itemDisplayName) then {
            ctrlSetText [IDC_STARTSTOP_BTN, "Stop Production"];
        } else {
            ctrlSetText [IDC_STARTSTOP_BTN, "Start Production"];
        };
    };


    [] call FO_fn_GUI_clearLabels;
    ctrlSetText [IDC_STARTSTOP_BTN, "Start Production"];
};


FO_fn_GUI_addEventHandlers = {
    private _display          = findDisplay IDX_FACTORY_GUI;
    private _listBoxWeapons   = _display displayCtrl IDC_FACTORY_WEPS;
    private _listBoxFactories = _display displayCtrl IDC_FACTORY_LIST;
    private _startStopButton  = _display displayCtrl IDC_STARTSTOP_BTN;
    private _exitButton       = _display displayCtrl IDC_EXIT_BUTTON;

    _listBoxWeapons ctrlAddEventHandler ["LBSelChanged", {
        private _selText  = lbText [IDC_FACTORY_LIST, lbCurSel IDC_FACTORY_LIST];
        private _ownedFactories = call FO_fn_GUI_createFactoryTownPairs;
        private _factoryID = [_ownedFactories, _selText] call FO_fn_GUI_lookupFactoryIDbyName;

        [_factoryID] call FO_fn_GUI_updateLabels;
    }];

    // Add the Selection Changed event handler to Owned Factories ListBox
    _listBoxFactories ctrlAddEventHandler ["LBSelChanged", {
        private _selIndex = lbCurSel IDC_FACTORY_LIST;
        private _selText = lbText [IDC_FACTORY_LIST, _selIndex];
      
        // Select the town name in the GUI -> Convert it to factory name -> Get that factory's structure.
        private _ownedFactories = call FO_fn_GUI_createFactoryTownPairs;
        private _factoryID = [_ownedFactories, _selText] call FO_fn_GUI_lookupFactoryIDbyName;

#ifdef DEBUG
        systemChat format ["%1 factory selected, ID %2", _selText, _factoryID];
#endif

        [_factoryID] call FO_fn_GUI_updateLabels;
    }];

    // Add the ButtonClick event handler to Start/Stop Production Button.
    _startStopButton ctrlAddEventHandler ["ButtonClick", {
        private _selIndex = lbCurSel IDC_FACTORY_LIST;
        private _selText  = lbText [IDC_FACTORY_LIST, _selIndex];
      
        // Select the town name in the GUI -> Convert it to factory name -> Get that factory's structure.
        private _ownedFactories = call FO_fn_GUI_createFactoryTownPairs;
        private _factoryID = [_ownedFactories, _selText] call FO_fn_GUI_lookupFactoryIDbyName;

        private _structure = _factoryID call FO_fn_getFactoryStructure;

        if ((ctrlText IDC_STARTSTOP_BTN) isEqualTo "Start Production") then {
            // Item Display name in IDC_FACTORY_WEPS -> className -> StartProduction
            {
                private _itemName  = getText (configFile >> "CfgWeapons" >> _x select 0 >> "displayName");
                private _selIndex = lbCurSel IDC_FACTORY_WEPS;
                private _selText = lbText [IDC_FACTORY_WEPS, _selIndex];
                if (_selText isEqualTo _itemName) then {
                    // Production params: ["_factory", "_item", "_amount", "_ticks", "_magazine"];
                    [_factoryID, _x select 0, _x select 1, _x select 2, _x select 3] remoteExec ["FO_fn_setFactoryProduction", 2];

#ifdef DEBUG
                    systemChat format ["Started production on %1 for %2 (%3)", _factoryID, _x select 1, _selText];
#endif

                    ctrlSetText [IDC_ITEM, _itemName];
                    ctrlSetText [IDC_QTY, str(_x select 1)];
                    ctrlSetText [IDC_STARTSTOP_BTN, "Stop Production"];
                };
            } forEach call FO_fn_getUnlockedItems;


        } else {
            [_factoryID, "", 0, -1, 0, ""] remoteExec ["FO_fn_setFactoryProduction", 2];
#ifdef DEBUG
            systemChat format ["Stopped production on %1", _factoryID];
#endif
            ctrlSetText [IDC_ITEM, ""];
            ctrlSetText [IDC_QTY, ""];
            ctrlSetText [IDC_STARTSTOP_BTN, "Start Production"];
        };

    }];

    _exitButton ctrlAddEventHandler ["ButtonClick", {
        closeDialog 2;
    }];

    // Select the first entries in the listboxes
    if (lbSize IDC_FACTORY_LIST > 0) then {
        lbSetCurSel [IDC_FACTORY_LIST, 0];
        lbSetCurSel [IDC_FACTORY_WEPS, 0];
    };
};


[] spawn FO_fn_GUI_addFactoriesToListbox;
[] spawn FO_fn_GUI_addWeaponsToListbox;
[] spawn FO_fn_GUI_addEventHandlers;