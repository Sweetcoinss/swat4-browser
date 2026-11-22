class GUIExternalViewport extends GUIImage
	config(SwatGui)
	perobjectconfig
	instanced
	hidecategories(Menu,Object,Menu,Object);

function InitComponent(GUIComponent Owner)
{
	super.InitComponent(Owner);
	return;
}

event Hide()
{
	super(GUIComponent).Hide();
	__OnClientDraw__Delegate = InternalRender;
	return;
}

function InternalRender(Canvas inCanvas)
{
	return;
}
