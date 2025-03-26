/*
Autores: Matheus Tauffer de Paula e Mario Henrique Bigai
*/

#include "Peripheral_Setup.h"
#include "math.h"
#include "fuzzy_init.h"

#define CLOSEDLOOP                                  // OPENLOOP / CLOSEDLOOP. OBS: comentar para D fixo
#define FILTER_FREQ_1                             // FILTER_FREQ_1 = 1kHz
//#define STEP_D
//#define STEP_Ref_Vi
//#define MPPT                                        // MPPT/STEP_Ref_Vi - ref
//#define Ref_Vi_CTE


// Parâmetros PI - Controle Vin (Buck)
#define kcont1 0.002283 //PI Vin        //0.003937 //PI Vout
#define kcont2 0.002274 //PI Vin        //0.003875 //PI Vout

//Parâmetros Filtro Corrente de Saída (Emu)
#define kfilt_io_1 0.22826091
#define kfilt_io_2 0.38586954
//Parâmetros Filtro Tensão de Saída (Emu)
#define kfilt_vo_1 0.98751209
#define kfilt_vo_2 0.0062439534

// Parˆametros PI - Controle io (Emulador)
#define kcont1_emu 0.0066 //0.0088
#define kcont2_emu 0.0054 //0.0062

// Constantes do filtro digital para leitura do potenciômetro
#ifdef FILTER_FREQ_1
    #define b0 0.23905722
    #define b1 0.23905722
    #define a1 -0.52188555
#endif

/**
 * main.c
*/

// Declaração de funções
void updatePWM(float d);
void updatePWM_emulador(float d2);
void PV_Parameters(void);
void Init_Variables(void);

// Declaração das variáveis globais
//Buck
uint32_t cont;
uint16_t adc, adc1, adcf, adcf1, ad4, ad1, ad2;
float duty, dutymax, dutymin, vo_0, vin_0, iin_0, vo_ref, vi_ref, ek, ek_1, uk, uk_1;
uint32_t contMPPT, contAcumula;
float Iant, Vant, cond, condInc, k_inc, inc, dP, dI, dV, vpv, ipv, vin1, vinf1, vinf, iin1, iinf1, iinf;
float kp, ki, A, B, Ts; //Variáveis p/ controle contínuo discretizado (Tustin)
uint32_t cont_fuzzy; //contador para mudar os ganhos kp e ki
float kp_t, ki_t, kE, kdE, kkp, kki; // Ganhos de fuzzificação e defuzzificação e ganhos variáveis
float dkp, dki, kp_erro_dE, kp_erro_dE1, ki_erro_dE, ki_erro_dE1, kp_E_dE, kp_E_dE1, kp_E1_dE, kp_E1_dE1, ki_E_dE, ki_E_dE1, ki_E1_dE, ki_E1_dE1; //retornos das tabelas de kp e ki e interpolados
int E, dE, E1, dE1; //- int para acessar tabela kp e ki
float erro, erro1, derro, erro_E, derro_dE, erro_E1, derro_dE1; //float para interpolar
float flag;

//Emulador
int x, x2;
Uint32 cont_varia, cont_ad;
int Ns, Ms, Mp;
double duty_emu, voltage_an0, voltage_an2, vo[2], vo_f[2], io[2], io_f[2], u[2], ypi[2], voref, ioref;
double K1, K2, K3, K4, K5, Psun, T, vcell, icell, kaux, Rs, Rp, Voc, Voccell, Isc, alpha, n, k, q, EG, Tr, Vt, Iph, Ir, Irr;

#ifdef OPENLOOP
// Declaração de funções de interrupção
__interrupt void isr_adc(void);
#endif

#ifdef CLOSEDLOOP
// Declaração de funções de interrupção
__interrupt void isr_adc(void);
#endif

int main(void){

    InitSysCtrl();                                  // Inicialização do sistema
    DINT;                                           // Desabilita as Interrupções globais da CPU
    InitPieCtrl();                                  // Inicializa o registrador de controle PIE em seu estado padrão
    IER = 0x0000;                                   // Desabilita as interrupções da CPU
    IFR = 0x0000;                                   // Limpa todas as flags de interrupção da CPU
    InitPieVectTable();                             // Inicialização da tabela de vetores do PIE

    EINT;                                           // Habilitação das Interrupções Globais INTM
    ERTM;                                           // Habilitação da Interrupção Global em tempo real DBGM

#ifdef OPENLOOP
    EALLOW;
    PieVectTable.ADCA1_INT = &isr_adc;              // Passa o endereço da função de interrupção para a tabela de interrupções
    EDIS;
#endif

#ifdef CLOSEDLOOP
    EALLOW;
    PieVectTable.ADCA1_INT = &isr_adc;              // Passa o endereço da função de interrupção para a tabela de interrupções
    EDIS;
#endif

    // Inicialização das variáveis (buck):
    duty = 0.6;                                   //
    dutymax = 0.9;
    dutymin = 0;
    //adc = 0;
    adc1 = 0;
    adcf1 = 0;
    contMPPT = 0;
    contAcumula = 0;
    vpv = 0; ipv = 0;
    vin1 = 0; vinf1 = 0; vinf = 0;
    iin1 = 0; iinf1 = 0; iinf = 0;
    Iant = 0;
    Vant = 0;
    cond = 0;
    condInc = 0;
    k_inc = 0.001;
    inc = 0.2;
    dP = 0;
    dI = 0;
    dV= 0;
    vi_ref = 20;
    kp = 0.0055;
    ki = 3.23;
    A = 0;
    B = 0;
    Ts = 1.0/150000.0;
    cont_fuzzy=0;
    dkp = 0;
    dki = 0;
    kp_erro_dE = 0;
    kp_erro_dE1 = 0;
    ki_erro_dE = 0;
    ki_erro_dE1 = 0;
    kp_E_dE = 0;
    kp_E_dE1 = 0;
    kp_E1_dE = 0;
    kp_E1_dE1 =0;
    ki_E_dE = 0;
    ki_E_dE1 = 0;
    ki_E1_dE = 0;
    ki_E1_dE1 = 0;
    kp_t = 0.0055;
    ki_t = 3.23;
    kE = 0.534949;
    kdE = 0.020407;
    kkp = 0.008984;
    kki = 4.933423;
    E=0;
    dE=0;
    E1=1;
    dE1=1;
    erro=0;
    erro1=0;
    derro=0;
    erro_E=0;
    derro_dE=0;
    erro_E1=0;
    derro_dE1=0;
    flag =0.0;

    // Inicialização das variáveis (Emulador)
    cont_ad = 0; //para não precisar fazer outra interrupção para o Emulador
    duty_emu = 0.4;
    ioref = 4;
    Psun = 1000;
    T = 25;

    PV_Parameters();
    Init_Variables();

    // Configuração de periféricos:
    Setup_GPIO();                                   // Chamada da função que configura as GPIOs
    Setup_ePWM();                                   // Chamada da função que configura os PWMs
    Setup_ADC();                                    // Chamada da função que configura o ADC
    Setup_DAC();                                    // Chamada da função que configura o DAC

    // Chamada a função que atualiza a razão cíclica e o tempo morto do PWM
    updatePWM(duty);
    updatePWM_emulador(0.4);

    //Lógica para variar Psun e T e MPPT LUT
    for(;;){
        if((cont_varia > 6250) && (x2 == 1)){
            if((Psun == 165) && (T == 12+273.) && (x == 1)){
                vi_ref = 25.7;
            }
            else if((Psun == 562) && (T == 27+273.) && (x == 2)){
                vi_ref = 26.2;
            }
            else if((Psun == 767) && (T == 40+273.) && (x == 3)){
                vi_ref = 25.4;
            }
            else if((Psun == 570) && (T == 40+273.) && (x == 4)){
                vi_ref = 25;
            }
            else if((Psun == 186) && (T == 30+273.) && (x == 0)){
                vi_ref = 24.3;
            }
            x2 = 0;
        }
        if(cont_varia > 12500){
            if(x == 0){
                Psun = 165.;
                T = 12.;
                PV_Parameters();
                x = 1;
            }
            else if(x == 1){
                Psun = 562.;
                T = 27.;
                PV_Parameters();
                x = 2;
            }
            else if(x == 2){
                Psun = 767.;
                T = 40.;
                PV_Parameters();
                x = 3;
            }
            else if(x == 3){
                Psun = 570.;
                T = 40.;
                PV_Parameters();
                x = 4;
            }
            else if(x == 4){
                Psun = 186.;
                T = 30.;
                PV_Parameters();
                x = 0;
            }
            cont_varia = 0;
            x2 = 1;
        }
        DELAY_US(20);
        cont_varia++;
    }

//    while(1){
//        //updatePWM(duty);
//    }

    return 0;
}

void updatePWM(float d){

    // Saturador de razão cíclica
    if(d > dutymax)
        d = dutymax;
    else if(d < dutymin)
        d = dutymin;

    // Configuração da razão cíclica
    EPwm1Regs.CMPA.bit.CMPA = (d)*(EPwm1Regs.TBPRD);         // Configura a razão cíclica do módulo PWM1
}

void updatePWM_emulador(float d2){
    if(d2 > 0.9995)
        d2 = 0.9995;
    else if(d2 < 0.0005)
        d2 = 0.0005;

    EPwm2Regs.CMPA.bit.CMPA = d2*2000;
    EPwm2Regs.CMPB.bit.CMPB = d2*2000;

    if((d2+0.015) > 1){
        EPwm2Regs.DBRED.bit.DBRED = (1-d2)*2000;
        EPwm2Regs.DBFED.bit.DBFED = (1-d2)*2000;
    }

    else if(d2 < 0.015){
        EPwm2Regs.DBRED.bit.DBRED = d2*2000;
        EPwm2Regs.DBFED.bit.DBFED = d2*2000;
    }

    else{
        EPwm2Regs.DBRED.bit.DBRED = 0.015*2000;
        EPwm2Regs.DBFED.bit.DBFED = 0.015*2000;
    }
}

void Init_Variables(void){
    int j;
    for(j=0;j<2;j++){
        vo[j] = 0;
        vo_f[j] = 0;
        io[j] = 0;
        io_f[j] = 0;
        u[j] = 0;
        ypi[j] = 0;
    }
    x = 0;
    x2 = 0;
    cont = 0;
}

void PV_Parameters(void){
    //PARAMETROS DO PAINEL: //DADOS DO CATALOGO:
    Ns = 45.; //número de células do painel

    Voc = 32.9; //tensao de circuito aberto por módulo
    Voccell = Voc/Ns; //tensao de circuito aberto por celula
    Isc = 8.21; //corrente de curto circuito por modulo
    Rs = 4.5e-3; //resistencia em serie
    Rp = 2.116; //resistencia em paralelo
    //Voc = 1.; //tensao de circuito aberto por celula
    //Isc = 1.; //corrente de curto circuito por celula
    alpha = 0.003117; //coeficiente de temperatura da corrente de curto circuito
    n = 1.4; //fator de qualidade da juncao
    k = 1.38e-23; //constante de Boltzmann [J/K]
    q = 1.60e-19; //carga elementar
    EG = 1.12; //energia da banda proibida
    Tr = 273. + 25.; //temperatura de referencia
    //CALCULOS:
    T = T + 273.; //temperatura ambiente convertida para [K]
    Vt = (n*k*T)/q; //tensao termica
    Iph = (Isc+(alpha*(T-Tr)))*Psun/1000; //fotocorrente
    Irr = (Isc-Voccell/Rp)/(exp(q*Voccell/n/k/Tr)-1); //corrente de saturacao reversa de referencia
    Ir = Irr*pow((T/Tr), 3)*exp(q*EG/n/k*(1/Tr-1/T)); //corrente de saturacao reversa
    K1 = Iph + Ir;
    K2 = 1./Rp;
    K3 = Ir;
    K4 = 1. + (Rs/Rp);
    K5 = (Ir*q*Rs)/(n*k*T);
}

#ifdef OPENLOOP
__interrupt void isr_adc(void){
    GpioDataRegs.GPADAT.bit.GPIO14 = 1;                      // Sinaliza o início da conversão A/D (pino 74)

    // Resultado da conversão A/D (4 aquisições sucessivas)
    adc = (AdcaResultRegs.ADCRESULT0 + AdcaResultRegs.ADCRESULT1 + AdcaResultRegs.ADCRESULT2)/3;    // Potenciômetro
    ad2 = (AdcaResultRegs.ADCRESULT3+ AdcaResultRegs.ADCRESULT4 + AdcaResultRegs.ADCRESULT5)/3;    // Iin
    ad1 = (AdcaResultRegs.ADCRESULT6 + AdcaResultRegs.ADCRESULT7 + AdcaResultRegs.ADCRESULT8)/3;  // Vin
    ad4 = (AdcaResultRegs.ADCRESULT9 + AdcaResultRegs.ADCRESULT10 + AdcaResultRegs.ADCRESULT11)/3;// Vout

    vo_0 = (13.82*((float)ad4/4095) + 0.051);
    vin_0 = (64.09*((float)ad1/4095) + 0.342); //(61.8*((float)ad1/4095)); //Curva Inicial
    iin_0 = (19.568*((float)ad2/4095) + 0.0851);//(19.13*((float)ad2/4095)); //Curva Inicial

    // Implementação de filtro digital para leitura do potênciometro
    adcf = (b0*adc)+(b1*adc1)-(a1*adcf1);                    // Eq. a diferenças para o filtro do potênciometro
    adc1 = adc;
    adcf1 = adcf;

    DacaRegs.DACVALS.bit.DACVALS = adcf/3;                   // Conversão p/ que 1V no DAC corresponda a D = 1

    duty = ((float)adcf)/4095;                               // Conversão da leitura do A/D para razão cíclica

    #ifdef STEP_D                                            // Realização de degraus de razão cíclica
        cont = cont + 1;
        if(cont <= 75000){
            duty = 0.24;
        }else{
            duty = 0.4;
        }
        if(cont == 150000){
            cont = 0;
        }
        DacaRegs.DACVALS.bit.DACVALS = (uint16_t)(4095*duty);
    #endif

    if(duty > dutymax){
        duty = dutymax;
    }else if(duty < dutymin){
        duty = dutymin;
    }

    updatePWM(duty);                                         // Chamada a função que atualiza a razão cíclica

    AdcaRegs.ADCINTFLGCLR.bit.ADCINT1 = 1;                   // Limpa a flag da interrupção INT1
    PieCtrlRegs.PIEACK.all = PIEACK_GROUP1;

    GpioDataRegs.GPADAT.bit.GPIO14 = 0;                      // Sinaliza o término da conversão A/D
}
#endif

#ifdef CLOSEDLOOP
__interrupt void isr_adc(void){
    GpioDataRegs.GPADAT.bit.GPIO14 = 1;                      // Sinaliza o início da conversão A/D

    cont_ad = cont_ad+1;

    // Resultado da conversão A/D (3 aquisições sucessivas para cada canal)

    // Lendo sensores do Buck
    adc = (AdcaResultRegs.ADCRESULT12 + AdcaResultRegs.ADCRESULT13)/2;    // Potenciômetro
    ad2 = (AdcaResultRegs.ADCRESULT3+ AdcaResultRegs.ADCRESULT4 + AdcaResultRegs.ADCRESULT5)/3;    // Iin
    ad1 = (AdcaResultRegs.ADCRESULT6 + AdcaResultRegs.ADCRESULT7 + AdcaResultRegs.ADCRESULT8)/3;  // Vin
    ad4 = (AdcaResultRegs.ADCRESULT9 + AdcaResultRegs.ADCRESULT10 + AdcaResultRegs.ADCRESULT11)/3;// Vout

    vo_0 = (13.82*((float)ad4/4095) + 0.051);
    vin_0 = (64.09*((float)ad1/4095) + 0.342); //(61.8*((float)ad1/4095)); //Curva Inicial
    iin_0 = (19.568*((float)ad2/4095) + 0.0851);//(19.13*((float)ad2/4095)); //Curva Inicial

    // Implementação de filtro digital para leitura do potênciometro
    vinf = (b0*vin_0)+(b1*vin1)-(a1*vinf1);                    // Eq. a diferenças para o filtro do potênciometro
    vin1 = vin_0;
    vinf1 = vinf;

    iinf = (b0*iin_0)+(b1*iin1)-(a1*iinf1);                    // Eq. a diferenças para o filtro do potênciometro
    iin1 = iin_0;
    iinf1 = iinf;

    if(cont_ad == 3){
        // Lendo sensores do Emulador
        voltage_an0 = (((double)AdcaResultRegs.ADCRESULT0 + (double)AdcaResultRegs.ADCRESULT1))/8190;
        voltage_an2 = (((double)AdcaResultRegs.ADCRESULT14 + (double)AdcaResultRegs.ADCRESULT15))/8190;

        vo[0] = 48.88*voltage_an0;
        vo_f[0] = kfilt_vo_1*vo_f[1] + kfilt_vo_2*(vo[0]+vo[1]);
        vo[1] = vo[0];
        vo_f[1] = vo_f[0];

        io[0] = 10.84*voltage_an2 - 0.085;//10.54*voltage_an2;//(curva inicial)
        io_f[0] = kfilt_io_1*io_f[1] + kfilt_io_2*(io[0]+io[1]);
        io[1] = io[0];
        io_f[1] = io_f[0];

        vcell = vo_f[0]/(Ns);
        kaux = exp(vcell/Vt);
        icell = (K1-K2*vcell-K3*kaux)/(K4+K5*kaux);
        ioref = icell;
        if(io_f[0] > 15 || vo_f[0] > 40){
            ioref = 0;
        }
        //Lógica de Controle do PI Emulador
        u[0] = ioref - io_f[0];
        ypi[0] = ypi[1] + kcont1*u[0] - kcont2*u[1];

        if(ypi[0] > 0.5)
            ypi[0] = 0.5;
        else if(ypi[0] < 0)
            ypi[0] = 0;

        u[1] = u[0];
        ypi[1] = ypi[0];
        duty_emu = ypi[0];

        updatePWM_emulador(duty_emu);
        cont_ad = 0;
    }

    // Algoritmo de MPPT - CONDINC - seta valores de vref (PI Buck)
    #ifdef MPPT
        contMPPT = contMPPT + 1;
        // A cada 10.000 iterações (approx 66 ms) executa o MPPT
        if(contMPPT == 150000){
            vpv = vinf; //Ideia: Utilizar vo_f[1] -
            ipv = iinf; //Ideia: Utilizar io_f[1] -
                        // vinf e iinf - amostrado em 150khz, filtro antialising + filtro digital (1khz - mesmo do potenciometro)
                        // vo_f[1] e io_f[1] - amostrado em 50kHz, filtro antialising + filtro digital (??khz)

            dI = ipv-Iant;
            dV = vpv-Vant;

            cond = ipv/vpv;
            condInc = dI/dV;
            //condInc = -0.125; //- CondIncremental cte para Fonte de tensão com resistor em série (PV Linearizado)

            if(cond+condInc > 0){
                //teste: vi_ref = {20, 21, 22, 23, 24} e v_fonte = 44V
                vi_ref = vi_ref+inc;//vi_ref = 21;
            }
            else if(cond+condInc < 0){
                //teste: vi_ref = {20, 21, 22, 23, 24} e v_fonte = 44V
                vi_ref = vi_ref-inc;//vi_ref = 21;
            }

            if(vi_ref>30){
                vi_ref=30;
            }
            if(vi_ref<20){
                vi_ref=20;
            }

            Vant = vpv;
            Iant = ipv;
            contMPPT=0;
        }
    #endif

    // Referência constante p/ PI BUCK
    #ifdef Ref_Vi_CTE
        vi_ref = 26;
    #endif

    // Referência variável p/ PI BUCK
    #ifdef STEP_Ref_Vi                                          // Realização de degraus de tensão de referência
        cont = cont + 1;
        if(cont > 150000){
            if(vi_ref > 25)
            {
                vi_ref = 23;
                cont = 0;
            }
            else
            {
                vi_ref = 26;
                cont=0;
            }
        }
//        if(cont > 450000){
//            cont = 0;
//        }
//        if(cont > 150000 && cont <= 300000){
//            vi_ref = 27;
//        }
//        if(cont > 300000 && cont <= 450000){
//            vi_ref = 30;
//        }
//        if (cont > 450000 && cont <= 600000){
//            vi_ref = 27;
//        }
//        if(cont > 450000){
//            cont = 0;
//        }
    #endif

        // Lógica Fuzzy via look-up-table e interpolação linear
       cont_fuzzy = cont_fuzzy+1;
       if(cont_fuzzy == 30){
           erro = ek*kE;
           derro = (erro - erro1)*kdE;

           if (erro > 1){erro = 1;}
           if (erro < -1){erro = -1;}

           if (derro > 1){derro = 1;}
           if (derro < -1){derro = -1;}

           E = (int)(10*erro)+10;
           dE = (int)(10*derro)+10;

           if (E >= 20){
               E = 20;
               E1 = 20;
           }
           else if (E < 0) {
               E = 0;
               E1 = 1;
           }
           else {
               E1 = E + 1;
           }

           if (dE >= 20){
              dE = 20;
              dE1 = 20;
          }
          else if (dE < 0) {
              dE = 0;
              dE1 = 1;
          }
          else {
              dE1 = dE + 1;
          }

         if(E==E1 || dE == dE1) {
             dkp = get_dkp(E, dE);
             dki = get_dki(E, dE);
         }
         else {
             erro_E = (float)(E);
             erro_E =  (erro_E*2/20) - 1;
             derro_dE = (float)(dE);
             derro_dE = (derro_dE*2/20) -1;
             erro_E1 = (float)(E1);
             erro_E1 = (erro_E1*2/20) - 1;
             derro_dE1 = (float)(dE1);
             derro_dE1 = (derro_dE1*2/20) - 1;

             kp_E_dE = get_dkp(E,dE);
             kp_E_dE1 = get_dkp(E, dE1);
             kp_E1_dE = get_dkp(E1, dE);
             kp_E1_dE1 = get_dkp(E1,dE1);

             ki_E_dE = get_dki(E,dE);
             ki_E_dE1 = get_dki(E, dE1);
             ki_E1_dE = get_dki(E1, dE);
             ki_E1_dE1 = get_dki(E1,dE1);

             kp_erro_dE = (( kp_E1_dE - kp_E_dE)/(erro_E1 - erro_E))*(erro-erro_E)+ kp_E_dE;
             ki_erro_dE = (( ki_E1_dE - ki_E_dE)/(erro_E1 - erro_E))*(erro-erro_E)+ ki_E_dE;

             kp_erro_dE1 = (( kp_E1_dE1 - kp_E_dE1)/(erro_E1 - erro_E))*(erro-erro_E)+ kp_E_dE1;
             ki_erro_dE1 = (( ki_E1_dE1 - ki_E_dE1)/(erro_E1 - erro_E))*(erro-erro_E)+ ki_E_dE1;

             dkp = ((kp_erro_dE1 - kp_erro_dE)/(derro_dE1 - derro_dE))*(derro-derro_dE) + kp_erro_dE;
             dki = ((ki_erro_dE1 - ki_erro_dE)/(derro_dE1 - derro_dE))*(derro-derro_dE) + ki_erro_dE;
         }

             flag = (vin_0 > 22) ? 1.0 : 0.0;
             dkp = dkp*flag*kkp;
             dki = dki*flag*kki;

//
           kp_t = kp + dkp;
           ki_t = ki + dki;

           kp_t = (kp_t < 0) ? 0 : kp_t;
           ki_t = (ki_t < 0) ? 0 : ki_t;

           erro1=erro;
           cont_fuzzy = 0;
       }


    // Lógica de Controle do PI Buck
    // Cálculo do erro
    ek = -(vi_ref - vinf);

    // Eq. a diferenças - PI Lento discretizado ZOH
//    uk = uk_1 + (kcont1*ek) - (kcont2*ek_1);

    //PI contínuo discretizado Tustin
    A = (kp_t + (ki_t*Ts)/2);
    B = (kp_t - (ki_t*Ts)/2);
    uk = A*ek - B*ek_1 + uk_1;

    if(uk > dutymax){
        uk = dutymax;
    }else if(uk < dutymin){
        uk = dutymin;
    }

    // Atualização das variáveis
    ek_1 = ek;
    uk_1 = uk;
    duty = uk;

    updatePWM(duty);                                         // Chamada a função que atualiza a razão cíclica

//    DacaRegs.DACVALS.bit.DACVALS = (condInc + 0.5)*4095;
    DacaRegs.DACVALS.bit.DACVALS = (x == 0)*4095;
//    DacaRegs.DACVALS.bit.DACVALS = flag*4095;
//    DacaRegs.DACVALS.bit.DACVALS = (0.5+(0.5/kkp)*dkp)*4095;
//    DacaRegs.DACVALS.bit.DACVALS = (0.5+(0.5/kki)*dki)*4095;
//    DacaRegs.DACVALS.bit.DACVALS = (io_f[0]/5.0)*4095;
//    DacaRegs.DACVALS.bit.DACVALS = ((duty-0.4)*50)*4095;
//    DacaRegs.DACVALS.bit.DACVALS = (vinf/40)*4095;
//    DacaRegs.DACVALS.bit.DACVALS = (0.5+derro/2)*4095;
//    DacaRegs.DACVALS.bit.DACVALS = (ioref/10)*4095;
//    DacaRegs.DACVALS.bit.DACVALS = (T/323.)*4095;


    AdcaRegs.ADCINTFLGCLR.bit.ADCINT1 = 1;                   // Limpa a flag da interrupção INT1
    PieCtrlRegs.PIEACK.all = PIEACK_GROUP1;

    GpioDataRegs.GPADAT.bit.GPIO14 = 0;                      // Sinaliza o término da conversão A/D
}
#endif
