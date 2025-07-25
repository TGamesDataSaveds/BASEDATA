package options.optionsMenu;

class IASettings extends BaseOptionsMenu {
    public function new() {

        rpcTitle = 'IA SETTINGS';
        
        if (ClientPrefs.data.language == 'Inglish') {
            var option:Option = new Option('IBL:',
            'The IBL is the number of requests that the AI will process. More Requests use more resources',
            'ibl',
            'float');
            option.minValue = 0.01;
            option.maxValue = 120;
            option.changeValue = 0.01;
            addOption(option);

            var option:Option = new Option('GPT version:',
            'This sets the version of the AI. newer better results. GPT 4(ALPHA)',
            'gpt',
            'string',
            ['GPT3', 'GPT3.5', 'GPT4']);
            addOption(option);

            var option:Option = new Option('DLL version:',
            'This is the file upload quality. DLL',
            'dll',
            'string',
            ['LOW', 'GOOD', 'HIGH']);
            addOption(option);

            var option:Option = new Option('Internet IA:',
            'Use some Internet AI improvements',
            'internetGPT',
            'bool');
            addOption(option);
        } else if (ClientPrefs.data.language == 'Spanish') {
            var option:Option = new Option('IBL:',
            'El IBL es la cantidad de solicitudes que pocesara la IA. mas Solicitudes utiliza mas recursos',
            'ibl',
            'float');
            option.minValue = 0.01;
            option.maxValue = 120;
            option.changeValue = 0.01;
            addOption(option);

            var option:Option = new Option('Version de GPT:',
            'Este establece la version de la IA. mas nueva mejores resultados. GPT 4(ALPHA)',
            'gpt',
            'string',
            ['GPT3', 'GPT3.5', 'GPT4']);
            addOption(option);

            var option:Option = new Option('Version de DLL:',
            'Esta es la calidad de carga de archivos. DLL',
            'dll',
            'string',
            ['LOW', 'GOOD', 'HIGH']);
            addOption(option);

            var option:Option = new Option('Internet IA:',
            'Utiliza algunas mejoras de las IA de Internet',
            'internetGPT',
            'bool');
            addOption(option);
        } else {
            var option:Option = new Option('IBL:',
            'El IBL es la cantidad de solicitudes que pocesara la IA. mas Solicitudes utiliza mas recursos',
            'ibl',
            'float');
            option.minValue = 0.01;
            option.maxValue = 120;
            option.changeValue = 0.01;
            addOption(option);

            var option:Option = new Option('Version de GPT:',
            'Este establece la version de la IA. mas nueva mejores resultados. GPT 4(ALPHA)',
            'gpt',
            'string',
            ['GPT3', 'GPT3.5', 'GPT4']);
            addOption(option);

            var option:Option = new Option('Version de DLL:',
            'Esta es la calidad de carga de archivos. DLL',
            'dll',
            'string',
            ['LOW', 'GOOD', 'HIGH']);
            addOption(option);

            var option:Option = new Option('Internet IA:',
            'Utiliza algunas mejoras de las IA de Internet',
            'internetGPT',
            'bool');
            addOption(option);
        }
        super();
    }
}