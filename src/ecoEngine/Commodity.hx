package ecoEngine;

/**
 * ...
 * @author Michael Stephens
 */
class Commodity 
{

	var id(get, null):Int;
	var count(get, null):Int;
	var agentID(get, null):Int;
	
	public function new(?commodityString_:String, ?commodityID_:Int, ?count_:Int, agentID_:Int) 
	{
		if (commodityString_ != null)
		{
			id = GetCommodityID(commodityString_);
		}
		
		if (commodityID_ != null)
		{
			id = commodityID_;
		}
		
		if (count_ != null)
		{
			count = count_;
		}
		
		agentID = agentID_;
	}
	
	public function get_id():Int
	{
		return id;
	}
	
	public function get_count():Int
	{
		return count;
	}
	
	public function get_agentID():Int
	{
		return agentID;
	}
	
	public function Add(count_:Int):Void
	{
		count += count_;
	}
	
	public function Remove(count_:Int):Int
	{
		var finalCount:Int = cast(Math.max(count - count_, 0), Int);
		var removedAmount:Int = count - finalCount;
		
		count = finalCount;
		
		return removedAmount;
	}
	
	static var CURRENT_COMMODITY_ID:Int = 0;
	static var commodities:Map<String, Int> = new Map<String, Int>();
	public static function AddCommodity(name:String):Int
	{
		commodities.set(name, CURRENT_COMMODITY_ID);
		trace("Added commodity: " + name + " to ID: " + CURRENT_COMMODITY_ID);
		CURRENT_COMMODITY_ID++;
		return CURRENT_COMMODITY_ID - 1;
	}
	
	public static function GetCommodityID(name:String):Int
	{
		var value = commodities.get(name);
		if (value == null)
		{
			value = AddCommodity(name);
		}
		return value;
	}
	
	static var conversionConditionArray:Array < Inventory->Bool > = new Array < Inventory->Bool > ();
	static var conversionActionArray:Array < Inventory->Void > = new Array < Inventory->Void > ();
	public static function AddConversion(condition_:Inventory->Bool, action_:Inventory->Void)
	{
		conversionConditionArray[conversionConditionArray.length] = condition_;
		conversionActionArray[conversionActionArray.length] = action_;
	}
	
}