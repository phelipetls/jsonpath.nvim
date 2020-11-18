#!/bin/bash

mutt_expand_path() {
    eval "$(mutt -Q folder)"
    val="${1/#=/$folder\/}"
    val="${val/#\~/$HOME}"
    echo "$val"
}

# Define usage
usage() {
  cat <<EOF
Usage: $0 [-a alias file] [-d days] [-p] [-f] [-b] [-n] DIRECTORIES
Built mutt aliases from maildir emails in DIRECTORIES.
OPTIONS:
  -a          alias file (default: value of \$alias_file in ~/.muttrc)
  -d          maximal number of days since last sent mail to (default: 0 = unlimited)
  -p          purge aliases previously added by $0
  -f          filter out email addresses that are probably impersonal
  -b          backup the current alias file (if it exists) to *.prev
  -n          create a new alias file instead of modifying the current one
  -h          display this help and exit
EOF
  exit 1
}

# Parse options

max_age=0
purge='false'
filter='false'
backup='false'
new='false'

while getopts 'a:d:pfbnh' opt; do
  case "${opt}" in
    a) alias_file="$OPTARG" ;;
    d) max_age="$OPTARG" ;;
    p) purge='true' ;;
    f) filter='true' ;;
    b) backup='true' ;;
    n) new='true' ;;
    *) usage; exit 1 ;;
  esac
done
shift $((OPTIND-1))

if [ $# = 0 ]; then usage; fi

if [ -z "$alias_file" ]; then
  if [ -x mutt ]; then
    alias_file="$(mutt -Q "alias_file")"
    alias_file=$(mutt_expand_path "$alias_file")
  elif [ -f ~/.muttrc ]; then
    alias_file=$(grep -E --only-matching --no-filename '^\s*set\s+alias_file\s*=.*$' ~/.muttrc)
    alias_file=$(echo "${alias_file}" | grep -E --only-matching --no-filename '[^=]+$' -)
    alias_file=$(eval echo "${alias_file}")
  fi
fi

if ! [ -f "$alias_file" ]; then
  echo "No alias file found. Exiting!"
  exit
fi

# Make backup and/or clear previous database
alias_file_prev="${alias_file}.prev"
if [ -f "${alias_file}" ]; then
  if [ $backup = 'true' ] && [ $new = 'true' ]; then
    mv "${alias_file}" "${alias_file_prev}"
  elif [ $backup = 'true' ] && [ $new = 'false' ]; then
    cp "${alias_file}" "${alias_file_prev}"
  elif [ $backup = 'false' ] && [ $new = 'true' ]; then
    rm "${alias_file}"
  fi
fi

touch "$alias_file"
echo Using "${alias_file}" to store aliases...

# make temporary copy of alias file
alias_file_orig="${alias_file}"
TMPDIR=${TMPDIR:-/tmp}
tmp_dir=$(mktemp --directory "$TMPDIR/mutt-alias.XXXXXXXXXX")
alias_file="${tmp_dir}"/aliases
cp "${alias_file_orig}" "${alias_file}"

email_regexp="[[:alnum:]._%+-]+\@([[:alnum:]-]+\.)+[[:alpha:]]{2,}"

if [ "$purge" = true ]; then
  alias_regexp="^alias (${email_regexp}) \1 # mutt-alias: e-mail sent on [[:digit:]]+"
  sed -E --in-place "/${alias_regexp}/d" "${alias_file}"
fi

for directory in "$@"; do
  echo "Processing ${directory}"
  for email in "$directory/"*; do
    # Parse "To:"
    in_to="$(awk 'BEGIN {found="no"}; ((found=="yes") && /^\S/) || /^$/ {exit}; (found=="yes") && /^\s/ { printf "%s", $0 }; /^To:/ {found="yes"; sub(/^To: ?/, "", $0) ; printf "%s", $0}' "$email")"

    # Parse "Date:"
    in_date="$(awk 'BEGIN {found="no"}; ((found=="yes") && /^\S/) || /^$/ {exit}; (found=="yes") && /^\s/ { printf "%s", $0 }; /^Date:/ {found="yes"; sub(/^Date: ?/, "", $0) ; printf "%s", $0}' "$email")"
    out_date="$( date --date="$in_date" +%s )"
    # If there is no date, then just put an early date in.
    if [ "${out_date}" = "" ]; then out_date="0"; fi

    # Split To: on `,` for multiple recipients
    IFS=','
    for each_to in $in_to; do
      # first delete white space (possibly leading space from `, `),
      # then remove real name (if present),
      # then make lower-case
      out_to="$( <<<"$each_to" tr -d '[:space:]' | sed -E 's/.*<(.*)>/\1/' )"
      out_to=$(echo "$out_to" | tr "[:upper:]" "[:lower:]")
      # get real name
      name_to="$( <<<"$each_to" sed -E 's/(.*)<.*>/\1/' )"
      # get alias by removing domain
      alias_to=${out_to%@*}

      now=$(date +%s)
      out_age=$(( (now - out_date) / 86400 ))

      if [[ "$out_to" =~ ^${email_regexp}$ ]]; then
        # Find previous entry's line number
        prev_line_number="$(grep -F -i --max-count=1 "${out_to}" "${alias_file}")"
        if { [ "0" = "$max_age" ] || [ "$out_age" -lt "$max_age" ]; } && [ "${prev_line_number}" = "" ]; then
          hr_out_date="$( date --date=@"$out_date" +%Y-%m-%d@%H:%M:%S )"
          new_entry="alias ${alias_to} $name_to <${out_to}> # mutt-alias: e-mail sent on ${hr_out_date}"
          echo "${new_entry}" >> "${alias_file}"
        fi
      fi
    done
    IFS=" "
  done
done

if perl -e 'use Encode::MIME::Header;' > /dev/null 2>&1; then
  perl -CS -MEncode -ne 'print decode("MIME-Header", $_)' \
    "${alias_file}" | iconv -f UTF-8 -t ISO-8859-15 > "${alias_file}.decoded"
  mv "${alias_file}.decoded" "${alias_file}"
fi

if [ "$filter" = "true" ]; then
  filter_regexp="<([[:alnum:]._%+-]*([0-9]{9,}|([0-9]+[a-z]+){3,}|\+|nicht-?antworten|ne-?pas-?repondre|not?([-_.])?reply|\b(un)?subscribe\b|\bMAILER\-DAEMON\b)[[:alnum:]._%+-]*\@([[:alnum:]-]+\.)+[[:alpha:]]{2,})> # mutt-alias: e-mail sent on"
  grep -E -i --invert-match \
    "$filter_regexp" \
    "${alias_file}" > "${alias_file}.filtered"

  mv "${alias_file}.filtered" "${alias_file}"
fi

# override alias file by temporary copy of alias file
mv "${alias_file}" "${alias_file_orig}"
rmdir "${tmp_dir}"

# Return time it took to run, removing leading zeros
TOTALTIME=$(date --date="1970-01-01 ${SECONDS} sec" +'%T' | sed -E 's/^0(0:(0)?)?//')
echo "Database updated in ${TOTALTIME}."

# ex:ft=sh
