require 'rdf'
#require 'rdf/raptor'
require 'sparql'
#require 'sparql-client'
require 'net/http'
require 'openssl'
require 'linkeddata'

graph = RDF::Graph.load("foaf.rdf")
puts graph.inspect

query = "
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
SELECT DISTINCT ?o
 WHERE { ?s foaf:knows ?o }
"
puts "beforeloading"
sse = SPARQL.parse(query)
sse.execute(graph) do |result|
 puts result.o
 triples = RDF::Resource(RDF::URI.new(result.o))
 graph.load(triples)
end
puts "afterloading"
sse.execute(graph) do |result|
 puts result.o
end

interest_query = "
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
SELECT DISTINCT ?interest
  WHERE { ?s foaf:interest ?interest}
"
puts "interests"
q_parsed = SPARQL.parse(interest_query)
q_parsed.execute(graph) do |result|
  puts result.interest
end

tmp_query = "PREFIX foaf: <http://xmlns.com/foaf/0.1/>
  PREFIX dbo: <http://dbpedia.org/ontology/>
  SELECT ?abs
    WHERE { ?s dbo:abstract ?abs
           FILTER (lang(?abs) = 'en')}"

tmp_graph = RDF::Graph.load("http://dbpedia.org/resource/Elvis_Presley")
sse_abstracts = SPARQL.parse(tmp_query)
sse_abstracts.execute(tmp_graph) do |result|
  puts result.abs
end




# bess_rdf = RDF::Resource(RDF::URI.new("http://www.stanford.edu/~laneymcg/laney.rdf"))
#
# hacker_nt = RDF::Resource(RDF::URI.new("http://www.stanford.edu/~arcadia/foaf.rdf"))
#
# # Load multiple RDF files into the same RDF::Repository object
# queryable = RDF::Repository.load(hacker_nt)
# queryable.load(bess_rdf)
#
# sse = SPARQL.parse(query)
# sse.execute(queryable) do |result|
#  puts result.o
# end
