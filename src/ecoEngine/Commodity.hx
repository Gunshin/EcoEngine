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
		count = cast(Math.max(0, count - count_), Int);
	}
	
	public function Split(count_:Int):Commodity
	{
		var amountMoved:Int = cast(Math.min(count_, get_count()), Int);
		
		count_ -= amountMoved;
		return new Commodity(get_type(), amountMoved);
	}
	
	
}