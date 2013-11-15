package com.taobao.tbbpm.define.figure.line
{
	
	import com.taobao.tbbpm.define.figure.Figure;
	import com.taobao.tbbpm.define.figure.RectangleFigure;
	import com.taobao.tbbpm.define.figure.TbbpmLineFigure;
	
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	
	/**
	 * junyu.wy
	 * */
	public class LFold extends TbbpmLineFigure
	{
		public function LFold(start:Figure, end:Figure)
		{
			super(start, end);
			type=TbbpmLineFigure.FOLD;
			this.addChild(arrow);
		}
		
		/**
		 * 控制
		 */
		override public function doDrawByStartService(e:Event=null):void{//根据起至服务画线
			absolutePosition();
			this.drawFoldLine();
		}
		
		/**
		 * 起始和结束对象之间最近的点
		 */
		override public function absolutePosition():void{
			startPoint=start.getOperator().absolutePosition(this.startPlane);
			endPoint=end.getOperator().absolutePosition(this.endPlane);
		}
		
		override public function doClear():void{//清空
			graphics.clear(); 
			arrow.graphics.clear();
		}
		
		
		override public function redraw():void{//根据鼠标位置重画
			absolutePosition();
			this.drawFoldLine();
		}
		
		/**
		 * 画折线
		 */
		private var foldArray:Array=[];
		private var hander:int=30;
		public function drawFoldLine():void{
			graphics.clear();
			graphics.lineStyle(thickness,uint(color),_alpha);
			this.graphics.lineGradientStyle(GradientType.RADIAL,[color],[_alpha],ratios,null,SpreadMethod.REPEAT);
			var target:Object;
			if(isDotted){
				var dl:Dash = new Dash(this,this.thickness*3,this.thickness+0.5);
				target=dl;
			}else{
				target=this.graphics;
			} 
			foldArray=[];
			var sPoint:Point=this.startPoint;
			if(startPlane==TbbpmLineFigure.top){
				if(endPlane==TbbpmLineFigure.left||endPlane==TbbpmLineFigure.right){
					var tlrpoint:Point=new Point(this.startPoint.x,this.endPoint.y);
					foldArray.push(tlrpoint);
					sPoint=tlrpoint;
				}else if(endPlane==TbbpmLineFigure.bottom||endPlane==TbbpmLineFigure.top){
					var tbpoint:Point=new Point(this.startPoint.x,this.startPoint.y-hander);
					foldArray.push(tbpoint);
					var tb2point:Point=new Point(this.endPoint.x,this.startPoint.y-hander);
					foldArray.push(tb2point);
					sPoint=tb2point;
				}
			}else if(startPlane==TbbpmLineFigure.left){
				if(endPlane==TbbpmLineFigure.top||endPlane==TbbpmLineFigure.bottom){
					var ltbpoint:Point=new Point(this.endPoint.x,this.startPoint.y);
					foldArray.push(ltbpoint);
					sPoint=ltbpoint;
				}else if(endPlane==TbbpmLineFigure.right||endPlane==TbbpmLineFigure.left){
					var lrbpoint:Point=new Point(this.startPoint.x-hander,this.startPoint.y);
					foldArray.push(lrbpoint);
					var lr2bpoint:Point=new Point(this.startPoint.x-hander,this.endPoint.y);
					foldArray.push(lr2bpoint);
					sPoint=lr2bpoint;
				}
			}else if(startPlane==TbbpmLineFigure.right){
				if(endPlane==TbbpmLineFigure.top||endPlane==TbbpmLineFigure.bottom){
					var rtbpoint:Point=new Point(this.endPoint.x,this.startPoint.y);
					foldArray.push(rtbpoint);
					sPoint=rtbpoint;
				}else if(endPlane==TbbpmLineFigure.left||endPlane==TbbpmLineFigure.right){
					var rlpoint:Point=new Point(this.startPoint.x+hander,this.startPoint.y);
					foldArray.push(rlpoint);
					var rl2point:Point=new Point(this.startPoint.x+hander,this.endPoint.y);
					foldArray.push(rl2point);
					sPoint=rl2point;
				}
			}else if(startPlane==TbbpmLineFigure.bottom){
				if(endPlane==TbbpmLineFigure.left||endPlane==TbbpmLineFigure.right){
					var blrpoint:Point=new Point(this.startPoint.x,this.endPoint.y);
					foldArray.push(blrpoint);
					sPoint=blrpoint;
				}else if(endPlane==TbbpmLineFigure.top||endPlane==TbbpmLineFigure.bottom){
					var btpoint:Point=new Point(this.startPoint.x,this.startPoint.y+hander);
					foldArray.push(btpoint);
					var bt2point:Point=new Point(this.endPoint.x,this.startPoint.y+hander);
					foldArray.push(bt2point);
					sPoint=bt2point;
				}
			}
			
			target.moveTo(this.startPoint.x,this.startPoint.y);//moveTo绘制起始点的横坐标和纵坐标  默认为0
			for each(var fPoint:Point in foldArray){
				target.lineTo(fPoint.x,fPoint.y);
			}
			target.lineTo(endPoint.x,endPoint.y);
			var ePoint:Point=this.endPoint;
			drawArrow(sPoint,ePoint);
		}
		
	}
}