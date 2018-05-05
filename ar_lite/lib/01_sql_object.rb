require_relative 'db_connection'
require 'active_support/inflector'
require 'byebug'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    table_name = self.table_name
    @all_values ||= DBConnection.execute2(<<-SQL)
        SELECT
          *
        FROM
          #{table_name}
        SQL
    @all_values.first.map(&:to_sym)
  end

  def self.finalize!
    columns.each do |column|
      define_method("#{column}=") do |val|
        attributes[column] = val
      end
      define_method(column) do
        attributes[column]
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name# || self.to_s.tableize
  end

  def self.table_name
    @table_name || self.to_s.tableize
  end

  def self.all
    # @all_values = DBConnection.execute2(<<-SQL)
    #     SELECT
    #       #{table_name}.*
    #     FROM
    #       #{table_name}
    #     SQL
    #debugger
    self.parse_all(@all_values.drop(1))
    # @all_values.drop(1)
  end

  def self.parse_all(results)
    results.map {|obj| self.new(obj)}
  end

  def self.find(id)
    # ...
  end

  def initialize(params = {})
    params.each do |k,v|
      if self.class.columns.include?(k.to_sym)
        self.send("#{k}=", v)
      else
        raise "unknown attribute '#{k}'"
      end
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    # ...
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
