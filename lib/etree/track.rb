module Etree
  class Track
    attr_accessor :name, :disc, :number
  
    def initialize(attrs={})
      attrs.each do |k,v|
        send "#{k}=", v
      end
    end
  
    def file_name
      ("d%dt%02d %s" % [disc, number, name]).gsub(/\W/, '_').gsub(/_{2,}/,'_').gsub(/^_|_$/, '').downcase
    end
  
    def eql?(track)
      self.class.equal?(track.class) &&
        name == track.name &&
        disc == track.disc &&
        number == track.number
    end
    alias == eql?
  
    def hash
      name.hash ^ disc.hash ^ number.hash
    end
  
    def to_s
      "d%dt%02d %s" % [disc, number, name]
    end
  
  end
end