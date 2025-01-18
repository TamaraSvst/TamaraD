#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды 

КонецПроцедуры

//***ВКМ_Доработка

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ТекущийОбъект.Ссылка = Документы.ВКМ_ОбслуживаниеКлиентов.ПустаяСсылка() Тогда

		ДобавитьЭлементВСправочникБота();
	
	КонецЕсли;
	
	ВКМ_РегламентноеЗаданиеОтправкиСообщений.ВКМ_ОтправкаСообщенийВТелеграм();

КонецПроцедуры

&НаКлиенте
Процедура ВКМ_СпециалистПриИзменении(Элемент)
	ВКМ_СпециалистПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ВКМ_СпециалистПриИзмененииНаСервере()
	
	ДобавитьЭлементВСправочникБота();

КонецПроцедуры

&НаКлиенте
Процедура ВКМ_ДатаПроведенияРаботПриИзменении(Элемент)
	ВКМ_ДатаПроведенияРаботПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ВКМ_ДатаПроведенияРаботПриИзмененииНаСервере()
	ДобавитьЭлементВСправочникБота();
КонецПроцедуры

&НаКлиенте
Процедура ВКМ_ВремяНачалаРаботПланПриИзменении(Элемент)
	ВКМ_ВремяНачалаРаботПланПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ВКМ_ВремяНачалаРаботПланПриИзмененииНаСервере()
	ДобавитьЭлементВСправочникБота();
КонецПроцедуры


&НаКлиенте
Процедура ВКМ_ВремяОкончанияРаботПланПриИзменении(Элемент)
	ВКМ_ВремяОкончанияРаботПланПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ВКМ_ВремяОкончанияРаботПланПриИзмененииНаСервере()
	ДобавитьЭлементВСправочникБота();
КонецПроцедуры




//---ВКМ_Доработка

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

//***ВКМ_Доработка

&НаСервере
Процедура ДобавитьЭлементВСправочникБота()

	ДокументОбъект = ЭтотОбъект.Объект;
	ФорматДатыДляЗаписи = Лев(Формат(ДокументОбъект.ДатаПроведенияРабот, "ДФ=dd.MM.yyyy;"), 10);

	ФорматВремяНачало = Лев(Формат(ДокументОбъект.ВремяНачалаРаботПлан, "ДЛФ=T;"), 8);

	ФорматВремяОкончания = Лев(Формат(ДокументОбъект.ВремяОкончанияРаботПлан, "ДЛФ=T;"), 8);

	ТекстУведомленияБота = СтрШаблон("Специалист: %1,
									 |Дата: %2,
									 |Время Начала: %3,
									 |Время Окончания: %4.", ДокументОбъект.Специалист, ФорматДатыДляЗаписи,
		ФорматВремяНачало, ФорматВремяОкончания);

	ЭлементСправочникаУведомлений = Справочники.ВКМ_УведомленияТелеграмБоту.СоздатьЭлемент();
	ЭлементСправочникаУведомлений.Текст = ТекстУведомленияБота;

	ЭлементСправочникаУведомлений.Записать();
	
		//ВКМ_Телеграм.ПолучитьЭлементСправочника();
		//ВКМ_РегламентноеЗаданиеОтправкиСообщений.ВКМ_ОтправкаСообщенийВТелеграм();
		
		
КонецПроцедуры


//---ВКМ_Доработка
#КонецОбласти

#Область ПодключаемыеКоманды

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти