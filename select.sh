#!/bin/bash
function selct {
. ../../connect.sh
#declare -a arr

select choice in "Select All" "Select By Column" "Select By Row" "Back To Connect Menu"
do
case $REPLY in
1)showall;;			
2)bycols ;;
3)byrow;;
4) cd ../.. ;connect;;	
*) echo "Invalid Entry"
esac
done
}
function showall {
echo "Avaliable Tables"
ls -I "*-meta" 
read -p "Which Table Do You Want To Select From: " tname


column -t -s ';' $tname
read -p "Do you want to select more with the same option?(y/n) " ans
while true
    do
		if [[ $ans != [yYnN] ]]                     
	       	then
                read -p "Please Enter Either y or n " ans

               elif [[ $ans = [yY] ]]
               then
			showall
		else
			#cd ../..
			selct
        fi
done
}
###########################################################################################################################################################
function byrow {

echo "Avaliable Tables"
ls -I "*-meta" 
read -p "Which table do u want to select from: " tname
if [ ! -f $tname ];then
	echo "No table with that name"
    byrow
fi
if [[ $tname == "" ]];then
		echo "Really?"
		byrow
fi
colnum=$(awk 'END{print NR}' "${tname}-meta")
#keys=($(awk -F":" '{print $4}' test-meta))
for (( k = 1; k <=$colnum ; k++ )); do
	colkey=($(awk -F: -v i="$k" '{if(NR==i) print $4}' "${tname}-meta")) #to know if it primary or not
	#coltyp=$(awk -F: -v i="$k" '{if(NR==i) print $3}' "${tname}-meta")
    	if [[ $colkey == "primary" ]]; then
		#echo "The primary key is $field"
		#echo "$coltype"
		primcol=$k

	fi
done
#echo ${keys[@]}
#echo ${#keys[@]}	
#echo $primcol
primtyp=$(awk -F: -v i="$primcol" '{if(NR==i)print $3}' test-meta)
#echo $primtyp

num_of_rows=$(awk -F: 'END{print NR}' $tname)
field=$(awk -F":" '{print $0}' $tname|cut -d: -f"$primcol" |head -1)
echo "The primary key is $field"

read  -p "Please enter a $field value to print: " input
if [[ $input == "" ]];then
		echo "Really?"
        read  -p "Please enter a $field value to print: " input

		
fi
if [[ $primtyp == [iI] ]];then 
		while ! [[  $input =~ ^[0-9]*$ ]]; do
			echo "Invalid DataType "
			echo -e "Enter ($field) which is an integer "
 			read input
		done
	
	else 
		while ! [[ $input =~ ^[a-zA-Z]+$ ]]; do
			echo "Invalid DataType "
			echo -e "Enter ($field) which is a string"
			read input
		done
	fi


	grep -i -w $input $tname
read -p "Do you want to select more with the same option?(y/n) " ans

while true
    do
		if [[ $ans != [yYnN] ]]                     
	       	then
                read -p "Please enter either y or n " ans

               elif [[ $ans = [yY] ]]
               then
			byrow
		else
			#cd ../..
			selct
        fi
done

}

#############################################################################################################################################################################
function bycols {
#!/bin/bash
echo "Avaliable Tables"
echo `ls -I "*-meta"`
read -p "Which Table Do You Want To Select From: " tname
if [[ $tname == "" ]];then
		echo "Really?"
        bycols
		
fi

if [ ! -f $tname ];then
	echo "No table like that"
    bycols
fi
echo "Avaliable Columns"
echo `awk -F: '{print $0}' $tname | head -1`
colnum_num=$(awk 'END{print NR}' "${tname}-meta")
while  true ;do
	read -p  "Please Enter the Column Number You Want: " input
	if  ! [[  $input =~ ^[0-9]*$ ]]; then
		echo "ple "
		echo -e "Enter the Column Number which is an integer: "
 		continue;
	fi
	if [[ $input > $colnum_num ]];then
		continue;
	else
		awk -F: -v i="$input" '{print $i}' $tname
		break;
	fi
done
read -p "Do you want to select more with the same option?(y/n) " ans

while true
    do
        
	if [[ $ans != [yYnN] ]]                     
       	then
            read -p "Please enter either y or n " ans

           elif [[ $ans = [yY] ]]
            then
			bycols
		else
			#cd ../..
			selct
    fi


done
}










#cols=$(awk -F: '{print NF}' $tname | head -1)
#for ((i=1;i<=cols;i++))
#do
#arr+=($(awk -F: '{print $0}' $tname |head -1 |cut -d: -f$i))
#done
#len_array=${#arr[@]}
#elect choice in "all" "row" "columns"
#do
#if [ "$choice" == "all" ]
#then 
#column -t  $tname
#if [[ $? != 0 ]]
#then
#echo "Error Displaying Table $tname"
#fi
#fi
#if [ "$choice" == "row" ]
#then
#echo "enter the primary key:"
#read prim
#grep -i -w $prim $tname
#fi
#if [ "$choice" == "columns" ]
#then
#read -p "enter the column u want :" column
#for ((i=1;i<=$len_array;i++))
#do
#if [ arr[i] == "column" ]
#then 
#	 echo $(awk 'BEGIN{FS=":"}{print $1}' $tname)

#fi
#done
#fi
#done





#i want to create array from file



