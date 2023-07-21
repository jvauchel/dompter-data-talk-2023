#!/usr/bin/env bash

echo "
= Dompter Data

" > index.adoc

CONFERENCES="tadx jug-summer-camp abstract"

for conf in ${CONFERENCES}
do
  echo "generate ${conf} html"

  CONFERENCE_NAME=${conf}
      CONFERENCE_PNG_BASE64=$(cat images/logo-${CONFERENCE_NAME}.png | base64 -w0) \
      QRCODE_PNG_BASE64=$(cat images/qrcode.png | base64 -w0) \
      MY_NAME_PNG_BASE64=$(cat images/myName.png | base64 -w0) \
        envsubst < custom.css > public/custom-${conf}.css

  if [ ${conf} = 'abstract' ] ; then
    SOURCE="abstract.adoc"
  else
    SOURCE="dompter-data-talk.adoc"
  fi

  docker run --rm -u $(id -u):$(id -g) -v $(pwd):/documents asciidoctor/docker-asciidoctor:1.49.0 \
    asciidoctor-revealjs -a data-uri -a revealjs_theme=white \
    -a revealjsdir=https://cdnjs.cloudflare.com/ajax/libs/reveal.js/3.9.2 -a revealjs_transition=fade \
    -a customcss=custom-${conf}.css -a revealjs_slideNumber=true \
    -D public -o index-${conf}.html \
    ${SOURCE}

    echo "* link:index-${conf}.html[${conf}^]" >> index.adoc

done

mkdir -p public/videos
cp -a videos public


touch public/.nojekyll


docker run --rm -u $(id -u):$(id -g) -v $(pwd):/documents asciidoctor/docker-asciidoctor:1.49.0 \
  asciidoctor -D public -o index.html index.adoc

rm index.adoc