package system;

class TextFormatter {
    public static function formatText(text:String):String {
        var formattedText = text;
        
        // Procesar títulos H1 (#)
        formattedText = processH1(formattedText);
        
        // Procesar títulos H3 (###)
        formattedText = processH3(formattedText);
        
        // Procesar texto en negrita (**)
        formattedText = processBold(formattedText);
        
        // Procesar viñetas (-)
        formattedText = processBullets(formattedText);
        
        // Procesar enumeraciones (1., 2., etc)
        formattedText = processEnumeration(formattedText);
        
        // Procesar texto tipo terminal (==)
        formattedText = processTerminal(formattedText);
        
        return formattedText;
    }
    
    private static function processH1(text:String):String {
        var lines = text.split("\n");
        var result = [];
        
        for (line in lines) {
            if (StringTools.startsWith(line, "# ")) {
                result.push("[size=24][b]" + line.substr(2) + "[/b][/size]");
            } else {
                result.push(line);
            }
        }
        
        return result.join("\n");
    }
    
    private static function processH3(text:String):String {
        var lines = text.split("\n");
        var result = [];
        
        for (line in lines) {
            if (StringTools.startsWith(line, "### ")) {
                result.push("[size=18][b]" + line.substr(4) + "[/b][/size]");
            } else {
                result.push(line);
            }
        }
        
        return result.join("\n");
    }
    
    private static function processBold(text:String):String {
        var parts = text.split("**");
        var result = "";
        var inBold = false;
        
        for (i in 0...parts.length) {
            if (i > 0) {
                result += inBold ? "[/b]" : "[b]";
            }
            result += parts[i];
            inBold = !inBold;
        }
        
        return result;
    }
    
    private static function processBullets(text:String):String {
        var lines = text.split("\n");
        var result = [];
        
        for (line in lines) {
            if (StringTools.startsWith(line, "- ")) {
                result.push("• " + line.substr(2));
            } else {
                result.push(line);
            }
        }
        
        return result.join("\n");
    }
    
    private static function processEnumeration(text:String):String {
        var lines = text.split("\n");
        var result = [];
        
        for (line in lines) {
            var numberMatch = ~/^(\d+)\.\s+(.+)$/;
            if (numberMatch.match(line)) {
                result.push(numberMatch.matched(1) + ". " + numberMatch.matched(2));
            } else {
                result.push(line);
            }
        }
        
        return result.join("\n");
    }
    
    private static function processTerminal(text:String):String {
        var parts = text.split("==");
        var result = "";
        var inTerminal = false;
        
        for (i in 0...parts.length) {
            if (i > 0) {
                result += inTerminal ? "[/font]" : "[font=monospace]";
            }
            result += parts[i];
            inTerminal = !inTerminal;
        }
        
        return result;
    }
}