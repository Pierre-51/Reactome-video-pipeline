#!/bin/bash
mkdir -p output_molstar/
if [ -f "Q9UNE7.cif" ]; then
    node /Users/psinquin/Desktop/3DstructurePipeline/molstar/lib/commonjs/examples/image-renderer/webm_renderer.js Q9UNE7.cif output_molstar/
    rm -d Q9UNE7.cif
fi
