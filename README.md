# Nextflow Pipeline for Cif/Pdb File Processing

This pipeline automates the process of querying a Neo4j database, downloading structures, rendering videos, and
uploading files to an S3 bucket. The pipeline is managed using Nextflow, and requires `cypher-shell` to interact with
the Neo4j database.

## Prerequisites

Before running this pipeline, ensure you have the following installed:

1. **Neo4j**: Follow the instruction to install the docker [Neo4j Reactome database](https://reactome.org/download-data), don't
   forget to run it. If you want to use a Neo4j Deskop modify the address in nextflow.config. 
2. **Nextflow**: Follow the installation instructions on
   the [Nextflow website](https://www.nextflow.io/docs/latest/getstarted.html#installation).
   Java is required.
4. **Cypher Shell**: This is required to run Cypher queries against the Neo4j database. Download it from
   the [Neo4j website](https://neo4j.com/deployment-center/?cypher-shell#tools-tab).
5. **Molstar**: Before installing the Mol* packages, be sure to have nodes.js (17+) installed. You must have python and python3 installed. The way to do it depend of your configuration, check on the web.
Install all of these packages. 
```bash
apt-get update && sudo apt-get install -y \
    default-jre \
    wget \
    unzip \
    net-tools \
    ffmpeg \
    pkg-config \
    libx11-dev \
    libxi-dev \
    libcairo2-dev \
    libpango1.0-dev \
    libjpeg-dev \
    libgif-dev \
    librsvg2-dev \
    build-essential \
    libglx-dev \
    libgl-dev \
    libgl1-mesa-glx \
    libgl1-mesa-dri \
    xvfb \
    libsm6 \
    libxext6 \
    libgl1-mesa-dev \
    libosmesa6-dev \
    xorg \
    xserver-xorg \
    libxext-dev \
    libglapi-mesa \
    mesa-utils \
```
Then you can run : 
```bash
   cd molstar
   npm install 
   npm run rebuild
   cd ../
```

5. **AWS**: Ensure the connection with an [AWS s3](https://aws.amazon.com/s3/) server.
```bash
aws credential
```
7. Before launching the pipeline, you may need to install requests python package.
```bash
   python3 -m pip install requests
```
   
## Pipeline Parameters

- `output`: Directory where PDB files will be saved (default: "Cif_files").
- `cypherScript`: Path to the Cypher query script (default: "queryCyph.cyp").
- `version`: Version of the pipeline (default: "0.1").
- `cyphershell_version`: Version of the CypherShell (default: "5.21.0")
- `address`: Address of the Neo4j database (default: "bolt://localhost:7687").

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
2. **Prepare Cypher Script**: Create or modify the Cypher script (`queryCyph.cyp`) that contains the query to extract
   UniProt IDs.
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

## Notes

- Ensure that the Neo4j database is running and accessible at the specified address.
- Make sure AWS CLI is configured with the appropriate permissions to upload files to the specified S3 bucket.
- The `molstar` process assumes that `webm_renderer.js` from the Mol* library is available at the specified path.

For any issues or questions, please refer to
the [Nextflow documentation](https://www.nextflow.io/docs/latest/index.html) or the relevant tool documentation.
