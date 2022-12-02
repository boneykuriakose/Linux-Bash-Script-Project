<<doc
Name:Boney Kuriakose
Date:03/10/2022
Description:
Sample input:
Sample output:
doc
#!/bin/bash
function signup
{
    read -p "Username:" user
    read -s -p "Password:" pass
    echo
    passlen=${#pass}
    if [ $passlen -lt 8 ]
    then
	echo "Password length must be minimum 8"
	echo
	echo
	signup
    elif [ $passlen -ge 8 ]
    then
	arruser=(`cat username.csv`)
	usernum=${#arruser[@]}
	if [ $usernum -eq 0 ]
	then
	    echo
	    read -s -p "Confirm password" conf
	    if [ $pass != $conf ]
	    then
		echo "Password not matching"
		echo
		echo
		signup
	    else
		echo $user >> /home/boney/ECEP/Ls/Project/username.csv
		echo $pass >> /home/boney/ECEP/Ls/Project/password.csv
		echo "Sign up successful"
		echo 
		echo
		frontpage
	    fi
	fi
	read -s -p "Confirm password: " conf
	echo
	for i in ${arruser[@]}
	do
	    if [ $i = $user ]
	    then
		echo "Username already exist please try another username"
		echo
		echo
		signup
	    else
		if [ $pass != $conf ]
		then
		    echo "Passwords not matching"
		    signup
		fi
	    fi
	done
	echo $user >> /home/boney/ECEP/Ls/Project/username.csv
	echo $pass >> /home/boney/ECEP/Ls/Project/password.csv
	echo "Sign up successful"
	echo 
	echo
	frontpage
    fi   
}

function signin
{
    read -p "Username: " user
    read -s -p "Password: " pass

    arruser=(`cat username.csv`)
    arrpass=(`cat password.csv`)
    arruserlen=$((${#arruser[@]}-1))
    for i in 0 1 $arruserlen
    do
      if [ $user = ${arruser[i]} ]
      then
       	  if [ ${arrpass[i]} = $pass ]
	  then
	      echo "Sign in successful"
	      echo "1)Take test"
	      echo "2)Exit"
	      read b
	      case $b in
		  1)
		      taketest
		      ;;
		  2)
		      return
		      ;;
	      esac
	  else
	      echo "Incorrect password"
	  fi
      fi
    done
}

function taketest
{
    clear
    echo "-----TAKE TEST-----"
    totalline=`cat questionbank.txt | wc -l`
    for i in `seq 5 5 $totalline`
    do
      head -$i questionbank.txt | tail -5
      for j in `seq 9 -1 0`
      do
        echo -n -e "\r choose option:$j \c"
        read -t1 opt
        if [ -z $opt ]
        then
	    opt=e
        else
	    break
        fi
      done
    echo
    echo $opt >> userans.txt
    done
	clear
    marks

}

function marks
{
    arruserans=(`cat userans.txt`)
    len=${#arruserans[@]}
    arrorgans=(`cat originalans.txt`)
    mark=0
    totalline=`cat questionbank.txt | wc -l`
	d=0
    for j in `seq 5 5 $totalline`
	do
	   head -$j questionbank.txt | tail -5
	   echo  "The correct answer is ${arrorgans[$d]}"
       echo "User answer is ${arruserans[$d]}"
	   d=$(($d+1))
	   anslines=`cat userans.txt | wc -l`
	   lines=$(($anslines-1))
	   for k in `seq 0 1 $lines`
	   do 
	      if [ ${arruserans[$k]} = ${arrorgans[$k]} ]
	      then
			  mark=$(($mark+1))
	      fi
	   done
	   echo
     done
		echo
		tmark=$(($mark/5))
		echo "Total marks=$tmark/$anslines"
		#clean
}

#function clean
{
	sed -i 'd' userans.txt
}


function frontpage
{

echo "1)Sign up"
echo "2)Sign in"
echo "3)Exit"
read a
case $a in
    1)
	signup
	;;
    2)
	signin
	;;
    3)
	return
	;;
esac
}

frontpage
