module ActiveRecord
  class Base
    def serialize
      {"#{self.class.name.downcase.underscore}" => self.send((self.respond_to? :api_attributes) ? :api_attributes : :to_json)}
    end
    
    def self.serialize
      self.collect{|model| model.send((model.respond_to? :api_attributes) ? :api_attributes : :to_json).merge({:_class_name => self.first.class.name.downcase.pluralize})}.group_by{|d| d[:_class_name] }
    end
     
  end
end


class Array
  def serialize
    self.collect{|model| model.send((model.respond_to? :api_attributes) ? :api_attributes : :to_json).merge({:_class_name => self.first.class.name.downcase.pluralize})}.group_by{|d| d[:_class_name] }
  end
end