#!/bin/bash

# This is only a subset of all the .ipynbs in the RAPIDS repo

jupyter nbconvert --to notebook --execute /notebooks/rapids/cuml/arima_demo.ipynb             --allow-errors --output-dir /notebooks/auto_testing_results
jupyter nbconvert --to notebook --execute /notebooks/rapids/cuml/forest_inference_demo.ipynb  --allow-errors --output-dir /notebooks/auto_testing_results
jupyter nbconvert --to notebook --execute /notebooks/rapids/cuml/kmeans_demo.ipynb            --allow-errors --output-dir /notebooks/auto_testing_results
jupyter nbconvert --to notebook --execute /notebooks/rapids/cuml/linear_regression_demo.ipynb --allow-errors --output-dir /notebooks/auto_testing_results
jupyter nbconvert --to notebook --execute /notebooks/rapids/cuml/nearest_neighbors_demo.ipynb --allow-errors --output-dir /notebooks/auto_testing_results
jupyter nbconvert --to notebook --execute /notebooks/rapids/cuml/random_forest_demo.ipynb     --allow-errors --output-dir /notebooks/auto_testing_results

jupyter nbconvert --to notebook --execute /notebooks/rapids/xgboost/XGBoost_Demo.ipynb        --allow-errors --output-dir /notebooks/auto_testing_results

echo Testing is done
