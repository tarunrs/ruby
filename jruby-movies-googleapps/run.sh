echo " starting .."
rm first.war
echo "removing tmp directory"
rm -r tmp
echo "making tmp directory"
mkdir tmp
../jruby~main/bin/jruby -S warble war
echo "warbleing"
cp first.war /home/tarun/Desktop/1.zip
echo "extracting"
cd tmp
unzip /home/tarun/Desktop/1.zip
echo "lauching webserver"
cd ..
../appengine-java-sdk-1.3.5/bin/dev_appserver.sh --port=18080 tmp

