# check
cd ~/R
R --vanilla CMD check dispmod

# build
cd ~/R
R --vanilla CMD build --force dispmod

# install
lib="/Library/Frameworks/R.framework/Resources/library"
sudo R --vanilla CMD REMOVE --library="$lib" dispmod
sudo R --vanilla CMD INSTALL --library="$lib" dispmod_1.1.tar.gz # <-- change with the last version
