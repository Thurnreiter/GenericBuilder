unit GB.Core.Tests;

interface

uses
  DUnitX.TestFramework;

type

  [TestFixture]
  TMyTestObject = class(TObject)
  public
    [Setup]
    procedure Setup;

    [TearDown]
    procedure TearDown;

    [Test]
    procedure Test_HasCreatedObjectByBuild();

    [Test]
    procedure Test_HasCreatedObjectByBuild_WithoutMemoryLeaks();

    [Test]
    procedure Test_HasDummyObject_PropSet();

    [Test]
    procedure Test_HasDummyObject_PropSet_SameTwice();

    [Test]
    procedure Test_HasDummyObject_PropSet_WithObject();

    [Test]
    procedure Test_HasDummyObject_PropSet_WithProp3();

    [Test]
    procedure Test_HasCreatedInterfaceByBuild();

    [Test]
    procedure Test_HasDummyInterface_PropSet_WithObject();

    [Test]
    procedure Test_HasDummyObject_CreateWithAtgumentNil();

    [Test]
    procedure Test_HasDummyObject_OverClassOperator_WithJson();

    [Test]
    procedure Test_HasDummyObject_OverClassOperator_WithJson_Direct();
  end;

implementation

uses
//REST.JSON,
//System.JSON,
//System.JSON.Serializers,
  Nathan.GB.Core,
  Test.DummyClass;

procedure TMyTestObject.Setup;
begin
end;

procedure TMyTestObject.TearDown;
begin
end;

procedure TMyTestObject.Test_HasCreatedObjectByBuild;
var
  Actual: TMyInterfaceImpl;
begin
  Actual := TGenericBuilder<TMyInterfaceImpl>
    .Builder
    .WithProp('AnyName', '4711')
    .Build;
  try
    Assert.IsNotNull(Actual);
    Assert.AreEqual('4711', Actual.AnyName);
  finally
    Actual.Free;
  end;
end;

procedure TMyTestObject.Test_HasCreatedObjectByBuild_WithoutMemoryLeaks;
var
  Actual: TMyInterfaceImpl;
begin
  Actual := TGenericBuilder<TMyInterfaceImpl>.Builder.Build;
  try
    Assert.IsNotNull(Actual);
  finally
    Actual.Free;
  end;
end;

procedure TMyTestObject.Test_HasDummyObject_PropSet;
var
  Actual: TMyInterfaceImpl;
begin
  Actual := TGenericBuilder<TMyInterfaceImpl>
    .Builder
    .WithProp('AnyName', 'Internal value for properties')
    .WithProp('ThisIsAnInteger', 2810)
    .Build;
  try
    Assert.IsNotNull(Actual);
    Assert.AreEqual('Internal value for properties', Actual.AnyName);
    Assert.AreEqual(2810, Actual.ThisIsAnInteger);
  finally
    Actual.Free;
  end;
end;

procedure TMyTestObject.Test_HasDummyObject_PropSet_SameTwice;
begin
  Assert.WillNotRaise(
    procedure
    var
      Actual: TMyInterfaceImpl;
    begin
      Actual := TGenericBuilder<TMyInterfaceImpl>
        .Builder
        .WithProp('AnyName', 'Internal value for properties')
        .WithProp('ThisIsAnInteger', 2810)
        .WithProp('ThisIsAnInteger', 2812)
        .Build;
      Assert.AreEqual(2812, Actual.ThisIsAnInteger);
      Actual.Free;
    end);
end;

procedure TMyTestObject.Test_HasDummyObject_PropSet_WithObject;
var
  Stub: TObject;
  Actual: TMyInterfaceImpl;
begin
  Stub := TObject.Create;

  Actual := TGenericBuilder<TMyInterfaceImpl>
    .Builder
    .WithProp('AnyName', 'Internal value for properties')
    .WithProp('ThisIsAnInteger', 2810)
    .WithProp('AnyAddionalObject', Stub)
    .Build;
  try
    Assert.IsNotNull(Actual);
    Assert.AreEqual('Internal value for properties', Actual.AnyName);
    Assert.AreEqual(2810, Actual.ThisIsAnInteger);
    Assert.AreSame(Stub, Actual.AnyAddionalObject);
  finally
    Stub.Free;
    Actual.Free;
  end;
end;

procedure TMyTestObject.Test_HasDummyObject_PropSet_WithProp3;
{$J+}
const
  C: Integer = 0;
begin
  Inc(C);
  Inc(C);
  Assert.WillNotRaise(
    procedure
    var
      Actual: TMyInterfaceImpl;
    begin
      Actual := TGenericBuilder<TMyInterfaceImpl>
        .Builder
        .WithProp('AnyName', 'Internal value for properties')
        .WithProp('ThisIsAnInteger', 2810)
        .WithProp(
          procedure(Instance: TMyInterfaceImpl)
          begin
            Instance.ThisIsAnInteger := 2812
          end)
        .Build;
      Assert.AreEqual(2812, Actual.ThisIsAnInteger);
      Assert.AreEqual('Internal value for properties', Actual.AnyName);
      Actual.Free;
    end);
  Inc(C);
  Assert.AreEqual(3, C);
end;

procedure TMyTestObject.Test_HasCreatedInterfaceByBuild;
var
  Actual: IMyInterface;
begin
  Actual := TGenericBuilder<IMyInterface>
    .Builder
    .WithProp('AnyName', '4711')
    .Build;
  try
    Assert.IsNull(Actual);
  finally
    Actual := nil;
  end;
end;

procedure TMyTestObject.Test_HasDummyInterface_PropSet_WithObject;
var
  Stub: TObject;
  Actual: IMyInterface;
begin
  Stub := TObject.Create;

  Actual := TGenericBuilder<IMyInterface>
    .Builder
    .WithProp('AnyName', 'Internal value for properties')
    .WithProp('ThisIsAnInteger', 2810)
    .WithProp('AnyAddionalObject', Stub)
    .Build;
  try
    Assert.IsNull(Actual);
  finally
    Stub.Free;
    Actual := nil;;
  end;
end;

procedure TMyTestObject.Test_HasDummyObject_CreateWithAtgumentNil;
var
  Actual: TMyInterfaceImpl;
begin
  Actual := TGenericBuilder<TMyInterfaceImpl>
    .Builder
    .Build(['Internal value for properties']);
  try
    Assert.IsNotNull(Actual);
    Assert.AreEqual('Internal value for properties', Actual.AnyName);
  finally
    Actual.Free;
  end;
end;

procedure TMyTestObject.Test_HasDummyObject_OverClassOperator_WithJson;
var
  Cut: TGenericBuilder<TMyInterfaceImpl>;
  Actual: TMyInterfaceImpl;
begin
  // '{"internal":"Internal value for properties","internalInt":2810,"internalObj":null}'
  //    my := TJson.ObjectToJsonString(Actual);
  //    Actual := TJson.JsonToObject<TMyInterfaceImpl>('{"internal":"Internal value for properties","internalInt":2810,"internalObj":null}');

  //  Cut := '{"FInternal":"Internal value for properties","FInternalInt":2811,"FInternalObj":null,"FRefCount":0}';
  Cut := '{"Internal":"Internal value for properties","InternalInt":2811,"InternalObj":null}';
  Actual := Cut.Build;
  try
    Assert.IsNotNull(Actual);
    Assert.AreEqual(2811, Actual.ThisIsAnInteger);
    Assert.AreEqual('Internal value for properties', Actual.AnyName);
    Assert.IsNull(Actual.AnyAddionalObject);
  finally
    Actual.Free;
  end;
end;

procedure TMyTestObject.Test_HasDummyObject_OverClassOperator_WithJson_Direct;
var
  Actual: TMyInterfaceImpl;
begin
  Actual := TGenericBuilder<TMyInterfaceImpl>('{"Internal":"Internal value for properties","InternalInt":2811,"InternalObj":null}').Build;
  try
    Assert.IsNotNull(Actual);
    Assert.AreEqual(2811, Actual.ThisIsAnInteger);
    Assert.AreEqual('Internal value for properties', Actual.AnyName);
    Assert.IsNull(Actual.AnyAddionalObject);
  finally
    Actual.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TMyTestObject);
end.
