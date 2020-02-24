thisdir="$(cd "$(dirname "$0")" && pwd)"
watchdir="$(cd "$(dirname "$0")/../.." && pwd)"
echo "watching ${watchdir}"

inotifywait -r -m "${watchdir}" 2>/dev/null | while read message; do
    if [ -n "$(echo $message | grep "${watchdir}/public/")" ]; then
        continue
    fi

    if [ -z "$(echo $message | grep '\.\(js\|css\|png\)$' | grep '\bCLOSE_WRITE\b')" ]; then
        continue
    fi

    echo -n "building..."
    php "${thisdir}/build.php"
    echo "done"
done
