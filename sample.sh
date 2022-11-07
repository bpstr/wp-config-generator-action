args=()

for argument in "$@"
do
    key=$(echo ${argument^^} | cut -f1 -d=)
    value=$(echo ${argument} | cut -f2 -d=)

    if [[ $key == *"--"* ]]; then
        name="${key:2}";
        declare "${name/-/_}=${value}"
   fi
done

source ./generate.sh

