// Generated KOS Script...
PRINT "Started Script".
WAIT 3.


  function get_in_Kerbin_orbit_Deploy_sat_com_s{
         get_in_kerbin_orbit_region().
         UNTIL false{
         IF true{
            return reach_mun_orbit_Deploy_sat_com_s@. 
         }
                                          
         WAIT 0.001.
         }
  }
 
  
    function doLaunchInToOrbit_1_80000_6000__get_in_kerbin_orbit_region_s{
           doLaunchInToOrbit(1,80000,6000).
           UNTIL false{
           IF true{
              return doSafeStage_1__get_in_kerbin_orbit_region_s@. 
           }
                                            
           WAIT 0.001.
           }
    }
   
    function doSafeStage_1__get_in_kerbin_orbit_region_s{
           doSafeStage(1).
           UNTIL false{
           IF true{
              return doLowerInclination___get_in_kerbin_orbit_region_s@. 
           }
                                            
           WAIT 0.001.
           }
    }
   
    function doDeploySolarPanels___get_in_kerbin_orbit_region_s{
           doDeploySolarPanels().
           UNTIL false{
           IF true{
           	return 0.
           }
           WAIT 0.001.
           }
    }
   
    function doLowerInclination___get_in_kerbin_orbit_region_s{
           doLowerInclination().
           UNTIL false{
           IF true{
              return doDeploySolarPanels___get_in_kerbin_orbit_region_s@. 
           }
                                            
           WAIT 0.001.
           }
    }
   
  
  
   function get_in_kerbin_orbit_region{
          local next_state is doLaunchInToOrbit_1_80000_6000__get_in_kerbin_orbit_region_s@.
         UNTIL next_state = 0{
                set next_state to next_state().
         }
   }
  
  function reach_mun_orbit_Deploy_sat_com_s{
         reach_mun_orbit_region().
         UNTIL false{
         IF true{
         	return 0.
         }
         WAIT 0.001.
         }
  }
 
  
    function doFollowMun___reach_mun_orbit_region_s{
           doFollowMun().
           UNTIL false{
           IF true{
              return doCircularizeFromApoapsis___reach_mun_orbit_region_s@. 
           }
                                            
           WAIT 0.001.
           }
    }
   
    function doCircularizeFromApoapsis___reach_mun_orbit_region_s{
           doCircularizeFromApoapsis().
           UNTIL false{
           IF true{
           	return 0.
           }
           WAIT 0.001.
           }
    }
   
  
  
   function reach_mun_orbit_region{
          local next_state is doFollowMun___reach_mun_orbit_region_s@.
         UNTIL next_state = 0{
                set next_state to next_state().
         }
   }
  


 function Deploy_sat_com{
        local next_state is get_in_Kerbin_orbit_Deploy_sat_com_s@.
       UNTIL next_state = 0{
              set next_state to next_state().
       }
 }

               
Deploy_sat_com().
PRINT "Finished Script".
UNTIL false {
     WAIT 1.
}

//library version 30.12
//maneuvers

function doChangeApoapsis {
  //This function changes the height of the apoapsis by burning at the periapsis.
  parameter desired_apoapsis.
  
  local init_manv is list(time:seconds + eta:periapsis, 0, 0, 0).
  set manv to findManeuver(init_manv, list(3), scoreDiffApoapsisHeight@, list(desired_apoapsis), list(100, 10, 1)).
  executeManeuver(manv, 15, 10).
  wait 1.
}
function doChangePeriapsis {
  //This function changes the height of the periapsis by burning at the apoapsis
  parameter desired_periapsis.
  local init_manv is list(time:seconds + eta:apoapsis, 0, 0, 0).
  set manv to findManeuver(init_manv, list(3), scoreDiffPeriapsisHeight@, list(desired_periapsis), list(100, 10, 1)).
  executeManeuver(manv, 15, 10).
  wait 1.
}
function doCircularizeFromPeriapsis {
  //Circularize the orbit by burning at the apoapsis.
  local init_manv is list(time:seconds + eta:periapsis, 0, 0, 0).
  set manv to findManeuver(init_manv, list(3), eccentricityScore@, false, list(100, 10, 1)).
  executeManeuver(manv, 15, 10).
  wait 1.
}
function doCircularizeFromApoapsis {
  //Circularize the orbit by burning at the periapsis.
  local init_manv is list(time:seconds + eta:apoapsis, 0, 0, 0).
  set manv to findManeuver(init_manv, list(3), eccentricityScore@, false, list(100, 10, 1)).
  executeManeuver(manv, 15, 10).
  wait 1.
}

function doTransferToBody {
  //Transfer to a given celestial body.
  parameter transfer_body, desired_height.
  local startSearchTime is ternarySearch(diffFromDistanceNeg@, list(ship, transfer_body, 0), time:seconds + 30, time:seconds + 30 + orbit:period, 1).
  local init_manv is list(startSearchTime, 0, 0, 0).
  set manv to findManeuver(init_manv, list(0, 1, 2, 3), transferScore@, list(transfer_body, desired_height), list(100, 10, 1)).
  executeManeuver(manv, 15, 10).
  wait 1.
}
function doTransferToFarBody {
  //Transfer to a given celestial body, function meant for farther celestial bodies.
  parameter transfer_body, desired_height.
  local init_manv is list(time:seconds + 30 + orbit:period, 0, 0, 500).
  set manv to findManeuver(init_manv, list(0), scoreDiffDistanceApoapsis@, list(ship, transfer_body, desired_height), list(100, 10, 1)).
  set manv to findManeuver(manv, list(0, 1, 2, 3), transferScore@, list(transfer_body, desired_height), list(100, 10, 1)).
  executeManeuver(manv, 15, 10).
  wait 1.
}
function doSlingShotToFarBody {
  //Uses a celestial body to slingshot to the patch of a second body, function meant for farther celestial bodies.
  parameter end_body, slingshot_body, desired_height.
  local init_manv is list(time:seconds + 30 + orbit:period, 0, 0, 500).
  set manv to findManeuver(init_manv, list(0), scoreDiffDistanceApoapsis@, list(ship, slingshot_body, desired_height), list(100, 10, 1)).
  set manv to findManeuver(manv, list(0, 1, 2, 3), SlingShotScore@, list(desired_height, slingshot_body, end_body), list(100, 10, 1)).
  executeManeuver(manv, 15, 10).
  wait 1.
}
function doSlingShotToBody {
  //Uses a celestial body to slingshot to the patch of a second body.
  parameter end_body, slingshot_body, desired_height.
  local startSearchTime is ternarySearch(diffFromDistanceNeg@, list(ship, slingshot_body, 0), time:seconds + 30, time:seconds + 30 + orbit:period, 1).
  local init_manv is list(startSearchTime, 0, 0, 0).
  set manv to findManeuver(init_manv, list(0, 1, 2, 3), SlingShotScore@, list(desired_height, slingshot_body, end_body), list(100, 10, 1)).
  executeManeuver(manv, 15, 10).
  wait 1.
}
function doLowerInclination {
  //Lowers the inclination of the ship's orbit.
  local init_manv is list(time:seconds + orbit:period, 0, 0, 0).
  set manv to findManeuver(init_manv, list(0, 1, 2, 3), lowerinclinationScore@, false, list(100, 10, 1)).
  executeManeuver(manv, 15, 10).
  wait 1.
}
function warpToNextPatch{
  //Warp to the next patch.
  parameter next_body.
  warpto(time:seconds + obt:nextPatchEta - 5).
  wait until body = next_body.
  wait 1.
}
function doSafeStage {
  //This function will stage the rocket.
  parameter AmountOfStages.
  local step is 0.
  until step = AmountOfStages{
    wait until stage:ready.
    stage.
    set step to (step + 1).
  }
  global oldThrust is ship:availablethrust.
  wait 1.
}
function doLaunchIntoOrbit{
  //Launch the rocket into orbit.
  parameter amount_of_stages, end_height, turn_height.
  doLaunch(amount_of_stages).
  lock steering to up.
  until alt:radar > turn_height {
    doAutoStage().
  }
  doAscent().
  until apoapsis > end_height {
    doAutoStage().
  }
  doShutdown().
  set mapview to true.
  doCircularization().
  SET WARPMODE TO "RAILS".
}
function landDarkSideofMun{
 parameter offset is 0.
 //Lands the ship at the dark side of the mun if it is in an orbit around the mun.
 stopOrbitAtDarkSideWithOffset(offset).
 doHoverslam().
}

//find initial maneuver functions

function ternarySearch {
  parameter f, extra_parameters, left, right, absolutePrecision.
  until false {
    if abs(right - left) < absolutePrecision {
      return (left + right) / 2.
    }
    local leftThird is left + (right - left) / 3.
    local rightThird is right - (right - left) / 3.
    if f(leftThird, extra_parameters) > f(rightThird, extra_parameters) {
      set left to leftThird.
    } else {
      set right to rightThird.
    }
  }
}
function diffFromDistanceNeg {
  parameter t, extra_parameters.
  local object_1 is extra_parameters[0].
  local object_2 is extra_Parameters[1].
  local desired_distance is extra_parameters[2].
  
  local distance is GetDistanceBetween2Objects(object_1, object_2, t).
  return -ABS(distance-desired_distance).
}
function diffFromDistance {
  parameter t, extra_parameters.
  local object_1 is extra_parameters[0].
  local object_2 is extra_Parameters[1].
  local desired_distance is extra_parameters[2].
  
  local distance is GetDistanceBetween2Objects(object_1, object_2, t).
  return ABS(distance-desired_distance).
}

//find maneuver functions

function findManeuver{
  parameter init_manv, converge_indexes, scoreFunction, extra_parameters, stepSizes.

  local local_scoreFunction is scoreFunction.
  for index in converge_indexes{
    if index = 0{
      set local_scoreFunction to protectFromPast(scoreFunction).
    }
  }
  set manv to improveConverge(init_manv, converge_indexes, local_scoreFunction, extra_parameters, stepSizes).
  return manv.
}
function protectFromPast {
  parameter originalFunction.
  local replacementFunction is {
    parameter data, extra_parameters.
    if data[0] < time:seconds + 15 {
      return 2^64.
    } else {
      return originalFunction(data, extra_parameters).
    }
  }.
  return replacementFunction@.
}
function improveConverge {
  parameter data, converge_indexes, scoreFunction, extra_parameters, stepSizes.
  for stepSize in stepSizes {
    set timestepSize to stepSize.
    until false {
      local oldScore is scoreFunction(data, extra_parameters).
      set result to improve(data, converge_indexes, stepSize, timestepSize, scoreFunction, extra_parameters).
      set data to result[0].
      set timestepSize to result[1].
      if oldScore <= scoreFunction(data, extra_parameters) {
        break.
      }
    }
  }
  return data.
}
function improve {
  parameter data, converge_indexes, stepSize, timestepSize, scoreFunction, extra_parameters.
  local scoreToBeat is scoreFunction(data, extra_parameters).
  local bestCandidate is data.
  local candidates is list().
  for index in converge_indexes {
    local incCandidate is data:copy().
    local decCandidate is data:copy().
    if index = 0{
      set incCandidate[index] to incCandidate[index] + timestepSize.
      set decCandidate[index] to decCandidate[index] - timestepSize.
    } else{
      set incCandidate[index] to incCandidate[index] + stepSize.
      set decCandidate[index] to decCandidate[index] - stepSize.
    }
    candidates:add(incCandidate).
    candidates:add(decCandidate).
  }
  for candidate in candidates {
    local candidateScore is scoreFunction(candidate, extra_parameters).
    if candidateScore < scoreToBeat {
      set scoreToBeat to candidateScore.
      set bestCandidate to candidate.
    }
  }
  if bestCandidate[0] = data[0] {
    set timestepSize to stepSize.
  } else {
    set timestepSize to timestepSize*2.
  }
  return list(bestCandidate, timestepSize).
}

//maneuver finding search functions

function scoreDiffPeriapsisHeight {
  // a search function that gives the difference between the periapsis and the desired periapsis.
  parameter data, extra_parameters.
  local desired_periapsis is extra_parameters[0].

  local mnv is node(data[0], data[1], data[2], data[3]).
  addManeuverToFlightPlan(mnv).
  local result is ABS(mnv:orbit:periapsis-desired_periapsis).
  removeManeuverFromFlightPlan(mnv).
  return result.
}
function scoreDiffApoapsisHeight {
  // a search function that gives the difference between the apoapsis and the desired apoapsis.
  parameter data, extra_parameters.
  local desired_apoapsis is extra_parameters[0].

  local mnv is node(data[0], data[1], data[2], data[3]).
  addManeuverToFlightPlan(mnv).
  local result is ABS(mnv:orbit:apoapsis-desired_apoapsis).
  removeManeuverFromFlightPlan(mnv).
  return result.
}
function scoreDiffPeriapsisHeightNextPatch {
  // a search function that gives the difference between the periapsis and the desired periapsis in the next patch.
  parameter data, extra_parameters.
  local desired_periapsis is extra_parameters[0].

  local mnv is node(data[0], data[1], data[2], data[3]).
  addManeuverToFlightPlan(mnv).
  local result is 0.
  if mnv:orbit:hasNextPatch{
    set result to ABS(mnv:orbit:nextPatch:periapsis-desired_periapsis).
  } else {
    set result to 2^64.
  }
  removeManeuverFromFlightPlan(mnv).
  return result.
}
function scoreDiffApoapsisHeightNextPatch {
  // a search function that gives the difference between the apoapsis and the desired apoapsis in the next patch.
  parameter data, extra_parameters.
  local desired_apoapsis is extra_parameters[0].

  local mnv is node(data[0], data[1], data[2], data[3]).
  addManeuverToFlightPlan(mnv).
  local result is 0.
  if mnv:orbit:hasNextPatch{
    set result to ABS(mnv:orbit:nextPatch:apoapsis-desired_apoapsis).
  } else {
    set result to 2^64.
  }
  removeManeuverFromFlightPlan(mnv).
  return result.
}
function scoreDiffDistanceApoapsis {
  // a search function that gives the difference between the distance of two objects when the ship is at the apoapsis and a desired_distance.
  parameter data, extra_parameters.
  local object_1 is extra_parameters[0].
  local object_2 is extra_parameters[1].
  local desired_distance is extra_parameters[2].

  local mnv is node(data[0], data[1], data[2], data[3]).
  addManeuverToFlightPlan(mnv).
  local result is 0.
  if mnv:orbit:hasnextpatch {
    set result to 2^64.
  } else{
    local ApoapsisTime is FindApoapsisTime(mnv).
    local distance is GetDistanceBetween2Objects(object_1, object_2, ApoapsisTime).
    set result to ABS(distance-desired_distance).
  }
  removeManeuverFromFlightPlan(mnv).
  return result.
}
function scoreDiffDistancePeriapsis {
  // a search function that gives the difference between the distance of two objects when the ship is at the periapsis and a desired_distance.
  parameter data, extra_parameters.
  local object_1 is extra_parameters[0].
  local object_2 is extra_parameters[1].
  local desired_distance is extra_parameters[2].

  local mnv is node(data[0], data[1], data[2], data[3]).
  addManeuverToFlightPlan(mnv).
  local PeriapsisTime is FindPeriapsiTime(mnv).
  local distance is GetDistanceBetween2Objects(object_1, object_2, PeriapsisTime).
  local result is ABS(distance-desired_distance).
  removeManeuverFromFlightPlan(mnv).
  return result.
}
function eccentricityScore {
  // a search function that gives the eccentricity of an orbit.
  parameter data, extra_parameters.
  local mnv is node(data[0], data[1], data[2], data[3]).
  addManeuverToFlightPlan(mnv).
  local result is mnv:orbit:eccentricity.
  removeManeuverFromFlightPlan(mnv).
  return result.
}
function inclinationScore {
  // a search function that gives the inclination of an orbit.
  parameter data, extra_parameters.
  local mnv is node(data[0], data[1], data[2], data[3]).
  addManeuverToFlightPlan(mnv).
  local result is mnv:orbit:inclination.
  removeManeuverFromFlightPlan(mnv).
  return result.
}
function inclinationScoreNextPatch {
  // a search function that gives the inclination of an orbit in the next patch.
  parameter data, extra_parameters.
  local mnv is node(data[0], data[1], data[2], data[3]).
  addManeuverToFlightPlan(mnv).
  local result is 0.
  if mnv:orbit:hasNextPatch{
    set result to mnv:orbit:nextPatch:inclination.
  } else {
    set result to 2^64.
  }
  removeManeuverFromFlightPlan(mnv).
  return result.
}
function transferScore{
  // a search function used for the doTransferToBody. this function will first minimise the distance between the apoapsis and the transfer_body.
  // Then if the maneuver goes into the patch of the transfer orbit this function minimizes the difference between the periapsis and the desired height of the periapsis.
  parameter data, extra_parameters.
  local transfer_body is extra_parameters[0].
  local desired_height is extra_parameters[1].

  local mnv is node(data[0], data[1], data[2], data[3]).
  addManeuverToFlightPlan(mnv).
  local result is 0.
  if mnv:orbit:hasNextPatch {
    if mnv:orbit:nextpatch:body = transfer_body{
      set result to scoreDiffPeriapsisHeightNextPatch(list(data[0], 0, 0, 0), list(desired_height)).
    } else {
      set result to 2^64.
    }
  } else {
    set result to scoreDiffDistanceApoapsis(list(data[0], 0, 0, 0), list(ship, transfer_body, desired_height)).
  }
  removeManeuverFromFlightPlan(mnv).
  return result.
}
function slingShotScore {
  // a search function used for the doSlingShotToBody. this function will first minimise the distance between the apoapsis and the slingshot_body.
  // Then if the maneuver goes into the patch of the transfer orbit this function maximises the height of the apoapsis in the patch after the patch 
  // of the slingshot_body until the patch after the slingshot_body is the patch of the end_body. Then the function will minimize the difference between
  // the periapsis in the patch of the slingshot_body and the desired_height.
  parameter data, extra_parameters.
  local desired_height is extra_parameters[0].
  local slingshot_body is extra_parameters[1].
  local end_body is extra_parameters[2].
  
  local mnv is node(data[0], data[1], data[2], data[3]).
  addManeuverToFlightPlan(mnv).
  local result is 0.
  if mnv:orbit:hasNextPatch {
    if mnv:orbit:nextpatch:body = slingshot_body{
      if mnv:orbit:nextpatch:nextpatch:body = end_body{
        set result to ABS(mnv:orbit:nextPatch:periapsis-desired_height)-2^64.
      } else {
        set result to -mnv:orbit:nextpatch:nextpatch:apoapsis.
      }
    } else {
      set result to 2^64.
    }
  } else {
    set result to scoreDiffDistanceApoapsis(list(data[0], 0, 0, 0), list(ship, slingshot_body, 0)).
  }
  removeManeuverFromFlightPlan(mnv).
  return result.
}
function lowerInclinationScore {
  // a search function for the doLowerInclination function. It lowers the inclination but also keeps the orbit circular.
  parameter data, extra_parameters.
  local mnv is node(data[0], data[1], data[2], data[3]).
  addManeuverToFlightPlan(mnv).
  local result is mnv:orbit:inclination + 10*mnv:orbit:eccentricity.
  removeManeuverFromFlightPlan(mnv).
  return result.
}

//execute maneuver

function executeManeuver {
  parameter mList, warp_offset, lock_offset.
  local mnv is node(mList[0], mList[1], mList[2], mList[3]).
  addManeuverToFlightPlan(mnv).
  local startTime is calculateStartTime(mnv).
  warpto(startTime - warp_offset).
  wait until time:seconds > startTime - lock_offset.
  lockSteeringAtManeuverTarget(mnv).
  wait until time:seconds > startTime.
  lock throttle to 1.
  until isManeuverComplete(mnv) {
    doAutoStage().
  }
  lock throttle to 0.
  unlock steering.
  removeManeuverFromFlightPlan(mnv).
}
function addManeuverToFlightPlan {
  parameter mnv.
  add mnv.
}
function calculateStartTime {
  parameter mnv.
  return time:seconds + mnv:eta - maneuverBurnTime(mnv) / 2.
}
function maneuverBurnTime {
  parameter mnv.
  local dV is mnv:deltaV:mag.
  local g0 is 9.80665.
  local isp is 0.

  list engines in myEngines.
  for en in myEngines {
    if en:ignition and not en:flameout {.
      set isp to isp + (en:isp * (en:availableThrust / ship:availableThrust)).
    }
  }

  if isp = 0{
    print("Error there is no available thrust").
  }

  local mf is ship:mass / constant():e^(dV / (isp * g0)).
  local fuelFlow is ship:availableThrust / (isp * g0).
  local t is (ship:mass - mf) / fuelFlow.

  return t.
}
function lockSteeringAtManeuverTarget {
  parameter mnv.
  lock steering to mnv:burnvector.

}
function isManeuverComplete {
  parameter mnv.
  if not(defined originalVector) or originalVector = -1 {
    declare global originalVector to mnv:burnvector.
  }
  if vang(originalVector, mnv:burnvector) > 90 {
    declare global originalVector to -1.
    return true.
  }
  return false.
}
function removeManeuverFromFlightPlan {
  parameter mnv.
  remove mnv.
}

//helper functions

function getDistanceBetween2Objects {
  parameter object_1, object_2, time_point.
  local position_1 is GetPositionOfObject(object_1, time_point).
  local position_2 is GetPositionOfObject(object_2, time_point).
  local distance is (position_2-position_1).
  return distance:mag.
}
function getObject {
  parameter name, type.
  local object is 0.
  if type = "vessel"{
    set object to vessel(name).
  } else if type = "body"{
    set object to body(name).
  } else if type = "ship"{
    set object to ship.
  } else {
    print("error: no valid type was given").
  }
  return object.
}
function getPositionOfObject {
  parameter object, timepoint.
  local position is positionAt(object, timepoint).
  if object = sun{
    return position.
  } else{
    until false{
      if object = sun{
        set position to (position+(positionAt(sun, timepoint)-positionAt(sun, time:seconds))).
        return position.
      } else{
        set position to (position+(positionAt(object:body, timepoint)-positionAt(object:body, time:seconds))).
        set object to object:body.
      }
    }
  }
  }
 
function findApoapsisTime {
  parameter mnv.
  local apoapsisTime is ternarySearch(
    altitudeAtNeg@,
    ship:body, 
    time:seconds + mnv:eta, 
    time:seconds + mnv:eta + mnv:orbit:period,
    1
  ).
  return apoapsisTime.
}
function findPeriapsiTime {
  parameter mnv.
  local periapsisTime is ternarySearch(
    altitudeAt@,
    ship:body, 
    time:seconds + mnv:eta, 
    time:seconds + mnv:eta + mnv:orbit:period,
    1
  ).
  return periapsisTime.
}
function findApoapsisTimeNextPatch {
  parameter mnv.
  local apoapsisTime is ternarySearch(
    altitudeAt@,
    mnv:orbit:nextpatch:body, 
    time:seconds + mnv:eta, 
    time:seconds + mnv:eta + mnv:orbit:period,
    1
  ).
  return apoapsisTime.
}
function findPeriapsiTimeNextPatch {
  parameter mnv.
  local periapsisTime is ternarySearch(
    altitudeAtneg@,
    mnv:orbit:nextpatch:body, 
    time:seconds + mnv:eta, 
    time:seconds + mnv:eta + mnv:orbit:period,
    1
  ).
  return periapsisTime.
}
function altitudeAt {
  parameter t, ship_body.
  return ship_body:altitudeOf(positionAt(ship, t)).
}
function altitudeAtNeg {
  parameter t, ship_body.
  return -ship_body:altitudeOf(positionAt(ship, t)).
}

// launch to orbit functions

function doLaunch {
  parameter amount_of_stages.
  lock throttle to 1.
  doSafeStage(amount_of_stages).
}
function doAscent {
  lock targetPitch to 88.963 - 1.03287 * alt:radar^0.409511.
  set targetDirection to 90.
  lock steering to heading(targetDirection, targetPitch).
}
function doAutoStage {
  if not(defined oldThrust) {
    global oldThrust is ship:availablethrust.
  }
  if ship:availablethrust < (oldThrust - 10) {
    until false {
      doSafeStage(1).
      if ship:availableThrust > 0 { 
        break.
      }
    }
  }
}
function doShutdown {
  lock throttle to 0.
  lock steering to prograde.
}
function doCircularization {
  local circ is list(time:seconds + eta:apoapsis, 0, 0, 0).
  set circ to improveConverge(circ, list(3), eccentricityScore@, false, list(100, 10, 1)).
  wait until altitude > 70000.
  executeManeuver(circ, 15, 10).
  wait 1.
}

// landing on mun functions

function stopOrbitAtDarkSideWithOffset {
  parameter angle_offset.

  declare angular_vel is 2*constant:pi/orbit:period.
  declare time_offset is (angle_offset * constant:DegToRad) / angular_vel.

  declare rotation_dir is vectorCrossProduct(ship:velocity:surface, v(0, 1 ,0)).

  // Determine if the cross product is positive or negative to decide orbit direction
  IF rotation_dir:Z > 0 {
      set time_offset to time_offset * -1.
      set angle_offset to angle_offset * -1.
  } 

  print "Radian offset: " + angle_offset + ", Time offset: " + time_offset.
  local startTime is ternarySearch(diffFromDistanceNeg@, list(ship, kerbin, 0), time:seconds + 30, time:seconds + 30 + orbit:period, 1).
  local init_manv is list(startTime + time_offset, 0, 0, -ship:groundspeed).
  executeManeuver(init_manv, 15, 10).
  wait 1.
}


function distanceToKerbinFromMoon {
  parameter t, extra_parameters.
  local distance is GetDistanceBetween2Objects(ship, kerbin, t).
  return distance.
}
function doHoverslam {
  SET WARPMODE TO "PHYSICS".
  lock steering to srfRetrograde.
  lock pct to stoppingDistance() / distanceToGround().
  set warp to 4.
  wait until pct > 0.01.
  set warp to 3.
  wait until pct > 0.1.
  set warp to 0.
  wait until pct > 0.95.
  lock throttle to pct.
  when distanceToGround() < 500 then { gear on. }
  wait until ship:verticalSpeed > 0.
  lock throttle to 0.
  lock steering to groundSlope().
  wait 30.
  unlock steering.
}
function distanceToGround {
  return altitude - body:geopositionOf(ship:position):terrainHeight - 4.7.
}
function stoppingDistance {
  local grav is constant():g * (body:mass / body:radius^2).
  local maxDeceleration is (ship:availableThrust / ship:mass) - grav.
  return ship:verticalSpeed^2 / (2 * maxDeceleration).
}
function groundSlope {
  local east is vectorCrossProduct(north:vector, up:vector).

  local center is ship:position.

  local a is body:geopositionOf(center + 5 * north:vector).
  local b is body:geopositionOf(center - 3 * north:vector + 4 * east).
  local c is body:geopositionOf(center - 3 * north:vector - 4 * east).

  local a_vec is a:altitudePosition(a:terrainHeight).
  local b_vec is b:altitudePosition(b:terrainHeight).
  local c_vec is c:altitudePosition(c:terrainHeight).

  return vectorCrossProduct(c_vec - a_vec, b_vec - a_vec):normalized.
}

function doDeploySolarPanels {
    // This function will deploy the solar panels
    local panels is ship:modulesnamed("ModuleDeployableSolarPanel").
    local deployedCount is 0.  // Added missing counter initialization
    
    for panel in panels {
        // Check if panel is retracted
        if panel:getfield("status") = "Retracted" {
            // Use "extend solar panel" instead of "deploy"
            panel:doaction("extend solar panel", true).
            set deployedCount to deployedCount + 1.
            wait 0.1. // Small delay between deployments
        }
    }
    
    print "Deployment complete. " + deployedCount + " panels deployed.".
    wait 1.
}

function doFollowMun {
  local desired_distance is Mun:soiradius + 50_000.
  local desired_height is Mun:altitude - 400_000.
  local init_manv is list(time:seconds + orbit:period, 0, 0, 0).

  declare apoapsis_manv to findManeuver(init_manv, list(0, 3), scoreDiffApoapsisHeight@, list(desired_height), list(100, 20, 10, 1)).
  print apoapsis.
  
  set manv to findManeuver(apoapsis_manv, list(0), scoreDiffDistanceApoapsisRaw@, list(ship, Mun, desired_distance), list(100, 20, 10, 1)).
  
  executeManeuver(manv, 15, 10).
  wait 1.
}

function scoreDiffDistanceApoapsisRaw {
  // a search function that gives the difference between the distance of two objects when the ship is at the apoapsis and a desired_distance.
  parameter data, extra_parameters.
  local object_1 is extra_parameters[0].
  local object_2 is extra_parameters[1].
  local desired_distance is extra_parameters[2].

  local mnv is node(data[0], data[1], data[2], data[3]).
  addManeuverToFlightPlan(mnv).
  local result is 0.
  if mnv:orbit:hasnextpatch {
    set result to 2^64.
  } else{
    local ApoapsisTime is FindApoapsisTime(mnv).
    local distance is GetDistanceBetween2Objects(object_1, object_2, ApoapsisTime).
    set result to (distance-desired_distance).
  }
  removeManeuverFromFlightPlan(mnv).
  return result.
}

