etree
=====

This is a port of the [Perl Etree Scripts](http://etree-scripts.sourceforge.net/) to Ruby.  This scripts can be used to download the flac source of audience recording of a concert from a site like [http://bt.etree.org](http://bt.etree.org) or [The Live Music Archive](http://www.archive.org/details/audio) and convert it to mp3s.  Very much a work in progress at this point.

Requirements
------------

You will need `flac` and `lame` installed in order to use this.  You can install them both from macports:

    $ sudo port install flac
    $ sudo port install lame

Usage
-----
    
    $ git clone git://github.com/pjb3/etree.git
    $ cd etree
    $ gem build etree.gemspec
    $ gem install etree*.gem
    $ cd ~/Downloads
    $ flac2mp3 ph2010-06-12.flacf
    
Assuming there is a set of flacf files in `~/Downloads/ph2010-06-12.flacf` and a text file describing the show, that will create mp3 files in `~/Downloads/ph2010-06-12.mp3f`.

Copyright
---------

Copyright (c) 2010 Paul Barry. See LICENSE for details.
