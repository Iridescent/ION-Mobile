package infrastructure.remoting.framework.descriptors
{
	public class SurveyServiceDescriptor
	{
		public function SurveyServiceDescriptor(configuration:String)
		{
			Configuration = configuration;
			Source = "SurveyService";
			
			ConnectAction = "Connect";
			CheckInAction = "CheckIn";
			CheckOutAction = "CheckOut";
			GetSurveyListAction = "GetSurveyList";
			GetSurveyAction = "GetSurvey";
			GetSurveyReplyItemAction = "GetSurveyReplyItem";
			SaveSurveyReplyItemAction = "SaveSurveyReplyItem";
			SaveFileAction = "SaveFile";
		}
		
		public var Configuration:String;
		public var Source:String;
		
		public var ConnectAction:String;
		public var CheckInAction:String;
		public var CheckOutAction:String;
		public var GetSurveyListAction:String;
		public var GetSurveyAction:String;
		public var GetSurveyReplyItemAction:String;
		public var SaveSurveyReplyItemAction:String;
		public var SaveFileAction:String;
	}
}