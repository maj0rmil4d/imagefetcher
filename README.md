# imagefetcher
dead simple docker registery image fetcher ~!~


# allow insecure registeries 

 echo "{"insecure-registries": ["0.0.0.0/1","128.0.0.0/2","192.0.0.0/3","224.0.0.0/4"]}" > /etc/docker/daemon.json ; service docker restart


 # use the script 

 
bash fetchimage.sh xyz.zyz.xya.asv
