package ecoEngine;

/**
 * ...
 * @author Michael Stephens
 */
class Commodity 
{

	var type(get, null):CommodityType;
	var count(get, null):Int;
	
	public function new(commodityType_:CommodityType, count_:Int) 
	{
		
		type = commodityType_;
		count = count_;
		
	}
	
	public function get_type():CommodityType
	{
		return type;
	}
	
	public function get_count():Int
	{
		return count;
	}
	
	public function Add(count_:Int):Void
	{
		count += count_;
	}
	
	public function Remove(count_:Int):Void
	{
		count = Math.max(0, count - count_);
	}
	
	
}