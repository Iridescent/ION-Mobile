package viewmodel.base
{
	[Bindable]
	public class BaseCommandViewModel
	{
		public var IsValid:Boolean;
		public var Error:String;
		
		public function Validate():void
		{
			IsValid = true;
			Error = "";
		}
	}
}