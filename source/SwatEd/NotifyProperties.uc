class NotifyProperties extends Object
	native
	collapsecategories
	hidecategories(Object);

cpptext
{
	void PostEditChange();

}

struct native NotifyInfo
{
	var() float NotifyFrame;
	var() editinlinenotify AnimNotify Notify;
	var int OldRevisionNum;
};

var int OldArrayCount;
var const int WBrowserAnimationPtr;
var array<NotifyInfo> Notifys;
