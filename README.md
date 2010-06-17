RDF/JSON Support for RDF.rb
===========================

This is an [RDF.rb][] plugin that adds support for parsing/serializing the
[RDF/JSON][] serialization format.

* <http://github.com/bendiken/rdf-json>
* <http://blog.datagraph.org/2010/04/parsing-rdf-with-ruby>

Documentation
-------------

* {RDF::JSON}
  * {RDF::JSON::Format}
  * {RDF::JSON::Reader}
  * {RDF::JSON::Writer}
  * {RDF::JSON::Extensions}

Dependencies
------------

* [RDF.rb](http://rubygems.org/gems/rdf) (>= 0.2.0)
* [JSON](http://rubygems.org/gems/json_pure) (>= 1.4.3)

Installation
------------

The recommended installation method is via [RubyGems](http://rubygems.org/).
To install the latest official release of the `RDF::JSON` gem, do:

    % [sudo] gem install rdf-json

Download
--------

To get a local working copy of the development repository, do:

    % git clone git://github.com/bendiken/rdf-json.git

Alternatively, you can download the latest development version as a tarball
as follows:

    % wget http://github.com/bendiken/rdf-json/tarball/master

Author
------

* [Arto Bendiken](mailto:arto.bendiken@gmail.com) - <http://ar.to/>

License
-------

`RDF::JSON` is free and unencumbered public domain software. For more
information, see <http://unlicense.org/> or the accompanying UNLICENSE file.

[RDF.rb]:   http://rdf.rubyforge.org/
[RDF/JSON]: http://n2.talis.com/wiki/RDF_JSON_Specification
