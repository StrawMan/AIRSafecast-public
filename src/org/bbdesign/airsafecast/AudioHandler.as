///////////////////////////
//AIRSafecast 1.0.
//AudioHandler.as.
//Audio/mic/line-in etc. 
//Handling class.
///////////////////////////
package org.bbdesign.airsafecast {
	import flash.display.*;
	import flash.events.*;
	import flash.media.Microphone;
	//ByteArray.org MicRecorder class.
	import org.bytearray.micrecorder.MicRecorder;
	import org.bytearray.micrecorder.encoder.WaveEncoder;
	import org.bytearray.micrecorder.events.RecordingEvent;
	//Mad Components.
	import com.danielfreeman.extendedMadness.UIDropWindow;
	
	public class AudioHandler extends Sprite {
		//////////////////////////////
		//Internal class variables.
		//////////////////////////////
		//Instance.
		private var _audiodevice:Microphone;
		private var _audiodevicelist:Array;
		private var _audiorecorder:MicRecorder;
		
		//Custom class instances.
		private var _ui:Interface = new Interface();
		
		//////////////////////////////
		//Constructor.
		//////////////////////////////
		public function AudioHandler() {
			//Get list of available audio devices.
			getAudioDeviceList();
			//Build device picker callout menu.
			var callout:UIDropWindow = _ui.buildCallout(50, 50, 180, 135, _audiodevicelist);
			//addChild(callout);
			//Initialize device.
			initDevice();
			//Initialize recorder object.
			var volume:Number = .8;
			var wavEncoder:WaveEncoder = new WaveEncoder(volume);
			//Pass selected device to recorder object for handling.
			_audiorecorder = new MicRecorder(wavEncoder, _audiodevice);
		}
		
		//////////////////////////////
		//////////////////////////////
		//Private methods.
		//////////////////////////////
		//////////////////////////////
		//Get list of available audio devices.
		private function getAudioDeviceList():void {
			_audiodevicelist = Microphone.names;
		}
		
		//Initialize device.
		private function initDevice():void {
			_audiodevice = Microphone.getMicrophone(_audiodevicelist[0]);
			_audiodevice.setLoopBack(true);
			_audiodevice.setUseEchoSuppression(true);
		}
		//////////////////////////////
		//////////////////////////////
		//Public methods.
		//////////////////////////////
		//////////////////////////////
	
		//////////////////////////////
		//////////////////////////////
		//Event handlers.
		//////////////////////////////
		//////////////////////////////	
	}
}