# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
test = Test.create([{title: 'Судебно-медицинская экспертиза трупа',
                     description: 'Раздел IV'}, {title: 'Дерматовенерология', description: ''},{title: 'патологическая анатомия(пример видео и аудио)', description: ''}])

tasks = Task.create([{task_type: 'Единичный выбор', #1
                      text: 'Для наступления смерти от тампонады сердца кровью имеет значение:',
                      hint: 'Выберите наиболее правильный и полный ответ:',
                      point: 1,
                      test_id: test.first.id},
                     {task_type: 'Единичный выбор', #2
                      text: 'Трупные пятна после прекращения кровообращения обычно начинают появляться в период:',
                      hint: 'Выберите наиболее правильный и полный ответ:',
                      point: 1,
                      test_id: test.first.id},
                     {task_type: 'Единичный выбор', #3
                      text: 'Заподозрить при наружном осмотре трупа отравление окисью углерода возможно по:',
                      hint: 'Выберите наиболее правильный и полный ответ:',
                      point: 1,
                      test_id: test.first.id},
                     {task_type: 'Единичный выбор', #4
                      text: 'Для травматической жировой эмболии головного мозга характерны:',
                      hint: 'Выберите наиболее правильный и полный ответ:',
                      point: 1,
                      test_id: test.first.id},
                     {task_type: 'Единичный выбор', #5
                      text: 'Первая фаза травматической болезни:',
                      hint: 'Выберите наиболее правильный и полный ответ:',
                      point: 1,
                      test_id: test.first.id},
                     {task_type: 'Единичный выбор', #6
                      text: 'Способность к сознательным действиям у пострадавших с наличием повреждений, послуживших причиной смерти, исключается:',
                      hint: 'Выберите наиболее правильный и полный ответ:',
                      point: 1,
                      test_id: test.first.id},
                     {task_type: 'Единичный выбор', #7
                      text: 'При судебно-медицинским исследовании трупа исследование огнестрельных повреждений следует начинать с:',
                      hint: 'Выберите наиболее правильный и полный ответ:',
                      point: 1,
                      test_id: test.first.id},
                     {task_type: 'Единичный выбор', #8
                      text: 'Исследование внутренних органов трупа при огнестрельном ранении следует начинать с:',
                      hint: 'Выберите наиболее правильный и полный ответ:',
                      point: 1,
                      test_id: test.first.id},
                     {task_type: 'Единичный выбор', #9
                      text: 'Специфическим признаком механической асфиксии при аспирации крови в дыхательные пути является:',
                      hint: 'Выберите наиболее правильный и полный ответ:',
                      point: 1,
                      test_id: test.first.id},
                     {task_type: 'Единичный выбор', #10
                      text: 'Жировая эмболия, обнаруженная при исследовании трупа с переломами костей свидетельствует о:',
                      hint: 'Выберите наиболее правильный и полный ответ:',
                      point: 1,
                      test_id: test.first.id},
                     {task_type: 'Открытый вопрос', #13 (11 и 12 пропущены из бумажной версии)
                      text: 'Некомпенсированное испарение влаги кожей и слизистыми оболочками называется____________ и относится к ранним трупным явлениям.',
                      hint: 'Введите правильный ответ:',
                      point: 1,
                      test_id: test.first.id},
                     {task_type: 'Открытый вопрос', #14
                      text: 'Масса серо-желтого цвета  на трупе со специфическим прогорклым запахом, оставляющая на бумаге жирное пятно называется ____________ и относится к поздним трупным изменениям.',
                      hint: 'Введите правильный ответ:',
                      point: 1,
                      test_id: test.first.id},
                     {task_type: 'Открытый вопрос', #15
                      text: 'Тромбоэмболия легочных артерий при переломе бедренных костей является его________________',
                      hint: 'Введите правильный ответ:',
                      point: 1,
                      test_id: test.first.id},
                     {task_type: 'Открытый вопрос', #16
                      text: 'Тромбоэмболия легочных артерий при переломе бедренных костей является его________________',
                      hint: 'Введите правильный ответ:',
                      point: 1,
                      test_id: test.first.id},
                     {task_type: 'Открытый вопрос', #17
                      text: 'При комнатной температуре в первые 6 часов скорость охлаждения трупа обычно составляет ___________ градус в час.',
                      hint: 'Введите правильный ответ:',
                      point: 1,
                      test_id: test.first.id},
                     {task_type: 'Открытый вопрос', #18
                      text: 'Комплекс патологических изменений органов и систем при термических ожогах получил название ________________',
                      hint: 'Введите правильный ответ:',
                      point: 1,
                      test_id: test.first.id},
                     {task_type: 'Последовательность', #21 (19 и 20 пропущены из бумажной версии)
                      text: 'Стадии асфиктического периода при механической асфиксии:',
                      hint: 'Установите правильную последовательность процессов:',
                      point: 1,
                      test_id: test.first.id},
                     {task_type: 'Последовательность', #22
                      text: 'Порядок наружного исследования трупа:',
                      hint: 'Установите правильную последовательность процессов:',
                      point: 1,
                      test_id: test.first.id},
                     {task_type: 'Сопоставление', #23
                      text: '',
                      hint: 'Установите соответствие: положений, субъектов, объектов',
                      point: 1,
                      test_id: test.first.id},
                     {task_type: 'Сопоставление', #24
                      text: '',
                      hint: 'Установите соответствие: положений, субъектов, объектов',
                      point: 1,
                      test_id: test.first.id},
                     {task_type: 'Единичный выбор', #109
                      text: 'Пациент, 24 лет. Болен в течение 6 месяцев.Трехкратно анализ на грибы отрицательный. Наиболее вероятным диагнозом является:',
                      hint: 'Выберите наиболее правильный и полный ответ:',
                      point: 1,
                      test_id: test.second.id},
                     {task_type: 'Единичный выбор', #110
                      text: 'Пациент 16 лет. Болен в течение 2,5 лет. Лечился по поводу онихомикоза системными антимикотическими препаратами - без эффекта. Наиболее вероятным диагнозом является:',
                      hint: 'Выберите наиболее правильный и полный ответ:',
                      point: 1,
                      test_id: test.second.id},
                     {task_type: 'Множественный выбор', #83
                      text: 'У ребенка установлен диагноз микроспории волосистой части головы. Укажите клинические симптомы, наблюдающиеся при этом заболевании:',
                      hint: 'Выберите наиболее правильный и полный ответ:',
                      point: 1,
                      test_id: test.second.id},
                     {task_type: 'Множественный выбор', #84
                      text: 'К препаратам, тормозящим высвобождение медиаторных веществ из тучных клеток, относятся',
                      hint: 'Выберите наиболее правильный и полный ответ:',
                      point: 1,
                      test_id: test.second.id},
                     {task_type: 'Единичный выбор', #пример видео
                      text: 'При патологоанатомическом исследовании сердца в области верхушки и передней стенки левого желудочка обнаружено истончение стенки до 0,3 см в поперечнике с выбуханием ее в виде мешка. Левый желудочек в месте выбухания представлен белого цвета плотной тканью, со стороны эндокарда заполнен тромботическими массами. Передняя межжелудочковая ветвь левой коронарной артерии резко стенозирована атеросклеротическими бляшками. Сделайте заключение о патологическом процессе по описанным изменениям со стороны сердца.',
                      hint: 'Выберите один вариант ответ, который считаете правильным:',
                      point: 1,
                      test_id: test.third.id},
                     {task_type: 'Единичный выбор', #пример аудио
                      text: 'У молодого человека 22 лет на задней поверхности шеи подкожно длительное время располагалось образование диаметром 5 см, чётко отграниченное от окружающих тканей, мягкое, подвижное. В последнее время образование стало мешать, травмироваться одеждой, в связи с чем было удалено. Макроскопически операционный материал выглядит как конгломерат жировой ткани с тонкими белесыми прослойками, кровоизлияниями, микроскопически состоит из жировых клеток неправильной формы и неодинаковых размеров, полей и прослоек соединительной ткани. Сделайте заключение о патологическом образовании по описанным изменениям.',
                      hint: 'Выберите один вариант ответ, который считаете правильным:',
                      point: 1,
                      test_id: test.third.id}])
Answer.create([{correct: false, # 1
                text: 'Локализация разрыва сердца',
                point: '',
                serial_number: '',
                task_id: tasks.first.id},
               {correct: false,
                text: 'Состояние кровоизлияния в сердечной сорочке',
                point: '',
                serial_number: '',
                task_id: tasks.first.id},
               {correct: false,
                text: 'Повреждение сердечной сорочки',
                point: '',
                serial_number: '',
                task_id: tasks.first.id},
               {correct: false,
                text: 'Развитие инфаркта миокарда',
                point: '',
                serial_number: '',
                task_id: tasks.first.id},
               {correct: true,
                text: 'Состояние и объем излившейся в полость сердечной сорочки крови',
                point: '',
                serial_number: '',
                task_id: tasks.second.id},
               {correct: false, #2
                text: '30 минут -1 часа',
                point: '',
                serial_number: '',
                task_id: tasks.second.id},
               {correct: true,
                text: '1 часа 30 минут – 2 часов',
                point: '',
                serial_number: '',
                task_id: tasks.second.id},
               {correct: false,
                text: '2 - 4 часов',
                point: '',
                serial_number: '',
                task_id: tasks.second.id},
               {correct: false,
                text: '2 - 3  часов',
                point: '',
                serial_number: '',
                task_id: tasks.second.id},
               {correct: false,
                text: '4-6 часов',
                point: '',
                serial_number: '',
                task_id: tasks.second.id},
               {correct: true, # 3
                text: 'Ярко-красному цвету трупных пятен',
                point: '',
                serial_number: '',
                task_id: tasks.third.id},
               {correct: false,
                text: 'Алому цвету крови в сосудах',
                point: '',
                serial_number: '',
                task_id: tasks.third.id},
               {correct: false,
                text: 'Позе трупа',
                point: '',
                serial_number: '',
                task_id: tasks.third.id},
               {correct: false,
                text: 'Темно-вишневому цвету трупных пятен',
                point: '',
                serial_number: '',
                task_id: tasks.third.id},
               {correct: false,
                text: 'Узким зрачкам',
                point: '',
                serial_number: '',
                task_id: tasks.third.id},
               {correct: true, # 4
                text: 'Стойкая гиперемия головного мозга, петехиальные кровоизлияния в веществе головного мозга, наличие капелек жира в крови, милиарные очаги некроза в веществе головного мозга',
                point: '',
                serial_number: '',
                task_id: tasks.fourth.id},
               {correct: false,
                text: 'Милиарные очаги некроза в веществе головного мозга',
                point: '',
                serial_number: '',
                task_id: tasks.fourth.id},
               {correct: false,
                text: 'Стойкая гиперемия головного мозга',
                point: '',
                serial_number: '',
                task_id: tasks.fourth.id},
               {correct: false,
                text: 'Миоглобинурийный некротический нефроз',
                point: '',
                serial_number: '',
                task_id: tasks.fourth.id},
               {correct: false,
                text: 'Малокровие селезёнки',
                point: '',
                serial_number: '',
                task_id: tasks.fourth.id},
               {correct: false, #5
                text: 'Эректильная',
                point: '',
                serial_number: '',
                task_id: tasks.fifth.id},
               {correct: false,
                text: 'Торпидная',
                point: '',
                serial_number: '',
                task_id: tasks.fifth.id},
               {correct: false,
                text: 'Некробиотических изменений',
                point: '',
                serial_number: '',
                task_id: tasks.fifth.id},
               {correct: false,
                text: 'Септических осложнений',
                point: '',
                serial_number: '',
                task_id: tasks.fifth.id},
               {correct: true,
                text: 'Травматического шока и кровопотери',
                point: '',
                serial_number: '',
                task_id: tasks.fifth.id},
               {correct: false, #6
                text: 'Всегда',
                point: '',
                serial_number: '',
                task_id: tasks[5].id},
               {correct: false,
                text: 'При внутричерепных гематомах',
                point: '',
                serial_number: '',
                task_id: tasks[5].id},
               {correct: false,
                text: 'При повреждениях сердца',
                point: '',
                serial_number: '',
                task_id: tasks[5].id},
               {correct: false,
                text: 'При повреждении лобной доли головного мозга',
                point: '',
                serial_number: '',
                task_id: tasks[5].id},
               {correct: true,
                text: 'При повреждении стволового отдела головного мозга',
                point: '',
                serial_number: '',
                task_id: tasks[5].id},
               {correct: false, #7
                text: 'Зондирования раневого канала',
                point: '',
                serial_number: '',
                task_id: tasks[6].id},
               {correct: false,
                text: 'Обмывания загрязнений вокруг ран',
                point: '',
                serial_number: '',
                task_id: tasks[6].id},
               {correct: false,
                text: 'Иссечения кожных препаратов с ранами',
                point: '',
                serial_number: '',
                task_id: tasks[6].id},
               {correct: true,
                text: 'Описания и фотографирования повреждений, установления  анатомической и метрической локализации повреждений',
                point: '',
                serial_number: '',
                task_id: tasks[6].id},
               {correct: false,
                text: 'Пальпации ран',
                point: '',
                serial_number: '',
                task_id: tasks[6].id},
               {correct: false, #8
                text: 'Обнаружения и извлечения пули',
                point: '',
                serial_number: '',
                task_id: tasks[7].id},
               {correct: false,
                text: 'Осмотра внутренних органов до извлечения',
                point: '',
                serial_number: '',
                task_id: tasks[7].id},
               {correct: true,
                text: 'Осмотра внутренних органов до извлечения и затем их  выделения  единым   комплексом',
                point: '',
                serial_number: '',
                task_id: tasks[7].id},
               {correct: false,
                text: 'Выделения внутренних органов в отдельности',
                point: '',
                serial_number: '',
                task_id: tasks[7].id},
               {correct: false,
                text: 'Описания повреждений внутренних органов',
                point: '',
                serial_number: '',
                task_id: tasks[7].id},
               {correct: false, #9
                text: '«Пестрый» рисунок легкого на разрезе с множественными темно-красными участками',
                point: '',
                serial_number: '',
                task_id: tasks[8].id},
               {correct: false,
                text: '«Мраморная» окраска кожных покровов',
                point: '',
                serial_number: '',
                task_id: tasks[8].id},
               {correct: true,
                text: 'Карминовый отек легких',
                point: '',
                serial_number: '',
                task_id: tasks[8].id},
               {correct: false,
                text: 'Острая эмфизема легких',
                point: '',
                serial_number: '',
                task_id: tasks[8].id},
               {correct: false,
                text: 'Тромбоэмболия  легочной артерии',
                point: '',
                serial_number: '',
                task_id: tasks[8].id},
               {correct: false, #10
                text: 'Прижизненности и переживаемости травмы',
                point: '',
                serial_number: '',
                task_id: tasks[9].id},
               {correct: false,
                text: 'Острой почечной недостаточности',
                point: '',
                serial_number: '',
                task_id: tasks[9].id},
               {correct: true,
                text: 'Отеке головного мозга',
                point: '',
                serial_number: '',
                task_id: tasks[9].id},
               {correct: false,
                text: 'Синдроме позиционного давления',
                point: '',
                serial_number: '',
                task_id: tasks[9].id},
               {correct: false,
                text: 'Травматическом шоке',
                point: '',
                serial_number: '',
                task_id: tasks[9].id},
               {correct: true, # 13 (11 и 12 пропущены из бумажной версии)
                text: 'высыханием',
                point: '',
                serial_number: '',
                task_id: tasks[10].id},
               {correct: true, #14
                text: 'жировоск',
                point: '',
                serial_number: '',
                task_id: tasks[11].id},
               {correct: true, #15
                text: 'осложнением',
                point: '',
                serial_number: '',
                task_id: tasks[12].id},
               {correct: true, #16
                text: '5',
                point: '',
                serial_number: '',
                task_id: tasks[13].id},
               {correct: true, #17
                text: 'один',
                point: '',
                serial_number: '',
                task_id: tasks[14].id},
               {correct: true, #18
                text: 'ожоговая болезнь',
                point: '',
                serial_number: '',
                task_id: tasks[15].id},
               {correct: false, #21
                text: 'терминальных дыхательных движений',
                point: '',
                serial_number: '4',
                task_id: tasks[16].id},
               {correct: false,
                text: 'кратковременной остановки дыхания',
                point: '',
                serial_number: '3',
                task_id: tasks[16].id},
               {correct: false,
                text: 'экспираторной одышки',
                point: '',
                serial_number: '2',
                task_id: tasks[16].id},
               {correct: false,
                text: 'полная остановка дыхания',
                point: '',
                serial_number: '5',
                task_id: tasks[16].id},
               {correct: false,
                text: 'инспираторной одышки',
                point: '',
                serial_number: '1',
                task_id: tasks[16].id},
               {correct: false, #22
                text: 'фотографирование повреждений',
                point: '',
                serial_number: '5',
                task_id: tasks[17].id},
               {correct: false,
                text: 'антропологическая и половая характеристики трупа',
                point: '',
                serial_number: '2',
                task_id: tasks[17].id},
               {correct: false,
                text: 'исследование одежды и обуви',
                point: '',
                serial_number: '1',
                task_id: tasks[17].id},
               {correct: false,
                text: 'исследование трупных явлений и суправитальных реакций',
                point: '',
                serial_number: '3',
                task_id: tasks[17].id},
               {correct: false,
                text: 'взятие мазков',
                point: '',
                serial_number: '6',
                task_id: tasks[17].id},
               {correct: false,
                text: 'описание повреждений и иных особенностей',
                point: '',
                serial_number: '4',
                task_id: tasks[17].id},
               {correct: true, #23 - сопоставление левая колонка
                text: 'Жировоск',
                point: '',
                serial_number: '1',
                task_id: tasks[18].id},
               {correct: true,
                text: 'Умирание',
                point: '',
                serial_number: '2',
                task_id: tasks[18].id},
               {correct: true,
                text: 'Торфяное дубление',
                point: '',
                serial_number: '3',
                task_id: tasks[18].id},
               {correct: true,
                text: 'Суправитальные реакции',
                point: '',
                serial_number: '4',
                task_id: tasks[18].id},
               {correct: true, #24 - сопоставление левая колонка
                text: 'Пятна Тардье',
                point: '',
                serial_number: '1',
                task_id: tasks[19].id},
               {correct: true,
                text: 'Фигуры «колосьев» в легких',
                point: '',
                serial_number: '2',
                task_id: tasks[19].id},
               {correct: true,
                text: 'Карминовый отек легких',
                point: '',
                serial_number: '3',
                task_id: tasks[19].id},
               {correct: true,
                text: 'Поперечные разрывы интимы сонных артерий',
                point: '',
                serial_number: '4',
                task_id: tasks[19].id},
               {correct: true, # 109
                text: 'Ладонно-подошвенный псориаз',
                point: '',
                serial_number: '',
                task_id: tasks[20].id},
               {correct: false,
                text: 'Папулезный сифилид',
                point: '',
                serial_number: '',
                task_id: tasks[20].id},
               {correct: false,
                text: 'Красный плоский лишай',
                point: '',
                serial_number: '',
                task_id: tasks[20].id},
               {correct: false,
                text: 'Экзема',
                point: '',
                serial_number: '',
                task_id: tasks[20].id},
               {correct: false, # 110
                text: 'Травматическая ониходистрофия',
                point: '',
                serial_number: '',
                task_id: tasks[21].id},
               {correct: true,
                text: 'Псориатическаяониходистрофия',
                point: '',
                serial_number: '',
                task_id: tasks[21].id},
               {correct: false,
                text: 'Онихомикоз',
                point: '',
                serial_number: '',
                task_id: tasks[21].id},
               {correct: false,
                text: 'Кандидоз ногтей',
                point: '',
                serial_number: '',
                task_id: tasks[21].id},
               {correct: false, # 83
                text: 'очаги рубцовой атрофии',
                point: '',
                serial_number: '',
                task_id: tasks[22].id},
               {correct: true,
                text: 'очаги поражения с обломанными волосами',
                point: '',
                serial_number: '',
                task_id: tasks[22].id},
               {correct: false,
                text: 'фолликулярный гиперкератоз',
                point: '',
                serial_number: '',
                task_id: tasks[22].id},
               {correct: true,
                text: 'небольшая гиперемия и шелушение',
                point: '',
                serial_number: '',
                task_id: tasks[22].id},
               {correct: true, # 84
                text: 'кромолин-натрий',
                point: '',
                serial_number: '',
                task_id: tasks[23].id},
               {correct: false,
                text: 'циметидин',
                point: '',
                serial_number: '',
                task_id: tasks[23].id},
               {correct: true,
                text: 'задитен',
                point: '',
                serial_number: '',
                task_id: tasks[23].id},
               {correct: false,
                text: 'фамотидин',
                point: '',
                serial_number: '',
                task_id: tasks[23].id},
               {correct: true, # пример видео
                text: 'Постинфарктный кардиосклероз',
                point: '',
                serial_number: '',
                task_id: tasks[24].id},
               {correct: false,
                text: 'Острая аневризма сердца',
                point: '',
                serial_number: '',
                task_id: tasks[24].id},
               {correct: false,
                text: 'Атеросклеротический кардиосклероз',
                point: '',
                serial_number: '',
                task_id: tasks[24].id},
               {correct: false,
                text: 'Хроническая аневризма сердца',
                point: '',
                serial_number: '',
                task_id: tasks[24].id},
               {correct: true, # пример аудио
                text: 'Липома',
                point: '',
                serial_number: '',
                task_id: tasks[25].id},
               {correct: false,
                text: 'Аденома',
                point: '',
                serial_number: '',
                task_id: tasks[25].id},
               {correct: false,
                text: 'Фиброма',
                point: '',
                serial_number: '',
                task_id: tasks[25].id},
               {correct: false,
                text: 'Липосаркома',
                point: '',
                serial_number: '',
                task_id: tasks[25].id}])
Association.create([{text: 'Естественная консервация трупа', # 23 (колонка справа ассоциации)
                     serial_number: '3',
                     task_id: tasks[18].id},
                    {text: 'Высыхание в жарких условиях внешней среды',
                     serial_number: '6',
                     task_id: tasks[18].id},
                    {text: 'Предагональное состояние, терминальная пауза, агония',
                     serial_number: '2',
                     task_id: tasks[18].id},
                    {text: 'Раздражение гортани',
                     serial_number: '5',
                     task_id: tasks[18].id},
                    {text: 'Недостаток аэрации, избыток влаги, относительно низкая температура',
                     serial_number: '1',
                     task_id: tasks[18].id},
                    {text: 'Введение 1% раствора атропина в переднюю камеру глаза',
                     serial_number: '4',
                     task_id: tasks[18].id},

                    {text: 'Компрессионная асфиксия', # 24 (колонка справа ассоциации)
                     serial_number: '3',
                     task_id: tasks[19].id},
                    {text: 'Повешение',
                     serial_number: '4',
                     task_id: tasks[19].id},
                    {text: 'Острая кровопотеря',
                     serial_number: '5',
                     task_id: tasks[19].id},
                    {text: 'Острая смерть',
                     serial_number: '1',
                     task_id: tasks[19].id},
                    {text: 'Охлаждение',
                     serial_number: '2',
                     task_id: tasks[19].id},
                    {text: 'Инфаркт миокарда',
                     serial_number: '6',
                     task_id: tasks[19].id}])


TaskContent.create([{:file_content => File.new("#{Rails.root}/app/assets/media/1.jpeg"),
                     :task_id => tasks[20].id},
                    {:file_content => File.new("#{Rails.root}/app/assets/media/psoriaz-nogtej.jpg"),
                     :task_id => tasks[21].id},
                    {:file_content => File.new("#{Rails.root}/app/assets/media/video.mp4"),
                     :task_id => tasks[24].id},
                    {:file_content => File.new("#{Rails.root}/app/assets/media/audio.mp3"),
                     :task_id => tasks[25].id}])