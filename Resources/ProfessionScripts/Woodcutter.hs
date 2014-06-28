

if(ContainsAmount("Tool", 1))
{
	Consume("Tool", 1, 0.1);
	
	Produce("Wood", 5);
}
else
{	
	Produce("Wood", 1);
}