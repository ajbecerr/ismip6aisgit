from hublib.cmd import runCommand

res, stdout, stderr = runCommand("submit -v ccr-ghub \
                                 -m ccr-vhub-python \
                                 --runName=runtest \
                                 --progress submit \
                                 all_figures.sh")