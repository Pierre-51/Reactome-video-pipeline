#!/bin/bash
/Users/psinquin/Desktop/3DstructurePipeline/cypher-shell-5.19.0/bin/cypher-shell -u neo4j -p neo4j12345 -a bolt://localhost:7688 -f /Users/psinquin/Desktop/3DstructurePipeline/queryCyph.cyp > output.txt && tail -n +2 output.txt | sed 's/"//g' > uniProtID.txt
rm -rf output.txt
