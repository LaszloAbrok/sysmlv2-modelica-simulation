package SysMLv2ModelicaDCMotorControlNominal
  package Interfaces
    connector ElectricalPin "Electrical Pin"
      Real v "Potential (V)";
      flow Real i "Current (A)";
      annotation(
        Icon(graphics = {Ellipse(fillColor = {246, 97, 81}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}})}));
    end ElectricalPin;

    connector Flange "Mechanikai perem"
      Real phi "Rotation degree (rad)";
      flow Real tau "Torque (Nm)";
      annotation(
        Icon(graphics = {Ellipse(fillColor = {154, 153, 150}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}})}));
    end Flange;

    connector RealInput = input Real "Real input connector" annotation(
      Icon(graphics = {Polygon(lineColor = {0, 0, 127}, fillColor = {98, 160, 234}, fillPattern = FillPattern.Solid, points = {{-100, 100}, {100, 0}, {-100, -100}, {-100, 100}})}));
    connector RealOutput = output Real "Custom real output" annotation(
      Icon(graphics = {Polygon(lineColor = {0, 0, 127}, fillColor = {222, 221, 218}, fillPattern = FillPattern.Solid, points = {{-100, 100}, {100, 0}, {-100, -100}, {-100, 100}})}));
    connector BooleanOutput = output Boolean "Boolean output connector" annotation(
      Icon(graphics = {Polygon(lineColor = {97, 53, 131}, fillColor = {220, 138, 221}, fillPattern = FillPattern.Solid, lineThickness = 2, points = {{-100, 100}, {100, 0}, {-100, -100}, {-100, 100}})}));
    connector BooleanInput = input Boolean "Boolean input connector" annotation(
      Icon(graphics = {Polygon(lineColor = {152, 106, 68}, fillColor = {248, 228, 92}, fillPattern = FillPattern.Solid, lineThickness = 4, points = {{-100, 100}, {100, 0}, {-100, -100}, {-100, 100}})}));
  end Interfaces;

  package Components
    import SysMLv2ModelicaDCMotorControlNominal.Interfaces.*;

    model Resistor "Custom resistor"
      ElectricalPin p annotation(
        Placement(transformation(extent = {{-110, -10}, {-90, 10}})));
      ElectricalPin n annotation(
        Placement(transformation(extent = {{90, -10}, {110, 10}})));
      parameter Real R_nom = 1.0;
      parameter Real fault_startTime = 1e99;
      parameter Real fault_R = 5.0;
      parameter Real fault_duration = 10.0;
      Real R_actual;
      Real v;
      Real i;
    equation
      R_actual = if (time >= fault_startTime and time <= fault_startTime + fault_duration) then fault_R else R_nom;
      v = p.v - n.v;
      0 = p.i + n.i;
      i = p.i;
      v = i*R_actual;
      annotation(
        Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Rectangle(fillColor = {181, 131, 90}, fillPattern = FillPattern.Solid, extent = {{-70, -30}, {70, 30}}), Line(points = {{-100, 0}, {-70, 0}}, color = {0, 0, 255}, thickness = 2), Line(points = {{70, 0}, {100, 0}}, color = {0, 0, 255}, thickness = 2), Text(textColor = {0, 0, 255}, extent = {{-100, 40}, {100, 80}}, textString = "%name"), Text(extent = {{-100, -80}, {100, -40}}, textString = "R = %R")}));
    end Resistor;

    model Ground "Ground"
      ElectricalPin p annotation(
        Placement(transformation(extent = {{-10, 90}, {10, 110}})));
    equation
      p.v = 0.0;
      annotation(
        Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Line(points = {{0, 100}, {0, 0}}, color = {61, 56, 70}, thickness = 2), Line(points = {{-60, 0}, {60, 0}}, color = {61, 56, 70}, thickness = 2), Line(points = {{-40, -20}, {40, -20}}, color = {61, 56, 70}, thickness = 2), Line(points = {{-20, -40}, {20, -40}}, color = {61, 56, 70}, thickness = 2), Text(origin = {57, -44}, extent = {{-31, -14}, {31, 14}}, textString = "GND"), Text(origin = {-2, -126}, textColor = {0, 0, 255}, extent = {{-100, 40}, {100, 80}}, textString = "%name")}),
        Diagram(graphics));
    end Ground;

    model EMF "Electrical to Mechanical converter"
      parameter Real k = 0.1;
      ElectricalPin p annotation(
        Placement(transformation(extent = {{-110, 30}, {-90, 50}}), iconTransformation(origin = {-8, -80}, extent = {{-110, 30}, {-90, 50}})));
      ElectricalPin n annotation(
        Placement(transformation(extent = {{-110, -50}, {-90, -30}}), iconTransformation(origin = {-6, 80}, extent = {{-110, -50}, {-90, -30}})));
      Flange flange annotation(
        Placement(transformation(extent = {{90, -10}, {110, 10}})));
      Real v;
      Real i;
      Real w;
    equation
      v = p.v - n.v;
      0 = p.i + n.i;
      i = p.i;
      w = der(flange.phi);
      v = k*w;
      flange.tau = -k*i;
      annotation(
        Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}), graphics = {Line(points = {{-100, 40}, {-46, 40}}, color = {0, 0, 255}, thickness = 2), Line(points = {{-100, -40}, {-46, -40}}, color = {0, 0, 255}, thickness = 2), Line(points = {{60, 0}, {100, 0}}, thickness = 2), Text(origin = {-73, -57}, extent = {{17, -15}, {-17, 15}}, textString = "P"), Text(origin = {-73, 63}, extent = {{17, -15}, {-17, 15}}, textString = "N"), Rectangle(origin = {10, -2}, fillColor = {154, 153, 150}, fillPattern = FillPattern.Backward, extent = {{-58, -60}, {58, 60}}), Text(origin = {11, -2}, extent = {{33, -38}, {-33, 38}}, textString = "EMF"), Text(origin = {8, 18}, textColor = {0, 0, 255}, extent = {{-100, 40}, {100, 80}}, textString = "%name")}),
        Diagram(graphics));
    end EMF;

    model Inductor
      parameter Real L = 0.01 "Inductance [H]";
      ElectricalPin p annotation(
        Placement(transformation(extent = {{-110, -10}, {-90, 10}})));
      ElectricalPin n annotation(
        Placement(transformation(extent = {{90, -10}, {110, 10}})));
      Real v;
    equation
      v = p.v - n.v;
      p.i + n.i = 0;
      v = L*der(p.i);
      annotation(
        Icon(graphics = {Rectangle(lineColor = {198, 70, 0}, fillColor = {153, 193, 241}, fillPattern = FillPattern.Horizontal, lineThickness = 2, extent = {{-70, -30}, {70, 30}}), Line(points = {{-100, 0}, {-70, 0}}, color = {0, 0, 255}), Line(points = {{70, 0}, {100, 0}}, color = {0, 0, 255}), Text(textColor = {0, 0, 255}, extent = {{-100, 40}, {100, 80}}, textString = "%name"), Text(extent = {{-100, -80}, {100, -40}}, textString = "L = %L")}),
        Diagram(graphics));
    end Inductor;

    model SignalVoltage
      ElectricalPin p annotation(
        Placement(transformation(extent = {{-110, -10}, {-90, 10}})));
      ElectricalPin n annotation(
        Placement(transformation(extent = {{90, -10}, {110, 10}})));
      RealInput v annotation(
        Placement(transformation(extent = {{-10, 90}, {10, 110}}), iconTransformation(origin = {-100, 98}, extent = {{-10, 90}, {10, 110}}, rotation = 270)));
      parameter Real vMax = 400.0;
      parameter Real fault_startTime = 1e99;
      parameter Real fault_gainFactor = 0.5 "Feszültségcsökkentő szorzó (50%)";
      parameter Real fault_duration = 10.0 "Hiba hossza [s]";
      Real v_actual;
      Real v_faulty;
    equation
      v_faulty = if (time >= fault_startTime and time <= fault_startTime + fault_duration) then v*fault_gainFactor else v;
      v_actual = max(-vMax, min(vMax, v_faulty));
      p.v - n.v = v_actual;
      p.i + n.i = 0;
      annotation(
        Icon(graphics = {Ellipse(origin = {0, 1}, fillColor = {143, 240, 164}, fillPattern = FillPattern.Solid, extent = {{-64, -63}, {64, 63}}), Text(origin = {0, -1}, extent = {{-32, -45}, {32, 45}}, textString = "V"), Line(origin = {-82, 0}, points = {{-18, 0}, {18, 0}, {18, 0}}, thickness = 2), Line(origin = {82, 0}, points = {{-18, 0}, {18, 0}}, thickness = 2), Line(origin = {0, 77}, points = {{0, 13}, {0, -13}, {0, -13}, {0, -13}}, thickness = 2), Text(origin = {-2, -142}, textColor = {0, 0, 255}, extent = {{-100, 40}, {100, 80}}, textString = "%name")}),
        Diagram(graphics));
    end SignalVoltage;

    model Ramp
      parameter Real height = 100;
      parameter Real duration = 0.3;
      parameter Real offset = 0;
      parameter Real startTime = 0.1;
      RealOutput y annotation(
        Placement(transformation(extent = {{90, -10}, {110, 10}}), iconTransformation(extent = {{90, -10}, {110, 10}})));
    equation
      y = offset + (if time < startTime then 0 else if time < startTime + duration then (time - startTime)*height/duration else height);
      annotation(
        Icon(graphics = {Rectangle(origin = {0, -1}, fillColor = {246, 245, 244}, fillPattern = FillPattern.Solid, lineThickness = 1, extent = {{-80, 71}, {80, -71}}), Line(origin = {90, 0}, points = {{-10, 0}, {10, 0}, {10, 0}}, thickness = 2), Text(origin = {-2, -146}, textColor = {0, 0, 255}, extent = {{-100, 40}, {100, 80}}, textString = "%name"), Line(points = {{-80, -60}, {-40, -60}, {40, 60}, {80, 60}, {80, 60}, {80, 60}, {80, 60}}, thickness = 2), Text(origin = {39, -44}, extent = {{31, -26}, {-31, 26}}, textString = "Ramp")}),
        Diagram(graphics));
    end Ramp;

    model Inertia
      Flange flange_a annotation(
        Placement(transformation(extent = {{-110, -10}, {-90, 10}}), iconTransformation(extent = {{-110, -10}, {-90, 10}})));
      Flange flange_b annotation(
        Placement(transformation(extent = {{90, -10}, {110, 10}}), iconTransformation(origin = {2, 0}, extent = {{90, -10}, {110, 10}})));
      parameter Real J = 0.05;
      parameter Real fault_startTime = 1e99;
      parameter Real fault_loadTorque = -15.0;
      parameter Real fault_duration = 10.0;
      Real phi;
      Real w;
      Real tau_dist;
    equation
      phi = flange_a.phi;
      phi = flange_b.phi;
      w = der(phi);
      tau_dist = if (time >= fault_startTime and time <= fault_startTime + fault_duration) then fault_loadTorque else 0.0;
      J*der(w) = flange_a.tau + flange_b.tau + tau_dist;
      annotation(
        Icon(graphics = {Rectangle(fillColor = {222, 221, 218}, fillPattern = FillPattern.Solid, extent = {{-60, -40}, {60, 40}}), Rectangle(origin = {-70, -1}, fillColor = {222, 221, 218}, fillPattern = FillPattern.Solid, extent = {{-10, -9}, {10, 9}}), Rectangle(origin = {70, -1}, fillColor = {222, 221, 218}, fillPattern = FillPattern.Solid, extent = {{-10, -9}, {10, 9}}), Text(origin = {-88, 28}, extent = {{-32, -20}, {32, 20}}, textString = "A"), Text(origin = {88, 28}, extent = {{-32, -20}, {32, 20}}, textString = "B"), Line(origin = {-85, 0}, points = {{-5, 0}, {5, 0}}, thickness = 2), Line(origin = {86, 0}, points = {{-6, 0}, {6, 0}, {6, 0}}, thickness = 2), Text(origin = {-1, 0}, extent = {{-59, 40}, {59, -40}}, textString = "Inertia"), Text(origin = {-2, -128}, textColor = {0, 0, 255}, extent = {{-100, 40}, {100, 80}}, textString = "%name")}),
        Diagram(graphics));
    end Inertia;

    model Feedback
      RealInput u1 annotation(
        Placement(transformation(extent = {{-110, -10}, {-90, 10}}), iconTransformation(origin = {-6, 0}, extent = {{-110, -10}, {-90, 10}})));
      RealInput u2 annotation(
        Placement(transformation(extent = {{-10, -110}, {10, -90}}), iconTransformation(origin = {-100, -106}, extent = {{-10, -110}, {10, -90}}, rotation = 90)));
      RealOutput y annotation(
        Placement(transformation(extent = {{90, -10}, {110, 10}}), iconTransformation(origin = {10, 0}, extent = {{90, -10}, {110, 10}})));
    equation
      y = u1 - u2;
      annotation(
        Icon(graphics = {Ellipse(lineColor = {0, 0, 127}, fillColor = {222, 221, 218}, fillPattern = FillPattern.Solid, extent = {{-80, -80}, {80, 80}}), Text(origin = {-28, -20}, textColor = {0, 0, 127}, extent = {{-60, 40}, {-20, 0}}, textString = "+"), Text(origin = {-22, -12}, textColor = {0, 0, 127}, extent = {{0, -20}, {44, -60}}, textString = "_"), Text(origin = {4, -3}, extent = {{-78, 39}, {78, -39}}, textString = "F"), Line(origin = {-90, 0}, points = {{-10, 0}, {10, 0}, {10, 0}, {10, 0}}, thickness = 2), Line(origin = {90, 0}, points = {{-10, 0}, {10, 0}}, thickness = 2), Line(origin = {0, -90}, points = {{0, -10}, {0, 10}}, thickness = 2), Text(origin = {-8, 34}, textColor = {0, 0, 255}, extent = {{-100, 40}, {100, 80}}, textString = "%name")}),
        Diagram(graphics));
    end Feedback;

    model PID "PID Controller"
      parameter Real k = 1.0;
      parameter Real Ti = 1.0;
      parameter Real Td = 0.1;
      parameter Real yMax = 400.0;
      parameter Real yMin = -400.0;
      RealInput u annotation(
        Placement(transformation(extent = {{-110, -10}, {-90, 10}})));
      RealOutput y annotation(
        Placement(transformation(extent = {{90, -10}, {110, 10}})));
      Real I_term(start = 0);
      Real y_unlimited;
    equation
      der(I_term) = u/Ti;
      y_unlimited = k*(u + I_term + Td*der(u));
      y = max(yMin, min(yMax, y_unlimited));
      annotation(
        Icon(graphics = {Rectangle(lineColor = {0, 0, 127}, fillColor = {255, 190, 111}, fillPattern = FillPattern.Solid, extent = {{-80, -80}, {80, 80}}), Text(extent = {{-60, 40}, {60, -40}}, textString = "PID"), Line(origin = {-90, 0}, points = {{-10, 0}, {10, 0}, {10, 0}, {10, 0}}, thickness = 2), Line(origin = {90, 0}, points = {{-10, 0}, {10, 0}, {10, 0}, {10, 0}}, thickness = 2), Text(origin = {-4, -158}, textColor = {0, 0, 255}, extent = {{-100, 40}, {100, 80}}, textString = "%name")}),
        Diagram(graphics));
    end PID;

    model SpeedSensor "Rotational speed sensor"
      Flange flange annotation(
        Placement(transformation(extent = {{-110, -10}, {-90, 10}})));
      RealOutput w annotation(
        Placement(transformation(extent = {{90, -10}, {110, 10}})));
        
      Real w_ideal "A valódi, fizikai sebesség a tengelyen";
      Real w_drifted;
      Real w_gained;
      Real w_oscillated;
      
      parameter Real gainError_startTime = 1e99;
      parameter Real gainError_gainFactor = 1.15;
      parameter Real gainError_duration = 10.0;
      Boolean gainError_isActive;
      
      parameter Real stuckError_startTime = 1e99;
      parameter Real stuckError_value = 0.0;
      parameter Real stuckError_duration = 10.0;
      Boolean stuckError_isActive;
      
      // 3. Szinuszos oszcilláció hiba (Oscillation Fault)
      parameter Real oscError_startTime = 1e99;
      parameter Real oscError_amplitude = 5.0;
      parameter Real oscError_frequency = 10.0;
      parameter Real oscError_duration = 10.0;
      Boolean oscError_isActive;
    
      // 4. ÚJ: Drift hiba (Lassú elvándorlás)
      parameter Real driftError_startTime = 1e99;
      parameter Real driftError_rate = 2.0;
      parameter Real driftError_duration = 10.0;
      Boolean driftError_isActive;
    
    equation
      w_ideal = der(flange.phi);
      flange.tau = 0;
      
      gainError_isActive = (time >= gainError_startTime) and (time <= gainError_startTime + gainError_duration);
      stuckError_isActive = (time >= stuckError_startTime) and (time <= stuckError_startTime + stuckError_duration);
      oscError_isActive = (time >= oscError_startTime) and (time <= oscError_startTime + oscError_duration);
      driftError_isActive = (time >= driftError_startTime) and (time <= driftError_startTime + driftError_duration);
    
      // --- KASZKÁDOS HIBA-FELDOLGOZÁS ---
      // 1. Lassú vándorlás hozzáadása
      w_drifted = w_ideal + (if driftError_isActive then driftError_rate * (time - driftError_startTime) else 0.0);
      
      // 2. Erősítés rászorzása
      w_gained = w_drifted * (if gainError_isActive then gainError_gainFactor else 1.0);
      
      // 3. Zaj/Oszcilláció hozzáadása
      w_oscillated = w_gained + (if oscError_isActive then oscError_amplitude*sin(2*Modelica.Constants.pi*oscError_frequency*(time - oscError_startTime)) else 0.0);
      
      // 4. A beragadás (Stuck) mindent felülír, ha aktív
      w = if stuckError_isActive then stuckError_value else w_oscillated;
    
      annotation(
        Icon(graphics = {Ellipse(fillColor = {153, 193, 241}, fillPattern = FillPattern.Solid, extent = {{-80, -80}, {80, 80}}), Text(extent = {{-50, 40}, {50, -40}}, textString = "S"), Line(origin = {-85, 0}, points = {{-5, 0}, {5, 0}, {5, 0}}, thickness = 2), Line(origin = {85, 0}, points = {{-5, 0}, {5, 0}, {5, 0}}, thickness = 2), Text(origin = {-2, -150}, textColor = {0, 0, 255}, extent = {{-100, 40}, {100, 80}}, textString = "%name")}),
        Diagram(graphics));
    end SpeedSensor;

    model MedianVoter
      RealInput u1 annotation(
        Placement(transformation(extent = {{-110, 50}, {-90, 70}})));
      RealInput u2 annotation(
        Placement(transformation(extent = {{-110, -10}, {-90, 10}})));
      RealInput u3 annotation(
        Placement(transformation(extent = {{-110, -70}, {-90, -50}})));
      RealOutput y annotation(
        Placement(transformation(extent = {{90, -10}, {110, 10}})));
    equation
      y = max(min(u1, u2), min(max(u1, u2), u3));
      annotation(
        Icon(graphics = {Rectangle(lineColor = {0, 0, 127}, fillColor = {220, 138, 221}, fillPattern = FillPattern.Solid, extent = {{-80, -80}, {80, 80}}), Text(textColor = {36, 31, 49}, extent = {{-60, 40}, {60, -40}}, textString = "Voter"), Line(origin = {-90, 0}, points = {{-10, 0}, {10, 0}, {10, 0}}, thickness = 1), Line(origin = {-90, -60}, points = {{-10, 0}, {10, 0}, {10, 0}}, thickness = 1), Line(origin = {-90, 60}, points = {{-10, 0}, {10, 0}, {10, 0}}, thickness = 1), Line(origin = {90, 0}, points = {{-10, 0}, {10, 0}, {10, 0}}, thickness = 1), Text(origin = {-6, -148}, textColor = {0, 0, 255}, extent = {{-100, 40}, {100, 80}}, textString = "%name")}),
        Diagram(graphics));
    end MedianVoter;

    model FDIMonitor
      parameter Real threshold = 2.0 "Max allowed difference [rad/s]";
      parameter Real confirmation_time = 0.05 "Window to confirm fault [s]";
      RealInput w_sensor annotation(
        Placement(transformation(extent = {{-110, 30}, {-90, 50}}), iconTransformation(origin = {6, 40}, extent = {{-110, 30}, {-90, 50}}, rotation = 180)));
      RealInput w_voter annotation(
        Placement(transformation(extent = {{-110, -50}, {-90, -30}}), iconTransformation(origin = {-40, -8}, extent = {{-110, -50}, {-90, -30}}, rotation = 90)));
      RealOutput residual "Current value of the residual" annotation(
        Placement(transformation(extent = {{90, 30}, {110, 50}}), iconTransformation(origin = {80, 10}, extent = {{90, 30}, {110, 50}}, rotation = 90)));
      BooleanOutput fault_detected "Only detected when fault is present for the given time." annotation(
        Placement(transformation(extent = {{90, 30}, {110, 50}}), iconTransformation(origin = {0, 10}, extent = {{90, 30}, {110, 50}}, rotation = 90)));
      Real fault_timer(start = 0.0);
    equation
      residual = abs(w_sensor - w_voter);
      der(fault_timer) = if residual > threshold then 1.0 else if fault_timer > 0.0 then -5.0 else 0.0;
      fault_detected = fault_timer >= confirmation_time;
      annotation(
        Icon(graphics = {Rectangle(lineColor = {255, 0, 0}, fillColor = {255, 220, 220}, fillPattern = FillPattern.Solid, extent = {{-80, -80}, {80, 80}}), Text(textColor = {255, 0, 0}, extent = {{-60, 40}, {60, -40}}, textString = "FDI"), Text(origin = {-220, -68}, textColor = {0, 0, 255}, extent = {{-100, 40}, {100, 80}}, textString = "%name"), Line(origin = {-40, 90}, points = {{0, -10}, {0, 10}, {0, 10}}, thickness = 2), Line(origin = {40, 90}, points = {{0, -10}, {0, 10}, {0, 10}}, thickness = 2), Line(origin = {0, -92.5}, points = {{0, -9.5}, {0, 10.5}, {0, 6.5}}, thickness = 2), Line(origin = {90, 0}, points = {{-10, 0}, {10, 0}, {10, 0}}, thickness = 2), Text(origin = {-80, -108}, extent = {{-42, 16}, {42, -16}}, textString = "voter"), Text(origin = {160, -28}, extent = {{-42, 16}, {42, -16}}, textString = "sensor"), Text(origin = {-157, 113}, extent = {{-77, 47}, {77, -47}}, textString = "fault detection"), Text(origin = {124, 112}, extent = {{-42, 16}, {42, -16}}, textString = "residual")}),
        Diagram(graphics));
    end FDIMonitor;

    model SystemMonitor "Critical failure and Tracking Monitor"
      import SysMLv2ModelicaDCMotorControlNominal.Interfaces.*;
      // --- Szenzor hiba bemenetek (Eredeti) ---
      BooleanInput fault1 annotation(
        Placement(transformation(extent = {{-110, 50}, {-90, 70}})));
      BooleanInput fault2 annotation(
        Placement(transformation(extent = {{-110, -10}, {-90, 10}})));
      BooleanInput fault3 annotation(
        Placement(transformation(extent = {{-110, -70}, {-90, -50}})));
      // --- ÚJ: Folytonos bemenetek a hardverhiba figyeléséhez ---
      RealInput w_ref "Célsebesség (Ramp)" annotation(
        Placement(transformation(extent = {{-70, 90}, {-50, 110}}), iconTransformation(origin = {-160, 38},extent = {{-70, 90}, {-50, 110}}, rotation = -90)));
      RealInput w_voter "Tényleges sebesség (Voter)" annotation(
        Placement(transformation(extent = {{50, 90}, {70, 110}}), iconTransformation(origin = {-40, 158},extent = {{50, 90}, {70, 110}}, rotation = -90)));
      // --- Kritikus hiba kimenet ---
      BooleanOutput critical_failure annotation(
        Placement(transformation(extent = {{90, -10}, {110, 10}})));
      // --- ÚJ: Követési hiba paraméterek ---
      parameter Real tracking_threshold = 10.0 "Maximális megengedett eltérés [rad/s]";
      parameter Real tracking_confirmation_time = 0.05 "Hiba megerősítési ideje [s]";
      parameter Real startup_mask_time = 1.0;
      // --- Belső változók ---
      Integer active_faults;
      Real tracking_error;
      Real tracking_timer(start = 0.0);
      Boolean hardware_fault;
    equation
// 1. TMR logika: Hány szenzor hibásodott meg?
      active_faults = (if fault1 then 1 else 0) + (if fault2 then 1 else 0) + (if fault3 then 1 else 0);
// 2. ÚJ: Hardver hiba logika (Követési hiba)
// Kiszámoljuk a különbséget a cél és a valóság között
      tracking_error = abs(w_ref - w_voter);
// Szivárgó integrátor az időzítéshez (hogy ne jelezzen be apró tüskékre)
      der(tracking_timer) = if (time > startup_mask_time and tracking_error > tracking_threshold) then 1.0 
                            else if tracking_timer > 0.0 then -1.0 
                            else 0.0;
// Hardver hiba aktív, ha az időzítő elérte a limitet
      hardware_fault = tracking_timer >= tracking_confirmation_time;
// 3. Kritikus hiba kimenet
// A rendszer leáll, ha a TMR összeomlik (2+ szenzor hiba) VAGY ha a hardver nem bírja a tempót
      critical_failure = (active_faults >= 2) or hardware_fault;
      annotation(
        Icon(graphics = {Rectangle(lineColor = {150, 0, 0}, fillColor = {246, 97, 81}, fillPattern = FillPattern.Solid, extent = {{-80, -80}, {80, 80}}), Text(textColor = {150, 0, 0}, extent = {{-70, 30}, {70, -30}}, textString = "System
Monitor"), Text(origin = {-2, -160}, textColor = {0, 0, 255}, extent = {{-100, 40}, {100, 80}}, textString = "%name"), Line(origin = {-87.5, 60}, points = {{-4.5, 0}, {5.5, 0}, {1.5, 0}}, thickness = 2), Line(origin = {-87.5, 0}, points = {{-4.5, 0}, {5.5, 0}, {1.5, 0}}, thickness = 2), Line(origin = {-87.5, -60}, points = {{-4.5, 0}, {5.5, 0}, {1.5, 0}}, thickness = 2), Line(origin = {84.5, 0}, points = {{-4.5, 0}, {5.5, 0}, {1.5, 0}}, thickness = 2), Line(origin = {-60, 85}, points = {{0, 5}, {0, -5}}, thickness = 2), Line(origin = {60, 85}, points = {{0, 5}, {0, -5}}, thickness = 2), Text(origin = {-103, 38}, extent = {{-27, 10}, {27, -10}}, textString = "F1"), Text(origin = {-103, -26}, extent = {{-27, 10}, {27, -10}}, textString = "F2"), Text(origin = {-103, -82}, extent = {{-27, 10}, {27, -10}}, textString = "F3"), Text(origin = {-28, 91}, extent = {{-16, 17}, {16, -17}}, textString = "Ref"), Text(origin = {96, 89}, extent = {{-24, 19}, {24, -19}}, textString = "Voter")}),
        Diagram(graphics));
    end SystemMonitor;
  end Components;

  model System
    Components.Ramp ramp(height = 100) annotation(
      Placement(transformation(origin = {-104, 16}, extent = {{-10, -10}, {10, 10}})));
    Components.Feedback feedback annotation(
      Placement(transformation(origin = {-52, 16}, extent = {{-10, -10}, {10, 10}})));
    Components.PID pid(k = 5.0, Ti = 0.05) annotation(
      Placement(transformation(origin = {-22, 16}, extent = {{-10, -10}, {10, 10}})));
    Components.SpeedSensor speedSensor3 annotation(
      Placement(transformation(origin = {48, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
    Components.SignalVoltage amplifier annotation(
      Placement(transformation(origin = {14, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
    Components.Resistor resistor annotation(
      Placement(transformation(origin = {34, 0}, extent = {{-10, -10}, {10, 10}})));
    Components.Inductor inductor annotation(
      Placement(transformation(origin = {60, 0}, extent = {{-10, -10}, {10, 10}})));
    Components.EMF emf annotation(
      Placement(transformation(origin = {90, 16}, extent = {{-10, -10}, {10, 10}})));
    Components.Ground ground annotation(
      Placement(transformation(origin = {14, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
    Components.Inertia inertia annotation(
      Placement(transformation(origin = {100, -22}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    SysMLv2ModelicaDCMotorControlNominal.Components.SpeedSensor speedSensor1 annotation(
      Placement(transformation(origin = {48, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
    SysMLv2ModelicaDCMotorControlNominal.Components.SpeedSensor speedSensor2 annotation(
      Placement(transformation(origin = {48, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
    Components.MedianVoter medianVoter annotation(
      Placement(transformation(origin = {-38, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
    Components.FDIMonitor fDIMonitor1 annotation(
      Placement(transformation(origin = {-10, -28}, extent = {{-10, -10}, {10, 10}})));
    SysMLv2ModelicaDCMotorControlNominal.Components.FDIMonitor fDIMonitor2 annotation(
      Placement(transformation(origin = {-78, -56}, extent = {{-10, -10}, {10, 10}})));
    SysMLv2ModelicaDCMotorControlNominal.Components.FDIMonitor fDIMonitor3 annotation(
      Placement(transformation(origin = {-38, -98}, extent = {{-10, -10}, {10, 10}})));
    Components.SystemMonitor systemMonitor annotation(
      Placement(transformation(origin = {-70, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  equation
    connect(ramp.y, feedback.u1) annotation(
      Line(points = {{-94, 16}, {-62, 16}}, color = {0, 0, 127}));
    connect(feedback.y, pid.u) annotation(
      Line(points = {{-42, 16}, {-32, 16}}, color = {0, 0, 127}));
    connect(pid.y, amplifier.v) annotation(
      Line(points = {{-12, 16}, {4, 16}}, color = {0, 0, 127}));
    connect(amplifier.n, ground.p) annotation(
      Line(points = {{14, 26}, {14, 34}}));
    connect(amplifier.n, emf.n) annotation(
      Line(points = {{14, 26}, {80, 26}, {80, 20}}));
    connect(amplifier.p, resistor.p) annotation(
      Line(points = {{14, 6}, {14, 0}, {24, 0}}));
    connect(resistor.n, inductor.p) annotation(
      Line(points = {{44, 0}, {50, 0}}));
    connect(inductor.n, emf.p) annotation(
      Line(points = {{70, 0}, {80, 0}, {80, 12}}));
    connect(emf.flange, inertia.flange_a) annotation(
      Line(points = {{100, 16}, {100, -12}}));
    connect(speedSensor3.flange, inertia.flange_b) annotation(
      Line(points = {{58, -90}, {100, -90}, {100, -32}}));
    connect(speedSensor2.flange, inertia.flange_b) annotation(
      Line(points = {{58, -70}, {100, -70}, {100, -32}}));
    connect(speedSensor1.flange, inertia.flange_b) annotation(
      Line(points = {{58, -50}, {100, -50}, {100, -32}}));
    connect(speedSensor2.w, medianVoter.u2) annotation(
      Line(points = {{38, -70}, {-28, -70}}, color = {0, 0, 127}));
    connect(speedSensor3.w, medianVoter.u1) annotation(
      Line(points = {{38, -90}, {-20, -90}, {-20, -76}, {-28, -76}}, color = {0, 0, 127}));
    connect(speedSensor1.w, medianVoter.u3) annotation(
      Line(points = {{38, -50}, {-20, -50}, {-20, -64}, {-28, -64}}, color = {0, 0, 127}));
    connect(speedSensor1.w, fDIMonitor1.w_sensor) annotation(
      Line(points = {{38, -50}, {20, -50}, {20, -28}, {1, -28}}, color = {0, 0, 127}));
    connect(medianVoter.y, feedback.u2) annotation(
      Line(points = {{-48, -70}, {-52, -70}, {-52, 6}}, color = {0, 0, 127}));
    connect(medianVoter.y, fDIMonitor1.w_voter) annotation(
      Line(points = {{-48, -70}, {-52, -70}, {-52, -43}, {-10, -43}, {-10, -39}}, color = {0, 0, 127}));
    connect(medianVoter.y, fDIMonitor2.w_voter) annotation(
      Line(points = {{-48, -70}, {-78, -70}, {-78, -67}}, color = {0, 0, 127}));
    connect(speedSensor2.w, fDIMonitor2.w_sensor) annotation(
      Line(points = {{38, -70}, {20, -70}, {20, -56}, {-68, -56}}, color = {0, 0, 127}));
    connect(speedSensor3.w, fDIMonitor3.w_sensor) annotation(
      Line(points = {{38, -90}, {-20, -90}, {-20, -98}, {-27, -98}}, color = {0, 0, 127}));
    connect(fDIMonitor3.w_voter, medianVoter.y) annotation(
      Line(points = {{-38, -109}, {-38, -116}, {-52, -116}, {-52, -70}, {-48, -70}}, color = {0, 0, 127}));
    connect(fDIMonitor1.fault_detected, systemMonitor.fault3) annotation(
      Line(points = {{-14, -16}, {-64, -16}, {-64, -12}}, color = {97, 53, 131}));
    connect(fDIMonitor2.fault_detected, systemMonitor.fault1) annotation(
      Line(points = {{-82, -44}, {-82, -18}, {-76, -18}, {-76, -12}}, color = {97, 53, 131}));
    connect(fDIMonitor3.fault_detected, systemMonitor.fault2) annotation(
      Line(points = {{-42, -86}, {-42, -82}, {-58, -82}, {-58, -22}, {-70, -22}, {-70, -12}}, color = {97, 53, 131}));
  connect(medianVoter.y, systemMonitor.w_voter) annotation(
      Line(points = {{-48, -70}, {-52, -70}, {-52, -30}, {-88, -30}, {-88, 4}, {-80, 4}}, color = {0, 0, 127}));
  connect(ramp.y, systemMonitor.w_ref) annotation(
      Line(points = {{-94, 16}, {-84, 16}, {-84, -8}, {-80, -8}}, color = {0, 0, 127}));
  end System;
end SysMLv2ModelicaDCMotorControlNominal;