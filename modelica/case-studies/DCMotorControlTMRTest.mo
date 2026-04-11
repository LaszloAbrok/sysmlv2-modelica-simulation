model DCMotorControlTMRTest
  Modelica.Blocks.Sources.Step reference(height = 100, startTime = 0.1)
   annotation(Placement(transformation(origin = {-86, 58}, extent = {{-10, -10}, {10, 10}})));
  
  Modelica.Blocks.Math.Feedback feedback
   annotation(Placement(transformation(origin = {-60, 58}, extent = {{-10, -10}, {10, 10}})));
  
  Modelica.Blocks.Continuous.PID controller(Td = 0.1, k = 3.0, Ti = 0.05)
   annotation(Placement(transformation(origin = {-34, 58}, extent = {{-10, -10}, {10, 10}})));
  
  Modelica.Electrical.Analog.Sources.SignalVoltage amplifier
   annotation(Placement(transformation(origin = {2, 58}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
   
  Modelica.Electrical.Analog.Basic.Resistor R(R = 1)
   annotation(Placement(transformation(origin = {26, 48}, extent = {{-10, -10}, {10, 10}})));
   
  Modelica.Electrical.Analog.Basic.Inductor L(L = 0.01)
   annotation(Placement(transformation(origin = {60, 48}, extent = {{-10, -10}, {10, 10}})));
   
  Modelica.Electrical.Analog.Basic.RotationalEMF emf(k = 0.1)
   annotation(Placement(transformation(origin = {70, 78}, extent = {{-10, -10}, {10, 10}})));
   
  Modelica.Electrical.Analog.Basic.Ground ground
   annotation(Placement(transformation(origin = {2, 30}, extent = {{-10, -10}, {10, 10}})));
   
  Modelica.Mechanics.Rotational.Components.Inertia load(J = 0.05)
   annotation(Placement(transformation(origin = {90, -2}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
   
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor truthSensor
   annotation(Placement(transformation(origin = {52, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(transformation(origin = {-50, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Math.Add add3 annotation(
    Placement(transformation(origin = {-50, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Math.Add add2 annotation(
    Placement(transformation(origin = {-50, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant const(k = 0)  annotation(
    Placement(transformation(origin = {34, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant const1(k = 300)  annotation(
    Placement(transformation(origin = {18, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Sine sine(amplitude = 50)  annotation(
    Placement(transformation(origin = {0, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Voter voter annotation(
    Placement(transformation(origin = {-94, -10}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(reference.y, feedback.u1) annotation(
    Line(points = {{-75, 58}, {-68, 58}}, color = {0, 0, 127}));
  connect(feedback.y, controller.u) annotation(
    Line(points = {{-51, 58}, {-46, 58}}, color = {0, 0, 127}));
  connect(controller.y, amplifier.v) annotation(
    Line(points = {{-23, 58}, {-10, 58}}, color = {0, 0, 127}));
  connect(amplifier.p, R.p) annotation(
    Line(points = {{2, 48}, {16, 48}}, color = {0, 0, 255}));
  connect(R.n, L.p) annotation(
    Line(points = {{36, 48}, {50, 48}}, color = {0, 0, 255}));
  connect(L.n, emf.p) annotation(
    Line(points = {{70, 48}, {70, 88}}, color = {0, 0, 255}));
  connect(emf.n, amplifier.n) annotation(
    Line(points = {{70, 68}, {2, 68}}, color = {0, 0, 255}));
  connect(truthSensor.flange, load.flange_b) annotation(
    Line(points = {{62, -12}, {90, -12}}));
  connect(amplifier.n, ground.p) annotation(
    Line(points = {{2, 68}, {2, 40}}, color = {0, 0, 255}));
  connect(load.flange_a, emf.flange) annotation(
    Line(points = {{90, 8}, {90, 78.5}, {80, 78.5}, {80, 78}}));
  connect(truthSensor.w, add2.u2) annotation(
    Line(points = {{41, -12}, {-18.75, -12}, {-18.75, -4}, {-38, -4}}, color = {0, 0, 127}));
  connect(add3.u2, truthSensor.w) annotation(
    Line(points = {{-38, -30}, {-10, -30}, {-10, -12}, {41, -12}}, color = {0, 0, 127}));
  connect(add1.u1, truthSensor.w) annotation(
    Line(points = {{-38, 10}, {-9.5, 10}, {-9.5, -12}, {41, -12}}, color = {0, 0, 127}));
  connect(add3.u1, sine.y) annotation(
    Line(points = {{-38, -42}, {0, -42}, {0, -59}}, color = {0, 0, 127}));
  connect(const1.y, add2.u1) annotation(
    Line(points = {{8, -30}, {0, -30}, {0, -16}, {-38, -16}}, color = {0, 0, 127}));
  connect(const.y, add1.u2) annotation(
    Line(points = {{23, 22}, {-38, 22}}, color = {0, 0, 127}));
  connect(voter.input3, add3.y) annotation(
    Line(points = {{-86, -18}, {-80, -18}, {-80, -36}, {-60, -36}}, color = {0, 0, 127}));
  connect(add2.y, voter.input2) annotation(
    Line(points = {{-60, -10}, {-86, -10}}, color = {0, 0, 127}));
  connect(voter.input1, add1.y) annotation(
    Line(points = {{-86, -2}, {-80, -2}, {-80, 16}, {-60, 16}}, color = {0, 0, 127}));
  connect(voter.y, feedback.u2) annotation(
    Line(points = {{-102, -10}, {-124, -10}, {-124, 34}, {-60, 34}, {-60, 50}}, color = {0, 0, 127}));
  annotation(
    uses(Modelica(version = "4.0.0")));
end DCMotorControlTMRTest;