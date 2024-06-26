import json
import sys
import requests
from pathlib import Path

BEACONS_API = 'https://www.ebi.ac.uk/pdbe/pdbe-kb/3dbeacons/api/uniprot/summary/'
ALPHAFOLD_API = 'https://alphafold.ebi.ac.uk/api/uniprot/summary/'
S3_API = 'https://s3.amazonaws.com/download.reactome.org/structures/'
UNIPROT_API = 'https://www.ebi.ac.uk/pdbe/graph-api/uniprot/best_structures/'
PDBE_API = 'https://www.ebi.ac.uk/pdbe/graph-api/mappings/best_structures/'

def search(uniprot_id, api):
    url = f'{api}{uniprot_id}' if api == UNIPROT_API else f'{api}{uniprot_id}.json'
    try:
        response = requests.get(url)
        response.raise_for_status()
        data = response.json()
        if api == UNIPROT_API:
            structures = data.get(uniprot_id)
            return structures[0]
        else:
            structures = data.get('structures')
            return structures

    except (requests.RequestException, ValueError) as e:
        if '-' in uniprot_id:
            return search(uniprot_id[:uniprot_id.index('-')], api)
        else:
            return None

def download_file(url, id, location):
    try:
        response = requests.get(url)
        response.raise_for_status()
        name = url.split('/')[-1].split('?')[0]
        file_path = Path(location) / f'{id}{name[-4:]}'
        with file_path.open('wb') as f:
            f.write(response.content)
        return id
    except requests.RequestException as e:
        return None

def extract_information(best_structure):
    chain_ids = []
    if 'entities' in best_structure:
        for entity in best_structure['entities']:
            if 'chain_ids' in entity:
                chain_ids.extend(entity['chain_ids'])
    else:
        if 'chain_id' in best_structure:
            chain_ids.append(best_structure['chain_id'])
    extracted_data = {
        'model_identifier': best_structure.get('model_identifier'),
        'model_category': best_structure['model_category'],
        'model_url': best_structure.get('model_url'),
        'pipeline_version': best_structure.get('pipeline_version'),
        'chain': chain_ids,
        'resolution': best_structure.get('resolution'),
        'coverage': best_structure.get('coverage'),
        'method': best_structure.get('experimental_method') if 'experimental_method' in best_structure else 'null'
    }
    return extracted_data

def process_uniprot_id(uniprot_id, output_dir, version):
    global new_model_url, best_structure
    json_file_url = f'{S3_API}{uniprot_id}.json'

    try:
        response = requests.get(json_file_url)
        response.raise_for_status()
        json_data = response.json()
        saved_model_url = json_data.get('model_url')
        saved_version = json_data.get('pipeline_version')
    except requests.RequestException as e:
        saved_model_url = None
        saved_version = None

    video_exists = all(requests.head(f'{S3_API}{uniprot_id}.{extension}').status_code == 200
                       for extension in ['webm', 'mov'])
    process = True
    structures_alpha = search(uniprot_id, ALPHAFOLD_API)
    if structures_alpha:
        best_structure = structures_alpha[0].get('summary')
        new_model_url = best_structure.get('model_url')
    else:
        structures_pdb = search(uniprot_id, PDBE_API)
        if structures_pdb:
            best_structure = structures_pdb
            pdb_id = best_structure.get('pdb_id')
            new_model_url = f'https://www.ebi.ac.uk/pdbe/static/entry/{pdb_id}_updated.cif'
            best_structure['model_url'] = new_model_url
            best_structure['model_identifier'] = pdb_id
        else:
            structures_3d = search(uniprot_id, BEACONS_API)
            if structures_3d:
                structures_3d.sort(key=lambda s: s.get('summary').get('coverage'), reverse=True)
                best_structure = structures_3d[0].get('summary')
                new_model_url = best_structure.get('model_url')
            else:
                process = False
                if requests.head(f'{S3_API}NoStructure_{uniprot_id}.txt').status_code != 200:
                    file_path = Path(output_dir) / 'files'
                    file_path.mkdir(parents=True, exist_ok=True)
                    no_structure_path = Path(output_dir) / 'files' / f'NoStructure_{uniprot_id}.txt'
                    with open(no_structure_path, 'a') as no_structure:
                        no_structure.write(f'{uniprot_id}\n')

    if process:
        if new_model_url != saved_model_url or version != saved_version or not video_exists:
            file_path = Path(output_dir) / 'files'
            file_path.mkdir(parents=True, exist_ok=True)
            json_file_path = Path(output_dir) / 'files' / f'{uniprot_id}.json'
            download_file(new_model_url, uniprot_id, output_dir)
            best_structure['pipeline_version'] = version
            with json_file_path.open('w') as json_summary:
                json.dump(extract_information(best_structure), json_summary)
        else:
            return True

def main(uniprot_id_file, output_dir, version):
    process_uniprot_id(uniprot_id_file, output_dir, version)

if __name__ == '__main__':
    if len(sys.argv) != 4:
        sys.exit(1)
    uniprot_id_file, output_dir, version = sys.argv[1:]
    main(uniprot_id_file, output_dir, version)