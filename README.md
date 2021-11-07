# Домашнее задание ШРИ: Инфраструкутра
Для выполнения домашнего задания я использовал Github Actions  
-чтобы просмотреть историю тегов репозитория можно выполнить git tag  
-пример команды для создания нового тега git tag -a v0.5 -m "New release tag"  
-для отправки тега в репозиторий используем git push origin v0.5 или gut push --tags

-гитхаб экшн запускается после добавления в git релизного тэга в формате v*, например v0.1  
-также экшн можно запускать вручную из github action  

В результате выполнения экшена запускается скрипт ./.github/scripts/release.sh, который:  
-создает тикет в Яндекс Трекере с заголовком вида "Release: <релизный тег>" дополнительной информацией и changelog`ом в описании.  
-если тикет с таким именем существует, то он обновляется.  
-запускает автотесты и результат отправляется в комментарий к тикету.  
-собирает докер-образ и результат отправляется в комментарий к тикету (образ не публикуется).  

Конфиги github-action лежат в ./.github/workflows/release.yml  
Скрипты в папке ./.github/scripts  

Пример релизного тикета: https://tracker.yandex.ru/TMP-1259  
