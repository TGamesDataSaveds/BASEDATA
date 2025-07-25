package notification;

import flixel.FlxG;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import haxe.ds.StringMap;

class NotificationManager
{
    private static var instance:NotificationManager;
    
    public var notifications:Array<NotificationData> = [];
    private var activeNotifications:Array<Notification> = [];
    private var maxActiveNotifications:Int = 3;
    private var notificationSpacing:Float = 10;
    private var isInitialized:Bool = false;
    
    private var notificationQueue:Array<{id:String, title:String, message:String, type:NotificationType, camera:FlxCamera}> = [];
    
    public static function getInstance():NotificationManager
    {
        if (instance == null)
        {
            instance = new NotificationManager();
        }
        return instance;
    }
    
    private function new()
    {
        // Private constructor for singleton
    }
    
    public function initialize():Void
    {
        if (isInitialized) return;
        
        isInitialized = true;
    }
    
    public function showNotification(title:String, message:String, type:NotificationType = null, ?moreInformation:String, ?camera:FlxCamera):String
    {
        if (!isInitialized) initialize();
        
        var id = generateId();
        
        // Create notification data - Fixed type issue
        var notificationData = new NotificationData(id, title, message, type, camera);
        if (moreInformation != null) notificationData.detailedMessage = moreInformation;
        notifications.push(notificationData);
        
        if (activeNotifications.length < maxActiveNotifications)
        {
            createAndShowNotification(notificationData); // Pass NotificationData instead of individual params
        }
        else
        {
            notificationQueue.push({id: id, title: title, message: message, type: type, camera: camera});
        }
        
        return id;
    }
    
    private function createAndShowNotification(data:NotificationData):Void // Fixed parameter type
    {
        var notification = new Notification(data.id, data.title, data.message, data.type);
        
        positionNotification(notification);
        
        activeNotifications.push(notification);
        
        if (FlxG.state != null)
        {
            FlxG.state.add(notification);
        }
        
        notification.onClicked = onNotificationClicked;
        notification.onClosed = onNotificationClosed;
    }
    
    private function positionNotification(notification:Notification):Void
    {
        var yPos:Float = 20; // Fixed type
        
        for (activeNotification in activeNotifications)
        {
            if (activeNotification != null)
            {
                yPos += activeNotification.height + notificationSpacing;
            }
        }

        repositionNotifications();
        notification.posY = yPos;
    }
    
    private function onNotificationClicked(notification:Notification):Void
    {
        var notificationData = findNotificationDataById(notification.id);
        if (notificationData != null)
        {
            notificationData.isRead = true;
        }
        
        openNotificationCenter();
    }
    
    private function onNotificationClosed(notification:Notification):Void
    {
        var index = activeNotifications.indexOf(notification);
        if (index != -1)
        {
            activeNotifications.splice(index, 1);
        }
        
        repositionNotifications();
        processNotificationQueue();
    }
    
    private function repositionNotifications():Void
    {
        var yPos:Float = 20; // Fixed type
        
        for (i in 0...activeNotifications.length)
        {
            var notification = activeNotifications[i];
            if (notification != null)
            {
                FlxTween.tween(notification, {posY: yPos}, 0.3, {ease: FlxEase.quartOut});
                yPos += notification.height + notificationSpacing;
            }
        }
    }
    
    private function processNotificationQueue():Void
    {
        if (notificationQueue.length > 0 && activeNotifications.length < maxActiveNotifications)
        {
            var nextNotification = notificationQueue.shift();
            var notificationData = new NotificationData(
                nextNotification.id,
                nextNotification.title,
                nextNotification.message,
                nextNotification.type,
                nextNotification.camera
            );
            notifications.push(notificationData);
            createAndShowNotification(notificationData);
        }
    }
    
    public function openNotificationCenter():Void
    {
        FlxG.switchState(new NotificationCenter(notifications));
    }
    
    public function dismissNotification(id:String):Void
    {
        for (i in 0...activeNotifications.length)
        {
            var notification = activeNotifications[i];
            if (notification != null && notification.id == id)
            {
                notification.slideOut();
                break;
            }
        }
    }
    
    public function dismissAllNotifications():Void
    {
        for (i in 0...activeNotifications.length)
        {
            var notification = activeNotifications[i];
            if (notification != null)
            {
                new FlxTimer().start(i * 0.1, function(_) {
                    notification.slideOut();
                });
            }
        }
        
        notificationQueue = [];
    }
    
    public function markAllAsRead():Void
    {
        for (notification in notifications)
        {
            notification.isRead = true;
        }
        
        for (activeNotification in activeNotifications)
        {
            if (activeNotification != null)
            {
                activeNotification.markAsRead();
            }
        }
    }
    
    private function findNotificationDataById(id:String):NotificationData
    {
        for (notification in notifications)
        {
            if (notification.id == id)
            {
                return notification;
            }
        }
        return null;
    }
    
    private function generateId():String
    {
        return Date.now().getTime() + "_" + Math.floor(Math.random() * 10000);
    }
    
    public function createTestNotifications():Void
    {
        //MUESTRA TODAS LAS NOTIFICACIONES EN FORMA DE PRUEBA
        try {
            showNotification(
                "Information",
                "This is an information notification with some details about a system event.",
                NotificationType.INFO
            );
            
            new FlxTimer().start(1.0, function(_) {
                showNotification(
                    "Success!",
                    "Your changes have been saved successfully.",
                    NotificationType.SUCCESS
                );
            });
            
            new FlxTimer().start(2.0, function(_) {
                showNotification(
                    "Warning",
                    "Your session will expire in 5 minutes. Please save your work.",
                    NotificationType.WARNING
                );
            });
            
            new FlxTimer().start(3.0, function(_) {
                showNotification(
                    "Error Occurred",
                    "Failed to connect to the server. Please check your internet connection.",
                    NotificationType.ERROR
                );
            });
            
            new FlxTimer().start(4.0, function(_) {
                var notificationData = new NotificationData(
                    generateId(),
                    "Update Available",
                    "A new version of the application is available.",
                    NotificationType.INFO
                );
                notificationData.detailedMessage = "Version 2.0.1 includes:\n\n" +
                    "• Improved performance\n" +
                    "• New user interface\n" +
                    "• Bug fixes\n\n" +
                    "Would you like to update now?";
                
                notifications.push(notificationData);
                
                showNotification(
                    notificationData.title,
                    notificationData.message,
                    notificationData.type
                );
            });
        } catch (e:Dynamic) {
            trace("Error creating test notifications: " + e);
        }
    }
}