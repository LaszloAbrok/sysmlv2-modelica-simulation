model VoterTest
  Voter voter annotation(
    Placement(transformation(origin = {-80, 0}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Sources.Sine sine annotation(
    Placement(transformation(origin = {-10, 70}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant const2(k = 0.5)  annotation(
    Placement(transformation(origin = {40, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant const1(k = -0.5)  annotation(
    Placement(transformation(origin = {-12, -76}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
equation
  connect(voter.input1, sine.y) annotation(
    Line(points = {{-64, 16}, {-10, 16}, {-10, 48}}, color = {0, 0, 127}));
  connect(const2.y, voter.input2) annotation(
    Line(points = {{18, 0}, {-64, 0}}, color = {0, 0, 127}));
  connect(voter.input3, const1.y) annotation(
    Line(points = {{-64, -16}, {-12, -16}, {-12, -54}}, color = {0, 0, 127}));
  annotation(
    uses(Modelica(version = "4.0.0")));
end VoterTest;