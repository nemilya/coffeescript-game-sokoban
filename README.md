﻿Игра Sokoban на CoffeeScript
============================

Миграция Ruby кода из проекта: https://github.com/nemilya/ruby-game-sokoban

Спеки, класс.

По настройке тестирования на Jasmine можно посмотреть здесь:
https://github.com/nemilya/coffeescript-spec-demo

Создаём папку `lib` - будет будущий класс Сокобана на CoffeeScript.

Создаём папку `spec` - здесь будет спецификация класса для Жасмина.

Создаём соответственно файлы:

* `game_sokoban.coffee`
* `game_sokoban_spec.coffee`

Запускаем автотестирование:

    jasmine-node --coffee . --autotest


Т.к. пока спеки не указаны, то выведет:

    0 tests, 0 assertions, 0 failures


С помощью `Sublime Text 2` открываем:

* `game_sokoban_spec.rb` (Ruby версия спецификации)
* `game_sokoban_spec.coffee` (спецификация на класс)
* `game_sokoban.coffee` (реализация класса игры)


Заполняем в спецификацию, делаем одну спеку с проверкой на 
инициализацию класса:

    {GameSokoban} = require('../lib/game_sokoban')

    describe "describe GameSokoban", ->
      it "инициализация класса", ->
        game = new GameSokoban()
        expect(game).toBeDefined()



Заполняем в класс:

    class GameSokoban


    exports.GameSokoban = GameSokoban


Не забываем `exports.GameSokoban = GameSokoban` - иначе класс не будет виден "снаружи".

Автотест должен автоматически подхватить изменения, и пройтись по спецификациям
которые он найдёт.


И вот это будет выведено в консоли Жасмина:


    .

    Finished in 0.085 seconds
    1 test, 1 assertion, 0 failures


То есть видим:

* `1 test` - это наш блок `it`
* `1 assertion` - это наша проверка `expect(...).toBeDefined()`


Как это выглядит: start.png


Делаем инициализацию Git:

    git init


Добавляем файл исключений `.gitignore`


И делаем 

   git add .
   git commit -m "init"

Теперь текущее состояние добавлено в `git` репозиторий, локально.


Всё готово чтобы идти по оригинальной спецификации что была для `Ruby` - 
и конвертировать её в `CoffeeScript`.


При переносе, конструкция вида на Ruby:

    it "text" do
      ...
    end

Заменяется на CoffeeScript, вида:

    it "text", ->
      ....


Сделали загрузку уровня `set_level`, и получение элементов в ячейке `element_at_pos`

Добавляем в `git`:

    git add .
    git commit -m "step1"


Сделали информацию по уровню.


Не забываем скобки! 

Это:

    expect( game.valid_direction('up') ).toBeTruthy


Совсем не это:

    expect( game.valid_direction('up') ).toBeTruthy()

В первом случае не будет никакой ошибки - т.к. проверка вообще не будет выполнена.

Поэтому правильный подход - это получение ошибки перед началом программирования - чтобы
было понятно, что тест работает.


И не забывайте, что без скобок, это будет "указатель на функцию"

   @refresh_cells

это не то же самое что:

   @refresh_cells()

Экономьте своё время :)