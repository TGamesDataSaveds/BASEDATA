package options;

class OptimizationsSubState extends BaseOptionsMenu {
    public function new() {

        ClientPrefs.loadPrefs();
        MusicBeatState.updatestate("Optimizations Settings");
        if (ClientPrefs.data.language == 'Spanish') {
            title = 'Ajustes de Optimizacion';
            rpcTitle = 'Menu de Ajustes de optimizacion';

            var option:Option = new Option("Eliminar Animaciones",
            "Elimina las animaciones mas pesadas y que consuman muchos recursos",
            "noneAnimations",
            "bool");
            addOption(option);

            var option:Option = new Option("Eliminar Fondos Animados",
            "Elimina los Fondos Animados como el del 'Menu Principal'",
            "noneBGAnimated",
            "bool");
            addOption(option);

            var option:Option = new Option("Eliminar Acciones Continuas",
            "Elimina comprobaciones constantes como ubicaciones de Sprites\no Actualizacion constantes de Input",
            "noneFixeds",
            "bool");
            addOption(option);

            var option:Option = new Option("Movimiento de Almacen",
            "Mueve la carga de trabajo entre la memoria RAM y la GPU",
            "movedComponents",
            "bool");
            addOption(option);

            var option:Option = new Option("Eliminar actualizacion de States",
            "Elimina la actualizacion del titulo del juego dependiendo de tus ajustes",
            "updateState",
            "bool");
            addOption(option);

            var option:Option = new Option("Eliminar Conexiones",
            "Elimina cualquier conexion de internet o alguna otra conexion\n!!Este Ajuste puede dar errores en algunos Luagares!!",
            "noneNet",
            "bool");
            addOption(option);

            var option:Option = new Option("Eliminar PreCargas",
            "Elimina cualquier PreCarga de Sprites o algun sonido\nEste puede tener un resultado diferente en otros Dispositivos",
            "nonePost",
            "bool");
            addOption(option);

            var option:Option = new Option("Elimina Deteccion de Mods",
            "Elimina cualquier comprobacion de archivos de Mods",
            "noneMods",
            "bool");
            addOption(option);

            var option:Option = new Option("Eliminar plugins",
            "Esto elimina cualquier funcion de un Plugin anadido\n!!No cargara Ningun plugin!! Recuerda desactivarlo para poder cargar plugins",
            "nonePlugins",
            "bool");
            addOption(option);

            var option:Option = new Option("Carga Inicial",
            "Es la carga inicial al iniciar el juego",
            "startLoad",
            "bool");
            addOption(option);

            var option:Option = new Option("Metodo de Carga",
            "RAM: Carga todo en la Cache de la RAM. TEMPORAL\nSTORGE: Almacena en el almacenamiento. LARGO PLAZO\nGPU: Almacena todo en la cache de la GPU. TEMPORAL pero RAPIDO\nNONE: CARGA tODA LA PANTALLA. RAPIDO pero muy Exigente en COMPONENTES",
            "loadMethor",
            "string",
            ['RAM', 'STORGE', 'GPU', 'NONE']);
            addOption(option);

            var option:Option = new Option("Redimención de ventana Automatica",
            "Redimenciona de forma automatica la altura y anchura de la ventana al iniciar el juego.",
            "resizeAuto",
            "bool");
            addOption(option);

            /*var option:Option = new Option("Ajustes Actualizandose",
            "Esto hace que todo se ajuste de forma automatica\n!!Esto puede dar error solo para PCs de pocos recursos!!\n[NO RECOMENDADO PARA PCs QUE CUMPLAN CON LOS REQUISITOS MINIMOS]",
            "updateSettings",
            "bool");
            addOption(option);*/
        }



        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////





        if (ClientPrefs.data.language == 'Inglish') {
            title = 'Ajustes de Optimizacion';
            rpcTitle = 'Menu de Ajustes de optimizacion';

            var option:Option = new Option("Eliminar Animaciones",
            "Elimina las animaciones mas pesadas y que consuman muchos recursos",
            "noneAnimations",
            "bool");
            addOption(option);

            var option:Option = new Option("Eliminar Fondos Animados",
            "Elimina los Fondos Animados como el del 'Menu Principal'",
            "noneBGAnimated",
            "bool");
            addOption(option);

            var option:Option = new Option("Eliminar Acciones Continuas",
            "Elimina comprobaciones constantes como ubicaciones de Sprites\no Actualizacion constantes de Input",
            "noneFixeds",
            "bool");
            addOption(option);

            var option:Option = new Option("Movimiento de Almacen",
            "Mueve la carga de trabajo entre la memoria RAM y la CPU",
            "movedComponents",
            "bool");
            addOption(option);

            var option:Option = new Option("Eliminar actualizacion de States",
            "Elimina la actualizacion del titulo del juego dependiendo de tus ajustes",
            "updateState",
            "bool");
            addOption(option);

            var option:Option = new Option("Eliminar Conexiones",
            "Elimina cualquier conexion de internet o alguna otra conexion\n!!Este Ajuste puede dar errores en algunos Luagares!!",
            "noneNet",
            "bool");
            addOption(option);

            var option:Option = new Option("Eliminar PreCargas",
            "Elima cualquier PreCarga de Sprites o algun sonido\nEste puede tener un resultado diferente en otros Dispositivos",
            "nonePost",
            "bool");
            addOption(option);

            var option:Option = new Option("Elimina Deteccion de Mods",
            "Elimina cualquier comprobacion de archivos de Mods",
            "noneMods",
            "bool");
            addOption(option);

            var option:Option = new Option("Eliminar plugins",
            "Esto elimina cualquier funcion de un Plugin anadido\n!!No cargara Ningun plugin!! Recuerda desactivarlo para poder cargar plugins",
            "nonePlugins",
            "bool");
            addOption(option);

            var option:Option = new Option("Initial charge",
            "It is the initial load when starting the game",
            "startLoad",
            "bool");
            addOption(option);

            var option:Option = new Option("Charging Method",
            "RAM: Load everything into the RAM Cache. TEMPORARY\nSTORGE: Store in storage. LONG TERM\nGPU: Store everything in the GPU cache. TEMPORARY but FAST\nNONE: LOADS THE ENTIRE SCREEN. FAST but very Demanding in COMPONENTS",
            "loadMethor",
            "string",
            ['RAM', 'STORGE', 'GPU', 'NONE']);
            addOption(option);

            var option:Option = new Option("Automatic window resizing",
            "Automatically resizes the height and width of the window when starting the game.",
            "resizeAuto",
            "bool");
            addOption(option);

            /*var option:Option = new Option("Ajustes Actualizandose",
            "Esto hace que todo se ajuste de forma automatica\n!!Esto puede dar error solo para PCs de pocos recursos!!\n[NO RECOMENDADO PARA PCs QUE CUMPLAN CON LOS REQUISITOS MINIMOS]",
            "updateSettings",
            "bool");
            addOption(option);*/
        }




/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////






        if (ClientPrefs.data.language == 'Portuguese') {
            title = 'Ajustes de Optimizacion';
            rpcTitle = 'Menu de Ajustes de optimizacion';

            var option:Option = new Option("Eliminar Animaciones",
            "Elimina las animaciones mas pesadas y que consuman muchos recursos",
            "noneAnimations",
            "bool");
            addOption(option);

            var option:Option = new Option("Eliminar Fondos Animados",
            "Elimina los Fondos Animados como el del 'Menu Principal'",
            "noneBGAnimated",
            "bool");
            addOption(option);

            var option:Option = new Option("Eliminar Acciones Continuas",
            "Elimina comprobaciones constantes como ubicaciones de Sprites\no Actualizacion constantes de Input",
            "noneFixeds",
            "bool");
            addOption(option);

            var option:Option = new Option("Movimiento de Almacen",
            "Mueve la carga de trabajo entre la memoria RAM y la CPU",
            "movedComponents",
            "bool");
            addOption(option);

            var option:Option = new Option("Eliminar actualizacion de States",
            "Elimina la actualizacion del titulo del juego dependiendo de tus ajustes",
            "updateState",
            "bool");
            addOption(option);

            var option:Option = new Option("Eliminar Conexiones",
            "Elimina cualquier conexion de internet o alguna otra conexion\n!!Este Ajuste puede dar errores en algunos Luagares!!",
            "noneNet",
            "bool");
            addOption(option);

            var option:Option = new Option("Eliminar PreCargas",
            "Elima cualquier PreCarga de Sprites o algun sonido\nEste puede tener un resultado diferente en otros Dispositivos",
            "nonePost",
            "bool");
            addOption(option);

            var option:Option = new Option("Elimina Deteccion de Mods",
            "Elimina cualquier comprobacion de archivos de Mods",
            "noneMods",
            "bool");
            addOption(option);

            var option:Option = new Option("Eliminar plugins",
            "Esto elimina cualquier funcion de un Plugin anadido\n!!No cargara Ningun plugin!! Recuerda desactivarlo para poder cargar plugins",
            "nonePlugins",
            "bool");
            addOption(option);

            var option:Option = new Option("Carga inicial",
            "É o carregamento inicial ao iniciar o jogo",
            "startLoad",
            "bool");
            addOption(option);

            var option:Option = new Option("Método de carregamento",
            "RAM: Carregue tudo no cache RAM. TEMPORÁRIO\nSTORGE: Armazene em armazenamento. LONGO PRAZO\nGPU: Armazene tudo no cache da GPU. TEMPORÁRIO, mas RÁPIDO\nNONE: CARREGA A TELA INTEIRA. RÁPIDO, mas muito exigente em COMPONENTES",
            "loadMethor",
            "string",
            ['RAM', 'STORGE', 'GPU', 'NONE']);
            addOption(option);

            var option:Option = new Option("Redimensionamento automático de janela",
            "Redimensiona automaticamente a altura e a largura da janela ao iniciar o jogo.",
            "resizeAuto",
            "bool");
            addOption(option);

            /*var option:Option = new Option("Ajustes Actualizandose",
            "Esto hace que todo se ajuste de forma automatica\n!!Esto puede dar error solo para PCs de pocos recursos!!\n[NO RECOMENDADO PARA PCs QUE CUMPLAN CON LOS REQUISITOS MINIMOS]",
            "updateSettings",
            "bool");
            addOption(option);*/
        }

        super();
    }
}