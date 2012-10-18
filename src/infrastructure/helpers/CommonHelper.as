package infrastructure.helpers
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.utils.ByteArray;
	
	import mx.graphics.ImageSnapshot;
	import mx.graphics.codec.JPEGEncoder;
	import mx.graphics.codec.PNGEncoder;

	public class CommonHelper
	{
		private static const imagePrefix:String = "image/";
		private static const videoPrefix:String = "video/";
		
		public static function IsNullOrEmpty(str:String):Boolean
		{
			return str == null || str == "";
		}
		
		public static function IsArrayNullOrEmpty(source:Array):Boolean
		{
			return source == null || source.length < 1;
		}
		
		public static function GetMimeTypeByExtension(extension:String):String
		{
			var ext:String = extension.toLowerCase(); 
			switch(ext)
			{
				case "jpg":
				case "jpeg":
				case "png":
				case "gif":
				case "bmp":
				{
					return imagePrefix + ext;
				}
				case "3gp":
				case "flv":
				case "swf":
				case "avi":
				case "mov":
				case "mp4":
				case "mpeg":
				case "mpg":
				case "wmv":
				case "3g2":
				{
					return videoPrefix + ext; 
				}
			}
			return extension;
		}
		
		public static function GetExtensionByMimeType(mimeType:String):String
		{
			if (!IsNullOrEmpty(mimeType))
			{
				return "." + mimeType.substring(mimeType.indexOf("/")+1, mimeType.length); 
			}
			return ".file";
		}
		
		public static function GetImageData(content:DisplayObject, contentType:String):ByteArray
		{
			var data:BitmapData = Bitmap(content).bitmapData;
			switch (contentType)
			{
				case "image/jpeg":
				case "image/jpg":
				{
					return EncodeJpeg(data);
				}
				case "image/png":
				{
					return EncodePng(data);
				}
			}
			return null;
		}
		
		public static function ConvertStringToNumber(value:String):Number
		{
			if (CommonHelper.IsNullOrEmpty(value))
			{
				return NaN;
			}
			return parseInt(value);
		}

		private static function EncodeJpeg(data:BitmapData):ByteArray
		{
			var snapshot:ImageSnapshot = ImageSnapshot.captureImage(data, 0, new JPEGEncoder(70));
			return snapshot.data;
		}
		
		private static function EncodePng(data:BitmapData):ByteArray
		{
			var snapshot:ImageSnapshot = ImageSnapshot.captureImage(data, 0, new PNGEncoder());
			return snapshot.data;
		}
	}
}