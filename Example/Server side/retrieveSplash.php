<?php
    
    // Helper method to get a string description for an HTTP status code
    // From http://www.gen-x-design.com/archives/create-a-rest-api-with-php/
    function getStatusCodeMessage($status)
    {
        // these could be stored in a .ini file and loaded
        // via parse_ini_file()... however, this will suffice
        // for an example
        $codes = Array(
                       100 => 'Continue',
                       101 => 'Switching Protocols',
                       200 => 'OK',
                       201 => 'Created',
                       202 => 'Accepted',
                       203 => 'Non-Authoritative Information',
                       204 => 'No Content',
                       205 => 'Reset Content',
                       206 => 'Partial Content',
                       300 => 'Multiple Choices',
                       301 => 'Moved Permanently',
                       302 => 'Found',
                       303 => 'See Other',
                       304 => 'Not Modified',
                       305 => 'Use Proxy',
                       306 => '(Unused)',
                       307 => 'Temporary Redirect',
                       400 => 'Bad Request',
                       401 => 'Unauthorized',
                       402 => 'Payment Required',
                       403 => 'Forbidden',
                       404 => 'Not Found',
                       405 => 'Method Not Allowed',
                       406 => 'Not Acceptable',
                       407 => 'Proxy Authentication Required',
                       408 => 'Request Timeout',
                       409 => 'Conflict',
                       410 => 'Gone',
                       411 => 'Length Required',
                       412 => 'Precondition Failed',
                       413 => 'Request Entity Too Large',
                       414 => 'Request-URI Too Long',
                       415 => 'Unsupported Media Type',
                       416 => 'Requested Range Not Satisfiable',
                       417 => 'Expectation Failed',
                       500 => 'Internal Server Error',
                       501 => 'Not Implemented',
                       502 => 'Bad Gateway',
                       503 => 'Service Unavailable',
                       504 => 'Gateway Timeout',
                       505 => 'HTTP Version Not Supported'
                       );
        
        return (isset($codes[$status])) ? $codes[$status] : '';
    }
    
    // Helper method to send a HTTP response code/message
    function sendResponse($status = 200, $body = '', $content_type = 'text/html')
    {
        $status_header = 'HTTP/1.1 ' . $status . ' ' . getStatusCodeMessage($status);
        header($status_header);
        header('Content-type: ' . $content_type);
        echo $body;
    }
    
    class SplashAPI {
        private $db;
        
        function retrieveHelp()
        {
            $ip = $_SERVER['REMOTE_ADDR'];
            
            // Check for required parameters
            if (
                isset($_POST["key"]) &&
                isset($_POST["app"]) &&
                isset($_POST["version"])
                )
            {
                $app = $_POST["app"];
                $version = $_POST["version"];
                $key = $_POST["key"];
                $localization = $_POST["localization"];
                
                if( $localization == NULL){
                    $localization = "EN";
                }
                
                $stmt = Database::$mysql->prepare("select main_title, title_1, title_2, title_3, title_4, icon_1, text_1, icon_2, text_2, icon_3, text_3, icon_4, text_4, footnote_icon, footnote_text from SPLASH where SPLASH.key = ? and SPLASH.app = ? and SPLASH.version = ? and SPLASH.locale = ?");
                $stmt->bind_param('ssss',$key, $app, $version, $localization);
                
                $stmt->execute();
                $stmt->bind_result( $main_title, $title1, $title2, $title3, $title4, $icon1, $text1, $icon2, $text2, $icon3, $text3, $icon4, $text4, $footnote_icon, $footnote_text);
                $stmt->store_result();
                $stmt->fetch();

                if ( $main_title == NULL ){
                    sendResponse(200, "");
                    return true;
                }
                
                $splashItems = array();
                
                if ($icon1 != NULL && $text1 != NULL && $title1 != NULL){
                    $element1 = array(
                                      "title" => $title1,
                                      "icon" => $icon1,
                                      "text" => $text1
                                      );
                    array_push( $splashItems, $element1);
                }

                if ($icon2 != NULL && $text2 != NULL && $title2!= NULL){
                    $element2 = array(
                                      "title" => $title2,
                                      "icon" => $icon2,
                                      "text" => $text2
                                      );
                    array_push( $splashItems, $element2);
                }
                
                if ($icon3 != NULL && $text3 != NULL && $title3 != NULL){
                    $element3 = array(
                                      "title" => $title3,
                                      "icon" => $icon3,
                                      "text" => $text3
                                      );
                    array_push( $splashItems, $element3);
                }

                if ($icon4 != NULL && $text4 != NULL && $title4 != NULL){
                    $element4 = array(
                                      "title" => $title4,
                                      "icon" => $icon4,
                                      "text" => $text4
                                      );
                    array_push( $splashItems, $element4);
                }
                
                $result = array(
                                "main_title" => $main_title,
                                "footnote_icon" => $footnote_icon,
                                "footnote_text" => $footnote_text,
                                "splashItems" => $splashItems
                                );

                sendResponse(200, json_encode($result));
                
                return true;
            }
            sendResponse(400, 'Invalid request');
            return false;
        }
        
        function __construct() {
            $db = new Database;
        }
    }
    
    class Database {
        public static $mysql;
        function __construct() {
            if (!isset(self::$mysql)) {
                //
                // enter your mysql connection params
                //
                self::$mysql = new mysqli('mysql_host', 'mysql_user', 'password', 'mysql_schema');
                if (self::$mysql->connect_errno) {
                    echo "Failed to connect to MySQL: (" . $this->mysql->connect_errno . ") " . self::$mysql->connect_error;
                }
                else
                {
                    self::$mysql->set_charset("utf8");
                }
            }
        }
    }
    
    $api = new SplashAPI;
    $api->retrieveHelp();
?>

