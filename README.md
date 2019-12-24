# S.M.A.R.T-R
S.M.A.R.T'R offers the possibility to display all SMART values from any Server, PC or NAS in a simple, clear and fast way!

### Install with CURL
    su
    curl -fsSL https://raw.githubusercontent.com/MTrage/S.M.A.R.T-R/master/usr/local/bin/smart-r.sh > /usr/local/bin/smart-r
    chmod 755 /usr/local/bin/smart-r
    exit

### Install with WGET
    su
    wget https://raw.githubusercontent.com/MTrage/S.M.A.R.T-R/master/usr/local/bin/smart-r.sh > /usr/local/bin/smart-r
    chmod 755 /usr/local/bin/smart-r
    exit

### Short output of the values
    sudo smart-r -s or --short
    
### Path and name for output file
    sudo smart-r -f or --file & /PATH/OUTPUT_FILE_NAME
    
### Without a suffix, all information is displayed
    sudo smart-r

## The following programs are used by S.M.A.R.T'R to create enjoyment.°)
- [x] awk
- [x] rm
- [x] sed
- [x] wc
- [x] echo
- [x] smartctl
- [x] read
- [x] printf
- [x] grep
- [x] tput
- [x] id
- [x] exit
- [x] cat
