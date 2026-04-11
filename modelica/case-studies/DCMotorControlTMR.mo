model DCMotorControlTMR
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
   annotation(Placement(transformation(origin = {76, 78}, extent = {{-10, -10}, {10, 10}})));
   
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
  Modelica.Blocks.Interfaces.RealInput injection1 annotation(
    Placement(transformation(origin = {-24, 22}, extent = {{-8, -8}, {8, 8}}, rotation = 180), iconTransformation(origin = {-44, -40}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput injection3 annotation(
    Placement(transformation(origin = {-24, -42}, extent = {{-8, -8}, {8, 8}}, rotation = 180), iconTransformation(origin = {4, -42}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput injection2 annotation(
    Placement(transformation(origin = {-24, -16}, extent = {{-8, -8}, {8, 8}}, rotation = 180), iconTransformation(origin = {28, -38}, extent = {{-20, -20}, {20, 20}})));
  Voter voter annotation(
    Placement(transformation(origin = {-88, -10}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(reference.y, feedback.u1)
   annotation(Line(points = {{-75, 58}, {-68, 58}}, color = {0, 0, 127}));
  connect(feedback.y, controller.u) annotation(
    Line(points = {{-51, 58}, {-46, 58}}, color = {0, 0, 127}));
  
  connect(controller.y, amplifier.v)
  annotation(Line(points = {{-23, 58}, {-10, 58}}, color = {0, 0, 127}));
  
  connect(amplifier.p, R.p)
  annotation(Line(points = {{2, 48}, {16, 48}}, color = {0, 0, 255}));
  
  connect(R.n, L.p)
  annotation(Line(points = {{36, 48}, {50, 48}}, color = {0, 0, 255}));
  
  connect(L.n, emf.p)
  annotation(Line(points = {{70, 48}, {70, 67}, {76, 67}, {76, 88}}, color = {0, 0, 255}));
  
  connect(emf.n, amplifier.n)
  annotation(Line(points = {{76, 68}, {2, 68}}, color = {0, 0, 255}));
  connect(truthSensor.flange, load.flange_b) annotation(
    Line(points = {{62, -12}, {90, -12}}));
  connect(amplifier.n, ground.p) annotation(
    Line(points = {{2, 68}, {2, 40}}, color = {0, 0, 255}));
  connect(load.flange_a, emf.flange) annotation(
    Line(points = {{90, 8}, {90, 43}, {86, 43}, {86, 78}}));
  connect(truthSensor.w, add2.u2) annotation(
    Line(points = {{41, -12}, {-18.75, -12}, {-18.75, -4}, {-38, -4}}, color = {0, 0, 127}));
  connect(injection1, add1.u2) annotation(
    Line(points = {{-24, 22}, {-38, 22}}, color = {0, 0, 127}));
  connect(injection2, add2.u1) annotation(
    Line(points = {{-24, -16}, {-38, -16}}, color = {0, 0, 127}));
  connect(injection3, add3.u1) annotation(
    Line(points = {{-24, -42}, {-38, -42}}, color = {0, 0, 127}));
  connect(add3.u2, truthSensor.w) annotation(
    Line(points = {{-38, -30}, {-10, -30}, {-10, -12}, {41, -12}}, color = {0, 0, 127}));
  connect(add1.u1, truthSensor.w) annotation(
    Line(points = {{-38, 10}, {-9.5, 10}, {-9.5, -12}, {41, -12}}, color = {0, 0, 127}));
  connect(add2.y, voter.input2) annotation(
    Line(points = {{-61, -10}, {-80, -10}}, color = {0, 0, 127}));
  connect(add1.y, voter.input1) annotation(
    Line(points = {{-61, 16}, {-71, 16}, {-71, -2}, {-80, -2}}, color = {0, 0, 127}));
  connect(add3.y, voter.input3) annotation(
    Line(points = {{-61, -36}, {-71, -36}, {-71, -18}, {-80, -18}}, color = {0, 0, 127}));
  connect(voter.y, feedback.u2) annotation(
    Line(points = {{-96, -10}, {-128, -10}, {-128, 35}, {-60, 35}, {-60, 50}}, color = {0, 0, 127}));

annotation(
    uses(Modelica(version = "4.0.0")));
end DCMotorControlTMR;