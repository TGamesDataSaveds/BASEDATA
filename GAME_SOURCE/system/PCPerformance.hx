package system;

import flixel.FlxG;
import flixel.util.FlxTimer;

class PCPerformance
{
	private var benchmarkStartTime:Float;
	private var frameCount:Int = 0;
	private var totalFrameTime:Float = 0;
	private var benchmarkComplete:Bool = false;
	private var performanceScore:Float = 0.5; // Score por defecto (medio)
	
	public function new()
	{
		
	}
	
	public function startBenchmark():Void
	{
		benchmarkStartTime = haxe.Timer.stamp();
		frameCount = 0;
		totalFrameTime = 0;
		benchmarkComplete = false;
		
		// Ejecutar benchmark por 0.3 segundos
		new FlxTimer().start(0.3, function(_) {
			completeBenchmark();
		});
		
		// Iniciar medición de frames
		measureFrames();
	}
	
	private function measureFrames():Void
	{
		if (benchmarkComplete) return;
		
		var frameStart = haxe.Timer.stamp();
		
		// Simular algo de trabajo (crear y destruir sprites)
		performBenchmarkWork();
		
		var frameEnd = haxe.Timer.stamp();
		var frameTime = frameEnd - frameStart;
		
		totalFrameTime += frameTime;
		frameCount++;
		
		// Continuar midiendo en el siguiente frame
		new FlxTimer().start(0.016, function(_) { // ~60 FPS
			measureFrames();
		});
	}
	
	private function performBenchmarkWork():Void
	{
		// Trabajo simple para medir rendimiento
		// Crear y procesar algunos cálculos
		var testArray:Array<Float> = [];
		
		for (i in 0...1000)
		{
			testArray.push(Math.sin(i) * Math.cos(i));
		}
		
		// Ordenar el array (operación costosa)
		testArray.sort(function(a, b) {
			if (a < b) return -1;
			if (a > b) return 1;
			return 0;
		});
	}
	
	private function completeBenchmark():Void
	{
		benchmarkComplete = true;
		
		if (frameCount > 0)
		{
			var avgFrameTime = totalFrameTime / frameCount;
			var currentFPS = FlxG.drawFramerate;
			
			// Calcular score basado en FPS y tiempo de frame
			var fpsScore = Math.min(currentFPS / 60.0, 1.0); // Normalizar a 60 FPS
			var frameTimeScore = Math.max(0, 1.0 - (avgFrameTime * 1000)); // Menos tiempo = mejor
			
			// Score combinado
			performanceScore = (fpsScore * 0.7) + (frameTimeScore * 0.3);
			performanceScore = Math.max(0.1, Math.min(1.0, performanceScore)); // Entre 0.1 y 1.0
			
			trace('Benchmark Complete:');
			trace('  Average FPS: $currentFPS');
			trace('  Average Frame Time: ${avgFrameTime * 1000}ms');
			trace('  Performance Score: $performanceScore');
		}
	}
	
	public function getPerformanceScore():Float
	{
		return performanceScore;
	}
	
	public function getPerformanceCategory():String
	{
		if (performanceScore > 0.8) return "ALTO";
		else if (performanceScore > 0.5) return "MEDIO";
		else return "BAJO";
	}
}
