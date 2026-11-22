class ActionPlayAnimation extends Action
	editinlinenew
	collapsecategories
	hidecategories(Object);

var name TargetLabel "Who to play the animation on.";
var name Animation "Which animation to play on the Target.";
var float AnimationRate "The speed at which to play Animation.  1.0 is normal speed, and 0.5 is half-speed.";
var float TweenTime "The time for the Target to Tween (interpolate animation) before starting the Animation.";
var float Channel "The animation channel on which Target should play Animation.";

latent function Variable execute()
{
	local Actor Target;

	Target = parentScript.findByLabel(Class'Engine.Actor', TargetLabel);
	AssertWithDescription(NotEqual_ObjectObject(Target, none), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] The Script named ", string(parentScript.Name)), " tried to execute an ActionPlayAnimation on a Target defined by having the Label '"), string(TargetLabel)), "', but no such target was found."));
	AssertWithDescription(EqualEqual_IntInt(int(Target.DrawType), int(2)), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] The Script named ", string(parentScript.Name)), " tried to execute an ActionPlayAnimation on a Target defined by having the Label '"), string(TargetLabel)), "'.\nThe target was found (named "), string(Target.Name)), "), but it is not DrawType DT_Mesh, so it can't play animations."));
	Target.PlayAnim(Animation, AnimationRate, TweenTime, int(Channel));
	return none;
	return;
}

defaultproperties
{
	AnimationRate=1.0000000
	actionDisplayName="Play an Animation on a Mesh"
	actionHelp="Causes a Target Actor of DrawType DT_Mesh to play a specified Animation."
	category="Script"
}