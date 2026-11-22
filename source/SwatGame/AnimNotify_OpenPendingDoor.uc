class AnimNotify_OpenPendingDoor extends AnimNotify_Scripted
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
