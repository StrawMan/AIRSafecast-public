///////////////////////////
//AIRSafecast 1.0.
//Main.as.
//Document Class.
///////////////////////////
package com.mobiledesign.airsafecast {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.desktop.NativeApplication;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.system.Capabilities;
	
	public class Main extends Sprite {
		//////////////////////////////
		//Internal class variables.
		//////////////////////////////
		//Instance.
		private var _application:Application;
		private var _app_width:Number;
		private var _app_height:Number;
		private var _app_dpi:Number;
		
		//////////////////////////////
		//Constructor.
		//////////////////////////////
		public function Main():void {
			if (stage) {
				init();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		//////////////////////////////
		
		//////////////////////////////
		//////////////////////////////
		//Private, internal methods.
		//////////////////////////////
		//////////////////////////////
		
		////////////////////////////
		//Init application.
		////////////////////////////
		private function init(e:Event = null):void {
			//has been added to stage. Remove listener.
			removeEventListener(Event.ADDED_TO_STAGE, init);
			///////////////////////////
			//Dimensions, alignment & dpi.
			///////////////////////////
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.DEACTIVATE, deactivate);
			_app_dpi = Capabilities.screenDPI;
			///////////////////////////
			
			///////////////////////////
			//Touch or gesture?
			///////////////////////////
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			///////////////////////////
			
			///////////////////////////
			//Application entry point.
			///////////////////////////
			_application = new Application(stage, _app_dpi);
			addChild(_application);
			///////////////////////////
		}
		
		////////////////////////////
		
		///////////////////////////
		//Auto-close
		///////////////////////////
		private function deactivate(e:Event):void {
			NativeApplication.nativeApplication.exit();
		}
		///////////////////////////
	}

}