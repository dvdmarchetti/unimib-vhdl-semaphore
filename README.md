# Informatica Industriale A.A. 2019/2020
Final project for "Informatica Industriale" course.

## Traffic Light
Design and implement a digital system to manage the internals of a semaphore (with three lights: red, yellow and green).

The semaphore has three operational conditions:

- **Nominal**: red light is on for 5 seconds, then green light is on for 5 seconds, then green and yellow lights are on for 2 seconds.
- **Standby**: red and green lights are off, while the yellow light is blinking 1 second on and 2 seconds off.
- **Maintenance**: all the lights are turned on. This mode allows to pick a standby operational mode behaviour:
  - **MOD0**: the default operational condition explained above.
  - **MOD1**: red and green alternate blinking for one second each, meanwhile yellow is off.
  - **MOD_AUTO**: red and green alternate blinking for one second each, meanwhile yellow is off. After 10 seconds, the system switches automatically to the nominal operational mode.

## Code Linting
VHDL code linting is performed with the [vsg](https://github.com/jeremiah-c-leary/vhdl-style-guide) python tool.

To install it in a virtualenv execute the following commands, then refer to vsg's documentation for more in-depth usage:
```sh
virtualenv venv
./venv/scripts/activate
pip install -r requirements.txt
vsg -f ./semaphore.vhd --fix
```
