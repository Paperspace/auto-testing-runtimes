# Auto-testing Gradient Runtimes

Last updated: Sep 01st 2022

The combination of 10+ Gradient runtimes and 10+ machine types gives 100+ combinations of runtime+machine to test, any of which could fail due to particular runtime content and GPUs being incompatible, or becoming so due to some update.

Testing 100+ combinations manually every time something is updated is intractable, so this repo automates the testing.

The setup is:

- Use the Gradient CLI on your machine to create and run Gradient Notebooks in each valid runtime+machine combination
- Within the Notebook, run the other scripts from this repo

## Requirements

 - Gradient subscription that allows the number of Notebooks the script creates
 - Gradient CLI on own machine
 - Gradient Project in which to create Notebooks
 - API key set to access that Project

## To run

On Gradient

- Create Project and get its ID

On your own machine

- Install the Gradient CLI
- Set API key to access your Gradient Project
- Copy `do_run_testing.sh` to your machine [1]
- Run it, e.g.,

```
chmod 764 do_run_testing.sh
./do_run_testing.sh "<runtime>" "<projectId>"
```

where `<runtime>` is one of the names displayed in the runtime tiles in the GUI Notebook create page, e.g., `PyTorch 1.12`.

The full usage is

```
./do_run_testing.sh [-c "<clusterId>" -w "<workspaceRef>"] "<runtime>" "<projectId>"
```

where `<clusterId>` and `<workspaceRef>` are options to point to a cluster other than the default and a non-master branch of the runtime's GitHub repo, aka. workspace.

**WARNING**: This has the potential to create a lot of Notebooks! In total for all runtimes it would be up to R*M for R runtimes and M machines, so 10+ * 10+ = 100+. The script is invoked with a given runtime to reduce this, e.g., the example command shown will be R=1 and thus create just M Notebooks (10+ not 100+).

[1] It's not required to clone this repo as the rest of it is cloned to the Notebook and used there

## Files

The above is enough to be able to run everything. The scripts have comments in them with more details on what they are doing.

- `do_run_testing.sh` = Top level script to call everything else. Run on own machine. Calls Gradient CLI.
- `run_testing.sh` = Generic tests applicable to all Notebooks.
- `run_testing.py` = Same, for Python
- `run_testing.ipynb` = Same, for Jupyter
- `specific/run_testing_pt112.sh`, etc. = Tests specific to each runtime, i.e., run its `.ipynb` content

## Improvements

The aim here is to make testing the runtimes+machines tractable. There are likely better ways to software-engineer the testing here over time.

- Better framework: CLI YAML options files, Workflows, or Python may improve upon the master-shell-script setup here.
- Notebooks as `.py`: Currently this uses `nbconvert` to run each `.ipynb` on the Gradient Notebook as a notebook, meaning that the output has to be manually inspected in the notebook view if there are errors. nbconvert can convert `.ipynb`s into `.py`s which then gives us the usual ability to log a `.py`'s output. But this introduces a conversion step that may have errors a user wouldn't see when running the `.ipynb`, and we want to ensure that running our `.ipynb`s is working for users. Also some code in `.ipynb` doesn't work in `.py`, e.g., line and cell magics. We could require our recommended content to be convertible to `.py`, but this might be restrictive.
- Output to non-Notebook location: Completed `.ipynb` notebooks could be output to an external location or other format such as PDF (PDF requires a lengthy TeXLive install), and the created Notebook then stopped or deleted rather than left open. `nbconvert` can also pick up whether or not a notebook errored (although the errors themselves would still need to be looked at).
- More commands and tests: Likely there are more things that can be tested, so additions to the scripts here can be ongoing.
- The runtimes and machines settings are hardwired in the `do_run_testing.sh` script. It is probably possible to use separate configuration files, or the CLI's `--optionsFile`.
- Notebooks that require the user to take some manual action first such as mounting a Gradient Dataset won't work, but these are minority.
- Nice-to-have would be to create one Notebook for each runtime and run it for all machineS. This would avoid creating a large number of Notebooks. But using gradient notebooks create, stop, and start same ID with different machine still creates a new one each time, leaving just as many.
- `gradient notebooks metrics get` would add information about GPU usage.
- Papermill & Forego might improve the setting up of commands to run when the Notebook is started.

These improvements can be moved to issues (label as enhancements) for this repo.
