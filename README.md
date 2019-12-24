# S.M.A.R.T-R
S.M.A.R.T'R offers the possibility to display all SMART values from any Server, PC or NAS in a simple, clear and fast way!
### If all SMART values are ok
![](https://github.com/MTrage/S.M.A.R.T-R/blob/master/screenshot/ok.png)
### If there is something wrong with the media or SMART values
![](https://github.com/MTrage/S.M.A.R.T-R/blob/master/screenshot/error.png)
#### The constant querying of SMART states of hard disks on NAS systems and servers annoyed me a bit in the long run. Therefore I wrote a small script which is able to query all storage media automatically after calling them and display them sorted in different messages. Of course you can also automate SMARTR e.g. with a cronjob and output a given file, which you put on a web server, with a new job the old evaluation is deleted and replaced by a new one, but you could also adapt this with a simple PHP script to put the data sorted by date and time into a database.

### Install with CURL
    su
    curl -fsSL https://raw.githubusercontent.com/MTrage/S.M.A.R.T-R/master/usr/local/bin/smart-r.sh > /usr/local/bin/smart-r
    chmod 755 /usr/local/bin/smart-r
    exit

### Install with WGET
    su
    wget https://raw.githubusercontent.com/MTrage/S.M.A.R.T-R/master/usr/local/bin/smart-r.sh
    cd /usr/local/bin/
    cp smart-r.sh smart-r
    rm smart-r.sh
    chmod 755 smart-r
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
