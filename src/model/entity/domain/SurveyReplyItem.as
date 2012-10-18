package model.entity.domain
{
	public class SurveyReplyItem
	{
		public function SurveyReplyItem(id:int=0, surveyReplyId:int=0, questionType:int=0, questionId:int=0, text:String=null,
										imageFileId:int=0, videoFileId:int=0, variants:String=null, mediaFileName:String=null,
										mediaFileUrl:String=null)
		{
			Id = id;
			SurveyReplyId = surveyReplyId;
			QuestionType = questionType;
			QuestionId = questionId;
			Text = text;
			ImageFileId = imageFileId;
			VideoFileId = videoFileId;
			Variants = variants;
			MediaFileName = mediaFileName;
			MediaFileUrl = mediaFileUrl;
		}
		
		public var Id:int;
		public var SurveyReplyId:int;
		public var QuestionType:int;
		public var QuestionId:int;
		public var Text:String;
		public var ImageFileId:int;
		public var VideoFileId:int;
		public var Variants:String;
		
		public var SurveyId:int;
		public var MediaFileName:String;
		public var MediaFileUrl:String;
	}
}