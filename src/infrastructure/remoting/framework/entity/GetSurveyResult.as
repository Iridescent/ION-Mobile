package infrastructure.remoting.framework.entity
{
	import model.entity.domain.Survey;

	public class GetSurveyResult extends BaseResult
	{
		public function GetSurveyResult()
		{
			Result = new Survey();
		}
		
		public var Result:Survey;
	}
}