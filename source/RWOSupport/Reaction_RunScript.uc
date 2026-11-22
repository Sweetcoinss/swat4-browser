class Reaction_RunScript extends Reaction
	editinlinenew
	collapsecategories
	hidecategories(Object);

var(Reaction) name Script "The Label of the Script to execute";

protected function execute(Actor Owner, Actor Other)
{
	Owner.dispatchMessage(Class'RWOSupport.MessageRWOReacted'.static.Allocate(self)., construct_NameName(Owner.Label, 'None'));
	return;
}
