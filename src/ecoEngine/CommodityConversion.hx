package ecoEngine;

/**
 * ...
 * @author Michael Stephens
 */
class CommodityConversion
{
	var name:String;
	var requirements:Array<Commodity> = new Array<Commodity>();
	var requirementsFunctions:Array < Inventory->Bool > = new Array < Inventory->Bool > ();
	
	var conversionFunctions:Array < CommodityConversion->Inventory->Void > = new Array < CommodityConversion->Inventory->Void > ();
	
	var produce:Array<Commodity> = new Array<Commodity>();
	
	public function new(name_:String)
	{
		name = name_;
	}
	
	public function AddRequirement(?commodity_:Commodity, ?func_:Inventory->Bool):CommodityConversion
	{
		if (commodity_ != null)
		{
			requirements.push(commodity_);
		}
		
		if (func_ != null)
		{
			requirementsFunctions.push(func_);
		}
		
		return this;
	}
	
	public function AddConversionFunction(func_:CommodityConversion->Inventory->Void):CommodityConversion
	{
		conversionFunctions.push(func_);
		return this;
	}

	public function AddProduce(commodity_:Commodity):CommodityConversion
	{
		produce.push(commodity_);
		return this;
	}
	
	public function CanProduce(inventory_:Inventory):Bool
	{
		for (i in 0...requirements.length)
		{
			if (!inventory_.ContainsAmount(requirements[i]))
			{
				return false;
			}
		}
		
		for (i in 0...requirementsFunctions.length)
		{
			if (!requirementsFunctions[i](inventory_))
			{
				return false;
			}
		}
		
		return true;
	}
	
	public function ConvertItems(inventory_:Inventory):Void
	{
		if (CanProduce(inventory_))
		{
			for (i in 0...requirements.length)
			{
				inventory_.RemoveStock(requirements[i]);
			}
			
			for (i in 0...conversionFunctions.length)
			{
				conversionFunctions[i](this, inventory_);
			}
			
			for (i in 0...produce.length)
			{
				inventory_.AddStock(produce[i]);
			}
		}
	}
	
	static var commodityConversions:Map < Int, Array<CommodityConversion> > = new Map < Int, Array<CommodityConversion> > ();
	
	public static function AddConversion(proffesion_:String, conversion_:CommodityConversion)
	{
		var id:Int = Agent.GetProfessionID(proffesion_);
		var array:Array<CommodityConversion> = commodityConversions.get(id);
		if (array == null)
		{
			array = new Array<CommodityConversion>();
			commodityConversions.set(id, array);
		}
		array.push(conversion_);
		//commodityConversions.set(id, conversion_);
	}
	
	public static function GetCommodityConversion(?proffesionID_:Int, ?proffesion_:String):CommodityConversion
	{
		var id:Int = -1;
		if (proffesionID_ != null)
		{
			id = proffesionID_;
		}
		else if(proffesion_ != null)
		{
			id = Agent.GetProfessionID(proffesion_);
		}
		else
		{
			return null;
		}
		
		var array:Array<CommodityConversion> = commodityConversions.get(id);
		
		if (array != null)
		{
			return array[Std.random(array.length)];
		}
		
		return null;
	}
	
	/*static var conversionConditionArray:Array < Inventory->Bool > = new Array < Inventory->Bool > ();
	static var conversionActionArray:Array < Inventory->Void > = new Array < Inventory->Void > ();
	public static function AddConversion(condition_:Inventory->Bool, action_:Inventory->Void)
	{
		conversionConditionArray[conversionConditionArray.length] = condition_;
		conversionActionArray[conversionActionArray.length] = action_;
	}*/
	
}