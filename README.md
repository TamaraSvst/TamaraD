# Дипломный проект профессии «1C-программист: с нуля до middle»
## Первоначальная Настройка системы
### Для работы с подсистемой Обслуживание Клментов необходимо:
1. Заполнить константы НоменклатураАбонентскаяПлата и НоменклатураРаботыСпециалиста
2. Заполнить регистр сведений Условия работы сотрудников
### Для работы с телеграм-ботом необходимо:
1. Напишете в Телеграм https://t.me/BotFather команду "/start"
2. Напишите команду "/newbot"
3. Выберите имя вашего бота, которое будут видеть пользователи
4. Выберите идентификатор вашего бота (он должен заканчиваться на "bot")
5. Скопируйте токен, который пришлет BotFather и сохраните его в константу ТокенТелеграмБота.
6. Напишите любое сообщение в группу
7. С помощью браузера или Postman выполните запрос https://api.telegram.org/bot[ВашТокен]/getUpdates.
8.  В полученном JSON найдите идентификатор группы, в которой получено сообщение, и сохраните его в константу ИдентификаторГруппыТелеграм.




