include <../OpenSCAD_Lib/MakeInclude.scad>
include <../OpenSCAD_Lib/torus.scad>
include <../OpenSCAD_Lib/chamferedCylinders.scad>

makeTip2 = false;
makeSection3 = false;

module tip2Pusher()
{
	// Measured Carbon 600
	tipOD = 38.0;
	tipID = 33.1;

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
	tipOD = 42.0;
	tipID = 36.9;

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

	// The insert into the mast-section:
	insertCZ = 3;
	bumpDia = 2*insertCZ;
	mirror([0,0,1]) 
	{
		translate([0,0,-1]) simpleChamferedCylinder(d=tipID-0.8, h=insertZ+1, cz=insertCZ);

		for (a=[0:30:359]) 
		{
			// rotate([0,0,a]) translate([tipID/2-bumpDia/2+0.2,0,0]) simpleChamferedCylinder(d=bumpDia, h=insertZ, cz=insertCZ);
			rotate([0,0,a]) translate([tipID/2-bumpDia/2,0,0]) hull()
			{
				translate([0.2,0,0]) cylinder(d=bumpDia, h=insertZ-insertCZ);
				// MAGIC NUMBER: 0.5
				translate([-0.5,0,insertZ-insertCZ]) cylinder(d1=bumpDia, d2=0, h=insertCZ);
			}
		}
	}
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
