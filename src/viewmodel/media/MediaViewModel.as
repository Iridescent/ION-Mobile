package viewmodel.media
{
	import model.entity.media.FileDescriptor;

	[Bindable]
	public class MediaViewModel
	{
		public function MediaViewModel()
		{
			SetImage(null);
			SetVideo(null);
		}
		
		public var ImageName:String;
		public var VideoName:String;
		public var ImageFileUrl:String;
		public var VideoFileUrl:String;
		
		public var IsImageAdded:Boolean;
		public var IsVideoAdded:Boolean;
		
		public var Image:FileDescriptor;
		public var Video:FileDescriptor;
		
		public function SetImage(image:FileDescriptor):void
		{
			ImageFileUrl = null;
			Image = image;
			ImageName = image == null ? "Image" : image.Name;
			IsImageAdded = image != null;
		}
		
		public function SetVideo(video:FileDescriptor):void
		{
			VideoFileUrl = null;
			Video = video;
			VideoName = video == null ? "Video" : video.Name;
			IsVideoAdded = video != null;
		}
		
		public function get ImageSource():Object
		{
			if (Image != null)
			{
				return Image.AdditionalLoader != null ? Image.AdditionalLoader :  Image.Content;
			}
			return null;
		}
	}
}