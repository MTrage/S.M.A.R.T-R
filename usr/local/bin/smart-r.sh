#!/bin/bash
#
#   S.M.A.R.T'R is freely usable for all with the exception of military and other anti-social activities.
#   Created 24.12.2019 by Marc-André Tragé
#
#   If you have any questions, you can also send me an email at mt@7vm.de
#
#   Of course I take over absolutely no guarantee and also do not pay for damages,
#   which can possibly develop – like most in the life the use is also here on own danger!
#
#   Please also observe the respective rights of use of the tools used by S.M.A.R.T'R.
#

ERROR="0"
SHORT="0"
OPFILE=$2

# Brings some color into the terminal - ILoveCandy °D
bold=$(tput bold)
normal=$(tput sgr0)
fgcol=$(tput setaf 3)
fncol=$(tput setaf 7)
bgcol=$(tput setab 1)
bocol=$(tput setab 4)

# All texts that are output can be found here
MSG_1_0=" You can only run S.M.A.R.T.T'R as sudo with root privileges! "
MSG_2_0="  S.M.A.R.T'R                                                     "
MSG_2_1="   offers the possibility to display all SMART values"
MSG_2_2="   from any Server, PC or NAS in a simple, clear and fast way!"
MSG_2_3="    -s, --short   Short output of the values\n"
MSG_2_4="    -f, --file    Path and name for output file\n\n"
MSG_3_0="S.M.A.R.T.'R – OUTPUTFILE"
MSG_4_0="---------------------------------------------------------------------------------------------------------------------------------"
MSG_5_0=" SMART Values OK "
MSG_6_0=" [ --- All (S)ATA,SCSI or NVMe SMART Values are OK --- ] "
MSG_6_1=" USB SMART ERROR "
MSG_6_2=" USB ERROR WITH "
MSG_7_0="Show the Error(s)?"
MSG_7_1=" Errors saved in /tmp/SMARTER-Error-Log.txt "
MSG_7_2=" Please answer yes or no [y/n] "

# You should have ROOT rights, or at least be a SUDO
if ! [ $(id -u) = 0 ]; then
    echo "${fgcol}${bgcol}${bold}$MSG_1_0${normal}"
    exit 1
fi

# Output of help information for the user
if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    printf "\n"
    echo "${fgcol}${bold}${bocol}$MSG_2_0${normal}"
    echo "${fgcol}$MSG_2_1${normal}"
    echo "${fgcol}$MSG_2_2${normal}"
    printf "$MSG_2_3"
    printf "$MSG_2_3"
    exit 1
fi

# Create and cache the information in the TMP folder
lsblk -d > /tmp/1.inf
sed -n 2,100p /tmp/1.inf > /tmp/2.inf
wc -l /tmp/2.inf > /tmp/3.inf
awk 'NR==1{print $1}' /tmp/3.inf > /tmp/4.inf
fileCount="/tmp/4.inf"
lineCount=$(cat "$fileCount")

# Delete the caching of information in the TMP folder
Remove_TMP_Files(){
  rm /tmp/1.inf /tmp/2.inf /tmp/3.inf /tmp/4.inf
}

# Create the desired output file
Output_File(){
  sudo echo $MSG_3_0 > $OPFILE
  for i in `seq $lineCount`
    do
      dNAME=$(awk "NR==${i}{print \$1}" /tmp/2.inf)
      dCHECK=$(sudo smartctl /dev/$dNAME -a);
        if [ "$dCHECK" != "" ]; then
            sudo echo $MSG_4_0 >> $OPFILE
            sudo lsblk /dev/$dNAME -f >> $OPFILE
            sudo smartctl /dev/$dNAME -a >> $OPFILE
            sudo echo $MSG_4_0 >> $OPFILE
            sudo echo "" >> $OPFILE
        fi
  done
}

# Query if an output file is desired
if [ "$1" == "-f" ] || [ "$1" == "--file" ]; then
  Output_File
  Remove_TMP_Files
  exit 1
fi

# Evaluation of the existing data medium information
for i in `seq $lineCount`
    do
      dNAME=$(awk "NR==${i}{print \$1}" /tmp/2.inf)
      dCHECK=$(sudo smartctl /dev/$dNAME -a | grep PASSED);
        # Change only if you know exactly the reason for the filtering and want to change it specifically.
        if [ "$dCHECK" == "SMART overall-health self-assessment test result: PASSED" ]; then
          if [ "$1" == "-s" ] || [ "$1" == "--short" ]; then
            SHORT="1";
            else
              echo "${fgcol}${bold}[ $dNAME ]${normal} ${fncol}${bold}${bocol}$MSG_5_0${normal}"
              sudo lsblk /dev/$dNAME -f
              sudo smartctl /dev/$dNAME -a
          fi
          else
            ERROR="1";
          fi
          if [ "$ERROR" == "0" ]; then
            FILE=/tmp/SMARTER-Error-Log.txt
            if [ -f "$FILE" ]; then
              rm $FILE
            fi
          fi
done

# Message that all media are OK
  if [ "$SHORT" == "1" ]; then
      echo "${fncol}${bold}${bocol}$MSG_6_0${normal}"
  fi

# Creation of the error log for error information
    if [ "$ERROR" == "1" ]; then
      sudo echo "" > /tmp/SMARTER-Error-Log.txt
        for i in `seq $lineCount`
          do
            dNAME=$(awk "NR==${i}{print \$1}" /tmp/2.inf)
            dCHECK=$(sudo smartctl /dev/$dNAME -a | grep USB);
              if [[ $dCHECK =~ ^[/dev] ]]; then
                  echo "${fgcol}${bold}[ $dNAME ]${normal} ${fgcol}${bgcol}${bold}$MSG_6_1${normal}"
                  echo "${fgcol}${bgcol}${bold}$MSG_6_2${normal}${fgcol}${bold} [ /dev/$dNAME ]${normal}" >> /tmp/SMARTER-Error-Log.txt
                  sudo lsblk /dev/$dNAME -f >> /tmp/SMARTER-Error-Log.txt
                  sudo smartctl /dev/$dNAME -a >> /tmp/SMARTER-Error-Log.txt
                    if [ "$1" != "-s" ]; then
                      if [ "$1" != "--short" ]; then
                        sudo lsblk /dev/$dNAME -f
                        sudo smartctl /dev/$dNAME -a
                      fi
                    fi
                fi
          done
    fi

# Query how or whether the error information should be displayed
if [ "$ERROR" == "1" ]; then
  while true; do
      read -p "$MSG_7_0 ${fgcol}${bold}[y/n]${normal} " -n 1 -r yn
      case $yn in
          [Yy]* ) echo ""
                  cat /tmp/SMARTER-Error-Log.txt
                  echo "${fncol}${bold}${bocol}$MSG_7_1${normal}"
                  break;;
          [Nn]* ) echo ""
                  echo "${fncol}${bold}${bocol}$MSG_7_1${normal}"
                  Remove_TMP_Files
                  exit;;
          * ) echo "${fgcol}${bgcol}${bold}$MSG_7_2${normal}";;
      esac
  done
fi

# Calling the TMP Cleanup
Remove_TMP_Files
