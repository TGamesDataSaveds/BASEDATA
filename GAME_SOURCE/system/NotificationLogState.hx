package system;

import states.TitleState;
import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

class NotificationLogState extends FlxState {
    override public function create():Void {
        super.create();

        var title = new FlxText(0, 20, FlxG.width, "Registro de Notificaciones");
        title.setFormat(null, 32, FlxColor.WHITE, "center");
        add(title);

        var yPos = 100;
        for (notification in NotificationManager.getInstance().notificationLog) {
            var notificationText = new FlxText(20, yPos, FlxG.width - 40, '${notification.title}: ${notification.description}');
            notificationText.setFormat(null, 16, FlxColor.WHITE, "left");
            add(notificationText);
            yPos += 30;
        }

        var backButton = new FlxButton(FlxG.width / 2 - 40, FlxG.height - 50, "Volver", function() {
            FlxG.switchState(new TitleState());
        });
        add(backButton);
    }
}