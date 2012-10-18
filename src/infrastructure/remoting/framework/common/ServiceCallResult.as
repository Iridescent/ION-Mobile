package infrastructure.remoting.framework.common
{
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	public class ServiceCallResult
	{
		public var Fault:FaultEvent;
		public var Result:ResultEvent;
	}
}