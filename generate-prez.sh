#!/usr/bin/env bash

docker run --rm -u $(id -u):$(id -g) -v $(pwd):/documents asciidoctor/docker-asciidoctor \
  asciidoctor-revealjs -a data-uri -a revealjs_theme=white \
  -a revealjsdir=https://cdnjs.cloudflare.com/ajax/libs/reveal.js/3.9.2 -a revealjs_transition=fade \
  -a customcss=custom.css -a revealjs_slideNumber=true \
  -D public -o index.html \
  dompter-data-talk.adoc

cp custom.css public/
mkdir public/videos
cp videos/collisionTissu.mp4 public/videos

touch public/.nojekyll