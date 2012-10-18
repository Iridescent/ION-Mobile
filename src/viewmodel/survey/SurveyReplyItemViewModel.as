package viewmodel.survey
{
	import infrastructure.helpers.CommonHelper;
	import infrastructure.helpers.VisualHelper;
	
	import model.entity.common.QuestionType;
	import model.entity.domain.Question;
	import model.entity.domain.SurveyReplyItem;
	import model.entity.media.FilePickResult;
	
	import mx.collections.ArrayCollection;
	
	import viewmodel.base.BaseViewModel;
	import viewmodel.media.MediaViewModel;

	[Bindable]
	public class SurveyReplyItemViewModel extends BaseViewModel
	{
		private var required:Boolean;
		private var surveyReplyItem:SurveyReplyItem;
		
		public function SurveyReplyItemViewModel(surveyReplyItem:SurveyReplyItem, question:Question)
		{
			Media = new MediaViewModel();
			required = question.Required;
			QuestionTitle = question.Title;
			
			var i:int;
			
			switch (surveyReplyItem.QuestionType)
			{
				case QuestionType.Image:
				{
					if (surveyReplyItem.ImageFileId > 1)
					{
						Media.ImageName = surveyReplyItem.MediaFileName;
						Media.ImageFileUrl = surveyReplyItem.MediaFileUrl;
						Media.IsImageAdded = true;
					}
					break;
				}
					
				case QuestionType.Video:
				{
					if (surveyReplyItem.VideoFileId > 1)
					{
						Media.VideoName = surveyReplyItem.MediaFileName;
						Media.VideoFileUrl = surveyReplyItem.MediaFileUrl;
						Media.IsVideoAdded = true;
					}
					break;
				}
					
				case QuestionType.SingleChoice:
				case QuestionType.Dropdown:
				{
					SelectedOption = CommonHelper.ConvertStringToNumber(surveyReplyItem.Variants);
					Variants = new ArrayCollection(question.Variants as Array);
					break;
				}
					
				case QuestionType.Scale:
				{
					var parsed:Number = CommonHelper.ConvertStringToNumber(surveyReplyItem.Variants);
					SelectedOption = NaN;
					if (!isNaN(parsed))
					{
						SelectedOption = parsed + 1;						
					}
					Variants = new ArrayCollection();
					
					if (question.Variants != null)
					{
						for (i=question.Variants.minValue; i <= question.Variants.maxValue; i++)
						{
							Variants.addItem({ title: i.toString(), weight: i+1 });
						}
					}
					ScaleMinLabel = question.Variants.labelMin;
					ScaleMaxLabel = question.Variants.labelMax;
					break;
				}
					
				case QuestionType.Smiles:
				{
					SelectedOption = CommonHelper.ConvertStringToNumber(surveyReplyItem.Variants);
					Variants = new ArrayCollection();
					if (question.Variants != null)
					{
						for (i=question.Variants.minValue; i <= question.Variants.maxValue; i++)
						{
							Variants.addItem({ smileUrl: VisualHelper.GetSmileUrl(i), weight: i });
						}
					}
					ScaleMinLabel = question.Variants.labelMin;
					ScaleMaxLabel = question.Variants.labelMax;
					break;
				}
					
				case QuestionType.MultipleChoice:
				{
					MultiSelectCollection = new ArrayCollection();
					var selectedOptions:Array = new Array();
					if (surveyReplyItem.Variants != null)
					{
						selectedOptions = surveyReplyItem.Variants.split(',')
							.map(function (item:String, index:int, arr:Array):Object
							{
								return parseInt(item);
							});
					}
					
					for (i=0; i < question.Variants.length; i++)
					{
						var variant:Object = question.Variants[i];
						MultiSelectCollection.addItem({title: variant.title, weight: variant.weight, selected: selectedOptions.indexOf(variant.weight) > -1 });
					}
					break;
				}
			}
		}
		
		public function PickVideo(result:FilePickResult):void
		{
			if (result.IsSucceed)
			{
				IsVideoRemoved = false;
				Media.SetVideo(result.File);
			}
		}
		
		public function RemoveVideo():void
		{
			IsVideoRemoved = true;
			Media.SetVideo(null);
		}
		
		public function PickImage(result:FilePickResult):void
		{
			if (result.IsSucceed)
			{
				IsImageRemoved = false;
				Media.SetImage(result.File);
			}
		}
		
		public function RemoveImage():void
		{
			IsImageRemoved = true;
			Media.SetImage(null);
		}
		
		public var QuestionTitle:String;
		public var Text:String;
		public var Media:MediaViewModel;
		public var IsVideoRemoved:Boolean;
		public var IsImageRemoved:Boolean;
		public var SelectedOption:Object; //Single Choice, Dropdown, Scale

		public var Variants:ArrayCollection; //For Single Choice, Multiple Choice, Dropdown, Scale
		public var MultiSelectCollection:ArrayCollection;// For Multiple Choice
		public var ScaleMinLabel:String;
		public var ScaleMaxLabel:String;
	}
}