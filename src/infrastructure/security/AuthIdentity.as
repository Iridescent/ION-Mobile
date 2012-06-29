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
		
		public function AuthIdentity()
		{
		}
		
		public var Profile:Person;
	}
}