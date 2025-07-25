package notification;

class NotificationData
{
    public var id:String;
    public var title:String;
    public var message:String;
    public var detailedMessage:String;
    public var timestamp:Float;
    public var isRead:Bool;
    public var type:NotificationType;
    public var cameras:Array<FlxCamera>;
    
    public function new(id:String, title:String, message:String, type:NotificationType = null, camera:FlxCamera = null)
    {
        this.id = id;
        this.title = title;
        this.message = message;
        this.detailedMessage = null;
        this.timestamp = Date.now().getTime();
        this.isRead = false;
        this.type = type != null ? type : NotificationType.INFO;
        if (camera != null) {
        this.cameras = [camera];
        } else {
        this.cameras = FlxG.cameras.list;
        }
    }
}