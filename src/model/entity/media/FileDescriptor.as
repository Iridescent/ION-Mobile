package model.entity.media
{
	import flash.display.Loader;
	import flash.utils.ByteArray;

	public class FileDescriptor
	{
		public function FileDescriptor(name:String, size:Number, contentType:String, content:ByteArray=null)
		{
			Name = name;
			Size = size;
			ContentType = contentType;
			Content = content;
		}
		
		public var Name:String;
		public var Size:Number;
		public var ContentType:String;
		public var Content:ByteArray;
		
		public var AdditionalLoader:Loader;
	}
}