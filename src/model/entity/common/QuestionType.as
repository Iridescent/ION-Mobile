package model.entity.common
{
	public class QuestionType
	{
		public static const TextInput:int = 1;
		public static const TextArea:int = 2;
		public static const SingleChoice:int = 3;
		public static const MultipleChoice:int = 4;
		public static const Dropdown:int = 5;
		public static const Scale:int = 6;
		public static const Grid:int = 7;
		public static const Image:int = 8;
		public static const Video:int = 9;
		public static const Smiles:int = 10;

		public static function IsImage(type:int):Boolean
		{
			return type == QuestionType.Image;
		}
		
		public static function IsVideo(type:int):Boolean
		{
			return type == QuestionType.Video;
		}
		
		public static function IsText(type:int):Boolean
		{
			return type == QuestionType.TextInput || type == QuestionType.TextArea;
		}
		
		public static function IsSingleChoiceOrDropdown(type:int):Boolean
		{
			return type == QuestionType.SingleChoice || type == QuestionType.Dropdown;
		}
		
		public static function IsMultipleChoice(type:int):Boolean
		{
			return type == QuestionType.MultipleChoice;
		}
		
		public static function IsScale(type:int):Boolean
		{
			return type == QuestionType.Scale;
		}
	}
}