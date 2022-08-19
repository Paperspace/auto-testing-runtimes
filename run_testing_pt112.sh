#!/bin/bash

jupyter nbconvert --to notebook --execute quick_start_pytorch.ipynb --allow-errors --output-dir results

echo Testing is done
