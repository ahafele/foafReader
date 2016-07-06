require 'rdf'
#require 'rdf/raptor'
require 'sparql'
#require 'sparql-client'
require 'net/http'
require 'openssl'
require 'linkeddata'

graph = RDF::Graph.load("foaf.rdf") #loading my foaf.rdf file as a graph using the rdf gem with the graph object and load method?
puts graph.inspect #outputing the graph with the inspect method?

#sets variable query to output of sparql query
query = "
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
SELECT DISTINCT ?o
 WHERE { ?s foaf:knows ?o }
"
#query that graph (HOW DOES IT KNOW TO QUERY THAT GRAPH?) for distinct objects of the predicate foaf:knows. The objects of the "knows" statements in the foaf.rdf file

puts "beforeloading" #outputs text beforeloading
sse = SPARQL.parse(query) #creates the variable sse and sets it to the output of parsing the above sparql query. USES THE SPARQL OBJECT? OR CALLS THE SPARQL GEM IN ORDER TO USE PARSE?
sse.execute(graph) do |result| #??
 puts result.o #outputs results of above query
 triples = RDF::Resource(RDF::URI.new(result.o)) #puts the triples into variable triple
 graph.load(triples) #loads these triples to our graph
end
puts "afterloading" #outputs text afterloading
sse.execute(graph) do |result| #??
 puts result.o
end

#sparql query for evreyones interests
interest_query = "
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
SELECT DISTINCT ?interest
  WHERE { ?s foaf:interest ?interest}
"
#query our graphy for all the objects (?interest) of predicate foaf:interest
puts "interests" #outputs text interests
q_parsed = SPARQL.parse(interest_query) #parse the query and put it in variable q_parsed.
q_parsed.execute(graph) do |result| #??
  puts result.interest #output results of interest_query? OR OUTPUTS objects ?interest ??
end

tmp_query = "
  PREFIX foaf: <http://xmlns.com/foaf/0.1/>
  PREFIX dbo: <http://dbpedia.org/ontology/>
  SELECT ?abs
    WHERE { ?s dbo:abstract ?abs
           FILTER (lang(?abs) = 'en')}
  "
#this is a query on the below graph. looking for abstracts where predicate is dbo:abstract
tmp_graph = RDF::Graph.load("http://dbpedia.org/resource/Elvis_Presley") #create temp_graph with elvis presley resource
sse_abstracts = SPARQL.parse(tmp_query) #parse the results of above query
sse_abstracts.execute(tmp_graph) do |result| #call that graph here.
  puts result.abs #output results
end
