

if(ContainsAmount("Tool", 1))
{
	Consume("Tool", 1, 0.1);
	
	Produce("Food", 5);
}
else
{	
	Produce("Food", 1);
}