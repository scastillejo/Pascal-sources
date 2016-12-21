program cajeroautomatico;
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
    nro,op,clv,flag:integer;


function validarclave(rcla,c:integer):boolean;
var i:integer;
begin
     for i:=0 to 1 do
     begin
          if (rcla<>c) then
          begin
               clrscr;
               writeln('Clave incorrecta');
               write('Ingrese clave de acceso: ');readln(c);
          end;
          if (rcla=c) then
          begin
               validarclave:=true;
               exit;
          end;
     end;
     validarclave:=false;
end;
function modificacion(nro:integer):string;
var s:string;
    clv1,clv2:integer;
begin
     repeat
           clrscr;
           writeln('Clave actual: ',r.clave);
           write('Ingrese nueva clave: ');readln(clv1);
           write('Repita la nueva clave (0 para salir): ');readln(clv2);
           if (clv2<>0) and (clv1=clv2) then
           begin
                seek(f,0);
                while (not eof(f)) do
                begin
                     read(f,r);
                     if (r.nro=nro) then
                     begin
                          write('Confirma cambio de clave? (S/N): ');readln(s);
                          if(s='s') or (s='S') then
                          begin
                               r.clave:=clv1;
                               seek(f,filepos(f)-1);
                               write(f,r);
                               modificacion:='Clave modificada.';
                               exit;
                          end;
                     end;
                end;
           end;
           if (clv2<>0) and (clv1<>clv2) then
           begin
                write('Las claves ingresadas no coinciden.');
                readkey;
           end;
           if (clv2=0) then
           begin
                modificacion:='';
                exit;
           end;
     until clv2=0;
end;
function consultarsaldo(num:integer):real;
begin
     seek(f,0);
     while (not eof(f)) do
     begin
          read(f,r);
          if (r.nro=num) then
          begin
               consultarsaldo:=r.saldo;
               exit;
          end;
     end;
     consultarsaldo:=0;
end;
procedure extraccion(nro:integer);
var s:string;
    mon,sal:real;
begin
     repeat
           clrscr;
           flag:=0;
           write('Ingrese monto a extraer (0 para salir): ');readln(mon);
           if (mon<>0) and (mon<=r.saldo) then
           begin
                seek(f,0);
                while (not eof(f)) do
                begin
                     read(f,r);
                     if (r.nro=nro) then
                     begin
                          write('Confirma extraccion? (S/N): ');readln(s);
                          if(s='s') or (s='S') then
                          begin
                               sal:=r.saldo;
                               r.saldo:=r.saldo-mon;
                               seek(f,filepos(f)-1);
                               write(f,r);
                               writeln;
                               writeln('Extraccion exitosa.');
                               flag:=1;
                          end;
                     end;
                end;
           end;
           if (flag>0) then
           begin
                seek(f,0);
                while (not eof(f)) do
                begin
                     read(f,r);
                     if (r.nro=nro) then
                     begin
                          writeln('Saldo anterior: ',sal:2:2);
                          writeln('Monto extraido: ',mon:2:2);
                          writeln('Saldo actual: ',r.saldo:2:2);
                          readkey;
                          exit;
                     end;
                end;
           end;
           if (mon<>0) and (mon>r.saldo) then
           begin
                write('El monto no puede ser superior al saldo de la cuenta. (Saldo actual: ',r.saldo:2:2,')');
                readkey;
           end;
     until mon=0;
end;
procedure deposito(nro:integer);
var s:string;
    mon,sal:real;
begin
     repeat
           clrscr;
           flag:=0;
           write('Ingrese monto a depositar (0 para salir): ');readln(mon);
           if (mon<>0) then
           begin
                seek(f,0);
                while (not eof(f)) do
                begin
                     read(f,r);
                     if (r.nro=nro) then
                     begin
                          write('Confirma deposito? (S/N): ');readln(s);
                          if(s='s') or (s='S') then
                          begin
                               sal:=r.saldo;
                               r.saldo:=r.saldo+mon;
                               seek(f,filepos(f)-1);
                               write(f,r);
                               writeln;
                               writeln('Deposito realizado.');
                               flag:=1;
                          end;
                     end;
                end;
           end;
           if (flag>0) then
           begin
                seek(f,0);
                while (not eof(f)) do
                begin
                     read(f,r);
                     if (r.nro=nro) then
                     begin
                          writeln('Saldo anterior: ',sal:2:2);
                          writeln('Monto depositado: ',mon:2:2);
                          writeln('Saldo actual: ',r.saldo:2:2);
                          readkey;
                          exit;
                     end;
                end;
           end;
     until mon=0;
end;
begin
     assign(f,'D:\Pascal\RCAJERO.dat');
     flag:=0;
     repeat
           clrscr;
           reset(f);
           write('INGRESO DE DATOS (0 para finalizar)');
           writeln;
           write('Ingrese numero de cuenta: ');readln(nro);
           if (nro<>0) then
           begin
                write('Ingrese clave de acceso: ');readln(clv);
                seek(f,0);
                while (not eof(f)) do
                begin
                     read(f,r);
                     if (r.nro=nro) then
                     begin
                          if validarclave(r.clave,clv) then
                          begin
                               clrscr;
                               write('Bienvenido SR/SRA: ',r.titular);
                               writeln;
                               write('Gracias por usar esta red de cajeros (Presione Enter)');
                               readkey;
                               repeat
                                     clrscr;
                                     gotoxy(20,1); write('CAJERO AUTOMATICO');
                                     gotoxy(20,3); write('1-MODIFICACION DE CLAVE');
                                     gotoxy(20,5); write('2-CONSULTA DE SALDO');
                                     gotoxy(20,7); write('3-EXTRACCIONES');
                                     gotoxy(20,9); write('4-DEPOSITOS');
                                     gotoxy(20,11); write('5-FINALIZAR');
                                     gotoxy(20,15); write('Opci¢n:');
                                     readln(op);
                                     if (op=1) then
                                     begin
                                          clrscr;
                                          write(modificacion(nro));
                                          readkey;
                                     end;
                                     if (op=2) then
                                     begin
                                          clrscr;
                                          write('Saldo de la Cuenta: ',consultarsaldo(nro):2:2);
                                          readkey;
                                     end;
                                     if (op=3) then extraccion(nro);
                                     if (op=4) then deposito(nro);
                               until (op>=5);
                          end
                          else
                          begin
                               writeln('Tarjeta retenida. Concurra a la sucursal correspondiente. Muchas Gracias.');
                               readkey;
                          end;
                          flag:=1;
                    end;
                end;
                if (flag<1) and (nro>0) then
                begin
                     write('El numero de cuenta no existe.');
                     readkey;
                end;
            end;
     until (nro=0);
     close(f);
     write('Fin del programa.');
     readkey;
end.
