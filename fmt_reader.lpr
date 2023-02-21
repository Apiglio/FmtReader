program fmt_reader;

uses base_reader, split_lines;

var reader:TSplitLines;
    arr:TDynIntArray;
    pi:integer;

procedure debug_output(str:string);
begin
  write(utf8toansi(str));
end;

begin
  {
  reader:=TSplitLines.Create;
  reader.LoadFromFile('info.tmp','=');
  writeln('reader["duration"] = ',reader.Values['duration']);
  reader.Print(@debug_output);
  reader.Free;
  }
  arr:=TDynIntArray.Create;
  arr.Append(2);
  arr.Append(3);
  arr.Append(3);
  arr.Append(4);
  arr.Append(5);
  arr.Append(6);
  arr.Append(2);
  arr.Append(8);
  arr.Append(9);

  arr.Delete(4);
  //arr.Insert(-2,66);
  arr.Sort;
  arr.Unique;

  for pi:=0 to arr.Count-1 do writeln(arr[pi]);

  readln;
end.

