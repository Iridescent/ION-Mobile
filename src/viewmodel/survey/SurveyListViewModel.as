package viewmodel.survey
{
	import infrastructure.container.ServiceLocator;
	import infrastructure.navigation.NavigationManager;
	import infrastructure.remoting.framework.entity.BaseResult;
	import infrastructure.remoting.framework.entity.ListResult;
	import infrastructure.remoting.services.SurveyServiceClient;
	import infrastructure.security.AuthIdentity;
	
	import model.entity.query.QuerySurvey;
	
	import mx.collections.ArrayCollection;
	
	import viewmodel.base.BaseViewModel;

	[Bindable]
	public class SurveyListViewModel extends BaseViewModel
	{
		private var serviceClient:SurveyServiceClient;
		
		private var pageIndex:int;
		private var pageSize:int;
		
		public function SurveyListViewModel()
		{
			serviceClient = ServiceLocator.Instance.GetSurveyServiceClient();
			
			pageIndex = 1;
			pageSize = 20;
			SurveyList = new ArrayCollection();
		}
		
		//Load
		public function Load(refresh:Boolean):void
		{
			if (refresh)
			{
				SurveyList.removeAll();
				pageIndex = 1;
			}
			Loading = true;
			serviceClient.GetSurveyList(pageSize, pageIndex, onLoad);
		}

		private function onLoad(result:ListResult):void
		{
			if (result.IsSucceed)
			{
				pageIndex++;
				SurveyList.addAll(result.List);
			}
			MoreVisible = result.List != null && result.List.length == pageSize;
			Loading = false;
		}
		
		//Reply
		public function Reply(item:Object):void
		{
			Loading = true;
			var survey:QuerySurvey = QuerySurvey(item);
			NavigationManager.Instance.GotoSurveyReply(survey);
			Loading = false;
		}
		
		//Check Out
		public function CheckOut():void
		{
			Loading = true;
			serviceClient.CheckOut(onCheckOut);
		}
		
		private function onCheckOut(result:BaseResult):void
		{
			Loading = false;
			if (result.IsSucceed)
			{
				AuthIdentity.Current.CheckOut();
				NavigationManager.Instance.GotoCheckIn();
			}
		}
		
		public var SurveyList:ArrayCollection;
		public var MoreVisible:Boolean;
	}
}