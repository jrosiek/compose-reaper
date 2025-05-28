#!/bin/bash

cd "$(dirname "$0")"

function help
{
    echo "usage: $0 [options] tag [tag...]"
    echo
    echo "options:"
    echo "  -p      - push images to DockerHub"
    echo "  -d      - add date tag"
    exit 1
}

tags=()
push=
while [ -n "$1" ]; do
    case "$1" in
        -p) 
            push=1
            ;;
        -d)
            tags+=("$(date '+%Y%m%d')")
            ;;
        -*)
            echo "unknown option: $1"
            echo
            help
            ;;
        *)
            tags+=("$1")
            ;;                  

    esac
    shift
done



if [ -z "${tags[*]}" ]; then
    help
fi

echo "Tags: ${tags[*]}"

images=()
args=()
for tag in "${tags[@]}"; do
    images+=("jrosiek/compose-reaper:$tag")
    args+=("-t" "jrosiek/compose-reaper:$tag")
done

echo "Building..."
docker build "${args[@]}" src


if [ -n "$push" ]; then
    for image in "${images[@]}"; do
        echo "Pushing: $image"
        docker push "$image"
    done
else
    echo "Skipping push"
fi
