package infrastructure.helpers
{
	import flash.system.Capabilities;

	public class OperationSystem
	{
		public static const None:int = -1;
		public static const Unknown:int = 0;
		public static const Android:int = 1;
		public static const IOS:int = 2;
		public static const Blackberry:int = 3;
		
		private static var current:int = OperationSystem.None;
		
		public static function IsIOS():Boolean
		{
			Init();
			return current == OperationSystem.IOS;
		}
		
		private static function Init():void
		{
			if (current == OperationSystem.None)
			{
				switch(true)
				{
					case (Capabilities.version.indexOf('IOS') > -1):
					{
						current = OperationSystem.IOS;
						break;
					}
					case (Capabilities.version.indexOf('QNX') > -1):
					{
						current = OperationSystem.Blackberry;
						break;
					}
					case (Capabilities.version.indexOf('AND') > -1):
					{
						current = OperationSystem.Android;
						break;
					}
					default:
					{
						current = OperationSystem.Unknown;
						break;
					}
				}
			}
		}
	}
}