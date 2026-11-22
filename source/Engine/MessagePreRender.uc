class MessagePreRender extends Message
	native;

var Canvas Canvas;

overloaded function Construct(Canvas _canvas)
{
	Canvas = _canvas;
	return;
}

static function string editorDisplay(name TriggeredBy, Message filter)
{
	return "";
	return;
}

defaultproperties
{
	specificTo=none
}