include <../OpenSCAD_Lib/MakeInclude.scad>
include <../OpenSCAD_Lib/torus.scad>
include <../OpenSCAD_Lib/chamferedCylinders.scad>

makeTip2Pusher = false;

tipOD = 40;
tipID = 35;

insertZ = 30;
bottomRadius = 20;
topDiameter = tipOD * 0.6;
topCtrZ = 30;
topPrintPlateAngle = 50;

module tip2Pusher()
{
	difference()
	{
		hull()
		{
			tsp([0,0,topCtrZ], d=topDiameter);

			bottomTranslation = tipOD/2 - (bottomRadius);
			echo(str("bottomTranslation = ", bottomTranslation));
			torus2(radius=bottomRadius, translation=bottomTranslation); //tipOD-(2*bottomRadius));
		}
		tcu([-200, -200, -400], 400);
	}

	//tcy([0,0,-insertZ], d=tipID, h=insertZ+1);
	mirror([0,0,1]) translate([0,0,-1]) simpleChamferedCylinder(d=tipID, h=insertZ+1, cz=3);
}

module clip(d=0)
{
	// tc([-200, -400-d, -200], 400);
}

if(developmentRender)
{
	display() tip2Pusher();
}
else
{
	if(makeTip2Pusher) tip2Pusher();
}
