package model.entity.domain
{
	public class Question
	{
		public function Question(id:int, title:String, required:Boolean, type:int, variants:Object = null)
		{
			Id = id;
			Title = title;
			Required = required;
			Type = type;
			Variants = variants;
		}
		
		public var Id:int;
		public var Title:String;
		public var Required:Boolean;
		public var Type:int;
		public var Variants:Object;
	}
}