# 0.3 - 2015-07-26

- Fix create_vm cmd imageName
- Fix missing machine/ directory instead of machines/
- Set dm and dc aliases instead of symbolic links

# 0.2 - 2015-07-06

- Move set_machine in utils.sh and rename dc in dcompose to release the alias for docker-machine
- Add .bashrc (that always source utils.sh and call set_machine) and .bash_aliases

# 0.1 - 2015-07-05

- First release