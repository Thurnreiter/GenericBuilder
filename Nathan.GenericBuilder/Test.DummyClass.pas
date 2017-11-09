unit Test.DummyClass;

interface

{$M+}

//{$RTTI EXPLICIT METHODS([vcPublic, vcProtected, vcPrivate, vcPublished])}

type
  IMyInterface = Interface
    ['{226588F1-1035-4342-AE49-8AB3E5D6D2DA}']
    function GetAnyName(): string;
    procedure SetAnyName(const Value: string);

    function GetHereIAm(): string;
    procedure SetHereIAm(const Value: string);

    function GetThisIsAnInteger(): Integer;
    procedure SetThisIsAnInteger(Value: Integer);

    function GetAnyAddionalObject(): TObject;
    procedure SetAnyAddionalObject(Value: TObject);


    procedure SomePublicProcedureWithString(const Value: string);
    function SomePublicFunction(Value: Integer): Boolean;

    property AnyAddionalObject: TObject read GetAnyAddionalObject write SetAnyAddionalObject;
    property AnyName: string read GetAnyName write SetAnyName;
    property HereIAm: string read GetHereIAm write SetHereIAm;
    property ThisIsAnInteger: Integer read GetThisIsAnInteger write SetThisIsAnInteger;
  end;

  TMyInterfaceImpl = class(TInterfacedObject, IMyInterface)
  strict private
    FInternal: string;
    FInternalInt: Integer;
    FInternalObj: TObject;
  private
    function GetAnyName(): string;
    procedure SetAnyName(const Value: string);

    function GetHereIAm(): string;
    procedure SetHereIAm(const Value: string);

    function GetThisIsAnInteger(): Integer;
    procedure SetThisIsAnInteger(Value: Integer);

    function GetAnyAddionalObject(): TObject;
    procedure SetAnyAddionalObject(Value: TObject);
  public
    procedure SomePublicProcedureWithString(const Value: string);
    function SomePublicFunction(Value: Integer): Boolean;
  published
    property AnyAddionalObject: TObject read GetAnyAddionalObject write SetAnyAddionalObject;
    property AnyName: string read GetAnyName write SetAnyName;
    property HereIAm: string read GetHereIAm write SetHereIAm;
    property ThisIsAnInteger: Integer read GetThisIsAnInteger write SetThisIsAnInteger;
  end;

{$M-}

implementation

uses
  System.SysUtils;

{ TMyInterfaceImpl }

function TMyInterfaceImpl.GetAnyAddionalObject: TObject;
begin
  Result := FInternalObj;
end;

function TMyInterfaceImpl.GetAnyName: string;
begin
  Result := FInternal;
end;

function TMyInterfaceImpl.GetHereIAm: string;
begin
  Result := FInternal;
end;

function TMyInterfaceImpl.GetThisIsAnInteger: Integer;
begin
  Result := FInternalInt;
end;

procedure TMyInterfaceImpl.SetAnyAddionalObject(Value: TObject);
begin
  FInternalObj := Value;
end;

procedure TMyInterfaceImpl.SetAnyName(const Value: string);
begin
  FInternal := Value;
end;

procedure TMyInterfaceImpl.SetHereIAm(const Value: string);
begin
  FInternal := Value;
end;

procedure TMyInterfaceImpl.SetThisIsAnInteger(Value: Integer);
begin
  FInternalInt := Value;
end;

function TMyInterfaceImpl.SomePublicFunction(Value: Integer): Boolean;
begin
  Result := (Value > 0);
end;

procedure TMyInterfaceImpl.SomePublicProcedureWithString(const Value: string);
begin
  FInternal := Value;
end;

end.
