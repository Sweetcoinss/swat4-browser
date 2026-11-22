class Reaction_PlayAnimation extends Reaction
	editinlinenew
	collapsecategories
	hidecategories(Object);

enum EPlayAnimationMode
{
	Play_Normal,                    // 0
	Play_Looping,                   // 1
	Play_TweenTo,                   // 2
	Play_Stop,                      // 3
	Play_FreezeAt                   // 4
};

var(Reaction) Reaction_PlayAnimation.EPlayAnimationMode Mode;
var(Reaction) name Animation;
var(Reaction) float Rate;
var(Reaction) float TweenTime;
var(Reaction) int Channel;

protected simulated function execute(Actor Owner, Actor Other)
{
	AssertWithDescription(EqualEqual_IntInt(int(Owner.DrawType), int(2)), Concat_StrStr(Concat_StrStr(Concat_StrStr(Concat_StrStr("[tcohen] ", string(Name)), ": can't play an animation on "), string(Owner)), " because it is not DrawType=DT_Mesh"));
	switch(Mode)
	{
		case 0:
			Owner.PlayAnim(Animation, Rate, TweenTime, Channel);
			break;
		case 1:
			Owner.LoopAnim(Animation, Rate, TweenTime, Channel);
			break;
		case 2:
			Owner.TweenAnim(Animation, TweenTime, Channel);
			break;
		case 3:
			Owner.StopAnimating();
			break;
		case 4:
			Owner.FreezeAnimAt(TweenTime, Channel);
			break;
		default:
			assert(false);
			break;
	}
	return;
}

defaultproperties
{
	Rate=1.0000000
}