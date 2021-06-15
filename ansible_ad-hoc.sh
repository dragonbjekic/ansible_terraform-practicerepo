#!/bin/bash
######################################
# AD-HOC SCRIPT
######################################

echo "
Enter the number of the desired option:
1) - Touch ~/tempfile on all hosts with 0444 perms
2) - Delete ~/tempfile on host group2
3) - Open port 12345 and probe it on group4(requires a plugin)
4) - Install the required plugin
5) - Option 3 + privilege escalation + password prompt
6) - Close port 12345 on group1 (requires a plugin)
7) - Remove plugin

Keep in mind that all of these groups refer a single host - ubuntubox
"
read option
case $option in
1)
    ansible all -m file -a 'path=~/tmp state=touch mode=0444'
    ;;
2)
    ansible group2 -m file -a 'path=~/tmp state=absent'
    ;;
3)
    ansible group4 -m community.general.ufw -a 'rule=allow port=12345 state=enabled' && \
    nmap -Pn ubuntubox | grep -i '12345'
    ;;
4)
    ansible-galaxy collection install community.general
    ;;
5)
    ansible group4 -m community.general.ufw -a 'rule=allow port=12345 state=reloaded' -bK && \
    nmap -Pn ubuntubox | grep -i '12345'
    ;;
6)
    ansible group1 -m community.general.ufw -a 'rule=deny port=12345' -bK
    ;;
7)
    rm -rf ~/.ansible/collections/ansible_collections/community/general/
    ;;
*)
    echo "wrong number"
    ;;
esac
