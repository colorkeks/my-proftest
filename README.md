# proftest

Для установки гема capybara-webkit нужно выполнить:

sudo apt-get install libqt4-dev


Установка wkhtmltopdf

Скачать бинарник http://wkhtmltopdf.org/downloads.html

Установить sudo dpkg -i wkhtmltox-0.12.2.1_linux-trusty-i386.deb , если возникли проблемы выполнить sudo apt-get install -f

В initializers добавить файл со строкой WickedPdf.config = { exe_path: '/usr/local/bin/wkhtmltopdf' }

