class SwatCheatManager extends CheatManager within SwatPlayerController
	native;

var private bool bUserHidAIs;
var private bool bDebugGrenades;

exec function Help()
{
	Log("--------------------------------------------------------------------");
	Log("              SwatCheatManager available functions");
	Log("--------------------------------------------------------------------");
	Log("");
	Log("---------- QA stuff ----------");
	Log("");
	Log("Loc: Print player location/rotation to the log file");
	Log("OpenDoorsToLeft: Opens all doors in the level to the left");
	Log("OpenDoorsToRight: Opens all doors in the level to the right");
	Log("");
	Log("---------- HUD/GUI stuff ----------");
	Log("");
	Log("ToggleGUI: Turn GUI/HUD rendering on/off");
	Log("ShowHands or HandsDown: Turn First-person hands & weapon rendering on/off");
	Log("ToggleWatermark: Turn screenshot watermark (version, %complete, etc) on/off");
	Log("");
	Log("---------- AI stuff ----------");
	Log("");
	Log("HideAI: Hides all AIs");
	Log("ShowAI: Shows hidden AIs");
	Log("DebugAIs: Turn on/off AI debug info");
	Log("DebugTyrion: Turn on/off all Tyrion debug info");
	Log("DebugTyrionCharacter: Turn on/off Tyrion Character debug info");
	Log("DebugTyrionMovement: Turn on/off Tyrion Movement debug info");
	Log("DebugTyrionWeapon: Turn on/off Tyrion Weapon debug info");
	Log("DisableVision <optional: AI Class (ie. SwatEnemy)>: Disables AI vision");
	Log("EnableVision <optional: AI Class (ie. SwatEnemy)>: Enables vision for AIs whose vision has been disabled");
	Log("DisableHearing <optional: AI Class (ie. SwatEnemy)>: Disables AI hearing");
	Log("EnableHearing <optional: AI Class (ie. SwatEnemy)>: Enables hearing for AIs whose hearing has been disabled");
	Log("ToggleAIHiddenState: Toggle between ShowAI/HideAI");
	Log("DebugMorale: Turn on/off morale debugging info");
	Log("EveryoneComply: Asks all enemy/hostage AIs to comply");
	Log("DisableAwareness <optional: AI Class (ie. SwatEnemy)>: Disables the awareness system of AIs");
	Log("EnableAwareness <optional: AI Class (ie. SwatEnemy)>: Enables the awareness system of AIs whose awareness has been disabled");
	Log("DisableCollisionAvoidance <optional: AI Class (ie. SwatEnemy)>: Disables collision avoidance");
	Log("EnableCollisionAvoidance <optional: AI Class (ie. SwatEnemy)>: Enables collision avoidance");
	Log("MakeAIGod <optional: AI Class (ie. SwatEnemy)>: Makes particular types unhurtable (defaults to all AIs)");
	Log("");
	Log("---------- Cover stuff ----------");
	Log("");
	Log("DebugCover <name of pawn taking cover>: Shows 'true' cover area for specified pawn (i.e., intersection of per-officer cover extrusions)");
	Log("DebugCover2 <name of pawn taking cover>: 'DebugCover' functionality PLUS per-officer cover extrusions for cover plane");
	Log("DebugCover3 <name of pawn taking cover>: 'DebugCover2' functionality PLUS extrusion from each officer to the cover plane");
	Log("");
	Log("---------- Weapon stuff ----------");
	Log("");
	Log("DebugBallistics: Toggles debugging ballistics on and off.  When on, ballistics information will be logged for each shot fired.");
	Log("UseAmmo <Ammo class>: Use the specified ammunition class with your current weapon, Eg. 'useammo fullmetaljacket'");
	Log("ToggleRecoil: Turns recoil on and off");
	Log("FlashlightLines <0 or 1>: Turns debug flashlight lines on and off");
	Log("FlashlightFancy <0 or 1>: Selects Flashlight spot lights (true) or point lights (false)");
	Log("DebugGrenades: Toggles debugging of grenades on and off.  When on, trajectories and radii of affect are drawn.");
	Log("");
	Log("---------- Weapon ScreenEffect stuff ----------");
	Log("");
	Log("GetSprayed:   Runs camera effect for Pepper Spray (with 0 damage).");
	Log("GetGassed:    Runs camera effect for CS Gas (similar to Pepper Spray) (with 0 damage).");
	Log("GetTased:     Runs camera effect for Taser (with 0 damage).");
	Log("GetStung:     Runs camera effect for Sting Grenade (with 0 damage).");
	Log("GetLLShotgun: Runs camera effect for Less Lethal Shotgun (similar to Sting Grenade) (with 0 damage).");
	Log("---------- For editing ScreenEffect Parameters:");
	Log("editClass paramsClass: Where paramsClass is one of: ");
	Log("  DesignerStingParams, DesignerPepperSprayParams, DesignerCSGasParams, DesignerLessLethalSGParams");
	Log("");
	Log("---------- Archetypes/Spawning stuff ----------");
	Log("");
	Log("SummonArchetype <'Enemy' / 'Hostage' / 'Inanimate'>, <Archetype name>: Spawns an instance of the specified archetype in front of the player.  Eg. 'summonarchetype enemy arms_dealer'");
	Log("TestSpawn <Count>: Simulate spawning for the current level Count times.  Nothing is actually spawned.  But results of the simulation are logged.");
	Log("TestSpawn (no count): Spawn a 'TestSpawn' Archetype at each Enemy and Hostage Spawner.");
	Log("UsePrimaryEntry <1 or 0>: if 1, singleplayer missions will use the primary entry point. If 0, they will use the secondary entry point");
	Log("");
	Log("---------- Sound/Visual FX stuff ----------");
	Log("");
	Log("DebugEffectEvent <EffectEvent>: log the details of TriggerEffectEvent() each time EffectEvent is triggered.");
	Log("DumpEffects <'Visual' / 'Sound'>: Logs the state of the specified effects subsystem.");
	Log("");
	Log("---------- Leadership/Objectives stuff ----------");
	Log("");
	Log("MissionStatus: Log the current mission status");
	Log("LeadershipStatus: Log the current leadership status & scores");
	Log("");
	Log("---------- Rendering Stuff ----------");
	Log("");
	Log("RenderDetail <0-3>: Globally adjusts ALL other rendering settings; 3 is highest detail, 0 is lowest");
	Log("TextureDetail <0-3>: Changes texture detail (size); 3 is highest detail, 0 is lowest");
	Log("BumpDetail <0-3>: Changes bumpmapping settings. 3 = characters+staticmesh+bsp+emitters, 2 = characters+staticmesh; 1 = static mesh, 0 = nothing");
	Log("");
	Log("---------- Profiling Stuff ----------");
	Log("");
	Log("EnableProfile: Turn on profiling of function calls");
	Log("TickProfile: Enable profiling of time spent in Tick() on a per-class basis");
	Log("ResetProfile: Rest the profiling stats");
	Log("LogProfile: Dump the current profile to the log");
	Log("");
	Log("---------- Debugging Stuff ----------");
	Log("");
	Log("stat anim: Show details on what animations are playing");
	Log("show projectorbounds: Show bounds of projectors in-game.");
	Log("show actors: turn on/off rendering of actors");
	Log("show actorinfo: turn on/off rendering of actor info");
	Log("show staticmesh: turn on/off rendering of static meshes");
	Log("show fog: turn on/off rendering of fog");
	Log("show sky: turn on/off rendering of skyzone");
	Log("show corona: turn on/off rendering of coronas");
	Log("show particle: turn on/off rendering of particles");
	Log("show bsp: turn on/off rendering of bsp surfaces");
	Log("show radii: turn on/off rendering of radii for things using cylinder collision");
	Log("show fluid: turn on/off rendering of fluid surfaces");
	Log("show projector: turn on/off rendering of dynamic projectors");
	Log("show collision: Show non-havok collision bounds. Dynamic objects are in pink. Also show bone collision boxes.");
	Log("rend collision: Show pawn collision. If pawn is on top of something, show that thing in yellow and draw line to it");
	Log("AnimDrawDebugLines: Show where the pawns should be aiming");
	Log("DebugAIMovement: Show where the AIs think they are going");
	Log("rend bound: Show the rendering bounding sphere/box for skeletal");
	Log("            meshes (blue), the render bounding box for static meshes (green),");
	Log("            the predicted render bounding box (red) and the emitter bounds (yellow)");
	Log("ListVisibleSprites: writes to the log the identity of any 'dragon-camel' icons appearing in the game.");
	Log("");
	Log("--------------------------------------------------------------------");
	return;
}

// Export USwatCheatManager::execToggleWatermark(FFrame&, void* const)
native exec function ToggleWatermark();

exec function HideAI()
{
	local SwatAI TheAI;

	foreach Outer.AllActors(Class'SwatGame.SwatAI', TheAI)
	{
		Log(Concat_StrStr(Concat_StrStr("SwatCheatManager: Hiding SwatAI \"", string(TheAI)), "\""));
		TheAI.Hide();
	}
	bUserHidAIs = true;
	return;
}

exec function ShowAI()
{
	local SwatAI TheAI;

	foreach Outer.AllActors(Class'SwatGame.SwatAI', TheAI)
	{
		Log(Concat_StrStr(Concat_StrStr("SwatCheatManager: Unhiding SwatAI \"", string(TheAI)), "\""));
		TheAI.Show();
	}
	bUserHidAIs = false;
	return;
}

exec function ToggleAIHiddenState()
{
	if(bUserHidAIs)
	{
		ShowAI();
	}
	else
	{
		HideAI();
	}
	return;
}

exec function EveryoneComply()
{
	local SwatAI IterAI;

	foreach Outer.AllActors(Class'SwatGame.SwatAI', IterAI)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("SwatCheatManager: Telling SwatAI ", string(IterAI)), " to comply using "), string(Outer.Pawn)));
		assert(NotEqual_ObjectObject(SwatCharacterResource(IterAI.CharacterAI).CommonSensorAction.GetComplySensor(), none));
		SwatCharacterResource(IterAI.CharacterAI).CommonSensorAction.GetComplySensor().NotifyComply(Outer.Pawn);
	}
	return;
}

exec function AnimDrawDebugLines()
{
	local SwatPawn SwatPawn;

	foreach Outer.AllActors(Class'SwatGame.SwatPawn', SwatPawn)
	{
		SwatPawn.ToggleAnimDrawDebugLines();
	}
	return;
}

exec function DebugPathLines()
{
	local SwatAI SwatAI;

	foreach Outer.AllActors(Class'SwatGame.SwatAI', SwatAI)
	{
		SwatAI.ToggleDebugPathLines();
	}
	return;
}

exec function DebugAIs()
{
	local SwatAI SwatAI;

	foreach Outer.AllActors(Class'SwatGame.SwatAI', SwatAI)
	{
		SwatAI.bShowBlackboardDebugInfo = Not_PreBool(SwatAI.bShowBlackboardDebugInfo);
	}
	return;
}

exec function DebugTyrion()
{
	DebugTyrionCharacter();
	DebugTyrionMovement();
	DebugTyrionWeapon();
	DebugTyrionHead();
	return;
}

exec function DebugTyrionCharacter()
{
	local SwatAI SwatAI;

	foreach Outer.AllActors(Class'SwatGame.SwatAI', SwatAI)
	{
		SwatAI.bShowTyrionCharacterDebugInfo = Not_PreBool(SwatAI.bShowTyrionCharacterDebugInfo);
	}
	return;
}

exec function DebugTyrionMovement()
{
	local SwatAI SwatAI;

	foreach Outer.AllActors(Class'SwatGame.SwatAI', SwatAI)
	{
		SwatAI.bShowTyrionMovementDebugInfo = Not_PreBool(SwatAI.bShowTyrionMovementDebugInfo);
	}
	return;
}

exec function DebugTyrionWeapon()
{
	local SwatAI SwatAI;

	foreach Outer.AllActors(Class'SwatGame.SwatAI', SwatAI)
	{
		SwatAI.bShowTyrionWeaponDebugInfo = Not_PreBool(SwatAI.bShowTyrionWeaponDebugInfo);
	}
	return;
}

exec function DebugTyrionHead()
{
	local SwatAI SwatAI;

	foreach Outer.AllActors(Class'SwatGame.SwatAI', SwatAI)
	{
		SwatAI.bShowTyrionHeadDebugInfo = Not_PreBool(SwatAI.bShowTyrionHeadDebugInfo);
	}
	return;
}

exec function DebugAIAiming()
{
	local SwatAI SwatAI;

	foreach Outer.AllActors(Class'SwatGame.SwatAI', SwatAI)
	{
		SwatAI.bShowAimingDebugInfo = Not_PreBool(SwatAI.bShowAimingDebugInfo);
	}
	return;
}

exec function DisableAwareness(optional Class<SwatAI> OptionalAIClass)
{
	local Actor AI;
	local Class<SwatAI> AIClass;

	if(EqualEqual_ObjectObject(OptionalAIClass, none))
	{
		AIClass = Class'SwatGame.SwatAI';
	}
	else
	{
		AIClass = OptionalAIClass;
	}
	foreach Outer.DynamicActors(AIClass, AI)
	{
		SwatAI(AI).DisableAwareness();
	}
	Outer.ClientMessage(At_StrStr("Awareness now disabled for all:", string(AIClass.Name)));
	return;
}

exec function EnableAwareness(optional Class<SwatAI> OptionalAIClass)
{
	local Actor AI;
	local Class<SwatAI> AIClass;

	if(EqualEqual_ObjectObject(OptionalAIClass, none))
	{
		AIClass = Class'SwatGame.SwatAI';
	}
	else
	{
		AIClass = OptionalAIClass;
	}
	foreach Outer.DynamicActors(AIClass, AI)
	{
		SwatAI(AI).EnableAwareness();
	}
	Outer.ClientMessage(At_StrStr("Awareness now enabled for all:", string(AIClass.Name)));
	return;
}

exec function DisableCollisionAvoidance(optional Class<SwatAI> OptionalAIClass)
{
	local Actor AI;
	local Class<SwatAI> AIClass;

	if(EqualEqual_ObjectObject(OptionalAIClass, none))
	{
		AIClass = Class'SwatGame.SwatAI';
	}
	else
	{
		AIClass = OptionalAIClass;
	}
	foreach Outer.DynamicActors(AIClass, AI)
	{
		SwatAI(AI).DisableCollisionAvoidance();
	}
	Outer.ClientMessage(At_StrStr("Collision Avoidance now disabled for all:", string(AIClass.Name)));
	return;
}

exec function EnableCollisionAvoidance(optional Class<SwatAI> OptionalAIClass)
{
	local Actor AI;
	local Class<SwatAI> AIClass;

	if(EqualEqual_ObjectObject(OptionalAIClass, none))
	{
		AIClass = Class'SwatGame.SwatAI';
	}
	else
	{
		AIClass = OptionalAIClass;
	}
	foreach Outer.DynamicActors(AIClass, AI)
	{
		SwatAI(AI).EnableCollisionAvoidance();
	}
	Outer.ClientMessage(At_StrStr("Collision Avoidance now disabled for all:", string(AIClass.Name)));
	return;
}

exec function DisableVision(optional Class<SwatAI> OptionalAIClass)
{
	local Actor AI;
	local Class<SwatAI> AIClass;

	if(EqualEqual_ObjectObject(OptionalAIClass, none))
	{
		AIClass = Class'SwatGame.SwatAI';
	}
	else
	{
		AIClass = OptionalAIClass;
	}
	foreach Outer.DynamicActors(AIClass, AI)
	{
		SwatAI(AI).DisableVision(false);
	}
	Outer.ClientMessage(At_StrStr("Vision now disabled for all:", string(AIClass.Name)));
	return;
}

exec function EnableVision(optional Class<SwatAI> OptionalAIClass)
{
	local Actor AI;
	local Class<SwatAI> AIClass;

	if(EqualEqual_ObjectObject(OptionalAIClass, none))
	{
		AIClass = Class'SwatGame.SwatAI';
	}
	else
	{
		AIClass = OptionalAIClass;
	}
	foreach Outer.DynamicActors(AIClass, AI)
	{
		SwatAI(AI).EnableVision();
	}
	Outer.ClientMessage(At_StrStr("Vision now enabled for all:", string(AIClass.Name)));
	return;
}

exec function EnableHearing(optional Class<SwatAI> OptionalAIClass)
{
	local Actor AI;
	local Class<SwatAI> AIClass;

	if(EqualEqual_ObjectObject(OptionalAIClass, none))
	{
		AIClass = Class'SwatGame.SwatAI';
	}
	else
	{
		AIClass = OptionalAIClass;
	}
	foreach Outer.DynamicActors(AIClass, AI)
	{
		SwatAI(AI).EnableHearing();
	}
	Outer.ClientMessage(At_StrStr("Hearing now enabled for all:", string(AIClass.Name)));
	return;
}

exec function DisableHearing(optional Class<SwatAI> OptionalAIClass)
{
	local Actor AI;
	local Class<SwatAI> AIClass;

	if(EqualEqual_ObjectObject(OptionalAIClass, none))
	{
		AIClass = Class'SwatGame.SwatAI';
	}
	else
	{
		AIClass = OptionalAIClass;
	}
	foreach Outer.DynamicActors(AIClass, AI)
	{
		SwatAI(AI).DisableHearing(false);
	}
	Outer.ClientMessage(At_StrStr("Hearing now disabled for all:", string(AIClass.Name)));
	return;
}

exec function MakeAIsGod(optional Class<SwatAI> OptionalAIClass)
{
	MakeAIGod(OptionalAIClass);
	return;
}

exec function MakeAIGod(optional Class<SwatAI> OptionalAIClass)
{
	local Actor AI;
	local Class<SwatAI> AIClass;

	if(EqualEqual_ObjectObject(OptionalAIClass, none))
	{
		AIClass = Class'SwatGame.SwatAI';
	}
	else
	{
		AIClass = OptionalAIClass;
	}
	foreach Outer.DynamicActors(AIClass, AI)
	{
		SwatAI(AI).Controller.bGodMode = Not_PreBool(SwatAI(AI).Controller.bGodMode);
	}
	Outer.ClientMessage(At_StrStr("MakeAIGod called on all: ", string(AIClass.Name)));
	return;
}

exec function logTyrion(optional Class<SwatAI> OptionalAIClass)
{
	local Actor AI;
	local Class<SwatAI> AIClass;

	if(EqualEqual_ObjectObject(OptionalAIClass, none))
	{
		AIClass = Class'SwatGame.SwatAI';
	}
	else
	{
		AIClass = OptionalAIClass;
	}
	foreach Outer.DynamicActors(AIClass, AI)
	{
		SwatAI(AI).logTyrion = Not_PreBool(SwatAI(AI).logTyrion);
	}
	return;
}

exec function logAI(optional Class<SwatAI> OptionalAIClass)
{
	local Actor AI;
	local Class<SwatAI> AIClass;

	if(EqualEqual_ObjectObject(OptionalAIClass, none))
	{
		AIClass = Class'SwatGame.SwatAI';
	}
	else
	{
		AIClass = OptionalAIClass;
	}
	foreach Outer.DynamicActors(AIClass, AI)
	{
		SwatAI(AI).logAI = Not_PreBool(SwatAI(AI).logAI);
	}
	return;
}

exec function AILowReady(optional Class<SwatAI> OptionalAIClass)
{
	local Actor AI;
	local Class<SwatAI> AIClass;

	if(EqualEqual_ObjectObject(OptionalAIClass, none))
	{
		AIClass = Class'SwatGame.SwatAI';
	}
	else
	{
		AIClass = OptionalAIClass;
	}
	foreach Outer.DynamicActors(AIClass, AI)
	{
		SwatAI(AI).SetUpperBodyAnimBehavior(1);
		SwatAI(AI).SetLowReady(Not_PreBool(SwatAI(AI).IsLowReady()));
	}
	return;
}

exec function AIUpperBodyOn(optional Class<SwatAI> OptionalAIClass)
{
	local Actor AI;
	local Class<SwatAI> AIClass;

	if(EqualEqual_ObjectObject(OptionalAIClass, none))
	{
		AIClass = Class'SwatGame.SwatAI';
	}
	else
	{
		AIClass = OptionalAIClass;
	}
	foreach Outer.DynamicActors(AIClass, AI)
	{
		SwatAI(AI).SetUpperBodyAnimBehavior(2);
	}
	return;
}

exec function AIUpperBodyOff(optional Class<SwatAI> OptionalAIClass)
{
	local Actor AI;
	local Class<SwatAI> AIClass;

	if(EqualEqual_ObjectObject(OptionalAIClass, none))
	{
		AIClass = Class'SwatGame.SwatAI';
	}
	else
	{
		AIClass = OptionalAIClass;
	}
	foreach Outer.DynamicActors(AIClass, AI)
	{
		SwatAI(AI).SetUpperBodyAnimBehavior(0);
	}
	return;
}

exec function OpenDoorsToLeft()
{
	local NavigationPoint Iter;
	local SwatDoor Door;

	Iter = Outer.Level.NavigationPointList;
	J0x1D:

	if(NotEqual_ObjectObject(Iter, none))
	{
		Door = SwatDoor(Iter);
		if(NotEqual_ObjectObject(Door, none))
		{
			Door.SetPositionForMove(1, 0);
			Door.Moved(true);
		}
		Iter = Iter.nextNavigationPoint;
		// [Loop Continue]
		goto J0x1D;
	}
	return;
}

exec function OpenDoorsToRight()
{
	local NavigationPoint Iter;
	local SwatDoor Door;

	Iter = Outer.Level.NavigationPointList;
	J0x1D:

	if(NotEqual_ObjectObject(Iter, none))
	{
		Door = SwatDoor(Iter);
		if(NotEqual_ObjectObject(Door, none))
		{
			Door.SetPositionForMove(2, 0);
			Door.Moved(true);
		}
		Iter = Iter.nextNavigationPoint;
		// [Loop Continue]
		goto J0x1D;
	}
	return;
}

exec function LockAllDoors()
{
	local NavigationPoint Iter;
	local SwatDoor Door;

	Iter = Outer.Level.NavigationPointList;
	J0x1D:

	if(NotEqual_ObjectObject(Iter, none))
	{
		Door = SwatDoor(Iter);
		if(AndAnd_BoolBool(NotEqual_ObjectObject(Door, none), Door.CanBeLocked()))
		{
			Door.Lock();
		}
		Iter = Iter.nextNavigationPoint;
		// [Loop Continue]
		goto J0x1D;
	}
	return;
}

exec function DebugMorale()
{
	local SwatAI SwatAI;

	foreach Outer.AllActors(Class'SwatGame.SwatAI', SwatAI)
	{
		SwatAI.bShowMoraleHistoryDebugInfo = Not_PreBool(SwatAI.bShowMoraleHistoryDebugInfo);
	}
	return;
}

exec function SummonArchetype(name ArchetypeKind, name ArchetypeName)
{
	local Class<Archetype> ArchetypeClass;
	local Archetype Archetype;
	local Pawn PlayerPawn;
	local Class<Actor> ClassToSpawn;
	local Actor Summoned;

	switch(ArchetypeKind)
	{
		case 'Enemy':
			ArchetypeClass = Class'SwatGame.EnemyArchetype';
			break;
		case 'Hostage':
			ArchetypeClass = Class'SwatGame.HostageArchetype';
			break;
		case 'Inanimate':
			ArchetypeClass = Class'SwatGame.InanimateArchetype';
			break;
		default:
			Log(Concat_StrStr(Concat_StrStr("Unexpected ArchetypeKind ", string(ArchetypeKind)), " specified."));
			break;
	}
	PlayerPawn = Outer.Level.GetLocalPlayerController().Pawn;
	Archetype = ArchetypeClass.static.Allocate(self, none, string(ArchetypeName), 0).;
	Construct_Void();
	if(EqualEqual_ObjectObject(Archetype, none))
	{
		Log(Concat_StrStr("SummonArchetype: Couldn't instantiate a new Archetype of class ", string(ArchetypeClass)));
		return;
	}
	Archetype.Initialize(Outer.Level);
	ClassToSpawn = Archetype.PickClass();
	assert(NotEqual_ObjectObject(ClassToSpawn, none));
	Summoned = Outer.Spawn(ClassToSpawn,,, Add_VectorVector(Add_VectorVector(PlayerPawn.Location, Multiply_FloatVector(float(70), Vector(PlayerPawn.Rotation))), vect(1.0000000, 1.0000000, 15.0000000)));
	if(EqualEqual_ObjectObject(Summoned, none))
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("SummonArchetype: Couldn't Spawn an instance of Class ", string(ClassToSpawn)), ".  (selected to spawn from Archetype "), string(Archetype)), ")"));
		return;
	}
	Archetype.InitializeSpawned(IUseArchetype(Summoned), none);
	return;
}

exec function DebugBallistics()
{
	Outer.Level.AnalyzeBallistics = Not_PreBool(Outer.Level.AnalyzeBallistics);
	return;
}

exec function FlashlightLines(bool onState)
{
	local FiredWeapon TheWeapon;

	foreach Outer.AllActors(Class'Engine.FiredWeapon', TheWeapon)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("SwatCheatManager: Changing Flashlight debug line visibility for \"", string(TheWeapon)), "\" to: "), string(onState)));
		TheWeapon.DebugDrawFlashlightDir = onState;
	}
	return;
}

exec function FlashlightFancy(bool onState)
{
	local FiredWeapon TheWeapon;

	foreach Outer.AllActors(Class'Engine.FiredWeapon', TheWeapon)
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("SwatCheatManager: Changing Flashlight point/spot type for \"", string(TheWeapon)), "\" to: "), string(onState)));
		if(onState)
		{
			TheWeapon.FlashlightUseFancyLights = 1;
			continue;
		}
		TheWeapon.FlashlightUseFancyLights = 0;
	}
	return;
}

exec function GetTased()
{
	SwatPlayer(Outer.Level.GetLocalPlayerController().Pawn).ReactToBeingTased(none, 10.0000000, 4.0000000);
	return;
}

exec function GetSprayed()
{
	local bool bTestingEffects;

	bTestingEffects = SwatPlayer(Outer.Level.GetLocalPlayerController().Pawn).bTestingCameraEffects;
	SwatPlayer(Outer.Level.GetLocalPlayerController().Pawn).bTestingCameraEffects = true;
	SwatPlayer(Outer.Level.GetLocalPlayerController().Pawn).ReactToBeingPepperSprayed(none, 10.0000000, 4.0000000, 0.0000000, 0.0000000);
	SwatPlayer(Outer.Level.GetLocalPlayerController().Pawn).bTestingCameraEffects = bTestingEffects;
	return;
}

exec function GetGassed()
{
	local SwatGrenadeProjectile Gasser;
	local Class<SwatGrenadeProjectile> GrenadeClass;
	local Vector Offset;
	local bool bTestingEffects;

	Offset.X = 10.0000000;
	Offset.Y = 0.0000000;
	Offset.Z = 0.0000000;
	GrenadeClass = Class<SwatGrenadeProjectile>(DynamicLoadObject("SwatEquipment.CSGasGrenadeProjectile", Class'Core.Class'));
	AssertWithDescription(NotEqual_ObjectObject(GrenadeClass, none), "[henry] Could not find class CSGasGrenadeProjectile in GetGassed().");
	Gasser = Outer.Spawn(GrenadeClass, Outer.Level.GetLocalPlayerController().Pawn,, Add_VectorVector(Outer.Level.GetLocalPlayerController().Pawn.Location, Offset));
	AssertWithDescription(NotEqual_ObjectObject(Gasser, none), "[henry] Could not create class CSGasGrenadeProjectile in GetGassed().");
	Gasser.bHidden = true;
	bTestingEffects = SwatPlayer(Outer.Level.GetLocalPlayerController().Pawn).bTestingCameraEffects;
	SwatPlayer(Outer.Level.GetLocalPlayerController().Pawn).bTestingCameraEffects = true;
	SwatPlayer(Outer.Level.GetLocalPlayerController().Pawn).ReactToCSGas(Gasser, 10.0000000, 0.0000000, 0.0000000);
	SwatPlayer(Outer.Level.GetLocalPlayerController().Pawn).bTestingCameraEffects = bTestingEffects;
	Gasser.Destroy();
	return;
}

exec function GetLLShotgun()
{
	local Range ImpulseRange;

	ImpulseRange.Min = 0.0000000;
	ImpulseRange.Max = 1.0000000;
	SwatPlayer(Outer.Level.GetLocalPlayerController().Pawn).ReactToStingGrenade(none, Outer.Level.GetLocalPlayerController().Pawn, 0.0000000, 10.0000000, ImpulseRange, 10.0000000, 10.0000000, 10.0000000, 6.0000000, 4.0000000, 0.0000000);
	return;
}

exec function GetStung()
{
	local SwatGrenadeProjectile Stinger;
	local Class<SwatGrenadeProjectile> GrenadeClass;
	local Range ImpulseRange;
	local Vector Offset;

	Offset.X = 10.0000000;
	Offset.Y = 0.0000000;
	Offset.Z = 0.0000000;
	GrenadeClass = Class<SwatGrenadeProjectile>(DynamicLoadObject("SwatEquipment.StingGrenadeProjectile", Class'Core.Class'));
	AssertWithDescription(NotEqual_ObjectObject(GrenadeClass, none), "[henry] Could not find class StingGrenadeProjectile in GetStung().");
	Stinger = Outer.Spawn(GrenadeClass, Outer.Level.GetLocalPlayerController().Pawn,, Add_VectorVector(Outer.Level.GetLocalPlayerController().Pawn.Location, Offset));
	AssertWithDescription(NotEqual_ObjectObject(Stinger, none), "[henry] Could not create class StingGrenadeProjectile in GetStung().");
	Stinger.bHidden = true;
	ImpulseRange.Min = 0.0000000;
	ImpulseRange.Max = 1.0000000;
	SwatPlayer(Outer.Level.GetLocalPlayerController().Pawn).ReactToStingGrenade(Stinger, Outer.Level.GetLocalPlayerController().Pawn, 0.0000000, 10.0000000, ImpulseRange, 10.0000000, 10.0000000, 10.0000000, 6.0000000, 4.0000000, 0.0000000);
	Stinger.Destroy();
	return;
}

exec function GetFlashBanged()
{
	local Range ImpulseRange;
	local bool bTestingEffects;

	ImpulseRange.Min = 0.0000000;
	ImpulseRange.Max = 1.0000000;
	bTestingEffects = SwatPlayer(Outer.Level.GetLocalPlayerController().Pawn).bTestingCameraEffects;
	SwatPlayer(Outer.Level.GetLocalPlayerController().Pawn).bTestingCameraEffects = true;
	SwatPlayer(Outer.Level.GetLocalPlayerController().Pawn).ReactToFlashbangGrenade(none, Outer.Level.GetLocalPlayerController().Pawn, 0.0000000, 10.0000000, ImpulseRange, 10.0000000, 100.0000000, 10.0000000, 4.0000000, 0.0000000);
	SwatPlayer(Outer.Level.GetLocalPlayerController().Pawn).bTestingCameraEffects = bTestingEffects;
	return;
}

exec function DebugEffectEvent(name EffectEvent)
{
	EffectsSystem(Outer.Level.EffectsSystem).DebugEffectEvent[EffectsSystem(Outer.Level.EffectsSystem).DebugEffectEvent.Length] = EffectEvent;
	Log(Concat_StrStr(Concat_StrStr("DebugEffectEvent() now debugging '", string(EffectEvent)), "'"));
	return;
}

exec function TestSpawn(int Count)
{
	local SpawningManager SpawningManager;

	SpawningManager = SpawningManager(Outer.Level.SpawningManager);
	AssertWithDescription(NotEqual_ObjectObject(SpawningManager, none), "[tcohen] This map has no SpawningManager in its LevelInfo.  Can't TestSpawn.");
	SpawningManager.TestSpawn(SwatGameInfo(Outer.Level.Game), Count);
	return;
}

exec function UsePrimaryEntry(bool UsePrimary)
{
	local SwatRepo theRepo;

	theRepo = SwatRepo(Outer.Level.GetRepo());
	if(UsePrimary)
	{
		theRepo.SetDesiredEntryPoint(0);
		Outer.ClientMessage("Set desired entry point to PRIMARY");
	}
	else
	{
		theRepo.SetDesiredEntryPoint(1);
		Outer.ClientMessage("Set desired entry point to SECONDARY");
	}
	return;
}

exec function ListVisibleSprites()
{
	local Actor TheActor;

	foreach Outer.AllActors(Class'Engine.Actor', TheActor)
	{
		if(AndAnd_BoolBool(EqualEqual_IntInt(int(TheActor.DrawType), int(1)), EqualEqual_BoolBool(TheActor.bHidden, false)))
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr("FOUND VISIBLE SPRITE: ", string(TheActor)), " at location "), string(TheActor.Location)));
		}
	}
	return;
}

exec function ViewClass(Class<Actor> aClass, optional bool bQuiet, optional bool bCheat)
{
	local SwatGamePlayerController GamePlayerController;

	super.ViewClass(aClass, bQuiet, bCheat);
	GamePlayerController = SwatGamePlayerController(Outer.Level.GetLocalPlayerController());
	GamePlayerController.RefreshCameraEffects(SwatPlayer(GamePlayerController.ViewTarget));
	return;
}

exec function TaseMe()
{
	local SwatGamePlayerController GamePlayerController;

	GamePlayerController = SwatGamePlayerController(Outer.Level.GetLocalPlayerController());
	GamePlayerController.GetCommandInterface().CurrentCommandTeam.DeployTaser(Outer.Pawn, Outer.Pawn.Location, Outer.Pawn);
	return;
}

exec function LogTimers()
{
	local Timer TheTimer;

	foreach Outer.AllActors(Class'Engine.Timer', TheTimer)
	{
		if(NotEqual_ObjectObject(TheTimer, none))
		{
			Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("  Timer: Name=", string(TheTimer.Name)), " Owner="), string(TheTimer.Owner)), " IsRunning="), string(TheTimer.IsRunning())), " LastStartTime="), string(TheTimer.GetLastStartTime())));
		}
	}
	return;
}
