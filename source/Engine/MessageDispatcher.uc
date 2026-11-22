class MessageDispatcher extends Object
	native;

struct native ReceiverInfo
{
	var Actor Receiver;
	var Class<Message> MessageClass;
};

var private const noexport transient int receivers[6];

// Export UMessageDispatcher::execregisterReceiver(FFrame&, void* const)
native function registerReceiver(Actor Receiver, Class<Message> MessageClass, string triggeredByFilter);

// Export UMessageDispatcher::execdispatch(FFrame&, void* const)
native function dispatch(Actor dispatcher, out Message msg);

// Export UMessageDispatcher::execdeleteMessage(FFrame&, void* const)
native function deleteMessage(Message msg);
