function fis = newFis2(x)

%Universo de discurso fixos em -1 e 1
ud_E = [-1 1]; ud_dE = [-1 1];
ud_kp = [-1 1]; ud_ki = [-1 1];

%Método de Defuzzificação => Centroide
fis = mamfis("Name", "FLS_FGS_PI", "DefuzzificationMethod", "centroid");

% Parâmetros entrada E - x(5) ... x(8) - [0 .. 1]
fis = addInput(fis, ud_E, "Name", "E");
fis = addMF(fis,"E","gaussmf", [x(5) -1], "Name", "NG");
fis = addMF(fis,"E","gaussmf", [x(6) -x(7)], "Name", "NP");
fis = addMF(fis,"E","gaussmf", [x(8) 0], "Name", "Z");
fis = addMF(fis, "E", "gaussmf", [x(6) x(7)], "Name", "PP");
fis = addMF(fis, "E", "gaussmf", [x(5) 1], "Name", "PG");

% Parâmetros entrada dE - x(9) ... x(12) - [0 .. 1]
fis = addInput(fis, ud_dE, "Name", "dE");
fis = addMF(fis,"dE","gaussmf", [x(9) -1], "Name", "NG");
fis = addMF(fis,"dE","gaussmf", [x(10) -x(11)], "Name", "NP");
fis = addMF(fis,"dE","gaussmf", [x(12) 0], "Name", "Z");
fis = addMF(fis, "dE", "gaussmf", [x(10) x(11)], "Name", "PP");
fis = addMF(fis, "dE", "gaussmf", [x(9) 1], "Name", "PG");

% Parâmetros entrada kp - x(13) ... x(16) - [0 .. 1]
fis = addOutput(fis, ud_kp, "Name", "kp");
fis = addMF(fis,"kp","gaussmf", [x(13), -1],"Name","NG");
fis = addMF(fis,"kp","gaussmf", [x(14), -x(15)],"Name","NP");
fis = addMF(fis,"kp","gaussmf", [x(16), 0],"Name","Z");
fis = addMF(fis,"kp","gaussmf", [x(14), x(15)],"Name","PP");
fis = addMF(fis,"kp","gaussmf", [x(13), 1],"Name","PG");

% Parâmetros entrada ki - x(17) ... x(20) - [0 .. 1]
fis = addOutput(fis, ud_ki, "Name", "ki");
fis = addMF(fis,"ki","gaussmf", [x(17), -1],"Name","NG");
fis = addMF(fis,"ki","gaussmf", [x(18), -x(19)],"Name","NP");
fis = addMF(fis,"ki","gaussmf", [x(20), 0],"Name","Z");
fis = addMF(fis,"ki","gaussmf", [x(18), x(19)],"Name","PP");
fis = addMF(fis,"ki","gaussmf", [x(17), 1],"Name","PG");

%Regras x(29) ... x(78) - [-5, -4, ..., 4, 5] - inteiro
% Pesos das Regras x(79) ... x(103) - [0 ... 1]

x(21:70) = int32(x(21:70));

ruleList = [1 1 x(21) x(22) x(71) 1;%1
                 1 2 x(23) x(24) x(72) 1;%2
                 1 3 x(25) x(26) x(73) 1;%3
                 1 4 x(27) x(28) x(74) 1;%4
                 1 5 x(29) x(30) x(75) 1;%5
                 2 1 x(31) x(32) x(76) 1;%6
                 2 2 x(33) x(34) x(77) 1;%7
                 2 3 x(35) x(36) x(78) 1;%8
                 2 4 x(37) x(38) x(79) 1;%9
                 2 5 x(39) x(40) x(80) 1;%10
                 3 1 x(41) x(42) x(81) 1;%11
                 3 2 x(43) x(44) x(82) 1;%12
                 3 3 x(45) x(46) x(83) 1;%13
                 3 4 x(47) x(48) x(84) 1;%14
                 3 5 x(49) x(50) x(85) 1;%15
                 4 1 x(51) x(52) x(86) 1;%16
                 4 2 x(53) x(54) x(87) 1;%17
                 4 3 x(55) x(56) x(88) 1;%18
                 4 4 x(57) x(58) x(89) 1;%19
                 4 5 x(59) x(60) x(90) 1;%20
                 5 1 x(61) x(62) x(91) 1;%21
                 5 2 x(63) x(64) x(92) 1;%22
                 5 3 x(65) x(66) x(93) 1;%23
                 5 4 x(67) x(68) x(94) 1;%24
                 5 5 x(69) x(70) x(95) 1;];%25
fis = addRule(fis, ruleList);

end