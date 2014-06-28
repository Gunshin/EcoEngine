

if(ContainsAmount("Iron", 2) && ContainsAmount("Tool", 1))
{
	Consume("Iron", 2);
	Consume("Tool", 1, 0.1);
	
	Produce("Tool", 1);
}
else if(ContainsAmount("Iron", 4))
{
	Consume("Iron", 4);
	
	Produce("Tool", 1);
}