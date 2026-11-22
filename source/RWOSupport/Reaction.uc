class Reaction extends Object
	abstract
	native
	editinlinenew
	collapsecategories
	hidecategories(Object);

var() bool OnceOnly "If true, this reaction will be triggered the first time only. If false, it will be re-triggered every time";
var private bool Done;
var() name Event;

final simulated function InternalExecute(Actor Owner, Actor Other)
{
	if(AndAnd_BoolBool(Done, OnceOnly))
	{
		return;
	}
	execute(Owner, Other);
	Done = true;
	Owner.TriggerEvent(Event, Owner, Pawn(Other));
	return;
}

protected simulated function execute(Actor Owner, Actor Other)
{
	return;
}
