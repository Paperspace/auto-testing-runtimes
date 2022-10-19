## Improvements

Last updated: Oct 19th 2022

The aim here is to make testing the runtimes+machines tractable rather than engineer in the best possible way. Nevertheless, there are various improvements we can add over time. Listed roughly in priority order.

- Multi-GPU machines and CPU machines are not yet tested.
- Machines only on particular subscriptions such as Free-GPU are not yet tested.
- Include notebook rerun on test and rerun+kernel restart
- More commands and tests: there are more things that can be tested, e.g., `nvidia-smi -q`, `locate cuda`, so additions to the scripts here can be ongoing.
- Notebooks that require the user to take some manual action first such as mounting a Gradient Dataset won't work, but these are a minority.
- `nbconvert` can pick up whether or not a notebook errored, meaning notebooks that didn't error wouldn't have to be inspected if we trust they are OK. Ones with errors would still need to be looked at.
- Better framework: CLI YAML options file (`--optionsFile`), Workflows, or Python may improve upon the master-shell-script setup here.
- Nice-to-have would be to create one Notebook for each runtime and run it for all machines. This would avoid creating a large number of Notebooks. But using gradient notebooks create, stop, and start same ID with different machine still creates a new one each time, leaving just as many.
- PDF output also works and could be saved to a remote location without the need to access the Notebook to inspect the results. But it requires a slow TeXLive install [1], and our Notebooks can be viewed offline.
- Notebooks as `.py`: Currently this uses `nbconvert` to run each `.ipynb` on the Gradient Notebook as a notebook, meaning that the output has to be manually inspected in the notebook view if there are errors. `nbconvert` and `jupytext` can convert `.ipynb`s into `.py`s which then gives us the usual ability to log a `.py`'s output. But this introduces a conversion step that may have errors a user wouldn't see when running the `.ipynb`, and we want to ensure that running our `.ipynb`s is working for users. Also some code in `.ipynb` doesn't work in `.py`, e.g., line and cell magics. We could require our recommended content to be convertible to `.py`, but this might be restrictive.
- Papermill & Forego might improve the setting up of commands to run when the Notebook is started, e.g., a notebook can be executed with arguments such as a required API key.
- Auto-testing doesn't pick up issues from rerunning a notebook without restarting the kernel, because the kernel is in effect restarted because each notebook is run separately with its own `nbconvert` command. An example is a GPU going out of memory if the user tries to rerun it and didn't reset the kernel to clear the memory allocation. This is an edge case.

These improvements could also be moved to issues (label as enhancements) for this repo.

[1]

```
apt-get update
apt-get install -y pandoc
apt-get install -y texlive-xetex texlive-fonts-recommended texlive-plain-generic
jupyter nbconvert --to pdf --execute quick_start_pytorch.ipynb --allow-errors --output-dir pdf
```
