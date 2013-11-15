package com.taobao.tbbpm.tool
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import spark.components.BorderContainer;
	/**
	 * junyu.wy
	 * */
	public class TbbpmTool
	{
		import com.taobao.tbbpm.controller.Controller;
		import com.taobao.tbbpm.define.figure.Figure;
		import com.taobao.tbbpm.define.figure.TbbpmLineFigure;
		import com.taobao.tbbpm.events.TbbpmEvent;
		
		import mx.core.DragSource;
		import mx.core.UIComponent;
		import mx.events.FlexEvent;
		import mx.managers.DragManager;
		
		import spark.filters.GlowFilter;
		
		public static const NODE:String="node";   
		
		private var _control:Controller=Controller.getInstance();
		
		public  function creationComplete():void
		{
			this._control.addEventListener(TbbpmEvent.STARTLINK,startLink);
			this._control.addEventListener(TbbpmEvent.ENDLINK,endLink);
			this._control.addEventListener(TbbpmEvent.CLEARTEMPORARYLINK,clearTemporaryLink);
			
			temporaryuic.addChild(this.temporarySprite);
		}
		
		/**
		 * 划临时线
		 */
		public static var startNode:Figure;	
		public static var startPlane:String="center";
		public static var endNode:Figure;
		public static var endPlane:String="center";
		
		private var startPoint:Point=new Point();
		
		
		public var temporarySprite:Sprite=new Sprite();
		public var temporaryuic:UIComponent;//画布
		public static var temporaryFlag:Boolean=false;
		
		public function startLink(e:TbbpmEvent):void{//建立虚线
			var array:Array=e.stanza as Array;
			startNode=array[0] as Figure;
			startPlane=array[1];
			startPoint= startNode.getOperator().absolutePosition(startPlane);
			temporaryuic.stage.addEventListener(Event.ENTER_FRAME, drawTemporay);
			temporaryFlag=true;
		}
		
		
		public function endLink(e:TbbpmEvent):void{//删除
			var array:Array=e.stanza as Array;
			endNode=array[0] as Figure;
			endPlane=array[1];
			if(startNode==endNode){
			}else{
				var line:TbbpmLineFigure=startNode.getOperator().lineTo(endNode,lineType);
				if(temporaryuic){
					line.startPlane=startPlane;
					line.endPlane=endPlane;  
					
					temporaryuic.addChild(line);
					line.doDrawByStartService();
				}
			}
			clearTemporaryLink(null);
		}
		
		public function clearTemporaryLink(e:TbbpmEvent):void{
			temporarySprite.graphics.clear();
			temporaryuic.stage.removeEventListener(Event.ENTER_FRAME,drawTemporay);
			temporaryFlag=false;
		}
		
		public function drawTemporay(event:Event):void{
			temporarySprite.graphics.clear();
			temporarySprite.graphics.lineStyle(1,0x999999);
			var startX:int=this.startPoint.x;
			var startY:int=this.startPoint.y;
			
			var endX:int=temporarySprite.mouseX;
			var endY:int=temporarySprite.mouseY;
			
			temporarySprite.graphics.moveTo(startX,startY);
			
			var angle:Number=this._control.getAngle(startPoint,new Point(endX,endY));
			var endPoint:Point=new Point(endX-3*(Math.cos(angle*(Math.PI/180))),endY+3*(Math.sin(angle*(Math.PI/180))));
			temporarySprite.graphics.lineTo(endPoint.x,endPoint.y);
		}
		
		public static var lineType:String=TbbpmLineFigure.FOLD;
		public var lineTypeArray:Array=[];
		public var glowFilterArray:Array = [new GlowFilter(0x00ff00, 1, 2, 2, 10, 1, false, false)];
		public var glowFilterArray_empty:Array = [];
		protected function lineType_mouseDownHandler(event:MouseEvent,type:String,obj:Object):void
		{
			if(type){
			}else{
				return;  
			}
			lineType=type;
			for each(var lineOBJ:BorderContainer in this.lineTypeArray){
				if(lineOBJ==obj){
					lineOBJ.alpha=0.3;
					lineOBJ.setStyle("borderColor","0x000000");
				}else{
					lineOBJ.alpha=1.0;
					lineOBJ.setStyle("borderColor","0xdddddd");
				}
			}
		}
	}
}