///////////////////////////
//AIRSafecast 1.0.
//Orientation.as.
//Orientation handling.
///////////////////////////
package org.bbdesign.airsafecast {
	import flash.display.*;
	import flash.events.*;
	
	public class Orientation extends Sprite {
		//////////////////////////////
		//Internal class variables.
		//////////////////////////////
		//Instance.
		private var _stage:Stage;
		public var current_width:Number;
		public var current_height:Number;
		public var orient_str:String;
		
		//////////////////////////////
		//Constructor.
		//////////////////////////////
		public function Orientation(stage:Stage) {
			_stage = stage;
			//Orientation change event listener.
			_stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE, onChange);
			//Orientation check on application initial load.
			switch (_stage.orientation) {
				case StageOrientation.DEFAULT:
					current_width = _stage.stageWidth;
					current_height = _stage.stageHeight;
					orient_str = 'portrait';
					break;
				case StageOrientation.ROTATED_RIGHT:
					current_width = _stage.stageWidth;
					current_height = _stage.stageHeight;
					orient_str = (orient_str == 'portrait') ? 'landscape' : 'portrait';
					break;
				case StageOrientation.ROTATED_LEFT:
					current_width = _stage.stageWidth;
					current_height = _stage.stageHeight;
					orient_str = (orient_str == 'portrait') ? 'landscape' : 'portrait';
					break;
				case StageOrientation.UPSIDE_DOWN:
					current_width = _stage.stageWidth;
					current_height = _stage.stageHeight;
					orient_str = 'portrait';
					break;
			}
		}
		
		//////////////////////////////
		//////////////////////////////
		//Event handlers.
		//////////////////////////////
		//////////////////////////////
		
		//////////////////////////////
		//On orientation change.
		//////////////////////////////
		private function onChange(e:StageOrientationEvent):void {
			switch (e.afterOrientation) {
				case StageOrientation.DEFAULT:
					current_width = _stage.stageWidth;
					current_height = _stage.stageHeight;
					orient_str = 'portrait';
					dispatchEvent(new Event('ORIENTATION_CHANGED', true));
					break;
				case StageOrientation.ROTATED_RIGHT:
					current_width = _stage.stageWidth;
					current_height = _stage.stageHeight;
					orient_str = (orient_str == 'portrait') ? 'landscape' : 'portrait';
					dispatchEvent(new Event('ORIENTATION_CHANGED', true));
					break;
				case StageOrientation.ROTATED_LEFT:
					current_width = _stage.stageWidth;
					current_height = _stage.stageHeight;
					orient_str = (orient_str == 'portrait') ? 'landscape' : 'portrait';
					dispatchEvent(new Event('ORIENTATION_CHANGED', true));
					break;
				case StageOrientation.UPSIDE_DOWN:
					current_width = _stage.stageWidth;
					current_height = _stage.stageHeight;
					orient_str = 'portrait';
					dispatchEvent(new Event('ORIENTATION_CHANGED', true));
					break;
			}
		}
		//////////////////////////////
	
	}

}

