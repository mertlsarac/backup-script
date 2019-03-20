#!/bin/sh

declare -a directories=("home" "etc" "root")
declare -a HostNames=("doc" "logging" "mail" "ns1" "ns2" "www")

for hostname in ${HostNames[@]};
do
        ssh root@$hostname 'mkdir /tmp/backup'
done

for hostname in ${HostNames[@]};
do

        for directory in ${directories[@]};
        do

                day=$(date +%Y-%m-%d-%H)
                target="tmp/backup/backup-$hostname-$directory-$day.tar.gz"
                ssh root@$hostname bash -c "'tar -pczf /$target --absolute-names /$directory'"
                rsync -avzh root@$hostname:/$target /var/backup/$hostname/$directory/

        done
done

for hostname in ${HostNames[@]};
do
        ssh root@$hostname bash -c "'rm -rf /tmp/backup/'"
done

