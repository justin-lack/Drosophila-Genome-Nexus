#!/usr/bin/perl -w
use strict;

#####

my $chr = 'ChrX';
my $LocusName = 'yellow';  #A name for your output file(s)
my $PosStart = 235001;  #The first reference genome position to include in your file(s)
my $PosStop = 265000;  #The last reference genome position to include in your file(s)
my $RevComp = 'No';  #Reverse complement the output files?  'Yes' or 'No'
my $SingleOutputFile = 'Yes';  #Set to 'Yes' for a single multi-individual unformatted sequence file.  Set to 'No' to create a separate FastA file for each individual

#Reduce the list below to the genomes you want data from
my @InLines = ('CK1', 'CK2', 'CO1', 'CO10b-3', 'CO10N', 'CO13N', 'CO14', 'CO15N', 'CO16', 'CO16-3', 'CO2', 'CO4N', 'CO8b-3', 'CO8N', 'CO9N', 'ED10N', 'ED19-1-3', 'ED2', 'ED3', 'ED55-2', 'ED56-2', 'ED5N', 'ED6N', 'EZ2', 'EZ25', 'EZ5N', 'EZ63-1-3', 'EZ9N', 'FR14', 'FR151', 'FR180', 'FR207', 'FR217', 'FR229', 'FR310', 'FR361', 'FR70', 'GA125', 'GA129', 'GA130', 'GA132', 'GA141', 'GA145', 'GA160', 'GA185', 'GA187', 'GA191', 'GU10', 'GU11-3', 'GU2', 'GU3-3', 'GU6', 'GU7', 'GU9', 'KN133N', 'KN20N', 'KN34', 'KN35', 'KN6', 'KN73-1-3', 'KO10-1-3', 'KO2-1-3', 'KO6-1-3', 'KR39', 'KR42', 'KR4N', 'KR54-1-3', 'KR68-1-3', 'KR7', 'KT1', 'KT6', 'MW11-1', 'MW27-3', 'MW28-1', 'MW28-2-3', 'MW38-1', 'MW38-2', 'MW46-1', 'MW56-2-3', 'MW6-1', 'MW6-2', 'MW6-3', 'MW63-1', 'MW63-2-3', 'MW9-1', 'MW9-2', 'NG10N', 'NG1N', 'NG3N', 'NG6N', 'NG7', 'NG9', 'RC1', 'RC5', 'RG10', 'RG11N', 'RG13N', 'RG15', 'RG18N', 'RG19', 'RG2', 'RG21N', 'RG22', 'RG24', 'RG25', 'RG28', 'RG3', 'RG32N', 'RG33', 'RG34', 'RG35', 'RG36', 'RG37N', 'RG38N', 'RG39', 'RG4N', 'RG5', 'RG6N', 'RG7', 'RG8', 'RG9', 'SP173', 'SP188', 'SP221', 'SP235', 'SP241', 'SP254', 'SP80', 'TZ10', 'TZ14', 'TZ8', 'UG17-3', 'UG19', 'UG28N', 'UG40-3', 'UG5N', 'UG7', 'UM118', 'UM37', 'UM526', 'ZK131', 'ZK186', 'ZK84', 'ZL130', 'ZO12', 'ZO65', 'ZS11', 'ZS37', 'ZS5', 'ZS56', 'EA119', 'EA3', 'EA49', 'EA71', 'EA87', 'EB132', 'EB148', 'EB18', 'EB237', 'EB25', 'EF120', 'EF2', 'EF39', 'EF65', 'EF78', 'EG40N', 'EG69N', 'EG73N', 'EM239', 'EM40', 'EM6', 'ER11', 'ER156', 'ER32', 'ER63', 'ER85', 'KM106', 'KM36', 'KM73', 'KM92', 'SB10', 'SB16', 'SB26', 'SB31', 'SB51', 'SD145', 'SD45', 'SD67', 'SD82', 'SD98', 'SE16', 'SE55', 'SE63', 'SF110', 'SF332', 'SF428', 'SF447', 'SF7', 'UK10', 'UK120', 'UK2', 'UK57', 'UK73', 'ZI10', 'ZI103', 'ZI104', 'ZI114N', 'ZI117', 'ZI118N', 'ZI126', 'ZI129', 'ZI134N', 'ZI136', 'ZI138', 'ZI152', 'ZI157', 'ZI161', 'ZI164', 'ZI165', 'ZI167', 'ZI170', 'ZI172', 'ZI173', 'ZI176', 'ZI177', 'ZI178', 'ZI179', 'ZI181', 'ZI182', 'ZI184', 'ZI185', 'ZI188', 'ZI190', 'ZI191', 'ZI193', 'ZI194', 'ZI196', 'ZI197N', 'ZI198', 'ZI199', 'ZI200', 'ZI202', 'ZI206', 'ZI207', 'ZI210', 'ZI211', 'ZI212', 'ZI213', 'ZI214', 'ZI216N', 'ZI218', 'ZI219', 'ZI220', 'ZI221', 'ZI225', 'ZI226', 'ZI227', 'ZI228', 'ZI230', 'ZI231', 'ZI232', 'ZI233', 'ZI235', 'ZI237', 'ZI239', 'ZI240', 'ZI241', 'ZI250', 'ZI251N', 'ZI252', 'ZI253', 'ZI254N', 'ZI255', 'ZI26', 'ZI261', 'ZI263', 'ZI264', 'ZI265', 'ZI267', 'ZI268', 'ZI269', 'ZI27', 'ZI271', 'ZI273N', 'ZI276', 'ZI279', 'ZI28', 'ZI281', 'ZI284', 'ZI286', 'ZI291', 'ZI292', 'ZI293', 'ZI295', 'ZI296', 'ZI303', 'ZI311N', 'ZI313', 'ZI314', 'ZI316', 'ZI317', 'ZI319', 'ZI31N', 'ZI320', 'ZI321', 'ZI324', 'ZI329', 'ZI33', 'ZI332', 'ZI333', 'ZI335', 'ZI336', 'ZI339', 'ZI341', 'ZI342', 'ZI344', 'ZI348', 'ZI351', 'ZI352', 'ZI353', 'ZI357N', 'ZI358', 'ZI359', 'ZI362', 'ZI364', 'ZI365', 'ZI368', 'ZI370', 'ZI373', 'ZI374', 'ZI377', 'ZI378', 'ZI379', 'ZI380', 'ZI381', 'ZI382', 'ZI384', 'ZI386', 'ZI388', 'ZI392', 'ZI394N', 'ZI395', 'ZI396', 'ZI397N', 'ZI398', 'ZI400', 'ZI402', 'ZI405', 'ZI413', 'ZI418N', 'ZI420', 'ZI421', 'ZI429', 'ZI431', 'ZI433', 'ZI437', 'ZI443', 'ZI444', 'ZI445', 'ZI446', 'ZI447', 'ZI448', 'ZI453', 'ZI455N', 'ZI456', 'ZI457', 'ZI458', 'ZI460', 'ZI466', 'ZI467', 'ZI468', 'ZI471', 'ZI472', 'ZI476', 'ZI477', 'ZI486', 'ZI488', 'ZI490', 'ZI491', 'ZI504', 'ZI505', 'ZI508', 'ZI50N', 'ZI514N', 'ZI517', 'ZI523', 'ZI524', 'ZI527', 'ZI530', 'ZI56', 'ZI59', 'ZI61', 'ZI68', 'ZI76', 'ZI81', 'ZI85', 'ZI86', 'ZI90', 'ZI91', 'ZI99', 'RAL-100', 'RAL-101', 'RAL-105', 'RAL-109', 'RAL-129', 'RAL-136', 'RAL-138', 'RAL-142', 'RAL-149', 'RAL-153', 'RAL-158', 'RAL-161', 'RAL-176', 'RAL-177', 'RAL-181', 'RAL-189', 'RAL-195', 'RAL-208', 'RAL-21', 'RAL-217', 'RAL-223', 'RAL-227', 'RAL-228', 'RAL-229', 'RAL-233', 'RAL-235', 'RAL-237', 'RAL-239', 'RAL-256', 'RAL-26', 'RAL-28', 'RAL-280', 'RAL-287', 'RAL-301', 'RAL-303', 'RAL-304', 'RAL-306', 'RAL-307', 'RAL-309', 'RAL-31', 'RAL-310', 'RAL-313', 'RAL-315', 'RAL-317', 'RAL-318', 'RAL-319', 'RAL-32', 'RAL-320', 'RAL-321', 'RAL-324', 'RAL-325', 'RAL-332', 'RAL-335', 'RAL-336', 'RAL-338', 'RAL-340', 'RAL-348', 'RAL-350', 'RAL-352', 'RAL-354', 'RAL-355', 'RAL-356', 'RAL-357', 'RAL-358', 'RAL-359', 'RAL-360', 'RAL-361', 'RAL-362', 'RAL-365', 'RAL-367', 'RAL-370', 'RAL-371', 'RAL-373', 'RAL-374', 'RAL-375', 'RAL-377', 'RAL-379', 'RAL-38', 'RAL-380', 'RAL-381', 'RAL-382', 'RAL-383', 'RAL-385', 'RAL-386', 'RAL-390', 'RAL-391', 'RAL-392', 'RAL-395', 'RAL-397', 'RAL-399', 'RAL-40', 'RAL-405', 'RAL-406', 'RAL-409', 'RAL-41', 'RAL-42', 'RAL-426', 'RAL-427', 'RAL-437', 'RAL-439', 'RAL-440', 'RAL-441', 'RAL-443', 'RAL-45', 'RAL-461', 'RAL-48', 'RAL-486', 'RAL-49', 'RAL-491', 'RAL-492', 'RAL-502', 'RAL-505', 'RAL-508', 'RAL-509', 'RAL-513', 'RAL-517', 'RAL-528', 'RAL-530', 'RAL-531', 'RAL-535', 'RAL-551', 'RAL-555', 'RAL-559', 'RAL-563', 'RAL-566', 'RAL-57', 'RAL-584', 'RAL-589', 'RAL-59', 'RAL-595', 'RAL-596', 'RAL-627', 'RAL-630', 'RAL-634', 'RAL-639', 'RAL-642', 'RAL-646', 'RAL-69', 'RAL-703', 'RAL-705', 'RAL-707', 'RAL-712', 'RAL-714', 'RAL-716', 'RAL-721', 'RAL-727', 'RAL-73', 'RAL-730', 'RAL-732', 'RAL-737', 'RAL-738', 'RAL-748', 'RAL-75', 'RAL-757', 'RAL-761', 'RAL-765', 'RAL-774', 'RAL-776', 'RAL-783', 'RAL-786', 'RAL-787', 'RAL-790', 'RAL-796', 'RAL-799', 'RAL-801', 'RAL-802', 'RAL-804', 'RAL-805', 'RAL-808', 'RAL-810', 'RAL-812', 'RAL-818', 'RAL-819', 'RAL-820', 'RAL-821', 'RAL-822', 'RAL-83', 'RAL-832', 'RAL-837', 'RAL-843', 'RAL-849', 'RAL-85', 'RAL-850', 'RAL-852', 'RAL-853', 'RAL-855', 'RAL-857', 'RAL-859', 'RAL-861', 'RAL-879', 'RAL-88', 'RAL-882', 'RAL-884', 'RAL-887', 'RAL-890', 'RAL-892', 'RAL-894', 'RAL-897', 'RAL-900', 'RAL-907', 'RAL-908', 'RAL-91', 'RAL-911', 'RAL-913', 'RAL-93');

#Full list of genomes
#'CK1', 'CK2', 'CO1', 'CO10b-3', 'CO10N', 'CO13N', 'CO14', 'CO15N', 'CO16', 'CO16-3', 'CO2', 'CO4N', 'CO8b-3', 'CO8N', 'CO9N', 'ED10N', 'ED19-1-3', 'ED2', 'ED3', 'ED55-2', 'ED56-2', 'ED5N', 'ED6N', 'EZ2', 'EZ25', 'EZ5N', 'EZ63-1-3', 'EZ9N', 'FR14', 'FR151', 'FR180', 'FR207', 'FR217', 'FR229', 'FR310', 'FR361', 'FR70', 'GA125', 'GA129', 'GA130', 'GA132', 'GA141', 'GA145', 'GA160', 'GA185', 'GA187', 'GA191', 'GU10', 'GU11-3', 'GU2', 'GU3-3', 'GU6', 'GU7', 'GU9', 'KN133N', 'KN20N', 'KN34', 'KN35', 'KN6', 'KN73-1-3', 'KO10-1-3', 'KO2-1-3', 'KO6-1-3', 'KR39', 'KR42', 'KR4N', 'KR54-1-3', 'KR68-1-3', 'KR7', 'KT1', 'KT6', 'MW11-1', 'MW27-3', 'MW28-1', 'MW28-2-3', 'MW38-1', 'MW38-2', 'MW46-1', 'MW56-2-3', 'MW6-1', 'MW6-2', 'MW6-3', 'MW63-1', 'MW63-2-3', 'MW9-1', 'MW9-2', 'NG10N', 'NG1N', 'NG3N', 'NG6N', 'NG7', 'NG9', 'RC1', 'RC5', 'RG10', 'RG11N', 'RG13N', 'RG15', 'RG18N', 'RG19', 'RG2', 'RG21N', 'RG22', 'RG24', 'RG25', 'RG28', 'RG3', 'RG32N', 'RG33', 'RG34', 'RG35', 'RG36', 'RG37N', 'RG38N', 'RG39', 'RG4N', 'RG5', 'RG6N', 'RG7', 'RG8', 'RG9', 'SP173', 'SP188', 'SP221', 'SP235', 'SP241', 'SP254', 'SP80', 'TZ10', 'TZ14', 'TZ8', 'UG17-3', 'UG19', 'UG28N', 'UG40-3', 'UG5N', 'UG7', 'UM118', 'UM37', 'UM526', 'ZK131', 'ZK186', 'ZK84', 'ZL130', 'ZO12', 'ZO65', 'ZS11', 'ZS37', 'ZS5', 'ZS56', 'EA119', 'EA3', 'EA49', 'EA71', 'EA87', 'EB132', 'EB148', 'EB18', 'EB237', 'EB25', 'EF120', 'EF2', 'EF39', 'EF65', 'EF78', 'EG40N', 'EG69N', 'EG73N', 'EM239', 'EM40', 'EM6', 'ER11', 'ER156', 'ER32', 'ER63', 'ER85', 'KM106', 'KM36', 'KM73', 'KM92', 'SB10', 'SB16', 'SB26', 'SB31', 'SB51', 'SD145', 'SD45', 'SD67', 'SD82', 'SD98', 'SE16', 'SE55', 'SE63', 'SF110', 'SF332', 'SF428', 'SF447', 'SF7', 'UK10', 'UK120', 'UK2', 'UK57', 'UK73', 'ZI10', 'ZI103', 'ZI104', 'ZI114N', 'ZI117', 'ZI118N', 'ZI126', 'ZI129', 'ZI134N', 'ZI136', 'ZI138', 'ZI152', 'ZI157', 'ZI161', 'ZI164', 'ZI165', 'ZI167', 'ZI170', 'ZI172', 'ZI173', 'ZI176', 'ZI177', 'ZI178', 'ZI179', 'ZI181', 'ZI182', 'ZI184', 'ZI185', 'ZI188', 'ZI190', 'ZI191', 'ZI193', 'ZI194', 'ZI196', 'ZI197N', 'ZI198', 'ZI199', 'ZI200', 'ZI202', 'ZI206', 'ZI207', 'ZI210', 'ZI211', 'ZI212', 'ZI213', 'ZI214', 'ZI216N', 'ZI218', 'ZI219', 'ZI220', 'ZI221', 'ZI225', 'ZI226', 'ZI227', 'ZI228', 'ZI230', 'ZI231', 'ZI232', 'ZI233', 'ZI235', 'ZI237', 'ZI239', 'ZI240', 'ZI241', 'ZI250', 'ZI251N', 'ZI252', 'ZI253', 'ZI254N', 'ZI255', 'ZI26', 'ZI261', 'ZI263', 'ZI264', 'ZI265', 'ZI267', 'ZI268', 'ZI269', 'ZI27', 'ZI271', 'ZI273N', 'ZI276', 'ZI279', 'ZI28', 'ZI281', 'ZI284', 'ZI286', 'ZI291', 'ZI292', 'ZI293', 'ZI295', 'ZI296', 'ZI303', 'ZI311N', 'ZI313', 'ZI314', 'ZI316', 'ZI317', 'ZI319', 'ZI31N', 'ZI320', 'ZI321', 'ZI324', 'ZI329', 'ZI33', 'ZI332', 'ZI333', 'ZI335', 'ZI336', 'ZI339', 'ZI341', 'ZI342', 'ZI344', 'ZI348', 'ZI351', 'ZI352', 'ZI353', 'ZI357N', 'ZI358', 'ZI359', 'ZI362', 'ZI364', 'ZI365', 'ZI368', 'ZI370', 'ZI373', 'ZI374', 'ZI377', 'ZI378', 'ZI379', 'ZI380', 'ZI381', 'ZI382', 'ZI384', 'ZI386', 'ZI388', 'ZI392', 'ZI394N', 'ZI395', 'ZI396', 'ZI397N', 'ZI398', 'ZI400', 'ZI402', 'ZI405', 'ZI413', 'ZI418N', 'ZI420', 'ZI421', 'ZI429', 'ZI431', 'ZI433', 'ZI437', 'ZI443', 'ZI444', 'ZI445', 'ZI446', 'ZI447', 'ZI448', 'ZI453', 'ZI455N', 'ZI456', 'ZI457', 'ZI458', 'ZI460', 'ZI466', 'ZI467', 'ZI468', 'ZI471', 'ZI472', 'ZI476', 'ZI477', 'ZI486', 'ZI488', 'ZI490', 'ZI491', 'ZI504', 'ZI505', 'ZI508', 'ZI50N', 'ZI514N', 'ZI517', 'ZI523', 'ZI524', 'ZI527', 'ZI530', 'ZI56', 'ZI59', 'ZI61', 'ZI68', 'ZI76', 'ZI81', 'ZI85', 'ZI86', 'ZI90', 'ZI91', 'ZI99', 'RAL-100', 'RAL-101', 'RAL-105', 'RAL-109', 'RAL-129', 'RAL-136', 'RAL-138', 'RAL-142', 'RAL-149', 'RAL-153', 'RAL-158', 'RAL-161', 'RAL-176', 'RAL-177', 'RAL-181', 'RAL-189', 'RAL-195', 'RAL-208', 'RAL-21', 'RAL-217', 'RAL-223', 'RAL-227', 'RAL-228', 'RAL-229', 'RAL-233', 'RAL-235', 'RAL-237', 'RAL-239', 'RAL-256', 'RAL-26', 'RAL-28', 'RAL-280', 'RAL-287', 'RAL-301', 'RAL-303', 'RAL-304', 'RAL-306', 'RAL-307', 'RAL-309', 'RAL-31', 'RAL-310', 'RAL-313', 'RAL-315', 'RAL-317', 'RAL-318', 'RAL-319', 'RAL-32', 'RAL-320', 'RAL-321', 'RAL-324', 'RAL-325', 'RAL-332', 'RAL-335', 'RAL-336', 'RAL-338', 'RAL-340', 'RAL-348', 'RAL-350', 'RAL-352', 'RAL-354', 'RAL-355', 'RAL-356', 'RAL-357', 'RAL-358', 'RAL-359', 'RAL-360', 'RAL-361', 'RAL-362', 'RAL-365', 'RAL-367', 'RAL-370', 'RAL-371', 'RAL-373', 'RAL-374', 'RAL-375', 'RAL-377', 'RAL-379', 'RAL-38', 'RAL-380', 'RAL-381', 'RAL-382', 'RAL-383', 'RAL-385', 'RAL-386', 'RAL-390', 'RAL-391', 'RAL-392', 'RAL-395', 'RAL-397', 'RAL-399', 'RAL-40', 'RAL-405', 'RAL-406', 'RAL-409', 'RAL-41', 'RAL-42', 'RAL-426', 'RAL-427', 'RAL-437', 'RAL-439', 'RAL-440', 'RAL-441', 'RAL-443', 'RAL-45', 'RAL-461', 'RAL-48', 'RAL-486', 'RAL-49', 'RAL-491', 'RAL-492', 'RAL-502', 'RAL-505', 'RAL-508', 'RAL-509', 'RAL-513', 'RAL-517', 'RAL-528', 'RAL-530', 'RAL-531', 'RAL-535', 'RAL-551', 'RAL-555', 'RAL-559', 'RAL-563', 'RAL-566', 'RAL-57', 'RAL-584', 'RAL-589', 'RAL-59', 'RAL-595', 'RAL-596', 'RAL-627', 'RAL-630', 'RAL-634', 'RAL-639', 'RAL-642', 'RAL-646', 'RAL-69', 'RAL-703', 'RAL-705', 'RAL-707', 'RAL-712', 'RAL-714', 'RAL-716', 'RAL-721', 'RAL-727', 'RAL-73', 'RAL-730', 'RAL-732', 'RAL-737', 'RAL-738', 'RAL-748', 'RAL-75', 'RAL-757', 'RAL-761', 'RAL-765', 'RAL-774', 'RAL-776', 'RAL-783', 'RAL-786', 'RAL-787', 'RAL-790', 'RAL-796', 'RAL-799', 'RAL-801', 'RAL-802', 'RAL-804', 'RAL-805', 'RAL-808', 'RAL-810', 'RAL-812', 'RAL-818', 'RAL-819', 'RAL-820', 'RAL-821', 'RAL-822', 'RAL-83', 'RAL-832', 'RAL-837', 'RAL-843', 'RAL-849', 'RAL-85', 'RAL-850', 'RAL-852', 'RAL-853', 'RAL-855', 'RAL-857', 'RAL-859', 'RAL-861', 'RAL-879', 'RAL-88', 'RAL-882', 'RAL-884', 'RAL-887', 'RAL-890', 'RAL-892', 'RAL-894', 'RAL-897', 'RAL-900', 'RAL-907', 'RAL-908', 'RAL-91', 'RAL-911', 'RAL-913', 'RAL-93'

#####





#declarations
my $file = '';
my $unmask = '';
my $noadfilt = '';
my $OutputFile = '';
my $OutputName = '';
my $RangeStart = 0;
my $RangeStop = 0;
my @LineSeq = ();
my @InputSeq = ();
my @OutputSeq = ();
my $i = 0;
my $KiloRange = 0;
my $WinStart = -1;
my $f = 0;

#If single output file, have this output file open
if ($SingleOutputFile eq 'Yes'){
 $OutputFile = $LocusName . '_' . $chr;
    if ($RevComp eq 'Yes'){
      $OutputFile = $OutputFile . '_' . $PosStop . '_' . $PosStart . '.fas';
    }
    else{
      $OutputFile = $OutputFile . '_' . $PosStart . '_' . $PosStop . '.fas';
    }
  open M, ">$OutputFile";
}

#Cycle through each genome, opening file, then scanning through 1kb blocks to find the region of interest
for ($f = 0; $f < @InLines; $f++){
  $file = $InLines[$f] . "_" . $chr . "\.seq1k";
  unless (-e $file) {
    print "Can't open $file (maybe this genome doesn't have data for this chromosome).\n";
    next;
  }
  open I, "<$file";
  @InputSeq = ();
  @OutputSeq = ();
  $KiloRange = 0;
  $WinStart = -1;

  while (<I>){
    chomp;
    if ($PosStart <= $KiloRange + 1000){
      if ($WinStart < 0){
	$WinStart = $KiloRange;
      }
      @LineSeq = split(//, $_);
      @InputSeq = (@InputSeq, @LineSeq);
      last if ($PosStop <= $KiloRange + 1000);
    }
    $KiloRange += 1000;
  }
  close I;

  $RangeStart = $PosStart - $WinStart;
  $RangeStop = $PosStop - $WinStart;

  if ($RevComp eq 'Yes'){
    for ($i = ($RangeStop - 1); $i >= ($RangeStart - 1); $i--){
      if ($InputSeq[$i] eq 'A'){
	push @OutputSeq, 'T';
      }
      elsif ($InputSeq[$i] eq 'C'){
	push @OutputSeq, 'G';
      }
      elsif ($InputSeq[$i] eq 'G'){
	push @OutputSeq, 'C';
      }
      elsif ($InputSeq[$i] eq 'T'){
	push @OutputSeq, 'A';
      }
      else{
	push @OutputSeq, 'N';
      }
    }
  }
  else{
    for ($i = ($RangeStart - 1); $i < $RangeStop; $i++){
      push @OutputSeq, $InputSeq[$i];
    }
  }

#output
  if ($SingleOutputFile eq 'Yes'){
    $OutputName = '>' . $InLines[$f];
    print M "$OutputName\n";
    for ($i = 0; $i < @OutputSeq; $i++){
      print M $OutputSeq[$i];
      #uncomment the lines below to add line breaks every 1000 bp
      #    if ($i % 1000 == 999){
      #      print O "\n";
      #    }
    }
    print M "\n";
  }

  else{
    $OutputFile = $LocusName . '_' . $InLines[$f] . '_' . $chr;
    if ($RevComp eq 'Yes'){
      $OutputFile = $OutputFile . '_' . $PosStop . '_' . $PosStart . '.fas';
    }
    else{
      $OutputFile = $OutputFile . '_' . $PosStart . '_' . $PosStop . '.fas';
    }
    $OutputName = '>' . $InLines[$f];
    open O, ">$OutputFile";
    print O "$OutputName\n";
    for ($i = 0; $i < @OutputSeq; $i++){
      print O $OutputSeq[$i];
      #uncomment the lines below to add line breaks every 1000 bp
      #    if ($i % 1000 == 999){
      #      print O "\n";
      #    }
    }
  }
}
