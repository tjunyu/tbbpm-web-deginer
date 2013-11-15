/**
 * This is a generated class and is not intended for modification.  To customize behavior
 * of this service wrapper you may modify the generated sub-class of this class - SaveDF.as.
 */
package services.savedf
{
	import com.adobe.fiber.core.model_internal;
	import com.adobe.fiber.services.wrapper.HTTPServiceWrapper;
	import com.adobe.serializers.json.JSONDecoder;
	import com.adobe.serializers.json.JSONEncoder;
	import com.adobe.serializers.json.JSONSerializationFilter;
	import com.taobao.tbbpm.controller.Controller;
	import com.taobao.tbbpm.define.flash.FParameterDefine;
	import com.taobao.tbbpm.define.flash.impl.FAutoTaskNode;
	import com.taobao.tbbpm.define.flash.impl.FBpmDefine;
	import com.taobao.tbbpm.dto.Diagram;
	import com.taobao.tbbpm.events.TbbpmEvent;
	import com.taobao.tbbpm.view.AutoTaskNodePropertyWindow;
	
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import hr.binaria.asx3m.Asx3mer;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.DragSource;
	import mx.events.CloseEvent;
	import mx.managers.BrowserManager;
	import mx.managers.DragManager;
	import mx.rpc.AbstractOperation;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPMultiService;
	import mx.rpc.http.Operation;
	import mx.utils.StringUtil;
	
	import spark.components.Image;
	import spark.components.Label;
	import spark.components.VGroup;
	import spark.skins.spark.ImageSkin;
	
	/**
	 * junyu.wy
	 * */
	[ExcludeClass]
	internal class _Super_SaveDF extends com.adobe.fiber.services.wrapper.HTTPServiceWrapper
	{
		
		private var controller:Controller = Controller.getInstance();
		private var xmlc:Asx3mer = Asx3mer.instance;
		private static var serializer0:JSONSerializationFilter = new JSONSerializationFilter();
		// Constructor
		public function _Super_SaveDF()
		{
			getDomain();
			// initialize service control
			_serviceControl = new mx.rpc.http.HTTPMultiService();
			var operations:Array = new Array();
			var operation:mx.rpc.http.Operation;
			var argsArray:Array;
			
			operation = new mx.rpc.http.Operation(null, "saveDF");
			operation.url = GlobalParams.domainUrl+"webdesginer/saveDF.do?_input_charset=UTF-8";
			operation.method = "POST";
			argsArray = new Array("xml","userNick");
			operation.argumentNames = argsArray;         
			operation.contentType = "application/x-www-form-urlencoded";
			operation.resultType = Object;
			operation.resultFormat="text";
			
			operations.push(operation);
			
			//获取用户信息
			operation = new mx.rpc.http.Operation(null, "getUser");
			operation.url = GlobalParams.domainUrl+"webdesginer/getUser.do";
			operation.method = "POST";
			operation.argumentNames = [];
			operation.contentType = "application/x-www-form-urlencoded";
			operation.resultType = Object;
			operation.resultFormat="text";
			
			operations.push(operation);
			
			//获取所有流程图id
			operation = new mx.rpc.http.Operation(null, "getDiagrams");
			operation.url = GlobalParams.domainUrl+"webdesginer/getDiagrams.do?_input_charset=UTF-8";
			operation.method = "POST";
			argsArray = new Array("userNick");
			operation.argumentNames = argsArray;
			operation.contentType = "application/x-www-form-urlencoded";
			operation.resultType = String;
			operation.resultFormat="text";
			
			operations.push(operation);
			
			//获取指定的流程图
			operation = new mx.rpc.http.Operation(null, "getDf");
			operation.url = GlobalParams.domainUrl+"webdesginer/getDf.do?_input_charset=UTF-8";
			operation.method = "POST";
			argsArray = new Array("id","userNick");
			operation.argumentNames = argsArray;
			operation.contentType = "application/x-www-form-urlencoded";
			operation.resultType = Object;
			operation.resultFormat="text";
			
			operations.push(operation);
			
			//发布流程图
			operation = new mx.rpc.http.Operation(null, "publishDf");
			operation.url = GlobalParams.domainUrl+"webdesginer/publishDf.do?_input_charset=UTF-8";
			operation.method = "POST";
			argsArray = new Array("domain","id","userNick");
			operation.argumentNames = argsArray;
			operation.contentType = "application/x-www-form-urlencoded";
			operation.resultType = Object;
			operation.resultFormat="text";
			
			operations.push(operation);
			
			//获取我的服务
			operation = new mx.rpc.http.Operation(null, "getService");
			operation.url = GlobalParams.domainUrl+"webdesginer/getService.do?_input_charset=UTF-8";
			operation.method = "POST";
			argsArray = new Array("userNick");
			operation.argumentNames = argsArray;
			operation.serializationFilter = serializer0;
			operation.contentType = "application/x-www-form-urlencoded";
			operation.resultType = FAutoTaskNode; 	
			
			operations.push(operation);
			
			//删除diagram
			operation = new mx.rpc.http.Operation(null, "deleteDiagram");
			operation.url = GlobalParams.domainUrl+"webdesginer/deleteDiagram.do?_input_charset=UTF-8";
			operation.method = "POST";
			argsArray = new Array("userNick","id");
			operation.argumentNames = argsArray;
			operation.contentType = "application/x-www-form-urlencoded";
			operation.resultType = Object;
			operation.resultFormat="text";
			
			operations.push(operation);
			
			
			_serviceControl.operationList = operations;  
			
			
			preInitializeService();
			model_internal::initialize();
		}
		
		//init initialization routine here, child class to override
		protected function preInitializeService():void
		{
			
		}
		
		
		/**
		 * This method is a generated wrapper used to call the 'saveDF' operation. It returns an mx.rpc.AsyncToken whose 
		 * result property will be populated with the result of the operation when the server response is received. 
		 * To use this result from MXML code, define a CallResponder component and assign its token property to this method's return value. 
		 * You can then bind to CallResponder.lastResult or listen for the CallResponder.result or fault events.
		 *
		 * @see mx.rpc.AsyncToken
		 * @see mx.rpc.CallResponder 
		 *
		 * @return an mx.rpc.AsyncToken whose result property will be populated with the result of the operation when the server response is received.
		 */
		public function saveDF(xml:String) : mx.rpc.AsyncToken
		{
			var _internal_operation:mx.rpc.AbstractOperation = _serviceControl.getOperation("saveDF");
			var _internal_token:mx.rpc.AsyncToken = _internal_operation.send(xml,GlobalParams.userNick) ;
			return _internal_token;
		}
		public function getUser() : mx.rpc.AsyncToken
		{
			var _internal_operation:mx.rpc.AbstractOperation = _serviceControl.getOperation("getUser");
			_internal_operation.addEventListener(ResultEvent.RESULT,getUserNick);
			var _internal_token:mx.rpc.AsyncToken = _internal_operation.send() ;
			return _internal_token;
		}
		
		public function getDiagrams() : mx.rpc.AsyncToken
		{
			var _internal_operation:mx.rpc.AbstractOperation = _serviceControl.getOperation("getDiagrams");
			_internal_operation.addEventListener(ResultEvent.RESULT,initDiagrams);
			var _internal_token:mx.rpc.AsyncToken = _internal_operation.send(GlobalParams.userNick) ;
			return _internal_token;
		}
		
		public function getDf(id:String) : mx.rpc.AsyncToken
		{
			var _internal_operation:mx.rpc.AbstractOperation = _serviceControl.getOperation("getDf");
			_internal_operation.addEventListener(ResultEvent.RESULT,showDiagram);
			var _internal_token:mx.rpc.AsyncToken = _internal_operation.send(id,GlobalParams.userNick) ;
			return _internal_token;
		}
		
		public function publishDf(domain:String,id:String) : mx.rpc.AsyncToken
		{
			var _internal_operation:mx.rpc.AbstractOperation = _serviceControl.getOperation("publishDf");
			var _internal_token:mx.rpc.AsyncToken = _internal_operation.send(domain,id,GlobalParams.userNick) ;
			return _internal_token;
		}
		public function getService() : mx.rpc.AsyncToken
		{
			var _internal_operation:mx.rpc.AbstractOperation = _serviceControl.getOperation("getService");
			_internal_operation.addEventListener(ResultEvent.RESULT,showService);
			var _internal_token:mx.rpc.AsyncToken = _internal_operation.send(GlobalParams.userNick) ;
			return _internal_token;
		}
		
		public function deleteDiagram(id:String) : mx.rpc.AsyncToken
		{
			var _internal_operation:mx.rpc.AbstractOperation = _serviceControl.getOperation("deleteDiagram");
			_internal_operation.addEventListener(ResultEvent.RESULT,showMes);
			var _internal_token:mx.rpc.AsyncToken = _internal_operation.send(GlobalParams.userNick,id) ;
			return _internal_token;
		}
		
		protected function showMes(event:ResultEvent):void
		{
			Alert.show(event.result as  String);
		}
		
		protected function showService(event:ResultEvent):void
		{
			controller.services.removeAllElements();
			var serviceList:ArrayCollection = event.result as  ArrayCollection;
			for each(var service:FAutoTaskNode in serviceList){
				
				var vars:Array = service.action.actionHandle.vars;
				var newVars:Array = new Array();
				var i:int=1;
				for each(var v:Object in vars){
					var p:FParameterDefine = new FParameterDefine();
					p.contextVarName =  v.contextVarName;
					p.dataType       =  v.dataType  ;    
					p.defaultValue   =  v.defaultValue  ;
					p.description    =  v.description   ;
					p.inOutType      =  v.inOutType  ;   
					p.name           =  v.name     ;     
					newVars.push(p);
				}
				service.action.actionHandle.vars = newVars;
				var vGroup:VGroup = new VGroup();
				vGroup.horizontalAlign = "center";
				var img:Image = new Image();
				img.width=20; 
				img.height=20;
				img.smooth=true; 
				img.source="img/s_auto_task.png";
				img.id = "img"+i++;
				var servieStr:String = xmlc.toXML(service);
				img.addEventListener(MouseEvent.MOUSE_DOWN,JEventDelegate.create(doDrag,servieStr));
				var label:Label = new Label();
				label.text = service.name;
				label.width = 70;
				label.setStyle("textAlign","center");
				vGroup.addElement(img);
				vGroup.addElement(label);
				controller.services.addElement(vGroup);
			}
		}
		
		protected function doDrag(event:MouseEvent,...arg):void
		{
			var imgSkin:ImageSkin = event.target as ImageSkin;
			var img:Image = imgSkin.hostComponent;
			event.stopImmediatePropagation();
			var serverDragSource:DragSource=new DragSource();  
			serverDragSource.addData(img.source,arg[0]);   
			DragManager.doDrag(img,serverDragSource,event);
			
		}
		
		protected function showDiagram(event:ResultEvent):void
		{
			var fxml:XML = new XML(event.result as String);
			var define:FBpmDefine = xmlc.fromXML(fxml) as FBpmDefine;
			controller.showDiagram(define);
		}	
		
		
		protected function initDiagrams(event:ResultEvent):void
		{
			GlobalParams.diagrams.removeAll();
			var mes:String = event.result as String;
			mes = StringUtil.trim(mes);
			if(mes.length>0){
				var idAndName:Array = mes.split(",");
				for each(var idName:String in idAndName){
					var inArray:Array = idName.split(":");
					var diagram:Diagram = new Diagram();
					diagram.id = inArray[0];
					diagram.name = inArray[1];
					diagram.code = inArray[2];
					GlobalParams.diagrams.addItem(diagram);
				}
			}
		}
		
		protected function getUserNick(eNickvent:ResultEvent):void
		{
			GlobalParams.userNick = eNickvent.result as String;
			if(GlobalParams.userNick.length==0){
				Alert.show("未检测到用户信息，请到"+GlobalParams.domainUrl+"登入","登陆提示",Alert.YES,null,login);
			}
			getDiagrams();
			getService();
		}
		
		private function login(e:CloseEvent):void{
			navigateToURL(new URLRequest(GlobalParams.domainUrl),"_top");
		}
		
		private function getDomain():void
		{
			GlobalParams.domainUrl="";
			BrowserManager.getInstance().init();
			
			var completeURL:String = BrowserManager.getInstance().url;
			
			trace(completeURL);  
			var httpIdx : int   = completeURL.indexOf('http');  
			trace(httpIdx);  
			if (httpIdx == 0)  
			{  
				var doubleSlashsIdx : int   = completeURL.indexOf('//');  
				trace(doubleSlashsIdx);  
				if (doubleSlashsIdx != -1)  
				{  
					var domainRootSlashIdx : int    = completeURL.indexOf('/', doubleSlashsIdx + 2);  
					trace(domainRootSlashIdx);  
					if (domainRootSlashIdx != -1)  
						GlobalParams.domainUrl   = completeURL.substring(httpIdx, domainRootSlashIdx + 1);  
				}  
			}  
		}
		
	}
	
}
