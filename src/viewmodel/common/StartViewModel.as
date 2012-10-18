package viewmodel.common
{
	import infrastructure.container.ServiceLocator;
	import infrastructure.navigation.NavigationManager;
	import infrastructure.remoting.framework.entity.CheckInResult;
	import infrastructure.remoting.services.SurveyServiceClient;
	import infrastructure.security.AuthIdentity;
	import infrastructure.settings.ApplicationSettings;
	
	import spark.components.ViewNavigator;
	
	import viewmodel.base.BaseViewModel;
	
	import views.common.CheckInView;
	import views.survey.SurveyListView;

	[Bindable]
	public class StartViewModel extends BaseViewModel
	{
		private var serviceClient:SurveyServiceClient;
		
		public function StartViewModel()
		{
			super();
		}

		public function Start(navigator:ViewNavigator):void
		{
			NavigationManager.Instance.Initialize(navigator);
			ServiceLocator.Instance.Initialize(new ApplicationSettings());
			serviceClient = ServiceLocator.Instance.GetSurveyServiceClient();
			Connect();
		}
		
		public function Connect():void
		{
			Validate();
			serviceClient.Connect(onConnect);
		}
		
		private function onConnect(result:CheckInResult):void
		{
			IsValid = result.IsSucceed;
			if (result.IsSucceed)
			{
				AuthIdentity.Current.CheckIn(result.Result);
				if (result.Result != null)
				{
					NavigationManager.Instance.GotoSurveyList();
				}
				else
				{
					NavigationManager.Instance.GotoCheckIn();
				}
			}
			else
			{
				Error = result.Error;
			}
		}
	}
}