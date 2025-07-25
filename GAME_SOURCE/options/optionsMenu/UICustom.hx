package options.optionsMenu;

import options.BaseOptionsMenu;

class UICustom extends BaseOptionsMenu {
    
    public var color:Array<Int> = [ClientPrefs.data.R, ClientPrefs.data.G, ClientPrefs.data.B, ClientPrefs.data.A];

    public function new() {

        rpcTitle = 'UI CUSTOM SETTINGS';

        if (ClientPrefs.data.language == 'Inglish') {
            var option:Option = new Option('RED',
            'Set RED to UI Color'.toUpperCase(),
            'R',
            'Int');
            option.minValue = 0;
            option.maxValue = 255;
            option.changeValue = 1;
            option.onChange = UIColor;
            addOption(option);

            var option:Option = new Option('GREEN',
            'Set GREEN to UI Color'.toUpperCase(),
            'G',
            'Int');
            option.minValue = 0;
            option.maxValue = 255;
            option.changeValue = 1;
            option.onChange = UIColor;
            addOption(option);

            var option:Option = new Option('BLUE',
            'Set BLUE to UI Color'.toUpperCase(),
            'B',
            'Int');
            option.minValue = 0;
            option.maxValue = 255;
            option.changeValue = 1;
            option.onChange = UIColor;
            addOption(option);

            var option:Option = new Option('ALPHA',
            'Set ALPHA to UI Color'.toUpperCase(),
            'A',
            'Int');
            option.minValue = 50;
            option.maxValue = 255;
            option.changeValue = 1;
            option.onChange = UIColor;
            addOption(option);

            var option:Option = new Option('Resolution:',
            'Resolution to UI',
            'ResolutionUI',
            'string',
            ['ULTRA LOW', 'LOW', 'NORMAL', 'HIGH', 'UTRA']);
            addOption(option);

            var option:Option = new Option('Animations MODE: ',
            'Animations to UI',
            'animationsMODE',
            'string',
            ['Lineal', 'Elastic', 'presition', 'neutral']);
            addOption(option);

            var option:Option = new Option('Animations Velocity:',
            'Velocity to Animations in UI',
            'animationsVEL',
            'float');
            option.minValue = 0.1;
            option.maxValue = 1;
            option.changeValue = 0.1;
            addOption(option);

            var option:Option = new Option('Input',
            'Native Input to UI',
            'InputUI',
            'string',
            ['Mouse', 'Keybord', 'Touch', 'GamePad', 'Nouse/Keybord', 'Keybord/Touch', 'GamePad/Touch', 'Mouse/Keybord/Gamepad', 'Mouse/Keybord/Touch', 'Mouse/Keybord/GamePad/Touch']);
            addOption(option);

            //More Options Comming Soon

        } else if (ClientPrefs.data.language == 'Spanish') {
            var option:Option = new Option('ROJO',
            'Establece el Rojo en la UI'.toUpperCase(),
            'R',
            'Int');
            option.minValue = 0;
            option.maxValue = 255;
            option.changeValue = 1;
            option.onChange = UIColor;
            addOption(option);

            var option:Option = new Option('Verde'.toUpperCase(),
            'Establece el VERDE en la UI'.toUpperCase(),
            'G',
            'Int');
            option.minValue = 0;
            option.maxValue = 255;
            option.changeValue = 1;
            option.onChange = UIColor;
            addOption(option);

            var option:Option = new Option('Azul'.toUpperCase(),
            'Establece el AZUL en la UI'.toUpperCase(),
            'B',
            'Int');
            option.minValue = 0;
            option.maxValue = 255;
            option.changeValue = 1;
            option.onChange = UIColor;
            addOption(option);

            var option:Option = new Option('Opacidad'.toUpperCase(),
            'Establece la Opacidad de la UI'.toUpperCase(),
            'A',
            'Int');
            option.minValue = 50;
            option.maxValue = 255;
            option.changeValue = 1;
            option.onChange = UIColor;
            addOption(option);

            var option:Option = new Option('Resolucion:'.toUpperCase(),
            'Resolucion de la UI'.toUpperCase(),
            'Resolution',
            'string',
            ['ULTRA LOW', 'LOW', 'NORMAL', 'HIGH', 'UTRA']);
            addOption(option);

            var option:Option = new Option('Modo de Animaciones: '.toUpperCase(),
            'Animaciones de la UI'.toUpperCase(),
            'animationsMODE',
            'string',
            ['Lineal', 'Elastic', 'presition', 'neutral']);
            addOption(option);

            var option:Option = new Option('Animaciones Velocidad:'.toUpperCase(),
            'Velocidad de Animaciones en la UI'.toUpperCase(),
            'animationsVEL',
            'float');
            option.minValue = 0.1;
            option.maxValue = 1;
            option.changeValue = 0.1;
            addOption(option);

            var option:Option = new Option('Entrada'.toUpperCase(),
            'Entrada Nativa de la UI'.toUpperCase(),
            'InputUI',
            'string',
            ['Mouse', 'Keybord', 'Touch', 'GamePad', 'Nouse/Keybord', 'Keybord/Touch', 'GamePad/Touch', 'Mouse/Keybord/Gamepad', 'Mouse/Keybord/Touch', 'Mouse/Keybord/GamePad/Touch']);
            addOption(option);
        } else {
            var option:Option = new Option('ROJO',
            'Establece el Rojo en la UI'.toUpperCase(),
            'R',
            'Int');
            option.minValue = 0;
            option.maxValue = 255;
            option.changeValue = 1;
            option.onChange = UIColor;
            addOption(option);

            var option:Option = new Option('Verde'.toUpperCase(),
            'Establece el VERDE en la UI'.toUpperCase(),
            'G',
            'Int');
            option.minValue = 0;
            option.maxValue = 255;
            option.changeValue = 1;
            option.onChange = UIColor;
            addOption(option);

            var option:Option = new Option('Azul'.toUpperCase(),
            'Establece el AZUL en la UI'.toUpperCase(),
            'B',
            'Int');
            option.minValue = 0;
            option.maxValue = 255;
            option.changeValue = 1;
            option.onChange = UIColor;
            addOption(option);

            var option:Option = new Option('Opacidad'.toUpperCase(),
            'Establece la Opacidad de la UI'.toUpperCase(),
            'A',
            'Int');
            option.minValue = 50;
            option.maxValue = 255;
            option.changeValue = 1;
            option.onChange = UIColor;
            addOption(option);

            var option:Option = new Option('Resolucion:'.toUpperCase(),
            'Resolucion de la UI'.toUpperCase(),
            'Resolution',
            'string',
            ['ULTRA LOW', 'LOW', 'NORMAL', 'HIGH', 'UTRA']);
            addOption(option);

            var option:Option = new Option('Modo de Animaciones: '.toUpperCase(),
            'Animaciones de la UI'.toUpperCase(),
            'animationsMODE',
            'string',
            ['Lineal', 'Elastic', 'presition', 'neutral']);
            addOption(option);

            var option:Option = new Option('Animaciones Velocidad:'.toUpperCase(),
            'Velocidad de Animaciones en la UI'.toUpperCase(),
            'animationsVEL',
            'float');
            option.minValue = 0.1;
            option.maxValue = 1;
            option.changeValue = 0.1;
            addOption(option);

            var option:Option = new Option('Entrada'.toUpperCase(),
            'Entrada Nativa de la UI'.toUpperCase(),
            'InputUI',
            'string',
            ['Mouse', 'Keybord', 'Touch', 'GamePad', 'Nouse/Keybord', 'Keybord/Touch', 'GamePad/Touch', 'Mouse/Keybord/Gamepad', 'Mouse/Keybord/Touch', 'Mouse/Keybord/GamePad/Touch']);
            addOption(option);
        }

        super();
    }

    public function UIColor() {
        BaseOptionsMenu.colorNew(ClientPrefs.data.R, ClientPrefs.data.G, ClientPrefs.data.B, ClientPrefs.data.A);
    }
}