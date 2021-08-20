function D1Data = initSimD1Msg()
    D1Data.Pre = '11100010010';
    D1Data.Rev = '0000';
    D1Data.FraID = dec2bin(1,3);%'001';
    D1Data.SOW = dec2bin(259200,20);%'00111111010010000000';
    D1Data.SatH1 = '0';
    D1Data.AODC = '00100';
    D1Data.URAI = '0000';
    D1Data.WN = dec2bin(388,13);%'0000000000000';
    D1Data.Toc = dec2bin(round(278344/(2^3)),17);%'01000011111101001';
    D1Data.TGD1 = dec2twosComp(6.2/0.1,10);%'0000111110';
    D1Data.TGD2 = dec2twosComp(-0.3/0.1,10);%'1111111101';
    D1Data.alpha0 = dec2twosComp(round(6.52e-9/(2^-30)),8);%'00000111'
    D1Data.alpha1 = dec2twosComp(round(6.333e-7/(2^-27)),8);%'01010101'
    D1Data.alpha2 = dec2twosComp(round(-5.126e-6/(2^-24)),8);%'10101010'
    D1Data.alpha3 = dec2twosComp(round(-4.47e-6/(2^-24)),8);%'10110101'
    D1Data.beta0 = dec2twosComp(round(176128/(2^11)),8);%'01010110';%176128
    D1Data.beta1 = dec2twosComp(round(-1409024/(2^14)),8);%'10101010'
    D1Data.beta2 = dec2twosComp(round(-2818048/(2^16)),8);%'11010101'
    D1Data.beta3 = dec2twosComp(round(5898240/(2^16)),8);%'01011010';%5898240
    D1Data.a2 = dec2twosComp(round(-9.1886e-18/(2^-66)),11);%'01010101011'
    D1Data.a0 = dec2twosComp(round(9.1108e-4/(2^-33)),24);%'011101110110101010101101';%9.1108e-4
    D1Data.a1 = dec2twosComp(round(-4.9961e-10/(2^-50)),22);%'1101110110101010101101';%-4.9961e-10
    D1Data.AODE = dec2bin(21,5);
    
    