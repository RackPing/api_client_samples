#!/bin/sh -eux

# Program: build.sh
# Usage: ./build.sh
# Date: 2020 10 05
# Purpose: rust build script for multiple program files to populate dist/bin/
# Version: 1.0
# Copyright: RackPing USA 2020
# Env: bash
# Note:

ROOT="$PWD"

mkdir -p dist/bin

for crate in \
   rp_list_contacts \
   rp_add_contact \
   rp_update_contact \
   rp_del_contact \
   rp_list_checks \
   rp_add_check \
   rp_update_check \
   rp_pause_check \
   rp_resume_check \
   rp_pause_maint \
   rp_resume_maint \
   rp_schedule_maint \
   rp_del_check \
; do

  cd "$crate"
  cargo build --release
  cp -p "target/release/$crate" "$ROOT/dist/bin/"
  cd "$ROOT"
done

exit 0
