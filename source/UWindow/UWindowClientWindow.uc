class UWindowClientWindow extends UWindowWindow;

function Close(optional bool bByParent)
{
	if(Not_PreBool(bByParent))
	{
		ParentWindow.Close(bByParent);
	}
	super.Close(bByParent);
	return;
}
