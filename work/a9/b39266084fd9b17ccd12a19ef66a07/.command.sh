#!/bin/bash
mkdir -p output_molstar/
if [ -f "Q99459.cif" ]; then
    node /Users/psinquin/Desktop/3DstructurePipeline/molstar/lib/commonjs/examples/image-renderer/webm_renderer.js Q99459.cif output_molstar/
    rm -d Q99459.cif
fi
