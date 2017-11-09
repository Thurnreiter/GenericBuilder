# GenericBuilder
Generic Builder Pattern

I am trying to implement a generic builder pattern in Delphi.
The problem started when I tried to write a Builder pattern for TForm or similar classes.
In Delphi is there a lot of typing. Developed with Delphi Toyko 10.2
The template for this was the procedure in Java and C#.

#### Sample
```delphi
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
```

You have 2 options  to fill a property. The first one gets the property name and his value. The second gets only a delegate. Both have the same effect. It is importend that the first property call are ".Builder". It initializes the Builder. The method ".Build" create the Object and fill it.
