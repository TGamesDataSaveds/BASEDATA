package system;

import system.Notification;
import flixel.group.FlxGroup;
import flixel.FlxG;

class NotificationManager extends FlxGroup {
    private static var instance:NotificationManager;
    public var notificationLog:Array<Notification> = [];

    public static function getInstance():NotificationManager {
        if (instance == null) {
            instance = new NotificationManager();
        }
        return instance;
    }

    private function new() {
        super();
    }

    public function showNotification(title:String, description:String, type:NotificationType):Void {
        var notification = new Notification(FlxG.width - 310, -50, title, description, type);
        add(notification);
        notification.show();
        notificationLog.push(notification);

        FlxG.sound.play(Paths.sound('notificacion-1'));

        haxe.Timer.delay(function() {
            notification.hide();
        }, 5000);
    }

    public function showNotificationLog():Void {
        // Implementa aquí la lógica para mostrar el registro de notificaciones
        // Esto podría ser una nueva pantalla o un menú desplegable
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        for (notification in members) {
            if (FlxG.mouse.overlaps(notification) && FlxG.mouse.justPressed) {
                cast(notification, Notification).expand();
            }
        }
    }
}