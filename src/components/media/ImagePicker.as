package components.media
{	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MediaEvent;
	import flash.filesystem.File;
	import flash.media.CameraRoll;
	import flash.media.MediaPromise;
	import flash.net.FileFilter;
	
	import infrastructure.container.ServiceLocator;
	import infrastructure.helpers.CommonHelper;
	
	import model.entity.media.FileDescriptor;
	import model.entity.media.FilePickResult;
	
	import mx.utils.UIDUtil;

	public class ImagePicker
	{
		private var onPick:Function;
		private var file:File;
		
		public function ImagePicker()
		{
		}
		
		public function Pick(onPick:Function):void
		{
			this.onPick = onPick;
			
			if (!CameraRoll.supportsBrowseForImage)
			{
				file = new File();
				file.addEventListener(Event.SELECT, onSelectViaFile);
				file.addEventListener(IOErrorEvent.IO_ERROR, onErrorViaFile);
				file.browse([new FileFilter("Images", ServiceLocator.Instance.Settings.ImageTypes)]);
			}
			else
			{
				var cameraRoll:CameraRoll = new CameraRoll();
				cameraRoll.addEventListener(MediaEvent.SELECT, onSelectViaCameraRoll);
				cameraRoll.addEventListener(ErrorEvent.ERROR, onViaCameraRollError);
				cameraRoll.browseForImage();
			}
		}
		
		private function onSelectViaFile(event:Event):void
		{
			file.removeEventListener(Event.SELECT, onSelectViaFile);
			file.removeEventListener(IOErrorEvent.IO_ERROR, onErrorViaFile);
			LoadFile();
		}
			
		private function onErrorViaFile(event:Event):void
		{
			file.removeEventListener(Event.SELECT, onSelectViaFile);
			file.removeEventListener(IOErrorEvent.IO_ERROR, onErrorViaFile);
			error();
		}
		
		private function onSelectViaCameraRoll(e:MediaEvent):void
		{
			var cameraRoll:CameraRoll = e.target as CameraRoll;
			cameraRoll.removeEventListener(MediaEvent.SELECT, onSelectViaCameraRoll);
			cameraRoll.removeEventListener(ErrorEvent.ERROR, onViaCameraRollError);
			var mediaPromise:MediaPromise = e.data;
			if (mediaPromise.file != null)
			{
				file = mediaPromise.file;
				LoadFile();
			}
			else
			{
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onMediaPromiseLoaded);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onMediaPromiseError);
				loader.loadFilePromise(mediaPromise);
			}
		}
		
		private function onViaCameraRollError(e:ErrorEvent):void
		{
			var cameraRoll:CameraRoll = e.target as CameraRoll;
			cameraRoll.removeEventListener(MediaEvent.SELECT, onSelectViaCameraRoll);
			cameraRoll.removeEventListener(ErrorEvent.ERROR, onViaCameraRollError);
			error();
		}
		
		private function LoadFile():void
		{
			file.addEventListener(Event.COMPLETE, onLoadFileSuccessHandler);
			file.addEventListener(IOErrorEvent.IO_ERROR, onLoadFileErrorHandler);
			file.load();
		}
		
		private function onMediaPromiseLoaded(e:Event):void
		{
			var loaderInfo:LoaderInfo = e.target as LoaderInfo;
			loaderInfo.removeEventListener(Event.COMPLETE, onMediaPromiseLoaded);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onMediaPromiseError);
			
			var result:FilePickResult = new FilePickResult();
			result.IsSucceed = true;
			result.File = new FileDescriptor(UIDUtil.createUID() + CommonHelper.GetExtensionByMimeType(loaderInfo.contentType), loaderInfo.bytesLoaded, loaderInfo.contentType, loaderInfo.bytes);
			result.File.AdditionalLoader = loaderInfo.loader;
			onPick(result);
		}
		
		private function onMediaPromiseError(e:Event):void
		{
			var loaderInfo:LoaderInfo = e.target as LoaderInfo;
			loaderInfo.removeEventListener(Event.COMPLETE, onMediaPromiseLoaded);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onMediaPromiseError);
			error();
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