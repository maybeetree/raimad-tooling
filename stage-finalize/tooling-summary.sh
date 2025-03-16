#!/bin/sh

set -e

echo > /tmp/raimad-tooling

export PYTHONPATH=$PYTHONPATH:$(realpath ./src)

for version in $PYTHONS
do
	shortversion="$(echo "$version" | cut -d. -f 1-2)"

	if python$shortversion -m unittest 1>&2
	then
		echo "TOOLING_UNITTEST_$shortversion=true  # Did unittests pass?" >> /tmp/raimad-tooling
	else
		echo "TOOLING_UNITTEST_$shortversion=false  # Did unittests pass?" >> /tmp/raimad-tooling
	fi
done

#FIXME hardcoded version

if python3.12 -m mypy --strict src/raimad 1>&2
then
	echo "TOOLING_MYPY=true  # Were there NO mypy issues?" >> /tmp/raimad-tooling
else
	echo "TOOLING_MYPY=false  # Were there NO mypy issues?" >> /tmp/raimad-tooling
fi

python3.12 -m coverage run -m unittest 1>&2
coverage_percent=$(python3.12 -m coverage json -q -o /dev/stdout -i | jq --raw-output '.totals.percent_covered_display')

echo "TOOLING_COVERAGE=$coverage_percent  # Percentage of codebase covered by tests" >> /tmp/raimad-tooling

num_todos=$(find src tests -name '__pycache__' -prune -o -type f -exec grep -Eo "TODO|FIXME" {} \; | wc -l)

echo "TOOLING_TODOS=$num_todos  # How many TODOs and FIXMEs are in the code?" >> /tmp/raimad-tooling

# FIXME horrible screenscraping gymnastics
ruff_issues=$(python3.12 -m ruff check | tail -n 3 | grep 'Found' | tr -cd 0-9)

echo "TOOLING_RUFF=$ruff_issues  # How many issues reported by ruff?" >> /tmp/raimad-tooling

cat /tmp/raimad-tooling

