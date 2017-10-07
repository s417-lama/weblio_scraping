#!/bin/bash

JSON=$(curl $1/api/translate -s \
    -X POST \
    -H "Content-Type: application/json" \
    -d "{\"query\": \"$2\"}")
if [ $? != 0 ]; then
    echo "http://$1/api/translate に接続できません。"
    exit
fi

if [ "$(echo $JSON | jq ".found")" = true ]; then
    echo $JSON | jq -r ".explanation"
elif [ "$(echo $JSON | jq ".error")" = "{}" ]; then
    echo "$2は見つかりませんでした。"
    if [ "$(echo $JSON | jq ".suggestions")" != "[]" ]; then
        echo ""
        echo "もしかして:"
        echo $JSON | jq -r '.suggestions[] | "\(.word)\t\(.explanation)"'
    fi
else
    echo "サーバーエラー:"
    echo $JSON | jq -r -c ".error"
fi
