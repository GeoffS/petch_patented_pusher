include <../OpenSCAD_Lib/MakeInclude.scad>
include <../OpenSCAD_Lib/torus.scad>
include <../OpenSCAD_Lib/chamferedCylinders.scad>

makeTip2 = false;
makeSection3 = false;

module tip2Pusher()
{
	// Measured Carbon 600
	tipOD = 37.4;
	tipID = 32.6;

	insertZ = 25;
	bottomRadius = 18;
	topDiameter = 27; //tipOD * 0.72;
	echo(str("#2 topDiameter = ", topDiameter));
	topCtrZ = 16;
	topPrintPlateAngle = 40;

	topPrintPlateTrimZ = topCtrZ + (topDiameter/2 * sin(90-topPrintPlateAngle));
	echo(str("topPrintPlateTrimZ = ", topPrintPlateTrimZ));

	basePusher(tipOD, tipID, insertZ, bottomRadius, topDiameter, topCtrZ, topPrintPlateAngle, topPrintPlateTrimZ);
}

module section3Pusher()
{
	// Measured Carbon 900 base
	tipOD = 41.5;
	tipID = 36.6;

	insertZ = 25;
	bottomRadius = 18;
	topDiameter = 27; //tipOD * 0.72;
	echo(str("#3 topDiameter = ", topDiameter));
	topCtrZ = 20.8; // approx. the same cone-angle as the #2 tip.
	topPrintPlateAngle = 40;

	topPrintPlateTrimZ = topCtrZ + (topDiameter/2 * sin(90-topPrintPlateAngle));
	echo(str("topPrintPlateTrimZ = ", topPrintPlateTrimZ));

	basePusher(tipOD, tipID, insertZ, bottomRadius, topDiameter, topCtrZ, topPrintPlateAngle, topPrintPlateTrimZ);
}

module basePusher(tipOD, tipID, insertZ, bottomRadius, topDiameter, topCtrZ, topPrintPlateAngle, topPrintPlateTrimZ)
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
	display() translate([-50,0,0]) tip2Pusher();
	display() section3Pusher();
}
else
{
	if(makeTip2) mirror([0,0,1]) tip2Pusher();
	if(makeSection3) mirror([0,0,1]) section3Pusher();
}
