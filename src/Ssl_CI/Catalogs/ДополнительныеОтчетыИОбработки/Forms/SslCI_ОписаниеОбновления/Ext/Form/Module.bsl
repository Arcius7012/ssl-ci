﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ОбновленныеФайлы") Тогда
		ОписаниеОбновления = SslCI_СлужебныйВызовСервера.ПолучитьМакетОбновления(Параметры.ОбновленныеФайлы);
	Иначе
		Отказ = Истина;	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти