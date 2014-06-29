package ecoEngine;
import ecoEngine.Brokerage.Order;

/**
 * ...
 * @author Michael Stephens
 */
class Brokerage 
{

	/*var buyOrders:Array<Array<Order>> = new Array<Commodity>();
	var sellOrders:Array<Array<Order>> = new Array<Commodity>();*/
	
	var buyOrders:Map < CommodityType, Array<Order> > = new Map < CommodityType, Array<Order> > ();
	var sellOrders:Map < CommodityType, Array<Order> > = new Map < CommodityType, Array<Order> > ();
	
	var completedOrders:Array<FinishedOrder> = new Array<FinishedOrder>();
	
	var inventory:Inventory = new Inventory(512);
	
	public function new() 
	{
		
		
	}
	
	public function SellCommodity(commodity_:Commodity, owner_:Agent, minimumCostPerItem_:Int):Bool
	{
		var existingBuyOrders:Array<Order> = CheckBuyOrders(commodity_, minimumCostPerItem_);
		
		var amountSold:Int = 0;
		
		for (i in existingBuyOrders)
		{
			
			if(i.
			
		}
		
	}
	
	function AddSellOrder(commodity_:Commodity, owner_:Agent, costPerItem_:Int)
	{
		var array:Array<Order> = sellOrders[commodity_.get_type()];
		
		if (array == null)
		{
			array = new Array<Order>();
			sellOrders[commodity_.get_type()] = array;
			array.push(new Order(commodity_, owner_, costPerItem_));
			return;
		}
		else
		{
			for (i in 0...array.length - 1)
			{
				if (array[i].costPerItem > costPerItem_)
				{
					array.insert(i, new Order(commodity_, owner_, costPerItem_));
					return;
				}
			}
			array.push(new Order(commodity_, owner_, costPerItem_));
		}
	}
	
	function CheckSellOrders(commodity_:Commodity, maximumCostPerItem_:Int):Array<Order>
	{
		var array:Array<Order> = sellOrders[commodity_.get_type()];
		
		var validOrders:Array<Order> = new Array<Order>();
		var countFulfilled:Int = 0;
		
		for (i in array)
		{
			if (i.costPerItem <= maximumCostPerItem_ && countFulfilled < commodity_.get_count())
			{
				validOrders.push(i);
				countFulfilled += commodity_.get_count();
			}
			else
			{
				return validOrders;
			}
		}
		
		return null;
	}
	
	function AddBuyOrder(commodity_:Commodity, owner_:Agent, costPerItem_:Int)
	{
		var array:Array<Order> = buyOrders[commodity_.get_type()];
		
		if (array == null)
		{
			array = new Array<Order>();
			buyOrders[commodity_.get_type()] = array;
			array.push(new Order(commodity_, owner_, costPerItem_));
			return;
		}
		else
		{
			for (i in 0...array.length - 1)
			{
				if (array[i].costPerItem > costPerItem_)
				{
					array.insert(i, new Order(commodity_, owner_, costPerItem_));
					return;
				}
			}
			array.push(new Order(commodity_, owner_, costPerItem_));
		}
	}
	
	
	function CheckBuyOrders(commodity_:Commodity, minimumCostPerItem_:Int):Array<Order>
	{
		var array:Array<Order> = sellOrders[commodity_.get_type()];
		
		var validOrders:Array<Order> = new Array<Order>();
		var countFulfilled:Int = 0;
		
		for (i in array)
		{
			if (i.get_costPerItem() >= minimumCostPerItem_ && countFulfilled < commodity_.get_count())
			{
				validOrders.push(i);
				countFulfilled += commodity_.get_count();
			}
			else
			{
				return validOrders;
			}
		}
		
		return null;
	}
	


class Order
{
	
	var money(get, null):Int;
	
	public function get_money():Int
	{
		return money;
	}
	
	var commodity:Commodity;
	public function get_commodity():Commodity
	{
		return commodity;
	}
	
	var owner:Agent;
	
	
	var costPerItem(get, null):Int;
	public function get_costPerItem():Int
	{
		return costPerItem;
	}
	
	public function new(commodity_:Commodity, owner_:Agent, costPerItem_:Int)
	{
		commodity = commodity_;
		owner = owner_;
		costPerItem = costPerItem;
	}
	
	public function Ordered(count_:Int):FinishedOrder
	{
		
		var amountMoved:Int = cast(Math.min(count_, commodity.get_count()), Int);
		
		
		
	}
	
}

class FinishedOrder
{
	
	var owner(get, null):Agent;
	public function get_owner():Agent
	{
		return owner;
	}
	
	var commodity:Commodity;
	var money:Int;
	
	public function new(agent_:Agent, commodity_:Commodity, money_:Int)
	{
		owner = agent_;
		
		commodity = commodity_;

		money = money_;
	}
	
	public function TransferGoods():Bool
	{
		
		//if(owner.get_inventory().
		if (commodity != null)
		{
			owner.get_inventory().AddStock(commodity);
		}
		
		owner.AddMoney(money);
	}
	
}