#!/bin/bash

readonly VERSION=0.1.0
readonly CLI_NAME="create-go-package"


printf "\033[90m=> %s v%s\n" $CLI_NAME $VERSION;


printf "\033[37mpackage name? "
read PKG_NAME

if [[ -d "$PKG_NAME" ]] 
then 
     printf "\033[91mDestination already exists.\n"
     exit 1
fi

if [[ -z $PKG_NAME ]]
then 
    printf "\033[91mPackage name is required\n"
    exit 1
fi

printf "\033[37mGithub username? "
read GITHUB_USERNAME

if [[ -z $GITHUB_USERNAME ]]
then 
    printf "\033[91mGithub username is required\n"
    exit 1
fi


# Clone the template repository
git clone git@github.com:ArunMurugan78/simple_package_seed.git $PKG_NAME

cd $PKG_NAME

sed -i "s/pkg/$PKG_NAME/" pkg.go
sed -i "s/pkg/$PKG_NAME/" pkg_test.go

mv pkg.go $PKG_NAME.go
mv pkg_test.go ${PKG_NAME}_test.go

go mod edit -module="github.com/$GITHUB_USERNAME/$PKG_NAME"

cd tools
go mod edit -module="github.com/$GITHUB_USERNAME/$PKG_NAME/build"
cd ..

# Git commit
rm -rf .git
git init
git branch -M main
git add -A
git commit -m "chore: intial commit"

# Install module deps.
go get ./...

# Install dev tools
make install

printf "Done ✨\n"
