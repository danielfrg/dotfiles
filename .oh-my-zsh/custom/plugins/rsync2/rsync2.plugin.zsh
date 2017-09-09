dirsync() {
    if [ -z "$1" ]; then
        echo "Input directory needed"
        return 1
    fi;
    if [ -z "$2" ]; then
        echo "Target directory needed"
        return 1
    fi;
    # if [ -z "$3" ]; then
    #     echo "No keypair provided"
    #     return 1
    # fi;

    echo "Syncing $1 to $2"
    rsync -avz $1 $2 --exclude='.git/' --exclude='data'

    echo "Waiting for events"
    fswatch $1 | while read -r event
    do
        echo "File Changed: $event"
        rsync -avz -e "ssh -i $3" $1 $2 --exclude='.git/'
    done

    return 0;
}
