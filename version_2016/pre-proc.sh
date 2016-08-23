sed '1,3d; /^$/,$d; /-/d; />/d' $1 \
  | awk '{ print $1, NF-2 }' > num_site_$1
sed '1,3d; /^$/,$d; /-/d; />/d' $1 > sites_$1
