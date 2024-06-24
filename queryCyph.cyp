//MATCH (n:Pathway {hasDiagram:TRUE, hasEHLD:FALSE})-[:hasEvent|input|output|catalystActivity|physicalEntity|entityFunctionalStatus|diseaseEntity|regulatedBy|regulator*]->(m:PhysicalEntity)-[:referenceEntity]->(re:ReferenceEntity)
//OPTIONAL MATCH (re)<-[:interactor]-(ii:Interaction)-[:interactor]->(i:ReferenceEntity)
//WITH re, i, ii
//  ORDER BY re DESC, ii.score DESC
//WITH re, COLLECT( distinct i )[0..18] AS topInteractors
//UNWIND topInteractors as i
//WITH COLLECT(DISTINCT re) + COLLECT(DISTINCT i) AS allRe
//UNWIND allRe AS re
//WITH re
//  WHERE re:ReferenceGeneProduct
//return COUNT(DISTINCT COALESCE(re.variantIdentifier, re.identifier))
//LIMIT 100
//1500620
MATCH (n:Pathway {stId: 'R-HSA-9615710'})
        -[:hasEvent|input|output|catalystActivity|physicalEntity|entityFunctionalStatus|diseaseEntity|regulatedBy|regulator*]->(m:PhysicalEntity)
        -[:referenceEntity]->(re:ReferenceEntity)
OPTIONAL MATCH (re)<-[:interactor]-(ii:Interaction)-[:interactor]->(i:ReferenceEntity)
WITH re, i, ii
  ORDER BY re DESC, ii.score DESC
WITH re, collect(DISTINCT i)[0..18] AS topInteractors
UNWIND topInteractors AS i
WITH collect(DISTINCT re) + collect(DISTINCT i) AS allRe
UNWIND allRe AS re
WITH re
  WHERE re:ReferenceGeneProduct
RETURN DISTINCT coalesce(re.variantIdentifier, re.identifier)




