class AnimationSetManager extends Object;

enum EAnimationSet
{
	kAnimationSetNull,              // 0
	kAnimationSetDynamicStanding,   // 1
	kAnimationSetDynamicStandingHeavyArmor,// 2
	kAnimationSetDynamicStandingUpStairs,// 3
	kAnimationSetDynamicStandingDownStairs,// 4
	kAnimationSetStealthStanding,   // 5
	kAnimationSetStealthStandingHeavyArmor,// 6
	kAnimationSetStealthStandingUpStairs,// 7
	kAnimationSetStealthStandingDownStairs,// 8
	kAnimationSetCrouching,         // 9
	kAnimationSetCrouchingHeavyArmor,// 10
	kAnimationSetInjuredStanding,   // 11
	kAnimationSetInjuredStandingUpStairs,// 12
	kAnimationSetInjuredStandingDownStairs,// 13
	kAnimationSetInjuredCrouching,  // 14
	kAnimationSetOfficerInjuredStanding,// 15
	kAnimationSetOfficerInjuredCrouching,// 16
	kAnimationSetCivilianWalk,      // 17
	kAnimationSetCivilianRun,       // 18
	kAnimationSetTrainer,           // 19
	kAnimationSetGangWalkHG,        // 20
	kAnimationSetGangWalkSMG,       // 21
	kAnimationSetGangWalkMG,        // 22
	kAnimationSetGangWalkSG,        // 23
	kAnimationSetGangRunHG,         // 24
	kAnimationSetGangRunSMG,        // 25
	kAnimationSetGangRunMG,         // 26
	kAnimationSetGangRunSG,         // 27
	kAnimationSetGangSprint,        // 28
	kAnimationSetGangSprintHG,      // 29
	kAnimationSetGangSprintSMG,     // 30
	kAnimationSetGangSprintMG,      // 31
	kAnimationSetGangSprintSG,      // 32
	kAnimationSetAICharacterInjuredStanding,// 33
	kAnimationSetAICharacterInjuredStandingUpStairs,// 34
	kAnimationSetAICharacterInjuredStandingDownStairs,// 35
	kAnimationSetAICharacterInjuredCrouching,// 36
	kAnimationSetGangRun,           // 37
	kAnimationSetGangWalk,          // 38
	kAnimationSetEnemyPatrolHG,     // 39
	kAnimationSetEnemyPatrolSMG,    // 40
	kAnimationSetEnemyPatrolMG,     // 41
	kAnimationSetEnemyPatrolSG,     // 42
	kAnimationSetCompliant,         // 43
	kAnimationSetRestrained,        // 44
	kAnimationSetHandgun,           // 45
	kAnimationSetHandgunLowReady,   // 46
	kAnimationSetHandgunCrouched,   // 47
	kAnimationSetHandgunLowReadyCrouched,// 48
	kAnimationSetHandgunExtremeLowReady,// 49
	kAnimationSetSubMachineGun,     // 50
	kAnimationSetSubMachineGunLowReady,// 51
	kAnimationSetSubMachineGunCrouched,// 52
	kAnimationSetSubMachineGunLowReadyCrouched,// 53
	kAnimationSetSubMachineGunExtremeLowReady,// 54
	kAnimationSetMachineGun,        // 55
	kAnimationSetMachineGunLowReady,// 56
	kAnimationSetMachineGunCrouched,// 57
	kAnimationSetMachineGunLowReadyCrouched,// 58
	kAnimationSetMachineGunExtremeLowReady,// 59
	kAnimationSetShotgun,           // 60
	kAnimationSetShotgunLowReady,   // 61
	kAnimationSetShotgunCrouched,   // 62
	kAnimationSetShotgunLowReadyCrouched,// 63
	kAnimationSetShotgunExtremeLowReady,// 64
	kAnimationSetThrownWeapon,      // 65
	kAnimationSetThrownWeaponLowReady,// 66
	kAnimationSetThrownWeaponCrouched,// 67
	kAnimationSetThrownWeaponLowReadyCrouched,// 68
	kAnimationSetThrownWeaponExtremeLowReady,// 69
	kAnimationSetTacticalAid,       // 70
	kAnimationSetTacticalAidLowReady,// 71
	kAnimationSetTacticalAidCrouched,// 72
	kAnimationSetTacticalAidLowReadyCrouched,// 73
	kAnimationSetTacticalAidExtremeLowReady,// 74
	kAnimationSetTacticalAidUse,    // 75
	kAnimationSetPepperSpray,       // 76
	kAnimationSetPepperSprayLowReady,// 77
	kAnimationSetPepperSprayCrouched,// 78
	kAnimationSetPepperSprayLowReadyCrouched,// 79
	kAnimationSetPepperSprayExtremeLowReady,// 80
	kAnimationSetM4,                // 81
	kAnimationSetM4LowReady,        // 82
	kAnimationSetM4Crouched,        // 83
	kAnimationSetM4LowReadyCrouched,// 84
	kAnimationSetM4ExtremeLowReady, // 85
	kAnimationSetUMP,               // 86
	kAnimationSetUMPLowReady,       // 87
	kAnimationSetUMPCrouched,       // 88
	kAnimationSetUMPLowReadyCrouched,// 89
	kAnimationSetUMPExtremeLowReady,// 90
	kAnimationSetOptiwand,          // 91
	kAnimationSetOptiwandLowReady,  // 92
	kAnimationSetOptiwandCrouched,  // 93
	kAnimationSetOptiwandLowReadyCrouched,// 94
	kAnimationSetOptiwandExtremeLowReady,// 95
	kAnimationSetPaintball,         // 96
	kAnimationSetPaintballLowReady, // 97
	kAnimationSetPaintballCrouched, // 98
	kAnimationSetPaintballLowReadyCrouched,// 99
	kAnimationSetPaintballExtremeLowReady,// 100
	kAnimationSetGangHandgun,       // 101
	kAnimationSetGangMachinegun,    // 102
	kAnimationSetCuffed,            // 103
	kAnimationSetCompliantLookAt,   // 104
	kAnimationSetFlashbanged,       // 105
	kAnimationSetFlashbangedCuffed, // 106
	kAnimationSetGassed,            // 107
	kAnimationSetGassedCuffed,      // 108
	kAnimationSetPepperSprayed,     // 109
	kAnimationSetPepperSprayedCuffed,// 110
	kAnimationSetStung,             // 111
	kAnimationSetStungCuffed,       // 112
	kAnimationSetTased,             // 113
	kAnimationSetTasedCuffed,       // 114
	kAnimationSetAIFlashbanged,     // 115
	kAnimationSetAIGassed,          // 116
	kAnimationSetAIPepperSprayed,   // 117
	kAnimationSetAIStung,           // 118
	kAnimationSetAITased,           // 119
	kAnimationSetMouthOpen          // 120
};

var private AnimationSet m_animationSets[121];

overloaded function Construct()
{
	CreateSet(0, "AnimationSetNull");
	CreateSet(1, "AnimationSetDynamicStanding");
	CreateSet(2, "AnimationSetDynamicStandingHeavyArmor");
	CreateSet(3, "AnimationSetDynamicStandingUpStairs");
	CreateSet(4, "AnimationSetDynamicStandingDownStairs");
	CreateSet(5, "AnimationSetStealthStanding");
	CreateSet(6, "AnimationSetStealthStandingHeavyArmor");
	CreateSet(7, "AnimationSetStealthStandingUpStairs");
	CreateSet(8, "AnimationSetStealthStandingDownStairs");
	CreateSet(9, "AnimationSetCrouching");
	CreateSet(10, "AnimationSetCrouchingHeavyArmor");
	CreateSet(11, "AnimationSetInjuredStanding");
	CreateSet(14, "AnimationSetInjuredCrouching");
	CreateSet(15, "AnimationSetOfficerInjuredStanding");
	CreateSet(12, "AnimationSetOfficerInjuredStandingUpStairs");
	CreateSet(13, "AnimationSetOfficerInjuredStandingDownStairs");
	CreateSet(16, "AnimationSetOfficerInjuredCrouching");
	CreateSet(17, "AnimationSetCivilianWalk");
	CreateSet(18, "AnimationSetCivilianRun");
	CreateSet(19, "AnimationSetTrainer");
	CreateSet(38, "AnimationSetGangWalk");
	CreateSet(37, "AnimationSetGangRun");
	CreateSet(20, "AnimationSetGangWalkHG");
	CreateSet(21, "AnimationSetGangWalkSMG");
	CreateSet(22, "AnimationSetGangWalkMG");
	CreateSet(23, "AnimationSetGangWalkSG");
	CreateSet(24, "AnimationSetGangRunHG");
	CreateSet(25, "AnimationSetGangRunSMG");
	CreateSet(26, "AnimationSetGangRunMG");
	CreateSet(27, "AnimationSetGangRunSG");
	CreateSet(28, "AnimationSetGangSprint");
	CreateSet(29, "AnimationSetGangSprintHG");
	CreateSet(30, "AnimationSetGangSprintSMG");
	CreateSet(31, "AnimationSetGangSprintMG");
	CreateSet(32, "AnimationSetGangSprintSG");
	CreateSet(33, "AnimationSetAICharacterInjuredStanding");
	CreateSet(34, "AnimationSetAICharacterInjuredStandingUpStairs");
	CreateSet(35, "AnimationSetAICharacterInjuredStandingDownStairs");
	CreateSet(36, "AnimationSetAICharacterInjuredCrouching");
	CreateSet(43, "AnimationSetCompliant");
	CreateSet(44, "AnimationSetRestrained");
	CreateSet(39, "AnimationSetEnemyPatrolHG");
	CreateSet(40, "AnimationSetEnemyPatrolSMG");
	CreateSet(41, "AnimationSetEnemyPatrolMG");
	CreateSet(42, "AnimationSetEnemyPatrolSG");
	CreateSet(45, "AnimationSetHandgun");
	CreateSet(46, "AnimationSetHandgunLowReady");
	CreateSet(47, "AnimationSetHandgunCrouched");
	CreateSet(48, "AnimationSetHandgunLowReadyCrouched");
	CreateSet(49, "AnimationSetHandgunExtremeLowReady");
	CreateSet(50, "AnimationSetSubMachineGun");
	CreateSet(51, "AnimationSetSubMachineGunLowReady");
	CreateSet(52, "AnimationSetSubMachineGunCrouched");
	CreateSet(53, "AnimationSetSubMachineGunLowReadyCrouched");
	CreateSet(54, "AnimationSetSubMachineGunExtremeLowReady");
	CreateSet(55, "AnimationSetMachinegun");
	CreateSet(56, "AnimationSetMachinegunLowReady");
	CreateSet(57, "AnimationSetMachinegunCrouched");
	CreateSet(58, "AnimationSetMachinegunLowReadyCrouched");
	CreateSet(59, "AnimationSetMachinegunExtremeLowReady");
	CreateSet(60, "AnimationSetShotgun");
	CreateSet(61, "AnimationSetShotgunLowReady");
	CreateSet(62, "AnimationSetShotgunCrouched");
	CreateSet(63, "AnimationSetShotgunLowReadyCrouched");
	CreateSet(64, "AnimationSetShotgunExtremeLowReady");
	CreateSet(65, "AnimationSetThrownWeapon");
	CreateSet(66, "AnimationSetThrownWeaponLowReady");
	CreateSet(67, "AnimationSetThrownWeaponCrouched");
	CreateSet(68, "AnimationSetThrownWeaponLowReadyCrouched");
	CreateSet(69, "AnimationSetThrownWeaponExtremeLowReady");
	CreateSet(70, "AnimationSetTacticalAid");
	CreateSet(71, "AnimationSetTacticalAidLowReady");
	CreateSet(72, "AnimationSetTacticalAidCrouched");
	CreateSet(73, "AnimationSetTacticalAidLowReadyCrouched");
	CreateSet(74, "AnimationSetTacticalAidExtremeLowReady");
	CreateSet(75, "AnimationSetTacticalAidUse");
	CreateSet(76, "AnimationSetPepperSpray");
	CreateSet(77, "AnimationSetPepperSprayLowReady");
	CreateSet(78, "AnimationSetPepperSprayCrouched");
	CreateSet(79, "AnimationSetPepperSprayLowReadyCrouched");
	CreateSet(80, "AnimationSetPepperSprayExtremeLowReady");
	CreateSet(81, "AnimationSetM4");
	CreateSet(82, "AnimationSetM4LowReady");
	CreateSet(83, "AnimationSetM4Crouched");
	CreateSet(84, "AnimationSetM4LowReadyCrouched");
	CreateSet(85, "AnimationSetM4ExtremeLowReady");
	CreateSet(86, "AnimationSetUMP");
	CreateSet(87, "AnimationSetUMPLowReady");
	CreateSet(88, "AnimationSetUMPCrouched");
	CreateSet(89, "AnimationSetUMPLowReadyCrouched");
	CreateSet(90, "AnimationSetUMPExtremeLowReady");
	CreateSet(91, "AnimationSetOptiwand");
	CreateSet(92, "AnimationSetOptiwandLowReady");
	CreateSet(93, "AnimationSetOptiwandCrouched");
	CreateSet(94, "AnimationSetOptiwandLowReadyCrouched");
	CreateSet(95, "AnimationSetOptiwandExtremeLowReady");
	CreateSet(96, "AnimationSetPaintball");
	CreateSet(97, "AnimationSetPaintballLowReady");
	CreateSet(98, "AnimationSetPaintballCrouched");
	CreateSet(99, "AnimationSetPaintballLowReadyCrouched");
	CreateSet(100, "AnimationSetPaintballExtremeLowReady");
	CreateSet(101, "AnimationSetGangHandgun");
	CreateSet(102, "AnimationSetGangMachinegun");
	CreateSet(103, "AnimationSetCuffed");
	CreateSet(104, "AnimationSetCompliantLookAt");
	CreateSet(105, "AnimationSetFlashbanged");
	CreateSet(106, "AnimationSetFlashbangedCuffed");
	CreateSet(107, "AnimationSetGassed");
	CreateSet(108, "AnimationSetGassedCuffed");
	CreateSet(109, "AnimationSetPepperSprayed");
	CreateSet(110, "AnimationSetPepperSprayedCuffed");
	CreateSet(111, "AnimationSetStung");
	CreateSet(112, "AnimationSetStungCuffed");
	CreateSet(113, "AnimationSetTased");
	CreateSet(114, "AnimationSetTasedCuffed");
	CreateSet(115, "AnimationSetAIFlashbanged");
	CreateSet(116, "AnimationSetAIGassed");
	CreateSet(117, "AnimationSetAIPepperSprayed");
	CreateSet(118, "AnimationSetAIStung");
	CreateSet(119, "AnimationSetAITased");
	CreateSet(120, "AnimationSetMouthOpen");
	return;
}

function AnimationSet GetAnimationSet(AnimationSetManager.EAnimationSet Set)
{
	return m_animationSets[int(Set)];
	return;
}

private function CreateSet(AnimationSetManager.EAnimationSet Set, string configEntryName)
{
	m_animationSets[int(Set)] = Class'SwatGame.AnimationSet'.static.Allocate(self, none, configEntryName, 0).;
	Construct_Void();
	AssertWithDescription(NotEqual_ObjectObject(m_animationSets[int(Set)], none), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("Animation set ", configEntryName), " (enum "), string(GetEnum(Enum'SwatGame.AnimationSetManager.EAnimationSet', int(Set)))), ") could not be created."));
	return;
}
