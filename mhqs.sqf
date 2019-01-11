// When the triggered, adds a list of teleports to a vehicle type to the object it was triggered from

// Called from an object like a flagpole
// That object should *only* do this, no other addactions

// Usage: Add 
// this addAction ["Request Redeployment", "mhqs.sqf",[],6,true,false,"","true",5];
// to your flagpole, and include mhqs.sqf in the root.

//*********
// MHQ Vehicle type is ideally something that *wont* be spawned
// in for other purposes. ALL vehicles of this type are listed
mhq_vehicle_type = "CUP_B_HMMWV_Ambulance_USA";
//*********

_target = _this select 0;
_caller = _this select 1;

// Get rid of the old addaction
removeAllActions _target;

// Get all of the vehicle type
_mhqs = entities [[ mhq_vehicle_type ], []];
{
	if (alive _x) then {
		_vehicleName = vehicleVarName _x;
		_actionString = "";
		_placeName = text nearestLocation [_x,""];
		if (_placeName=="") then {
			_nearestCity = nearestLocation [player,"nameCity"];
			_nearestVillage = nearestLocation [player,"nameVillage"];
			if ((player distance (getPos _nearestCity)) > (player distance (getPos _nearestVillage))) then {
				_placeName = text _nearestVillage;
			} else {
				_placeName = text _nearestCity;
			};
		};
		_actionString = "MHQ " + _vehicleName + " near " + _placeName;
		_target addAction[_actionString, {cutText ["Redeploying...","BLACK FADED",0.3];player moveInCargo ((_this select 3) select 0);},[_x],6,true,true,"","true",5];
	};
} forEach _mhqs;

// Schedule restoring the old addaction
[_target] spawn {
	sleep 15;
	removeAllActions (_this select 0);
	// Can i replace this with somethign like reinit _target;
	(_this select 0) addAction ["Request Redeployment", "mhqs.sqf",[],6,true,false,"","true",5];
};
