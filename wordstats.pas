program wordstats;
uses sysutils;

var
  despath, lastfilename : String;
  returnmode : Integer;
  readfile, outfile : Text;

procedure Print_Heading;
begin
  WriteLn;
  WriteLn('Yb        dP  dP"Yb  88""Yb 8888b.      .dP"Y8 888888    db    888888 .dP"Y8 ');
  WriteLn(' Yb  db  dP  dP   Yb 88__dP  8I  Yb     `Ybo."   88     dPYb     88   `Ybo." ');
  WriteLn('  YbdPYbdP   Yb   dP 88"Yb   8I  dY     o.`Y8b   88    dP__Yb    88   o.`Y8b ');
  WriteLn('   YP  YP     YbodP  88  Yb 8888Y"      8bodP''   88   dP""""Yb   88   8bodP'' ');
  WriteLn;
  WriteLn('Authored by Hugo Law - Version 1.1.5');
  WriteLn;
  returnmode := 3;
  repeat
    WriteLn('Please enter the destination path:');
    ReadLn(despath);
  until DirectoryExists(despath);
  if despath[Length(despath)-1] <> '\' then
    despath := despath + '\';
  WriteLn('You may edit the destination path again in Program Preference');
  WriteLn;
end;

procedure Print_PList;
var
  Reading : String;
  i, error : Integer;
begin
  WriteLn('--Program Preference--');
  WriteLn('1. Change Destination Path');
  WriteLn('2. Result Return Preference');
  WriteLn('3. Quit');
  WriteLn;
  repeat
    Write('Enter your choice: ');
    ReadLn(Reading);
    Val(Reading, i, error)
  until (error = 0) and (i <= 3) and (i >= 1);
  WriteLn;
  if i = 1 then
    begin
      repeat
        WriteLn('Please enter the destination path:');
        ReadLn(despath);
      until DirectoryExists(despath);
      if despath[Length(despath)-1] <> '\' then
        despath := despath + '\';
    end
  else if i = 2 then
    begin
      WriteLn('--Result Return Preference--');
      WriteLn('1. Always Append Result in Original File');
      WriteLn('2. Always Return Result in New File');
      WriteLn('3. Always Ask After Runs');
      WriteLn('4. Never Record Result in Text File');
      WriteLn;
      repeat
        Write('Enter your choice: ');
        ReadLn(Reading);
        Val(Reading, returnmode, error)
      until (error = 0) and (returnmode <= 4) and (returnmode >= 1);
    end;
  WriteLn;
  if not (i = 3) then
    Print_PList;
end;

function CheckWordFinished(S: String; I : Integer): Boolean;
begin
  CheckWordFinished :=  (S[I] = ' ') or (S[I] = ',') or (S[I] = '.')
end;

procedure Word_Count(rfname : String);
var
  wordno, paghno, i, error : Integer;
  temp, ofname, Reading : String;
  duallines, dualdull, f : Boolean;
begin
  paghno := 1;
  wordno := 1;
  duallines := False;
  dualdull := False;
  while not Eof(readfile) do
    begin
      ReadLn(readfile, temp);
      if temp = '' then
        begin
          if not dualdull then
            begin
              paghno := paghno + 1;
              dualdull := True;
            end;
          if (not duallines) and (not dualdull) then
            wordno := wordno + 1;
          temp := temp + 'a';
        end
      else if dualdull then
        dualdull := False;
      if (duallines) and (not CheckWordFinished(temp, 1)) then
        wordno := wordno + 1;
      duallines := False;
      for i := 1 to Length(temp) - 1 do
        if CheckWordFinished(temp, i) and (not CheckWordFinished(temp, i+1)) then
            wordno := wordno + 1;
      if CheckWordFinished(temp, Length(temp)) then
        duallines := True;
    end;
  WriteLn('Number of Words: ',wordno);
  WriteLn('Number of Paragraphs: ',paghno);
  WriteLn;
  i := returnmode;
  if i = 3 then
    begin
      WriteLn('--Output Mode--');
      WriteLn('1. Append Result in Original File');
      WriteLn('2. Return Result in New File');
      WriteLn('3. Give Up the Result');
      WriteLn;
      repeat
        Write('Enter your choice: ');
        ReadLn(Reading);
        Val(Reading, i, error)
      until (error = 0) and (i <= 3) and (i >= 1);
      if i = 3 then
        i := 4;
      WriteLn;
    end;
  if i = 1 then
    begin
      Close(readfile);
      Append(readfile);
      WriteLn(readfile);
      WriteLn(readfile, 'Number of Words: ',wordno);
      WriteLn(readfile, 'Number of Paragraphs: ',paghno);
    end
  else if i = 2 then
    begin
      f := True;
      repeat
        if f then
          f := False
        else
          WriteLn('File is not found.');
        Write('Enter the file name : ');
        ReadLn(ofname);
        ofname := despath + ofname;
        Assign(outfile, ofname);
        {$i-}
        Append(outfile);
        {$i+}
      until IOResult = 0;
      WriteLn(outfile, rfname);
      WriteLn(outfile, 'Number of Words: ',wordno);
      WriteLn(outfile, 'Number of Paragraphs: ',paghno);
      WriteLn(outfile);
      Close(outfile);
      WriteLn;
    end;
end;

procedure Word_Freq(rfname : String);
var
  wordno, i, error : Integer;
  temp, ofname, Reading : String;
  f : Boolean;
begin
  Write('Enter the Word/Expression: ');
  ReadLn(Reading);
  while not Eof(readfile) do
    begin
      ReadLn(readfile, temp);
      while Pos(Reading, temp) <> 0 do
        begin
          if CheckWordFinished(temp, (Pos(Reading, temp) + Length(Reading))) then
            wordno := wordno + 1;
          temp := Copy(temp, (Pos(Reading, temp) + Length(Reading)), (Length(temp) - Pos(Reading, temp) - Length(Reading) + 1))
        end;
    end;
  WriteLn;
  WriteLn('Number of "',Reading,'": ', wordno);
  WriteLn;
  i := returnmode;
  if i = 3 then
    begin
      WriteLn('--Output Mode--');
      WriteLn('1. Append Result in Original File');
      WriteLn('2. Return Result in New File');
      WriteLn('3. Give Up the Result');
      WriteLn;
      repeat
        Write('Enter your choice: ');
        ReadLn(Reading);
        Val(Reading, i, error)
      until (error = 0) and (i <= 3) and (i >= 1);
      if i = 3 then
        i := 4;
      WriteLn;
    end;
  if i = 1 then
    begin
      Close(readfile);
      Append(readfile);
      WriteLn(readfile);
      WriteLn(readfile, 'Number of "',Reading,'": ', wordno);
    end
  else if i = 2 then
    begin
      f := True;
      repeat
        if f then
          f := False
        else
          WriteLn('File is not found.');
        Write('Enter the file name : ');
        ReadLn(ofname);
        ofname := despath + ofname;
        Assign(outfile, ofname);
        {$i-}
        Append(outfile);
        {$i+}
      until IOResult = 0;
      WriteLn(outfile, rfname);
      WriteLn(outfile, 'Number of "',Reading,'": ', wordno);
      WriteLn(outfile);
      Close(outfile);
      WriteLn;
    end;
end;

procedure Char_Freq(rfname : String);
var
  Upcase : array[65..90] of Integer;
  Downcase : array[97..122] of Integer;
  Num : array[48..57] of Integer;
  code, i, error, lnc : Integer;
  temp, ofname, Reading : String;
  f : Boolean;
begin
  for i := 48 to 57 do
    Num[i] := 0;
  for i := 65 to 90 do
    Upcase[i] := 0;
  for i := 97 to 122 do
    Downcase[i] := 0;
  while not Eof(readfile) do
    begin
      ReadLn(readfile, temp);
      for i := 1 to Length(temp) do
        begin
          code := Ord(temp[i]);
          case code of
            48..57 : Num[code] := Num[code] + 1;
            65..90 : Upcase[code] := Upcase[code] + 1;
            97..122 : Downcase[code] := Downcase[code] + 1;
          end;
        end;
    end;
  lnc := 1;
  for i := 48 to 57 do
    if Num[i] <> 0 then
      begin
        Write('"',Chr(i),'" : ',Num[i]:3);
        if lnc < 3 then
          begin
            lnc := lnc + 1;
            Write(' | ');
          end
        else
          begin
            lnc := 1;
            WriteLn;
          end;
      end;
  for i := 65 to 90 do
    if Upcase[i] <> 0 then
      begin
        Write('"',Chr(i),'" : ',Upcase[i]:3);
        if lnc < 3 then
          begin
            lnc := lnc + 1;
            Write(' | ');
          end
        else
          begin
            lnc := 1;
            WriteLn;
          end;
      end;
  for i := 97 to 122 do
    if Downcase[i] <> 0 then
      begin
        Write('"',Chr(i),'" : ',Downcase[i]:3);
        if lnc < 3 then
          begin
            lnc := lnc + 1;
            Write(' | ');
          end
        else
          begin
            lnc := 1;
            WriteLn;
          end;
      end;
  WriteLn;
  WriteLn;
  i := returnmode;
  if i = 3 then
    begin
      WriteLn('--Output Mode--');
      WriteLn('1. Append Result in Original File');
      WriteLn('2. Return Result in New File');
      WriteLn('3. Give Up the Result');
      WriteLn;
      repeat
        Write('Enter your choice: ');
        ReadLn(Reading);
        Val(Reading, i, error)
      until (error = 0) and (i <= 3) and (i >= 1);
      if i = 3 then
        i := 4;
      WriteLn;
    end;
  if i = 1 then
    begin
      Close(readfile);
      Append(readfile);
      WriteLn(readfile);
      lnc := 1;
      for i := 48 to 57 do
        if Num[i] <> 0 then
          begin
            Write(readfile, '"',Chr(i),'" : ',Num[i]:3);
            if lnc < 3 then
              begin
                lnc := lnc + 1;
                Write(readfile, ' | ');
              end
            else
              begin
                lnc := 1;
                WriteLn(readfile);
              end;
          end;
      for i := 65 to 90 do
        if Upcase[i] <> 0 then
          begin
            Write(readfile, '"',Chr(i),'" : ',Upcase[i]:3);
            if lnc < 3 then
              begin
                lnc := lnc + 1;
                Write(readfile, ' | ');
              end
            else
              begin
                lnc := 1;
                WriteLn(readfile);
              end;
          end;
      for i := 97 to 122 do
        if Downcase[i] <> 0 then
          begin
            Write(readfile, '"',Chr(i),'" : ',Downcase[i]:3);
            if lnc < 3 then
              begin
                lnc := lnc + 1;
                Write(readfile, ' | ');
              end
            else
              begin
                lnc := 1;
                WriteLn(readfile);
              end;
          end;
    end
  else if i = 2 then
    begin
      f := True;
      repeat
        if f then
          f := False
        else
          WriteLn('File is not found.');
        Write('Enter the file name : ');
        ReadLn(ofname);
        ofname := despath + ofname;
        Assign(outfile, ofname);
        {$i-}
        Append(outfile);
        {$i+}
      until IOResult = 0;
      WriteLn(outfile, rfname);
      lnc := 1;
      for i := 48 to 57 do
        if Num[i] <> 0 then
          begin
            Write(outfile, '"',Chr(i),'" : ',Num[i]:3);
            if lnc < 3 then
              begin
                lnc := lnc + 1;
                Write(outfile, ' | ');
              end
            else
              begin
                lnc := 1;
                WriteLn(outfile);
              end;
          end;
      for i := 65 to 90 do
        if Upcase[i] <> 0 then
          begin
            Write(outfile, '"',Chr(i),'" : ',Upcase[i]:3);
            if lnc < 3 then
              begin
                lnc := lnc + 1;
                Write(outfile, ' | ');
              end
            else
              begin
                lnc := 1;
                WriteLn(outfile);
              end;
          end;
      for i := 97 to 122 do
        if Downcase[i] <> 0 then
          begin
            Write(outfile, '"',Chr(i),'" : ',Downcase[i]:3);
            if lnc < 3 then
              begin
                lnc := lnc + 1;
                Write(outfile, ' | ');
              end
            else
              begin
                lnc := 1;
                WriteLn(outfile);
              end;
          end;
      WriteLn(outfile);
      Close(outfile);
      WriteLn;
    end;
end;

procedure Print_List;
var
  Reading, filename : String;
  i, error : Integer;
  f : Boolean;
begin
  WriteLn('--Program Menu--');
  WriteLn('1. Check Frequencies of Letters');
  WriteLn('2. Total Number of Words and Paragraphs');
  WriteLn('3. Check Frequencies of a Given Word/Expression');
  WriteLn('4. Program Preference');
  WriteLn('5. Quit');
  WriteLn;
  repeat
    Write('Enter your choice: ');
    ReadLn(Reading);
    Val(Reading, i, error)
  until (error = 0) and (i <= 5) and (i >= 1);
  WriteLn;
  if i < 4 then
    begin
      f := True;
      repeat
        if f then
          f := False
        else
          WriteLn('File is not found.');
        Write('Enter the file name : ');
        ReadLn(filename);
        if (lastfilename <> '') and (filename = 'last') then
          filename := lastfilename
        else
          lastfilename := filename;
        filename := despath + filename;
        Assign(readfile, filename);
        {$i-}
        Reset(readfile);
        {$i+}
      until IOResult = 0;
      WriteLn;
      if i = 1 then
        Char_Freq(filename);
      if i = 2 then
        Word_Count(filename);
      if i = 3 then
        Word_Freq(filename);
      Close(readfile);
    end;
  if i = 4 then
    Print_PList;
  if not (i = 5) then
    Print_List;
end;

begin
  Print_Heading;
  lastfilename := '';
  Print_List;
end.
