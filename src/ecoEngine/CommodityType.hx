package ecoEngine;

/**
 * ...
 * @author Michael Stephens
 */
class CommodityType
{

	var name(get, null):String;
	
	public function new(data_:Dynamic) 
	{
		name = data_.name;
		
		AddCommodity(this);
	}
	
	public function get_name():String
	{
		return name;
	}
	
	static var commodities:Map<String, CommodityType> = new Map<String, CommodityType>();
	public static function AddCommodity(commodity_:CommodityType):Void
	{
		commodities.set(commodity_.get_name(), commodity_);
		trace("Added commodity type: " + commodity_.get_name());
	}
	
	public static function GetCommodityType(name:String):CommodityType
	{
		return commodities.get(name);
	}
	
	public static function CreateNewCommodity(name_:String, count_:Int):Commodity
	{
		var type:CommodityType = GetCommodityType(name_);
		if (type == null)
		{
			return null;
		}
		
		return new Commodity(type, count_);
	}
	
}