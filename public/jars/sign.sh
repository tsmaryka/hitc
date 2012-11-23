#!/bin/bash

for i in *.jar
do
jarsigner -keystore ~/hitc -storepass trevdude9 -keypass Trevdude $i trevor 
done
