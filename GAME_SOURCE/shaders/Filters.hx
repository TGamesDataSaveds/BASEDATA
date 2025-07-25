package shaders;

import openfl.filters.BitmapFilter;
import openfl.filters.BlurFilter;
import openfl.filters.ColorMatrixFilter;
#if shaders_supported
#if (openfl >= "8.0.0")
import openfl8.*;
#else
import openfl3.*;
#end
import openfl.filters.ShaderFilter;
import openfl.Lib;
#end

class Filters {

    	//Filter
	var filterMap:Map<String, {filter:BitmapFilter, ?onUpdate:Void->Void}>;
	var filters:Array<BitmapFilter> = [];

    public function new(cam:FlxCamera = null, ?cam2:FlxCamera = null, ?cam3:FlxCamera = null, ?cam4:FlxCamera = null, ?cam5:FlxCamera = null, ?cam6:FlxCamera = null, ?cam7:FlxCamera = null) {
        filterMap = [
            #if shaders_supported
            "Scanline" => {
                filter: new ShaderFilter(new Scanline()),
            }, "Grain" => {
                var shader = new Grain();
                {
                    filter: new ShaderFilter(shader),
                    onUpdate: function()
                    {
                        #if (openfl >= "8.0.0")
                        shader.uTime.value = [Lib.getTimer() / 1000];
                        #else
                        shader.uTime = Lib.getTimer() / 1000;
                        #end
                    }
                }
            }
            #end
            /*"Grayscale" => {
                var matrix:Array<Float> = [
                    0.5, 0.5, 0.5, 0, 0,
                    0.5, 0.5, 0.5, 0, 0,
                    0.5, 0.5, 0.5, 0, 0,
                      0,   0,   0, 1, 0,
                ];
    
                {filter: new ColorMatrixFilter(matrix)}
            }*/
        ];

        if (cam != null) {
            cam.setFilters(filters);
            cam.filtersEnabled = true;

            if (cam2 != null) {
                cam2.setFilters(filters);
                cam2.filtersEnabled = true;
            } else {
                trace('CAMERA 2 NOT FOUND');
            }
            if (cam3 != null) {
                cam3.setFilters(filters);
                cam3.filtersEnabled = true;
            } else {
                trace('CAMERA 3 NOT FOUND');
            }
            if (cam4 != null) {
                cam4.setFilters(filters);
                cam4.filtersEnabled = true;
            } else {
                trace('CAMERA 4 NOT FOUND');
            }
            if (cam5 != null) {
                cam5.setFilters(filters);
                cam5.filtersEnabled = true;
            } else {
                trace('CAMERA 5 NOT FOUND');
            }
            if (cam6 != null) {
                cam6.setFilters(filters);
                cam6.filtersEnabled = true;
            } else {
                trace('CAMERA 6 NOT FOUND');
            }
            if (cam7 != null) {
                cam7.setFilters(filters);
                cam7.filtersEnabled = true;
            } else {
                trace('CAMERA 7 NOT FOUND');
            }
            for (key in filterMap.keys()) {
                filtersMode(filterMap.get(key).filter);
            }
        } else {
            FlxG.camera.setFilters(filters);
            FlxG.camera.filtersEnabled = true;
            for (key in filterMap.keys()) {
                filtersMode(filterMap.get(key).filter);
            }
            trace('CAMERA NOT FOUND.\nLOAD FILTER IN GAME');
        }
    }

    public function filtersMode(filter:BitmapFilter) {
        filters.push(filter);
    }

    public function update(elapsed:Float) {
        for (filter in filterMap)
			{
				if (filter.onUpdate != null)
					filter.onUpdate();
			}
    }
}