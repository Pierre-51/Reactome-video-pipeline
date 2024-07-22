// main.nf

output = file(params.output)
queryCyph = file(params.cypherScript)

process neo4j {
    output:
        path "uniProtID.txt"

    script:
    """
    #!/bin/bash
    ${baseDir}/cypher-shell-${params.cypherShell_version}/bin/cypher-shell -a ${params.address} -u ${params.user} -p ${params.password} -f ${queryCyph} > output.txt && tail -n +2 output.txt | sed 's/"//g' > uniProtID.txt

    rm -rf output.txt
    """
}
process searchAndDownloadStructure {

    input:
        val uniProtID

    output:
        path "${params.output}/${uniProtID}.*", optional: true
        path "${params.output}/files/", optional: true

    script:
    """
    #!/bin/bash
    mkdir -p ${params.output}
    python3 ${baseDir}/search_pdb.py ${uniProtID} ${params.output} ${params.version} ${baseDir}
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
process s3_file {
    input:
        val toto
    script:
    """
    #!/bin/bash
    aws s3 sync ${baseDir}/no-structure.txt s3://download.reactome.org/structures/ --only-show-errors
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

workflow {
    neo4j_out = neo4j()
    neo4j_out.splitText()
       .map { it.trim() }
       .set { uniProtIDs }
    (file, path_s) = searchAndDownloadStructure(uniProtIDs)
    s3_json(path_s)
    path_m = molstar(file)
    s3_videos(path_m)
    s3_file(file.collect())
}
