package ecoEngine;

import cpp.Lib;
import cpp.vm.Thread;
import cpp.vm.Mutex;
import haxe.Constraints.Function;
import haxe.Timer;

/**
 * ...
 * @author Michael Stephens
 */

class Main 
{
	
	var agents:Array<Agent> = new Array<Agent>();
	
	public function new()
	{
		Agent.AddProfession("Farmer");
		Agent.AddProfession("Woodcutter");
		Agent.AddProfession("Miner");
		Agent.AddProfession("Blacksmith");
		
		Commodity.AddCommodity("Wood");
		Commodity.AddCommodity("Food");
		Commodity.AddCommodity("Iron");
		Commodity.AddCommodity("Tool");
		
		CommodityConversion.AddConversion("Farmer", 
			new CommodityConversion("Food")
			.AddRequirement(null, function(inv_:Inventory):Bool
			{
				return inv_.ContainsAmount(new Commodity("Tool", null, 1, null));
			})
			.AddConversionFunction(function(comConv_:CommodityConversion, inv_:Inventory):Void
			{
				var broke:Int = Std.random(20);
				if (broke == 0)
				{
					inv_.RemoveStock(new Commodity("Tool", null, 1, null));
				}
			})
			.AddProduce(new Commodity("Food", null, 10, null))
		);
		
		CommodityConversion.AddConversion("All", new CommodityConversion("Eat").AddRequirement(new Commodity("Food", null, 1, null)));
		
		CommodityConversion.AddConversion("Woodcutter", 
			new CommodityConversion("Wood")
			.AddRequirement(null, function(inv_:Inventory):Bool
			{
				return inv_.ContainsAmount(new Commodity("Tool", null, 1, null));
			})
			.AddConversionFunction(function(comConv_:CommodityConversion, inv_:Inventory):Void
			{
				var broke:Int = Std.random(20);
				if (broke == 0)
				{
					inv_.RemoveStock(new Commodity("Tool", null, 1, null));
				}
			})
			.AddProduce(new Commodity("Wood", null, 5, null))
		);
		
		CommodityConversion.AddConversion("Miner", 
			new CommodityConversion("Iron")
			.AddRequirement(null, function(inv_:Inventory):Bool
			{
				return inv_.ContainsAmount(new Commodity("Tool", null, 1, null));
			})
			.AddConversionFunction(function(comConv_:CommodityConversion, inv_:Inventory):Void
			{
				var broke:Int = Std.random(20);
				if (broke == 0)
				{
					inv_.RemoveStock(new Commodity("Tool", null, 1, null));
				}
			})
			.AddProduce(new Commodity("Iron", null, 3, null))
		);
		
		CommodityConversion.AddConversion("Blacksmith", new CommodityConversion("Tools")
			.AddRequirement(new Commodity("Iron", null, 2, null))
			.AddRequirement(null, function(inv_:Inventory):Bool
			{
				return inv_.ContainsAmount(new Commodity("Tool", null, 1, null));
			})
			.AddConversionFunction(function(comConv_:CommodityConversion, inv_:Inventory):Void
			{
				var broke:Int = Std.random(20);
				if (broke == 0)
				{
					inv_.RemoveStock(new Commodity("Tool", null, 1, null));
				}
			})
			.AddProduce(new Commodity("Tool", null, 1, null))
		);
		
		for (i in 0...20)
		{
			agents[i] = new Agent(null, Std.random(4));
			agents[i].AddItem(new Commodity("Tool", null, 5, agents[i].get_id()));
		}
		
		//TickResources();
		
		var flag:Bool = true;
		
		while (flag)
		{
			TickResources();
		}
		
	}
	
	public function TickResources()
	{
		
		for (i in agents)
		{
			i.Update();
		}
		
	}

	static function main() 
	{
		new Main();
	}
	
}

/*Commodity.AddConversion(
			function(inventory_:Inventory):Bool
			{
				if (inventory_.Contains(Commodity.GetCommodityID("Food")))
				{
					return true;
				}
				return false;
			},
			function(inventory_:Inventory):Void
			{
				inventory_.RemoveStock(Commodity.GetCommodityID("Food"), 2);
				inventory_.AddStock(null, Commodity.GetCommodityID("Wood"), 5);
			}
			);*/

/*package ecoEngine;

import cpp.Lib;
import cpp.vm.Thread;
import cpp.vm.Mutex;

/**
 * ...
 * @author Michael Stephens
 */
/*
class ThreadObject
{
	public var update:Bool = false;
	public var mutex:Mutex = new Mutex();
	
	public var threadID:Int = 0;
	public var numArray:Array<Int> = new Array<Int>();
}

class ThreadArguments
{
	
	public function new(id_:Int, threadObj_:ThreadObject, runAmount_:Int)
	{
		id = id_;
		threadObj = threadObj_;
		runAmount = runAmount_;
	}
	
	public var id:Int;
	public var threadObj:ThreadObject;
	public var runAmount:Int;
}

class Main 
{
	
	public function new()
	{
		Agent.AddProfession("Farmer");
		Agent.AddProfession("Woodcutter");
		Agent.AddProfession("Miner");
		Agent.AddProfession("Blacksmith");
		
		var array:Array<Int> = new Array<Int>();
		
		var threadMax:Int = 100;
		var threads:Array<Thread> = new Array<Thread>();
		var threadObj:ThreadObject = new ThreadObject();
		
		
		for (i in 0...threadMax)
		{
			var threadArg:ThreadArguments = new ThreadArguments(i, threadObj, 10000);
			threads[i] = Thread.create(run);
			threads[i].sendMessage(threadArg);
		}
		
		for(i in 0...threadMax)
		{
			var finished:Bool = false;
			while (finished == false)
			{
				threadObj.mutex.acquire();
				if (threadObj.update == true)
				{
					var threadID:Int = threadObj.threadID;
					var values:Array<Int> = threadObj.numArray;
					trace("Thread " + threadID + " returned with " + values[0] + " under and " + values[1] + " over with currentWait at  " + i);
					threadObj.update = false;
					
					array[0] += values[0];
					array[1] += values[1];
					finished = true;
				}
				threadObj.mutex.release();
			}
			
		}
		
		trace("final count is " + array[0] + " under and " + array[1] + " over");
	}
	
	
	public function run():Void
	{
		var args:ThreadArguments = Thread.readMessage(true);
		
		var numbers:Array<Int> = CalculateRandomness(args.runAmount);
		
		var finished:Bool = false;
		while (finished == false)
		{
			args.threadObj.mutex.acquire();
			if (args.threadObj.update == false)
			{
				args.threadObj.threadID = args.id;
				args.threadObj.numArray = numbers;
				args.threadObj.update = true;
				finished = true;
			}
			args.threadObj.mutex.release();
		}
	}
	
	public function CalculateRandomness(times:Int):Array<Int>
	{
		var returnee:Array<Int> = new Array<Int>();
		
		for (a in 0...times)
		{
			var maxAgents:Int = 100;
			var agents:Array<Agent> = new Array<Agent>();
			
			for (i in 0...maxAgents)
			{
				agents[i] = new Agent(Std.random(4));
			}
			
			var totalMoney:Float = 0;
			agents.map(function(a:Agent) { totalMoney += a.get_monetary_value(); } );
			//trace("totalMoney = " + totalMoney + " withAverage = " + totalMoney / agents.length);
			
			(totalMoney / agents.length) < 50 ? returnee[0]++ : returnee[1]++;
		}
		
		return returnee;
	}
	
	static function main() 
	{
		new Main();
	}
	
}*/