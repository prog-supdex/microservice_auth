# Micro Ads

Приложение "микросервис Ads"

# Зависимости

- Ruby `3.0.0`
- Bundler `2.2.3`
- Roda `3.19+`
- Sequel `5+`
- Puma `5.0+`
- PostgreSQL `9.3+`

# Установка и запуск приложения

1. Склонируйте репозиторий:

```
git clone git@github.com:prog-supdex/micro_ads.git && cd micro_ads
```

2. Установите зависимости и создайте базу данных:

```
bundle install
rake db:create
rake:db:migrate
```

3. Запустите приложение:

```
bundle exec puma
```

# TODOLIST
1. Покрыть код тестами(rspec)
2. Разобраться с error_handler plugin. Чтобы вызывалось дефолтное поведение(отображение ошибок), если exception не совпал с теми, что указаны в блоке
3. Перейти на ROM

....
Список дополняется
