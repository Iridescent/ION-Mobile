package infrastructure.remoting.services
{
	import flash.utils.ByteArray;
	
	import infrastructure.remoting.framework.common.ServiceCallResult;
	import infrastructure.remoting.framework.descriptors.SurveyServiceDescriptor;
	import infrastructure.remoting.framework.entity.*;
	
	import model.entity.domain.*;
	import model.entity.query.QuerySurvey;

	public class SurveyServiceClient extends BaseServiceClient
	{
		private var descriptor:SurveyServiceDescriptor;
		
		public function SurveyServiceClient(descriptor:SurveyServiceDescriptor)
		{
			this.descriptor = descriptor;
			super(descriptor.Configuration, descriptor.Source);
		}
		
		//Connect
		private var onConnect:Function;
		public function Connect(onConnect:Function):void
		{
			this.onConnect = onConnect;
			this.Call(descriptor.ConnectAction, ConnectInternal);
		}
		
		private function ConnectInternal(serviceCallResult:ServiceCallResult):void
		{
			onConnect(processCheckInConnect(serviceCallResult));
		}
		
		//Check In
		private var onCheckIn:Function
		public function CheckIn(barcodeId:String, onCheckIn:Function):void
		{
			this.onCheckIn = onCheckIn;
			this.Call(descriptor.CheckInAction, CheckInInternal, barcodeId);
		}
		
		private function CheckInInternal(serviceCallResult:ServiceCallResult):void
		{
			onCheckIn(processCheckInConnect(serviceCallResult));
		}
		
		//Check Out
		private var onCheckOut:Function;
		public function CheckOut(onCheckOut:Function):void
		{
			this.onCheckOut = onCheckOut;
			this.Call(descriptor.CheckOutAction, CheckOutInternal);
		}
		
		private function CheckOutInternal(serviceCallResult:ServiceCallResult):void
		{
			var result:BaseResult = new BaseResult();
			SetOutcome(result, serviceCallResult);
			if (result.IsSucceed)
			{
				var dto:Object = serviceCallResult.Result.result;
				SetCallResultFromDto(result, dto);
			}
			onCheckOut(result);
		}
		
		//Get Survey List
		private var onGetSurveyList:Function;
		public function GetSurveyList(pageSize:int, pageIndex:int, onGetSurveyList:Function):void
		{
			this.onGetSurveyList = onGetSurveyList;
			this.Call(descriptor.GetSurveyListAction, GetSurveyListInternal, pageSize, pageIndex);
		}
		
		private function GetSurveyListInternal(serviceCallResult:ServiceCallResult):void
		{
			var result:ListResult = new ListResult();
			SetOutcome(result, serviceCallResult);
			if (result.IsSucceed)
			{
				var dto:Object = serviceCallResult.Result.result;
				SetCallResultFromDto(result, dto);
				if (dto.SurveyList != null)
				{
					for(var i:int=0; i < dto.SurveyList.length; i++)
					{
						var survey:Object = dto.SurveyList[i];
						result.List.addItem(new QuerySurvey(survey.title, survey.surveyId, survey.surveyReplyId, survey.isCompleted > 0));
					}
				}
			}
			onGetSurveyList(result);
		}
		
		//Get Survey
		private var onGetSurvey:Function;
		public function GetSurvey(surveyId:int, onGetSurvey:Function):void
		{
			this.onGetSurvey = onGetSurvey;
			this.Call(descriptor.GetSurveyAction, GetSurveyInternal, surveyId);
		}
		
		private function GetSurveyInternal(serviceCallResult:ServiceCallResult):void
		{
			var result:GetSurveyResult = new GetSurveyResult();
			SetOutcome(result, serviceCallResult);
			if (result.IsSucceed)
			{
				var dto:Object = serviceCallResult.Result.result;
				SetCallResultFromDto(result, dto);
				if (dto.Survey != null)
				{
					result.Result.Title = dto.Survey.title;
					if (dto.Survey.questions != null)
					{
						var questions:Object = dto.Survey.questions;
						for(var i:int=0; i < questions.length; i++)
						{
							var question:Object = questions[i];
							result.Result.Questions.push(new Question(question.id, question.title, question.required, question.type, question.variants));
						}
					}
				}
			}
			onGetSurvey(result);
		}
		
		//Get Survey Reply Item
		private var onGetSurveyReplyItem:Function;
		public function GetSurveyReplyItem(surveyReplyId:int, questionId:int, onGetSurveyReplyItem:Function):void
		{
			this.onGetSurveyReplyItem = onGetSurveyReplyItem;
			this.Call(descriptor.GetSurveyReplyItemAction, GetSurveyReplyItemInternal, surveyReplyId, questionId);
		}
		
		private function GetSurveyReplyItemInternal(serviceCallResult:ServiceCallResult):void
		{
			var result:GetSurveyReplyItemResult = new GetSurveyReplyItemResult();
			SetOutcome(result, serviceCallResult);
			if (result.IsSucceed)
			{
				var dto:Object = serviceCallResult.Result.result;
				SetCallResultFromDto(result, dto);
				if (dto.SurveyReplyItem != null)
				{
					var surveyReplyItem:Object = dto.SurveyReplyItem;
					result.Result = new SurveyReplyItem(surveyReplyItem.id, surveyReplyItem.surveyReplyId,
														surveyReplyItem.questionType, surveyReplyItem.questionId,
														surveyReplyItem.text, surveyReplyItem.imageFileId,
														surveyReplyItem.videoFileId, surveyReplyItem.variants,
														surveyReplyItem.mediaFileName, surveyReplyItem.mediaFileUrl);
				}
			}
			onGetSurveyReplyItem(result);
		}
		
		//Save Survey Reply Item
		private var onSaveSurveyReplyItem:Function;
		public function SaveSurveyReplyItem(surveyReplyItem:SurveyReplyItem, isCompleted:int, onSaveSurveyReplyItem:Function):void
		{
			this.onSaveSurveyReplyItem = onSaveSurveyReplyItem;
			
			//{SurveyId, SurveyReplyId, QuestionType, QuestionId, ImageFileId, VideoFileId, Text, Variants}
			var dto:Object = {};
			dto.SurveyId = surveyReplyItem.SurveyId;
			dto.SurveyReplyId = surveyReplyItem.SurveyReplyId;
			dto.QuestionType = surveyReplyItem.QuestionType;
			dto.QuestionId = surveyReplyItem.QuestionId;
			dto.ImageFileId = surveyReplyItem.ImageFileId;
			dto.VideoFileId = surveyReplyItem.VideoFileId;
			dto.Text = surveyReplyItem.Text;
			dto.Variants = surveyReplyItem.Variants;
			
			this.Call(descriptor.SaveSurveyReplyItemAction, SaveSurveyReplyItemInternal, dto, isCompleted);
		}
		
		private function SaveSurveyReplyItemInternal(serviceCallResult:ServiceCallResult):void
		{
			var result:SaveSurveyReplyItemResult = new SaveSurveyReplyItemResult();
			SetOutcome(result, serviceCallResult);
			if (result.IsSucceed)
			{
				var dto:Object = serviceCallResult.Result.result;
				SetCallResultFromDto(result, dto);
				result.SurveyReplyId = dto.SurveyReplyId;
			}
			onSaveSurveyReplyItem(result);
		}
		
		//Save File
		private var onSaveFile:Function;
		public function SaveFile(fileName:String, fileMime:String, content:ByteArray, fileType:int, onSaveFile:Function):void
		{
			this.onSaveFile = onSaveFile;
			var dto:Object = {name: fileName, mime: fileMime, content: content, type: fileType};
			this.Call(descriptor.SaveFileAction, SaveFileInternal, dto);
		}
		
		private function SaveFileInternal(serviceCallResult:ServiceCallResult):void
		{
			var result:SaveFileResult = new SaveFileResult();
			SetOutcome(result, serviceCallResult);
			if (result.IsSucceed)
			{
				var dto:Object = serviceCallResult.Result.result;
				SetCallResultFromDto(result, dto);
				result.FileId = dto.FileId;
			}
			onSaveFile(result);
		}
		
		//misc
		private function processCheckInConnect(serviceCallResult:ServiceCallResult):CheckInResult
		{
			var result:CheckInResult = new CheckInResult();
			SetOutcome(result, serviceCallResult);
			if (result.IsSucceed)
			{
				var dto:Object = serviceCallResult.Result.result;
				SetCallResultFromDto(result, dto);
				if (dto.Person != null)
				{
					result.Result = new Person();
					result.Result.BarcodeID = dto.Person.BarcodeID;
					result.Result.FirstName = dto.Person.FirstName;
					result.Result.LastName = dto.Person.LastName;
				}
			}
			return result;
		}
	}
}