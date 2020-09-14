## Traffic Light
### Informatica Industriale A.A. 2019/2020

### Code Linting
VHDL code linting is performed with the [vsg](https://github.com/jeremiah-c-leary/vhdl-style-guide) python tool.

To install it in a virtualenv execute the following commands, then refer to vsg's documentation for more in-depth usage:
```sh
virtualenv venv
./venv/scripts/activate
pip install -r requirements.txt
vsg -f ./semaphore.vhd --fix
```
