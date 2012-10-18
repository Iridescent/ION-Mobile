package infrastructure.events
{
	import flash.events.Event;

	public class ServiceCallEvent extends Event
	{
		public static const ERROR:String = "ERROR"; 
		
		public var Details:String;
		
		public function ServiceCallEvent(type:String, details:String=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			Details = details;
		}
	}
}