import Toybox.Lang;

var ERROR_CODE_MESSAGES as Dictionary<Number, String> = {
    -104 => "Connect WiFi or Bluetooth!",
    301 => "Server: Resource Moved Permanently",
    400 => "Server: Bad Request",
    401 => "Server: Unauthorized Access",
    403 => "Server: Access Forbidden",
    404 => "Server: Resource Not Found",
    500 => "Server: Internal Server Error",
    501 => "Server: Not Implemented",
    502 => "Server: Bad Gateway",
    // Add more status codes and corresponding messages as needed
};
