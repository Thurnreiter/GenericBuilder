unit Nathan.GB.Core;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Rtti,
  System.TypInfo,
  System.Generics.Collections;

{$M+}

{$METHODINFO ON}

type
  /// <summary>
  ///   This are a class that creates a gernieric builder for all properties from <T>.
  ///   Sample:
  ///   var
  ///     Actual: TMyImpl;
  ///   ...
  ///     Actual := TGenericBuilder<TMyImpl>
  ///       .Create
  ///       .WithProp('AnyName', 'Internal value for properties')
  ///       .WithProp('ThisIsAnInteger', 2810)
  ///       .WithProp('AnyAddionalObject', Stub)
  ///       .Build;
  /// </summary>
  //  TGenericBuilder<T: class, constructor> = record
  TGenericBuilder<T> = record
  private
    FMapVal: TDictionary<string, TValue>;
    FList: TList<TProc<T>>;

    procedure SetProperties(Element: T);
    function CreateInstance(): T;
  public
    /// <summary>
    ///   Only used to initialize the internal TDictionary list.
    /// </summary>

    class function Builder(): TGenericBuilder<T>; static;  // .GetInstance, .New, .Builder


    /// <summary>
    ///   Property filler. Example: .WithProp('AnyPropName', 'Internal string value for properties')
    /// </summary>
    /// <param name="APropName">
    ///   Are the name of property from <T>.
    /// </param>
    /// <param name="APropValue">
    ///   The value for property. Can accept any value corresponding to TValue.
    /// </param>
    function WithProp(const APropName: string; APropValue: TValue): TGenericBuilder<T>; overload;

    /// <summary>
    ///   Property filler Action<T>.
    /// </summary>

    function WithProp(Action: TProc<T>): TGenericBuilder<T>; overload;

    /// <summary>
    ///   Create an fill the corresponding object.
    /// </summary>

    function Build(): T;
  end;

{$M-}

implementation

{ **************************************************************************** }

{ TGenericBuilder<T> }

class function TGenericBuilder<T>.Builder(): TGenericBuilder<T>;
begin
  Result := Default(TGenericBuilder<T>);  //  Init my TDictionary
end;

function TGenericBuilder<T>.WithProp(const APropName: string; APropValue: TValue): TGenericBuilder<T>;
begin
  if (not Assigned(FMapVal)) then
    FMapVal := TDictionary<string, TValue>.Create;

  FMapVal.AddOrSetValue(APropName, APropValue);
  Result := Self;
end;

function TGenericBuilder<T>.WithProp(Action: TProc<T>): TGenericBuilder<T>;
begin
  if (not Assigned(FList)) then
    FList := TList<TProc<T>>.Create;

  FList.Add(Action);
  Result := Self;
end;

function TGenericBuilder<T>.Build: T;
var
  Action: TProc<T>;
begin
  Result := CreateInstance;

  if Assigned(FMapVal) then
    SetProperties(Result);

  if Assigned(FMapVal) then
    FMapVal.Free;

  if Assigned(FList) then
  begin
    for Action in FList do
      Action(Result);

    FList.Free;
  end;

  {$REGION 'Helps for me'}
  //  var
  //    xInValue, xOutValue: TValue;
  //  xInValue := GetTypeData(PTypeInfo(TypeInfo(T)))^.ClassType.Create;
  //  xInValue.TryCast(TypeInfo(T), xOutValue);
  //  Result := xOutValue.AsType<T>;
  //  
  //  v: TValue;
  //  v := TValue.From<T>(Result);
  //  if v.IsObject or v.IsObjectInstance then
  //    Return := v.AsObject.ToString;
  //
  //  RProp := RCtx
  //    .GetType(TypeInfo(T))
  //      .GetProperty('AnyName');
  //
  //  Return := RProp.GetValue(v.AsObject).ToString;
  //  RProp.SetValue(v.AsObject, 'Field 1 is set');
  //  Return := RProp.GetValue(v.AsObject).ToString;
  {$ENDREGION}
end;

procedure TGenericBuilder<T>.SetProperties(Element: T);
var
  Item: TPair<string, TValue>;
  RCtx: TRttiContext;
  RType: TRttiType;
  RProp: TRttiProperty;
  ValProp: TValue;
begin
  RCtx := TRttiContext.Create;
  RType := RCtx.GetType(TypeInfo(T));
  if (not Assigned(RType)) then
    Exit;

  ValProp := TValue.From<T>(Element);
  if (ValProp.IsObject or ValProp.IsObjectInstance) then
  begin
    for Item in FMapVal do
    begin
      RProp := RType.GetProperty(Item.Key);
      if Assigned(RProp) then
        RProp.SetValue(ValProp.AsObject, Item.Value);
    end;
  end;
end;

function TGenericBuilder<T>.CreateInstance(): T;
var
  AValue: TValue;
  RCtx: TRttiContext;
  RType: TRttiType;
  AMethCreate: TRttiMethod;
  AInstanceType: TRttiInstanceType;
begin
  RCtx := TRttiContext.Create;
  RType := RCtx.GetType(TypeInfo(T));
  for AMethCreate in RType.GetMethods do
  begin
    if (AMethCreate.IsConstructor)
    and (Length(AMethCreate.GetParameters) = 0) then
    begin
      AInstanceType := RType.AsInstance;
      AValue := AMethCreate.Invoke(AInstanceType.MetaclassType, []);  //  constructor parameters, here are emtpy []...
      Exit(AValue.AsType<T>);
    end;
  end;
end;

end.
