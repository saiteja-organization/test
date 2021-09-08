####################################
# global variables declaration
####################################

# version file value
new_version_tag=""

# last release-tag version 
previous_version_tag=""

# new updated version
result_version_tag=""

####################################
# member functions
####################################

# version values assignment
function get_version_tags()    
    new_version_tag = $(cat $(pwd)/VERSION)
    previous_version_tag = $(git describe --tags $(git rev-list --tags --max-count=1) | cut -d 'v' -f2)

# new version tag evaluation
function get_latest_tag():
    local new_version_major=$(echo $1 | cut -d '.' -f1)
    local new_version_minor=$(echo $1 | cut -d '.' -f2)
    local new_version_patch=$(echo $1 | cut -d '.' -f3)
    
    local previous_version_major=$(echo $2 | cut -d '.' -f1)
    local previous_version_minor=$(echo $2 | cut -d '.' -f2)
    local previous_version_patch=$(echo $2 | cut -d '.' -f3)
    
    if (( "$new_version_major">"$previous_version_major" )) || (( "$new_version_minor">"$previous_version_minor" )) || (( "$new_version_patch">"$previous_version_patch" ))
    then
        echo "$new_version_tag"
    else
        if (( "$new_version_major"=="$previous_version_major" )) && (( "$new_version_minor"=="$previous_version_minor" )) && (( "$new_version_patch"<="$previous_version_patch" ))
        then 
            echo "$previous_version_major.$previous_version_minor.$(expr $previous_version_patch + 1)"
        fi
    fi
    return 0
    
# scenario with no history of release-tag
function version_tag_init():
    if [ -z "$2" ]
    then
          result_version_tag="$1"
          echo "$result_version_tag"
          exit 0
    fi

# main method
function main() {
    # reading tag values
    get_version_tags

    # handling no previous release-tag
    version_tag_init $new_version_tag $previous_version_tag

    # version tag evaluation based on previous release-tag and version file value
    result_version_tag=$(get_latest_tag $new_version_tag $previous_version_tag)

    # updated release-tag version
    echo $result_version_tag
}
    
####################################
# script execution
####################################

main
