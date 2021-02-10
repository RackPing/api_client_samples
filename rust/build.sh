#!/bin/sh -eux

# See https://www.justanotherdot.com/posts/structuring-rust-projects-with-multiple-binaries.html

ROOT="$PWD"
mkdir -p dist/bin
for crate in rp_list_checks rp_list_contacts; do
  cd "$crate"
  cargo build --release
  cp -p "target/release/$crate" "$ROOT/dist/bin/"
  cd "$ROOT"
done

exit 0
