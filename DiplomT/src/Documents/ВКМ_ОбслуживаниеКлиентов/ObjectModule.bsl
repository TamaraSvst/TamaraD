#Область ОбработчикиСобытий
 
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	
	Движение = Движения.ВКМ_ВыполненныеКлиентуРаботы.Добавить();
	Движение.Период = Дата;
	Движение.ВКМ_Клиент = Клиент;
	Движение.ВКМ_Договор = Договор;
	ЧасыКОплате = ВКМ_ВыполненныеРаботы.Итог("ВКМ_ЧасыКОплатеКлиенту");
	Движение.ВКМ_КоличествоЧасов = ЧасыКОплате;
	
	Запрос = Новый Запрос;
	запрос.Текст =
	"ВЫБРАТЬ
	|	ВКМ_ОбслуживаниеКлиентов.Специалист,
	|	ДоговорыКонтрагентов.ВКМ_СтоимостьЧасаРаботы
	|ИЗ
	|	Документ.ВКМ_ОбслуживаниеКлиентов КАК ВКМ_ОбслуживаниеКлиентов
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	|		ПО ВКМ_ОбслуживаниеКлиентов.Договор = ДоговорыКонтрагентов.Ссылка
	|ГДЕ
	|	ВКМ_ОбслуживаниеКлиентов.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Ссылка",Ссылка );
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
		
	Движение.ВКМ_СуммаКОплате = Движение.ВКМ_КоличествоЧасов * Выборка.ВКМ_СтоимостьЧасаРаботы;
	
	Движения.ВКМ_ВыполненныеКлиентуРаботы.Записать();
	
	//***Взаимросчеты
	
	Движение = Движения.ВКМ_Взаиморасчеты.Добавить();
	Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
	Движение.Период = Дата;
	Движение.Клиент = Клиент;
	Движение.Договор = Договор;
	ЧасыКОплате = ВКМ_ВыполненныеРаботы.Итог("ВКМ_ЧасыКОплатеКлиенту");
	
	СтавкаЧасаСпециалиста = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Договор, "ВКМ_СтоимостьЧасаРаботы");
	
	Движение.Сумма = ЧасыКОплате * СтавкаЧасаСпециалиста;
	
	Движения.ВКМ_Взаиморасчеты.Записать();
	
	
	//---Взаиморасчеты
	
	
	Движение = Движения.ВКМ_ВыполненыеСотрудникомРаботы.Добавить();
	Движение.Период = Дата;
	Движение.Сотрудник = Специалист;
	Движение.ЧасовКОплате = ВКМ_ВыполненныеРаботы.Итог("ВКМ_ЧасыКОплатеКлиенту");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 	
	"ВЫБРАТЬ
	|	ВКМ_УсловияОплатыСотрудникаСрезПоследних.ПроцентОтРабот,
	|	ВКМ_УсловияОплатыСотрудникаСрезПоследних.Подразделение
	|ИЗ
	|	РегистрСведений.ВКМ_УсловияОплатыСотрудника.СрезПоследних(&Период, Сотрудник = &Сотрудник) КАК
	|		ВКМ_УсловияОплатыСотрудникаСрезПоследних";
	
	Запрос.УстановитьПараметр("Период", Дата);
	Запрос.УстановитьПараметр("Сотрудник",Специалист );
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Выборка.Следующий();
	Если  Выборка.Подразделение = Перечисления.ВКМ_КатегорииСотрудников.Специалисты И Выборка.ПроцентОтРабот = Неопределено Тогда
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = "Установите процент премии сотруднику!";
		Сообщение.Сообщить();
		
		Отказ = Истина;
		
		Иначе
	
	Движение.СуммаКОплате = Движение.ЧасовКОплате * СтавкаЧасаСпециалиста * Выборка.ПроцентОтРабот / 100;
	
	КонецЕсли;
	
	Движения.ВКМ_ВыполненыеСотрудникомРаботы.Записать();
	
	
КонецПроцедуры


Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	 
      ВидДоговораКонтрагента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Договор, "ВидДоговора");

	Если ВидДоговораКонтрагента <> Перечисления.ВидыДоговоровКонтрагентов.ВКМ_АбонентскоеОбслуживание Тогда
		ОбщегоНазначения.СообщитьПользователю(
   НСтр("ru = 'Вид договора не соответсвует! Выберите договор на Абонентское обслуживание.'"), , "ВКМ_Договор");

		Отказ = Истина;

	КонецЕсли;
	
	ДатаДоговора = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Договор, "ВКМ_НачалоПериодаДействия, 
																		   |ВКМ_КонецПериодаДействия ");

	Если ДатаДоговора.ВКМ_КонецПериодаДействия < Дата И ДатаДоговора.ВКМ_НачалоПериодаДействия > Дата Тогда
		ОбщегоНазначения.СообщитьПользователю(
   НСтр("ru = 'Дата не соотвествует периоду действия договора!'"), , "Дата");

		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


//***ВКМ_Доработка
#Область СлужебныеПроцедурыИФункции

Процедура ПолучитьОбъектДляЗаписи() Экспорт
	
	ФорматДатыДляЗаписи = Лев(Формат(ДатаПроведенияРабот, "ДФ=dd.MM.yyyy;"), 10);

	ФорматВремяНачало = Лев(Формат(ВремяНачалаРаботПлан, "ДЛФ=T;"), 8);

	ФорматВремяОкончания = Лев(Формат(ВремяОкончанияРаботПлан, "ДЛФ=T;"), 8);

	ТекстУведомленияБота = СтрШаблон("Специалист: %1,
									 |Дата: %2,
									 |Время Начала: %3,
									 |Время Окончания: %4.", Специалист, ФорматДатыДляЗаписи,
		ФорматВремяНачало, ФорматВремяОкончания);
		
		ЭлементСправочникаУведомлений = Справочники.ВКМ_УведомленияТелеграмБоту.СоздатьЭлемент();
		ЭлементСправочникаУведомлений.Текст = ТекстУведомленияБота;
				
		ЭлементСправочникаУведомлений.Записать();
	
	
КонецПроцедуры

Процедура ДобавитьЭлементВСправочникБота() Экспорт

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
КонецПроцедуры



#КонецОбласти
//---ВКМ_Доработка
