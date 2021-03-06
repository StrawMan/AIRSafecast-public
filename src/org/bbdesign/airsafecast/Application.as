///////////////////////////
//AIRSafecast 1.0.
//Application.as.
//Main application class.
///////////////////////////
package org.bbdesign.airsafecast {
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.text.engine.FontWeight;
	///////////////////////////
	//Tweener classes.
	import caurina.transitions.Tweener;
	//Mad Components.
	import com.danielfreeman.madcomponents.UIActivity;
	import com.danielfreeman.madcomponents.UIInput;
	
	public class Application extends Sprite {
		//////////////////////////////
		//Embedded assets.
		//////////////////////////////
		//Safecast icon.
		[Embed(source="/../icons/AIRSafecast35.png")]
		public static var SafecastIcon:Class;
		//Legend.
		[Embed(source="/../icons/radbar.png")]
		public static var RadBar:Class;
		//////////////////////////////
		//Internal class variables.
		//////////////////////////////
		//Instance.
		private var _actind_demand:Sprite;
		private var _app_width:Number;
		private var _app_height:Number;
		private var _app_dpi:Number;
		private var _nominatim_popup_bg:Sprite;
		private var _nominatim_popup_scaled:Boolean = false;
		private var _latlong_popup_bg:Sprite;
		private var _latlong_popup_txt:TextField;
		private var _ot_lat:String;
		private var _ot_lon:String;
		private var _within_meters_bg:Sprite;
		private var _within_meters_label_txt:TextField;
		private var _within_meters_txt:UIInput;
		private var _max_rad_label_txt:TextField;
		private var _max_rad_txt:UIInput;
		private var _no_data_popup_bg:Sprite;
		private var _no_data_popup_txt:TextField;
		
		//Custom class instances.
		private var _safecastmap:Map;
		private var _safecastdata:Httpserv;
		private var _ui:Interface = new Interface();
		private var _orientation:Orientation;
		
		//////////////////////////////
		//Constructor.
		//////////////////////////////
		public function Application(stage:Stage, app_dpi:Number) {
			
			///////////////////////////
			//Device DPI.
			///////////////////////////
			_app_dpi = app_dpi;
			///////////////////////////
			
			//////////////////////////////
			//Init Tweener overwrite.
			//////////////////////////////
			Tweener.autoOverwrite = false;
			//////////////////////////////
			
			///////////////////////////
			//Device orientation.
			///////////////////////////
			//Initial orientation.
			_orientation = new Orientation(stage);
			addChild(_orientation);
			var current_width:Number = _orientation.current_width;
			var current_height:Number = _orientation.current_height;
			//Initial Application width and height based on intial orientation.
			_app_width = current_width;
			_app_height = current_height;
			//Listen for orientation changes.
			_orientation.addEventListener('ORIENTATION_CHANGED', orientationChangedHandler);
			///////////////////////////
			
			//////////////////////////////
			//Populate display, map, etc.
			//////////////////////////////
			initSafecastMap();
			//////////////////////////////
		}
		
		//////////////////////////////
		//////////////////////////////
		//Private methods.
		//////////////////////////////
		//////////////////////////////
		
		//////////////////////////////
		//Init Safecast map & UI elements.
		//////////////////////////////
		private function initSafecastMap():void {
			//////////////////////////////
			//Primary map and touch/over listeners.
			//////////////////////////////
			_safecastmap = new Map(_app_width, _app_height, 37.551654, 140.880812, 5, _orientation.orient_str);
			addChild(_safecastmap);
			_safecastmap.addEventListener('MAP_OVER_COORD_COMPLETE', safecastMapOverTouchHandler);
			_safecastmap.addEventListener('MAP_TOUCH_COORD_COMPLETE', safecastMapOverTouchHandler);
			//////////////////////////////
			
			//////////////////////////////
			//Latitude & Longitude popup display.
			//////////////////////////////
			_latlong_popup_bg = _ui.drawMatte(2, 0xffffff, 0x000000, (_app_width / 6), (_app_height - 55), (_app_width / 1.5), 45, 'roundrect', 10, 10, 0.7, true, 'latlong_popup_bg');
			addChild(_latlong_popup_bg);
			_latlong_popup_txt = _ui.drawTextfield(Fontlib.DroidSans, 0, 0, 0xffffff, 5, (_latlong_popup_bg.height / 4), _latlong_popup_bg.width, 24, 19, false, 0xffffff, false, 0x8CC63F, 'dynamic', 'center', false, '_latlong_popup_txt', false, true, true, false);
			_latlong_popup_bg.addChild(_latlong_popup_txt);
			//////////////////////////////
			
			//////////////////////////////
			//Detection radius (meters).
			//////////////////////////////
			_within_meters_bg = _ui.drawMatte(2, 0xffffff, 0x000000, (_app_width / 10), (_app_height - 130), (_app_width - 100), 60, 'roundrect', 10, 10, 0.7, true, '_within_meters_bg');
			addChild(_within_meters_bg);
			_within_meters_label_txt = _ui.drawTextfield(Fontlib.DroidSans, 0, 0, 0xffffff, 5, 5, _within_meters_bg.width, 20, 16, false, 0x000000, false, 0x8CC63F, 'input', 'left', false, '_within_meters_label_txt', false, true, true, false);
			_within_meters_bg.addChild(_within_meters_label_txt);
			_within_meters_label_txt.text = 'Detection Radius (m)';
			
			_within_meters_txt = new UIInput(this, 35, 25, "700", new <uint>[0x000000, 0xffffff, 0], false);
			_within_meters_txt.needsSoftKeyboard = true;
			_within_meters_txt.width = (_within_meters_bg.width / 6);
			_within_meters_txt.height = 30;
			_within_meters_txt.opaqueBackground = true;
			_within_meters_bg.addChild(_within_meters_txt);
			//StageText instance.
			_ui.buildStagetext(this.stage, _within_meters_txt.stageRect(), 6);
			_within_meters_txt.addEventListener(FocusEvent.FOCUS_IN, onTxtDetectFocusIn);
			function onTxtDetectFocusIn(event:FocusEvent):void {
				_within_meters_txt.requestSoftKeyboard();
			}
			//////////////////////////////
			
			//////////////////////////////
			//Limit POI (radiation points) display.
			//////////////////////////////
			_max_rad_label_txt = _ui.drawTextfield(Fontlib.DroidSans, 0, 0, 0xffffff, 5, 5, (_within_meters_bg.width - 20), 20, 16, false, 0x000000, false, 0x8CC63F, 'input', 'right', false, '_max_rad_label_txt', false, true, true, false);
			_within_meters_bg.addChild(_max_rad_label_txt);
			_max_rad_label_txt.text = 'Max Radiation Points';
			
			_max_rad_txt = new UIInput(this, 270, 25, "20", new <uint>[0x000000, 0xffffff, 0], false);
			_max_rad_txt.needsSoftKeyboard = true;
			_max_rad_txt.width = (_within_meters_bg.width / 6);
			_max_rad_txt.height = 30;
			_max_rad_txt.opaqueBackground = true;
			_within_meters_bg.addChild(_max_rad_txt);
			//StageText instance.
			_ui.buildStagetext(this.stage, _max_rad_txt.stageRect(), 3);
			_max_rad_txt.addEventListener(FocusEvent.FOCUS_IN, onTxtpoiFocusIn);
			function onTxtpoiFocusIn(event:FocusEvent):void {
				_max_rad_txt.requestSoftKeyboard();
			}
			//////////////////////////////
			
			//////////////////////////////
			//Add activity indicator (on demand).
			//////////////////////////////
			_actind_demand = _ui.buildActivityIndicator((_app_width / 2), (_app_height / 2), _app_width, _app_height);
			_actind_demand.alpha = 0;
			//////////////////////////////
			
			//////////////////////////////
			//Nominatim data display.
			//////////////////////////////
			var safecast_icon:DisplayObject = new SafecastIcon();
			safecast_icon.x = 12;
			safecast_icon.y = 12;
			safecast_icon.alpha = 0.5;
			safecast_icon.name = 'safecast_icon';
			_nominatim_popup_bg = _ui.drawMatte(2, 0xffffff, 0x000000, 5, 5, (_app_width - 10), 150, 'roundrect', 10, 10, 0.7, true, 'nominatim_popup_bg');
			addChild(_nominatim_popup_bg);
			_nominatim_popup_bg.addChildAt(safecast_icon, 0);
			//Legend.
			var rad_legend:DisplayObject = new RadBar();
			rad_legend.x = (_nominatim_popup_bg.width - (rad_legend.width + 20));
			rad_legend.y = 100;
			rad_legend.alpha = 0.8;
			rad_legend.name = 'rad_legend';
			rad_legend.cacheAsBitmap = true;
			_nominatim_popup_bg.addChildAt(rad_legend, 1);
			//Scale nominatim popup.
			_nominatim_popup_bg.addEventListener(MouseEvent.CLICK, nomPopUpClickHandler, false, 0, false);
			//////////////////////////////
			
			//////////////////////////////
			//No data available popup.
			//////////////////////////////
			_no_data_popup_bg = _ui.drawMatte(2, 0xffffff, 0x000000, 60, (_app_height / 2), (_app_width - 169), 40, 'roundrect', 10, 10, 0.7, true, '_no_data_popup_bg');
			_no_data_popup_txt = _ui.drawTextfield(Fontlib.DroidSans, 0, 0, 0xffffff, 5, 7, 300, 28, 18, false, 0xffffff, false, 0x8CC63F, 'dynamic', 'center', false, '_no_data_popup_txt', false, true, true, false);
			_no_data_popup_txt.text = 'No Data Available Within Radius';
			addChild(_no_data_popup_bg);
			_no_data_popup_bg.addChild(_no_data_popup_txt);
			_no_data_popup_bg.alpha = 0;
			_no_data_popup_bg.mouseEnabled = false;
			_no_data_popup_bg.mouseChildren = false;
			//////////////////////////////
		
			//////////////////////////////
			//Audio device handling.
			//Mic, line-in etc.
			//CPM feedback/recording.
			//////////////////////////////
			//var cpm_counter:AudioHandler = new AudioHandler();
			//addChild(cpm_counter);
			//////////////////////////////
		}
		
		//////////////////////////////
		//Scale nominatim popup.
		//////////////////////////////
		private function nomPopUpClickHandler(e:MouseEvent):void {
			switch (_nominatim_popup_scaled) {
				case true:
					Tweener.addTween(_nominatim_popup_bg, {time: 1, scaleX: 1, scaleY: 1, alpha: 0.8, transition: "easeOutElastic"});
					_nominatim_popup_scaled = false;
					break;
				case false:
					Tweener.addTween(_nominatim_popup_bg, {time: 1, scaleX: 0.5, scaleY: 0.5, alpha: 0.5, transition: "easeOutElastic"});
					_nominatim_popup_scaled = true;
					break;
			}
		}
		
		//////////////////////////////
		//Return mouse over/press/touch coordinates.
		//Load data.
		//////////////////////////////
		private function safecastMapOverTouchHandler(e:Event):void {
			switch (e.type) {
				//Over map.
				case 'MAP_OVER_COORD_COMPLETE':
					var oc:Array = _safecastmap.latlongover_point.split(",");
					var oc_lat:String = oc[0].slice(0, -4);
					var oc_lon:String = oc[1].slice(0, -4);
					_latlong_popup_txt.htmlText = 'lat: ' + oc_lat + ' / ' + 'lon: ' + oc_lon;
					break;
				//Touch map.
				case 'MAP_TOUCH_COORD_COMPLETE':
					var ot:Array = _safecastmap.latlongclick_point.split(",");
					_ot_lat = ot[0];
					_ot_lon = ot[1];
					//Get Safecast data.
					getDataOnTapHandler(_ot_lat, _ot_lon);
					break;
			}
		}
		
		//////////////////////////////
		//Load data on demand.
		//////////////////////////////
		private function getDataOnTapHandler(ot_lat:String, ot_lon:String):void {
			//Clean up old Nominatim data.
			while (_nominatim_popup_bg.numChildren > 2) {
				_nominatim_popup_bg.removeChildAt(2);
			}
			//Construct query string.
			var detect_radius:String = (_within_meters_txt.text == '') ? '700' : _within_meters_txt.text;
			var lat_str:String = '&latitude=' + ot_lat;
			var lon_str:String = '&longitude=' + ot_lon;
			var dist_str:String = 'distance=' + detect_radius;
			var safecast_url:String = 'https://api.safecast.org/measurements.json?' + dist_str + lat_str + lon_str;
			
			trace(safecast_url);
			
			//Safecast API.
			_safecastdata = new Httpserv(safecast_url, 'GET', 'text', null);
			//HTTP service listener.
			_safecastdata.addEventListener('HTTPSERV_COMPLETE', safecastDataOnDemandHandler);
			//Display ativity indicator.
			addChild(_actind_demand);
			Tweener.addTween(_actind_demand, {alpha: 0.8, time: 2});
		}
		
		//////////////////////////////
		//Safecast data on demand handler.
		//////////////////////////////
		private function safecastDataOnDemandHandler(e:Event):void {
			//Cleanup any extant 'pois' before loading new data.
			_safecastmap.removepoi();
			if (_safecastdata.json_container.length > 0) {
				//Poi (radiation point) display limit.
				var poi_limit:String = (_max_rad_txt.text == '') ? '20' : _max_rad_txt.text;
				var poi_limit_num:Number = new Number(poi_limit);
				//Build 'pois'.
				var count:int = 0;
				for each (var val:Object in _safecastdata.json_container) {
					var latitude:Number = val.latitude;
					var longitude:Number = val.longitude;
					var reading_value:Number = val.value;
					var reading_date:String = val.captured_at;
					if (count < poi_limit_num) {
						_safecastmap.buildpoi(latitude, longitude, reading_value, reading_date);
					}
					count++;
				}
			} else {
				Tweener.addTween(_no_data_popup_bg, {alpha: 0.8, time: 1.5});
				Tweener.addTween(_no_data_popup_bg, {alpha: 0, time: 1.5, delay: 1.1, onComplete: function():void {
						Tweener.removeTweens(_no_data_popup_bg);
					}});
				trace('No data available within radius.');
			}
			
			//Nominatim. Reverse Geocoding.
			_safecastmap.returnominatim(_ot_lat, _ot_lon);
			_safecastmap.addEventListener('NOMINATIM_COMPLETE', nominatimDataLoadHandler);
			function nominatimDataLoadHandler(e:Event):void {
				var txt_y_position:int = -5;
				for (var value:String in _safecastmap.nomdata) {
					if (_safecastmap.nomdata[value] != undefined || _safecastmap.nomdata[value] != null) {
						var nomdat_txt:TextField = _ui.drawTextfield(Fontlib.DroidSans, 0, 0, 0xffffff, 5, (txt_y_position += 16), (parent.width - 15), 20, 14, false, 0xffffff, false, 0x8CC63F, 'dynamic', 'left', false, value, false, true, true, false);
						nomdat_txt.text = _safecastmap.nomdata[value];
						_nominatim_popup_bg.addChild(nomdat_txt);
					}
				}
				//Clear object data.
				for (var val:String in _safecastmap.nomdata) {
					delete _safecastmap.nomdata[val];
				}
				//Cleanup nominatim listener.
				_safecastmap.removeEventListener('NOMINATIM_COMPLETE', nominatimDataLoadHandler);
			}
			
			//Cleanup json data.
			_safecastdata.json_container = null;
			//Remove HTTPService listener.
			_safecastdata.removeEventListener('HTTPSERV_COMPLETE', safecastDataOnDemandHandler);
			//Hide activity indicator.
			Tweener.addTween(_actind_demand, {alpha: 0, time: 2, onComplete: remObj, onCompleteParams: [_actind_demand]});
		}
		
		//////////////////////////////
		//Orientation change handler.
		//////////////////////////////
		private function orientationChangedHandler(e:Event):void {
			var current_width:Number = _orientation.current_width;
			var current_height:Number = _orientation.current_height;
			//Application width and height based on orientation change.
			_app_width = current_width;
			_app_height = current_height;
			//////////////////////////////
			//Re-populate display, map, etc.
			//////////////////////////////
			initSafecastMap();
			//////////////////////////////
		}
		
		//////////////////////////////
		//Remove object.
		//////////////////////////////
		private function remObj(obj:*):void {
			if (obj != null) {
				try {
					var childidx:int = getChildIndex(obj);
					removeChildAt(childidx);
				} catch (error:Error) {
					trace('Error in function: remObj()');
					trace('Error type: ' + error);
				} finally {
					obj = null;
				}
			}
		}
	}
}