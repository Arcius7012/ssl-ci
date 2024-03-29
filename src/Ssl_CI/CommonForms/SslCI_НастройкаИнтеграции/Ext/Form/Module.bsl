﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НастройкиГита = SslCI_СлужебныйВызовСервера.ПолучитьТекущиеНастройкиИнтеграции();
	
	Если НастройкиГита <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, НастройкиГита);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Не ЗавершениеРаботы
		И Не Отказ
		И Модифицированность Тогда
		Отказ = Истина;
		
		Оповещение = Новый ОписаниеОповещения("ЗакрытьНастройки", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Сохранить настройки?'");
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 30);
	КонецЕсли;
	
КонецПроцедуры  

&НаКлиенте
Процедура ЗакрытьНастройки(Результат, ДопПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		СохранитьНастройки(Неопределено);
	Иначе
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НастройкаПриИзменении(Элемент)
	Модифицированность = Истина;		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПроверитьСоединение(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		НастройкиГита = НастройкиГита();
		
		Если SslCI_НастройкаИнтеграцииСГитомПовтИсп.СоединениеСГитомУстановлено(НастройкиГита, Истина) Тогда
			ДанныеПроекта = SslCI_РаботаПоАпи.ИнфоОПроекте(НастройкиГита);
			
			Если ДанныеПроекта.Успех = Истина Тогда
				Если ПутьКРепозиторию <> ДанныеПроекта.ОписаниеПроекта.web_url Тогда 
					ПутьКРепозиторию = ДанныеПроекта.ОписаниеПроекта.web_url;
					Модифицированность = Истина;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНастройки(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		SslCI_СлужебныйВызовСервера.ЗаписатьНастройкиИнтеграции(НастройкиГита());
		ОбновитьПовторноИспользуемыеЗначения();
		Оповестить("ОбновлениеНастроекГита");
		Модифицированность = Ложь;		
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция НастройкиГита()

	НастройкиГита = Новый Структура;
	НастройкиГита.Вставить("АдресГита", АдресГита);
	НастройкиГита.Вставить("ИдПроекта", ИдПроекта);
	НастройкиГита.Вставить("ТокенДоступа", ТокенДоступа);
	НастройкиГита.Вставить("КаталогИсходников", КаталогИсходников);
	НастройкиГита.Вставить("АдресТаскТрекера", АдресТаскТрекера);
	НастройкиГита.Вставить("ПрефиксЗадачи", ПрефиксЗадачи);
	НастройкиГита.Вставить("ПутьКРепозиторию", ПутьКРепозиторию);
	НастройкиГита.Вставить("РучноеДобавлениеФайлов", РучноеДобавлениеФайлов);
	НастройкиГита.Вставить("СтрокаПоискаТрекер", СтрокаПоискаТрекер);
	НастройкиГита.Вставить("ЛогинДоступаТрекер", ЛогинДоступаТрекер);
	НастройкиГита.Вставить("ПарольДоступаТрекер", ПарольДоступаТрекер);
	
	Возврат НастройкиГита;
	
КонецФункции

#КонецОбласти