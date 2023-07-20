﻿////////////////////////////////////////////////////////////////////////////////
// Серверные процедуры и функции для внутренней логики расширения. Для обратной совместимости с 8.3.12
//  
////////////////////////////////////////////////////////////////////////////////
#Область СлужебныйПрограммныйИнтерфейс

Функция ПолучитьТекущиеНастройкиИнтеграции() Экспорт
	
	ПараметрыПодключения = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища("ПараметрыИнтеграцииСГитом", "ПараметрыПодключения");
		
	Возврат ПараметрыПодключения;
	
КонецФункции

Процедура ЗаписатьНастройкиИнтеграции(НастройкиГита) Экспорт
	
	ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище("ПараметрыИнтеграцииСГитом", НастройкиГита, "ПараметрыПодключения");
	
КонецПроцедуры

Функция СтрокаВКодировкеURL(Строка) Экспорт
	Возврат КодироватьСтроку(Строка, СпособКодированияСтроки.КодировкаURL);	
КонецФункции

Функция ОбновитьОбработкуОтчет(ОбъектСсылка, ИмяФайла, ДвоичныеДанные, ОписаниеКоммита, ОтключитьОбновление = Ложь) Экспорт
	
	Успех = Ложь;
	
	АдресДанных = ПоместитьВоВременноеХранилище(ДвоичныеДанные);
	
	ОбъектСправочника 	= ОбъектСсылка.ПолучитьОбъект();	
	КомандыСохраненные 	= ОбъектСправочника.Команды.Выгрузить();
	
	ПараметрыРегистрации = Новый Структура;
	ПараметрыРегистрации.Вставить("АдресДанныхОбработки", 	АдресДанных);
	ПараметрыРегистрации.Вставить("ЭтоОтчет", 				СтрНайти(ИмяФайла, ".epf") = 0);
	ПараметрыРегистрации.Вставить("ОтключатьКонфликтующие", Ложь);
	ПараметрыРегистрации.Вставить("ИмяФайла", 				ИмяФайла);
	ПараметрыРегистрации.Вставить("ОтключатьПубликацию", 	Ложь);
	
	РезультатРегистрации = ДополнительныеОтчетыИОбработки.ЗарегистрироватьОбработку(ОбъектСправочника, ПараметрыРегистрации);
	ОбъектМетаданных = Метаданные.Справочники.ДополнительныеОтчетыИОбработки;
	
	Если РезультатРегистрации.Успех Тогда
		Попытка			
			ОбъектСправочника.ХранилищеОбработки = Новый ХранилищеЗначения(ДвоичныеДанные, Новый СжатиеДанных(9));
			
			Если ОбъектСправочника.Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительнаяОбработка Тогда
				ЗаполнитьКоманды(ОбъектСправочника, КомандыСохраненные);
			КонецЕсли;
			
			ЗаполнитьЗначенияСвойств(ОбъектСправочника, ОписаниеКоммита); 
			
			ОбъектСправочника.SslCI_НеОбновлятьАвтоматически = ОтключитьОбновление;
			
			ОбъектСправочника.Записать();
			Успех = Истина;
		Исключение			
			ТекстОшибки = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ЗаписьЖурналаРегистрации("Обновление объекта из репозитория", УровеньЖурналаРегистрации.Ошибка, ОбъектМетаданных, ОбъектСсылка, ТекстОшибки);
		КонецПопытки;
	Иначе
		ТекстОшибки = РезультатРегистрации.ТекстОшибки; 
		
		Если РезультатРегистрации.Свойство("Конфликтующие") Тогда
			ТекстОшибки = "Уже загружен файл с таким наименованием";	
		КонецЕсли;
		
		ЗаписьЖурналаРегистрации("Обновление объекта из репозитория", УровеньЖурналаРегистрации.Ошибка, ОбъектМетаданных, ОбъектСсылка, ТекстОшибки);
	КонецЕсли;
	
	Возврат Успех;
	
КонецФункции

Функция РеквизитыОбъекта(СправочникСсылка, Реквизиты) Экспорт
	Возврат ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СправочникСсылка, Реквизиты);	
КонецФункции

Функция ФайлыКАктуализации(Ветка = "", ФайлыВетки = Неопределено) Экспорт

	Ответ = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДополнительныеОтчетыИОбработки.Ссылка КАК Ссылка,
	|	ДополнительныеОтчетыИОбработки.SslCI_АдресВРепозитории КАК SslCI_АдресВРепозитории,
	|	ДополнительныеОтчетыИОбработки.SslCI_ИДКоммита КАК SslCI_ИДКоммита,
	|	ДополнительныеОтчетыИОбработки.SslCI_ИмяВетки КАК SslCI_ИмяВетки
	|ИЗ
	|	Справочник.ДополнительныеОтчетыИОбработки КАК ДополнительныеОтчетыИОбработки
	|ГДЕ
	|	ДополнительныеОтчетыИОбработки.SslCI_АдресВРепозитории <> """"
	|	И ДополнительныеОтчетыИОбработки.SslCI_ИмяВетки <> """"
	|	И НЕ ДополнительныеОтчетыИОбработки.SslCI_НеОбновлятьАвтоматически
	|	И НЕ ДополнительныеОтчетыИОбработки.ПометкаУдаления
	|	И ДополнительныеОтчетыИОбработки.Публикация <> ЗНАЧЕНИЕ(Перечисление.ВариантыПубликацииДополнительныхОтчетовИОбработок.Отключена)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		СтруктураФайла = Новый Структура;
		СтруктураФайла.Вставить("Ссылка", Выборка.Ссылка);
		
		Реквизиты = Новый Структура("SslCI_АдресВРепозитории, SslCI_ИДКоммита, SslCI_ИмяВетки");
		ЗаполнитьЗначенияСвойств(Реквизиты, Выборка);
		
		// Переключение ветки
		Если Ветка <> ""
			И ФайлыВетки <> Неопределено Тогда
			
			Если ФайлыВетки.Найти(Выборка.SslCI_АдресВРепозитории) <> Неопределено
				И Выборка.SslCI_ИмяВетки <> Ветка Тогда
				ОбработкаОбъект = Выборка.Ссылка.ПолучитьОбъект();
				ОбработкаОбъект.SslCI_ИмяВетки = Ветка;
				ОбработкаОбъект.Записать();
				Реквизиты.Вставить("SslCI_ИмяВетки", Ветка); 
			Иначе
				Продолжить;
			КонецЕсли;			
		КонецЕсли;
		
		СтруктураФайла.Вставить("Реквизиты", Реквизиты);
		
		Ответ.Добавить(СтруктураФайла);	
	КонецЦикла;
	
	Возврат Ответ;
	
КонецФункции

Процедура ПереключитьВетку(СправочникСсылка, Ветка) Экспорт
	
	СправочникОбъект = СправочникСсылка.ПолучитьОбъект();
	СправочникОбъект.SslCI_ИмяВетки = Ветка;
	СправочникОбъект.Записать();	
	
КонецПроцедуры

Функция ПолучитьМакетОбновления(ОбновленныеФайлы) Экспорт

	Макет = Справочники.ДополнительныеОтчетыИОбработки.ПолучитьМакет("SslCI_ОписаниеОбновления");
	
	ТабДок = Новый ТабличныйДокумент;
	
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
	
	ТабДок.Вывести(ОбластьЗаголовок);
	
	ЗапросДанных = Новый Запрос;
	ЗапросДанных.УстановитьПараметр("ОбновленныеФайлы", ОбновленныеФайлы);
	ЗапросДанных.Текст =
	"ВЫБРАТЬ
	|	ДополнительныеОтчетыИОбработки.Наименование КАК Наименование,
	|	ДополнительныеОтчетыИОбработки.SslCI_СообщениеКоммита КАК СообщениеКоммита,
	|	ДополнительныеОтчетыИОбработки.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ДополнительныеОтчетыИОбработки КАК ДополнительныеОтчетыИОбработки
	|ГДЕ
	|	ДополнительныеОтчетыИОбработки.Ссылка В(&ОбновленныеФайлы)";
	
	Результат = ЗапросДанных.Выполнить();
	
	Если Результат.Пустой() Тогда
		ОбластьСтрока.Параметры.ОписаниеОбновления = НСтр("ru = 'Все файлы актуализированы. Обновления не требуется'");
		ТабДок.Вывести(ОбластьСтрока);
	Иначе
		ШаблонСообщения = НСтр("ru = 'Обновлен файл ""%1"": %2'");
		
		Выборка = Результат.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			ОбластьСтрока.Параметры.ОписаниеОбновления = СтрШаблон(ШаблонСообщения, Выборка.Наименование, Выборка.СообщениеКоммита);
			ТабДок.Вывести(ОбластьСтрока);
		КонецЦикла;
	КонецЕсли;
	
	Возврат ТабДок;	
	
КонецФункции

Процедура СоздатьНовыйОбъект(ФайлРепозитория, Ветка, АдресДанных) Экспорт
	
	// Создаем в упрощенном виде, обновится потом по-нормальному из гита
	ЭтоОтчет = СтрНайти(ФайлРепозитория, "erf") <> 0;
	
	ОписаниеЗащитыОтОпасныхДействий = Новый ("ОписаниеЗащитыОтОпасныхДействий");
	ОписаниеЗащитыОтОпасныхДействий.ПредупреждатьОбОпасныхДействиях = Ложь;
	
	Если ЭтоОтчет Тогда
		ИмяОбработки = ВнешниеОтчеты.Подключить(АдресДанных, , Ложь, ОписаниеЗащитыОтОпасныхДействий);
		Обработка = ВнешниеОтчеты.Создать(ИмяОбработки);
	Иначе
		ИмяОбработки = ВнешниеОбработки.Подключить(АдресДанных, , Ложь, ОписаниеЗащитыОтОпасныхДействий);
		Обработка = ВнешниеОбработки.Создать(ИмяОбработки);
	КонецЕсли;
	
	УдалитьИзВременногоХранилища(АдресДанных);	
	ПараметрыРегистрации = Обработка.СведенияОВнешнейОбработке();	
	Вид = ВидОбработки(ПараметрыРегистрации.Вид);
	
	Обработка = Неопределено;
	
	СправочникОбъект = Справочники.ДополнительныеОтчетыИОбработки.СоздатьЭлемент();
	СправочникОбъект.ИспользоватьДляФормыОбъекта = Истина;
	СправочникОбъект.ИспользоватьДляФормыСписка  = Истина;
	СправочникОбъект.Ответственный               = Пользователи.ТекущийПользователь();
	
	СправочникОбъект.Наименование = ФайлРепозитория;			
	СправочникОбъект.ИмяФайла = ФайлРепозитория;
	СправочникОбъект.Публикация = Перечисления.ВариантыПубликацииДополнительныхОтчетовИОбработок.Используется;
	СправочникОбъект.Вид = Вид;
	
	СправочникОбъект.SslCI_АдресВРепозитории = ФайлРепозитория;
	СправочникОбъект.SslCI_ИмяВетки = Ветка;
	
	СправочникОбъект.Записать();
	
КонецПроцедуры

Функция ПолучитьСписокТекущихИмен() Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДополнительныеОтчетыИОбработки.SslCI_АдресВРепозитории КАК SslCI_АдресВРепозитории
	|ИЗ
	|	Справочник.ДополнительныеОтчетыИОбработки КАК ДополнительныеОтчетыИОбработки
	|ГДЕ
	|	ДополнительныеОтчетыИОбработки.SslCI_АдресВРепозитории <> """"
	|	И ДополнительныеОтчетыИОбработки.SslCI_ИмяВетки <> """"
	|	И НЕ ДополнительныеОтчетыИОбработки.ПометкаУдаления";
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("SslCI_АдресВРепозитории");
	
КонецФункции

#КонецОбласти    

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьКоманды(ОбъектСправочника, КомандыСохраненные)
	
	ОбъектСправочника.Команды.Сортировать("Представление");
		
	Для Каждого ЭлементКоманда Из ОбъектСправочника.Команды Цикл
						
		Если ЭлементКоманда.ВариантЗапуска = Перечисления.СпособыВызоваДополнительныхОбработок.ВызовСерверногоМетода
			Или ЭлементКоманда.ВариантЗапуска = Перечисления.СпособыВызоваДополнительныхОбработок.СценарийВБезопасномРежиме Тогда
						
			РегламентноеЗаданиеGUID = ЭлементКоманда.РегламентноеЗаданиеGUID;
			Если КомандыСохраненные <> Неопределено Тогда
				НайденнаяСтрока = КомандыСохраненные.Найти(ЭлементКоманда.Идентификатор, "Идентификатор");
				Если НайденнаяСтрока <> Неопределено Тогда
					РегламентноеЗаданиеGUID = НайденнаяСтрока.РегламентноеЗаданиеGUID;
				КонецЕсли;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(РегламентноеЗаданиеGUID) Тогда
				УстановитьПривилегированныйРежим(Истина);
				РегламентноеЗадание = РегламентныеЗаданияСервер.Задание(РегламентноеЗаданиеGUID);
				Если РегламентноеЗадание <> Неопределено Тогда
					ЭлементКоманда.РегламентноеЗаданиеGUID = РегламентноеЗаданиеGUID;
				КонецЕсли;
				УстановитьПривилегированныйРежим(Ложь);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция ВидОбработки(ВидСтрока)

	Если ВидСтрока = "ПечатнаяФорма" Тогда
		Возврат Перечисления.ВидыДополнительныхОтчетовИОбработок.ПечатнаяФорма;
	КонецЕсли;
	
	Если ВидСтрока = "ДополнительнаяОбработка" Тогда
		Возврат Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительнаяОбработка;
	КонецЕсли;
	
	Если ВидСтрока = "ДополнительныйОтчет" Тогда
		Возврат Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительныйОтчет;
	КонецЕсли;
	
	Если ВидСтрока = "ЗаполнениеОбъекта" Тогда
		Возврат Перечисления.ВидыДополнительныхОтчетовИОбработок.ЗаполнениеОбъекта;
	КонецЕсли;
	
	Если ВидСтрока = "Отчет" Тогда
		Возврат Перечисления.ВидыДополнительныхОтчетовИОбработок.Отчет;
	КонецЕсли;
	
	Если ВидСтрока = "СозданиеСвязанныхОбъектов" Тогда
		Возврат Перечисления.ВидыДополнительныхОтчетовИОбработок.СозданиеСвязанныхОбъектов;
	КонецЕсли;
	
	Возврат Перечисления.ВидыДополнительныхОтчетовИОбработок.ПустаяСсылка();
	
КонецФункции

#КонецОбласти