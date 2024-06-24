#!/bin/bash
aws s3 sync output_molstar s3://download.reactome.org/structures/ --only-show-errors
