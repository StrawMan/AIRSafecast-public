///////////////////////////
//AIRSafecast 1.0.
//Map.as.
//Map builder class.
///////////////////////////
package com.mobiledesign.airsafecast {
	import flash.display.*;
	import flash.geom.Point;
	import flash.events.*;
	import flash.text.*;
	import mx.controls.*;
	///////////////////////////
	//Starling framework.
	///////////////////////////
	//import starling.display.*;
	//import starling.events.*;
	//import starling.text.*;
	///////////////////////////
	//Mapquest API.
	///////////////////////////
	import com.mapquest.tilemap.*;
	import com.mapquest.Config;
	import com.mapquest.LatLng;
	import com.mapquest.tilemap.controls.inputdevice.*;
	import com.mapquest.tilemap.controls.shadymeadow.*;
	import com.mapquest.tilemap.pois.*;
	import com.mapquest.tilemap.overlays.*;
	import com.mapquest.services.nominatim.*;
	///////////////////////////
	
	public class Map extends Sprite {
		//////////////////////////////
		//Embedded assets.
		//////////////////////////////
		//Radiation map points.
		//0.2usv
		[Embed(source="/../icons/radiation_green.png")]
		public static var RadPointGreen:Class;
		//0.5usv
		[Embed(source="/../icons/radiation_yellow.png")]
		public static var RadPointYellow:Class;
		//1usv
		[Embed(source="/../icons/radiation_pink.png")]
		public static var RadPointPink:Class;
		//5usv
		[Embed(source="/../icons/radiation_blue.png")]
		public static var RadPointBlue:Class;
		//12usv
		[Embed(source="/../icons/radiation_red.png")]
		public static var RadPointRed:Class;
		//12+usv
		[Embed(source="/../icons/radiation_black.png")]
		public static var RadPointBlack:Class;
		
		//////////////////////////////
		//Internal class variables.
		//////////////////////////////
		//Instance.
		private var _map:TileMap;
		private var _nominatim:Nominatim;
		private var _app_width:Number;
		private var _app_height:Number;
		//Public data.
		public var nomdata:Object = {};
		public var latlongover_point:String;
		public var latlongclick_point:String;
		
		//////////////////////////////
		//Constructor.
		//////////////////////////////
		public function Map(w:int, h:int, lat:Number, lon:Number, zoom:int, orient_str:String) {
			_app_width = w;
			_app_height = h;
			//Map.
			_map = buildmap(_app_width, _app_height, lat, lon, zoom, orient_str);
			addChild(_map);
			//Nominatim.
			buildnominatim();
			//Return mouse over/press/touch coordinates.
			_map.addEventListener(MouseEvent.MOUSE_MOVE, onMouseOverTouchCoordinateHandler);
			_map.addEventListener(TileMapEvent.CLICK, onMouseClickTouchCoordinateHandler);
		}
		
		//////////////////////////////
		
		//////////////////////////////
		//////////////////////////////
		//Public methods.
		//////////////////////////////
		//////////////////////////////
		
		//////////////////////////////
		//Build poi.
		//////////////////////////////
		public function buildpoi(latitude:Number, longitude:Number, reading_value:Number, reading_date:String):void {
			//Latitude, longitude object.
			var ll:LatLng = new LatLng(latitude, longitude);
			//Define poi.
			var poi:Poi = new Poi(ll);
			poi.draggable = true;
			poi.keepRolloverOnDrag = true;
			//Poi events.
			poi.addEventListener(MouseEvent.CLICK, onPoiClickHander, false, 0, true);
			//Calculate millisieverts.
			var rad_val:Number = (reading_value / 350);
			var rad_val_round:Number = Math.round(rad_val * 100) / 100;
			//Title.
			poi.rolloverAndInfoTitleText = rad_val_round + 'uSv/h | ' + reading_value + 'cpm';
			//Content popup window.
			var strContent:String = new String();
			var lat_cut:String = latitude.toFixed(2);
			var lon_cut:String = longitude.toFixed(2);
			strContent += reading_date;
			strContent += '<br />----------------------------<br />';
			strContent += '<b><font color="#980e10">Latitude:</font></b> ' + lat_cut + '<br />';
			strContent += '<b><font color="#980e10">Longitude:</font></b> ' + lon_cut + '<br />';
			poi.infoContent = (strContent);
			//Custom icon.
			var ico:MapIcon = new MapIcon();
			ico.cacheAsBitmap = true;
			//Colour of point based on severity of contamination.
			switch (true) {
				//Green.
				case(rad_val_round <= 0.2):
					ico.setImage(new RadPointGreen(), 32, 37);
					break;
				//Yellow.
				case(rad_val_round > 0.2 && rad_val_round <= 0.5):
					ico.setImage(new RadPointYellow(), 32, 37);
					break;
				//Pink.
				case(rad_val_round > 0.5 && rad_val_round <= 1.0):
					ico.setImage(new RadPointPink(), 32, 37);
					break;
				//Blue.
				case(rad_val_round > 1.0 && rad_val_round <= 5.0):
					ico.setImage(new RadPointBlue(), 32, 37);
					break;
				//Red.
				case(rad_val_round > 5.0 && rad_val_round <= 12.0):
					ico.setImage(new RadPointRed(), 32, 37);
					break;
				//Black.
				case(rad_val_round > 12.0):
					ico.setImage(new RadPointBlack(), 32, 37);
					break;
			}
			poi.icon = ico;
			//Add to map.
			_map.addShape(poi);
		}
		
		//////////////////////////////
		//Remove poi.
		//////////////////////////////
		public function removepoi():void {
			//Clean map. Remove 'pois'.
			_map.removeShapes();
		}
		
		//////////////////////////////
		//Return nominatim data.
		//////////////////////////////
		public function returnominatim(ot_lat:String, ot_lon:String):void {
			//Nominatim. Reverse Geocoding.
			var ll:LatLng = new LatLng(Number(ot_lat), Number(ot_lon));
			_nominatim.reverseByLatLng(ll);
		}
		
		//////////////////////////////
		//////////////////////////////
		//Private methods.
		//////////////////////////////
		//////////////////////////////
		
		//////////////////////////////
		//Build map.
		//////////////////////////////
		private function buildmap(w:int, h:int, lat:Number, lon:Number, zoom:int, orient_str:String):TileMap {
			var map:TileMap = new TileMap('Fmjtd%7Cluu2n10an9%2C7g%3Do5-hwawh');
			var position:LatLng = new LatLng(lat, lon);
			map.size = new Size(w, h);
			map.mapFriction = 1.8;
			map.mapType = 'map';
			map.name = 'Safecast - Japan';
			map.showMobileCursor = false;
			map.cacheAsBitmap = true;
			//Add controls. Position based on device orientation.
			switch (orient_str) {
				case 'landscape':
					map.addControl(new SMLargeZoomControl(45), new MapCornerPlacement(MapCorner.TOP_RIGHT, new Size(30, 130)));
					map.addControl(new SMViewControl(155), new MapCornerPlacement(MapCorner.TOP_RIGHT, new Size(90, 20)));
					break;
				case 'portrait':
					map.addControl(new SMLargeZoomControl(50), new MapCornerPlacement(MapCorner.TOP_RIGHT, new Size(30, 250)));
					map.addControl(new SMViewControl(160), new MapCornerPlacement(MapCorner.TOP_RIGHT, new Size(90, 130)));
					break;
			}
			map.addControl(new MouseWheelZoomControl());
			//Map center and zoom level.
			map.setCenter(position, zoom);
			//Declutter object. 
			var force_declutter:ForceDeclutter = new ForceDeclutter();
			force_declutter.useAnimation = true;
			map.declutter = force_declutter;
			return map;
		}
		
		//////////////////////////////
		//Build nominatim.
		//////////////////////////////
		private function buildnominatim():void {
			_nominatim = new Nominatim();
			_nominatim.addEventListener(NominatimEvent.NOMINATIM_RESULT, onNominatimResult);
			_nominatim.addEventListener(IOErrorEvent.IO_ERROR, onNominatimIOError);
			_nominatim.addEventListener(NominatimEvent.HTTP_ERROR_EVENT, onNominatimHttpError);
		}
		
		//////////////////////////////
		//////////////////////////////
		//Event handling.
		//////////////////////////////
		//////////////////////////////
		
		//////////////////////////////
		//Poi events.
		//////////////////////////////
		//Prevent click on Poi from propagating to map underneath.
		private function onPoiClickHander(e:MouseEvent):void {
			e.stopImmediatePropagation();
		}
		
		//////////////////////////////
		//Return mouse over/press/touch coordinates.
		//////////////////////////////
		private function onMouseOverTouchCoordinateHandler(e:MouseEvent):void {
			latlongover_point = _map.pixToLL(new Point(_map.mouseX, _map.mouseY)).toString();
			dispatchEvent(new Event('MAP_OVER_COORD_COMPLETE', true));
		}
		private function onMouseClickTouchCoordinateHandler(e:TileMapEvent):void {
			latlongclick_point = _map.pixToLL(new Point(_map.mouseX, _map.mouseY)).toString();
			dispatchEvent(new Event('MAP_TOUCH_COORD_COMPLETE', true));
		}
		
		//////////////////////////////
		//Nominatim handlers.
		//////////////////////////////
		private function onNominatimResult(e:NominatimEvent):void {
			var r:NominatimResponse = e.nominatimResponse;
			nomdata.country = (r.resultData.addressparts.country.length() > 0) ? "Country: " + r.resultData.addressparts.country : null;
			nomdata.state = (r.resultData.addressparts.state.length() > 0) ? "State: " + r.resultData.addressparts.state : null;
			nomdata.region = (r.resultData.addressparts.region.length() > 0) ? "Region: " + r.resultData.addressparts.region : null;
			nomdata.county = (r.resultData.addressparts.county.length() > 0) ? "County: " + r.resultData.addressparts.county : null;
			nomdata.city = (r.resultData.addressparts.city.length() > 0) ? "City: " + r.resultData.addressparts.city : null;
			nomdata.suburb = (r.resultData.addressparts.suburb.length() > 0) ? "Suburb: " + r.resultData.addressparts.suburb : null;
			nomdata.road = (r.resultData.addressparts.road.length() > 0) ? "Road: " + r.resultData.addressparts.road : null;
			dispatchEvent(new Event('NOMINATIM_COMPLETE', true));
		}
		
		//Nominatim IO Error.
		private function onNominatimIOError(e:IOErrorEvent):void {
			trace("IO Error: " + e.text);
		}
		
		//Nominatim HTTP Error.
		private function onNominatimHttpError(e:NominatimEvent):void {
			trace("HTTP Error: " + (e.errorEvent as IOErrorEvent).text);
		}
	}
}