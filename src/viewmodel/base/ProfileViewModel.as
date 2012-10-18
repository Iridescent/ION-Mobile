package viewmodel.base
{
	import infrastructure.security.AuthIdentity;
	
	import model.entity.domain.Person;

	[Bindable]	
	public class ProfileViewModel
	{
		public static function get IsCheckedIn():Boolean
		{
			var profile:Person = AuthIdentity.Current.Profile;
			if (profile != null)
			{
				LastName = profile.LastName; 
				FirstName = profile.FirstName;
				return true;
			}
			return false;
		}
		
		public static var LastName:String;
		public static var FirstName:String;
	}
}