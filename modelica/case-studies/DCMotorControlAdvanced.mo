model DCMotorControlAdvanced
  // A különbségképző (Feedback) blokk hozzáadása a hibajel kiszámításához
  Modelica.Electrical.Analog.Sources.SignalVoltage amplifier
   annotation(Placement(transformation(origin = {10, 82}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
   
  Modelica.Electrical.Analog.Basic.RotationalEMF emf(k = 0.1)
   annotation(Placement(transformation(origin = {122, 82}, extent = {{-10, 10}, {10, -10}})));
   
  Modelica.Electrical.Analog.Basic.Ground ground
   annotation(Placement(transformation(origin = {10, 122}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
   
  Modelica.Mechanics.Rotational.Components.Inertia load(J = 0.05)
   annotation(Placement(transformation(origin = {90, -2}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
   
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor true_sensor
   annotation(Placement(transformation(origin = {52, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(transformation(origin = {-50, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Math.Add add3 annotation(
    Placement(transformation(origin = {-50, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Math.Add add2 annotation(
    Placement(transformation(origin = {-50, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Voter voter annotation(
    Placement(transformation(origin = {-88, -10}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Electrical.Analog.Basic.VariableResistor variable_resistor(useHeatPort = false)  annotation(
    Placement(transformation(origin = {40, 72}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Electrical.Analog.Basic.VariableInductor inductor annotation(
    Placement(transformation(origin = {78, 72}, extent = {{10, -10}, {-10, 10}}, rotation = -180)));
  Modelica.Blocks.Interfaces.RealInput sensor_failure_injection_1 annotation(
    Placement(transformation(origin = {-9, 23}, extent = {{7, -7}, {-7, 7}}), iconTransformation(origin = {-80, 80}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput sensor_failure_injection_2 annotation(
    Placement(transformation(origin = {21, -25}, extent = {{7, -7}, {-7, 7}}), iconTransformation(origin = {0, 80}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput sensor_failure_injection_3 annotation(
    Placement(transformation(origin = {21, -37}, extent = {{7, -7}, {-7, 7}}), iconTransformation(origin = {80, 80}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput resistor_failure_injection annotation(
    Placement(transformation(origin = {-71, 45}, extent = {{-7, -7}, {7, 7}}), iconTransformation(origin = {-80, -80}, extent = {{20, -20}, {-20, 20}}, rotation = 270)));
  Modelica.Blocks.Interfaces.RealInput inductor_failure_injection annotation(
    Placement(transformation(origin = {19, 13}, extent = {{7, -7}, {-7, 7}}, rotation = 180), iconTransformation(origin = {80, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
  Modelica.Blocks.Sources.Ramp reference(height = 100, duration = 0.3, offset = 0, startTime = 0.1)  annotation(
    Placement(transformation(origin = {-150, 82}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.LimPID PID(k = 5.0, Ti = 0.05, Td = 0.1, yMax = 1000, yMin = -1000)  annotation(
    Placement(transformation(origin = {-110, 82}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.Limiter resistor_limiter(uMax = 100, uMin = 0.1)  annotation(
    Placement(transformation(origin = {-22, 52}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.Limiter inductor_limiter(uMax = 1.0, uMin = 0.001) annotation(
    Placement(transformation(origin = {58, 14}, extent = {{-10, -10}, {10, 10}})));
equation
// --- Újragondolt jelfolyam (Szabályozási hurok) ---
// Alapjel megy a Feedback pozitív ágába
// Szenzor megy a Feedback negatív ágába
// Hibajel be a PID-be
  connect(true_sensor.flange, load.flange_b) annotation(
    Line(points = {{62, -12}, {90, -12}}));
  connect(true_sensor.w, add2.u2) annotation(
    Line(points = {{41, -12}, {-18.75, -12}, {-18.75, -4}, {-38, -4}}, color = {0, 0, 127}));
  connect(add3.u2, true_sensor.w) annotation(
    Line(points = {{-38, -30}, {-10, -30}, {-10, -12}, {41, -12}}, color = {0, 0, 127}));
  connect(add2.y, voter.input2) annotation(
    Line(points = {{-61, -10}, {-80, -10}}, color = {0, 0, 127}));
  connect(add1.y, voter.input1) annotation(
    Line(points = {{-61, 16}, {-71, 16}, {-71, -2}, {-80, -2}}, color = {0, 0, 127}));
  connect(add3.y, voter.input3) annotation(
    Line(points = {{-61, -36}, {-71, -36}, {-71, -18}, {-80, -18}}, color = {0, 0, 127}));
  connect(variable_resistor.p, amplifier.p) annotation(
    Line(points = {{30, 72}, {10, 72}}, color = {0, 0, 255}));
  connect(variable_resistor.n, inductor.p) annotation(
    Line(points = {{50, 72}, {68, 72}}, color = {0, 0, 255}));
  connect(true_sensor.w, add1.u1) annotation(
    Line(points = {{42, -12}, {-10, -12}, {-10, 10}, {-38, 10}}, color = {0, 0, 127}));
  connect(emf.flange, load.flange_a) annotation(
    Line(points = {{132, 82}, {132, 40}, {90, 40}, {90, 8}}));
  connect(sensor_failure_injection_1, add1.u2) annotation(
    Line(points = {{-9, 23}, {-38, 23}, {-38, 22}}, color = {0, 0, 127}));
  connect(sensor_failure_injection_2, add2.u1) annotation(
    Line(points = {{21, -25}, {-38, -25}, {-38, -16}}, color = {0, 0, 127}));
  connect(sensor_failure_injection_3, add3.u1) annotation(
    Line(points = {{21, -37}, {-12, -37}, {-12, -42}, {-38, -42}}, color = {0, 0, 127}));
  connect(inductor.n, emf.p) annotation(
    Line(points = {{88, 72}, {122, 72}}, color = {0, 0, 255}));
  connect(ground.p, amplifier.n) annotation(
    Line(points = {{10, 112}, {10, 92}}, color = {0, 0, 255}));
  connect(amplifier.n, emf.n) annotation(
    Line(points = {{10, 92}, {122, 92}}, color = {0, 0, 255}));
  connect(PID.y, amplifier.v) annotation(
    Line(points = {{-99, 82}, {-2, 82}}, color = {0, 0, 127}));
  connect(reference.y, PID.u_s) annotation(
    Line(points = {{-138, 82}, {-122, 82}}, color = {0, 0, 127}));
  connect(voter.y, PID.u_m) annotation(
    Line(points = {{-96, -10}, {-110, -10}, {-110, 70}}, color = {0, 0, 127}));
  connect(resistor_failure_injection, resistor_limiter.u) annotation(
    Line(points = {{-71, 45}, {-34, 45}, {-34, 52}}, color = {0, 0, 127}));
  connect(resistor_limiter.y, variable_resistor.R) annotation(
    Line(points = {{-10, 52}, {40, 52}, {40, 60}}, color = {0, 0, 127}));
  connect(inductor_limiter.y, inductor.L) annotation(
    Line(points = {{70, 14}, {78, 14}, {78, 60}}, color = {0, 0, 127}));
  connect(inductor_failure_injection, inductor_limiter.u) annotation(
    Line(points = {{20, 14}, {46, 14}}, color = {0, 0, 127}));
  annotation(
    uses(Modelica(version = "4.0.0")),
  Diagram(graphics),
  Icon(graphics = {Text(origin = {-76, 17}, rotation = -90, extent = {{-32, 27}, {32, -27}}, textString = "Sensor 1", textStyle = {TextStyle.Bold}), Rectangle(lineColor = {145, 65, 172}, fillColor = {97, 53, 131}, lineThickness = 2, extent = {{-100, -100}, {100, 100}}), Text(origin = {82, 17}, rotation = -90, extent = {{-32, 27}, {32, -27}}, textString = "Sensor 3", textStyle = {TextStyle.Bold}), Text(origin = {0, 17}, rotation = -90, extent = {{-32, 27}, {32, -27}}, textString = "Sensor 2", textStyle = {TextStyle.Bold}), Text(origin = {-46, -65}, rotation = 90, extent = {{-32, 27}, {32, -27}}, textString = "Resistor", textStyle = {TextStyle.Bold}), Text(origin = {50, -65}, rotation = 90, extent = {{-32, 27}, {32, -27}}, textString = "Inductor", textStyle = {TextStyle.Bold})}));
end DCMotorControlAdvanced;