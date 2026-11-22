class AnimNotify_ClosePendingDoor extends AnimNotify_Scripted
	editinlinenew
	collapsecategories
	hidecategories(Object);

event Notify(Actor Owner)
{
	assert(NotEqual_ObjectObject(Owner, none));
	if(Owner.IsA('SwatAI'))
	{
		SwatAI(Owner).InteractWithPendingDoor();
	}
	return;
}
