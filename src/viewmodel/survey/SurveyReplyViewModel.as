package viewmodel.survey
{
	import flash.utils.ByteArray;
	
	import infrastructure.container.ServiceLocator;
	import infrastructure.helpers.CommonHelper;
	import infrastructure.helpers.VisualHelper;
	import infrastructure.navigation.NavigationManager;
	import infrastructure.remoting.framework.entity.GetSurveyReplyItemResult;
	import infrastructure.remoting.framework.entity.GetSurveyResult;
	import infrastructure.remoting.framework.entity.SaveFileResult;
	import infrastructure.remoting.framework.entity.SaveSurveyReplyItemResult;
	import infrastructure.remoting.services.SurveyServiceClient;
	
	import model.entity.common.FileType;
	import model.entity.common.QuestionType;
	import model.entity.domain.Question;
	import model.entity.domain.Survey;
	import model.entity.domain.SurveyReplyItem;
	import model.entity.media.FileDescriptor;
	
	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;
	import mx.utils.StringUtil;
	
	import viewmodel.base.BaseViewModel;

	[Bindable]
	public class SurveyReplyViewModel extends BaseViewModel
	{
		private var serviceClient:SurveyServiceClient;
		private var surveyId:int;
		private var surveyReplyId:int;
		private var survey:Survey;
		private var currentQuestion:Question;
		
		public function SurveyReplyViewModel(questionStage:UIComponent)
		{
			this.questionStage = questionStage;
			serviceClient = ServiceLocator.Instance.GetSurveyServiceClient();
		}
		
		//Load
		public function Load(surveyId:int, surveyReplyId:int, title:String):void
		{
			this.surveyId = surveyId;
			this.surveyReplyId = surveyReplyId;
			SurveyTitle = title;
			
			Loading = true;
			serviceClient.GetSurvey(surveyId, onGetSurvey);
		}
		
		private function onGetSurvey(result:GetSurveyResult):void
		{
			if (result.IsSucceed)
			{
				survey = result.Result;
				Current = 1;
				Total = result.Result.Questions.length;
				currentQuestion = survey.Questions[Current - 1];
				getSurveyReplyItem(surveyReplyId, Current);
			}
		}
		
		private var prevNextDirection:Boolean;
		//Prev
		public function Prev():void
		{
			prevNextDirection = false;
			if (Current > 1) 
			{
				process();
			}
		}
		
		//Next
		public function Next():void
		{
			prevNextDirection = true;
			if (Current <= Total)
			{
				process();
			}
		}
		
		//Back
		public function Back():void
		{
			//TODO confirmation
			NavigationManager.Instance.Back();
		}
		
		//Save Survey Reply Item
		private function process():void
		{
			fillAndValidate();
			if (!IsValid)
			{
				Error = "Answer is required";
				return;
			}
			
			var file:FileDescriptor = null;
			var content:ByteArray = null;
			var fileType:int;
			if (QuestionType.IsVideo(currentQuestion.Type) && currentViewModel.Media.Video != null)
			{
				file = currentViewModel.Media.Video;
				content = file.Content;
				fileType = FileType.Video;
			}
			else if (QuestionType.IsImage(currentQuestion.Type) && currentViewModel.Media.Image != null)
			{
				file = currentViewModel.Media.Image;
				if (file.AdditionalLoader != null)
				{
					content = CommonHelper.GetImageData(file.AdditionalLoader.content, file.ContentType);
				}
				else
				{
					content = file.Content;
				}
				fileType = FileType.Image;
			}
			if (file != null && content != null)
			{
				serviceClient.SaveFile(file.Name, file.ContentType, content, fileType, onSaveFile);
				return;
			}
			saveSurveyReplyItem();
		}
		
		private function onSaveFile(result:SaveFileResult):void
		{
			if (result.IsSucceed)
			{
				if (result.FileId > 0)
				{
					if (QuestionType.IsVideo(currentQuestion.Type))
					{
						currentSurveyReplyItem.VideoFileId = result.FileId;
					}
					else if (QuestionType.IsImage(currentQuestion.Type))
					{
						currentSurveyReplyItem.ImageFileId = result.FileId;
					}
				}
			}
			saveSurveyReplyItem();
		}
		
		private function saveSurveyReplyItem():void
		{
			var isCompleted:int = Current == Total && prevNextDirection ? 1 : 0; 
			serviceClient.SaveSurveyReplyItem(currentSurveyReplyItem, isCompleted, onSaveSurveyReplyItem);
		}
		
		private function onSaveSurveyReplyItem(result:SaveSurveyReplyItemResult):void
		{
			if (result.IsSucceed)
			{
				surveyReplyId = result.SurveyReplyId;
			}
			if (prevNextDirection)
			{
				if (Current == Total)
				{
					Back();
					return;
				}
				Current++;
			}
			else
			{
				Current--;
			}
			currentQuestion = survey.Questions[Current - 1];
			if (result.IsSucceed)
			{
				getSurveyReplyItem(surveyReplyId, Current);
			}
		}
		
		//Get Survey Reply Item
		private function getSurveyReplyItem(surveyReplyId:int, current:int):void
		{
			Loading = true;
			serviceClient.GetSurveyReplyItem(surveyReplyId, currentQuestion.Id, onGetSurveyReplyItem);
		}
		
		private function onGetSurveyReplyItem(result:GetSurveyReplyItemResult):void
		{
			if (result.IsSucceed)
			{
				currentSurveyReplyItem = result.Result;
				if (currentSurveyReplyItem == null)
				{
					currentSurveyReplyItem = new SurveyReplyItem(0, surveyReplyId, currentQuestion.Type, currentQuestion.Id);
				}
				currentSurveyReplyItem.SurveyId = surveyId;
				update();
			}
			Loading = false;
		}
		
		//Update
		private var currentSurveyReplyItem:SurveyReplyItem;
		private var currentViewModel:SurveyReplyItemViewModel;
		private var questionStage:UIComponent;
		
		private function update():void
		{
			Required = currentQuestion.Required;
			currentViewModel = new SurveyReplyItemViewModel(currentSurveyReplyItem, currentQuestion);
			currentViewModel.Text = currentSurveyReplyItem.Text;
			updateNextPrevButtons();
			
			var child:UIComponent = VisualHelper.GetQuestionEditControls(currentQuestion, currentViewModel);
			child.width = questionStage.width;
			child.height = questionStage.height;
			questionStage.removeChildren();
			questionStage.addChild(child);
			
			//child.validateSize();
			//child.initialize();
			//child.validateDisplayList();
			//child.regenerateStyleCache(false);
		}
		
		//misc
		private function fillAndValidate():void
		{
			super.Validate();
			
			var parsed:Number;
			
			switch (currentQuestion.Type)
			{
				case QuestionType.TextInput:
				case QuestionType.TextArea:
				{
					IsValid = !currentQuestion.Required || !CommonHelper.IsNullOrEmpty(currentViewModel.Text);
					if (IsValid)
					{
						currentSurveyReplyItem.Text = currentViewModel.Text;
					}
					break;
				}
					
				case QuestionType.Image:
				{
					if (currentQuestion.Required && (currentSurveyReplyItem.ImageFileId < 1 || currentViewModel.IsImageRemoved)
						&& currentViewModel.Media.Image == null)
					{
						IsValid = false;
					}
					else if (currentViewModel.IsImageRemoved)
					{
						currentSurveyReplyItem.ImageFileId = 0;
					}
					break;
				}
					
				case QuestionType.Video:
				{
					if (currentQuestion.Required && (currentSurveyReplyItem.VideoFileId < 1 || currentViewModel.IsVideoRemoved)
						&& currentViewModel.Media.Video == null)
					{
						IsValid = false;
					}
					else if (currentViewModel.IsVideoRemoved)
					{
						currentSurveyReplyItem.VideoFileId = 0;
					}
					break;
				}
					
				case QuestionType.SingleChoice:
				case QuestionType.Dropdown:
				case QuestionType.Smiles:
				{
					parsed = parseInt(currentViewModel.SelectedOption.toString());
					IsValid = !currentQuestion.Required || !isNaN(parsed);
					if (IsValid)
					{
						currentSurveyReplyItem.Variants = isNaN(parsed) ? null : parsed.toString();
					}
					break;
				}
					
				case QuestionType.Scale:
				{
					parsed = parseInt(currentViewModel.SelectedOption.toString());
					parsed--;
					
					IsValid = !currentQuestion.Required || !isNaN(parsed);
					if (IsValid)
					{
						currentSurveyReplyItem.Variants = isNaN(parsed) ? null : parsed.toString();
					}
					break;
				}
					
				case QuestionType.MultipleChoice:
				{
					var selectedOptions:Array = currentViewModel.MultiSelectCollection.toArray()
						.filter(function (item:Object, index:int, array:Array):Boolean { return item.selected; });
					IsValid = !currentQuestion.Required || selectedOptions.length > 0;
					if (IsValid)
					{
						currentSurveyReplyItem.Variants =
							selectedOptions.length < 1 ? null :
							selectedOptions.map(function (item:Object, index:int, arr:Array):Object
								{
									return item.weight;
								}).join(',');
					}
					break;
				}
			}
		}
		
		private function updateNextPrevButtons():void
		{
			PrevButtonVisible = Current > 1;
			NextButtonLabel = Current == Total ? "Finish" : "Next" ;
		}

		public var Current:int;
		public var Total:int;
		public var Required:Boolean;
		public var SurveyTitle:String;
		public var NextButtonLabel:String;
		public var PrevButtonVisible:Boolean;
	}
}