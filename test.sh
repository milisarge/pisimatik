. inioku

cfg_parser ('pisimatik.ini')

# enable section called 'sec2' (in the file [sec2]) for reading
cfg.section.etc

# read the content of the variable called 'var2' (in the file
# var2=XXX). If your var2 is an array, then you can use
# ${var[index]}
echo $hostname
