#export "../../../A3A/addons/core/functions/FactoryOverhaul/fn_productionUnlocks.sqf"
#import "../include.sqf"


FO_fn_getUnlockedItems = {
	private unlockedItems = [];
	private baseUnlocks = [
		["rhs_weap_l1a1_wood",  1,  1, "rhs_mag_20Rnd_762x51_m80_fnfal"],
		["rhsusf_weap_MP7A2",   1,  1, "rhsusf_mag_40Rnd_46x30_FMJ"],
		["V_PlateCarrier1_rgr", 1,  1, ""]
	];

	unlockedItems append baseUnlocks;
	unlockedItems;
};
