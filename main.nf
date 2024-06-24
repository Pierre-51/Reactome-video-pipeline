// main.nf

params.output = "PDB_files"
params.cypherScript = "queryCyph.cyp"
params.version = "0.1"
address = "bolt://localhost:7688"
// address = "bolt://neo4j:7687"
output = file(params.output)
queryCyph = file(params.cypherScript)

process neo4j {
    output:
        path "uniProtID.txt"

    script:
    """
    #!/bin/bash
    ${baseDir}/cypher-shell-5.19.0/bin/cypher-shell -u neo4j -p neo4j12345 -a ${address} -f ${queryCyph} > output.txt && tail -n +2 output.txt | sed 's/"//g' > uniProtID.txt
    rm -rf output.txt
    """
}

process searchAndDownloadStructure {

    input:
        val uniProtID

    output:
        path "${params.output}/${uniProtID}.cif", optional: true
        path "${params.output}/files/", optional: true

    script:
    """
    #!/bin/bash
    mkdir -p ${params.output}
    python3 ${baseDir}/search_pdb.py ${uniProtID} ${params.output} ${params.version}
    """
}

process molstar {

    input:
        path cifFile

    output:
        path "output_molstar/", optional: true

    script:
    """
    #!/bin/bash
    mkdir -p output_molstar/
    if [ -f "${cifFile}" ]; then
        node $baseDir/molstar/lib/commonjs/examples/image-renderer/webm_renderer.js ${cifFile} output_molstar/
        rm -d ${cifFile}
    fi
    """
}

process s3_json {
    input:
        path path_s

    script:
    """
    #!/bin/bash
    aws s3 sync ${path_s} s3://download.reactome.org/structures/ --only-show-errors
    """
}
process s3_videos {
    input:
        path path_m

    script:
    """
    #!/bin/bash
    aws s3 sync ${path_m} s3://download.reactome.org/structures/ --only-show-errors
    """
}
// process delete_noStructure_file {
//     script:
//     """
//     #!/bin/bash
//     aws s3 rm s3://download.reactome.org/structures/noStructure.txt --only-show-errors
//     """
// }
workflow {
    neo4j_out = neo4j()
    neo4j_out.splitText()
       .map { it.trim() }
       .set { uniProtIDs }
    (file, path_s) = searchAndDownloadStructure(uniProtIDs)
    s3_json(path_s)
    path_m = molstar(file)
    s3_videos(path_m)
}



