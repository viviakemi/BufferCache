Program BufferPool;
Uses crt;
Type
Apontador = ^Celula;
TipoItem = record
           bloco:string[40];
           end;
Celula= record
         item: TipoItem;
         proxlru,antlru,proxhash: apontador;
         flag:boolean;
         numbloco:integer;
        end;
TipoLista = record
            primeiro,ultimo:apontador;
            end;

TipoDisco = array [0..999] of TipoItem;
TipoHash = array [0..9] of Apontador;

Var
cont,opcao:integer;
buffer:TipoLista;
disco:TipoDisco;
hash:TipoHash;



procedure inicializalista(var lista:TipoLista);
begin
 lista.primeiro := nil;
 lista.ultimo := nil;
end;

procedure inicializadisco(var disk:TipoDisco);
var i:integer;
begin
  for i:=0 to 999 do
    disk[i].bloco:='Esta Vazio!';
end;

procedure inicializahash(var tablehash:TipoHash);
var i:integer;
begin
  for i:=0 to 9 do
    tablehash[i]:= nil;
end;

function pesquisa (tablehash:TipoHash;indice:integer;var buffer:TipoLista; nro:integer):Apontador;
var bloco: Apontador;
begin
      bloco:= tablehash[indice];
      if bloco<>nil then
      begin
       while (bloco^.numbloco<>nro) and (bloco^.proxhash<>nil) do
         bloco:= bloco^.proxhash;
       if (bloco^.numbloco=nro) then
        begin
         pesquisa:= bloco;
        end
       else
        begin
         pesquisa:= nil;
        end;
      end
      else
       begin
         pesquisa := nil;
       end;
end;

procedure titulo;
begin
   textcolor (lightblue);
   gotoxy (22,2);
   writeln ('ษอออออออออออออออออออออออออออออออออออป ');
   gotoxy (22,3);
   writeln ('บ                                   บ ');
   gotoxy (22,4);
   writeln ('ศอออออออออออออออออออออออออออออออออออผ ');
   gotoxy (30,3);
   textcolor(lightgreen);
   writeln ('Programa BUFFER-POOL');
end;

procedure telainicial;
begin
  textbackground(black);
     clrscr;
     textcolor (lightblue);
     write('ษออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป');
     write('บ                                                                              บ');
     write('บ                                                                              บ');
     write('บ                                                                              บ');
     write('บ                                                                              บ');
     write('บ                                                                              บ');
     write('บ                                                                              บ');
     write('บ                                                                              บ');
     write('บ                                                                              บ');
     write('บ                                                                              บ');
     write('บ                                                                              บ');
     write('บ                                                                              บ');
     write('บ                                                                              บ');
     write('บ                                                                              บ');
     write('บ                                                                              บ');
     write('บ                                                                              บ');
     write('บ                                                                              บ');
     write('บ                                                                              บ');
     write('บ                                                                              บ');
     write('บ                                                                              บ');
     write('ฬอออออออออออออออออออออออออออออออออหอออออออออออออออออออออหออออออORI-TURMA ออออออน');
     write('บ Viviani Kasahara                บTrabalho Pratico 01  บ Profง Ricardo        บ');
     write('บ Caroline Perlin                 บ                     บ                      บ');
     write('ศอออออออออออออออออออออออออออออออออสอออออออออออออออออออออสออออออออออออออออออออออผ');
     titulo;
end;

procedure gravadisco(bloco:Apontador; var disk:TipoDisco);
begin
   gotoxy(9,7);
   disk[bloco^.numbloco]:= bloco^.item;
   textcolor(yellow);
   writeln('Bloco ',bloco^.numbloco,' foi gravado com sucesso');
   delay(3500);
   gotoxy(9,7);
   delline;
end;

procedure Atualiza(var buffer:TipoLista;var bloco:Apontador);
begin
  if buffer.primeiro<>bloco then
  begin
   if bloco=buffer.ultimo then
    begin
      buffer.primeiro^.antlru:= bloco;
      bloco^.proxlru:= buffer.primeiro;
      buffer.ultimo:= buffer.ultimo^.antlru;
      bloco^.antlru:= nil;
      buffer.primeiro:= bloco;
      buffer.ultimo^.proxlru:= nil;
    end
   else
     begin
       (bloco^.antlru)^.proxlru:= bloco^.proxlru;
       (bloco^.proxlru)^.antlru:= bloco^.antlru;
       (buffer.primeiro)^.antlru:= bloco;
       (bloco^.proxlru):= buffer.primeiro;
       bloco^.antlru:= nil;
       buffer.primeiro:= bloco;
      end;
   end;
end;

procedure escreve(var novacel: Apontador);
var r:string[40];
begin
     gotoxy(19,11);
     textcolor(yellow);
     writeln('Operacao Escrita');
     gotoxy(19,13);
     writeln('Digite:');
     gotoxy(25,13);
     read(r);
     {novacel^.item.bloco);
     read(r);              }
end;

procedure le(celula: Apontador);
begin
     gotoxy(19,11);
     textcolor(yellow);
     writeln('Operacao de Leitura');
     gotoxy(19,13);
     write('Conteudo: ', celula^.item.bloco);
     delay(2000);
end;

procedure insere(nro:integer;operacao:boolean;var tablehash:TipoHash;
                 var buffer:TipoLista;var cont:integer; var disk:TipoDisco);
var indice:integer;
    novacel:Apontador;
    bloco:Apontador;
    ant:Apontador;
    indicepesquisado: integer;
begin
     textcolor(white);
     indice := nro mod 10;
     bloco:= pesquisa(tablehash,indice,buffer,nro);
     if bloco=nil then
      begin
        if cont = 50 then
         begin
             gotoxy(19,12);
             textcolor(lightred);
             writeln('Buffer-Pool contem 50 blocos');
             delay(3000);
             gotoxy(19,12);
             delline;
             gotoxy(19,12);
             textcolor(white);
             writeln('Bloco ',nro,' buscado na particao');
             delay(2000);
             if buffer.ultimo^.flag = true then
              begin
                gravadisco(buffer.ultimo, disk);
              end;
             indicepesquisado := buffer.ultimo^.numbloco mod 10;
             novacel:= tablehash[indicepesquisado];
             while novacel^.numbloco <> buffer.ultimo^.numbloco do
             begin
                  ant:=novacel;
                  novacel:= novacel^.proxhash;
             end;
             ant^.proxhash := nil;
             novacel := buffer.ultimo;
             buffer.ultimo := buffer.ultimo^.antlru;
             buffer.ultimo^.proxlru := nil;
             novacel^.item := disk[nro];
             novacel^.numbloco := nro;
             novacel^.flag := operacao;
             novacel^.proxlru:= buffer.primeiro;
             novacel^.antlru:= nil;
             buffer.primeiro^.antlru:= novacel;
             buffer.primeiro:= novacel;
         end
        else
         begin
            gotoxy(19,9);
            writeln('Bloco ', nro, ' buscado na particao');
            delay(2000);
            new(novacel);
            novacel^.item:=disk[nro];
            novacel^.numbloco:=nro;
            novacel^.proxhash:=tablehash[indice];
            tablehash[indice]:= novacel;
            novacel^.flag:= operacao;
            if cont=0 then
             begin
                 buffer.primeiro:=novacel;
                 buffer.ultimo:=novacel;
                 novacel^.antlru:=nil;
                 novacel^.proxlru:=nil;
             end
            else
             begin
              novacel^.proxlru:= buffer.primeiro;
              novacel^.antlru:= nil;
              buffer.primeiro^.antlru:= novacel;
              buffer.primeiro:= novacel;
             end;
            cont:= cont + 1;
         end;
         if operacao = true then
          begin
            escreve(novacel);
          end
         else
          begin
             le(novacel);
          end;
         gotoxy(22,17);
         writeln('Bloco incluso') ;
         delay(2000);
      end
      else if bloco<>nil then
         begin
            Atualiza(buffer,bloco);
            gotoxy(19,9);
            writeln('Bloco ',nro,' encontrado no Buffer-Pool');
            delay(2000);
            if operacao = true then
             begin
               escreve(bloco);
               if bloco^.flag = false then
                 begin
                   bloco^.flag := true;
                 end;
             end
            else
             begin
                le(bloco);
             end;
            gotoxy(22,17);
            writeln('Bloco atualizado com sucesso');
            delay(2000);
         end;
end;



procedure imprimelru(buffer:TipoLista);
var bloco:Apontador;
    i,j,contbloco,max,contlinha: integer;
    ch:char;

begin
 bloco := buffer.primeiro;
 contlinha:=0;
 if bloco<>nil then
 begin
  while bloco<> nil do
   begin
    clrscr;
    telainicial;
    gotoxy (25,3);
    textcolor(lightgreen);
    writeln ('Programa BUFFER-POOL:LISTA LRU');
    i:=7;
    j:=3;
    contlinha:=2;
    contbloco:=0;
    max:=30;
    while (contbloco<>2) and (bloco<>nil) do
     begin
      textcolor (yellow);
      gotoxy(j,i);
      write('ษออออออออออออออออออออออออออออออออออป');
      gotoxy(j,i+1);
      write('บ                                  บ');
      gotoxy(j,i+2);
      write('บ                                  บ');
      gotoxy(j,i+3);
      write('บ                                  บ');
      gotoxy(j,i+4);
      write('บ                                  บ');
      gotoxy(j,i+5);
      write('บ                                  บ');
      gotoxy(j,i+6);
      write('บ                                  บ');
      gotoxy(j,i+7);
      write('บ                                  บ');
      gotoxy(j,i+8);
      write('บ                                  บ');
      gotoxy(j,i+9);
      write('บ                                  บ');
      gotoxy(j,i+10);
      write('ศออออออออออออออออออออออออออออออออออผ');
      gotoxy(j+10,i+1);
      textcolor(green);
      writeln('Conteudo: ');
      textcolor(white);
      if max<>4000 then
      begin
       gotoxy(j+3,i+contlinha);
       write(bloco^.item.bloco);
       contlinha:=contlinha+1;
       max:=max+30;
      end;
      gotoxy(j+2,i+9);
      writeln('nro_bloco: ',bloco^.numbloco);
      bloco := bloco^.proxlru;
      contbloco:= contbloco+1;
      j:=j+40;
      i:=7;
      delay(5000);
    end;
 end;
   gotoxy(40,19);
   textcolor(white);
   write('[Digite algo para terminar    ]');
   gotoxy(69,19);
   readln(ch);
end
  else
   begin
    telainicial;
    textcolor(lightred);
    gotoxy(27,9);
    writeln('Lista LRU esta VAZIA');
    delay(2500);
   end;
end;


procedure shutdown (var buffer:TipoLista;var cont:integer; var disk:TipoDisco; var hash:TipoHash);
var bloco:Apontador;
    i:integer;
    ch:char;
    alteracor:boolean;
begin
  alteracor:=false;
  gotoxy (25,3);
  textcolor(lightgreen);
  writeln ('Programa BUFFER-POOL:SHUTDOWN');
  bloco:= buffer.primeiro;
  if buffer.primeiro<>nil then
  begin
   while bloco<>nil do
    begin
     if bloco^.flag=true then
      begin
       gravadisco(bloco,disk);
      end;
     cont:= cont - 1;
     bloco:= bloco^.proxlru;
     gotoxy (9,9);
     textcolor(white);
     write('Numero do bloco deletado ');
     gotoxy(34,9);
     if alteracor=false then
     begin
      textcolor(lightred);
      alteracor:=true;
     end
     else
      begin
       textcolor(yellow);
       alteracor:=false;
     end;
      gotoxy(35,9);
      delay(1000);
      write('');
      delay(1000);
      gotoxy(36,9);
      write('');
      delay(1000);
      gotoxy(37,9);
      write('');
      delay(1000);
     if cont = 0 then {eh o ultimo bloco}
      begin
        gotoxy(40,9);
        textcolor(white);
        write(buffer.ultimo^.numbloco);
        gotoxy(25,17);
        writeln('TODOS os blocos do Buffer foram deletados!');
        gotoxy(25,19);
        write('[Digite algo para terminar    ]');
        gotoxy(54,19);
        readln(ch);
        dispose(buffer.ultimo);
        buffer.primeiro:=nil;
        buffer.ultimo:=nil;
      end
     else
      begin
        gotoxy(40,9);
        textcolor(white);
        write(bloco^.antlru^.numbloco);
        delay(3000);
        gotoxy(35,9);
        write('          ');
        dispose(bloco^.antlru);
      end;
   end;
   for i:=0 to 9 do
    begin
      hash[i]:= nil;
    end;
  end
  else
   begin
    gotoxy(25,9);
    textcolor(lightred);
    writeln('O Buffer esta VAZIO!');
    gotoxy(25,10);
    delay(2500);
  end;
end;

procedure menu;
begin
    textcolor(white);
    gotoxy(20,18);
    write('Entre com a opcao que deseja  ');
    gotoxy(27,7);
    writeln('1: Iniciar automatico');
    gotoxy(27,8);
    writeln('2: Imprimir lista LRU');
    gotoxy(27,9);
    writeln('3: Imprimir tabela HASH');
    gotoxy(27,10);
    writeln('4: Mostrar movimentacoes');
    gotoxy(27,11);
    writeln('5: Shutdown');
    gotoxy(27,12);
    textcolor(lightblue);
    writeln('6: Sair do programa');
    gotoxy(51,18);
end;

procedure geraauto(var buffer: TipoLista; var hash: Tipohash; var disco: TipoDisco; var contador: integer);
var nroblock, operac: integer;
    oper,altcor: boolean;
    parar:char;

begin
     Randomize;
     altcor:=false;
     repeat
          clrscr;
          telainicial;
          gotoxy (24,3);
          textcolor(lightgreen);
          writeln ('Programa BUFFER-POOL:AUTOMATICO');
          gotoxy(12,9);
          textcolor(white);
          writeln('Numero do bloco gerado');
          nroblock := random(1000);
          if altcor=false then
           begin
            textcolor(lightred);
            altcor:=true;
           end
          else
           begin
            textcolor(yellow);
            altcor:=false;
           end;
          gotoxy(35,9);
          write('');
          textcolor(white);
          gotoxy(39,9);
          writeln(nroblock);
          operac := random(2);
          if operac = 0 then
           begin
               oper := false;
               gotoxy(14,11);
               textcolor(white);
               writeln('Operacao gerada e leitura');
           end
          else
           begin
               oper := true;
               textcolor(white);
               gotoxy(14,11);
               writeln('Operacao gerada e escrita');
           end;
          delay(2500);
          clrscr;
          {insere(nroblock, oper, hash, buffer, contador, disco);}
          gotoxy(15,17);
          textcolor(white);
          writeln('Digite algo para parar ');
          gotoxy(40,17);
          read(parar);
     until (parar='p');
end;

procedure movimentacoes(var buffer:TipoLista;var hash:TipoHash;var cont:integer; var disk:TipoDisco);
var numblock:integer;
    op: char;
    operation:boolean;
begin
 numblock:=-2;
 while numblock<>-1 do
 begin
  clrscr;
  telainicial;
  gotoxy (24,3);
  textcolor(lightgreen);
  writeln ('Programa BUFFER-POOL:MOVIMENTACAO');
  textcolor(white);
  gotoxy(10,8);
  writeln('Digite um numero para o bloco [0..999] ou -1 para terminar  ');
  gotoxy(10,11);
  writeln('Digite a operacao [r]ead ou [w]rite');
  gotoxy(10,8);
  delay(1000);
 repeat
  gotoxy(71,8);
  write('       ');
  gotoxy(10,8);
  textcolor(yellow);
  writeln('Digite um numero para o bloco [0..999] ou -1 para terminar  ');
  textcolor(white);
  gotoxy(71,8);
  read(numblock);
 until((numblock >= 0) and (numblock <= 999)) or (numblock=-1);
  if numblock <> -1 then
  begin
   repeat
    gotoxy(48,11);
    write('       ');
    gotoxy(10,11);
    textcolor(yellow);
    writeln('Digite a operacao [r]ead ou [w]rite ');
    textcolor(white);
    gotoxy(48,11);
    read(op);
   until(op='r') or (op='w');
   if op='r' then
    begin
     operation:= false;
    end
   else if op='w' then
    begin
     operation:= true;
    end;
     clrscr;
     telainicial;
     insere(numblock, operation, hash, buffer, cont, disk);
   end;
 end;
end;

begin {do programa principal}
 window (1,1,80,25);
 inicializadisco(disco);
 inicializahash(hash);
 inicializalista(buffer);
 cont := 0;
 opcao:= 0;
 repeat
       { sound(9);
       delay(1000);
       nosound; }
       begin
       telainicial;
       menu;
       textcolor(white);
       read(opcao);
       case opcao of
            1: begin
                   geraauto(buffer, hash, disco, cont);
               end;
            2: begin
                    imprimelru(buffer);
               end;
            3: begin
                    {falta implementar}
                    {imprimehash(hash, buffer);}
               end;
            4: begin
                    movimentacoes(buffer, hash, cont, disco);
               end;
            5: begin
                    clrscr;
                    telainicial;
                    shutdown(buffer, cont, disco, hash);
               end;
       end;
    end;
 until (opcao=6);
end.
