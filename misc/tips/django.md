### Django make migration from sqlite

```
./manage.py dumpdata --natural --indent=2 app1 app2 app3 auth.User > dump.json
./manage.py dumpdata --natural --indent=2 --exclude=contenttypes --exclude=sessions.Session --exclude=south.Migrationhistory > dump.json
./manage.py syncdb --noinput --no-initial-data
./manage.py migrate
./manage.py loaddata dump.json
```
