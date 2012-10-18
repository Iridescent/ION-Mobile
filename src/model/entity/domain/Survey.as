package model.entity.domain
{
	public class Survey
	{
		public function Survey()
		{
			Questions = new Vector.<Question>();
		}
		
		public var Title:String;
		public var Questions:Vector.<Question>;
	}
}