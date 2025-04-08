include <../OpenSCAD_Lib/MakeInclude.scad>
include <../OpenSCAD_Lib/torus.scad>
include <../OpenSCAD_Lib/chamferedCylinders.scad>

makeTip2Pusher = false;

tipOD = 40;
tipID = 35;

insertZ = 30;
bottomRadius = 20;
topDiameter = tipOD * 0.65;
topCtrZ = 25;
topPrintPlateAngle = 40;

topPrintPlateTrimZ = topCtrZ + (topDiameter/2 * sin(90-topPrintPlateAngle));
echo(str("topPrintPlateTrimZ = ", topPrintPlateTrimZ));

module tip2Pusher()
{
	difference()
	{
		hull()
		{
			tsp([0,0,topCtrZ], d=topDiameter);

			bottomTranslation = tipOD/2 - (bottomRadius);
			echo(str("bottomTranslation = ", bottomTranslation));
			torus2(radius=bottomRadius, translation=bottomTranslation);
		}

		// Trim-off stuff below the top of the tip:
		tcu([-200, -200, -400], 400);

		// Trim the top for printability:
		tcu([-200, -200,topPrintPlateTrimZ], 400);
	}

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
	if(makeTip2Pusher) mirror([0,0,1]) tip2Pusher();
}
