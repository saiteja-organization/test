new_tag=""

recent_tag=""

function get_version_tag() {    
    new_tag=$(cat $(pwd)/VERSION)
    recent_tag=$(git describe --tags $(git rev-list --tags --max-count=1) | cut -d 'v' -f2)
}

function get_latest_tag() {
    local new_major=$(echo $1 | cut -d '.' -f1)
    local new_minor=$(echo $1 | cut -d '.' -f2)
    local new_patch=$(echo $1 | cut -d '.' -f3)
    
    local recent_major=$(echo $2 | cut -d '.' -f1)
    local recent_minor=$(echo $2 | cut -d '.' -f2)
    local recent_patch=$(echo $2 | cut -d '.' -f3)
    
    if (( "$new_major">"$recent_major" )) || (( "$new_minor">"$recent_minor" )) || (( "$new_patch">"$recent_patch" ))
    then
        echo "$new_tag"
    else
        if (( "$new_major"=="$recent_major" )) && (( "$new_minor"=="$recent_minor" )) && (( "$new_patch"<="$recent_patch" ))
        then 
            echo "$recent_major.$recent_minor.$(expr $recent_patch + 1)"
        fi
    fi
    return 0
}
    
function version_tag_init() {
    if [ -z "$2" ]
    then
          new_tag="$1"
          echo "$new_tag"
          exit 0
    fi
}

function main() {

    get_version_tag

    version_tag_init $new_tag $recent_tag

    new_tag=$(get_latest_tag $new_tag $recent_tag)

    echo $new_tag
    
main
