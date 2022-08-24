#!/bin/bash

jupyter nbconvert --to notebook --execute /notebooks/PixelDraw.ipynb --allow-errors --output-dir /notebooks/auto_testing_results

echo Testing is done
