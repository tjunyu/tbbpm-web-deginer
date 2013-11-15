package
{
	import mx.collections.ArrayCollection;

	public class GlobalParams
	{
		[Bindable]public static var userNick:String;
		[Bindable]public static var domainUrl:String = "http://console.cwf.cloud.daily.tmall.net/";
		[Bindable]public static var diagrams:ArrayCollection = new ArrayCollection();
	}
}