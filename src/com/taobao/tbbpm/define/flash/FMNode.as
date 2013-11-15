package com.taobao.tbbpm.define.flash
{
	/**
	* junyu.wy
	* */
	public class FMNode
	{
		[Bindable]public var id:String;
		[Bindable]public var name:String;
		[Bindable]public var g:String;
		[Bindable]public var transitionList:Array=[];
		[Bindable]public var retryType:String;
		[Bindable]public var retryMax:String = "5";
		[Bindable]public var retryInterVal:String = "60";
		[Bindable]public var taskGroup:String;
	}
}