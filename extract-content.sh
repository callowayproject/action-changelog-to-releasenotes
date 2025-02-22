#!/usr/bin/env bash

target_version=$1
changelog_filename=${2:-CHANGELOG.md}
output_filename=${3:-release-notes.md}

function extract_version_content() {
  changelog=$1
  target_version=$2

  awk -v target="$target_version" '
    /^## / {
      if (found) exit;
      version=$2;
      if (version == target) found=1;
      next;
    }
    found { print; }
  ' <<< "$changelog"
}

changelog_contents=$(cat "${changelog_filename}")
content=$(extract_version_content "${changelog_contents}" "${target_version}")

if [ -n "$content" ]; then
  echo "::notice::Found release notes for ${target_version}"
  echo "$content" >> "${output_filename}"
else
  echo "::warning::Did not find release notes for ${target_version}"
  touch "${output_filename}"
fi
