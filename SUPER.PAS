program supermercado;
uses crt;
type
     tr=record
     cod:integer;
     desc:string[25];
     sect:string[15];
     precio:real;
end;
type
     tabla=record
     cod:integer;
     cant:integer;
end;
type vector=array[0..20] of tabla;
ta=file of tr;
var
   r:tr;
   f:ta;
   v:vector;
   i,op,flag:integer;

function sectores(i:integer):string;
begin
     case i of
       1:sectores:='ALMACEN';
       2:sectores:='FIAMBRERIA';
       3:sectores:='CARNES';
       4:sectores:='VERDULERIA';
       5:sectores:='PERFUMERIA';
       6:sectores:='LIMPIEZA';
     end;
end;
procedure listado;
begin
     writeln;
     writeln('SECTORES');
     writeln('1-ALMACEN');
     writeln('2-FIAMBRERIA');
     writeln('3-CARNES');
     writeln('4-VERDULERIA');
     writeln('5-PERFUMERIA');
     writeln('6-LIMPIEZA');
     writeln;
end;
procedure existencia;
begin
     {$I-}
     reset(f);
     {$I+}
     if (IOResult<>0) then
     begin
          write('No existe el archivo.');
          readkey;
          exit;
     end;
end;
procedure alta;
var cod,sect:integer;
begin
     repeat
           clrscr;
           {$I-}
           reset(f);
           {$I+}
           if (IOResult<>0) then rewrite(f);
           write('Ingrese codigo (0 para salir): ');readln(cod);
           if (cod<>0) then
           begin
                seek(f,0);
                while (not eof(f)) do
                begin
                     read(f,r);
                     if (r.cod=cod) then
                     begin
                          write('Registro duplicado.');
                          cod:=-1;
                          readkey;
                     end;
                end;
           end;
           if (cod>0) then
           begin
                write('Ingrese descripcion: ');readln(r.desc);
                listado;
                repeat
                      write('Ingrese codigo de sector (1 al 6): ');readln(sect);
                until (sect>0) and (sect<7);
                r.sect:=sectores(sect);
                write('Ingrese precio: ');readln(r.precio);
                r.cod:=cod;
                write(f,r);
                write('Alta generada.');
                readkey;
           end;
           close(f);
      until cod=0;
end;
procedure baja;
var temporal:file of tr;
    cod:integer;
    resp:string;
begin
     repeat
           clrscr;
           existencia;
           write('Ingrese codigo (0 para salir): ');readln(cod);
           if (cod<>0) then
           begin
                assign(temporal,'D:\Pascal\temporal.tmp');
                rewrite(temporal);
                seek(f,0);
                flag:=0;
                while (not eof(f)) do
                begin
                     read(f,r);
                     if(r.cod=cod) then
                     begin
                          writeln(r.cod,' ',r.desc,' ',r.sect,' ',r.precio:2:2);
                          flag:=1;
                          writeln('Confirma baja? (s/n): ');readln(resp);
                          if (resp<>'s') and (resp<>'S') then begin write(temporal,r); end
                          else write('Registro eliminado.');
                     end
                     else
                         write(temporal,r);
                end;
                close(temporal);
                close(f);
                if(flag>0) then
                begin
                     erase(f);
                     rename(temporal,'D:\Pascal\SUPER.dat');
                end
                else
                    write('Codigo inexistente.');
                readkey;
           end;
     until cod=0;
end;
procedure modificacion;
var desc:string[25];
    s:string;
    cod:integer;
    precio:real;
begin
     repeat
           clrscr;
           existencia;
           write('Ingrese codigo (0 para salir): ');readln(cod);
           if (cod<>0) then
           begin
                seek(f,0);
                flag:=0;
                while (not eof(f)) do
                begin
                     read(f,r);
                     if (r.cod=cod) then
                     begin
                          write(r.desc);
                          writeln;
                          write('Introduzca nueva descripcion: ');readln(desc);
                          write(r.precio:2:2);
                          writeln;
                          write('Introduzca nuevo precio: ');readln(precio);
                          write('Confirma cambios? (S/N): ');readln(s);
                          if(s='s') or (s='S') then
                          begin
                               if (desc<>'') then r.desc:=desc;
                               if (precio<>0) then r.precio:=precio;
                               seek(f,filepos(f)-1);
                               write(f,r);
                               write('Registro modificado.');
                               readkey;
                          end;
                          flag:=1;
                     end;
                end;
                if(flag=0) then
                begin
                     write('No se encuentra el registro.');
                     readkey;
                end;
           end;
           close(f);
     until cod=0;
end;
procedure consulta;
var opc,num:integer;
begin
     repeat
           clrscr;
           existencia;
           clrscr;
           gotoxy(20,1); write('1-Consulta por Sector');
           gotoxy(20,3); write('2-Consulta por Codigo');
           gotoxy(20,5); write('3-Salir');
           gotoxy(20,9); write('Opci¢n:');
           readln(opc);
           clrscr;
           if (opc=1) then
           begin
                listado;
                repeat
                      write('Ingrese codigo de sector (1 al 6): ');readln(num);
                until (num>0) and (num<7);
                seek(f,0);
                while (not eof(f)) do
                begin
                     read(f,r);
                     if (r.sect=sectores(num)) then writeln(r.cod,' ',r.desc,' ',r.precio:2:2);
                end;
                readkey;
           end;
           if (opc=2) then
           begin
                write('Ingrese codigo de producto: ');readln(num);
                seek(f,0);
                while (not eof(f)) do
                begin
                     read(f,r);
                     if (r.cod=num) then write(r.cod,' ',r.desc,' ',r.precio:2:2);
                end;
                readkey;
           end;
           close(f);
     until (opc>2);
end;
procedure facturacion;
var c,i:integer;
    imp,tot:real;
    s:string;
begin
     clrscr;
     existencia;
     c:=0;
     repeat
           with v[c] do
           begin
                write('Ingrese codigo: ');readln(cod);
                write('Ingrese cantidad:');readln(cant);
                c:=c+1;
           end;
           write('(F para finalizar/Enter para continuar) ');readln(s);
     until (s='f') or (s='F');
     seek(f,0);
     while (not eof(f)) do
     begin
          read(f,r);
          for i:=0 to c-1 do
          begin
               if (r.cod=v[i].cod) then
               begin
                    imp:=r.precio*v[i].cant;
                    writeln('Prod: ',r.desc,' P.U.: ',r.precio:2:2,' Cant.: ', v[i].cant, ' Importe: ',imp:2:2);
                    tot:=tot+imp;
               end;
          end;
     end;
     writeln('Total: ',tot:2:2);
     close(f);
     readkey;
     exit;
end;
begin
     assign(F,'D:\Pascal\SUPER.dat');
     repeat
           clrscr;
           gotoxy(20,1); write('SUPERMERCADO');
           gotoxy(20,3); write('1-Altas');
           gotoxy(20,5); write('2-Bajas');
           gotoxy(20,7); write('3-Modificaciones');
           gotoxy(20,9); write('4-Consultas');
           gotoxy(20,11); write('5-Facturacion');
           gotoxy(20,13); write('6-Salir');
           gotoxy(20,17); write('Opci¢n:');
           readln(op);
           case op of
             1:alta;
             2:baja;
             3:modificacion;
             4:consulta;
             5:facturacion;
           end;
     until op>=6;
     gotoxy(20,19);
     write('Fin del programa.');
end.
