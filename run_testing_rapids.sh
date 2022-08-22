#!/bin/bash

#jupyter nbconvert --to notebook --execute /notebooks/ ... .ipynb --allow-errors --output-dir /notebooks/auto_testing_results

# This is only a subset of all the .ipynbs in the RAPIDS repo

jupyter nbconvert --to notebook --execute /notebooks/rapids/cuml/arima_demo.ipynb
jupyter nbconvert --to notebook --execute /notebooks/rapids/cuml/forest_inference_demo.ipynb
jupyter nbconvert --to notebook --execute /notebooks/rapids/cuml/kmeans_demo.ipynb
jupyter nbconvert --to notebook --execute /notebooks/rapids/cuml/linear_regression_demo.ipynb
jupyter nbconvert --to notebook --execute /notebooks/rapids/cuml/nearest_neighbors_demo.ipynb
jupyter nbconvert --to notebook --execute /notebooks/rapids/cuml/random_forest_demo.ipynb

jupyter nbconvert --to notebook --execute /notebooks/rapids/xgboost/XGBoost_Demo.ipynb

echo Testing is done
