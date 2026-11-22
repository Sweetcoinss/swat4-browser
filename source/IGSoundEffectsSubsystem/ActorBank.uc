class ActorBank extends Actor
	native
	config
	notplaceable
	hidecategories(Karma);

var array<Actor> BankedActors;
var private Class<Actor> ActorClassType;
var private bool bInitialized;
//var delegate<OnWithdrawn> __OnWithdrawn__Delegate;
//var delegate<OnDeposited> __OnDeposited__Delegate;

delegate OnWithdrawn(Actor inActorWithdrawn)
{
	inActorWithdrawn.OptimizeIn();
	return;
}

delegate OnDeposited(Actor inActorDeposited)
{
	inActorDeposited.OptimizeOut();
	return;
}

simulated function Initialize(Class<Actor> inClassType)
{
	ActorClassType = inClassType;
	bInitialized = true;
	return;
}

simulated event Actor Withdraw()
{
	local Actor WithdrawnActor;

	AssertWithDescription(bInitialized, "You MUST call Initialize before using an ActorBank.");
	if(Greater_IntInt(BankedActors.Length, 0))
	{
		WithdrawnActor = BankedActors[0];
		BankedActors.Remove(0, 1);
	}
	else
	{
		WithdrawnActor = Spawn(ActorClassType);
	}
	OnWithdrawn(WithdrawnActor);
	return WithdrawnActor;
	return;
}

simulated event Deposit(Actor inActor)
{
	local int ct;

	AssertWithDescription(bInitialized, "You MUST call Initialize before using an ActorBank.");
	AssertWithDescription(inActor.IsA(ActorClassType.Name), Concat_StrStr(Concat_StrStr(Concat_StrStr("You can only deposit actors of class ", string(ActorClassType)), ", you're trying to deposit a "), string(inActor.Class)));
	ct = 0;
	J0xCB:

	if(Less_IntInt(ct, BankedActors.Length))
	{
		if(EqualEqual_ObjectObject(inActor, BankedActors[ct]))
		{
			return;
		}
		AddAdd_PreInt(ct);
		// [Loop Continue]
		goto J0xCB;
	}
	BankedActors[BankedActors.Length] = inActor;
	OnDeposited(inActor);
	return;
}

defaultproperties
{
	bHidden=true
	bStasis=true
}