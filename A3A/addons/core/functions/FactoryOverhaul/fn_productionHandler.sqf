#define DEBUG_PRINTF        systemChat format
#define ARSENAL_BOX         boxX

#define BASE_PROGRESS       0
#define BASE_PROGRESSMAX    5
#define BASE_ITEM           "arifle_AKM_F"
#define BASE_AMOUNT         1

#define IDX_FACTORY         0
#define IDX_ITEM            1
#define IDX_AMOUNT          2
#define IDX_PROGRESS        3
#define IDX_PROGRESSMAX     4
#define IDX_MAGAZINE        5


params ["_tickRate"];

// [factory, item, amount, progress, progressMax, magazine]
factoryProductionArray = [];


FO_fn_setFactoryProduction = {
    params ["_factory", "_item", "_amount", "_ticks", "_magazine"];
    private _structure = _factory call FO_fn_getFactoryStructure;
    private _structure_index = factoryProductionArray find _structure;
    
    _structure set [IDX_ITEM, _item];
    _structure set [IDX_AMOUNT, _amount];
    _structure set [IDX_PROGRESS, 0];
    _structure set [IDX_PROGRESSMAX, _ticks];
    _structure set [IDX_MAGAZINE, _magazine];

    factoryProductionArray set [_structure_index, _structure];
    publicVariable "factoryProductionArray";
};


FO_fn_getNearestTown = {
    params ["_marker"];
    [citiesX, _marker] call BIS_Fnc_nearestPosition;
};


FO_fn_getOwnedFactories = {
    private _factories = [];
    {
        if ((sidesX getVariable [_x, sideUnknown]) == teamPlayer) then {
            _factories pushBack _x;
            // DEBUG_PRINTF ["%1 (%2) is owned by player", _x, [_x] call FO_fn_getNearestTown];
        }
    } forEach factories;

    _factories;
};


FO_fn_factoryIsProducing = {
    params ["_factoryStructure"];
    if ((_factoryStructure select IDX_PROGRESS) isEqualTo -1) exitWith {false};
    if ((_factoryStructure select IDX_ITEM) isEqualTo "")     exitWith {false};
    true;
};


FO_fn_getFactoryStructure = {
    params ["_factory"];
    private _result = [];

    {
        if (_x select IDX_FACTORY isEqualTo _factory) exitWith {
            _result = _x;
        };
    } forEach factoryProductionArray;

    _result;
};


private _fn_factoryInProductionArray = {
    params ["_factory"];
    private _result = false;

    {
        if ((_x select IDX_FACTORY) isEqualTo _factory) exitWith {
            _result = true;
        };
    } forEach factoryProductionArray;

    _result;
};


private _fn_factoryProduce = {
    params ["_factoryStructure"];
    
    private _factory = _factoryStructure select IDX_FACTORY;
    private _item    = _factoryStructure select IDX_ITEM;
    private _amount  = _factoryStructure select IDX_AMOUNT;
    private _magazine = _factoryStructure select IDX_MAGAZINE;

    // DEBUG_PRINTF ["%1 has produced %2", _factory, _item];
    ARSENAL_BOX addItemCargoGlobal [_item, _amount];
    if (_magazine != "") then {
        ARSENAL_BOX addItemCargoGlobal [_magazine, 2];
    };
};


private _fn_factoryUpdate = {
    params ["_factory"];
    // DEBUG_PRINTF ["%1 is updating", _factory];

    if ((_factory call _fn_factoryInProductionArray) isEqualTo false) then {
        // DEBUG_PRINTF ["%1 is not in production array, adding...", _factory];
        factoryProductionArray pushBack [_factory, "", 0, -1, 0, ""];
    };

    private _structure = _factory call FO_fn_getFactoryStructure;
    private _structure_index = factoryProductionArray find _structure;
    private _progress    = _structure select IDX_PROGRESS;
    private _progressMax = _structure select IDX_PROGRESSMAX;

    // decrement progress
    _progress = _progress + 1;
    _structure set [IDX_PROGRESS, _progress];

    if (([_structure] call FO_fn_factoryIsProducing) isEqualTo false) exitWith {
        // DEBUG_PRINTF ["%1 is not producing", _factory];
    };

    if (_progress isEqualTo _progressMax) then {
        private _progressMax = _structure select IDX_PROGRESSMAX;
        [_structure] call _fn_factoryProduce;
        _structure set [IDX_PROGRESS, 0];
    } else {
        // DEBUG_PRINTF ["%1 updated, progress: %2", _factory, _progress];
    };

    factoryProductionArray set [_structure_index, _structure];
};


private _fn_productionTick = {
    {
        _x call _fn_factoryUpdate;
    } forEach call FO_fn_getOwnedFactories;
};


private _fn_init = {
    // placeholder
};


private _fn_productionLoop = {
    params ["_tickRate"];
    call _fn_init;

    if (_tickRate isEqualTo 0) exitWith {};

    while {true} do {
        call _fn_productionTick;
        publicVariable "factoryProductionArray";
        sleep _tickRate;
    };
};


systemChat "Factory Production Initialized";
[_tickRate] call _fn_productionLoop;