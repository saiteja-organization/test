
new_version_tag=$(cat $(pwd)/VERSION)
previous_version_tag=$(git describe --tags $(git rev-list --tags --max-count=1))

if [ -z "$previous_version_tag" ]
then
      updated_version_tag="$new_version_tag"
      echo "$updated_version_tag"
      exit 0
fi

previous_version_tag=$(echo $previous_version_tag | cut -d 'v' -f2)

new_version_major=$(echo $new_version_tag | cut -d '.' -f1)
new_version_minor=$(echo $new_version_tag | cut -d '.' -f2)
new_version_patch=$(echo $new_version_tag | cut -d '.' -f3)

previous_version_major=$(echo $previous_version_tag | cut -d '.' -f1)
previous_version_minor=$(echo $previous_version_tag | cut -d '.' -f2)
previous_version_patch=$(echo $previous_version_tag | cut -d '.' -f3)

if (( "$new_version_major"<"$previous_version_major" ))
then
    updated_version_tag="$new_version_tag is smaller than $previous_version_tag"
else
    if (( "$new_version_major">"$previous_version_major" ))
    then
        updated_version_tag="$new_version_tag"
    else
        if (( "$new_version_major"=="$previous_version_major" ))
        then
            if (( "$new_version_minor"<"$previous_version_minor" ))
            then
                updated_version_tag="$new_version_tag is smaller than $previous_version_tag"
            else
                if (( "$new_version_minor">"$previous_version_minor" ))
                then
                    updated_version_tag="$new_version_tag"
                else
                    if (( "$new_version_minor"=="$previous_version_minor" ))
                    then
                        if (( "$new_version_patch"<="$previous_version_patch" ))
                        then
                            previous_version_patch=$(expr $previous_version_patch + 1)
                            updated_version_tag="$previous_version_major.$previous_version_minor.$previous_version_patch"
                        else
                            updated_version_tag="$new_version_tag"
                        fi
                    fi
                fi
            fi
        fi
    fi
fi

echo "$updated_version_tag"
