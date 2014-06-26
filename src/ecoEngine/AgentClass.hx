package ecoEngine;

import hscript.Expr;
import hscript.Interp;
import hscript.Parser;

/**
 * ...
 * @author Michael Stephens
 */
class AgentClass 
{
	var script:String;
	var compiledScript:Expr;
	var interp:Interp = new Interp();
	var scriptVars:Map<String, Dynamic>;
	
	var name:String;
	var startCash:Int;
	var startCommodities:Array<Commodity> = new Array<Commodity>();
	
	public function new(data_:Dynamic) 
	{
		var parser = new Parser();
		compiledScript = parser.parseString(data_.script);
		
		name = data_.name;
		
		startCash = data_.money;
		var startInventory:Array<Dynamic> = data_.inventory;
		for (a in startInventory)
		{
			startCommodities.push(new Commodity(CommodityType.GetCommodityType(a.name), a.count));
		}
	}
	
	public function SetVariables()
	{
		scriptVars = 
		[
			"trace" => haxe.Log.trace,
			"name" => "woodcutter"
		];
		
		interp.variables = scriptVars;
	}
	
	public function RunScript()
	{
		interp.execute(compiledScript);
	}
	
	static var professions:Map<String, AgentClass> = new Map<String, AgentClass>();
	public static function AddProfession(name:String, agentClass:AgentClass):AgentClass
	{
		professions.set(name, agentClass);
		trace("Added AgentClass: " + name);
		return agentClass;
	}
	
}