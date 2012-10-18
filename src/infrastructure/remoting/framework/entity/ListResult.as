package infrastructure.remoting.framework.entity
{
	import mx.collections.ArrayCollection;

	public class ListResult extends BaseResult
	{
		public function ListResult()
		{
			List = new ArrayCollection();
		}
		
		public var List:ArrayCollection;
	}
}