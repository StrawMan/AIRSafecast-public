//////////////////////////////
//AIRSafecast 1.0.
//HTTPserv.as.
//HTTPService/REST handler.
//////////////////////////////
package com.mobiledesign.airsafecast {
	import flash.display.*;
	import flash.events.*;
	import mx.rpc.http.*;
	import mx.rpc.events.*;
	
	public class Httpserv extends HTTPService {
		//////////////////////////////
		//Internal class variables.
		//////////////////////////////
		//Instance.
		private var _httpservice:HTTPService = new HTTPService();
		private var _prop:Object;
		//Public data.
		public var json_container:Object = {};
		//////////////////////////////
		//Constructor.
		//////////////////////////////
		public function Httpserv(url:String, method:String, resultformat:String = 'object', params:Object = null) {
			getHttpResp(url, method, resultformat, params);
		}
		
		//////////////////////////////
		
		//////////////////////////////
		
		//////////////////////////////
		//Private methods.
		//////////////////////////////
		
		//////////////////////////////
		
		//////////////////////////////
		//Get HTTP REST response.
		//////////////////////////////
		private function getHttpResp(url:String, method:String, resultformat:String, params:Object = null):* {
			_httpservice.useProxy = false;
			_httpservice.url = url;
			_httpservice.method = method;
			_httpservice.resultFormat = resultformat;
			_httpservice.send(params);
			//Event handlers.
			_httpservice.addEventListener('result', resultHandler);
			_httpservice.addEventListener('fault', faultHandler);
		}
		
		//////////////////////////////
		
		//////////////////////////////
		//Process response object.
		//////////////////////////////
		private function procObject(result:*):void {
			json_container = JSON.parse(result) as Object;
			dispatchEvent(new Event('HTTPSERV_COMPLETE', true));
		}
		
		//////////////////////////////
		
		//////////////////////////////
		//Event handlers.
		//////////////////////////////
		//Process results.
		private function resultHandler(evt:ResultEvent):void {
			try {
				procObject(evt.result);
			} catch (error:IOErrorEvent) {
				trace("IO Error: " + evt);
			}
		}
		
		//Faults.
		private function faultHandler(evt:FaultEvent):void {
			trace("Fault: " + evt);
		}
		//////////////////////////////
	
	}
	//////////////////////////////
}

