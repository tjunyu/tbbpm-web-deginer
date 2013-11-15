package services.savedf
{
	import flash.events.Event;  
	/**
	 * junyu.wy
	 * */
	public class JEventDelegate  
	{  
		public function JEventDelegate()  
		{  
		}  
		
		public static function create(f:Function,... arg):Function   
		{  
			return function(e:Event):void  
			{     
				f.apply(null,[e].concat(arg));    
			}  
		}  
		
		public static function toString():String   
		{  
			return "Class JEventDelegate";  
		}  
	}  
}