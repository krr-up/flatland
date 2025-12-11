#!/bin/bash

function bat()
{
    for x in "$@"; do
        type=$(file -b --mime-type -L "${x}")
        case ${type} in
        application/*bzip2*)
            bzcat "${x}"
            ;;
	application/*gzip*)
            zcat "${x}"
            ;;
	application/*xz*)
	    xzcat "${x}"
	    ;;
        *)
            cat "${x}"
            ;;
        esac
    done
}

bat "$@"
