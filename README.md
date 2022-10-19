# Auto-testing Gradient Runtimes

Last updated: Oct 19th 2022

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

See `improvements.md`.
