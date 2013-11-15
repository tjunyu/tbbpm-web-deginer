package com.taobao.tbbpm.define.figure
{
	import com.taobao.tbbpm.controller.Controller;
	import com.taobao.tbbpm.define.figure.Figure;
	import com.taobao.tbbpm.define.flash.FTransition;
	import com.taobao.tbbpm.events.TbbpmEvent;
	import com.taobao.tbbpm.view.LinePropertyWindow;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	
	import mx.managers.CursorManager;
	import mx.managers.PopUpManager;
	
	/**
	 * junyu.wy
	 * */
	public class TbbpmLineFigure extends Sprite
	{
		public var mTbbpmLine:FTransition = new FTransition();
		public var type:String=TbbpmLineFigure.FOLD;
		//线条类型
		public static var FOLD:String="fold";
		public static var CURVE:String="curve";
		public static var SOLID:String="solid";
		//线条在面的方位
		public static var top:String="top";
		public static var left:String="left";
		public static var bottom:String="bottom";
		public static var right:String="right";
		public static var center:String="center";
		
		public var start:Figure;
		public var end:Figure;
		
		public var startPoint:Point;
		public var endPoint:Point;
		
		public var startPlane:String;
		public var endPlane:String;
		
		
		
		//公共方法
		public var _control:Controller=Controller.getInstance();
		//定制样式
		[Bindable]public var isDotted:Boolean=false;
		[Bindable]public var thickness:Number=3;
		[Bindable]public var color:uint=0x123456;
		[Bindable]public var radius:int=4;
		[Bindable]public var arrowThickness:Number=1;
		[Bindable]public var arrowBorderColor:uint=0x000000;
		[Bindable]public var arrowFillColor:uint=0xffff00;
		public var _alpha:Number =1.0;
		public var ratios:Array = [0];
		
		
		
		//曲线样式
		[Bindable]public var cpPoint:Point=new Point(0,0)
		
		//箭头
		public var arrow:Shape=new Shape();
		
		
		//滤镜
		public var glowFilterArray:Array = [new GlowFilter(0x00ff00, 1, 2, 2, 2, 1, false, false)];
		public var glowFilterArray_empty:Array = [];
		
//		//编辑面板
//		private var le:LineEidt=new LineEidt();
		public function TbbpmLineFigure(start:Figure=null,end:Figure=null)
		{
			super();
			this.start=start;
			this.end=end;
			mTbbpmLine.to = end.getMNode().id;
			this.contextMenu=_control.createContextMenu();
			this.contextMenu=_control.addContextMenu(this.contextMenu,"删除\u00A0",onDelete);//添加删除按钮
			this.contextMenu=_control.addContextMenu(this.contextMenu,"属性编辑\u00A0",mouseDoubleClickHandler);//添加设置
			
			_control.addEventListener(TbbpmEvent.MOVENODE+start.getMNode().id,doDrawByStartService);
			_control.addEventListener(TbbpmEvent.MOVENODE+end.getMNode().id,doDrawByStartService);
			
			//不显示焦点矩形-->鼠标按下事件
			this.focusRect=false;
			this.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			this.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,mouseFocusChangeHandler);
			this.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			
			//双击事件
			this.doubleClickEnabled=true;
			this.addEventListener(MouseEvent.DOUBLE_CLICK,mouseDoubleClickHandler);
			//鼠标手型
			this.buttonMode=true;
			this.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
		}
		//事件***********************
		private function mouseOverHandler(event:MouseEvent):void{
			this.useHandCursor=true;
		}
		
		private function mouseOutHandler(event:MouseEvent):void{
			this.useHandCursor=false;
		}
		
		protected function keyDownHandler(event:KeyboardEvent):void
		{
			if (event.keyCode == 46)//del删除
			{
				onDelete();
			}
		}
		
		protected function mouseDownHandler(event:MouseEvent):void
		{
			this.stage.focus=this;
			this.filters=glowFilterArray ;
		}
		
		//选中效果
		protected function mouseFocusChangeHandler(event:FocusEvent):void
		{
			this.filters=glowFilterArray_empty;
		}
		
		protected function mouseDoubleClickHandler(event:Event=null):void{
			var titleWindow:LinePropertyWindow = PopUpManager.createPopUp(this, LinePropertyWindow, true)  as  LinePropertyWindow;
			titleWindow.line = 	mTbbpmLine;
		}
		
		public function onDelete(e:Event=null):void{ 
			this.start.getOperator().removeLineTo(this);
			this.end.getOperator().removeBeDirected(this);
			if(this.parent){
				this.parent.removeChild(this);
			}
		}
		
		/**
		 * 控制
		 */
		public function doDrawByStartService(e:Event=null):void{//根据起至服务画线
		}
		
		public function doDrawByAuto():void{
			
		}
		
		public function doClear():void{//清空
		}
		
		public function redraw():void{//根据鼠标位置重画
		}
		
		/**
		 * 起始和结束对象之间最近的点
		 */
		public function absolutePosition():void{
			startPoint=start.getOperator().absolutePosition(this.startPlane);
			endPoint=end.getOperator().absolutePosition(this.endPlane);
		}
		
		//箭头大小
		public function drawArrow(startPoint:Point,endPoint:Point):void{
			arrow.graphics.clear();
			arrow.graphics.lineStyle(arrowThickness,uint(arrowBorderColor),0.8); //箭头边框样式   
			arrow.graphics.beginFill(uint(arrowFillColor)); //箭头填充颜色   
			
			var angle:Number = this._control.getAngle(startPoint,endPoint);
			
			var centerX:Number = endPoint.x - radius * Math.cos(angle*(Math.PI/180));
			var centerY:Number = endPoint.y + radius * Math.sin(angle*(Math.PI/180));
			var topX:Number = endPoint.x + radius * Math.cos(angle*(Math.PI/180));
			var topY:Number = endPoint.y - radius* Math.sin(angle*(Math.PI/180));
			
			var leftX:Number = centerX + radius * Math.cos((angle+120)*(Math.PI/180));
			var leftY:Number = centerY - radius * Math.sin((angle+120)*(Math.PI/180));
			var rightX:Number = centerX + radius * Math.cos((angle+240)*(Math.PI/180));
			var rightY:Number = centerY - radius * Math.sin((angle+240)*(Math.PI/180));
			arrow.graphics.moveTo(topX,topY);
			arrow.graphics.lineTo(leftX,leftY);
			arrow.graphics.lineTo(centerX,centerY);
			arrow.graphics.lineTo(rightX,rightY);
			arrow.graphics.lineTo(topX,topY);
			arrow.graphics.endFill();
			
		}
	}
}