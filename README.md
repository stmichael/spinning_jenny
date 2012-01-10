# Spinning Jenny

This gem is an implementation of the test data builder pattern described in [Nat Pryces article](http://www.natpryce.com/articles/000714.html).

## Installation

Add the following line to your Gemfile

    gem 'spinning_jenny'

## Configuration

A core component of Spinning Jenny are the so called blueprints. They specify the classes of which Spinning Jenny can create instances and what default properties should be set. You usually put all blueprints in one or many configuration files. They may be placed anywhere. You just have to make sure that they will be loaded before you try to instantiate an object with Spinning Jenny.

If you use Spinning Jenny with RSpec, you would usually place the blueprints in a folder 'spec/blueprints'. In file spec_helper.rb you would add the following line:

    Dir[Rails.root.join("spec/blueprints/**/*.rb")].each {|f| require f}

## Usage

### Blueprints

Somewhere in your code:

    class Order
      attr_accessor :delivery
    end

A blueprint for the class Order could look as follows:

    SpinningJenny.blueprint Order do |blueprint|
      blueprint.delivery :express
    end

Every instance of class Order that you create with Spinning Jenny will have its attribute 'delivery' set to :express. Spinning Jenny will use the setter method of each attribute in the blueprint to assign the attribute values. So you don't need to define attributes with attr_accessor, you could instead just define a setter method called 'delivery='.

Each blueprint has a name. By default the name is generated with the class name. A blueprint for class Order will be called 'order', one for class SpecialOrder will be called 'special_order', one for class Vendor::Order will be called 'vendor_order'.

If you are not satisfied with the generated name, you can specify an explicit name:

    SpinningJenny.blueprint Order, :name => 'special_order' do |b|
      b.delivery :express
    end

Instead of passing the class directly to the blueprint you can also pass it as string or symbol.

    SpinningJenny.blueprint 'Order' do |b|
      b.delivery :express
    end
    SpinningJenny.blueprint :SpecialOrder do |b|
      b.delivery :express
    end

Attribute values will be evaluated when the blueprint is loaded.

    SpinningJenny.blueprint Order do |b|
      b.order_id rand(10)
    end

All instances of Order from SpinningJenny will have the same value for 'order_id' since 'rand(10)' will be evaluated just once. If you wish each instance to have its own 'order_id' then you can pass a block to the blueprint.

    SpinningJenny.blueprint Order do |b|
      b.order_id { rand(10) }
    end

The block will be evaluated once for each instance you create.

A special case for blueprint values are data builders.

    SpinningJenny.blueprint Item do |b|
      b.name 'item1'
    end
    SpinningJenny.blueprint Order do |b|
      b.item SpinningJenny.builder_for(Item)
    end

Like blocks they will be evaluated once for each instance. This mechanism allow you to create complex data structures with just one call.

     SpinningJenny.builder_for(Order).build

would create an instance of Item which will be assigned to the attribute 'item' of an instance of Order.

### Data builders

As soon as your blueprints are complete you can start to create instances with Spinning Jenny. This is the job of a data builder. You can create a data builder with the following:

    SpinningJenny.builder_for(Order)

Spinning Jenny will be looking for a blueprint named 'order' and creates a data builder with the found blueprint. Instead of a class you can also pass an explicit name as a string.

    SpinningJenny.builder_for('order')

The default strategy for the object creation is the build strategy.

    SpinningJenny.builder_for(Order).build

This creates a new instance of the desired class and sets its attributes according to the blueprint.

You can allways override or define new attributes.

    SpinningJenny.blueprint Order do |b|
      b.delivery :express
    end
    SpinningJenny.builder_for(Order).
      with(:delivery => :fedex).build

Or you can exclude attributes from the object creation process.

    SpinningJenny.blueprint Order do |b|
      b.delivery :express
    end
    SpinningJenny.builder_for(Order).
      without(:delivery).build

The attribute 'delivery' of the created instance of Order would not have the value :express.

It is possible to reuse builders.

    express_order_builder = SpinningJenny.builder_for(Order)
    fedex_order_builder = express_order_builder.with(:delivery => :fedex)
    normal_order_builder = fedex_order_builder.without(:delivery)

Similar to blueprints you can assign data builders to attributes.

    SpinningJenny.builder_for(Order).
      with(:item => SpinningJenny.builder_for(Item))

There is another, more readable way to find data builder. Consider the following example:

    SpinningJenny.blueprint Order do |b|
      b.delivery :express
    end
    SpinningJenny.an_order

Or:

    SpinningJenny.blueprint Order, :name => :special_order do |b|
      b.delivery :express
    end
    SpinningJenny.a_special_order

If the method starts with 'a_' or 'an_' Spinning Jenny will look for a blueprint named like the rest of the method name and create a data builder for it.
