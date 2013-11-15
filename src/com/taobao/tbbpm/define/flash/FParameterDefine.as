package com.taobao.tbbpm.define.flash
{
	/**
	 * junyu.wy
	 * */
	public class FParameterDefine
	{
		public static const  VARIABLE_TYPE_PARAM:String = "param";
		public static const  VARIABLE_TYPE_GLOBAL:String = "inner";
		public static const  VARIABLE_TYPE_RETURN:String = "return";
		
		public  var name:String;
		public  var description:String;
		
		public  var dataType:String;
		
		public  var contextVarName:String;
		
		public  var defaultValue:String;
		
		public var inOutType:String;
	}
}