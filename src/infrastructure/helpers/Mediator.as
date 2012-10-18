package infrastructure.helpers
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class Mediator
	{
		private static var instance:Mediator;
		
		public static function get Instance():Mediator
		{
			if (instance == null)
			{
				instance = new Mediator();		
			}
			return instance;
		}
		
		private var dispatcher:EventDispatcher;
		
		public function Mediator()
		{
			dispatcher = new EventDispatcher();
		}
		
		public function AddEventListener(type:String, listener:Function):void
		{
			dispatcher.addEventListener(type, listener);
		}
		
		public function RemoveEventListener(type:String, listener:Function):void
		{
			dispatcher.removeEventListener(type, listener);
		}
		
		public function DispatchEvent(event:Event):void
		{
			dispatcher.dispatchEvent(event);
		}
	}
}