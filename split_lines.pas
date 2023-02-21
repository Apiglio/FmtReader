unit split_lines;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  base_reader;

type
  TSplitLines = class(TFmtReaderBase)
  private
    FItems:TStringList;
  protected
    function GetValue(key:string):string;
  public
    property Values[key:string]:string read GetValue;
  public
    procedure LoadFromFile(filename:string;split:char);
    procedure SaveToFile(filename:string);
    procedure Print(output_func:TOutputFunc);
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TSplitLines }

function TSplitLines.GetValue(key:string):string;
var index:integer;
begin
  for index:=0 to FItems.Count-1 do begin
    if FItems[index]=key then begin
      result:=TStringUnit(FItems.Objects[index]).Value;
      exit;
    end;
  end;
  result:='';
end;

procedure TSplitLines.LoadFromFile(filename:string;split:char);
var index,poss,len:Integer;
    stmp,key,value:string;
begin
  FItems.LoadFromFile(filename);
  for index:=0 to FItems.Count-1 do begin
    stmp:=FItems[index];
    poss:=pos(split,stmp);
    if poss>=0 then begin
      key:=stmp;
      value:=stmp;
      len:=length(stmp);
      delete(key,poss,len);
      delete(value,1,poss);
      FItems[index]:=key;
      FItems.Objects[index]:=TStringUnit.Create(value);
    end;
  end;
end;

procedure TSplitLines.SaveToFile(filename:string);
begin

end;

procedure TSplitLines.Print(output_func:TOutputFunc);
var index:integer;
begin
  for index:=0 to FItems.Count-1 do begin
    output_func('('+FItems[index]+') = ('+TStringUnit(FItems.Objects[index]).Value+')'+#13#10);
  end;
end;

constructor TSplitLines.Create;
begin
  inherited Create;
  FItems:=TStringList.Create;
end;

destructor TSplitLines.Destroy;
begin
  while FItems.Count>0 do begin
    FItems.Objects[0].Free;
    FItems.Delete(0);
  end;
  FItems.Free;
  inherited Destroy;
end;

end.

