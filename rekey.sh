# Simple script to rekey sops secrets when changing keys.
find secrets -type f -print0 | while IFS= read -r -d '' file; do
   sops updatekeys -y $file
done
