#!/usr/bin/env bash

echo "
= Apprends à Dompter la Data sans Douter de Toi !

+++<img src="https://raw.githubusercontent.com/jvauchel/dompter-data-talk-2023/main/images/dompter-data-illustration.jpg" width='800'/>+++

== Slides

" > index.adoc

CONFERENCES=("tadx:long"
              "jug-summer-camp:long"
              "tremplin:short"
              "agile-bdx:short"
              "abstract:short")

rm -rf public
mkdir -p public

for conf in "${CONFERENCES[@]}"
do
  CONFERENCE_NAME=${conf%%:*}
  DURATION=${conf#*:}
  echo "generate ${CONFERENCE_NAME} html in version ${DURATION}"

  CONFERENCE_PNG_BASE64=$(cat images/logo-${CONFERENCE_NAME}.png | base64 -w0) \
  QRCODE_PNG_BASE64=$(cat images/qrcode.png | base64 -w0) \
  MY_NAME_PNG_BASE64=$(cat images/myName.png | base64 -w0) \
    envsubst < custom.css > public/custom-${CONFERENCE_NAME}.css

  if [ ${CONFERENCE_NAME} == 'abstract' ] ; then
    SOURCE="abstract.adoc"
  else
    SOURCE="dompter-data-talk.adoc"
  fi

  docker run --rm -u $(id -u):$(id -g) -v $(pwd):/documents asciidoctor/docker-asciidoctor:1.49.0 \
    asciidoctor-revealjs -a data-uri -a revealjs_theme=white \
    -a revealjsdir=https://cdnjs.cloudflare.com/ajax/libs/reveal.js/3.9.2 -a revealjs_transition=fade \
    -a customcss=custom-${CONFERENCE_NAME}.css -a revealjs_slideNumber=true \
    -a ${DURATION}-format \
    -D public -o index-${CONFERENCE_NAME}.html \
    ${SOURCE}

    echo "* link:index-${CONFERENCE_NAME}.html[${CONFERENCE_NAME}^]" >> index.adoc

done

echo "
== Vidéos

=== Pitch de présentation de la conférence

video::vQ5pa_EAh_M[youtube]

=== Jug Summer Camp 2023

video::-q2JKXsSKAY?si=Xdu50igg2OdblGYj[youtube]

=== Le Tremplin Bordelais 2023

video::3XqatOzeL-Y?si=AUbVWiMrDGX3frcv[youtube]

=== Agile Tour 2023

à venir

=== TADx 2023

à venir

=== SnowCamp 2024

à venir

" >> index.adoc

mkdir -p public/videos
cp -a videos public


touch public/.nojekyll


docker run --rm -u $(id -u):$(id -g) -v $(pwd):/documents asciidoctor/docker-asciidoctor:1.49.0 \
  asciidoctor -D public -o index.html index.adoc

rm index.adoc