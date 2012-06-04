#!/bin/bash
wget "http://127.0.0.1:8090/$1" --header='X-Fest-Dir: /usr/local/www/mail.ru.deploy/mail.ru.tugovikov/data/ru/' -O result 2>/dev/null&& cat result && rm result