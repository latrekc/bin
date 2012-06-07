#!/bin/bash
wget "http://e.mail.ru/api/v1/ab?token=123456789&email=andrewsumin@corp.mail.ru" -O result && cat result && rm result