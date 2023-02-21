unit base_reader;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fgl;

type

  generic TDynamicArray<T> = class
  private
    FArray:array of T;
  private
    function CheckRange(index:integer):boolean;
  protected
    function GetItems(index:integer):T;
    procedure SetItems(index:integer;value:T);
  public
    procedure Append(value:T);
    procedure Delete(index:integer);
    procedure Insert(index:integer;value:T);
    procedure Sort;
    procedure Unique;
    function Count:integer;
    property Items[index:integer]:T read GetItems write SetItems;default;
  public
    constructor Create;
    destructor Destroy;
  end;

  TDynIntArray = specialize TDynamicArray<int64>;

  TOutputFunc = procedure(str:string);

  TStringUnit = class
    FValue:string;
  public
    constructor Create(str_value:string);
    property Value:string read FValue write FValue;
  end;

  TFmtReaderBase = class
  public
    //procedure LoadFromFile(filename:string);virtual;abstract;
    //procedure SaveToFile(filename:string);virtual;abstract;
  end;

implementation

{ TDynamicArray }

function TDynamicArray.CheckRange(index:integer):boolean;
var len:integer;
begin
  len:=Length(FArray);
  if (index>=len) or (index<-len) then raise Exception.Create('array index out of range');
end;

function TDynamicArray.GetItems(index:integer):T;
var len:integer;
begin
  len:=Length(FArray);
  CheckRange(index);
  if index<0 then result:=FArray[len+index]
  else result:=FArray[index];
end;

procedure TDynamicArray.SetItems(index:integer;value:T);
var len:integer;
begin
  len:=Length(FArray);
  CheckRange(index);
  if index<0 then FArray[len+index]:=value
  else FArray[index]:=value;
end;

procedure TDynamicArray.Append(value:T);
var len:integer;
begin
  len:=Length(FArray);
  SetLength(FArray,len+1);
  FArray[len]:=value;
end;

procedure TDynamicArray.Delete(index:integer);
var idx,len,size:integer;
    ptr:^T;
begin
  len:=Length(FArray);
  CheckRange(index);
  if index<0 then idx:=len+index else idx:=index;
  size:=len-idx;
  ptr:=@(FArray[0]);
  if size>0 then Move((ptr+idx+1)^,(ptr+idx)^,size*SizeOf(ptr));
  SetLength(FArray,len-1);
end;

procedure TDynamicArray.Insert(index:integer;value:T);
var idx,len,size:integer;
    ptr:^T;
begin
  len:=Length(FArray);
  if index<>len then CheckRange(index);
  SetLength(FArray,len+1);
  if index<0 then idx:=len+index else idx:=index;
  size:=len-idx;
  ptr:=@(FArray[0]);
  if size>0 then Move((ptr+idx)^,(ptr+idx+1)^,size*SizeOf(ptr));
  FArray[idx]:=value;
end;

procedure TDynamicArray.Sort;
var pi,pj,len,min_index:integer;
    min,tmp:T;
begin
  //写一个慢速的临时应付一下
  len:=Length(FArray);
  for pi:=0 to len-2 do begin
    min_index:=pi;
    min:=FArray[pi];
    for pj:=pi+1 to len-1 do begin
      if FArray[pj]<min then begin
        min:=FArray[pj];
        min_index:=pj;
      end;
    end;
    if min_index<>pi then begin
      tmp:=FArray[min_index];
      FArray[min_index]:=FArray[pi];
      FArray[pi]:=tmp;
    end;
  end;
end;

procedure TDynamicArray.Unique;
var index:integer;
begin
  //只在排序后有效
  index:=1;
  while index<Length(FArray) do begin
    if FArray[index]=FArray[index-1] then Delete(index)
    else inc(index);
  end;
end;

function TDynamicArray.Count:integer;
begin
  result:=Length(FArray);
end;

constructor TDynamicArray.Create;
begin
  inherited Create;
  SetLength(FArray,0);
end;

destructor TDynamicArray.Destroy;
begin
  SetLength(FArray,0);
  inherited Destroy;
end;



{ TStringUnit }
constructor TStringUnit.Create(str_value:string);
begin
  inherited Create;
  FValue:=str_value;
end;

end.

