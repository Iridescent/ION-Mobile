package infrastructure.navigation
{
	import spark.components.ViewNavigator;
	
	import views.common.CheckInView;
	import views.survey.SurveyListView;
	import views.survey.SurveyReplyView;

	public class NavigationManager
	{
		private static var instance:NavigationManager;
		
		public static function get Instance():NavigationManager
		{
			if (instance == null)
			{
				instance = new NavigationManager();
			}
			return instance;
		}
		
		private var navigator:ViewNavigator;
		
		public function Initialize(navigator:ViewNavigator):void
		{
			this.navigator = navigator;
		}
		
		public function Back():void
		{
			navigator.popView();
		}
		
		public function GotoCheckIn():void
		{
			navigate(views.common.CheckInView, null, true);
		}
		
		public function GotoSurveyList():void
		{
			navigate(views.survey.SurveyListView, null, true);
		}
		
		public function GotoSurveyReply(data:Object = null):void
		{
			navigate(views.survey.SurveyReplyView, data);
		}
		
		private function navigate(view:Class, data:Object = null, clear:Boolean = false):void
		{
			if (clear)
			{
				navigator.popAll();
			}
			navigator.pushView(view, data);
		}
	}
}