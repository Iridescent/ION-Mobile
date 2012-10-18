package infrastructure.remoting.services
{
	import infrastructure.events.ServiceCallEvent;
	import infrastructure.helpers.Mediator;
	import infrastructure.helpers.VisualHelper;
	import infrastructure.remoting.framework.common.ServiceCallResult;
	import infrastructure.remoting.framework.entity.BaseResult;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.RemoteObject;

	public class BaseServiceClient
	{
		private var configuration:String;
		private var onCallEnd:Function;
		private var source:String;
		
		public function BaseServiceClient(configuration:String, source:String)
		{
			this.configuration = configuration;
			this.source = source;
		}
		
		protected function Call(action:String, onCallEnd:Function, ... params):void
		{
			this.onCallEnd = onCallEnd;
			var remote:RemoteObject = new RemoteObject(configuration);
			remote.source = source;
			remote.addEventListener(FaultEvent.FAULT, onFault);
			remote.addEventListener(ResultEvent.RESULT, onResult);
			remote.getOperation(action).send.apply(null, params);
		}
		
		protected function SetOutcome(result:BaseResult, serviceCallResult:ServiceCallResult):void
		{
			result.IsSucceed = serviceCallResult.Fault == null;
			result.Error = VisualHelper.CONNECTION_ERROR;
		}
		
		protected function SetCallResultFromDto(result:BaseResult, dto:Object):void
		{
			result.IsSucceed = dto.Succeed;
			result.Error = dto.Error;
		}
		
		private function onFault(event:FaultEvent):void
		{
			var remote:RemoteObject = event.target as RemoteObject;
			remote.removeEventListener(FaultEvent.FAULT, onFault);
			remote.removeEventListener(ResultEvent.RESULT, onResult);
			var result:ServiceCallResult = new ServiceCallResult();
			result.Fault = event;
			onCallEnd(result);
			
			var serviceCallEvent:ServiceCallEvent = new ServiceCallEvent(ServiceCallEvent.ERROR);
			Mediator.Instance.DispatchEvent(serviceCallEvent);
		}
		
		private function onResult(event:ResultEvent):void
		{
			var remote:RemoteObject = event.target as RemoteObject;
			remote.removeEventListener(FaultEvent.FAULT, onFault);
			remote.removeEventListener(ResultEvent.RESULT, onResult);
			
			var result:ServiceCallResult = new ServiceCallResult();
			result.Result = event;
			onCallEnd(result);
		}
	}
}