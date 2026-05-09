model StandardComponentMappingGoal
  Modelica.Electrical.Analog.Sources.ConstantVoltage source(V = 10)  annotation(
    Placement(transformation(origin = {-34, -34}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Basic.Resistor resistor(R = 5)  annotation(
    Placement(transformation(origin = {-20, -2}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(transformation(origin = {-8, -44}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(source.p, resistor.p) annotation(
    Line(points = {{-44, -34}, {-44, -2}, {-30, -2}}, color = {0, 0, 255}));
  connect(source.n, ground.p) annotation(
    Line(points = {{-24, -34}, {-8, -34}}, color = {0, 0, 255}));
  connect(ground.p, resistor.n) annotation(
    Line(points = {{-8, -34}, {6, -34}, {6, -2}, {-10, -2}}, color = {0, 0, 255}));

annotation(
    uses(Modelica(version = "4.0.0")));
end StandardComponentMappingGoal;