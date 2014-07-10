package ecoEngine;

import hscript.Expr;
import hscript.Interp;
import hscript.Parser;
import sys.FileStat;
import sys.FileSystem;
import sys.io.File;
import sys.io.FileInput;

/**
 * ...
 * @author Michael Stephens
 */
class AgentClass 
{
	var compiledScripts:Array<Expr> = new Array<Expr>();
	var interp:Interp = new Interp();
	//var scriptVars:Array<Map<String, Dynamic>> = new Array<Map<String, Dynamic>>();
	var scriptVars:Map<String, Dynamic> = new Map<String, Dynamic>();
	
	var name(get, null):String;
	public function get_name():String
	{
		return name;
	}
	
	var startCommodities:Array<Commodity> = new Array<Commodity>();
	
	public function new(data_:Dynamic) 
	{
		var parser = new Parser();
		
		var loadedScripts:Array<Dynamic> = data_.scripts;
		for (a in loadedScripts)
		{
			compiledScripts.push(parser.parseString(File.getContent(a)));
		}
		
		name = data_.name;
		
		var startInventory:Array<Dynamic> = data_.inventory;
		for (a in startInventory)
		{
			startCommodities.push(new Commodity(CommodityType.GetCommodityType(a.name), a.count));
		}
		
		AddProfession(name, this);
	}
	
	public function CreateAgent():Agent
	{
		
		var agent:Agent = new Agent(this);
		SetInventory(agent.get_inventory());
		
		return agent;
		
	}
	
	public function SetInventory(inventory_:Inventory)
	{
		for (commo in startCommodities)
		{
			inventory_.AddStock(new Commodity(commo.get_type(), commo.get_count()));
		}
	}
	
	public function SetVariables(agent_:Agent)
	{
		scriptVars = 
		[
			"agent" => agent_,
			
			"CreateNewCommodity" => CommodityType.CreateNewCommodity,
			"Consume" => agent_.Consume,
			"Produce" => agent_.Produce,
			"ContainsAmount" => agent_.ContainsAmount
		];
		
		interp.variables = scriptVars;
	}
	
	public function RunAllScripts()
	{
		for (script in compiledScripts)
		{
			interp.execute(script);
		}
	}
	
	static var professions:Map<String, AgentClass> = new Map<String, AgentClass>();
	public static function AddProfession(name:String, agentClass:AgentClass):AgentClass
	{
		professions.set(name, agentClass);
		trace("Added AgentClass: " + name);
		return agentClass;
	}
	
	public static function GetProfession(name_:String):AgentClass
	{
		return professions.get(name_);
	}
	
	public static function CreateNewAgent(name_:String):Agent
	{
		return professions.get(name_).CreateAgent();
	}
	
}