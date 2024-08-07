#!/usr/bin/env bash

echo "
= Apprends à Dompter la Data sans Douter de Toi !

+++<img src="https://raw.githubusercontent.com/jvauchel/dompter-data-talk-2023/main/images/dompter-data-illustration.jpg" width='800'/>+++

== Slides

" > index.adoc

ASCIIDOCTOR_DOCKER_IMAGE="asciidoctor/docker-asciidoctor:1.61.0"
REVEALJS_DIR="https://cdn.jsdelivr.net/npm/reveal.js@5.0.3"

CONFERENCES=("tadx:long"
              "jug-summer-camp:long"
              "tremplin:short"
              "agile-bdx:short"
              "abstract:short"
              "snowcamp:long"
              "rivieradev:long")

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

  docker run --rm -u $(id -u):$(id -g) -v $(pwd):/documents ${ASCIIDOCTOR_DOCKER_IMAGE} \
    asciidoctor-revealjs -a data-uri -a revealjs_theme=white \
    -a revealjsdir=${REVEALJS_DIR} -a revealjs_transition=fade \
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

https://agiletourbordeaux.fr/evenements/atbdx-edition-2023/

=== TADx 2023

video::5f29X4RiWCI?si=rG_fPRW6CHRZ-UfR[youtube]

=== SnowCamp 2024

https://snowcamp2024.sched.com/speaker/vauchel.johanna

=== Riviera Dev 2024

video::tgkyNvATdso?si=YDkfQBzsZxTmr0Xq[youtube]

" >> index.adoc

mkdir -p public/videos
cp -a videos public


touch public/.nojekyll


docker run --rm -u $(id -u):$(id -g) -v $(pwd):/documents ${ASCIIDOCTOR_DOCKER_IMAGE} \
  asciidoctor -D public -o index.html index.adoc

rm index.adoc