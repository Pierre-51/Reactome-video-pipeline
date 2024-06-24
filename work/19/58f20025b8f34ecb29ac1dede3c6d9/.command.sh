#!/bin/bash
aws s3 sync files s3://download.reactome.org/structures/ --only-show-errors
