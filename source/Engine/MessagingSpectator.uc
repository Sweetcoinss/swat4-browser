class MessagingSpectator extends PlayerController
	abstract
	config(User)
	notplaceable
	hidecategories(Karma);

function PostBeginPlay()
{
	super.PostBeginPlay();
	bIsPlayer = false;
	return;
}
