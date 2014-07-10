package ecoEngine;

/**
 * ...
 * @author Michael Stephens
 */

class Agent 
{
	
	var id(get, null):Int;
	var profession(get, null):AgentClass;
		
	var inventory(get, null):Inventory = new Inventory(32);

	public function new(profession_:AgentClass) 
	{
		
		profession = profession_;
		
		
		//SetID();
		
		/*if (professionString_ != null)
		{
			profession = GetProfessionID(professionString_);
		}
		
		if (professionID_ != null)
		{
			profession = professionID_;
		}
		
		monetary_value = Std.random(101);*/
		
	}
	
	public function get_id():Int
	{
		return id;
	}
	
	public function get_profession():AgentClass
	{
		return profession;
	}
	
	public function get_inventory():Inventory
	{
		return inventory;
	}
	
	public function AddItem(commodity_:Commodity):Void
	{
		inventory.AddStock(commodity_);
	}
	
	public function Consume(name_:String, count_:Int, chance_:Float = 1):Void
	{
		if (chance_ >= Math.random())
		{
			inventory.RemoveStock(CommodityType.CreateNewCommodity(name_, count_));
		}
	}
	
	public function Produce(name_:String, count_:Int):Void
	{
		inventory.AddStock(CommodityType.CreateNewCommodity(name_, count_));
	}
	
	public function ContainsAmount(name_:String, count_:Int):Bool
	{
		return inventory.ContainsAmount(CommodityType.CreateNewCommodity(name_, count_));
	}
	
	public function Update(deltaTime:Float)
	{
		profession.SetVariables(this);
		profession.RunAllScripts();
		
		//trace(profession.get_name());
		//inventory.Print();

	}
	
	static var CURRENT_ID:Int = 0;
	private function SetID():Void
	{
		id = CURRENT_ID;
		CURRENT_ID++;
	}
	
}