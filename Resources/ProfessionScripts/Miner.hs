

if(ContainsAmount("Tool", 1))
{
	Consume("Tool", 1, 0.1);
	
	Produce("Iron", 3);
}
else
{	
	Produce("Iron", 1);
}