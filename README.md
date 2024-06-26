# Nextflow Pipeline for PDB File Processing

This pipeline automates the process of querying a Neo4j database, downloading structures, rendering videos, and uploading files to an S3 bucket. The pipeline is managed using Nextflow, and requires `cypher-shell` to interact with the Neo4j database.

## Prerequisites

Before running this pipeline, ensure you have the following installed:

1. **Nextflow**: Follow the installation instructions on the [Nextflow website](https://www.nextflow.io/docs/latest/getstarted.html#installation).
2. **Cypher Shell**: This is required to run Cypher queries against the Neo4j database. Download it from the [Neo4j website](https://neo4j.com/download-center/#cypher-shell).

## Pipeline Parameters

- `params.output`: Directory where PDB files will be saved (default: "PDB_files").
- `params.cypherScript`: Path to the Cypher query script (default: "queryCyph.cyp").
- `params.version`: Version of the pipeline (default: "0.1").
- `address`: Address of the Neo4j database (default: "bolt://localhost:7688").

## Workflow

The pipeline consists of several processes:

### 1. Neo4j Query (`neo4j`)

Queries the Neo4j database using a Cypher script and extracts UniProt IDs.

**Output**: `uniProtID.txt`

### 2. Search and Download Structure (`searchAndDownloadStructure`)

Searches for PDB structures using the extracted UniProt IDs and downloads them.

**Inputs**: `uniProtID`
**Outputs**:
- PDB structure files (`${params.output}/${uniProtID}.cif`)
- Additional files in `${params.output}/files/`

### 3. Molstar Rendering (`molstar`)

Renders images of PDB structures using Mol*.

**Inputs**: PDB structure files (`*.cif`)
**Outputs**: Rendered images in `output_molstar/`

### 4. S3 JSON Upload (`s3_json`)

Uploads JSON files to an S3 bucket.

**Inputs**: `path_s`
**Outputs**: Files uploaded to `s3://download.reactome.org/structures/`

### 5. S3 Videos Upload (`s3_videos`)

Uploads video files to an S3 bucket.

**Inputs**: `path_m`
**Outputs**: Files uploaded to `s3://download.reactome.org/structures/`

## Running the Pipeline

1. **Configure Nextflow**: Ensure Nextflow is properly installed and configured on your system.
2. **Prepare Cypher Script**: Create or modify the Cypher script (`queryCyph.cyp`) that contains the query to extract UniProt IDs.
3. **Run Nextflow**: Execute the following command to start the pipeline:

    ```bash
    nextflow run main.nf
    ```

## Example Cypher Script (`queryCyph.cyp`)

An example Cypher script to extract UniProt IDs might look like this:

```cypher
MATCH (n:Protein)
RETURN n.uniProtID
```

## Customization

- Modify the `params.output` parameter to change the output directory.
- Update the `params.cypherScript` parameter to point to your custom Cypher script.
- Adjust the `address` parameter if your Neo4j database is running on a different address or port.

## Notes

- Ensure that the Neo4j database is running and accessible at the specified address.
- Make sure AWS CLI is configured with the appropriate permissions to upload files to the specified S3 bucket.
- The `molstar` process assumes that `webm_renderer.js` from the Mol* library is available at the specified path.

For any issues or questions, please refer to the [Nextflow documentation](https://www.nextflow.io/docs/latest/index.html) or the relevant tool documentation.
