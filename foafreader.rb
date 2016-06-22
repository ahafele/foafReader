require 'rdf'
require 'rdf/raptor'
require 'sparql'
require 'net/http'
require 'openssl'
require 'linkeddata'

graph = RDF::Graph.load("foaf.rdf")

 puts graph.inspect
