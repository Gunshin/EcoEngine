package ecoEngine;
import ecoEngine.Brokerage.Order;

/**
 * ...
 * @author Michael Stephens
 */
class Brokerage 
{

	var buyOrders:Array<Array<Order>> = new Array<Commodity>();
	var sellOrders:Array<Array<Order>> = new Array<Commodity>();
	
	var inventory:Inventory = new Inventory(512);
	
	public function new() 
	{
		
		
	}
	
	public function AddSellOrder(commodity_:Commodity, owner_:Agent, costPerItem_:Int)
	{
		if (sellOrders[commodity_.get_id()].length == 0)
		{
			sellOrders[commodity_.get_id()] = new Order(commodity_, owner_, costPerItem_);
		}
		else
		{
			for (i in 0...sellOrders.length - 1)
			{
				if (sellOrders[commodity_.get_id()][i].costPerItem > costPerItem_)
				{
					sellOrders[commodity_.get_id()].insert(i, new Order(commodity_, owner_, costPerItem_));
				}
			}
		}
	}
	
	public function CheckSellOrders(commodity_:Commodity, costPerItem_:Int)
	{
		
	}
	
	public function AddBuyOrder(commodity_:Commodity, owner_:Agent, costPerItem_:Int)
	{
		if (sellOrders[commodity_.get_id()].length == 0)
		{
			sellOrders[commodity_.get_id()] = new Order(commodity_, owner_, costPerItem_);
		}
		else
		{
			for (i in 0...sellOrders.length - 1)
			{
				if (sellOrders[commodity_.get_id()][i].costPerItem > costPerItem_)
				{
					sellOrders[commodity_.get_id()].insert(i, new Order(commodity_, owner_, costPerItem_));
				}
			}
		}
	}
	
}

class Order
{
	
	public var commodity:Commodity;
	public var owner:Agent;
	public var costPerItem:Int;
	
	public function new(commodity_:Commodity, owner_:Agent, costPerItem_:Int)
	{
		commodity = commodity_;
		owner = owner_;
		costPerItem = costPerItem;
	}
	
	
	
}