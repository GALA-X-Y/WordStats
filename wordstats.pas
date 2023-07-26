program sba;
uses Dos;

const
  PATH = 'C:\Users\HugoLaw\Codes\Pascal\';

var
  despath : String;
  setfile : Text;

procedure ReadSettingFile

procedure UpSettingFile;
begin
  Assign(setfile, PATH+'log_hw'+hwnum+'.txt');
  Rewrite(outfile)
end;


procedure Print_Heading;
var
  Hour, Min, Sec, HSec : word;
begin
  GetTime(Hour, Min, Sec, HSec);
  if (Hour <= 4) or (Hour >= 21) then
    Write('Good Night! ')
  else
    if (Hour >= 5) and (Hour <= 11) then
      Write('Good Morning! ')
    else
      if (Hour >= 12) and (Hour <= 17) then
        Write('Good Afternoon! ')
      else
        Write('Good Evening! ');
  WriteLn('Welcome to Composition Analyzer Version 1.0.0');
  WriteLn;
  despath = PATH;
  WriteLn('Please ensure that text files are in following path:');
  WriteLn(despath);
  WriteLn('You may edit the destination path in Program Preference');
  WriteLn;
end;

procedure Action_Perform(num : Integer);
begin
  if num = 3 then
    Print_PList;
end;

procedure Print_List;
var
  Reading : String;
  i, error : Integer;
begin
  WriteLn('--Program Menu--');
  WriteLn('1. Check Frequencies of Letters');
  WriteLn('2. Total Number of Words and Paragraphs');
  WriteLn('3. Program Preference');
  WriteLn('4. Quit');
  WriteLn;
  repeat
    Write('Enter your choice: ');
    ReadLn(Reading);
    Val(Reading, i, error)
  until (error = 0) and (i <= 4) and (i >= 1);
  WriteLn;
  Action_Perform(i)
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
  if i = 3 then
    Print_List;
  if i = 1 then
    begin
      WriteLn('Please enter the destination path:');
      ReadLn(despath);
      WriteLn('P.S. : The path is only available in this run.');
      WriteLn('       Please edit constant variable PATH to make sure it works every run.');
      WriteLn;
      Print_PList;
    end
  else
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
        Val(Reading, i, error)
      until (error = 0) and (i <= 4) and (i >= 1);
    end;
end;

procedure End_Enter;
begin
  WriteLn;
  Write('--Press Enter to continue--');
  ReadLn;
end;

begin

end.
