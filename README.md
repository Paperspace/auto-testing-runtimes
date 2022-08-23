# Auto-testing Gradient Runtimes

Last updated: Aug 22nd 2022

The combination of ~10 Gradient runtimes and ~10 machine types gives 100+ combinations of runtime+machine to test, any of which could fail due to particular runtime content and GPUs being incompatible, or becoming so due to some update.

Testing 100+ combinations manually every time something is updated is intractable, so this repo automates the testing.

The setup is:

- Use the Gradient CLI to create and run Gradient Notebooks in each valid runtime+machine combination
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
- Add your project ID to `do_run_testing.sh` in the location indicated
- Run it, e.g., `chmod 764 do_run_testing.sh; ./do_run_testing.sh <runtime>`, where `<runtime>` is one of the names displayed in the runtime tiles in the GUI Notebook create page, e.g., "PyTorch 1.12"

**WARNING**: This has the potential to create a lot of Notebooks! The script is invoked with a given runtime to reduce this, e.g., the example command shown will create N Notebooks for our M different machine types, which might be ~ 20.

[1] It's not required to clone this repo as the rest of it is cloned to the Notebook and used there

## Files

See the comments in the scripts for more details on what each one is doing.

- `do_run_testing.sh` = Top level script to call everything else. Run on own machine. Calls Gradient CLI.
- `run_testing.sh` = Generic tests applicable to all Notebooks.
- `run_testing.py` = Same, for Python
- `run_testing.ipynb` = Same, for Jupyter
- `run_testing_pt112.sh`, etc. = Tests specific to each runtime, i.e., run its `.ipynb` content

## Improvements

The aim so far here is purely to make testing the runtimes+machines tractable. There are likely better ways to software-engineer the testing here over time.

- Better framework: CLI YAML options files, Workflows, or Python may improve upon the master-shell-script setup here
- Notebooks as `.py`: Currently this uses nbconvert to run each `.ipynb` on the Gradient Notebook as a notebook, meaning that the output has to be manually inspected in the notebook view if there are errors. nbconvert can convert `.ipynb`s into `.py`s which then gives us the usual ability to log a `.py`'s output. But this introduces a conversion step that may have errors a user wouldn't see when running the `.ipynb`, and we want to ensure that running our `.ipynb`s is working for users. Also some code in `.ipynb` doesn't work in `.py`, e.g., line and cell magics. We could require our recommended content to be convertible to `.py`, but this might be restrictive.
- Output to non-Notebook location: Completed `.ipynb` notebooks could be output to an external location or other format such as PDF (PDF requires a lengthy TeXLive install), and the created Notebook then stopped or deleted rather than left open. `nbconvert` can also pick up whether or not a notebook errored (although the errors themselves would still need to be looked at).
- More commands and tests: Likely there are more things that can be tested, so additions to the scripts here can be ongoing.
- The runtimes and machines are hardwired in the `do_run_testing.sh` script. It is probably possible to passed more things through as arguments to reduce hardwiring, which is error-prone.
 - Notebooks that require the user to take some manual action first such as mounting a Gradient Dataset won't work, but these are a small minority

The comments in the scripts also mention a few details where things can be improved.
