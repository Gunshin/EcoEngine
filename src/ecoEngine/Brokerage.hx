package ecoEngine;

/**
 * ...
 * @author Michael Stephens
 */
class Brokerage 
{
	
	var buyOrders:Map < CommodityType, Array<BuyOrder> > = new Map < CommodityType, Array<BuyOrder> > ();
	var sellOrders:Map < CommodityType, Array<SellOrder> > = new Map < CommodityType, Array<SellOrder> > ();
	
	var completedOrders:Array<FinishedOrder> = new Array<FinishedOrder>();
	
	var inventory:Inventory = new Inventory(512);
	
	public function new() 
	{
		
	}
	
	public function SellCommodity(owner_:Agent, commodityToSell_:Commodity, totalMoney_:Commodity):Void
	{
		var amountPerItem:Int = cast(totalMoney_.get_count() / commodityToSell_.get_count(), Int);
		
		// check existing buy orders
		var existingBuyOrders:Array<BuyOrder> = buyOrders[commodityToSell_.get_type()];
		
		// sell existing orders to agent
		for (i in existingBuyOrders)
		{
			// if we can get the amount we are looking to sell for or more do it
			if (amountPerItem <= i.GetCostPerItem())
			{
				// complete the transaction
				var fOrders:Array<FinishedOrder> = i.Completed(owner_, commodityToSell_);
				
				for (i in 0...fOrders.length)
				{
					// since the seller is at the brokerage, give him the goods immediately. Add the buyers goods to the competedOrders awaiting collection.
					if (fOrders[i].get_owner() == owner_)
					{
						fOrders[i].TransferGoods();
					}
					else
					{
						completedOrders.push(fOrders[i]);
					}
				}
			}
			else
			{
				break;
			}
		}
		
		if (commodityToSell_.get_count() > 0)
		{
			AddSellOrder(owner_, commodityToSell_, new Commodity(CommodityType.GetCommodityType("Money"), amountPerItem * commodityToSell_.get_count()));
		}
	}
	
	function AddSellOrder(owner_:Agent, commodity_:Commodity, totalMoney_:Commodity)
	{
		var array:Array<SellOrder> = sellOrders[commodity_.get_type()];
		
		var costPerItem:Int = cast(commodity_.get_count() / totalMoney_.get_count(), Int);
		
		if (array == null)
		{
			array = new Array<SellOrder>();
			sellOrders[commodity_.get_type()] = array;
			array.push(new SellOrder(owner_, commodity_, totalMoney_));
			return;
		}
		else
		{
			for (i in 0...array.length - 1)
			{
				if (array[i].GetCostPerItem() > costPerItem)
				{
					array.insert(i, new SellOrder(owner_, commodity_, totalMoney_));
					return;
				}
			}
			array.push(new SellOrder(owner_, commodity_, totalMoney_));
		}
	}
	
	public function BuyCommodity(owner_:Agent, commodityToBuy_:Commodity, totalMoney_:Commodity):Void
	{
		var amountPerItem:Int = cast(totalMoney_.get_count() / commodityToBuy_.get_count(), Int);
		
		// check existing sell orders
		var existingSellOrders:Array<SellOrder> = sellOrders[commodityToBuy_.get_type()];
		
		// sell existing orders to agent
		for (i in existingSellOrders)
		{
			// if we can get less than the amount we are looking to buy for do it.
			if (amountPerItem >= i.GetCostPerItem())
			{
				// complete the transaction
				var fOrders:Array<FinishedOrder> = i.Completed(owner_, totalMoney_);
				
				for (i in 0...fOrders.length)
				{
					// since the buyer is at the brokerage, give him the goods immediately. Add the sellers money to the competedOrders awaiting collection.
					if (fOrders[i].get_owner() == owner_)
					{
						// remove the amount from commodityToBuy so we dont end up attempting to buy more than wanted
						commodityToBuy_.Remove(fOrders[i].GetSize());
						fOrders[i].TransferGoods();
					}
					else
					{
						completedOrders.push(fOrders[i]);
					}
				}
				
				// recalculate incase amount per item increases allowing for a broader range of selling targets.
				amountPerItem = cast(totalMoney_.get_count() / commodityToBuy_.get_count(), Int);
			}
			else
			{
				break;
			}
		}
		
		if (commodityToBuy_.get_count() > 0)
		{
			AddBuyOrder(owner_, commodityToBuy_, totalMoney_);
		}
	}
	
	function AddBuyOrder(owner_:Agent, commodity_:Commodity, totalMoney_:Commodity)
	{
		var amountPerItem:Int = cast(totalMoney_.get_count() / commodity_.get_count(), Int);
		
		var array:Array<BuyOrder> = buyOrders[commodity_.get_type()];
		
		if (array == null)
		{
			array = new Array<BuyOrder>();
			buyOrders[commodity_.get_type()] = array;
			array.push(new BuyOrder(owner_, commodity_, totalMoney_));
			return;
		}
		else
		{
			for (i in 0...array.length - 1)
			{
				if (array[i].GetCostPerItem() > amountPerItem)
				{
					array.insert(i, new BuyOrder(owner_, commodity_, totalMoney_));
					return;
				}
			}
			array.push(new BuyOrder(owner_, commodity_, totalMoney_));
		}
	}
	
	public function CheckForCompletedTransactions(owner_:Agent)
	{
		
		for (i in 0...completedOrders.length)
		{
			if (completedOrders[i].get_owner() == owner_)
			{
				completedOrders[i].TransferGoods();
			}
		}
		
	}
	
}

class BuyOrder
{
	
	var money(get, null):Commodity;
	public function get_money():Commodity
	{
		return money;
	}
	
	var commodityBeingBought(get, null):Commodity;
	public function get_commodityBeingBought():Commodity
	{
		return commodityBeingBought;
	}
	
	var owner(get, null):Agent;
	public function get_owner():Agent
	{
		return owner;
	}

	public function new(owner_:Agent, commodity_:Commodity, money_:Commodity)
	{
		commodityBeingBought = commodity_;
		owner = owner_;
		money = money_;
	}
	
	public function GetCostPerItem():Int
	{
		return cast(money.get_count() / commodityBeingBought.get_count(), Int);
	}
	
	public function Completed(seller_:Agent, commodityBeingBought_:Commodity):Array<FinishedOrder>
	{
		var finishedOrders:Array<FinishedOrder> = new Array<FinishedOrder>();
		
		// determine how much of the good is being traded
		var amountMoved:Int = cast(Math.min(commodityBeingBought_.get_count(), commodityBeingBought.get_count()), Int);
		var amountOfMoney:Int = amountMoved * GetCostPerItem();
		
		finishedOrders.push(new FinishedOrder(seller_, money.Split(amountOfMoney)));
		finishedOrders.push(new FinishedOrder(owner, commodityBeingBought_.Split(amountMoved)));
		
		return finishedOrders;
	}
	
}

class SellOrder
{
	
	var moneyBeingAskedFor(get, null):Commodity;
	public function get_moneyBeingAskedFor():Commodity
	{
		return moneyBeingAskedFor;
	}
	
	var commodityBeingSold(get, null):Commodity;
	public function get_commodityBeingSold():Commodity
	{
		return commodityBeingSold;
	}
	
	var owner(get, null):Agent;
	public function get_owner():Agent
	{
		return owner;
	}

	public function new(owner_:Agent, commodity_:Commodity, money_:Commodity)
	{
		owner = owner_;
		commodityBeingSold = commodity_;
		moneyBeingAskedFor = money_;
	}
	
	public function GetCostPerItem():Int
	{
		return cast(moneyBeingAskedFor.get_count() / commodityBeingSold.get_count(), Int);
	}
	
	public function Completed(buyer_:Agent, money_:Commodity):Array<FinishedOrder>
	{
		var finishedOrders:Array<FinishedOrder> = new Array<FinishedOrder>();
		
		// determine how much of the good is being traded
		var maxAmountOfMoneyBeingTraded:Int = cast(Math.min(money_.get_count(), moneyBeingAskedFor.get_count()), Int);
		
		var maxAmountOfCommodityBeingTraded:Int = cast(maxAmountOfMoneyBeingTraded / GetCostPerItem(), Int);
		
		// make sure that we stay within the boundaries of the sell order ie. cant sell more than we have
		var finalAmountOfCommodityBeingTraded:Int = cast(Math.min(commodityBeingSold.get_count(), maxAmountOfCommodityBeingTraded), Int);
		var finalAmountOfMoneyBeingTraded:Int = finalAmountOfCommodityBeingTraded * GetCostPerItem();
		
		finishedOrders.push(new FinishedOrder(owner, money_.Split(finalAmountOfMoneyBeingTraded)));
		finishedOrders.push(new FinishedOrder(buyer_, commodityBeingSold.Split(finalAmountOfCommodityBeingTraded)));
		
		return finishedOrders;
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
	
	public function new(agent_:Agent, commodity_:Commodity)
	{
		owner = agent_;
		
		commodity = commodity_;
	}
	
	public function GetSize():Int
	{
		return commodity.get_count();
	}
	
	public function TransferGoods():Bool
	{
		owner.get_inventory().AddStock(commodity);
		return true;
	}
	
}