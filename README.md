RDF/JSON Support for RDF.rb
===========================

This is an [RDF.rb][] plugin that adds support for parsing/serializing
[RDF/JSON][], a simple JSON-based RDF serialization format.

* <http://github.com/bendiken/rdf-json>
* <http://blog.datagraph.org/2010/04/parsing-rdf-with-ruby>

[![Gem Version](https://badge.fury.io/rb/rdf-json.png)][gem]
[![Build Status](https://travis-ci.org/ruby-rdf/rdf-json.png)](https://travis-ci.org/ruby-rdf/rdf-json)

Documentation
-------------

* {RDF::JSON}
  * {RDF::JSON::Format}
  * {RDF::JSON::Reader}
  * {RDF::JSON::Writer}
  * {RDF::JSON::Extensions}

Dependencies
------------

* [RDF.rb](http://rubygems.org/gems/rdf) (>= 1.1.0)
* [JSON](http://rubygems.org/gems/json_pure) (>= 1.7.7)

Installation
------------

The recommended installation method is via [RubyGems](http://rubygems.org/).
To install the latest official release of the `RDF::JSON` gem, do:

    % [sudo] gem install rdf-json

Download
--------

To get a local working copy of the development repository, do:

    % git clone git://github.com/bendiken/rdf-json.git

Alternatively, download the latest development version as a tarball as
follows:

    % wget http://github.com/bendiken/rdf-json/tarball/master

Mailing List
------------

* <http://lists.w3.org/Archives/Public/public-rdf-ruby/>

Author
------

* [Arto Bendiken](http://github.com/bendiken) - <http://ar.to/>

Contributors
------------

Refer to the accompanying {file:CREDITS} file.

License
-------

This is free and unencumbered public domain software. For more information,
see <http://unlicense.org/> or the accompanying {file:UNLICENSE} file.

[RDF.rb]:   http://rdf.rubyforge.org/
[RDF/JSON]: http://n2.talis.com/wiki/RDF_JSON_Specification
