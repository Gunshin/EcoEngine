package ecoEngine;

/**
 * ...
 * @author Michael Stephens
 */
class Inventory 
{

	@:isVar var maxItems(get, set):Int;
	var currentItemCount(get, null):Int;
	var stock:Map<String, Commodity> = new Map<String, Commodity>();
	
	public function new(maxItems_:Int) 
	{
		maxItems = maxItems_;
	}
	
	public function AddStock(commodity_:Commodity):Void
	{
		if (commodity_.get_count() > 0)
		{
			var commo:Commodity = stock.get(commodity_.get_type().get_name())
			if (commo == null)
			{
				stock.set(commodity_.get_type().get_name(), commodity_);
			}
			else
			{
				commodity_.Add(commodity_.get_count());
				commodity_.Remove(commodity_.get_count());
			}
		}
		
	}
	
	public function RemoveStock(commodity_:Commodity):Void
	{
		var commo:Commodity = stock.get(commodity_.get_type().get_name())
		if (commo != null)
		{
			commo.Remove(commodity_.get_count());
		}
		
	}
	
	public function Contains(itemID:Int):Bool
	{
		return stock[itemID] != null && stock[itemID].get_count() > 0;
	}
	
	public function ContainsAmount(commodity_:Commodity):Bool
	{
		return stock[commodity_.get_id()] != null && stock[commodity_.get_id()].get_count() >= commodity_.get_count();
	}
	
	public function get_maxItems():Int
	{
		return maxItems;
	}
	
	public function set_maxItems(maxCount_:Int):Int
	{
		return maxItems = maxCount_;
	}
	
	public function get_currentItemCount():Int
	{
		return currentItemCount;
	}
	
	public function Print():Void
	{
		trace("______ Starting inventory print _____________");
		for (i in stock)
		{
			if(i != null)
			trace(" stock type = " + i.get_id() + " with count = " + i.get_count());
		}
	}
}