Drivy Backend challenge
==================

You can find the original repo for this challenge [here](https://github.com/drivy/jobs/tree/master/backend).
Obviously, this code can be improve with more security testing for example...


How it works
-------------
You only have to go to the <code>backend/</code> directory and use this simple command:
```ruby
ruby main.rb
```

This will execute all the test level by level and print the result into the console.


Explanations
-------------
For more clarity, every level are executed with the same commands:
```ruby
# Load the data from the JSON file associated to the level
Drivy.load(LEVEL_NB)
# Process everything and generate the output needed
Drivy.save(LEVEL_NB)
# Test the generated output and the desired output
Drivy.test(LEVEL_NB)
```

Every new level require the previous level modifications. So every level contains only changes needed for it to work.

The code is splitted into:
* A <code>Drivy</code> module
* A <code>Car</code> class
* A <code>Rental</code> class
* An <code>Action</code> class
* A <code>Modification</code> class

### Level 1
Nothing to complicated here. We create two classes and load the data. For each data, generate an object, calculate the price according to the formula and generate the output.

### Level 2
We add to the <code>Rental</code> class a new method to calculate the discount.

### Level 3
We add to the <code>Rental</code> class new attributes and a new method to split the commission fees.
The method generating the output is overrided to add the fees into it.

### Level 4
We add to the <code>Rental</code> class new attributes and a new method to support options (deductible reduction fee).
The method generating the output is overrided to add the deductible reduction fee into it.

### Level 5
We create a new <code>Action</code> class which belongs to a rental.
Generate the actions needed for every rental and format them to the desired output format.
The method generating the output is overrided to add the actions into it.

### Level 6
We create a new <code>Modification</code> class which belongs to a rental.
Add a new attribute to the <code>Rental</code> class to notice if there is a modification pending or not.
We override the loading method to handle the modifications. For every modification detected, we create an object and we notice the rental associated.
Process the rental as usual but check if there is a modification pending, if yes create a new rental by with the modified value. Compare the old and the new rental via the <code>update</code> method and generate the desired output.


Dependencies
-------------
```ruby
# For parsing and generate JSON file
require 'json'
# To manipulate rental's dates
require 'date'
# To generate the output file
require 'fileutils'
# For colorful outputs for tests
require 'colorize'
```
