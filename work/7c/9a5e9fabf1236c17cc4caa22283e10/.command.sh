#!/bin/bash
mkdir -p output_molstar/
if [ -f "Q5S007.cif" ]; then
    node /Users/psinquin/Desktop/3DstructurePipeline/molstar/lib/commonjs/examples/image-renderer/webm_renderer.js Q5S007.cif output_molstar/
    rm -d Q5S007.cif
fi
