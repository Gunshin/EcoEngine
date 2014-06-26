package ecoEngine;

/**
 * ...
 * @author Michael Stephens
 */
class CommodityType
{

	var name(get, null):String;
	
	public function new(name_:String) 
	{
		name = name_;
	}
	
	public function get_name():String
	{
		return name;
	}
	
	static var commodities:Map<String, CommodityType> = new Map<String, CommodityType>();
	public static function AddCommodity(commodity_:CommodityType):Void
	{
		commodities.set(commodity_.get_name(), commodity_);
		trace("Added commodity: " + commodity_.get_name());
	}
	
	public static function GetCommodityType(name:String):CommodityType
	{
		return commodities.get(name);
	}
	
}