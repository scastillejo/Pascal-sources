program pvendedores;
uses crt;
type
    vendedores=record
    nro:integer;
    desc:string[25];
    cuil:string[25];
end;
ve= file of vendedores;
var A:ve;reg:vendedores;
    num,o:integer;cui:string;

begin
     assign(A,'D:\Pascal\VENDEDORES.dat');
     repeat
       clrscr;
       gotoxy(20,1);
       writeln('SOCIOS');
       gotoxy(20,2);
       writeln('-------------');
       gotoxy(20,4);
       writeln('1-Alta Vendedores');
       gotoxy(20,6);
       writeln('2-Salir');
       gotoxy(20,8);
       write('Opcion: ');
       readln(o);
       if (o=1) then
       begin
              clrscr;
              {$I-}
              reset(A);
              {$I+}
              if (IOResult<>0) then
                  rewrite(A);
              repeat
                    write('Ingrese un numero (1 a 20): ');readln(num);
              until (num>=1) and (num<21);
              write('Ingrese CUIL: ');readln(cui);
              seek(A,0);
              while (not eof(A)) do
              begin
                   read(A,reg);
                   if (reg.nro=num) or (reg.cuil=cui)then
                   begin
                        write('Alta duplicada');
                        close(A);
                        readkey;
                        exit;
                   end;
              end;
              write('Apellido y Nombre: ');readln(reg.desc);
              reg.nro:=num;
              reg.cuil:=cui;
              write(A,reg);
              write('Alta generada');
              close(A);
              readkey;
      end;
     until o>=2;
end.
