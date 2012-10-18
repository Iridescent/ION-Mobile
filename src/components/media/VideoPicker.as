package components.media
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	
	import infrastructure.container.ServiceLocator;
	import infrastructure.helpers.CommonHelper;
	import infrastructure.helpers.OperationSystem;
	
	import model.entity.media.FileDescriptor;
	import model.entity.media.FilePickResult;
	
	import nativeExtensions.VideoExtension;
	import nativeExtensions.VideoExtensionEvent;

	public class VideoPicker
	{
		private var onPick:Function;
		private var file:File;
		private var extension:VideoExtension;
		
		public function VideoPicker()
		{
		}
		
		public function Pick(onPick:Function):void
		{
			this.onPick = onPick;
			
			if (OperationSystem.IsIOS())
			{
				if (VideoExtension.isSupported)
				{
					extension = new VideoExtension();
					extension.addEventListener(VideoExtensionEvent.COMPLETE, IOSVideoPickComplete);
					extension.addEventListener(VideoExtensionEvent.CANCEL, IOSVideoPickCancel);
					extension.PickVideo();
				}
			}
			else
			{
				file = new File();
				file.addEventListener(Event.SELECT, onSelectHandler);
				file.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
				file.browse([new FileFilter("Video", ServiceLocator.Instance.Settings.VideoTypes)]);
			}
		}
		
		private function onSelectHandler(event:Event):void
		{
			file.removeEventListener(Event.SELECT, onSelectHandler);
			file.removeEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
			
			file.addEventListener(Event.COMPLETE, onLoadFileSuccessHandler);
			file.addEventListener(IOErrorEvent.IO_ERROR, onLoadFileErrorHandler);
			file.load();
		}
		
		private function onErrorHandler(event:Event):void
		{
			file.removeEventListener(Event.SELECT, onSelectHandler);
			file.removeEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
			error();
		}
		
		//IOS
		private function IOSVideoPickComplete(e:VideoExtensionEvent):void
		{
			extension.removeEventListener(VideoExtensionEvent.COMPLETE, IOSVideoPickComplete);
			extension.removeEventListener(VideoExtensionEvent.CANCEL, IOSVideoPickCancel);
			
			var result:Object = extension.GetMediaInfo();
			file = new File(result.MediaUrl);
			file.addEventListener(Event.COMPLETE, onLoadFileSuccessHandler);
			file.addEventListener(IOErrorEvent.IO_ERROR, onLoadFileErrorHandler);
			file.load();
		}
		
		private function IOSVideoPickCancel(e:VideoExtensionEvent):void
		{
			extension.removeEventListener(VideoExtensionEvent.COMPLETE, IOSVideoPickComplete);
			extension.removeEventListener(VideoExtensionEvent.CANCEL, IOSVideoPickCancel);
		}
		
		private function onLoadFileSuccessHandler(event:Event):void
		{
			var file:File = event.target as File;
			file.removeEventListener(Event.COMPLETE, onLoadFileSuccessHandler);
			file.removeEventListener(IOErrorEvent.IO_ERROR, onLoadFileErrorHandler);
			succeed(file);
		}
		
		private function onLoadFileErrorHandler(event:Event):void
		{
			var file:File = event.target as File;
			file.removeEventListener(Event.COMPLETE, onLoadFileSuccessHandler);
			file.removeEventListener(IOErrorEvent.IO_ERROR, onLoadFileErrorHandler);
			error();
		}
		
		private function succeed(file:File):void
		{
			var result:FilePickResult = new FilePickResult();
			result.IsSucceed = true;
			result.File = new FileDescriptor(file.name, file.size, CommonHelper.GetMimeTypeByExtension(file.extension), file.data);
			onPick(result);
		}
		
		private function error():void
		{
			var result:FilePickResult = new FilePickResult();
			result.IsSucceed = false;
			result.Error = "Could not pick file";
			onPick(result);
		}
	}
}