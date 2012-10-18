package model.entity.query
{
	public class QuerySurvey
	{
		public function QuerySurvey(title:String = null, surveyId:int = 0, surveyReplyId:int = 0, isCompleted:Boolean = false)
		{
			Title = title;
			SurveyId = surveyId;
			SurveyReplyId = surveyReplyId;
			IsCompleted = isCompleted;
		} 
		
		public var Title:String;
		public var SurveyId:int;
		public var SurveyReplyId:int;
		public var IsCompleted:Boolean;
		
		public function get IsReplied():Boolean
		{
			return SurveyReplyId != 0;
		} 
	}
}