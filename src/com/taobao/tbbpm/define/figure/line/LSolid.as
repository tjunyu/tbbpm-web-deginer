package com.taobao.tbbpm.define.figure.line
{
	
	import com.taobao.tbbpm.define.figure.Figure;
	import com.taobao.tbbpm.define.figure.TbbpmLineFigure;
	import com.taobao.tbbpm.define.figure.line.Dash;
	
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	
	import spark.components.Group;
	
	/**
	 * junyu.wy
	 * */
	public class LSolid extends TbbpmLineFigure
	{
		public function LSolid(start:Figure, end:Figure)
		{
			super(start, end);
			type=TbbpmLineFigure.SOLID;
			this.addChild(arrow);
		}
		/**
		 * 控制
		 */
		override public function doDrawByStartService(e:Event=null):void{//根据起至服务画线
//			absolutePosition();
			startPoint=getPosition(end as Group,start as Group);
			endPoint=getPosition(start as Group,end as Group);
			this.drawFoldLine();
		}
		
		/**
		 * 控制
		 */
		override public function doDrawByAuto():void{//根据起至服务画线
			startPoint=getPosition(end as Group,start as Group);
			endPoint=getPosition(start as Group,end as Group);
			this.drawFoldLine();
		}
		
		/**
		 * 画线时获取线条终点的坐标
		 * 判断终点图标和起始图标的相对位置,共九个
		 * 位置:左上,中上,右上;左中,中中,右中,左下,中下,右下
		 */
		private function getPosition(startIcon: Group, endIcon: Group): Point{
			var space: Number = 50;
			
			//计算起始点的中心点坐标
			var startCenterX: Number = startIcon.x + startIcon.width / 2;
			var startCenterY: Number = startIcon.y + startIcon.height / 2;
			
			//计算终点的中心点坐标
			var endCenterX: Number = endIcon.x + endIcon.width / 2;
			var endCenterY: Number = endIcon.y + endIcon.height / 2;
			
			var p: Point = new Point();
			
			//1左上
			if(endCenterX <= startCenterX - space && endCenterY <= startCenterY - space){
				p.x = endIcon.x + endIcon.width;
				p.y = endIcon.y + endIcon.height;
				//trace("左上");
			}
				//2中上
			else if(endCenterX >= startCenterX - space && endCenterX <= startCenterX + space
				&& endCenterY < startCenterY - space){
				p.x = endIcon.x + endIcon.width / 2;
				p.y = endIcon.y + endIcon.height;
				//trace("中上");
			}
				//3右上
			else if(endCenterX >= startCenterX + space && endCenterY <= startCenterY - space){
				p.x = endIcon.x;
				p.y = endIcon.y + endIcon.height;
				//trace("右上");
			}
				//4中左
			else if(endCenterX <= startCenterX - space && 
				endCenterY >= startCenterY - space && endCenterY <= startCenterY + space){
				p.x = endIcon.x + endIcon.width;
				p.y = endIcon.y + endIcon.height / 2;
				//trace("中左");
			}
				//5中中
			else if(endCenterX >= startCenterX - space && endCenterX <= startCenterX + space
				&& endCenterY >= startCenterY - space && endCenterY <= startCenterY + space){
				p.x = endIcon.x;
				p.y = endIcon.y;
				//trace("中中");
			}
				//6中右
			else if(endCenterX >= startCenterX + space && 
				endCenterY >= startCenterY - space && endCenterY <= startCenterY + space){
				p.x = endIcon.x;
				p.y = endIcon.y + endIcon.height / 2;
				//trace("中右");
			}
				//7下左
			else if(endCenterX <= startCenterX - space && endCenterY >= startCenterY + space){
				p.x = endIcon.x + endIcon.width;
				p.y = endIcon.y;
				//trace("下左");
			}
				//8下中
			else if((endCenterX >= startCenterX - space && endCenterX <= startCenterX + space) &&
				endCenterY >= startCenterY + space){
				p.x = endIcon.x + endIcon.width / 2;
				p.y = endIcon.y;
				//trace("下中");
			}
				//9右中
			else if(endCenterX >= startCenterX + space && endCenterY >= startCenterY + space){
				p.x = endIcon.x;
				p.y = endIcon.y;
				//trace("右中");
			}
			
			return p;
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
			
			target.moveTo(this.startPoint.x,this.startPoint.y);//moveTo绘制起始点的横坐标和纵坐标  默认为0
			target.lineTo(endPoint.x,endPoint.y);
			var sPoint:Point=this.startPoint;
			var ePoint:Point=this.endPoint;
			drawArrow(sPoint,ePoint);
		}
		
	}
}