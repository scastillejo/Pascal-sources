program auxcajero;
uses crt;
type
    usuarios=record
    nro:integer;
    titular:string[20];
    clave:integer;
    saldo:real;
end;
usu= file of usuarios;
var f:usu;r:usuarios;
    num,o,clv:integer;
    titular:string;
    sal:real;

begin
     assign(f,'C:\users\seb\documents\RCAJERO.dat');
     repeat
         clrscr;
         gotoxy(20,1);
         writeln('INGRESAR USUARIOS');
         gotoxy(20,2);
         writeln('-------------');
         gotoxy(20,4);
         writeln('1-Alta Usuarios');
         gotoxy(20,6);
         writeln('2-Salir');
         gotoxy(20,8);
         write('Opcion: ');
         readln(o);
         if (o=1) then
         begin
              clrscr;
              {$I-}
              reset(f);
              {$I+}
              if (IOResult<>0) then
                  rewrite(f);
              repeat
                    write('Ingrese un numero de cuenta: ');readln(num);
              until (num>=1);
              seek(f,0);
              while (not eof(f)) do
              begin
                   read(f,r);
                   if (r.nro=num) then
                   begin
                        write('La cuenta ya existe...');
                        close(f);
                        readkey;
                        exit;
                   end;
              end;
              write('Ingrese Titular: ');readln(r.titular);
              repeat
                    write('Ingrese la clave de acceso: ');readln(clv);
              until (clv>=1);
              repeat
                    write('Ingrese el saldo de la cuenta: ');readln(sal);
              until (sal>=1);
              r.nro:=num;
              r.clave:=clv;
              r.saldo:=sal;
              write(f,r);
              write('Usuario ingresado');
              close(f);
              readkey;
         end;
     until o>=2;
end.
