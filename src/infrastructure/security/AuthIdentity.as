package infrastructure.security
{
	import model.entity.domain.Person;

	public class AuthIdentity
	{
		private static var instance:AuthIdentity;
		
		public static function get Current():AuthIdentity
		{
			if (instance == null)
			{
				instance = new AuthIdentity();
			}
			return instance;
		}
		
		private var profile:Person;
		
		public function CheckIn(profile:Person):void
		{
			this.profile = profile;
		}
		
		public function CheckOut():void
		{
			this.profile = null;
		}

		public function get Profile():Person
		{
			return profile;
		}
	}
}