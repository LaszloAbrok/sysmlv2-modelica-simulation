model DCMotorControlBase
  
  Modelica.Blocks.Math.Feedback feedback
   annotation(Placement(transformation(origin = {-60, 20}, extent = {{-10, -10}, {10, 10}})));
  
  Modelica.Blocks.Continuous.PID controller(Td = 0.1, k = 5.0, Ti = 0.05)
   annotation(Placement(transformation(origin = {-34, 20}, extent = {{-10, -10}, {10, 10}})));
  
  Modelica.Electrical.Analog.Sources.SignalVoltage amplifier
   annotation(Placement(transformation(origin = {2, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
   
  Modelica.Electrical.Analog.Basic.Resistor R(R = 1)
   annotation(Placement(transformation(origin = {26, 10}, extent = {{-10, -10}, {10, 10}})));
   
  Modelica.Electrical.Analog.Basic.Inductor L(L = 0.01)
   annotation(Placement(transformation(origin = {60, 10}, extent = {{-10, -10}, {10, 10}})));
   
  Modelica.Electrical.Analog.Basic.RotationalEMF emf(k = 0.1)
   annotation(Placement(transformation(origin = {94, 48}, extent = {{-10, -10}, {10, 10}})));
   
  Modelica.Electrical.Analog.Basic.Ground ground
   annotation(Placement(transformation(origin = {-8, 68}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
   
  Modelica.Mechanics.Rotational.Components.Inertia load(J = 0.05)
   annotation(Placement(transformation(origin = {90, -40}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
   
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor sensor
   annotation(Placement(transformation(origin = {-38, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Ramp ramp(height = 100, duration = 0.3, offset = 0, startTime = 0.1)  annotation(
    Placement(transformation(origin = {-88, 20}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(feedback.y, controller.u) annotation(
    Line(points = {{-51, 20}, {-46, 20}}, color = {0, 0, 127}));
  connect(controller.y, amplifier.v) annotation(
    Line(points = {{-23, 20}, {-10, 20}}, color = {0, 0, 127}));
  connect(amplifier.p, R.p) annotation(
    Line(points = {{2, 10}, {16, 10}}, color = {0, 0, 255}));
  connect(R.n, L.p) annotation(
    Line(points = {{36, 10}, {50, 10}}, color = {0, 0, 255}));
  connect(L.n, emf.p) annotation(
    Line(points = {{70, 10}, {75, 10}, {75, 58}, {94, 58}}, color = {0, 0, 255}));
  connect(emf.n, amplifier.n) annotation(
    Line(points = {{94, 38}, {41, 38}, {41, 30}, {2, 30}}, color = {0, 0, 255}));
  connect(sensor.w, feedback.u2) annotation(
    Line(points = {{-49, -50}, {-60, -50}, {-60, 12}}, color = {0, 0, 127}));
  connect(sensor.flange, load.flange_b) annotation(
    Line(points = {{-28, -50}, {90, -50}}));
  connect(amplifier.n, ground.p) annotation(
    Line(points = {{2, 30}, {2, 68}}, color = {0, 0, 255}));
  connect(load.flange_a, emf.flange) annotation(
    Line(points = {{90, -30}, {90, 6}, {104, 6}, {104, 48}}));
  connect(ramp.y, feedback.u1) annotation(
    Line(points = {{-76, 20}, {-68, 20}}, color = {0, 0, 127}));

annotation(
    uses(Modelica(version = "4.0.0")));
end DCMotorControlBase;