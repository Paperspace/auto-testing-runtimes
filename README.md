# Auto-testing Gradient Runtimes

# UNDER CONSTRUCTION: Not ready to run yet

The combination of ~10 Gradient runtimes and ~10 machine types gives 100+ combinations of runtime+machine to test, any of which could fail due to particular runtime content and GPUs being incompatible.

Testing 100+ combinations manually every time something is updated is intractable, so this aims to provide automation.

The setup is:

- Use the Gradient CLI to create and run Gradient Notebooks in each runtime+machine combination
- Within the Notebook, run the other scripts from this repo

## Requirements

 - Gradient subscription that allows the number of Notebooks the script creates
 - Gradient CLI on own machine
 - Gradient Project to create Notebooks
 - API key set to access that Project

## To run

On Gradient

- Create Project and get its ID

On your own machine

- Install the Gradient CLI
- Set API key to access your Gradient Project
- Copy `do_run_testing.sh` to your machine [1]
- Add your project ID to `do_run_testing.sh` in the location indicated
- Run it, e.g., `chmod 764 do_run_testing.sh; ./do_run_testing.sh`

**WARNING**: This has the potential to create a lot of Notebooks! The script has a double loop of both runtimes and machines. It's worth viewing it first to get an idea.

[1] No need to clone repo as rest of repo is cloned to the Notebook and used there

## Files

See the comments in the scripts for more details on what each one is doing.

- `do_run_testing.sh` = Top level script to call everything else. Run on own machine. Calls Gradient CLI.
- `run_testing.sh` = Main script run on each Notebook, invoking the specific content for each runtime, testing commands, etc.

## Improvements

The aim so far here is purely to make testing the runtimes+machines tractable. There are likely better ways to software-engineer the testing here over time.

- Workflows: It may be possible to set this up using Gradient Workflows.
- Python: Or possibly with Python rather than shell.
- Notebooks as `.py`: Currently this uses nbconvert to run each `.ipynb` on the Gradient Notebook as a notebook, meaning that the output has to be manually inspected in the notebook view if there are errors. nbconvert can convert `.ipynb`s into `.py`s which then gives us the usual ability to log a `.py`'s output. But this introduces a conversion step that may have errors a user wouldn't see when running the `.ipynb`, and we want to ensure that running our `.ipynb`s is working for users. Also some code in `.ipynb` doesn't work in `.py`, e.g., line and cell magics. We could require our recommended content to be convertible to `.py`, but this might be restrictive.
- Output to non-Notebook location: Completed `.ipynb` notebooks could be output to an external location or other format such as PDF (PDF requires length TeXLive install), but with our improved offline viewing this is less vital now.
- More commands and tests: Likely there are more things that can be tested, so additions to the scripts here can be ongoing.
- The runtimes and machines are hardwired in the `do_run_testing.sh` script. They could be passed as arguments for more flexibility.
