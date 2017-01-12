module ADT
  def self.included(base)
    puts "ADT was extended by #{base}"
    base.extend(ModuleMethods)
    base.init
  end

  def match
    puts "called match on #{self}"
  end

  module ModuleMethods
    attr_reader :sub_types

    def included(sub_type)
      puts "#{sub_type} included #{self}"
      @sub_types << sub_type
    end

    def init
      @sealed = false
      @sub_types = []
    end

    def seal
      @sealed = true
    end

    def sealed?
      @sealed
    end
  end
end
