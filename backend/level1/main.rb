require_relative '../level1/drivy.rb'

# Load the data from the JSON file associated to the level
Drivy.load(1)
# Process everything and generate the output needed
Drivy.save(1)
# Test the generated output and the desired output
Drivy.test(1)
