require 'byebug'
class AttrAccessorObject
  def self.my_attr_accessor(*names)
    names.each do |name|
      str = "@#{name}"
      define_method(name) do
        instance_variable_get(str.to_sym)
      end

      define_method("#{name}=") do |val|
        instance_variable_set(str.to_sym, val)
      end
    end
  end
end
