/**************************LUCAS ROCHA****************************/
/*
   Portas Alalogicas A = 1,2,3,4,5,6,7.
   Portas Digitais D = 2,3,4,5PWM,6PWM,7,8,9PWM,10PWM,11PWM,12.
   Data 28/05/2021
*/
#define btn_1 2 //PIN_D2
#define btn_2 3 //PIN_D3
#define btn_3 4 //PIN_D4
#define btn_4 5 //PIN_D5
#define btn_5 6 //PIN_D6
#define pin_e 7 //EDIT MODE
#define pin_l 8 //LOOP MODE
#define pin_p 9 //BTN COMUM
#define led1 A1 //PIN_A1
#define led2 A2 //PIN_A2
#define led3 A3 //PIN_A3
#define led4 A4 //PIN_A4
#define led5 A5 //PIN_A5
#define rel1 A0 //PIN_A0
#define rel2 13 //PIN_D13
#define rel3 12 //PIN_D12
#define rel4 11 //PIN_D11
#define rel5 10 //PIN_D10
#define tmpLongo 2000
#define tmpCurto 300
long tmpInicio;
/*****************************************************************/

void setup() {
  //put your setup code here, to run once:
  pinMode(btn_1, INPUT_PULLUP); //PIN_D2
  pinMode(btn_2, INPUT_PULLUP); //PIN_D3
  pinMode(btn_3, INPUT_PULLUP); //PIN_D4
  pinMode(btn_4, INPUT_PULLUP); //PIN_D5
  pinMode(btn_5, INPUT_PULLUP); //PIN_D6
  //pinMode(btn_1, INPUT);      //PIN_D6
  pinMode(pin_e, OUTPUT);       //PIN_D7
  pinMode(pin_l, OUTPUT);       //PIN_D8
  pinMode(pin_p, OUTPUT);       //PIN_D9
  pinMode(led1, OUTPUT);        //A1
  pinMode(led2, OUTPUT);        //A2
  pinMode(led3, OUTPUT);        //A3
  pinMode(led4, OUTPUT);        //A4
  pinMode(led5, OUTPUT);        //A5
  pinMode(rel1, OUTPUT);        //A0
  pinMode(rel2, OUTPUT);        //D13
  pinMode(rel3, OUTPUT);        //D12
  pinMode(rel4, OUTPUT);        //D11
  pinMode(rel5, OUTPUT);        //D10

  digitalWrite(pin_l, HIGH);    //INCIA EM LOOP MODE
}
//===================================SINALIZAÇÃO LEDS================================//
void canal(char nLed) {           //MODO LOOP LED
  int led[5] = {led1, led2, led3, led4, led5};
  for (int i = 0; i < 5; i++) {
    digitalWrite(led[i], LOW);   //APAGA LEDS EM MODO LOOP
  }
  digitalWrite(nLed, !digitalRead(nLed)); //LIGAR LED
}
void canal_Edit(char eLed){    //MODO EDIT LED
  digitalWrite(eLed, !digitalRead(eLed)); //LIGAR LED
}
//===================================SINALIZAÇÃO LEDS================================//

//===================================EDITAR MOD================================//
//===================================LOOP MOD================================//
void modLoop() {
  digitalWrite(pin_e, LOW);                     //APAGA O LED EDIT MOD
  digitalWrite(pin_l, HIGH);                    //ACIONA O LED LOOP MOD
}
//===================================LOOP MOD================================//
void edite() {
  digitalWrite(pin_e, HIGH);                    //ACIONA O LED EDIT MOD
  digitalWrite(pin_l, LOW);                     //APAGA O LED LOOP MOD
}
//===================================EDITAR MOD================================//

//===================================MENU SALVAR================================//
void salvar() {
  digitalWrite(pin_e, LOW);                     //APAGA O LED EDIT MOD
  digitalWrite(pin_l, LOW);
}
void piscaLed(char cLed) { //PISCA LED PARA CONFIRMAÇÃO DE SALVAMENTO EM MEMÓRIA
  int cont = 0;
  for (int i = 0; i <= 14; i++) {
    if ((cont = i) % 2) {
      digitalWrite(cLed, LOW);
      delay(100);
    } else if ((cont = i) % 3) {
      digitalWrite(cLed, HIGH);
      delay(100);
    }
  }
}
void piscaSpeed() { //PISCA LED PARA CONFIRMAÇÃO DE SALVAMENTO EM MEMÓRIA
  int cont = 0;
  for (int i = 0; ;i++){
    if ((cont = i) % 2) {
      digitalWrite(led1, LOW);
      digitalWrite(led2, LOW);
      digitalWrite(led3, LOW);
      digitalWrite(led4, LOW);
      digitalWrite(led5, LOW);
      delay(50);
    } else if ((cont = i) % 3) {
      digitalWrite(led1, HIGH);
      digitalWrite(led2, HIGH);
      digitalWrite(led3, HIGH);
      digitalWrite(led4, HIGH);
      digitalWrite(led5, HIGH);
      delay(50);
     }else if(digitalRead(btn_1) == LOW){
       if ((millis() - tmpInicio >= tmpLongo)) {
        break; 
        }   
     }
  }
}
void apagaRele() {
      digitalWrite(rel1, LOW);
      digitalWrite(rel2, LOW);
      digitalWrite(rel3, LOW);
      digitalWrite(rel4, LOW);
      digitalWrite(rel5, LOW);
}
//===================================MENU SALVAR================================//

void loop() {
  //put your main code here, to run repeatedly:
  //*****************************************DUPLA FUNÇÃO*****************************************BTN1//
  // BOTÃO EDIT MOD
  tmpInicio = digitalRead(btn_1); //le o estado do botão - HIGH OU LOW
  if (digitalRead(btn_1) == LOW) {
    tmpInicio = millis();
    while ((millis() - tmpInicio < tmpLongo) && (digitalRead(btn_1) == LOW));
    if ((millis() - tmpInicio < tmpCurto)){         //CLICK E ACIOMA O LED1 SE O EDITI ESTIVER LOW
      if(digitalRead(pin_l) == HIGH){
        //digitalWrite(led1, !digitalRead(led1));
        canal(led1);       
      }
      else if (digitalRead(pin_e) == HIGH){         //CLICK E ACIOMA O LED1 SE O EDITI ESTIVER HIGH
        canal_Edit(rel1);
      }
    //PRESS 2s E ACIOMA O EDIT MOD E APAGA OS LED D1 - D5
    } else if ((millis() - tmpInicio >= tmpLongo)  && (digitalRead(pin_l) == HIGH)){   
      //digitalWrite(led1, !digitalRead(led1));
        edite();
        canal(' ');    
      while (digitalRead(btn_1) == LOW);
    }
    //PRESS 2s SALVAR BD
      else if ((millis() - tmpInicio >= tmpLongo) && (digitalRead(pin_e) == LOW) && (digitalRead(pin_l) == LOW)){  
      //digitalWrite(led1, !digitalRead(led1));
       canal(led1);
       piscaLed(led1);
       modLoop();
       apagaRele();
      while (digitalRead(btn_1) == LOW);
    } else {                                          //PRESS 2s E ACIOMA O LOOP MOD SEM SALVAR
      //digitalWrite(led1, !digitalRead(led1));
      canal(' ');
      modLoop();
      while (digitalRead(btn_1) == LOW);
    }
  }
  //*****************************************DUPLA FUNÇÃO*****************************************BT2//
  // BOTÃO SAVE MOD
  tmpInicio = digitalRead(btn_2); //le o estado do botão - HIGH OU LOW
  if (digitalRead(btn_2) == LOW) {
    tmpInicio = millis();
    while ((millis() - tmpInicio < tmpLongo) && (digitalRead(btn_2) == LOW));
    if (millis() - tmpInicio < tmpCurto) {
      if(digitalRead(pin_l) == HIGH){
        //digitalWrite(led1, !digitalRead(led1));
        canal(led2);
      }else if (digitalRead(pin_e) == HIGH){         //CLICK E ACIOMA O LED1 SE O EDITI ESTIVER HIGH
        canal_Edit(rel2);
      }  
     //PRESS 2s E ACIOMA MOD SALVAR
    } else if ((millis() - tmpInicio >= tmpLongo) && (digitalRead(pin_e) == HIGH)){   
      //digitalWrite(led1, !digitalRead(led1));
       salvar();
       piscaSpeed();
      while (digitalRead(btn_2) == LOW);
    }
  }
  //*****************************************DUPLA FUNÇÃO*****************************************//
  tmpInicio = digitalRead(btn_3); //le o estado do botão - HIGH OU LOW
  if (digitalRead(btn_3) == LOW) {
    tmpInicio = millis();
    while ((millis() - tmpInicio < tmpLongo) && (digitalRead(btn_3) == LOW));
    if (millis() - tmpInicio < tmpCurto) {
      if(digitalRead(pin_l) == HIGH){
        //digitalWrite(led1, !digitalRead(led1));
        canal(led3);
      }else if (digitalRead(pin_e) == HIGH){         //CLICK E ACIOMA O LED1 SE O EDITI ESTIVER HIGH
        canal_Edit(rel3);
      }
    }
  }
  tmpInicio = digitalRead(btn_4); //le o estado do botão - HIGH OU LOW
  if (digitalRead(btn_4) == LOW) {
    tmpInicio = millis();
    while ((millis() - tmpInicio < tmpLongo) && (digitalRead(btn_4) == LOW));
    if (millis() - tmpInicio < tmpCurto) {
      if(digitalRead(pin_l) == HIGH){
        //digitalWrite(led1, !digitalRead(led1));
        canal(led4);
      }else if (digitalRead(pin_e) == HIGH){         //CLICK E ACIOMA O LED1 SE O EDITI ESTIVER HIGH
        canal_Edit(rel4);
      }
    }
  }
    //*****************************************DUPLA FUNÇÃO*****************************************//
  tmpInicio = digitalRead(btn_5); //le o estado do botão - HIGH OU LOW
  if (digitalRead(btn_5) == LOW) {
    tmpInicio = millis();
    while ((millis() - tmpInicio < tmpLongo) && (digitalRead(btn_5) == LOW));
    if (millis() - tmpInicio < tmpCurto) {
      if(digitalRead(pin_l) == HIGH){
        //digitalWrite(led1, !digitalRead(led1));
        canal(led5);
      }else if (digitalRead(pin_e) == HIGH){         //CLICK E ACIOMA O LED1 SE O EDITI ESTIVER HIGH
        canal_Edit(rel5);
      }
    }
  }
    //*****************************************DUPLA FUNÇÃO*****************************************//
}//fim loop
//C:\Users\LuKInhas\AppData\Local\Temp\arduino_build_570449\Bot_o_dupla_fun__o.ino.hex