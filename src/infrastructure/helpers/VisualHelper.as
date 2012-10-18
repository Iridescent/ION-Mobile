package infrastructure.helpers
{
	import components.questions.*;
	import components.ui.Alert;
	import components.ui.Confirmation;
	
	import flash.display.DisplayObjectContainer;
	
	import infrastructure.container.ServiceLocator;
	
	import model.entity.common.QuestionType;
	import model.entity.domain.Question;
	import model.entity.domain.SurveyReplyItem;
	
	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;
	
	import spark.events.PopUpEvent;
	
	import viewmodel.survey.SurveyReplyItemViewModel;

	public class VisualHelper
	{
		public static const CONNECTION_ERROR:String = "Connection error";
		public static const LOGOUT_CONFIRMATION_MESSAGE:String = "Are you sure you want to Exit?";
		
		public static function OpenAlert(message:String, OnAlertClose:Function, owner:DisplayObjectContainer,
										 width:Number, height:Number, x:Number, y:Number):void
		{
			var confirmation:Alert = new Alert();
			if (OnAlertClose != null)
			{
				confirmation.addEventListener(PopUpEvent.CLOSE, OnAlertClose, false, 0, true);
			}
			confirmation.width = width;
			confirmation.height = height;
			confirmation.x = x;
			confirmation.y = y;
			confirmation.Message = message;
			confirmation.open(owner, true);
		}
		
		public static function OpenConfirmation(message:String, OnConfirmationClose:Function, owner:DisplayObjectContainer,
												width:Number, height:Number, x:Number, y:Number, yesText:String="Yes", noText:String="No"):void
		{
			var confirmation:Confirmation = new Confirmation();
			if (OnConfirmationClose != null)
			{
				confirmation.addEventListener(PopUpEvent.CLOSE, OnConfirmationClose, false, 0, true);
			}
			confirmation.width = width;
			confirmation.height = height;
			confirmation.x = x;
			confirmation.y = y;
			confirmation.Message = message;
			confirmation.YesButtonText = yesText;
			confirmation.NoButtonText = noText;
			confirmation.open(owner, true);
		}
		
		public static function GetQuestionEditControls(question:Question, surveyReplyItemViewModel:SurveyReplyItemViewModel):UIComponent
		{
			switch (question.Type)
			{
				case QuestionType.TextInput:
				{
					var textInput:TextInputQuestion = new TextInputQuestion();
					textInput.Context = surveyReplyItemViewModel;
					return textInput;
				}
				case QuestionType.TextArea:
				{
					var textArea:TextAreaQuestion = new TextAreaQuestion();
					textArea.Context = surveyReplyItemViewModel;
					return textArea;
				}
				case QuestionType.SingleChoice:
				case QuestionType.Dropdown:
				{
					var single:SingleChoiceQuestion = new SingleChoiceQuestion();
					single.Context = surveyReplyItemViewModel;
					return single;
				}
				case QuestionType.Scale:
				{
					var scale:ScaleQuestion = new ScaleQuestion();
					scale.Context = surveyReplyItemViewModel;
					return scale;
				}
				case QuestionType.Smiles:
				{
					var smiles:SmilesQuestion = new SmilesQuestion();
					smiles.Context = surveyReplyItemViewModel;
					return smiles;
				}
				case QuestionType.MultipleChoice:
				{
					var multiple:MultipleChoiceQuestion = new MultipleChoiceQuestion();
					multiple.Context = surveyReplyItemViewModel;
					return multiple;
				}
				case QuestionType.Grid:
				{
					return new GridQuestion();
				}
				case QuestionType.Image:
				{
					var image:ImageQuestion = new ImageQuestion();
					image.Context = surveyReplyItemViewModel;
					return image;
				}
				case QuestionType.Video:
				{
					var video:VideoQuestion = new VideoQuestion();
					video.Context = surveyReplyItemViewModel;
					return video;
				}
				default:
				{
					return new EmptyQuestion();
				}
			}
		}
		
		public static function GetSmileUrl(weight:int):String
		{
			var urls:Array = ServiceLocator.Instance.Settings.SmilesUrls;
			var serverUrl:String = ServiceLocator.Instance.Settings.ServerUrl;
			return weight > 0 && weight <= urls.length ? serverUrl + urls[weight - 1] : '';
		}
	}
}