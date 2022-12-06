#include <mega16.h>
#include <delay.h>


unsigned char num1,num2 ,
data[] = {0xC0,0xF9,0xA4,0xB0,0x99,0x92,0x82,0xF8,0x80,0x90} ,
row[] ={0xFE,0xFD,0xFb,0xF7} ,
flag ,i,num;


unsigned char  get_input(){
      char result[2];
      unsigned char j = 0, column = 3;
      while(1){
            for (i = 0; i < 4; i++)
            {
                 PORTB = row[i];
                 while(PINB.4 == 0) column = 0;
                 while(PINB.5 == 0) column = 1;
                 while(PINB.6 == 0) column = 2;
                 while(column != 3){
                 result[j] =( i * 3 + column);
                 column = 3;
                 j++;
                        }
            if  (j == 2)   return (result[0] * 10 + result[1]);
            }


      }



}

void light (char num1 ,char num2 , char flag) {
    unsigned char counter = num1 * 10 + num2;
    while(counter) {
    for(i = 0; i < 15; i++){
            PORTD=0xFE; //0b11111110 PIND.0=0;
            if (flag)PORTA = 0x00;
            PORTC=data[num2];
            delay_ms(1);
            if (flag)   PORTA = 0b00000010;
            PORTD=0xFD; //0b11111101 PIND.1=0;
            PORTC=data[num1];
            delay_ms(1);
    }
            if(num2 == 0){
            num2=10;
            num1--;
            }
            num2--;
            if  (num1 == 0 && num2 ==0) break;

    }
}




void main() {
      PORTC=0x00;
      DDRC=0xFF;
      PORTD=0XFF;
      DDRD=0x03;
      DDRA = 0xFF;
      DDRB = 0x0F;
      PORTB = 0xFF;

     while(1) {
              PORTA = 0b00000001;
              num = get_input();
              num1 =num/10 +1 ;
              num2 =num%10 +1;
              flag = 0;
              light(num1 , num2,flag);


              num = get_input();
              num1 =num/10 + 1;
              num2 =num%10 + 1;
              flag = 0;
              PORTA = 0b00000010;



              light (num1 , num2,flag);


              num = get_input();
              num1 =num/10 +1;
              num2 =num%10 + 1;
              flag = 0;
              PORTA = 0b00000100;

              light (num1 , num2,flag);
     }
}