class UpperBodyAnimBehaviorClients extends Object
	abstract;

enum EUpperBodyAnimBehaviorClientId
{
	kUBABCI_Default,                // 0
	kUBABCI_SwatMovementAction,     // 1
	kUBABCI_BaseIdleAction,         // 2
	kUBABCI_IdleAimAround,          // 3
	kUBABCI_StackedUp,              // 4
	kUBABCI_MoveToActionBase,       // 5
	kUBABCI_NonIdleAimAround,       // 6
	kUBABCI_FallIn,                 // 7
	kUBABCI_AvoidCollisions,        // 8
	kUBABCI_UsingToolkit,           // 9
	kUBABCI_OrderComplianceAction,  // 10
	kUBABCI_StunnedAction,          // 11
	kUBABCI_UseBreachingShotgunAction,// 12
	kUBABCI_RestrainedAction,       // 13
	kUBABCI_AimAtPointAction,       // 14
	kUBABCI_AimAtTargetAction,      // 15
	kUBABCI_FleeAction,             // 16
	kUBABCI_RegroupAction,          // 17
	kUBABCI_TakeCoverAndAttackAction,// 18
	kUBABCI_AttackTargetAction,     // 19
	kUBABCI_ComplianceAction,       // 20
	kUBABCI_MovingWhileCompliant    // 21
};
