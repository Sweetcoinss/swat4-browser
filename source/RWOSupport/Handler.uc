class Handler extends Object
	abstract
	native
	editinlinenew
	collapsecategories
	hidecategories(Object);

cpptext
{
    void CleanupRefs();
    void DetachReactions();
    void CheckForErrors(const TCHAR* RWOName, const TCHAR* HandlersName);

}

var() export editinline array<export editinline Reaction> Reactions;

protected final simulated function DoReactions(Actor Owner, Actor Other)
{
	local int i;

	i = 0;
	J0x07:

	if(Less_IntInt(i, Reactions.Length))
	{
		Reactions[i].InternalExecute(Owner, Other);
		AddAdd_PreInt(i);
		// [Loop Continue]
		goto J0x07;
	}
	return;
}
