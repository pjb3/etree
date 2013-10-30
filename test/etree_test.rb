require 'test_helper'

class EtreeTest < MiniTest::Unit::TestCase
  def test_parse_date
    info_file = Etree::InfoFile.new
    [
      "Sunday June 13th 2010",
      "June 13th 2010",
      "sat, jun 13 10",
      "6/13/2010",
      "2010-06-13"
    ].each do |d|
      assert_equal "2010-06-13", info_file.send(:parse_date, d).strftime("%Y-%m-%d")
    end
    assert_nil info_file.send(:parse_date, "foo")
  end

  def test_parse_one_set
    info_file = Etree::InfoFile.new :directory => File.expand_path(File.join(File.dirname(__FILE__), "examples", "moe2010-05-30early.skm140.flac16"))
    info_file.parse

    assert_equal "moe.", info_file.band
    assert_equal "2010-05-30", info_file.date.strftime("%Y-%m-%d")
    assert_equal "Summercamp Festival, Early Show, Moonshine Stage, Chillicothe, IL", info_file.venue
    assert_equal [
      "Intro",
      "Bearsong >",
      "Timmy Tucker",
      "One Life",
      "Deep This Time",
      "Not Coming Down",
      "Wind it up",
      "San Ber'dino >",
      "Muffin Man",
      "A rare photo op..."
    ], info_file.discs.first
  end

  def test_parse_multiple_sets_with_timings
    info_file = Etree::InfoFile.new :directory => File.expand_path(File.join(File.dirname(__FILE__), "examples", "ph2010-06-11.mk4v.flac16"))
    info_file.parse

    assert_equal "Phish", info_file.band
    assert_equal "2010-06-11", info_file.date.strftime("%Y-%m-%d")
    assert_equal "Bridgeview, Illinois  Toyota Park", info_file.venue
    assert_equal [
      Etree::Track.new(:name => "Down with Disease",       :disc => 1, :number => 1 ),
      Etree::Track.new(:name => "Wolfman's Brother",       :disc => 1, :number => 2 ),
      Etree::Track.new(:name => "Possum",                  :disc => 1, :number => 3 ),
      Etree::Track.new(:name => "Boogie On Reggae Woman",  :disc => 1, :number => 4 ),
      Etree::Track.new(:name => "Reba",                    :disc => 1, :number => 5 ),
      Etree::Track.new(:name => "Jesus Just Left Chicago", :disc => 1, :number => 6 ),
      Etree::Track.new(:name => "The Divided Sky",         :disc => 1, :number => 7 ),
      Etree::Track.new(:name => "Golgi Apparatus",         :disc => 1, :number => 8 ),
      Etree::Track.new(:name => "David Bowie",             :disc => 1, :number => 9 ),
      Etree::Track.new(:name => "Light >",                 :disc => 2, :number => 1 ),
      Etree::Track.new(:name => "Maze",                    :disc => 2, :number => 2 ),
      Etree::Track.new(:name => "Ghost >",                 :disc => 2, :number => 3 ),
      Etree::Track.new(:name => "Limb by Limb",            :disc => 2, :number => 4 ),
      Etree::Track.new(:name => "Prince Caspian >",        :disc => 2, :number => 5 ),
      Etree::Track.new(:name => "The Horse >",             :disc => 2, :number => 6 ),
      Etree::Track.new(:name => "Silent in the Morning",   :disc => 2, :number => 7 ),
      Etree::Track.new(:name => "Run Like an Antelope",    :disc => 2, :number => 8 ),
      Etree::Track.new(:name => "Show of Life",            :disc => 2, :number => 9 ),
      Etree::Track.new(:name => "crowd",                   :disc => 2, :number => 10),
      Etree::Track.new(:name => "Cavern",                  :disc => 3, :number => 1 ),
      Etree::Track.new(:name => "Julius",                  :disc => 3, :number => 2 )
    ], info_file.tracks
  end

end
