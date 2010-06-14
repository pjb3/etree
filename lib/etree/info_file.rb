require "chronic"

module Etree
  
  # This will parse the info file that comes with a show
  # Typical usage might look like:
  #   info_file = Etree::InfoFile.new :directory => "ph1999-12-31.flacf"
  #   info_file.parse
  #   info_file.band # => "Phish"
  #   info_file.date # => "1999-12-31"
  #   info_file.venue # => "Big Cypress Seminole Indian Reservation, Big Cypress, FL"
  #   info_file.discs.first # => ["Runaway Jim", "Funky Bitch", ...]
  class InfoFile
    
    REGEXPS = {
      :spots      => %r{fob|dfc|btp|d?aud|d?sbd|soundboard|on(\s*|-)stage|matrix|mix|balcony|rail|stand}ix,
      :mics       => %r{caps|omni|cardioid|sc?ho?ep[sz]|neumann|mbho|akg|b&k|dpa|audio.technica}ix,
      :configs    => %r{\b(?:ortf|x[-\/]?y|degrees|blumlein|binaural|nos|din)\b}ix,
      :cables     => %r{kc5|actives?|patch(?:ed)?|coax|optical}ix,
      :pres       => %r{lunatec|apogee|ad1000|ad2k\+?|oade|sonosax|sbm-?1|usb-pre|mini[\s-]?me}ix,
      :dats       => %r{dat|pcm|d[378]|da20|d10|m1|sv-25[05]|da-?p1|tascam|sony|teac|aiwa|panasonic|hhb|portadat|44\.1(?:k(?:hz))|mini-?disc|fostex}ix,
      :laptops    => %r{laptop|dell|ibm|apple|toshiba|(power|i)-?book}ix,
      :digicards  => %r{ieee1394|s.?pdif|zefiro|za-?2|rme|digiface|sb-?live|fiji|turtle\sbeach|delta\sdio|event\sgina|montego|zoltrix|prodif}ix,
      :software   => %r{cd-?wave?|mkwact|shn(?:v3)?|shorten|samplitude|cool[-\s]?edit|sound.?forge|wavelab}ix,
      :venues     => %r{(?:arts cent|theat)(?:er|re)|playhouse|arena|club|university|festival|lounge|room|cafe|field|house|airport|ballroom|college|hall|auditorium|village|temple}ix,
      :states     => %r{A[BLKZR]|BC|CA|CO|CT|DE|FL|GA|HI|I[DLNA]|KS|KY|LA|M[ABEDINSOT]|N[BCDEFVHJMSY]|O[HKNR]|P[AQ]|PEI|QC|RI|S[CDK]|TN|TX|UT|VT|VA|W[AVIY]|DC}x,
      :countries  => %r{Japan|England|Ireland|Brazil|Jamaica|United\s+Kingdom|Italy|South\s+Africa|Sweden|Portugal|Israel|Egypt|Norway|France|India|Finland|United\s+States|China|Mexico|Costa\s+Rica|Ecuador|New\s+Zealand|Puerto\s+Rico|Djibouti}i
    }
    
    TRACK_REGEXP = %r{^\s*(?:d\d+)?t?(\d+)  # sometimes you see d<n>t<m>
                  \s* (?:[[:punct:]]+)?     # whitespace, some punctuation
                  \s* (.*)}mix;             # whitespace, the track title
    
    attr_accessor :directory, :info_file, :band, :date, :venue, :source, :discs, :comments
    
    def initialize(attrs={})
      attrs.each do |k,v|
        send("#{k}=", v)
      end
    end
    
    def parse(info_file=nil)
      self.info_file = info_file if info_file
      parse_info
    end
    
    def directory
      @directory ||= info_file ? File.dirname(info_file) : Dir.pwd
    end
    
    def info_file
      # The implementation in the perl version is much more complicated
      # This should be good enough for now
      # Grab the first text file that doesn't have ffp in the name
      @info_file ||= Dir["#{directory}/*.txt"].detect{|f| File.basename(f) !~ /ffp/ }
    end
    
    def songs_count
      Dir["#{directory}/*.flac"].size
    end
    
    def tracks
      @tracks ||= begin
        tracks = []
        discs.each_with_index do |d, dn|
          d.each_with_index do |t, tn|
            tracks << Track.new(:name => t, :number => tn + 1, :disc => dn + 1)
          end
        end
        tracks
      end
    end
    
    private
    def info_file_paragraphs
      @info_file_paras ||= File.read(info_file).split(/\s*\r?\n\r?\n/)
    end
    
    def parse_info
      info_file_paragraphs.each do |paragraph|
        next if $para =~ /\b[\da-f]{32}\b/i
        if !band or !date or !venue
          parse_band paragraph
        elsif source_info_paragraph? paragraph
          self.source ||= []
          self.source << paragraph
        elsif tracks_paragraph? paragraph
          parse_tracks paragraph
        else
          self.comments ||= []
          self.comments << paragraph
        end
      end
    end
    
    def parse_band(paragraph)
      venue = []
      paragraph.each_line do |line|
        line.strip!
        next if line.empty?
        
        if !date
          self.date = parse_date(line)
          next if date
        end
        
        if band
          venue << line
        else
          self.band = line
        end
      end
      self.venue = Array(venue).join(", ")
    end
    
    def parse_date(s)
      if time = Chronic.parse(s.to_s.gsub(',','').gsub(/(?:mon|tue|wed|thu|fri|sat|sun)\w*/i,''))
        Date.new(time.year, time.month, time.day)
      end
    end
    
    def parse_tracks(paragraph)
      tracks = []
      paragraph.each_line do |line|
        line.strip!
        

        if match = line.match(TRACK_REGEXP)
          tracks << format_track_name(match[2])
        end
      end
      (self.discs ||= []) << tracks unless tracks.empty?
    end
    
    def format_track_name(track_name)
      track_name = track_name.to_s
      segue = track_name =~ />\s*$/
      track_name.sub!(/^\d{1,2}:\d{2}\]?\s/,"") # strip timings
      track_name.sub!(/[*^%>\s]*$/,"") # strip footnote markers
      track_name << (segue ? ' >' : '')
    end
    
    def source_info_paragraph?(paragraph)
      paragraph =~ %r{^(?:source|src|xfer|transfer|seede[rd]|tape[rd]|recorded)\b}mix or
      paragraph =~ %r{\b(#{REGEXPS[:spots]}|#{REGEXPS[:mics]}|#{REGEXPS[:configs]}|#{REGEXPS[:cables]}|#{REGEXPS[:pres]}|#{REGEXPS[:dats]}|#{REGEXPS[:laptops]}|#{REGEXPS[:digicards]}|#{REGEXPS[:software]})\b}
    end
    
    def tracks_paragraph?(paragraph)
      paragraph =~ /\b(cd|set|dis[ck]|volume|set)\b/i or
      paragraph =~ TRACK_REGEXP or
      paragraph =~ /^([\*\@\#\$\%\^]+)\s*[-=:]?\s*/
    end
    
  end
end