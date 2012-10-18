package infrastructure.container
{
	import infrastructure.remoting.services.SurveyServiceClient;
	import infrastructure.settings.ApplicationSettings;

	public class ServiceLocator
	{
		private var settings:ApplicationSettings;
		
		private static var instance:ServiceLocator;
		
		public static function get Instance():ServiceLocator
		{
			if (instance == null)
			{
				instance = new ServiceLocator();
			}
			return instance;
		}
		
		public function get Settings():ApplicationSettings
		{
			return settings;
		}
		
		public function Initialize(settings:ApplicationSettings):void
		{
			this.settings = settings;
		}
		
		public function GetSurveyServiceClient():SurveyServiceClient
		{
			var result:SurveyServiceClient = new SurveyServiceClient(settings.GetSurveyServiceDescriptor());
			return result;
		}
	}
}