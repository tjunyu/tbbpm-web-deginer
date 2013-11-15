package com.taobao.tbbpm.define.flash.impl
{
	import spark.components.List;
	/**
	 * junyu.wy
	 * */
	public class FBpmDefine
	{
		[Bindable]public var id:String;
		[Bindable]public var code:String;
		[Bindable]public var name:String;
		[Bindable]public var type:String="cloudWorkflow";
		[Bindable]public var description:String;
		[Bindable]public var vars:Array = [];
		[Bindable]public var nodes:Array = [];
	}
}