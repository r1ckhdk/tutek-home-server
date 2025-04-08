#!/bin/bash

set -eu

VIMRC_PATH="${HOME}/.vimrc"

echo "Starting vim setup..."

if [ -f "${VIMRC_PATH}" ]; then
    cp "${VIMRC_PATH}" "${VIMRC_PATH}.bkp"
    echo "Backup created: ${VIMRC_PATH}.bkp"

fi

cat > "${VIMRC_PATH}" << "EOF"
set number
set smartindent
set autoindent
set showmatch
set hlsearch
set completeopt=menu,menuone,noselect
syntax on
EOF

echo ".vimrc created at ${VIMRC_PATH}"
