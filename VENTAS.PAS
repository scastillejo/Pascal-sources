program pventas;
uses crt;
type ventas=record
     nro:integer;
     desc:string[25];
     cant:integer;
end;
type vendedores=record
     nro:integer;
     desc:string[25];
     cuil:string[25];
end;
type tabla=record
     nro:integer;
     cant:integer;
end;
ven=file of ventas;
vend=file of vendedores;
type vector=array[0..5] of tabla;
var vta1:vend;
    vta2:ven;
    reg1:vendedores;
    reg2:ventas;
    v:vector;
    o,i,c:integer;

begin
     assign(vta1,'D:\Pascal\VENDEDORES.dat');
     assign(vta2,'D:\Pascal\VENTAS.dat');
     repeat
           clrscr;
           gotoxy(20,1);
           writeln('VENTAS');
           gotoxy(20,2);
           writeln('------');
           gotoxy(20,4);
           writeln('1-Ingresar Ventas');
           gotoxy(20,6);
           writeln('2-Salir');
           gotoxy(20,8);
           writeln('Opcion: ');
           readln(o);
           if (o=1) then
           begin
                clrscr;
                for i:=1 to 5 do
                begin
                     with v[i] do
                     begin
                          write('Ingrese Nro. Vendedor: ');readln(nro);
                          write('Ingrese Cantidad Vendida: ');readln(cant);
                     end;
                end;
                reset(vta1);
                seek(vta1,0);
                rewrite(vta2);
                while (not eof(vta1)) do
                begin
                     read(vta1,reg1);
                     c:=0;
                     for i:=1 to 5 do
                     begin
                          if (reg1.nro=v[i].nro) then c:=c+v[i].cant;
                     end;
                     if (c>0) then
                     begin
                          reg2.nro:=reg1.nro;
                          reg2.desc:=reg1.desc;
                          reg2.cant:=c;
                          write(vta2,reg2);
                     end;
                 end;
                 {seek(vta2,0);
                 while (not EOF(vta2)) do
                 begin
                      read(vta2,reg2);
                      writeln(reg2.nro,reg2.desc,reg2.cant);
                 end;}
                 close(vta1);
                 close(vta2);
                 readkey;
            end;
    until o>=2;
end.









