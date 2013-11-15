package com.taobao.tbbpm.define.figure
{
	import com.taobao.tbbpm.TbbpmTheme;
	import com.taobao.tbbpm.controller.Controller;
	import com.taobao.tbbpm.define.figure.line.LCurve;
	import com.taobao.tbbpm.define.figure.line.LFold;
	import com.taobao.tbbpm.define.figure.line.LSolid;
	import com.taobao.tbbpm.define.flash.FMNode;
	import com.taobao.tbbpm.define.flash.FTransition;
	import com.taobao.tbbpm.events.TbbpmEvent;
	import com.taobao.tbbpm.tool.TbbpmTool;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.events.FlexEvent;
	
	import spark.components.BorderContainer;
	import spark.components.Group;
	import spark.filters.GlowFilter;

	/**
	 * junyu.wy
	 * */
	public class FigureOperator
	{
		
		private var control:Controller=Controller.getInstance();
		[Bindable]public var mnode:FMNode;
		[Bindable]public var nodeType:String = "";
		[Bindable]public var arrowVisible:Boolean = false;
		public var lineToArray:Array = [];
		public var beDirectedToArray:Array=[];
		public var glowFilterArray:Array = [new GlowFilter(0x00ff00, 1, 2, 2, 10, 1, false, false)];
		public var glowFilterArray_empty:Array = [];
		private var node:Group;
		
		public function initLines():void{
			var transitionList:Array =[];
			for each(var ftransition:FTransition in mnode.transitionList){
				transitionList.push(ftransition);
			}
			mnode.transitionList.splice(0);
			for each(var transition:FTransition in transitionList){
				var to:String = transition.to;
				var g:String = transition.g;
				var endNode:Figure = control.nodeMap[to];
				var line:TbbpmLineFigure = lineTo(endNode,null);
				if(g!=null&&g.length>0){
					var pointStr:Array = g.split(";:")[0].split(",");
					var point:Point = new Point(int(pointStr[0]),int(pointStr[1]));
					line.cpPoint = point;
				}
				control.tbbpmTool.temporaryuic.addChild(line)
				line.doDrawByStartService();
			}
		}
		
		public function setNodeFigure(_node:Group):void{
			node = _node;
		}
		
		public function setNmae(name:String):void{
			mnode.name = name;
		}
		
		public function mouseDownHandler(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			node.setFocus();
			node.filters=glowFilterArray;
			
			node.startDrag(false,new Rectangle(0, 0, node.parent.width-node.width, node.parent.height-node.height));
			node.stage.addEventListener(Event.ENTER_FRAME, nodeMove);
		}
		private function nodeMove(e:Event):void{
			control.dispatchEvent(new TbbpmEvent(TbbpmEvent.MOVENODE+mnode.id,""));
		}
		public function mouseUpHandler(event:MouseEvent):void
		{
			
			if(TbbpmTool.temporaryFlag){
				control.dispatchEvent(new TbbpmEvent(TbbpmEvent.ENDLINK,[node,null]));
				event.stopImmediatePropagation();
			}else{
				node.stage.removeEventListener(Event.ENTER_FRAME,nodeMove);
				node.stopDrag();
				setG(node);
			}
			
		}
		public function setG(_node:Group):void{
			mnode.g = _node.x+","+_node.y+","+_node.width+","+_node.height;
		}
		public function removeLineTo(line:TbbpmLineFigure):void{
			lineToArray.splice(lineToArray.indexOf(line),1); 
			mnode.transitionList.splice(mnode.transitionList.indexOf(line.mTbbpmLine),1);
		}
		
		public function removeBeDirected(line:TbbpmLineFigure):void{
			this.beDirectedToArray.splice(beDirectedToArray.indexOf(line),1); 
		}
		/**
		 * 返回组件的绝对位置
		 * startPoint不为空的时候返回组件距离startPoint最近的面的中心点
		 */
		private var pointArray:Array=[];
		private var point:Point=new Point();
		public function absolutePosition(plane:String):Point
		{
			//因为我现在的画板就应经是nodeGroup了，不是全局的布局，所以不用装为全局坐标
			if(plane==TbbpmLineFigure.top){
				point=new Point(node.x+node.width*0.5,node.y); 
			}else if(plane==TbbpmLineFigure.left){
				point=new Point(node.x,node.y+node.height*0.5); 
			}else if(plane==TbbpmLineFigure.right){
				point=new Point(node.x+node.width,node.y+node.height*0.5); 
			}else if(plane==TbbpmLineFigure.bottom){
				point=new Point(node.x+node.width*0.5,node.y+node.height); 
			}else if(plane==TbbpmLineFigure.center){
				point=new Point(node.x+node.width*0.5,node.y+node.height*0.5); 
			}else{
				point=new Point(node.x+node.width*0.5,node.y+node.height*0.5); 
			}
			return point; 
		}
		
		public function arrowMouseUpHandler(event:MouseEvent,plane:String):void
		{
			if(TbbpmTool.temporaryFlag){
				if(!plane){
					plane=TbbpmLineFigure.center;
				}
				control.dispatchEvent(new TbbpmEvent(TbbpmEvent.ENDLINK,[node,plane]));
				event.stopImmediatePropagation();
			}else{
			}	
		}  
		public function arrowMouseDownHandler(event:MouseEvent,plane:String):void
		{
			if(TbbpmTool.temporaryFlag){
			}else{
				if(!plane){
					plane=TbbpmLineFigure.center;
				}
				control.dispatchEvent(new TbbpmEvent(TbbpmEvent.STARTLINK,[node,plane]));
				event.stopImmediatePropagation();
			}
		}
		/**
		 * 根据起始和结束组件以及线的类型画线
		 * 并将线保存于起始组件的lineToArray以及结束组件的beDirectedToArray
		 */
		public function lineTo(endNodeUI:Figure,lineType:String,basedOnXML:XML=null):TbbpmLineFigure{
			var line:TbbpmLineFigure;
			//				if(lineType==TbbpmLine.CURVE){
			//					line=new LCurve(node,endNodeUI);
			//				}else if(lineType==TbbpmLine.FOLD){
			//					line=new LFold(node,endNodeUI);
			//				}else if(lineType==TbbpmLine.SOLID){
			line=new LCurve(node as Figure,endNodeUI);//  LSolid(node as Figure,endNodeUI)
			//				}
			
			lineToArray.push(line);
			mnode.transitionList.push(line.mTbbpmLine);
			endNodeUI.getOperator().beDirectedToArray.push(line);
			
			if(basedOnXML){
				for each(var cp:XML in basedOnXML.cp){
					line.cpPoint=new Point(cp.@x,cp.@y);
				}
				line.isDotted=basedOnXML.@isDotted=="true"?true:false;
				line.startPlane=basedOnXML.@startplane;
				line.endPlane=basedOnXML.@endplane;  
				
				line.thickness=basedOnXML.@thickness;
				line.color=basedOnXML.@color;
				line.radius=basedOnXML.@radius;
				line.arrowThickness=basedOnXML.@arrowThickness;
				line.arrowBorderColor=basedOnXML.@arrowBorderColor;
				line.arrowFillColor=basedOnXML.@arrowFillColor;
				
			}
			return line;  
		}
		public function keyDownHandler(event:KeyboardEvent):void
		{
			event.stopImmediatePropagation();
			if (event.keyCode == 46)//del删除
			{
				control.dispatchEvent(new TbbpmEvent(TbbpmEvent.DELETENODE,node));
			}
		}
		public function onDelete():void{
			var lineToNum:int = lineToArray.length;
			for(var i:int=0;i<lineToNum;i++){
				var line:Object = lineToArray[0];
				line.onDelete();
			}
			var lineForNum:int = beDirectedToArray.length;
			for (var j:int=0;j<lineForNum;j++){
				var lineForEnd:Object = beDirectedToArray[0];
				lineForEnd.onDelete();
			}
//			control.tbbpmTool.temporaryuic.removeChild(
		}
		public function mouseFocusChangeHandler(event:FocusEvent):void
		{
			node.filters=glowFilterArray_empty;
		}
	}
}