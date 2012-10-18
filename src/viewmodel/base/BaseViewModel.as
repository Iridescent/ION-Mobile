package viewmodel.base
{
	[Bindable]
	public class BaseViewModel
	{
		public var IsValid:Boolean;
		public var Error:String;
		
		public function BaseViewModel()
		{
			reset();
		}
		
		public function Validate():void
		{
			reset();
		}
		
		public var Loading:Boolean;
		
		private function reset():void
		{
			IsValid = true;
			Error = "";
		}
	}
}