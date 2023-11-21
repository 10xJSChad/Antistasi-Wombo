//Exported via Arma Dialog Creator (https://github.com/kayler-renslow/arma-dialog-creator)

#include "CustomControlClasses.h"
class FactoryGUI
{
	idd = 6969;
	
	class ControlsBackground
	{
		class ProductionLineBackground
		{
			type = 0;
			idc = -1;
			x = safeZoneX + safeZoneW * 0.295;
			y = safeZoneY + safeZoneH * 0.22555556;
			w = safeZoneW * 0.411875;
			h = safeZoneH * 0.54888889;
			style = 0;
			text = "";
			colorBackground[] = {0.05,0.05,0.05,0.7};
			colorText[] = {0,0,0,0};
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			
		};
		class Background2
		{
			type = 0;
			idc = -1;
			x = 0.00151516;
			y = -0.17171717;
			w = 0.99848485;
			h = 0.17171719;
			style = 0;
			text = "";
			colorBackground[] = {0.05,0.05,0.05,0.7};
			colorText[] = {0,0,0,0};
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			
		};
		class ItemPictureBackground
		{
			type = 0;
			idc = 69699;
			x = safeZoneX + safeZoneW * 0.503125;
			y = safeZoneY + safeZoneH * 0.23111112;
			w = safeZoneW * 0.195;
			h = safeZoneH * 0.24333334;
			style = 0;
			text = "";
			colorBackground[] = {1,1,1,0.4};
			colorText[] = {0,0,0,0};
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			
		};
		
	};
	class Controls
	{
		class ProductionList
		{
			type = 5;
			idc = 69692;
			x = safeZoneX + safeZoneW * 0.294375;
			y = safeZoneY + safeZoneH * 0.23111112;
			w = safeZoneW * 0.20625;
			h = safeZoneH * 0.54111112;
			style = 16;
			colorBackground[] = {0.302,0.302,0.302,0.5};
			colorDisabled[] = {0.2,0.2,0.2,1};
			colorSelect[] = {1,1,0.302,1};
			colorText[] = {1,1,1,1};
			font = "PuristaMedium";
			maxHistoryDelay = 0;
			rowHeight = 0.05;
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1.2);
			soundSelect[] = {"\A3\ui_f\data\sound\RscListbox\soundSelect",0.09,1.0};
			colorSelect2[] = {1,1,0.302,0.7};
			colorSelectBackground[] = {0,0,0,0};
			colorSelectBackground2[] = {0,0,0,0};
			class ListScrollBar
			{
				color[] = {1,1,1,1};
				thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
				arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
				arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
				border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
				
			};
			
		};
		class FactorySelectionTitle
		{
			type = 0;
			idc = -1;
			x = safeZoneX + safeZoneW * 0.12125;
			y = safeZoneY + safeZoneH * 0.15777778;
			w = safeZoneW * 0.15375;
			h = safeZoneH * 0.05555556;
			style = 0+2;
			text = "Factory Selection";
			colorBackground[] = {0.102,0.102,0.102,1};
			colorText[] = {1,1,1,1};
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 2);
			
		};
		class ItemCategoriesList
		{
			type = 4;
			idc = 69697;
			x = safeZoneX + safeZoneW * 0.299375;
			y = safeZoneY + safeZoneH * 0.18555556;
			w = safeZoneW * 0.13125;
			h = safeZoneH * 0.03444445;
			style = 16;
			arrowEmpty = "\A3\ui_f\data\GUI\RscCommon\RscCombo\arrow_combo_ca.paa";
			arrowFull = "\A3\ui_f\data\GUI\RscCommon\RscCombo\arrow_combo_active_ca.paa";
			colorBackground[] = {0,0,0,1};
			colorDisabled[] = {0.2,0.2,0.2,1};
			colorSelect[] = {1,1,1,1};
			colorSelectBackground[] = {0,0,0,1};
			colorText[] = {1,1,1,1};
			font = "PuristaBold";
			maxHistoryDelay = 0;
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			soundCollapse[] = {"\A3\ui_f\data\sound\RscCombo\soundCollapse",0.1,1.0};
			soundExpand[] = {"\A3\ui_f\data\sound\RscCombo\soundExpand",0.1,1.0};
			soundSelect[] = {"\A3\ui_f\data\sound\RscCombo\soundSelect",0.1,1.0};
			wholeHeight = 0.3;
			class ComboScrollBar
			{
				color[] = {1,1,1,1};
				thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
				arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
				arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
				border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
				
			};
			
		};
		class OwnedFactoriesList
		{
			type = 5;
			idc = 69691;
			x = safeZoneX + safeZoneW * 0.12207032;
			y = safeZoneY + safeZoneH * 0.22743056;
			w = safeZoneW * 0.15429688;
			h = safeZoneH * 0.54861112;
			style = 16;
			colorBackground[] = {0.2,0.2,0.2,0.5};
			colorDisabled[] = {0.2,0.2,0.2,1};
			colorSelect[] = {1,1,0.302,1};
			colorText[] = {1,1,1,1};
			font = "PuristaBold";
			maxHistoryDelay = 0;
			rowHeight = 0;
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1.5);
			soundSelect[] = {"\A3\ui_f\data\sound\RscListbox\soundSelect",0.09,1.0};
			colorSelect2[] = {1,1,0.302,0.7};
			colorSelectBackground[] = {0,0,0,0};
			colorSelectBackground2[] = {0,0,0,0};
			onLoad = "[] call A3A_fnc_productionGUIControls;";
			class ListScrollBar
			{
				color[] = {0,0,0,0};
				thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
				arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
				arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
				border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
				
			};
			
		};
		class StartProductionButton
		{
			type = 1;
			idc = 69695;
			x = safeZoneX + safeZoneW * 0.5075;
			y = safeZoneY + safeZoneH * 0.66777778;
			w = safeZoneW * 0.089375;
			h = safeZoneH * 0.06888889;
			style = 0+2;
			text = "Start Production";
			borderSize = 0;
			colorBackground[] = {0.2,0.2,0.2,1};
			colorBackgroundActive[] = {1,0,0,1};
			colorBackgroundDisabled[] = {0.2,0.2,0.2,1};
			colorBorder[] = {0,0,0,0};
			colorDisabled[] = {0.2,0.2,0.2,1};
			colorFocused[] = {0.2,0.2,0.2,1};
			colorShadow[] = {0,0,0,1};
			colorText[] = {1,1,1,1};
			font = "PuristaBold";
			offsetPressedX = 0.01;
			offsetPressedY = 0.01;
			offsetX = 0.01;
			offsetY = 0.01;
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1.2);
			soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick",0.09,1.0};
			soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter",0.09,1.0};
			soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape",0.09,1.0};
			soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush",0.09,1.0};
			
		};
		class ProdManagementTitle
		{
			type = 0;
			idc = -1;
			x = safeZoneX + safeZoneW * 0.295;
			y = safeZoneY + safeZoneH * 0.13;
			w = safeZoneW * 0.411875;
			h = safeZoneH * 0.05111112;
			style = 2;
			text = "Production Management";
			colorBackground[] = {0.102,0.102,0.102,1};
			colorText[] = {1,1,1,1};
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 2);
			
		};
		class SearchTextBox
		{
			type = 2;
			idc = -1;
			x = safeZoneX + safeZoneW * 0.51875;
			y = safeZoneY + safeZoneH * 0.18888889;
			w = safeZoneW * 0.175625;
			h = safeZoneH * 0.02777778;
			style = 0;
			text = "";
			autocomplete = "";
			colorBackground[] = {0.102,0.102,0.102,1};
			colorDisabled[] = {0.2,0.2,0.2,1};
			colorSelection[] = {1,0,0,1};
			colorText[] = {1,1,1,1};
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			
		};
		class SearchLabel
		{
			type = 0;
			idc = -1;
			x = safeZoneX + safeZoneW * 0.440625;
			y = safeZoneY + safeZoneH * 0.18888889;
			w = safeZoneW * 0.0725;
			h = safeZoneH * 0.02777778;
			style = 0;
			text = "Search Item:";
			colorBackground[] = {0,0,0,1};
			colorText[] = {1,1,1,1};
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			
		};
		class curItemLabel
		{
			type = 0;
			idc = 0;
			x = safeZoneX + safeZoneW * 0.5;
			y = safeZoneY + safeZoneH * 0.47666667;
			w = safeZoneW * 0.1125;
			h = safeZoneH * 0.03666667;
			style = 0;
			text = "Item in Production:";
			colorBackground[] = {0,0,0,0};
			colorText[] = {1,1,1,1};
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			
		};
		class quantityLabel
		{
			type = 0;
			idc = 0;
			x = safeZoneX + safeZoneW * 0.5;
			y = safeZoneY + safeZoneH * 0.55111112;
			w = safeZoneW * 0.1125;
			h = safeZoneH * 0.03666667;
			style = 0;
			text = "Quantity: ";
			colorBackground[] = {0,0,0,0};
			colorText[] = {1,1,1,1};
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			
		};
		class currentQty
		{
			type = 0;
			idc = 69694;
			x = safeZoneX + safeZoneW * 0.541875;
			y = safeZoneY + safeZoneH * 0.55111112;
			w = safeZoneW * 0.1125;
			h = safeZoneH * 0.03666667;
			style = 0;
			text = "";
			colorBackground[] = {0,0,0,0};
			colorText[] = {1,1,1,1};
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			
		};
		class currentItem
		{
			type = 0;
			idc = 69693;
			x = safeZoneX + safeZoneW * 0.504375;
			y = safeZoneY + safeZoneH * 0.51555556;
			w = safeZoneW * 0.1125;
			h = safeZoneH * 0.03666667;
			style = 0;
			text = "";
			colorBackground[] = {0,0,0,0};
			colorText[] = {1,1,1,1};
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			
		};
		class ExitMenuButton
		{
			type = 1;
			idc = 69696;
			x = safeZoneX + safeZoneW * 0.6075;
			y = safeZoneY + safeZoneH * 0.66777778;
			w = safeZoneW * 0.089375;
			h = safeZoneH * 0.06888889;
			style = 0+2;
			text = "Exit Menu";
			borderSize = 0;
			colorBackground[] = {0.2,0.2,0.2,1};
			colorBackgroundActive[] = {1,0,0,1};
			colorBackgroundDisabled[] = {0.2,0.2,0.2,1};
			colorBorder[] = {0,0,0,0};
			colorDisabled[] = {0.2,0.2,0.2,1};
			colorFocused[] = {0.2,0.2,0.2,1};
			colorShadow[] = {0,0,0,1};
			colorText[] = {1,1,1,1};
			font = "PuristaBold";
			offsetPressedX = 0.01;
			offsetPressedY = 0.01;
			offsetX = 0.01;
			offsetY = 0.01;
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1.2);
			soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick",0.09,1.0};
			soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter",0.09,1.0};
			soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape",0.09,1.0};
			soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush",0.09,1.0};
			
		};
		class ItemPicture
		{
			type = 0;
			idc = 69698;
			x = safeZoneX + safeZoneW * 0.503125;
			y = safeZoneY + safeZoneH * 0.23111112;
			w = safeZoneW * 0.195;
			h = safeZoneH * 0.24333334;
			style = 0+48+2048;
			text = "";
			colorBackground[] = {0,0,0,0};
			colorText[] = {1,1,1,1};
			font = "PuristaMedium";
			sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
			lineSpacing = 0;
			shadow = 0;
			tooltipColorBox[] = {1,1,1,1};
			tooltipColorShade[] = {0,0,0,0.65};
			tooltipColorText[] = {1,1,1,1};
			
		};
		
	};
	
};
