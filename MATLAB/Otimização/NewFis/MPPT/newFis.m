function fis = newFis(x)

%Universo de discurso fixos em -1 e 1
ud_E = [-1 1]; ud_dE = [-1 1];
ud_kp = [-1 1]; ud_ki = [-1 1];

%Método de Defuzzificação => Centroide ou MOM - x(1)

fis = mamfis("Name", "FLS_FGS_PI", "DefuzzificationMethod", "mom");


% Parâmetros entrada E - x(6) ... x(13) - [-1 .. 1]
fis = addInput(fis, ud_E, "Name", "E");
fis = addMF(fis,"E","trimf", [-1 -1 -x(5)],"Name","NB");
fis = addMF(fis,"E","trimf", [-x(6) -x(7) -x(8)],"Name","NM");
fis = addMF(fis,"E","trimf", [-x(9) -x(10) -x(11)],"Name","NS");
fis = addMF(fis,"E","trimf", [-x(12) 0 x(12)],"Name","Z");
fis = addMF(fis,"E","trimf", [x(11) x(10) x(9)],"Name","PS");
fis = addMF(fis,"E","trimf", [x(8) x(7) x(6)],"Name","PM");
fis = addMF(fis,"E","trimf", [x(5) 1 1],"Name","PB");

% Parâmetros entrada dE - x(14) ... x(21) - [-1 .. 1]
fis = addInput(fis, ud_dE, "Name", "dE");
fis = addMF(fis,"dE","trimf", [-1 -1 -x(13)],"Name","NB");
fis = addMF(fis,"dE","trimf", [-x(14) -x(15) -x(16)],"Name","NM");
fis = addMF(fis,"dE","trimf", [-x(17) -x(18) -x(19)],"Name","NS");
fis = addMF(fis,"dE","trimf", [-x(20) 0 x(20)],"Name","Z");
fis = addMF(fis,"dE","trimf", [x(19) x(18) x(17)],"Name","PS");
fis = addMF(fis,"dE","trimf", [x(16) x(15) x(14)],"Name","PM");
fis = addMF(fis,"dE","trimf", [x(13) 1 1],"Name","PB");

% Parâmetros entrada kp - x(22) ... x(29) - [-1 .. 1]
fis = addOutput(fis, ud_dE, "Name", "kp");
fis = addMF(fis,"kp","trimf", [-1 -1 -x(21)],"Name","NB");
fis = addMF(fis,"kp","trimf", [-x(22) -x(23) -x(24)],"Name","NM");
fis = addMF(fis,"kp","trimf", [-x(25) -x(26) -x(27)],"Name","NS");
fis = addMF(fis,"kp","trimf", [-x(28) 0 x(28)],"Name","Z");
fis = addMF(fis,"kp","trimf", [x(27) x(26) x(25)],"Name","PS");
fis = addMF(fis,"kp","trimf", [x(24) x(23) x(22)],"Name","PM");
fis = addMF(fis,"kp","trimf", [x(21) 1 1],"Name","PB");

% Parâmetros entrada ki - x(30) ... x(37) - [-1 .. 1]
fis = addOutput(fis, ud_dE, "Name", "ki");
fis = addMF(fis,"ki","trimf", [-1 -1 -x(29)],"Name","NB");
fis = addMF(fis,"ki","trimf", [-x(30) -x(31) -x(32)],"Name","NM");
fis = addMF(fis,"ki","trimf", [-x(33) -x(34) -x(35)],"Name","NS");
fis = addMF(fis,"ki","trimf", [-x(36) 0 x(36)],"Name","Z");
fis = addMF(fis,"ki","trimf", [x(35) x(34) x(33)],"Name","PS");
fis = addMF(fis,"ki","trimf", [x(32) x(31) x(30)],"Name","PM");
fis = addMF(fis,"ki","trimf", [x(29) 1 1],"Name","PB");

x(37:134) = int16(x(37:134));

ruleList = [1 1 x(37) x(38) x(135) 1;%1
                 1 2 x(39) x(40) x(136) 1;%2
                 1 3 x(41) x(42) x(137) 1;%3
                 1 4 x(43) x(44) x(138) 1;%4
                 1 5 x(45) x(46) x(139) 1;%5
                 1 6 x(47) x(48) x(140) 1;%6
                 1 7 x(49) x(50) x(141) 1;%7
                 2 1 x(51) x(52) x(142) 1;%8
                 2 2 x(53) x(54) x(143) 1;%9
                 2 3 x(55) x(56) x(144) 1;%10
                 2 4 x(57) x(58) x(145) 1;%11
                 2 5 x(59) x(60) x(146) 1;%12
                 2 6 x(61) x(62) x(147) 1;%13
                 2 7 x(63) x(64) x(148) 1;%14
                 3 1 x(65) x(66) x(149) 1;%15
                 3 2 x(67) x(68) x(150) 1;%16
                 3 3 x(69) x(70) x(151) 1;%17
                 3 4 x(71) x(72) x(152) 1;%18
                 3 5 x(73) x(74) x(153) 1;%19
                 3 6 x(75) x(76) x(154) 1;%20
                 3 7 x(77) x(78) x(155) 1;%21
                 4 1 x(79) x(80) x(156) 1;%22
                 4 2 x(81) x(82) x(157) 1;%23
                 4 3 x(83) x(84) x(158) 1;%24
                 4 4 x(85) x(86) x(159) 1;%25
                 4 5 x(87) x(88) x(160) 1;%26
                 4 6 x(89) x(90) x(161) 1;%27
                 4 7 x(91) x(92) x(162) 1;%28
                 5 1 x(93) x(94) x(163) 1;%29
                 5 2 x(95) x(96) x(164) 1;%30
                 5 3 x(97) x(98) x(165) 1;%31
                 5 4 x(99) x(100) x(166) 1;%32
                 5 5 x(101) x(102) x(167) 1;%33
                 5 6 x(103) x(104) x(168) 1;%34
                 5 7 x(105) x(106) x(169) 1;%35
                 6 1 x(107) x(108) x(170) 1;%36
                 6 2 x(109) x(110) x(171) 1;%37
                 6 3 x(111) x(112) x(172) 1;%38
                 6 4 x(113) x(114) x(173) 1;%39
                 6 5 x(115) x(116) x(174) 1;%40
                 6 6 x(117) x(118) x(175) 1;%41
                 6 7 x(119) x(120) x(176) 1;%42
                 7 1 x(121) x(122) x(177) 1;%43
                 7 2 x(123) x(124) x(178) 1;%44
                 7 3 x(125) x(126) x(179) 1;%45
                 7 4 x(127) x(128) x(180) 1;%46
                 7 5 x(129) x(130) x(181) 1;%47
                 7 6 x(131) x(132) x(182) 1;%48
                 7 7 x(133) x(134) x(183) 1;];%49
fis = addRule(fis, ruleList);

end