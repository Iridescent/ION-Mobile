package infrastructure.settings
{
	import infrastructure.remoting.framework.descriptors.SurveyServiceDescriptor;

	public class ApplicationSettings
	{
		private var serviceDescriptor:SurveyServiceDescriptor;
		
		public function ApplicationSettings()
		{
			var serviceConfiguration:String;
			
			CONFIG::release
			{
				serviceConfiguration = "ion-service-beta";
				ServerUrl = "http://www.beta-attendance.curiositymachine.org/";
			}
			
			CONFIG::debug
			{
				serviceConfiguration = "ion-service-dev";
				ServerUrl = "http://192.168.242.209/keytag/";
			}
			
			serviceDescriptor = new SurveyServiceDescriptor(serviceConfiguration);
			
			VideoTypes = "*.mp4;*.mpeg;*.avi;*.mpg;*.wmv;*.flv;*.mov;*.3gp;*.3g2;";
			ImageTypes = "*.png;*.jpg;*.jpeg;*.bmp;*.gif";
			SmilesUrls = ['images/smiles/strongly-disagree.png', 'images/smiles/disagree.png',
						  'images/smiles/not-sure.png', 'images/smiles/agree.png', 'images/smiles/strongly-agree.png']
		}
		
		public function GetSurveyServiceDescriptor():SurveyServiceDescriptor
		{
			return serviceDescriptor;
		}
		
		//Media types
		public var VideoTypes:String;
		public var ImageTypes:String;
		public var ServerUrl:String;
		public var SmilesUrls:Array;
	}
}