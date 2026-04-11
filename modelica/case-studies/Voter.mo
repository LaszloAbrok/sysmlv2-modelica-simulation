block Voter
  Modelica.Blocks.Interfaces.RealInput input1 annotation(
    Placement(transformation(origin = {100, 80}, extent = {{-40, -40}, {40, 40}}, rotation = 180), iconTransformation(origin = {80, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput input2 annotation(
    Placement(transformation(origin = {99, -5}, extent = {{-41, -41}, {41, 41}}, rotation = 180), iconTransformation(origin = {80, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput y annotation(
    Placement(transformation(origin = {-100, 0}, extent = {{-40, -40}, {40, 40}}, rotation = 180), iconTransformation(origin = {-80, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput input3 annotation(
    Placement(transformation(origin = {100, -80}, extent = {{-40, -40}, {40, 40}}, rotation = 180), iconTransformation(origin = {80, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
algorithm
  
  y := max(min(input1, input2), min(max(input1, input2),input3))

annotation(
    uses(Modelica(version = "4.0.0")));annotation(
    Diagram(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}})}),
  Icon(graphics = {Rectangle(extent = {{100, -100}, {-100, 100}})}));
end Voter;