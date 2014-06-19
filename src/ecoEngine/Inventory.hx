package ecoEngine;

/**
 * ...
 * @author Michael Stephens
 */
class Inventory 
{

	@:isVar var maxItems(get, set):Int;
	var currentItemCount(get, null):Int;
	var stock:Array<Commodity> = new Array<Commodity>();
	
	public function new(maxItems_:Int) 
	{
		maxItems = maxItems_;
	}
	
	public function AddStock(?commodity_:Commodity, ?itemID_:Int, ?itemCount_:Int):Void
	{
		if (commodity_ != null && commodity_.get_count() > 0)
		{
			if (stock[commodity_.get_id()] == null)
			{
				stock[commodity_.get_id()] = commodity_;
			}
			else
			{
				stock[commodity_.get_id()].Add(commodity_.get_count());
				commodity_.Remove(commodity_.get_count());
			}
		}
		else if (itemID_ != null && itemCount_ != null && itemID_ >= 0 && itemCount_ > 0)
		{
			stock[itemID_].Add(itemCount_);
		}
		
	}
	
	public function RemoveStock(itemID_:Int, count_:Int):Void
	{
		stock[itemID_].Remove(count_);
	}
	
	public function Contains(itemID:Int):Bool
	{
		return stock[itemID] != null && stock[itemID].get_count() > 0;
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
}