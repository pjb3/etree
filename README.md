# etree

This is a port of the [Perl Etree Scripts](http://etree-scripts.sourceforge.net/) to Ruby.  This scripts can be used to download the flac source of audience recording of a concert from a site like [http://bt.etree.org](http://bt.etree.org) or [The Live Music Archive](http://www.archive.org/details/audio) and convert it to MP3s. 

The main feature this provides, aside from converting the FLAC files to MP3, is extracting the track information from the text file in the folder and using that information to populate the MP3 ID3 tags such as Artist, Album, Track Title, Track Title, etc.

## Requirements

You will need `flac` and `lame` installed in order to use this.  You can install them both using [homebrew][homebrew]:

    $ brew install flac

## Usage
    
    $ gem install etree
    $ cd ~/Downloads
    $ flac2mp3 ph2010-06-12.flacf/ph2010-06-12.txt
    
Assuming there is a set of flacf files in `~/Downloads/ph2010-06-12.flacf` and `ph2010-06-12.txt` is a text file describing the show, that will create mp3 files in `~/Downloads/ph2010-06-12.mp3f`.

## Copyright

Copyright (c) 2010 Paul Barry. See LICENSE for details.

[homebrew]: http://brew.sh