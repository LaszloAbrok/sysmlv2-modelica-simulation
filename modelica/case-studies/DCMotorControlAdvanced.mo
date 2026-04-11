model DCMotorControlAdvanced
  Modelica.Electrical.Analog.Sources.SignalVoltage amplifier
   annotation(Placement(transformation(origin = {10, 82}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
   
  Modelica.Electrical.Analog.Basic.RotationalEMF emf(k = 0.1)
   annotation(Placement(transformation(origin = {122, 82}, extent = {{-10, 10}, {10, -10}})));
   
  Modelica.Electrical.Analog.Basic.Ground ground
   annotation(Placement(transformation(origin = {10, 122}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
   
  Modelica.Mechanics.Rotational.Components.Inertia load(J = 0.05)
   annotation(Placement(transformation(origin = {132, -2}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
   
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor true_sensor
   annotation(Placement(transformation(origin = {52, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(transformation(origin = {-194, 30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Add add3 annotation(
    Placement(transformation(origin = {-50, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Math.Add add2 annotation(
    Placement(transformation(origin = {-50, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Voter voter annotation(
    Placement(transformation(origin = {-226, -4}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Basic.VariableResistor variable_resistor(useHeatPort = false)  annotation(
    Placement(transformation(origin = {40, 72}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Electrical.Analog.Basic.VariableInductor inductor annotation(
    Placement(transformation(origin = {78, 72}, extent = {{10, -10}, {-10, 10}}, rotation = -180)));
  Modelica.Blocks.Interfaces.RealInput sensor_failure_injection_1 annotation(
    Placement(transformation(origin = {-201, 69}, extent = {{7, -7}, {-7, 7}}, rotation = 90), iconTransformation(origin = {-80, 80}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput sensor_failure_injection_2 annotation(
    Placement(transformation(origin = {21, -25}, extent = {{7, -7}, {-7, 7}}), iconTransformation(origin = {0, 80}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput sensor_failure_injection_3 annotation(
    Placement(transformation(origin = {43, -37}, extent = {{7, -7}, {-7, 7}}), iconTransformation(origin = {80, 80}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput resistor_failure_injection annotation(
    Placement(transformation(origin = {-49, 51}, extent = {{-7, -7}, {7, 7}}), iconTransformation(origin = {-80, -80}, extent = {{20, -20}, {-20, 20}}, rotation = 270)));
  Modelica.Blocks.Interfaces.RealInput inductor_failure_injection annotation(
    Placement(transformation(origin = {19, 15}, extent = {{7, -7}, {-7, 7}}, rotation = 180), iconTransformation(origin = {80, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
  Modelica.Blocks.Sources.Ramp reference(height = 100, duration = 0.3, offset = 0, startTime = 0.1)  annotation(
    Placement(transformation(origin = {-270, 82}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.LimPID PID(k = 5.0, Ti = 0.05, Td = 0.1, yMax = 1000, yMin = -1000)  annotation(
    Placement(transformation(origin = {-234, 82}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.Limiter resistor_limiter(uMax = 100, uMin = 0.1)  annotation(
    Placement(transformation(origin = {-10, 52}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.Limiter inductor_limiter(uMax = 1.0, uMin = 0.001) annotation(
    Placement(transformation(origin = {58, 16}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput stuck_value_1 annotation(
    Placement(transformation(origin = {-77, 33}, extent = {{7, -7}, {-7, 7}}), iconTransformation(origin = {80, -22}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(transformation(origin = {-146, 26}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold(threshold = 0.5)  annotation(
    Placement(transformation(origin = {-108, 58}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput stuck_value_trigger_1 annotation(
    Placement(transformation(origin = {-65, 71}, extent = {{7, -7}, {-7, 7}}), iconTransformation(origin = {88, 12}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
equation
  connect(true_sensor.flange, load.flange_b) annotation(
    Line(points = {{62, -12}, {132, -12}}));
  connect(true_sensor.w, add2.u2) annotation(
    Line(points = {{41, -12}, {-18.75, -12}, {-18.75, -4}, {-38, -4}}, color = {0, 0, 127}));
  connect(add3.u2, true_sensor.w) annotation(
    Line(points = {{-38, -30}, {-10, -30}, {-10, -12}, {41, -12}}, color = {0, 0, 127}));
  connect(add2.y, voter.input2) annotation(
    Line(points = {{-61, -10}, {-76.5, -10}, {-76.5, -4}, {-218, -4}}, color = {0, 0, 127}));
  connect(add3.y, voter.input3) annotation(
    Line(points = {{-61, -36}, {-71, -36}, {-71, -12}, {-218, -12}}, color = {0, 0, 127}));
  connect(variable_resistor.p, amplifier.p) annotation(
    Line(points = {{30, 72}, {10, 72}}, color = {0, 0, 255}));
  connect(variable_resistor.n, inductor.p) annotation(
    Line(points = {{50, 72}, {68, 72}}, color = {0, 0, 255}));
  connect(emf.flange, load.flange_a) annotation(
    Line(points = {{132, 82}, {132, 8}}));
  connect(sensor_failure_injection_2, add2.u1) annotation(
    Line(points = {{21, -25}, {-38, -25}, {-38, -16}}, color = {0, 0, 127}));
  connect(sensor_failure_injection_3, add3.u1) annotation(
    Line(points = {{43, -37}, {-12, -37}, {-12, -42}, {-38, -42}}, color = {0, 0, 127}));
  connect(inductor.n, emf.p) annotation(
    Line(points = {{88, 72}, {122, 72}}, color = {0, 0, 255}));
  connect(ground.p, amplifier.n) annotation(
    Line(points = {{10, 112}, {10, 92}}, color = {0, 0, 255}));
  connect(amplifier.n, emf.n) annotation(
    Line(points = {{10, 92}, {122, 92}}, color = {0, 0, 255}));
  connect(PID.y, amplifier.v) annotation(
    Line(points = {{-223, 82}, {-2, 82}}, color = {0, 0, 127}));
  connect(reference.y, PID.u_s) annotation(
    Line(points = {{-259, 82}, {-246, 82}}, color = {0, 0, 127}));
  connect(inductor_limiter.y, inductor.L) annotation(
    Line(points = {{69, 16}, {69, 60}, {78, 60}}, color = {0, 0, 127}));
  connect(inductor_failure_injection, inductor_limiter.u) annotation(
    Line(points = {{19, 15}, {33, 15}, {33, 16}, {46, 16}}, color = {0, 0, 127}));
  connect(resistor_failure_injection, resistor_limiter.u) annotation(
    Line(points = {{-49, 51}, {-22, 51}, {-22, 52}}, color = {0, 0, 127}));
  connect(resistor_limiter.y, variable_resistor.R) annotation(
    Line(points = {{2, 52}, {40, 52}, {40, 60}}, color = {0, 0, 127}));
  connect(voter.y, PID.u_m) annotation(
    Line(points = {{-234, -4}, {-234, 70}}, color = {0, 0, 127}));
  connect(greaterThreshold.y, switch1.u2) annotation(
    Line(points = {{-119, 58}, {-126, 58}, {-126, 26}, {-134, 26}}, color = {255, 0, 255}));
  connect(stuck_value_1, switch1.u1) annotation(
    Line(points = {{-77, 33}, {-134, 33}, {-134, 34}}, color = {0, 0, 127}));
  connect(true_sensor.w, switch1.u3) annotation(
    Line(points = {{42, -12}, {-8, -12}, {-8, 18}, {-134, 18}}, color = {0, 0, 127}));
  connect(sensor_failure_injection_1, add1.u2) annotation(
    Line(points = {{-201, 69}, {-200, 69}, {-200, 42}}, color = {0, 0, 127}));
  connect(switch1.y, add1.u1) annotation(
    Line(points = {{-156, 26}, {-164, 26}, {-164, 66}, {-188, 66}, {-188, 42}}, color = {0, 0, 127}));
  connect(add1.y, voter.input1) annotation(
    Line(points = {{-194, 20}, {-194, 4}, {-218, 4}}, color = {0, 0, 127}));
  connect(stuck_value_trigger_1, greaterThreshold.u) annotation(
    Line(points = {{-65, 71}, {-86, 71}, {-86, 58}, {-96, 58}}, color = {0, 0, 127}));
  annotation(
    uses(Modelica(version = "4.0.0")),
  Diagram(graphics),
  Icon(graphics = {Text(origin = {-62, 45}, rotation = -90, extent = {{-32, 27}, {32, -27}}, textString = "Sensor 1", textStyle = {TextStyle.Bold}), Rectangle(lineColor = {145, 65, 172}, fillColor = {97, 53, 131}, lineThickness = 2, extent = {{-100, -100}, {100, 100}}), Text(origin = {92, 45}, rotation = -90, extent = {{-32, 27}, {32, -27}}, textString = "Sensor 3", textStyle = {TextStyle.Bold}), Text(origin = {18, 45}, rotation = -90, extent = {{-32, 27}, {32, -27}}, textString = "Sensor 2", textStyle = {TextStyle.Bold}), Text(origin = {-50, -65}, rotation = 90, extent = {{-32, 27}, {32, -27}}, textString = "Resistor", textStyle = {TextStyle.Bold}), Text(origin = {54, -67}, rotation = 90, extent = {{-32, 27}, {32, -27}}, textString = "Inductor", textStyle = {TextStyle.Bold})}));
end DCMotorControlAdvanced;