use strict;
use warnings;

our %configuration;
our $startS;
our $endS;


#
#  large angle side(top) -->  /\
#                             \ \
#      Side view               \ \
#                               \ \
#                                \ \
#                                 \_\   <-- small angle vertex(bottom)
#  target  o
# 
# We are using the Hall B coordinate system with the origin at the target center.

# The bottom (downstream) of the CC will be dx1, dy1, the top will be dx2, dy2

# From the top, upstream:
#
#               pdx2
#       --------------------
#       \         |        /
#		   \        |       /
#	 	    \       |      /
#		 	  \      |     /
#			   \     |    /
#				 \    |   /
#				  --------
#               pdx1
#
# From the top, downstream:
#
#               pdx4
#       --------------------
#       \         |        /
#		   \        |       /
#	 	    \       |      /
#		 	  \      |     /
#			   \     |    /
#				 \    |   /
#				  --------
#               pdx3
#



# The downstream and upstream plates in the trapezoid are parallel
#
# From the side
# 
#
#             ------- --- DIFF must be same for pdx1 and pdx2
#            /       \
#           /         \
#          /           \
#         --------------
#

sub build_ltcc_box()
{
	my $DIFF = 235;
	
	my $pDx1   = 240;
	my $pDx2   = 2000;
	my $pDz    = 500;
	my $pTheta = 0;
	my $pPhi   = 0;
	my $pDy1   = 1700;
	my $pDy2   = 1700 ;
	my $pDx3   = $pDx1 - $DIFF;
	my $pDx4   = $pDx2 - $DIFF;
	my $pAlp1  = 0;

	my %detector = init_det();
	$detector{"name"}        = "ltccTrap";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Light Threshold Cerenkov Counter";
	$detector{"color"}       = "110088";
	$detector{"type"}        = "G4Trap";
	$detector{"dimensions"}  = "$pDz*mm $pTheta*deg $pPhi*deg $pDy1*mm $pDx1*mm $pDx2*mm $pAlp1*deg $pDy2*mm $pDx3*mm $pDx4*mm $pAlp1*deg";
	$detector{"material"}    = "Component";
	print_det(\%configuration, \%detector);
	
	
	
	# Subtract box at 45ish degrees from the top
	# The upper coordinate is at:
	# x = 0
	# y = $dy1
	# z = depth/2  
	
	my $y_upper = $pDy1;
	my $z_upper = $pDz;
	
	my $box_x   = 3000.0;
	my $box_y   =  600.0;
	my $box_z   = 3000.0;
	
	
	# box angle on the top is 45 - 25
	my $box_angle    = -20*$pi/180.0;
	my $absbox_angle =  20*$pi/180.0;
		
	my $y_box_p =  $y_upper - ($box_z*sin($absbox_angle) - $box_y*cos($absbox_angle));
	my $z_box_p = -$z_upper + ($box_z*cos($absbox_angle) + $box_y*sin($absbox_angle));
	
	%detector = init_det();
	$detector{"name"}        = "ltccTopBox";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Box to subtract from LTCC";
	$detector{"pos"}         = "0*mm $y_box_p*mm $z_box_p*mm";
	$detector{"rotation"}    = "$box_angle*rad 0*deg 0*deg"; 
	$detector{"color"}       = "110088";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "$box_x*mm $box_y*mm $box_z*mm";
	$detector{"material"}    = "Component";
	print_det(\%configuration, \%detector);

	# Trap - Box
	%detector = init_det();
	$detector{"name"}        = "ltccMinusTopBox";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Trap minus Top Box ";
	$detector{"color"}       = "110088";
	$detector{"type"}        = "Operation:  ltccTrap - ltccTopBox";
	$detector{"dimensions"}  = "0";
	$detector{"material"}    = "Component";
	print_det(\%configuration, \%detector);
	
	
	
	# Subtract tube 
	my $R  = 3250;
	my $DZ = 4500;
	
	my $zpos = 3500;
	my $ypos  = -600;
	
	%detector = init_det();
	$detector{"name"}        = "ltccTubeHole";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Tube to subtract from LTCC ";
	$detector{"pos"}         = "0*mm $ypos*mm $zpos*mm";
	$detector{"rotation"}    = "0*deg 90*deg 0*deg"; 
	$detector{"color"}       = "110088";
	$detector{"type"}        = "Tube";
	$detector{"dimensions"}  = "0*mm $R*mm $DZ*mm 0*deg 360*deg";
	$detector{"material"}    = "Component";
	print_det(\%configuration, \%detector);
	
	
	# Trap - Box - Tube
	%detector = init_det();
	$detector{"name"}        = "ltccTrapMinusHole";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Trap minus Top Box minus Tube";
	$detector{"color"}       = "110088";
	$detector{"type"}        = "Operation:  ltccMinusTopBox - ltccTubeHole";
	$detector{"dimensions"}  = "0";
	$detector{"material"}    = "Component";
	print_det(\%configuration, \%detector);
	



	# Subtract box at 25ish degrees from the bottom
	# The upper coordinate is at:
	# x = 0
	# y = -$c_d 
	# z = depth/2  
	
	$y_upper = -$pDy1-100;
	$z_upper = $pDz;
	
	$box_x   = 3000.0;
	$box_y   =  800.0;
	$box_z   = 3000.0;
	
	$box_angle    =  25*$pi/180.0;
	$absbox_angle =  25*$pi/180.0;
		
	$y_box_p =  $y_upper + ($box_z*sin($absbox_angle) - $box_y*cos($absbox_angle));
	$z_box_p = -$z_upper + ($box_z*cos($absbox_angle) + $box_y*sin($absbox_angle));
	
	%detector = init_det();
	$detector{"name"}        = "ltccBottomBox";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Box to subtract from LTCC";
	$detector{"pos"}         = "0*mm $y_box_p*mm $z_box_p*mm";
	$detector{"rotation"}    = "$box_angle*rad 0*deg 0*deg"; 
	$detector{"color"}       = "110088";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "$box_x*mm $box_y*mm $box_z*mm";
	$detector{"material"}    = "Component";
	print_det(\%configuration, \%detector);


	# Trap - Box - Tube - Box 2
	# these numbers are empirical to match
	# by eyes the box to the mirror position
	my $tBoxZ = 3900;
	my $tBoxY = 1800;
	%detector = init_det();
	$detector{"name"}        = "trapBox";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Trap minus Top Box minus Tube minus Bottom Box";
	$detector{"pos"}         = "0*mm $tBoxY*mm $tBoxZ*mm";
	$detector{"rotation"}    = "25*deg 180*deg 0*deg";
	$detector{"color"}       = "110088";
	$detector{"type"}        = "Operation:  ltccTrapMinusHole - ltccBottomBox";
	$detector{"dimensions"}  = "0";
	$detector{"material"}    = "Component";
	print_det(\%configuration, \%detector);
	
	%detector = init_det();
	$detector{"name"}        = "ltcc_big_box";
	$detector{"mother"}      = "root";
	$detector{"description"} = "Light Threshold Cerenkov Counter Box at the origin";
	$detector{"type"}        = "Box";
	$detector{"dimensions"}  = "3*m 5*m 6*m";
	$detector{"material"}    = "Component";
	print_det(\%configuration, \%detector);

	
	for(my $n=$startS; $n<=$endS; $n++)
	{
      my $c6toc12Z = 1700;
      #my $c6toc12Z = 0;
		my $rotPhi = 90 - ($n-1)*60;
		# Final box - Big Box * TrapBox
		%detector = init_det();
		$detector{"name"}        = "ltccS$n";
		$detector{"mother"}      = "fc";
		$detector{"description"} = "ltcc sector $n";
		$detector{"pos"}         = "0*mm 0*mm $c6toc12Z*mm";
		$detector{"rotation"}    = "0*deg 0*deg $rotPhi*deg";
		$detector{"color"}       = "110088";
		$detector{"type"}        = "Operation:  ltcc_big_box * trapBox";
		$detector{"dimensions"}  = "0";
		$detector{"visible"}     = 0;
		$detector{"material"}    = "C4F10";
		print_det(\%configuration, \%detector);

	}
	

	
	
}














