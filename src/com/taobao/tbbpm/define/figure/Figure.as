package com.taobao.tbbpm.define.figure
{
	import com.taobao.tbbpm.define.flash.FMNode;
	/**
	 * junyu.wy
	 * */
	public interface Figure
	{
		function onDelete():void;
		function getMNode():FMNode;
		function setMNode(mNode:FMNode):void;
		function getOperator():FigureOperator;
		function setWH(width:int,height:int):void;
		function setXY(x:int,y:int):void;
	}
}