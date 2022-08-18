# Auto-testing Gradient Runtimes

# UNDER CONSTRUCTION: Not ready to run yet

The combination of ~10 Gradient runtimes and ~10 machine types gives 100+ combinations of runtime+machine to test, any of which could fail due to particular runtime content and GPUs being incompatible.

Testing 100+ combinations manually every time something is updated is intractable, so this aims to provide automation.

The setup is:

- Use the Gradient CLI to create and run Gradient Notebooks in each runtime+machine combination
- Within the Notebook, run the other scripts from this repo

## To run

On your own machine

- Install the Gradient CLI
- Copy do_run_testing.sh to your machine
- Run it, e.g., `chmod 764 do_run_testing.sh; ./do_run_testing.sh`

WARNING: This has the potential to create a lot of Notebooks! The script has a double loop of both runtimes and machines. It's worth viewing it first to get an idea.

## Files

See the comments in the scripts for more details on what each one is doing.

- `do_run_testing.sh` = Top level script to call everything else. Run on own machine. Calls Gradient CLI.
- `run_testing.sh` = Main script run on each Notebook, invoking the specific content for each runtime, testing commands, etc.

## Improvements

The aim so far here is purely to make testing the runtimes+machines tractable. There are likely better ways to software-engineer the testing here over time.
