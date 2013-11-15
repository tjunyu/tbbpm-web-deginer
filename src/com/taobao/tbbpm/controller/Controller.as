package com.taobao.tbbpm.controller
{
	import com.taobao.tbbpm.define.figure.EllipseFigure;
	import com.taobao.tbbpm.define.figure.Figure;
	import com.taobao.tbbpm.define.figure.FigureOperator;
	import com.taobao.tbbpm.define.figure.RectangleFigure;
	import com.taobao.tbbpm.define.figure.RhombusFigure;
	import com.taobao.tbbpm.define.flash.FMNode;
	import com.taobao.tbbpm.define.flash.impl.FAutoTaskNode;
	import com.taobao.tbbpm.define.flash.impl.FBpmDefine;
	import com.taobao.tbbpm.define.flash.impl.FDecisionNode;
	import com.taobao.tbbpm.define.flash.impl.FEndNode;
	import com.taobao.tbbpm.define.flash.impl.FStartNode;
	import com.taobao.tbbpm.tool.TbbpmTool;
	
	import flash.events.ContextMenuEvent;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.getDefinitionByName;
	
	import mx.core.MXMLObjectAdapter;
	import mx.data.utils.Managed;
	
	import spark.components.Application;
	import spark.components.BorderContainer;
	import spark.components.Group;
	import spark.components.TileGroup;

	/**
	 * junyu.wy
	 * */
	public class Controller extends EventDispatcher
	{
		[Bindable]public var bpmDefine:FBpmDefine=new FBpmDefine();
		public var palette:BorderContainer;
		public var nodeMap:Object = new Object();
		private static var __instance:Controller=null;
		public var tbbpmTool:TbbpmTool;
		public var services:TileGroup;
		private static var num:int=0;
		//预加载
		private var autoTaskNode:FAutoTaskNode;
		private var rectangleFigure:RectangleFigure;
		private var rhombusFigure:RhombusFigure;
		private var decisionNode:FDecisionNode;
		
		public function clearDiagram(newBpmDefine:FBpmDefine):void{
			var nums:int = palette.numElements;
			for(var i:int = 1;i<nums;i++){
				palette.removeElementAt(1);
			}
			nums =tbbpmTool.temporaryuic.numChildren
			for(var j:int = 1;j<nums;j++){
				tbbpmTool.temporaryuic.removeChildAt(1);
			}
			bpmDefine = newBpmDefine;
		}
		
		public function showDiagram(newBpmDefine:FBpmDefine):void{
			clearDiagram(newBpmDefine);
			for each(var node:FMNode in bpmDefine.nodes){
				var figure:Figure;
				if(node is FAutoTaskNode){
					figure = new RectangleFigure();
				}else if (node is FStartNode){
					figure = new EllipseFigure();
				}else if (node is FEndNode){
					figure = new EllipseFigure();
				}else if (node is FDecisionNode){
					figure = new RhombusFigure();
				}
				var xywh:Array = node.g.split(',');
				figure.getOperator().mnode = node;
				figure.getOperator().setNodeFigure(figure as Group);
				figure.setWH(int(xywh[2]),int(xywh[3]));
				figure.setXY(int(xywh[0]),int(xywh[1]));
				palette.addElement(figure as Group);
				nodeMap[node.id] = figure;
				if(int(node.id)>num){
					num = int(node.id);
				}
			}
			for each(var fnode:FMNode in bpmDefine.nodes){
				var nodeFigure:Figure = nodeMap[fnode.id];
				nodeFigure.getOperator().initLines();
			}
			
		}
		
		public static function getInstance():Controller
		{
			if(__instance == null)
			{
				__instance=new Controller();
			}
			return __instance;
		}
		
		public function createTaskNode(node:String,figure:String,name:String):Figure{
				
			var classNode:Class = getDefinitionByName(node) as Class; 
			var mNode:FMNode = new classNode() as FMNode; 
			mNode.name = name;
			var classFigure:Class = getDefinitionByName(figure) as Class; 
			var vFigure:Figure = new classFigure() as Figure; 
			vFigure.setMNode(mNode);
			vFigure.setWH(88,48);
			vFigure.getMNode().id = getNum().toString();
			return vFigure;
		}
		
		public function createServiceNode(service:FAutoTaskNode):Figure{
			var figure:RectangleFigure = new RectangleFigure;
			figure.setMNode(service);
			figure.setWH(88,48);
			figure.getMNode().id = getNum().toString();
			return figure;
		}
		
		public function getNum():int{
			num++;
			return num;
		}
		
		public function createContextMenu():ContextMenu{
			var cm:ContextMenu = new ContextMenu();
			cm.hideBuiltInItems();
			return cm;
		}
		
		public function addContextMenu(cm:ContextMenu,name:String,_function:Function):ContextMenu{
			var menuItem:ContextMenuItem=new ContextMenuItem(name);
			menuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,_function);
			cm.customItems.push(menuItem);
			return cm;
		}
		//获得线的角度
		public function getAngle(startPoint:Point,endPoint:Point):Number{  
			var tmpx:Number=endPoint.x - startPoint.x;
			var tmpy:Number=startPoint.y - endPoint.y;
			var angle:Number= Math.atan2(tmpy,tmpx)*(180/Math.PI);
			return angle;
		}
	}
}