include <../OpenSCADdesigns/MakeInclude.scad>

makeTip2Pusher = false;

module tip2Pusher()
{
	
}

module clip(d=0)
{
	//tc([-200, -400-d, -10], 400);
}

if(developmentRender)
{
	display() tip2Pusher();
}
else
{
	if(makeTip2Pusher) tip2Pusher();
}
