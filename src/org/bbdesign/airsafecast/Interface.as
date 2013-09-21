//////////////////////////////
//AIRSafecast 1.0.
//Interface.as.
//UI elements.
//////////////////////////////
package org.bbdesign.airsafecast {
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.text.engine.FontWeight;
	import flash.filters.*;
	import flash.geom.*;
	//////////////////////////////
	import fl.controls.Button;
	import fl.controls.ProgressBar;
	import fl.controls.Slider;
	import fl.controls.SliderDirection;
	import fl.controls.Label;
	import fl.data.*;
	//Skinnable Minimal Components.
	import com.bit101.components.PushButton;
	import com.bit101.components.HSlider;
	import com.dgrigg.skins.*;
	//Mad Components.
	import com.danielfreeman.madcomponents.UIActivity;
	import com.danielfreeman.extendedMadness.UIDropWindow;
	import com.danielfreeman.madcomponents.UIButton;
	import com.danielfreeman.madcomponents.Attributes;
	import com.danielfreeman.madcomponents.UI;
	//Mad Components - Pure Helpers.
	import pureHelpers.UIFormMaker;
	
	//////////////////////////////
	public class Interface extends Sprite {
		//////////////////////////////
		//Internal class variables.
		//////////////////////////////
		//Instance.
		private var _matte:Sprite = new Sprite();
		private var _buttn:Button = new Button();
		private var _pbuttn:PushButton;
		private var _pb:ProgressBar;
		private var _txtfont:Font;
		private var _textfield:TextField;
		private var _txtfldborder:Boolean;
		private var _txtfldbordercol:uint;
		private var _txtfldtype:String;
		private var _txtformat:TextFormat = new TextFormat();
		private var _glowfilter:GlowFilter = new GlowFilter();
		private var _dropShadow:DropShadowFilter = new DropShadowFilter();
		private var _slider:Slider;
		private var _hslider:HSlider;
		private var _actind:Sprite;
		private var _stxt:StageText;
		
		//////////////////////////////
		//Constructor.
		//////////////////////////////
		public function Interface() {
			//////////////////////////////
			//Initialize general filters.
			//////////////////////////////
			_glowfilter = initGlowFilter();
			_dropShadow = initDropShadowFilter();
			//////////////////////////////
		}
		
		//////////////////////////////
		
		//////////////////////////////
		
		//////////////////////////////
		//Public methods.
		//////////////////////////////
		
		//////////////////////////////
		
		//////////////////////////////
		//Build simple shapes.
		//////////////////////////////
		public function drawMatte(thick:Number, linecol:uint, col:uint, xpos:Number, ypos:Number, wd:Number, ht:Number, drawtype:String = 'rect', radwd:Number = undefined, radht:Number = undefined, alph:Number = 1.0, dpshadow:Boolean = false, nm:String = null):Sprite {
			_matte = new Sprite();
			_matte.graphics.lineStyle(thick, linecol);
			_matte.graphics.beginFill(col);
			switch (drawtype) {
				case 'roundrect':
					_matte.graphics.drawRoundRect(0, 0, wd, ht, radwd, radht);
					break;
				case 'rect':
					_matte.graphics.drawRect(0, 0, wd, ht);
					break;
			}
			_matte.graphics.endFill();
			_matte.alpha = alph;
			_matte.x = xpos;
			_matte.y = ypos;
			if (nm != null) {
				_matte.name = nm;
			}
			if (dpshadow) {
				_matte.filters = [_dropShadow];
			}
			_matte.cacheAsBitmap = true;
			return _matte;
		}
		
		//////////////////////////////
		//Build standard buttons.
		//////////////////////////////
		public function drawButton(font:Class, col:uint, txtfontsize:Number, btnlabel:String, xpos:Number, ypos:Number, wd:Number, btnemphasis:Boolean, sharp:Number = 0, thick:Number = 0):Button {
			_txtfont = new font;
			_txtformat.font = _txtfont.fontName;
			_txtformat.size = txtfontsize;
			_txtformat.color = col;
			
			_buttn.useHandCursor = true;
			_buttn.label = btnlabel;
			_buttn.x = xpos;
			_buttn.y = ypos;
			_buttn.width = wd;
			_buttn.alpha = .9;
			_buttn.emphasized = btnemphasis;
			_buttn.textField.antiAliasType = AntiAliasType.ADVANCED;
			_buttn.textField.sharpness = sharp;
			_buttn.textField.thickness = thick;
			_buttn.setStyle('textFormat', _txtformat);
			_buttn.setStyle('embedFonts', true);
			_buttn.cacheAsBitmap = true;
			
			_buttn.addEventListener(MouseEvent.MOUSE_OVER, btnOver);
			_buttn.addEventListener(MouseEvent.MOUSE_OUT, btnOut);
			
			function btnOver():void {
				_buttn.alpha = 1.0;
				_buttn.filters = [_dropShadow];
			}
			function btnOut():void {
				_buttn.alpha = .9;
				_buttn.filters = [];
			}
			return _buttn;
		}
		
		//////////////////////////////
		//Build SMC pushbutton.
		//////////////////////////////
		public function drawPushButton(parent:DisplayObjectContainer, btnlabel:String, wd:Number, ht:Number, xpos:Number, ypos:Number):PushButton {
			_pbuttn = new PushButton(parent)
			_pbuttn.label = btnlabel;
			_pbuttn.width = wd;
			_pbuttn.height = ht;
			_pbuttn.x = xpos;
			_pbuttn.y = ypos;
			_pbuttn.skinClass = com.dgrigg.skins.ButtonImageSkin;
			_pbuttn.cacheAsBitmap = true;
			return _pbuttn;
		}
		
		//////////////////////////////
		//Build progress bar.
		//////////////////////////////
		public function buildProgressBar(source:*, labelstring:String, xpos:int, ypos:int, font:Class, col:uint, txtfontsize:Number):ProgressBar {
			_txtfont = new font;
			_txtformat.font = _txtfont.fontName;
			_txtformat.size = txtfontsize;
			_txtformat.color = col;
			
			_pb = new ProgressBar();
			var pbLabel:Label = new Label();
			pbLabel.text = labelstring;
			pbLabel.autoSize = TextFieldAutoSize.LEFT;
			pbLabel.move(_pb.x, _pb.y + _pb.height);
			pbLabel.setStyle('textFormat', _txtformat);
			pbLabel.setStyle('embedFonts', true);
			_pb.addChild(pbLabel);
			
			_pb.source = source;
			_pb.x = xpos;
			_pb.y = ypos;
			_pb.cacheAsBitmap = true;
			return _pb;
		}
		
		//////////////////////////////
		//Build activity indicator.
		//////////////////////////////
		public function buildActivityIndicator(xpos:Number, ypos:Number, appwidth:Number, appheight:Number):Sprite {
			var actind_bg:Sprite = this.drawMatte(0, 0x000000, 0x000000, 0, 0, appwidth, appheight, 'rect', undefined, undefined, 0.8, false, 'actind_bg');
			var actind:UIActivity = new UIActivity(actind_bg, xpos, ypos);
			actind.scaleX = 1;
			actind.scaleY = 1;
			actind.rotate = true;
			_actind = actind_bg;
			return _actind;
		}
		
		//////////////////////////////
		//Build callout menu.
		//////////////////////////////
		public function buildCallout(xpos:Number, ypos:Number, width:Number, height:Number, formdat:Array):UIDropWindow {
			var callout:UIDropWindow = new UIDropWindow(this,         <null/>, new Attributes(0, 0, width, height));
			callout.x = xpos;
			callout.y = ypos;
			var form:UIFormMaker = new UIFormMaker(callout, width, height);
			for (var ad:int = 0; ad < formdat.length; ad++) {
				var button:PushButton = drawPushButton(this, formdat[ad], width, 40, 0, 0);
				form.attachVertical(button);
			}
			form.x = form.y = -UI.PADDING;
			return callout;
		}
		
		//////////////////////////////
		//Build text fields.
		//////////////////////////////
		public function drawTextfield(font:*, sharp:Number, thick:Number, col:uint, xpos:int, ypos:int, wd:int, txtht:int, txtfontsize:Number, txtback:Boolean, txtbackcol:uint, txtfldborder:Boolean, txtfldbordercol:uint, txtfldtype:String, txtalign:String, txtselect:Boolean, txtname:String, txtembed:Boolean, wordwrap:Boolean = true, multiline:Boolean = true, underline:Boolean = false):TextField {
			_textfield = new TextField();
			if (font == "_sans") {
				_txtformat.font = "_sans";
				_textfield.embedFonts = false;
			} else {
				_txtfont = new font;
				_txtformat.font = _txtfont.fontName;
				_textfield.embedFonts = txtembed;
			}
			_txtformat.size = txtfontsize;
			_txtformat.underline = underline;
			switch (txtalign) {
				case 'center':
					_txtformat.align = TextFormatAlign.CENTER;
					break;
				case 'justify':
					_txtformat.align = TextFormatAlign.JUSTIFY;
					break;
				case 'left':
					_txtformat.align = TextFormatAlign.LEFT;
					break;
				case 'right':
					_txtformat.align = TextFormatAlign.RIGHT;
					break;
			}
			switch (txtfldtype) {
				case 'input':
					_textfield.type = TextFieldType.INPUT;
					break;
				case 'dynamic':
					_textfield.type = TextFieldType.DYNAMIC;
					break;
			}
			_textfield.antiAliasType = AntiAliasType.ADVANCED;
			_textfield.sharpness = sharp;
			_textfield.thickness = thick;
			_textfield.alwaysShowSelection = true;
			_textfield.mouseWheelEnabled = true;
			_textfield.condenseWhite = true;
			_textfield.wordWrap = wordwrap;
			_textfield.multiline = multiline;
			_textfield.border = txtfldborder;
			_textfield.borderColor = txtfldbordercol;
			_textfield.selectable = txtselect;
			_textfield.background = txtback;
			_textfield.backgroundColor = txtbackcol;
			_textfield.textColor = col;
			if (txtht as String == 'auto') {
				_textfield.autoSize = TextFieldAutoSize.LEFT;
			} else {
				_textfield.height = txtht as Number;
			}
			_textfield.width = wd;
			_textfield.x = xpos;
			_textfield.y = ypos;
			_textfield.name = txtname;
			_textfield.defaultTextFormat = _txtformat;
			_textfield.setTextFormat(_txtformat);
			_textfield.cacheAsBitmap = true;
			return _textfield;
		}
		
		//////////////////////////////
		//Build slider.
		//////////////////////////////
		public function buildSlider(xpos:int, ypos:int, dir:String, nummax:Number):Slider {
			_slider = new Slider();
			switch (dir) {
				case 'vertical':
					_slider.direction = SliderDirection.VERTICAL;
					break;
				case 'horizontal':
					_slider.direction = SliderDirection.HORIZONTAL;
					break;
			}
			_slider.minimum = 1;
			_slider.maximum = nummax;
			_slider.value = 1;
			_slider.liveDragging = true;
			_slider.snapInterval = 1;
			_slider.tickInterval = 5;
			_slider.move(xpos, ypos);
			_slider.validateNow();
			_slider.cacheAsBitmap = true;
			return _slider;
		}
		
		//////////////////////////////
		//Build SMC horizontal slider.
		//////////////////////////////
		public function buildHSlider(parent:DisplayObjectContainer, xpos:int, ypos:int, nummax:Number):HSlider {
			_hslider = new HSlider(parent, xpos, ypos);
			_hslider.minimum = 1;
			_hslider.maximum = nummax;
			_hslider.value = 1;
			_hslider.tick = 1;
			_hslider.horzGutter = 5;
			_hslider.cacheAsBitmap = true;
			_hslider.skinClass = com.dgrigg.skins.HSliderImageSkin;
			return _hslider;
		}
		
		//////////////////////////////
		//Build stageText instance.
		//////////////////////////////
		public function buildStagetext(stage:Stage, viewport:Rectangle, max_chars:int):StageText {
			var stageTextInitOptions:StageTextInitOptions = new StageTextInitOptions(false);
			_stxt = new StageText();
			_stxt.maxChars = max_chars;
			_stxt.restrict = '0-9';
			_stxt.textAlign = 'center';
			_stxt.softKeyboardType = SoftKeyboardType.NUMBER;
			_stxt.returnKeyLabel = ReturnKeyLabel.DONE;
			_stxt.fontSize = 18;
			_stxt.fontWeight = FontWeight.BOLD;
			_stxt.color = 0x000000;
			_stxt.stage = stage;
			_stxt.viewPort = viewport;
			_stxt.assignFocus();
			return _stxt;
		}
		
		//////////////////////////////
		//Initialize filters.
		//////////////////////////////
		public function initGlowFilter():GlowFilter {
			_glowfilter.color = 0x003366;
			_glowfilter.blurX = 12;
			_glowfilter.blurY = 12;
			_glowfilter.quality = 3;
			return _glowfilter;
		}
		
		public function initDropShadowFilter():DropShadowFilter {
			_dropShadow.color = 0x000000;
			_dropShadow.blurX = 5;
			_dropShadow.blurY = 5;
			_dropShadow.angle = 30;
			_dropShadow.alpha = 0.5;
			_dropShadow.distance = 5;
			_dropShadow.quality = 3;
			return _dropShadow;
		}
	}
}

