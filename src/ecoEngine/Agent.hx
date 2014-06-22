package ecoEngine;

/**
 * ...
 * @author Michael Stephens
 */

class Agent 
{
	
	var id(get, null):Int;
	var profession(get, null):Int;
	
	var monetary_value(get, null):Int;
	
	var inventory(get, null):Inventory = new Inventory(32);

	public function new(?professionString_:String, ?professionID_:Int) 
	{
		
		SetID();
		
		if (professionString_ != null)
		{
			profession = GetProfessionID(professionString_);
		}
		
		if (professionID_ != null)
		{
			profession = professionID_;
		}
		
		monetary_value = Std.random(101);
		
	}
	
	public function get_id():Int
	{
		return id;
	}
	
	public function get_profession():Int
	{
		return profession;
	}
	
	public function get_monetary_value():Int
	{
		return monetary_value;
	}
	
	public function get_inventory():Inventory
	{
		return inventory;
	}
	
	public function AddItem(commodity_:Commodity):Void
	{
		inventory.AddStock(commodity_);
	}
	
	var ticksUntilNextResource:Int = 0;
	
	public function Update()
	{
		
		if (ticksUntilNextResource == 0)
		{
			ticksUntilNextResource = 100 + Std.random(100);
			
			var conv:CommodityConversion = CommodityConversion.GetCommodityConversion(profession);
			
			conv.ConvertItems(inventory);
			
			inventory.Print();
		}
		
		ticksUntilNextResource--;
	}
	
	static var CURRENT_ID:Int = 0;
	private function SetID():Void
	{
		id = CURRENT_ID;
		CURRENT_ID++;
	}
	
	static var CURRENT_PROFESSION_ID:Int = 0;
	static var professions:Map<String, Int> = new Map<String, Int>();
	public static function AddProfession(name:String):Int
	{
		professions.set(name, CURRENT_PROFESSION_ID);
		trace("Added profession: " + name + " to ID: " + CURRENT_PROFESSION_ID);
		CURRENT_PROFESSION_ID++;
		return CURRENT_PROFESSION_ID - 1;
	}
	
	public static function GetProfessionID(name:String):Int
	{
		var value = professions.get(name);
		if (value == null)
		{
			value = AddProfession(name);
		}
		return value;
	}
}