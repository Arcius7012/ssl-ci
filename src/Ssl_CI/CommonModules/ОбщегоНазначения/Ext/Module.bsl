﻿
&ИзменениеИКонтроль("ЗаписатьДанныеВБезопасноеХранилище")
Процедура SslCI_ЗаписатьДанныеВБезопасноеХранилище(Владелец, Данные, Ключ)

	ОбщегоНазначенияКлиентСервер.Проверить(ЗначениеЗаполнено(Владелец),
	СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
	НСтр("ru='Недопустимое значение параметра %1 в %2."
	"параметр должен содержать ссылку; передано значение: %3 (тип %4).';en='Invalid value for %1 in %2."
	"parameter must contain a link; value: %3 (type %4).'"),
	"Владелец", "ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище", Владелец, ТипЗнч(Владелец)));

	ЭтоОбластьДанных = РазделениеВключено() И ДоступноИспользованиеРазделенныхДанных();
	Если ЭтоОбластьДанных Тогда
		БезопасноеХранилищеДанных = РегистрыСведений.БезопасноеХранилищеДанныхОбластейДанных.СоздатьМенеджерЗаписи();
	Иначе
		БезопасноеХранилищеДанных = РегистрыСведений.БезопасноеХранилищеДанных.СоздатьМенеджерЗаписи();
	КонецЕсли;

	БезопасноеХранилищеДанных.Владелец = Владелец;
	БезопасноеХранилищеДанных.Прочитать();
	Если Данные <> Неопределено Тогда
		Если БезопасноеХранилищеДанных.Выбран() Тогда
			ДанныеДляСохранения = БезопасноеХранилищеДанных.Данные.Получить();
			Если ТипЗнч(ДанныеДляСохранения) <> Тип("Структура") Тогда
				ДанныеДляСохранения = Новый Структура();
			КонецЕсли;
			ДанныеДляСохранения.Вставить(Ключ, Данные);
			ДанныеДляХранилищеЗначения = Новый ХранилищеЗначения(ДанныеДляСохранения, Новый СжатиеДанных(6));
			БезопасноеХранилищеДанных.Данные = ДанныеДляХранилищеЗначения;
			БезопасноеХранилищеДанных.Записать();
		Иначе
			ДанныеДляСохранения = Новый Структура(Ключ, Данные);
			ДанныеДляХранилищеЗначения = Новый ХранилищеЗначения(ДанныеДляСохранения, Новый СжатиеДанных(6));
			БезопасноеХранилищеДанных.Данные = ДанныеДляХранилищеЗначения;
			БезопасноеХранилищеДанных.Владелец = Владелец;
			БезопасноеХранилищеДанных.Записать();
		КонецЕсли;
	Иначе
		БезопасноеХранилищеДанных.Удалить();
	КонецЕсли;

КонецПроцедуры

&ИзменениеИКонтроль("ПрочитатьДанныеИзБезопасногоХранилища")
Функция SslCI_ПрочитатьДанныеИзБезопасногоХранилища(Владелец, Ключи, ОбщиеДанные)

	ОбщегоНазначенияКлиентСервер.Проверить(ЗначениеЗаполнено(Владелец),
	СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
	НСтр("ru='Недопустимое значение параметра %1 в %2."
	"параметр должен содержать ссылку; передано значение: %3 (тип %4).';en='Invalid value for %1 in %2."
	"parameter must contain a link; value: %3 (type %4).'"),
	"Владелец", "ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища", Владелец, ТипЗнч(Владелец)));

	Если РазделениеВключено()
		И ДоступноИспользованиеРазделенныхДанных() Тогда
		Если ОбщиеДанные = Истина Тогда
			ИмяБезопасноеХранилищеДанных = "БезопасноеХранилищеДанных";
		Иначе
			ИмяБезопасноеХранилищеДанных = "БезопасноеХранилищеДанныхОбластейДанных";
		КонецЕсли;
	Иначе
		ИмяБезопасноеХранилищеДанных = "БезопасноеХранилищеДанных";

	КонецЕсли;
	Результат = ДанныеИзБезопасногоХранилища(Владелец, ИмяБезопасноеХранилищеДанных, Ключи);

	Если Результат <> Неопределено И Результат.Количество() = 1 Тогда
		Возврат ?(Результат.Свойство(Ключи), Результат[Ключи], Неопределено);
	КонецЕсли;

	Возврат Результат;

КонецФункции

&ИзменениеИКонтроль("ЗначениеРеквизитаОбъекта")
Функция SslCI_ЗначениеРеквизитаОбъекта(Ссылка, ИмяРеквизита, ВыбратьРазрешенные)

	Если ПустаяСтрока(ИмяРеквизита) Тогда 
		ВызватьИсключение НСтр("ru = 'Неверный второй параметр ИмяРеквизита: 
		|- Имя реквизита должно быть заполнено'");
	КонецЕсли;

	Результат = ЗначенияРеквизитовОбъекта(Ссылка, ИмяРеквизита, ВыбратьРазрешенные);
	Возврат Результат[СтрЗаменить(ИмяРеквизита, ".", "")];

КонецФункции
