program wordstats;
uses sysutils;

const
  PATH = 'C:\Users\HugoLaw\Codes\Pascal\';

var
  despath, lastfilename, outfilename, BatchSearch : String;
  returnmode, listlength : Integer;
  readfile, outfile : Text;
  Batch : Boolean;
  Namelist : array[1..50] of String;

procedure DPathChange;
var
  i : Integer;
  temp : String;
  SR : TRawbyteSearchRec;
begin
  repeat
    WriteLn('Please enter the destination path:');
    ReadLn(despath);
  until DirectoryExists(despath);
  despath := IncludeTrailingPathDelimiter(despath);
  for i := 1 to 50 do
    Namelist[i] := '';
  if FindFirst(despath + '*', faAnyFile and (not faDirectory), SR) = 0 then
    begin
      i := 1;
      repeat
        temp := AnsiToUtf8(SR.Name);
        if Copy(temp, Length(temp)-2, 3) = 'txt' then
          begin
            Namelist[i] := temp;
            i := i + 1;
          end;
      until FindNext(SR) <> 0;
      FindClose(SR);
      listlength := i - 1;
    end
  else
    DPathChange;
end;

procedure Print_Heading;
begin
  WriteLn;
  WriteLn('Yb        dP  dP"Yb  88""Yb 8888b.      .dP"Y8 888888    db    888888 .dP"Y8 ');
  WriteLn(' Yb  db  dP  dP   Yb 88__dP  8I  Yb     `Ybo."   88     dPYb     88   `Ybo." ');
  WriteLn('  YbdPYbdP   Yb   dP 88"Yb   8I  dY     o.`Y8b   88    dP__Yb    88   o.`Y8b ');
  WriteLn('   YP  YP     YbodP  88  Yb 8888Y"      8bodP''   88   dP""""Yb   88   8bodP'' ');
  WriteLn;
  WriteLn('Authored by Hugo Law - Version 1.2.2');
  WriteLn;
  returnmode := 3;
  Batch := False;
  lastfilename := '';
  outfilename := '';

  DPathChange;
  WriteLn('You may edit the destination path again in Program Preference');
  WriteLn;
end;

function Select_File(m : Integer;var tfile : Text) : String;
var
  i, ri, error : Integer;
  Reading, filename : String;
begin
  WriteLn('--Select Text File--');
  for i := 1 to listlength do
    begin
      WriteLn(i,'. ',Namelist[i]);
    end;
  WriteLn;
  repeat
    if not(lastfilename = '') then
      WriteLn('You may type ''last'' to refer to previous text file');
    Write('Select a text file by index: ');
    ReadLn(Reading);
    if (not (lastfilename = '')) and (Reading = 'l') then
      begin
        filename := lastfilename;
        error := 0;
        ri := 1;
      end
    else
      Val(Reading, ri, error);
  until (error = 0) and (ri <= i) and (ri >= 1);
  if not (Reading = 'l') then
    begin
      filename := Namelist[ri];
      lastfilename := filename;
    end;
  filename := despath + filename;
  if m < 3 then
    Assign(tfile, filename);
  if m = 1 then
    Reset(tfile);
  if m = 2 then
    Append(tfile);
  Select_File := filename
end;

procedure Print_PList;
var
  Reading : String;
  i, error : Integer;
  tempfile : Text;
begin
  WriteLn('--Program Preference--');
  WriteLn('1. Change Destination Path');
  if Batch then
    begin
      WriteLn('2. Batch Processing Preference');
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
          DPathChange;
        end
      else if i = 2 then
        begin
          WriteLn('Batch Processing Off.');
          Batch := not Batch;
        end;
      WriteLn;
      if not (i = 3) then
        Print_PList;
    end
  else
    begin
      WriteLn('2. Result Return Preference');
      WriteLn('3. Batch Processing Preference');
      WriteLn('4. Quit');
      WriteLn;
      repeat
        Write('Enter your choice: ');
        ReadLn(Reading);
        Val(Reading, i, error)
      until (error = 0) and (i <= 4) and (i >= 1);
      WriteLn;
      if i = 1 then
        begin
          DPathChange;
        end
      else if (i = 2) or (i = 3) then
        begin
          if i = 3 then
            begin
              WriteLn('Batch Processing On.');
              Batch := not Batch;
              WriteLn;
            end;
          WriteLn('--Result Return Preference--');
          WriteLn('1. Always Append Result in Original File');
          WriteLn('2. Always Return Result in New File');
          if not Batch then
            WriteLn('3. Always Ask After Runs');
          WriteLn('4. Never Record Result in Text File');
          WriteLn;
          repeat
            Write('Enter your choice: ');
            ReadLn(Reading);
            Val(Reading, returnmode, error);
            if (Batch) and (returnmode = 3) then
              returnmode := 5;
          until (error = 0) and (returnmode <= 4) and (returnmode >= 1);
          if returnmode = 2 then
            begin
              WriteLn;
              outfilename := Select_File(3, tempfile);
              BatchSearch := '';
            end
          else
            begin
              outfilename := '';
              BatchSearch := '';
            end;
        end;
      WriteLn;
      if not (i = 4) then
        Print_PList;
    end;
end;

function CheckWordFinished(S: String; I : Integer): Boolean;
begin
  CheckWordFinished :=  (S[I] = ' ') or (S[I] = ',') or (S[I] = '.') or (S[I] = '?') or (S[I] = '!')
end;

procedure Word_Count(rfname : String);
var
  wordno, paghno, i, error : Integer;
  temp, ofname, Reading : String;
  duallines, dualdull : Boolean;
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
      if outfilename <> '' then
        begin
          ofname := outfilename;
          Assign(outfile, ofname);
          Append(outfile)
        end
      else
        ofname := Select_File(2, outfile);
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
begin
  wordno := 0;
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
      if outfilename <> '' then
        begin
          ofname := outfilename;
          Assign(outfile, ofname);
          Append(outfile)
        end
      else
        ofname := Select_File(2, outfile);
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
      if outfilename <> '' then
        begin
          ofname := outfilename;
          Assign(outfile, ofname);
          Append(outfile)
        end
      else
        ofname := Select_File(2, outfile);
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
  lc, i, error : Integer;
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
      if Batch then
        begin
          for lc := 1 to listlength do
            begin
              filename := despath + Namelist[lc];
              if not ((returnmode = 2) and (filename = outfilename)) then
                begin
                  WriteLn('File ',lc,' - ',Namelist[lc]);
                  Assign(readfile, filename);
                  Reset(readfile);
                  WriteLn;
                  if i = 1 then
                    Char_Freq(filename);
                  if i = 2 then
                    Word_Count(filename);
                  if i = 3 then
                    Word_Freq(filename);
                  Close(readfile);
                end;
            end;
        end
      else
        begin
          filename := Select_File(1, readfile);
          if not ((returnmode = 2) and (filename = outfilename)) then
            begin
              WriteLn;
              if i = 1 then
                Char_Freq(filename);
              if i = 2 then
                Word_Count(filename);
              if i = 3 then
                Word_Freq(filename);
              Close(readfile);
            end;
        end;
    end;
  if i = 4 then
    Print_PList;
  if not (i = 5) then
    Print_List;
end;

begin
  Print_Heading;
  Print_List;
end.
