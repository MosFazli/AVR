#include <mega8.h>
#include <alcd.h>
#include <string.h>
#include <delay.h>

#define DELETE 10
#define ENTER 11
#define LOCK PORTC.0

char GetKey();

char sys_code[] = "1379";
char usr_code[sizeof(sys_code)] = "";
char usr_code_idx = 0;

void main(void)
{

char k;

DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

DDRC.0 = 1;
DDRD = 0xF0;

lcd_init(16);

while (1)
      {
      LOCK = 0;
      lcd_clear();
      lcd_gotoxy(3,0);
      lcd_puts("Lock: OFF");
      lcd_gotoxy(0,1);
      lcd_puts("Pass: ");
      GET_KEY:
      do{
      k = GetKey();
      }while(k == 0xFF);
      delay_ms(1);
      while(GetKey() != 0xFF);
      if(k == DELETE){
       strcpyf(usr_code, "");
       usr_code_idx = 0;
      }else if(k == ENTER){
       usr_code[usr_code_idx] = '\0';
       if(strcmp(usr_code,sys_code) == 0){
        LOCK = 1;
        lcd_clear();
        lcd_gotoxy(3,0);
        lcd_putsf("Lock: ON");
        while(GetKey() != DELETE);
       }
       else{
        lcd_clear();
        lcd_putsf("Invalid Password");
        delay_ms(2000);
       }
       strcpyf(usr_code, "");
       usr_code_idx = 0;
      }
      else{
        if(usr_code_idx < sizeof(usr_code) - 1){
            usr_code[usr_code_idx] = k + 0x30;
            usr_code_idx++;
            lcd_putchar('*');
        }
        goto GET_KEY;
      }
    }
}


char GetKey(){
 unsigned char key_code = 0xFF;
 unsigned char columns;
 PORTD.4 = 0;
 columns = PIND & 0x07;

 if(columns != 0x07){
  switch(columns){
   case 0b110: key_code = 1; break;
   case 0b100: key_code = 2; break;
   case 0b011: key_code = 3; break;
  }
 }
 PORTD.4 = 1;
 PORTD.5 = 0;
 columns = PIND & 0x07;
  if(columns != 0x07){
  switch(columns){
   case 0b110: key_code = 4; break;
   case 0b100: key_code = 5; break;
   case 0b011: key_code = 6; break;
  }
 }

 PORTD.5 = 1;
 PORTD.6 = 0;
 columns = PIND & 0x07;
 if(columns != 0x07){
  switch(columns){
   case 0b110: key_code = 7; break;
   case 0b100: key_code = 8; break;
   case 0b011: key_code = 9; break;
  }
 }

 PORTD.6 = 1;
 PORTD.7 = 0;
 columns = PIND & 0x07;
 if(columns != 0x07){
  switch(columns){
   case 0b110: key_code = DELETE; break;
   case 0b100: key_code = 0; break;
   case 0b011: key_code = ENTER; break;
  }
 }
 PORTD.7 = 1;
 PORTD = 0xFF;
 return key_code;



}