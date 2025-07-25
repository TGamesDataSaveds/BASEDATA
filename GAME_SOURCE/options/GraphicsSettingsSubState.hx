package options;

import objects.Character;

class GraphicsSettingsSubState extends BaseOptionsMenu
{
	var antialiasingOption:Int;
	var boyfriend:Character = null;
	var sprite:FlxSprite;
	public function new()
	{
		boyfriend = new Character(840, 170, 'bf', true);
		boyfriend.setGraphicSize(Std.int(boyfriend.width * 0.75));
		boyfriend.updateHitbox();
		boyfriend.dance();
		boyfriend.animation.finishCallback = function (name:String) boyfriend.dance();
		boyfriend.visible = false;

		MusicBeatState.updatestate("Graphics Settings");

		if (ClientPrefs.data.language == 'Inglish') {
		title = 'Graphics';
		rpcTitle = 'Graphics Settings Menu'; //for Discord Rich Presence

		//I'd suggest using "Low Quality" as an example for making your own option since it is the simplest here
		var option:Option = new Option('Low Quality', //Name
			'If checked, disables some background details,\ndecreases loading times and improves performance.', //Description
			'lowQuality', //Save data variable name
			'bool'); //Variable type
		addOption(option);

		var option:Option = new Option('Anti-Aliasing',
			'If unchecked, disables anti-aliasing, increases performance\nat the cost of sharper visuals.',
			'antialiasing',
			'bool');
		option.onChange = onChangeAntiAliasing; //Changing onChange is only needed if you want to make a special interaction after it changes the value
		addOption(option);
		antialiasingOption = optionsArray.length-1;

		var option:Option = new Option('Shaders', //Name
			"If unchecked, disables shaders.\nIt's used for some visual effects, and also CPU intensive for weaker PCs.", //Description
			'shaders',
			'bool');
		addOption(option);

		var option:Option = new Option('GPU Caching', //Name
			"If checked, allows the GPU to be used for caching textures, decreasing RAM usage.\nDon't turn this on if you have a shitty Graphics Card.", //Description
			'cacheOnGPU',
			'bool');
		addOption(option);

		var option:Option = new Option('Resolution Quality',
		'It will affect the game in general by adjusting its quality, defining the sharpness.',
		'resolutionQuality',
		'string',
		['Low','Medium','High','Ultra']);
	addOption(option);

		#if !html5 //Apparently other framerates isn't correctly supported on Browser? Probably it has some V-Sync shit enabled by default, idk
		var option:Option = new Option('Framerate',
			"Pretty self explanatory, isn't it?",
			'framerate',
			'int');
		addOption(option);

		option.minValue = 30;
		option.maxValue = 240;
		option.displayFormat = '%v FPS';
		option.onChange = onChangeFramerate;
		#end

		var option:Option = new Option('Texture Reduce',
		'',
		'qualityLOW',
		'bool');
		addOption(option);

		
		var option:Option = new Option('Resolution Width:',
		"Ajust Resolution in Width",
		'resolutionWindowsWidth',
		'float');
		addOption(option);
		option.minValue = 1280;
		option.maxValue = 1920;
		option.changeValue = 20;
		option.onChange = onResolution;

		var option:Option = new Option('Resolution Height:',
		"Ajust Resolution in Height",
		'resolutionWindowsHeight',
		'float');
		addOption(option);
		option.minValue = 720;
		option.maxValue = 1080;
		option.changeValue = 20;
		option.onChange = onResolution;

		super();
		insert(1, boyfriend);
		}
		if(ClientPrefs.data.language == 'Spanish') {
			title = 'Gráficos';
			rpcTitle = 'Menú de configuración de gráficos'; //para una presencia rica en discord
	
			//Sugeriría usar "Baja calidad" como ejemplo para crear su propia opción, ya que es la más simple aquí.
			var option:Option = new Option('Baja calidad', //Nombre
				'Si está marcado, desactiva algunos detalles en segundo plano,\ndisminuye los tiempos de carga y mejora el rendimiento.', //Descripción
				'lowQuality', //Guardar nombre de variable de datos
				'bool'); //tipo de variable
			addOption(option);
	
			var option:Option = new Option('Antialiasing',
				'Si no está marcada, desactiva el suavizado \naumenta el rendimiento a costa de imágenes más nítidas.',
				'antialiasing',
				'bool');
			option.onChange = onChangeAntiAliasing; //Cambiar onChange solo es necesario si desea realizar una interacción especial después de cambiar el valor
			addOption(option);
			antialiasingOption = optionsArray.length-1;
	
			var option:Option = new Option('Sombreadores',
				"Si no está marcado, desactiva los sombreadores.\nSe utiliza para algunos efectos visuales \ntambién requiere un uso intensivo de CPU en PC más débiles.", //Description
				'shaders',
				'bool');
			addOption(option);
	
			var option:Option = new Option('Cache de GPU',
				"Si está marcado, permite que la GPU se use para almacenar texturas en caché, lo que reduce el uso de RAM.\nNo actives esta opción si tienes una tarjeta gráfica de mala calidad.", //Description
				'cacheOnGPU',
				'bool');
			addOption(option);

			var option:Option = new Option('Calidad de Resolucion',
			'Esto afecta al juego en general ajustando la nitidez\n(NO AFECTA EN EL SUAVIZADO)',
			'resolutionQuality',
			'string',
			['Low','Medium','High','Ultra']);
			addOption(option);
	
			#if !html5 //¿Aparentemente otras velocidades de fotogramas no son compatibles correctamente con el navegador? Probablemente tenga alguna mierda de V-Sync habilitada de forma predeterminada, no sé
			var option:Option = new Option('Cuadros por segundos',
				"Cantidad de Cuadros por segundos que muestra la aplicacion",
				'framerate',
				'int');
			addOption(option);
	
			option.minValue = 30;
			option.maxValue = 240;
			option.displayFormat = '%v FPS';
			option.onChange = onChangeFramerate;
			#end

			var option:Option = new Option('Reducion de Texturas',
			'Elimina la calidad de las texturas. Esto aumenta el Rendimiento',
			'qualityLOW',
			'bool');
			addOption(option);

			
			var option:Option = new Option('Resolution Width:',
			"Ajusta el ancho de la resolucion (NO AFECTA LA CALIDAD)",
			'resolutionWindowsWidth',
			'float');
			addOption(option);
			option.minValue = 1280;
			option.maxValue = 1920;
			option.changeValue = 20;
			option.onChange = onResolution;

			var option:Option = new Option('Resolution Height:',
			"Ajusta la altura de la resolucion (NO AFECTA LA CALIDAD)",
			'resolutionWindowsHeight',
			'float');
			addOption(option);
			option.minValue = 720;
			option.maxValue = 1080;
			option.changeValue = 20;
			option.onChange = onResolution;
	
			super();
			insert(1, boyfriend);
		}
		if (ClientPrefs.data.language == 'Portuguese') {
			title = 'Gráficos';
			rpcTitle = 'Menu de configurações gráficas'; //for Discord Rich Presence
	
			//I'd suggest using "Low Quality" as an example for making your own option since it is the simplest here
			var option:Option = new Option('Baixa qualidade', //Name
				'Se marcada, desativa alguns detalhes do plano de fundo,\ndediminui o tempo de carregamento e melhora o desempenho.', //Description
				'lowQuality', //Save data variable name
				'bool'); //Variable type
			addOption(option);
	
			var option:Option = new Option('Anti-aliasing',
				'Se desmarcada, desativa o anti-aliasing e aumenta o desempenho\nà custa de visuais mais nítidos.',
				'antialiasing',
				'bool');
			option.onChange = onChangeAntiAliasing; //Changing onChange is only needed if you want to make a special interaction after it changes the value
			addOption(option);
			antialiasingOption = optionsArray.length-1;
	
			var option:Option = new Option('Sombreadores', //Name
				"Se desmarcado, desativa os shaders.\nÉ usado para alguns efeitos visuais e também faz uso intensivo da CPU para PCs mais fracos.", //Description
				'shaders',
				'bool');
			addOption(option);
	
			var option:Option = new Option('Cache de GPU', //Name
				"Se marcada, permite que a GPU seja usada para armazenar texturas em cache, diminuindo o uso de RAM.\nNão ative esta opção se você tiver uma placa gráfica de baixa qualidade.", //Description
				'cacheOnGPU',
				'bool');
			addOption(option);
	
			#if !html5 //Apparently other framerates isn't correctly supported on Browser? Probably it has some V-Sync shit enabled by default, idk
			var option:Option = new Option('Taxa de quadros',
				"Quadros por segundo que o jogo roda",
				'framerate',
				'int');
			addOption(option);
	
			option.minValue = 30;
			option.maxValue = 240;
			option.displayFormat = '%v FPS';
			option.onChange = onChangeFramerate;
			#end

			
			var option:Option = new Option('Resolution Width:',
			"Ajust Resolution in Width",
			'resolutionWindowsWidth',
			'float');
			addOption(option);
			option.minValue = 1280;
			option.maxValue = 1920;
			option.changeValue = 20;
			option.onChange = onResolution;

			var option:Option = new Option('Resolution Height:',
			"Ajust Resolution in Height",
			'resolutionWindowsHeight',
			'float');
			addOption(option);
			option.minValue = 720;
			option.maxValue = 1080;
			option.changeValue = 20;
			option.onChange = onResolution;
	
			super();
			insert(1, boyfriend);
		}
		if (ClientPrefs.data.language == 'Mandarin') {
			title = '%ERROR%#LANGUAGE_NOT_AVALID#%ERROR%';
			rpcTitle = '%ERROR%#LANGUAGE_NOT_AVALID#%ERROR%'; //for Discord Rich Presence
	
			//I'd suggest using "Low Quality" as an example for making your own option since it is the simplest here
			var option:Option = new Option('%ERROR%', //Name
				'%ERROR%', //Description
				'', //Save data variable name
				'bool'); //Variable type
			addOption(option);
	
			var option:Option = new Option('Anti-%ERROR%',
				'If unchecked%ERROR%les anti-aliasing, increases performan%ERROR%st of sharper visuals.',
				'',
				'bool');
			//option.onChange = onChangeAntiAliasing; //Changing onChange is only needed if you want to make a special interaction after it changes the value
			addOption(option);
			//antialiasingOption = optionsArray.length-1;
	
			var option:Option = new Option('Shaders', //Name
				"%ERROR%ensive for weaker PCs.", //Description
				'',
				'bool');
			addOption(option);
	
			var option:Option = new Option('%ERROR%', //Name
				"If checked, allows the GPU to%ERROR%you have a shitty Graphics Card.", //Description
				'',
				'bool');
			addOption(option);
	
			#if !html5 //Apparently other framerates isn't correctly supported on Browser? Probably it has some V-Sync shit enabled by default, idk
			var option:Option = new Option('%ERROR%',
				"Pretty self explanatory, isn't it?",
				'',
				'int');
			addOption(option);
	
			option.minValue = -9999;
			option.maxValue = 9999;
			option.displayFormat = '%v %ERROR%';
			//option.onChange = onChangeFramerate;
			#end

			var option:Option = new Option('%ERROR%',
			"%ERROR%",
			'',
			'Int');
			addOption(option);
			option.minValue = -9999;
			option.maxValue = 9999;
			option.displayFormat = '%v %ERROR%';

			
			var option:Option = new Option('%ERROR%',
			"Ajust Resolution in Width",
			'',
			'float');
			addOption(option);
			option.minValue = -9999;
			option.maxValue = 9999;
			option.changeValue = 20;
			//option.onChange = onResolution;

			var option:Option = new Option('Resolution Height:',
			"%ERROR%",
			'',
			'float');
			addOption(option);
			option.minValue = -9999;
			option.maxValue = 9999;
			option.changeValue = 20;
			//option.onChange = onResolution;
	
			super();
			insert(1, boyfriend);
			}
		}

	function onChangeAntiAliasing()
	{
			sprite = cast sprite;
			if(sprite != null && (sprite is FlxSprite) && !(sprite is FlxText)) {
				sprite.antialiasing = ClientPrefs.data.antialiasing;
			}
	}

	function onResolution() {
		Lib.application.window.width = Std.int(ClientPrefs.data.resolutionWindowsWidth);
		Lib.application.window.height = Std.int(ClientPrefs.data.resolutionWindowsHeight);
	}

	function onChangeFramerate()
	{

	}

}