#export "../../../A3A/addons/core/functions/FactoryOverhaul/fn_productionUnlocks.sqf"
#import "../include.sqf"


FO_fn_getUnlockedItems = {
	private unlockedItems = [];
	private baseUnlocks = [
		["rhs_weap_savz61_folded",  1,  1, "rhsgref_20rnd_765x17_vz61"],
		["rhs_weap_kar98k",   1,  1, "rhsgref_5Rnd_792x57_kar98k"],
		["U_BG_Guerrilla_6_1", 1, 1, ""],
		["V_I_G_resistanceLeader_F", 1, 1, ""]
	];

	unlockedItems append baseUnlocks;
	unlockedItems;
};
