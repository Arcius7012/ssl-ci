﻿#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	SslCI_РаботаСГитом.ЗаполнитьСписокВеток(Элементы);
	
	Если Элементы.Ветка.СписокВыбора.Количество() Тогда
		Ветка = Элементы.Ветка.СписокВыбора.Получить(0).Значение;
	Иначе
		ТекстСообщения = НСтр("ru='Не найдено ни одной ветки'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , , , Отказ);	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Метаданные.Константы.Найти("ЭтоРабочаяБаза") <> Неопределено
		И Константы["ЭтоРабочаяБаза"].Получить() = Истина Тогда
		ТекстСообщения = НСтр("ru='Функционал недоступен на рабочей базе'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , , , Отказ);
	КонецЕсли;
	
	Если Параметры.Свойство("БезОповещения") Тогда
		БезОповещения = Параметры.БезОповещения;	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ВыборВеткиПродолжение", ЭтотОбъект);
	
	Если БезОповещения Тогда
		ТекстВопроса = НСтр("ru = 'Обновить файл из указанной ветки?'");
	Иначе
		ТекстВопроса = НСтр("ru = 'Обновить все отчеты/обработки из указанной ветки?'");
	КонецЕсли;
		
	ЗаголовокВопроса = НСтр("ru = 'Переключение ветки'");
	
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60, КодВозвратаДиалога.Нет, ЗаголовокВопроса);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборВеткиПродолжение(Результат, ДопПараметры) Экспорт

	Если Результат = КодВозвратаДиалога.Да Тогда
		Если БезОповещения Тогда
			Закрыть(Ветка);	
		Иначе
			ОповеститьОВыборе(Ветка);	
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
