model DCMotorControlAdvancedTest
  DCMotorControlAdvanced dCMotorControlAdvanced annotation(
    Placement(transformation(origin = {-23, 3}, extent = {{-23, -23}, {23, 23}})));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(transformation(origin = {-42, 52}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Blocks.Sources.Constant const2(k = 0) annotation(
    Placement(transformation(origin = {-22, 88}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Blocks.Sources.Constant const3(k = 0) annotation(
    Placement(transformation(origin = {-4, 52}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Blocks.Sources.Constant const4(k = 1) annotation(
    Placement(transformation(origin = {-42, -50}, extent = {{10, -10}, {-10, 10}}, rotation = 270)));
  Modelica.Blocks.Sources.Constant const5(k = 0.01) annotation(
    Placement(transformation(origin = {-4, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
equation
  connect(const.y, dCMotorControlAdvanced.sensor_failure_injection_1) annotation(
    Line(points = {{-42, 41}, {-42, 22}}, color = {0, 0, 127}));
  connect(const2.y, dCMotorControlAdvanced.sensor_failure_injection_2) annotation(
    Line(points = {{-22, 77}, {-22, 22}}, color = {0, 0, 127}));
  connect(const3.y, dCMotorControlAdvanced.sensor_failure_injection_3) annotation(
    Line(points = {{-4, 41}, {-4, 22}}, color = {0, 0, 127}));
  connect(const4.y, dCMotorControlAdvanced.resistor_failure_injection) annotation(
    Line(points = {{-42, -39}, {-42, -16}}, color = {0, 0, 127}));
  connect(const5.y, dCMotorControlAdvanced.inductor_failure_injection) annotation(
    Line(points = {{-4, -39}, {-4, -16}}, color = {0, 0, 127}));
  annotation(
    uses(Modelica(version = "4.0.0")));
end DCMotorControlAdvancedTest;