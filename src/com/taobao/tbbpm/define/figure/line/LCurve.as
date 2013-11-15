package com.taobao.tbbpm.define.figure.line
{
	
	import com.taobao.tbbpm.define.figure.Figure;
	import com.taobao.tbbpm.define.figure.RectangleFigure;
	import com.taobao.tbbpm.define.figure.TbbpmLineFigure;
	
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import spark.components.Group;
	
	import system.data.collections.ArrayCollection;
	
	/**
	 * junyu.wy
	 * */
	public class LCurve extends TbbpmLineFigure
	{
		private var canMove:Boolean = false;
		
		public function LCurve(start:Figure, end:Figure)
		{
			super(start, end);
			type=TbbpmLineFigure.CURVE;
			line_cp.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseCPDownHandler);
			this.addChild(arrow);
		}
		
		/**
		 * 控制
		 */
		override public function doDrawByStartService(e:Event=null):void{//根据起至服务画线
			absolutePosition();
			drawCurveLine();
		}
		
		/**
		 * 起始和结束对象之间最近的点
		 */
		override public function absolutePosition():void{
			if(cpPoint.x ==0 && cpPoint.y==0){
				getPosition(start as Group,end as Group);
			}else{
				startPoint = getPointPosition(start as Group,cpPoint);
				endPoint = getPointPosition(end as Group,cpPoint);
			}
			
		}
		
		/**
		 * 画线时获取最短距离的坐标
		 * 判断终点图标和起始图标的相对位置,共4个
		 * 位置:上中,左中,右中,下中
		 */
		private function getPointPosition(node: Group, inPoint: Point): Point{
			var space: Number = 50;
			
			var bpoint1:Point = new Point(node.x+node.width/2,node.y);//上中
			var bpoint2:Point = new Point(node.x,node.y+node.height/2);//左中
			var bpoint3:Point = new Point(node.x+node.width/2,node.y+node.height);//下中
			var bpoint4:Point = new Point(node.x+node.width,node.y+node.height/2);//右中
			
			var bpointList:Array = new Array();
			bpointList.push(bpoint1);
			bpointList.push(bpoint2);
			bpointList.push(bpoint3);
			bpointList.push(bpoint4);
			
			var mindistance:int = 0;
			var point:Point = null;
			for each(var bp:Point in bpointList){
					var dt:int = (bp.x-inPoint.x)*(bp.x-inPoint.x)+(bp.y-inPoint.y)*(bp.y-inPoint.y);
					if(dt<mindistance||mindistance==0){
						mindistance = dt;
						point = bp;
					}
			}
			return point;
		}
		
		/**
		 * 画线时获取最短距离的坐标
		 * 判断终点图标和起始图标的相对位置,共4个
		 * 位置:上中,左中,右中,下中
		 */
		private function getPosition(startIcon: Group, endIcon: Group): void{
			var space: Number = 50;
			
			var bpoint1:Point = new Point(startIcon.x+startIcon.width/2,startIcon.y);//上中
			var bpoint2:Point = new Point(startIcon.x,startIcon.y+startIcon.height/2);//左中
			var bpoint3:Point = new Point(startIcon.x+startIcon.width/2,startIcon.y+startIcon.height);//下中
			var bpoint4:Point = new Point(startIcon.x+startIcon.width,startIcon.y+startIcon.height/2);//右中
			
			var bpointList:Array = new Array();
			bpointList.push(bpoint1);
			bpointList.push(bpoint2);
			bpointList.push(bpoint3);
			bpointList.push(bpoint4);
			
			var epoint1:Point = new Point(endIcon.x+endIcon.width/2,endIcon.y);//上中
			var epoint2:Point = new Point(endIcon.x,endIcon.y+endIcon.height/2);//左中
			var epoint3:Point = new Point(endIcon.x+endIcon.width/2,endIcon.y+endIcon.height);//下中
			var epoint4:Point = new Point(endIcon.x+endIcon.width,endIcon.y+endIcon.height/2);//右中
			
			var epointList:Array = new Array();
			epointList.push(epoint1);
			epointList.push(epoint2);
			epointList.push(epoint3);
			epointList.push(epoint4);
			
			var mindistance:int = 0;
			for each(var bp:Point in bpointList){
				for each(var ep:Point in epointList){
					var dt:int = (bp.x-ep.x)*(bp.x-ep.x)+(bp.y-ep.y)*(bp.y-ep.y);
					if(dt<mindistance||mindistance==0){
						mindistance = dt;
						startPoint = bp;
						endPoint =ep;
					}
				}
			}
		}
		
		override public function doClear():void{//清空
			graphics.clear();
			arrow.graphics.clear();
		}
		
		/**
		 *事件 
		 */
		override protected function mouseDownHandler(event:MouseEvent):void
		{
			this.stage.focus=this;
			this.filters=glowFilterArray ;
			
			if(!line_cp.parent){
				//划控制点
				line_cp.graphics.clear();
				line_cp.graphics.beginFill(0x874D65,0.5);
				line_cp.graphics.lineStyle(3,0x874D65); 
				line_cp.graphics.drawCircle(0,0,3);
				line_cp.graphics.endFill();
				if(cpPoint.x !=0 && cpPoint.y!=0){
					line_cp.x = cpPoint.x;
					line_cp.y = cpPoint.y;
				}else{
					line_cp.x = (startPoint.x+endPoint.x)/2;
					line_cp.y = (startPoint.y+endPoint.y)/2;
				}
				
				this.addChild(line_cp);//鼠标单击后显示控制点
			}
		}
		
		override protected function mouseFocusChangeHandler(event:FocusEvent):void
		{
			this.filters=glowFilterArray_empty;
			
			if(event.relatedObject==line_cp){
			}else if(line_cp.parent){
				this.removeChild(line_cp);
			}
		}
		
		private function mouseCPDownHandler(event:MouseEvent):void{
			this.filters=glowFilterArray;
			if(!line_cp.parent){
				this.addChild(line_cp);
			}
			canMove = true;
			stage.addEventListener(Event.ENTER_FRAME,redrawForCP);
			line_cp.addEventListener(MouseEvent.MOUSE_UP,mouseCPUpHandler);
			line_cp.startDrag();
		}
		protected function mouseCPUpHandler(event:MouseEvent):void
		{
			canMove = false;
			event.stopImmediatePropagation();
			line_cp.stopDrag();
			stage.removeEventListener(Event.ENTER_FRAME,redrawForCP);
			stage.removeEventListener(MouseEvent.MOUSE_UP,mouseCPUpHandler);
			
			//自动直角
			var realDs:Number = (startPoint.x - endPoint.x)*(startPoint.x - endPoint.x)+(startPoint.y - endPoint.y)*(startPoint.y - endPoint.y);
			var stc:Number = (startPoint.x - cpPoint.x)*(startPoint.x - cpPoint.x)+(startPoint.y - cpPoint.y)*(startPoint.y - cpPoint.y);
			var cte:Number = (cpPoint.x - endPoint.x)*(cpPoint.x - endPoint.x)+(cpPoint.y - endPoint.y)*(cpPoint.y - endPoint.y);
			var	r:Number = Math.abs((stc+cte - realDs) / realDs);
				if (r < 0.35) {
					//确认点位置.绕口
                    var point1:Point = new Point(startPoint.x,endPoint.y);
					var point2:Point = new Point(endPoint.x,startPoint.y);
					var dis1:Number = (cpPoint.x - point1.x)*(cpPoint.x - point1.x) + (cpPoint.y - point1.y)*(cpPoint.y - point1.y);
					var dis2:Number = (cpPoint.x - point2.x)*(cpPoint.x - point2.x) + (cpPoint.y - point2.y)*(cpPoint.y - point2.y);
				    if(dis1<dis2){
						cpPoint = point1;
					}else{
						cpPoint = point2;
					}
					absolutePosition();
					drawCurveLine();
				}
		}
		
		public function redrawForCP(e:Event=null):void{//根据鼠标位置重画
			absolutePosition();
			cpPoint.x=this.mouseX;
			cpPoint.y=this.mouseY;
			drawCurveLine();
		}
		
		override public function redraw():void{//根据鼠标位置重画
			absolutePosition();
			drawCurveLine();
		}
		
		/**
		 * 画曲线底层>>>>
		 */
		private var line_cp:Sprite=new Sprite();
		public function drawCurveLine():void
		{
		    graphics.clear();
			graphics.lineStyle(thickness,uint(color),_alpha);
			
			this.graphics.lineGradientStyle(GradientType.RADIAL,[color],[_alpha],ratios,null,SpreadMethod.PAD);
			var target:Object;
			if(isDotted){
				var dl:Dash = new Dash(this,this.thickness*3,this.thickness+0.5);
				target=dl;
			}else{
				target=this.graphics;
			} 
			
			target.moveTo(startPoint.x,startPoint.y);//moveTo绘制起始点的横坐标和纵坐标  默认为0
			if(canMove||(cpPoint.x !=0 && cpPoint.y!=0)){
				target.lineTo(cpPoint.x,cpPoint.y);
				line_cp.x=this.cpPoint.x;
				line_cp.y=this.cpPoint.y;
			}
			
			target.lineTo(endPoint.x,endPoint.y);
			var sPoint:Point = startPoint;
			if(cpPoint.x !=0 && cpPoint.y!=0)
				sPoint=new Point(cpPoint.x,cpPoint.y);
			var ePoint:Point=this.endPoint;
			drawArrow(sPoint,ePoint);
			mTbbpmLine.g = cpPoint.x+","+cpPoint.y+";:-15,20";
		}
	}
}