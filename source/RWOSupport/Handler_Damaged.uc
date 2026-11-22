class Handler_Damaged extends Handler
	editinlinenew
	collapsecategories
	hidecategories(Object);

var(Handler) int minimum;
var(Handler) bool AccumulateDamage;
var int AccumulatedDamage;

static final simulated function dispatch(array<Handler> Handlers, Actor Owner, int Damage, Pawn EventInstigator, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Handlers.Length))
	{
		Handler_Damaged(Handlers[i]).Handle(Owner, Damage, EventInstigator, HitLocation, Momentum, DamageType);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}

final simulated function Handle(Actor Owner, int Damage, Pawn EventInstigator, Vector HitLocation, Vector Momentum, Class<DamageType> DamageType)
{
	if(AndAnd_BoolBool(NotEqual_ObjectObject(Owner, none), Owner.Level.GetEngine().EnableDevTools))
	{
		Log(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("** Handling ", string(self)), " On "), string(Owner)), " Damage = "), string(Damage)), " Accumulated = "), string(AccumulatedDamage)));
	}
	AddEqual_IntInt(AccumulatedDamage, Damage);
	if(AccumulateDamage)
	{
		if(Less_IntInt(AccumulatedDamage, minimum))
		{
			return;
		}
	}
	else
	{
		if(Less_IntInt(Damage, minimum))
		{
			return;
		}
	}
	DoReactions(Owner, EventInstigator);
	return;
}
