package viewmodel.common
{
	import infrastructure.container.ServiceLocator;
	import infrastructure.helpers.CommonHelper;
	import infrastructure.navigation.NavigationManager;
	import infrastructure.remoting.framework.entity.CheckInResult;
	import infrastructure.remoting.services.SurveyServiceClient;
	import infrastructure.security.AuthIdentity;
	
	import viewmodel.base.BaseViewModel;
	
	import views.survey.SurveyListView;

	[Bindable]
	public class CheckInViewModel extends BaseViewModel
	{
		private var serviceClient:SurveyServiceClient;
		
		public var BarcodeID:String;
		
		public function CheckInViewModel()
		{
			serviceClient = ServiceLocator.Instance.GetSurveyServiceClient();
			FirstAttempt = true;
		} 
		
		private var onAferCheckIn:Function;
		public function CheckIn(onAferCheckIn:Function):void
		{
			this.onAferCheckIn = onAferCheckIn;
			FirstAttempt = false;
			Validate();
			if (IsValid)
			{
				Loading = true;
				serviceClient.CheckIn(BarcodeID, onCheckIn); 
			}
		}
		
		private function onCheckIn(result:CheckInResult):void
		{
			Loading = false;
			if (result.IsSucceed)
			{
				AuthIdentity.Current.CheckIn(result.Result);
				NavigationManager.Instance.GotoSurveyList();
			}
			else
			{
				IsValid = false;
				Error = result.Error;
			}
			onAferCheckIn(result.IsSucceed);
		}
		
		override public function Validate():void
		{
			super.Validate();
			if (CommonHelper.IsNullOrEmpty(BarcodeID))
			{
				Error = "Please enter Barcode";
				IsValid = false;
			}
		}
		
		public var FirstAttempt:Boolean;
	}
}