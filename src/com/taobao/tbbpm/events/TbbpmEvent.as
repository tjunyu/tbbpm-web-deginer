package com.taobao.tbbpm.events
{
	import flash.events.Event;
	/**
	 * junyu.wy
	 * */
	public class TbbpmEvent extends Event
	{
		public static const ADDNODE:String="addnode";
		public static const MOVENODE:String="movenode_";
		public static const DELETENODE:String="deletenode";
		//划临时线
		public static const STARTLINK:String="startlink";
		public static const ENDLINK:String="endlink";
		public static const CLEARTEMPORARYLINK:String="cleartemporarylink";
		
		//add service
		public static const ADDSERVICE:String="addService";
		public static const OPEN:String="open";
		public var stanza:Object;
		public function TbbpmEvent(type:String, stanza:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{ 
			this.stanza = stanza;
			super(type, bubbles, cancelable);
		}
		
	}
}