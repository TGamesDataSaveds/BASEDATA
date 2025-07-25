package options.optionsMenu;

class SupportMenu extends BaseOptionsMenu {

    public function new() {
        title = 'Support Menu';
        rpcTitle = 'Support Settings';

        if (ClientPrefs.data.language == 'Spanish') {
            var option:Option = new Option('Eliminar Cache',
            'Esto ayuda a tener mas espacio en la cache de la RAM\n!!ELIMINA TODO DATO PRECARGADO!!',
            'deleteCache',
            'bool');
            addOption(option);

            var option:Option = new Option('Saltar Title',
            'Si hay algun problema en el Title sera saltada de forma Inmediata',
            'skipTItle',
            'bool');
            addOption(option);

            var option:Option = new Option('Bloquear IA',
            'Si la IA esta sufriendo problemas puedes desabilitarla\n!!FUNCIONES BLOQUEADAS Y LIMITADAS!!',
            'blockedIA',
            'bool');
            addOption(option);

            var option:Option = new Option('Metodo de Registro',
            'Este es el metodo que utiliza el sistema para verificar que los datos ingresados son correctos y los datos Guardados',
            'typeLOGIN',
            'string',
            ['SERVER', 'URL EXTERNAL', 'GITHUB']);
            addOption(option);

            var option:Option = new Option('Reportes de Problemas',
            'En el momento que el juego detecte una actividad inusual en el juego, enviara un informe a "tgames.yt.official@gmail.com"',
            'reportProblem',
            'bool');
            addOption(option);

            var option:Option = new Option('Precarga imagenes en Full HD(1080p)',
            'El precargar imagenes en Full HD(1080p) puede resultar bueno para la calidad grafica pero no muy bueno para el rendimiento',
            'preloadFULLHD',
            'bool');
            addOption(option);

            var option:Option = new Option('INFORME DE INICIAR SESION',
            'Enviara un reporte cuando inicies sesion y lo almacenara en las estadisticas de tu cuenta, si este reporte es sosperchoso se enviara una alerta a tu cuenta',
            'reportLOGIN',
            'bool');
            addOption(option);

            var option:Option = new Option('CUADROS POR SEGUNDOS DE DIBUJADOS',
            'Ajustara los cuadros por Segundo en los que se dibujara los graficos en pantalla',
            'framerateDraw',
            'int');
            option.minValue = 30;
            option.maxValue = 240;
            option.displayFormat = "%v FPS Dibujo";
            option.onChange = onDRAW;
            addOption(option);

            var option:Option = new Option('CUADROS POR SEGUNDOS DE ACTUALIZACION',
            'Ajustara los cuadros por segundo en los que se actualiza tu pantalla',
            'framerateUpdate',
            'int');
            option.minValue = 30;
            option.maxValue = 240;
            option.displayFormat = "%v FPS Actualizacion";
            option.onChange = onUPDATE;
            addOption(option);

        } else if (ClientPrefs.data.language == 'Inglish') {

            var option:Option = new Option('Delete Cache',
            'This helps to have more space in the RAM cache\n!! DELETE ALL PRELOADED DATA!!',
            'deleteCache',
            'bool');
            addOption(option);

            var option:Option = new Option('Skip Title',
            'If there is any problem in the Title it will be skipped immediately',
            'skipTItle',
            'bool');
            addOption(option);

            var option:Option = new Option('Block AI',
            'If the AI is having problems you can disable it\n!!BLOCKED AND LIMITED FUNCTIONS!!',
            'blockedIA',
            'bool');
            addOption(option);

            var option:Option = new Option('Registration Method',
            'This is the method that the system uses to verify that the data entered is correct and the data saved',
            'typeLOGIN',
            'string',
            ['SERVER', 'URL EXTERNAL', 'GITHUB']);
            addOption(option);

            var option:Option = new Option('Problem Reports',
            'The moment the game detects unusual activity in the game, it will send a report to "tgames.yt.official@gmail.com"',
            'reportProblem',
            'bool');
            addOption(option);

            var option:Option = new Option('Preload images in Full HD (1080p)',
            'Preloading images in Full HD (1080p) can be good for graphic quality but not very good for performance',
            'preloadFULLHD',
            'bool');
            addOption(option);

            var option:Option = new Option('LOGIN REPORT',
            'It will send a report when you log in and store it in your account statistics. If this report is suspicious, an alert will be sent to your account.',
            'reportLOGIN',
            'bool');
            addOption(option);

            var option:Option = new Option('FRAMERATE OF DRAW',
            'It will adjust the frames per second in which the graphics will be drawn on the screen.',
            'framerateDraw',
            'int');
            option.minValue = 30;
            option.maxValue = 240;
            option.displayFormat = "%v FPS Draw";
            option.onChange = onDRAW;
            addOption(option);

            var option:Option = new Option('FRAMERATE OF UPDATE',
            'It will adjust the frames per second at which your screen updates.',
            'framerateUpdate',
            'int');
            option.minValue = 30;
            option.maxValue = 240;
            option.displayFormat = "%v FPS Update";
            option.onChange = onUPDATE;
            addOption(option);

        } else if (ClientPrefs.data.language == 'Portuguese') {

            var option:Option = new Option('Excluir cache',
            'Isso ajuda a ter mais espaço no cache RAM\n!! EXCLUIR TODOS OS DADOS PRÉ-CARREGADOS!!',
            'deleteCache',
            'bool');
            addOption(option);

            var option:Option = new Option('Pular título',
            'Se houver algum problema no título, ele será ignorado imediatamente',
            'skipTItle',
            'bool');
            addOption(option);

            var option:Option = new Option('Bloquear IA',
            'Se a IA estiver com problemas, você pode desativá-la\n!!FUNÇÕES BLOQUEADAS E LIMITADAS!!',
            'blockedIA',
            'bool');
            addOption(option);

            var option:Option = new Option('Método de registro',
            'Este é o método que o sistema utiliza para verificar se os dados inseridos estão corretos e os dados salvos',
            'typeLOGIN',
            'string',
            ['SERVER', 'URL EXTERNAL', 'GITHUB']);
            addOption(option);

            var option:Option = new Option('Relatórios de problemas',
            'No momento em que o jogo detectar atividades incomuns no jogo, ele enviará um relatório para "tgames.yt.official@gmail.com"',
            'reportProblem',
            'bool');
            addOption(option);

            var option:Option = new Option('Pré-carregar imagens em Full HD (1080p)',
            'Pré-carregar imagens em Full HD (1080p) pode ser bom para qualidade gráfica, mas não muito bom para desempenho',
            'preloadFULLHD',
            'bool');
            addOption(option);

            var option:Option = new Option('RELATÓRIO DE LOGIN',
            'Ele enviará um relatório quando você fizer login e o armazenará nas estatísticas da sua conta. Se esta denúncia for suspeita, um alerta será enviado para sua conta.',
            'reportLOGIN',
            'bool');
            addOption(option);

            var option:Option = new Option('QUADROS POR SEGUNDOS DE DESENHO',
            'Ajustara los cuadros por Segundo en los que se dibujara los graficos en pantalla',
            'framerateDraw',
            'int');
            option.minValue = 30;
            option.maxValue = 240;
            option.displayFormat = "%v FPS Desenho";
            option.onChange = onDRAW;
            addOption(option);

            var option:Option = new Option('ATUALIZAÇÃO DE FRAMES POR SEGUNDOS',
            'Ajustara los cuadros por segundo en los que se actualiza tu pantalla',
            'framerateUpdate',
            'int');
            option.minValue = 30;
            option.maxValue = 240;
            option.displayFormat = "%v FPS Atualizar";
            option.onChange = onUPDATE;
            addOption(option);
        }

        super();
    }

    function onUPDATE() {
        FlxG.updateFramerate = ClientPrefs.data.framerateUpdate;
    }

    function onDRAW() {
        FlxG.drawFramerate = ClientPrefs.data.framerateDraw;
    }
}