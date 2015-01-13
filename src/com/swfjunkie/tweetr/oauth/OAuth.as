package com.swfjunkie.tweetr.oauth
{
    import com.hurlant.crypto.Crypto;
    import com.hurlant.crypto.hash.HMAC;
    import com.hurlant.util.Base64;
    import com.hurlant.util.Hex;
    import com.swfjunkie.tweetr.oauth.events.OAuthEvent;
    
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.external.ExternalInterface;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.net.URLVariables;
    import flash.utils.ByteArray;
    
    CONFIG::AIR
    import flash.html.HTMLLoader;
    
    /**
     * Dispatched when the OAuth has succesfully completed a Request.
     * @eventType com.swfjunkie.tweetr.oauth.events.OAuthEvent.COMPLETE
     */ 
    [Event(name="complete", type="com.swfjunkie.tweetr.oauth.OAuthEvent")]
    
    /**
     * Dispatched when something goes wrong while trying to authorize
     * @eventType com.swfjunkie.tweetr.oauth.events.OAuthEvent.ERROR
     */
    [Event(name="error", type="com.swfjunkie.tweetr.oauth.OAuthEvent")]
    
    /**
     * OAuth Authentication Utility - requires the <a href="http://code.google.com/p/as3crypto/" target="_blank">as3crypto library</a> to work.
     * @author Sandro Ducceschi [swfjunkie.com, Switzerland]
     */
    public class OAuth extends EventDispatcher implements IOAuth
    {
        //
        //  Class variables
        //
        //--------------------------------------------------------------------------
        private static const OAUTH_DOMAIN:String = "http://twitter.com";
        private static const REQUEST_TOKEN:String = "/oauth/request_token";
        private static const AUTHORIZE:String = "/oauth/authorize";
        private static const ACCESS:String = "/oauth/access_token";
        //--------------------------------------------------------------------------
        //
        //  Initialization
        //
        //--------------------------------------------------------------------------
        
        /**
         * Creates a new OAuth Instance
         */ 
        public function OAuth()
        {
            super();
            urlLoader = new URLLoader();
            urlLoader.addEventListener(Event.COMPLETE, handleComplete);
            urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleError);
            urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
        }
        
        //--------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------
        private var request:String;
        private var urlLoader:URLLoader;
        private var verifier:String;
        //--------------------------------------------------------------------------
        //
        //  Properties
        //
        //--------------------------------------------------------------------------
        /**
         * Get/Set the Consumer Key for your Application
         */ 
        public var consumerKey:String = "";
        /**
         * Get/set the Consumer Secret for your Application
         */ 
        public var consumerSecret:String = "";
        /**
         * Get/Set the User Token
         */ 
        public var oauthToken:String = "";
        /**
         * Get/Set the User Token Secret
         */ 
        public var oauthTokenSecret:String = "";
        
        private var _userId:String;
        /**
         * Get the twitter user_id (retrieval only available after successful user authorization)
         */ 
        public function get userId():String
        {
            if (_userId)
                return _userId;
            return null;
        }
        
        private var _callbackURL:String = "oob";
        /**
         * <b><font color="#00AA00">NEW</font></b> - Get/Set the OAuth Callback URL
         */
        public function get callbackURL():String
        {
            return decodeURIComponent(_callbackURL);
        }
        public function set callbackURL(value:String):void
        {
            _callbackURL = encodeURIComponent(value);
        }
        
        private var _username:String;
        /**
         * Get/set the twitter screen_name (retrieval only available after successful user authorization)
         */ 
        public function get username():String
        {
            if (_username)
                return _username;
            return null;
        }
        public function set username(value:String):void
        {
            _username = value;
        }
        
        private var _serviceHost:String = OAUTH_DOMAIN;
        /**
         * Service Host URL you want to use.
         * This has to be changed if you are going to use tweetr
         * from a web app. Since the crossdomain policy of twitter.com
         * is very restrictive. use Tweetr's own PHPProxy Class for this. 
         */
        public function get serviceHost():String
        {
            return _serviceHost;
        }
        public function set serviceHost(value:String):void
        {
            if (value.indexOf("http://") == -1 && value.indexOf("https://") == -1)
                _serviceHost = "http://"+value;
            else
                _serviceHost = value;
        }
        
        /**
         * <b><font color="#00AA00">NEW</font></b> - Whether to use pinless OAuth or not.<br/>
         * If you set this to true, you will have to supply
         * a callback url via <code>callbackURL</code>
         */
        public var pinlessAuth:Boolean = false;
        
        /**
         * <div class="airIcon"><b><font color="#00AA00">NEW</font></b> - <b>AIR only!</b> The HTMLLoader to be used to display the OAuth
         * Authentication Process from Twitter in.</div> 
         */ 
        CONFIG::AIR
        public var htmlLoader:HTMLLoader;
        //--------------------------------------------------------------------------
        //
        //  Additional getters and setters
        //
        //--------------------------------------------------------------------------
        private function get time():String
        {
            return Math.round(new Date().getTime() / 1000).toString(); 
        }
        
        private function get nonce():String
        {
            return Math.round(Math.random() * 99999).toString();
        }
        //--------------------------------------------------------------------------
        //
        // Overridden API
        //
        //--------------------------------------------------------------------------
        
        //--------------------------------------------------------------------------
        //
        //  API
        //
        //--------------------------------------------------------------------------
        /**
         * Requests a OAuth Authorization Token and will build the proper authorization URL if successful.
         * When the URL has been created a <code>OAuthEvent.COMPLETE</code> will be fired containing the url.
         */
        public function getAuthorizationRequest():void
        {
            request = REQUEST_TOKEN;
            var urlRequest:URLRequest = new URLRequest(OAUTH_DOMAIN+REQUEST_TOKEN);
            urlRequest.url = _serviceHost + REQUEST_TOKEN + "?"+ getSignedRequest("GET", urlRequest.url);
            urlLoader.load(urlRequest);
        }
        
        /**
         * Requests the final Access Token to finish the OAuth Authorization.
         * When the Request succeeds a <code>OAuthEvent.COMPLETE</code> will be fired and the OAuth Instance will contain all the information needed to successfully call any Twitter API Method.
         * @param verifier   PIN or verifier_token given by Twitter on the Authorization Page.
         */ 
        public function requestAccessToken(verifier:String):void
        {
            request = ACCESS;
            this.verifier = verifier;
            var urlRequest:URLRequest = new URLRequest(OAUTH_DOMAIN+ACCESS);
            urlRequest.url = _serviceHost + ACCESS + "?"+ getSignedRequest("GET", urlRequest.url);
            urlLoader.load(urlRequest);
        }
        
        /**
         * Signs a Request and returns an proper encoded argument string.<br/>
         * <b>There usually is no need to call this by yourself.</b><br/><br/>
         * @param method    The URLRequest Method used. Valid values are POST and GET
         * @param url       The Request URL
         * @param urlVars   URLVariables that need to be signed
         */ 
        public function getSignedRequest(method:String, url:String, urlVars:URLVariables = null):String
        {
            var args:Array = [];
            
            if (request)
                args.push({name: "oauth_callback", value: _callbackURL});
            args.push({name: "oauth_consumer_key", value: consumerKey});
            args.push({name: "oauth_nonce", value: nonce});
            args.push({name: "oauth_signature_method", value: "HMAC-SHA1"});
            args.push({name: "oauth_timestamp", value: time});
            args.push({name: "oauth_version", value: "1.0"});
            
            if (!request || request == ACCESS)
            {
                args.push({name: "oauth_token", value: oauthToken});
                if (request == ACCESS)
                    args.push({name: "oauth_verifier", value: verifier});
            }
            
            for (var nameValue:String in urlVars)
                args.push({name: nameValue, value: urlVars[nameValue]});
            
            args.sortOn("name");
            
            var n:int = args.length;
            var vars:String = "";
            for (var i:int = 0; i < n; i++)
            {
                if (args[i]["name"] != "_method")
                {
                    vars += args[i]["name"]+"="+args[i]["value"];
                    if (i != n-1)
                        vars += "&";
                }
            }
            var signString:String = method.toUpperCase() +"&" + encodeURIComponent(url) + "&" + encodeURIComponent(vars);
            var hmac:HMAC =  Crypto.getHMAC("sha1");
            var key:ByteArray = Hex.toArray( Hex.fromString(encodeURIComponent(consumerSecret) + "&" + encodeURIComponent(oauthTokenSecret)));
            var data:ByteArray = Hex.toArray( Hex.fromString( signString ) );
            var sha:String = Base64.encodeByteArray( hmac.compute( key, data ) );
            vars += "&oauth_signature="+encodeURIComponent(sha);
            return vars;
        }
        
        /**
         * <b><font color="#00AA00">NEW</font></b> - Returns username, userid, oauth token 
         * and secret in a practical string ;)
         */ 
        override public function toString():String
        {
            return "Username: "+_username+"\n"+
                    "User Id: "+_userId+"\n"+
                    "OAuth Token: "+oauthToken+"\n"+
                    "OAuth Token Secret: "+oauthTokenSecret;
        }
        
        //--------------------------------------------------------------------------
        //
        //  Overridden methods: _SuperClassName_
        //
        //--------------------------------------------------------------------------
        
        //--------------------------------------------------------------------------
        //
        //  Methods
        //
        //--------------------------------------------------------------------------
        
        private function buildAuthorizationRequest(data:String):void
        {
            var splitArr:Array = data.split("&");
            var n:int = splitArr.length;
            for (var i:int = 0; i < n; i++)
            {
                var element:Array = String(splitArr[i]).split("=");
                if (element[0] == "oauth_token")
                {
                    oauthToken = element[1];
                    break;
                }
            }
            var url:String = OAUTH_DOMAIN + AUTHORIZE +"?oauth_token="+encodeURIComponent(oauthToken);
            
            if (!pinlessAuth)
                dispatchEvent(new OAuthEvent(OAuthEvent.COMPLETE, url));
            else
                callAuthorize(url);
        }
        
        private function parseAccessResponse(data:String):void
        {
            var splitArr:Array = data.split("&");
            var n:int = splitArr.length;
            for (var i:int = 0; i < n; i++)
            {
                var element:Array = String(splitArr[i]).split("=");
                switch (element[0])
                {
                    case "oauth_token":
                    {
                        oauthToken = element[1];
                        break;
                    }
                    case "oauth_token_secret":
                    {
                        oauthTokenSecret = element[1];
                        break;
                    }
                    case "user_id":
                    {
                        _userId = element[1];
                        break;
                    }
                    case "screen_name":
                    {
                        _username = element[1];
                        break;
                    }
                }
            }
            dispatchEvent(new OAuthEvent(OAuthEvent.COMPLETE));
        }
        
        //------------------------------------------
        //  Conditional Authorize Call Methods
        //------------------------------------------
        
        CONFIG::WEB
        private function callAuthorize(url:String):void
        {
            if (ExternalInterface.available)
            {
                ExternalInterface.addCallback("setVerifier", requestAccessToken);
                ExternalInterface.call("OAuth.callAuthorize", url);
            }
        }
        
        
        CONFIG::AIR
        private function callAuthorize(url:String):void
        {
            if (htmlLoader)
            {
                htmlLoader.addEventListener(Event.COMPLETE, handleDocumentComplete);
                htmlLoader.load(new URLRequest(url));
            }
        }
        
        //--------------------------------------------------------------------------
        //
        //  Broadcasting
        //
        //--------------------------------------------------------------------------
        
        //--------------------------------------------------------------------------
        //
        //  Eventhandling
        //
        //--------------------------------------------------------------------------
        
        private function handleComplete(event:Event):void
        {
            if (request == REQUEST_TOKEN)
                buildAuthorizationRequest(urlLoader.data);
            if (request == ACCESS)
                parseAccessResponse(urlLoader.data);
        }
        
        private function handleError(event:IOErrorEvent):void
        {
            dispatchEvent(new OAuthEvent(OAuthEvent.ERROR, null, event.text));
        }
        
        private function handleSecurityError(event:SecurityErrorEvent):void
        {
            dispatchEvent(new OAuthEvent(OAuthEvent.ERROR, null, event.text));
        }
        
        CONFIG::AIR
        private function handleDocumentComplete(event:Event):void
        {
            var sStr:String = "oauth_verifier=";
            var location:String = htmlLoader.location;
            var hasLocation:Boolean = htmlLoader.location.indexOf(location) != -1;
            var oAuthVerifierIndex:int = location.indexOf(sStr);
            
            if (hasLocation && oAuthVerifierIndex != -1)
            {
                htmlLoader.removeEventListener(Event.COMPLETE, handleDocumentComplete);
                verifier = location.substr(oAuthVerifierIndex + sStr.length, location.length);
                htmlLoader = null;
                requestAccessToken(verifier);
            }
        }
    }
}