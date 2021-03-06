/**
 *        __       __               __ 
 *   ____/ /_ ____/ /______ _ ___  / /_
 *  / __  / / ___/ __/ ___/ / __ `/ __/
 * / /_/ / (__  ) / / /  / / /_/ / / 
 * \__,_/_/____/_/ /_/  /_/\__, /_/ 
 *                           / / 
 *                           \/ 
 * http://distriqt.com
 *
 * This is a test application for the distriqt extension
 * 
 * @author Michael Archbold & Shane Korin
 * 	
 */
package
{
	import com.distriqt.extension.adverts.AdvertPlatform;
	import com.distriqt.extension.adverts.AdvertPosition;
	import com.distriqt.extension.adverts.Adverts;
	import com.distriqt.extension.adverts.events.AdvertEvent;
	import com.distriqt.extension.adverts.events.InterstitialEvent;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	/**	
	 * Sample application for using the Adverts Native Extension
	 * 
	 * @author	Michael Archbold
	 */
	public class testadmob extends Sprite
	{
		public static const APP_KEY 								: String = "3feacd3930e12b7370e8cda5639c4f0961aff524Yo8hwVtchh50W0zd6py3VCRC0LQtRELpmuAgS9TrWcqLviunN+HUPu3ZfZKGHQbO43KgrED1/f1A4S6vZBVT/MpaV6p4xkOUE9aQWOn5jsv+IbENieTbdOKrzzXRO3P36UQgoMvciJt0XrZRcBMtmvQGi1awpIhqFIZg9whzGv7EpilgGGx6SxZiJdGr/qv1JbHwk9Ua36UzDfqdC75JmV28qgo9iGmiA+wJI/tf2Ha8i4vtwjmJAtkJsoI/crsYgBclxrdDh/atd77IoRgfM+nC1L8A26kAy9gq9tI9DCJFfFWtf3UswuI9pmbSahxq1hf5vBB1Ce3ce6edoIZ33Q==";
		
		public static const ADMOB_AD_UNIT_ID_ANDROID				: String = "ca-app-pub-7708694471693364/7962049451";
		public static const ADMOB_AD_UNIT_ID_INTERSTITIAL_ANDROID	: String = "ca-app-pub-7708694471693364/2745737012";
		
		public static const ADMOB_AD_UNIT_ID_IOS					: String = "ca-app-pub-7708694471693364/7962049451";
		public static const ADMOB_AD_UNIT_ID_INTERSTITIAL_IOS		: String = "ca-app-pub-7708694471693364/2745737012";
		
		public static const IAD_ACCOUNT_ID							: String = "";
		
		public static const TEST_KEY								: String = "8723715256D92F8D878DF5D3D6BCF1C0";
		
		
		/**
		 * Class constructor 
		 */	
		public function testadmob( appKey:String=APP_KEY, adUnitId:String=ADMOB_AD_UNIT_ID_IOS, adUnitIdInterstitial:String=ADMOB_AD_UNIT_ID_INTERSTITIAL_IOS )
		{
			super();
			_appKey = appKey;
			_adUnitId = adUnitId;
			_adUnitIdInterstitial = adUnitIdInterstitial;
			
			create();
			init();
		}
		
		
		//
		//	VARIABLES
		//
		
		private var _appKey					: String;
		private var _adUnitId				: String;
		private var _adUnitIdInterstitial	: String;
		private var _text					: TextField;
		
		
		//
		//	INITIALISATION
		//	
		
		private function create( ):void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var tf:TextFormat = new TextFormat( "_typewriter", 16 );
			_text = new TextField();
			_text.defaultTextFormat = tf;
			_text.y = 40;
			addChild( _text );
			
			stage.addEventListener( Event.RESIZE, stage_resizeHandler, false, 0, true );
			stage.addEventListener( MouseEvent.CLICK, stage_clickHandler, false, 0, true );
		}
		
		
		private function init( ):void
		{
			try
			{
				Adverts.init( _appKey );
				
				message( "Adverts Supported:       " + Adverts.isSupported );
				message( "Adverts Version:         " + Adverts.service.version );
				message( "IAD Supported:           " + Adverts.service.isPlatformSupported( AdvertPlatform.PLATFORM_IAD ) );
				message( "ADMOB Supported:         " + Adverts.service.isPlatformSupported( AdvertPlatform.PLATFORM_ADMOB ) );
				message( "DOUBLECLICK Supported:   " + Adverts.service.isPlatformSupported( AdvertPlatform.PLATFORM_DOUBLECLICK ) );
				
				if (Adverts.isSupported)
				{
					Adverts.service.addEventListener( AdvertEvent.RECEIVED_AD, 				adverts_receivedAdHandler, false, 0, true );
					Adverts.service.addEventListener( AdvertEvent.ERROR, 					adverts_errorHandler, false, 0, true );
					Adverts.service.addEventListener( AdvertEvent.USER_EVENT_DISMISSED, 	adverts_userDismissedHandler, false, 0, true );
					Adverts.service.addEventListener( AdvertEvent.USER_EVENT_LEAVE,			adverts_userLeaveHandler, false, 0, true );
					Adverts.service.addEventListener( AdvertEvent.USER_EVENT_SHOW_AD, 		adverts_userShowAdHandler, false, 0, true );
					
					Adverts.service.interstitials.addEventListener( InterstitialEvent.LOADED, 		interstitial_loadedHandler, 	false, 0, true );
					Adverts.service.interstitials.addEventListener( InterstitialEvent.ERROR, 		interstitial_errorHandler, 		false, 0, true );
					Adverts.service.interstitials.addEventListener( InterstitialEvent.DISMISSED, 	interstitial_dismissedHandler, 	false, 0, true );
					
					//					if (Adverts.service.isPlatformSupported( AdvertPlatform.PLATFORM_DOUBLECLICK ))
					//					{
					//						message( "Initialising DOUBLECLICK" );
					//						Adverts.service.initialisePlatform( AdvertPlatform.PLATFORM_DOUBLECLICK, "/6499/example/banner" );
					//					}
					if (Adverts.service.isPlatformSupported( AdvertPlatform.PLATFORM_ADMOB ))
					{
						message( "Initialising ADMOB" );
						Adverts.service.initialisePlatform( AdvertPlatform.PLATFORM_ADMOB );
						Adverts.service.setTestDetails( [ TEST_KEY ] );
					}
						//					else 
						//					if (Adverts.service.isPlatformSupported( AdvertPlatform.PLATFORM_IAD ))
						//					{
						//						message( "Initialising iAD" );
						//						Adverts.service.initialisePlatform( AdvertPlatform.PLATFORM_IAD, IAD_ACCOUNT_ID );
						//					}
					else
					{
						message( "No platform supported" );
					}
				}
				else
				{
					message( "Not supported..." );
				}
			}
			catch (e:Error)
			{
				message( e.message );
			}
		}
		
		
		//
		//	FUNCTIONALITY
		//
		
		private function message( str:String ):void
		{
			trace( str );
			_text.appendText(str+"\n");
		}
		
		
		//
		//	EVENT HANDLERS
		//
		
		private function stage_resizeHandler( event:Event ):void
		{
			_text.width  = stage.stageWidth;
			_text.height = stage.stageHeight - 100;
		}
		
		
		private function refresh():void
		{
			message( "refresh" );
			if (Adverts.isSupported)
			{
				Adverts.service.refreshAdvert();
			}
		}
		
		private var _stage:int = 0;
		
		private function stage_clickHandler( event:MouseEvent ):void
		{
			if (Adverts.isSupported)
			{
				try
				{
					switch(_stage)
					{
						case 0:
						{
							var size:AdvertPosition = new AdvertPosition();
							size.verticalAlign   = AdvertPosition.ALIGN_BOTTOM;
							size.horizontalAlign = AdvertPosition.ALIGN_CENTER;
							
							message("Adverts.showAdvert(" + size.toString() + ")");
							Adverts.service.showAdvert( size, _adUnitId );
							break;
						}
							
						case 1:
						{
							Adverts.service.refreshAdvert();
							break;
						}
							
						case 2:
						{
							Adverts.service.hideAdvert();
							break;
						}
							
						case 3:
						{
							if (Adverts.service.interstitials.isSupported)
							{
								Adverts.service.interstitials.load( _adUnitIdInterstitial );
							}
							else
							{
								message( "Interstitials not supported" );
							}
							break;
						}
							
						case 4:
						{
							if (Adverts.service.interstitials.isSupported)
							{
								if (Adverts.service.interstitials.isReady())
								{
									Adverts.service.interstitials.show();
								}
								else
								{
									message( "Interstitial not ready" );
								}
							}
							break;
						}
							
						default:
							_stage = 0;
							return;
							
					}
				}
				catch (e:Error)
				{
					message( "ERROR::"+e.message );
				}
				_stage ++; 
			}
		}
		
		
		//
		//	EXTENSION LISTENERS
		//
		
		private function adverts_receivedAdHandler( event:AdvertEvent ):void
		{
			message( "adverts_receivedAdHandler" );
		}
		
		private function adverts_errorHandler( event:AdvertEvent ):void
		{
			message( "adverts_errorHandler:: " + event.details.message );
			//
			//	If you wish you can force a reload attempt here by setting a delayed call to refreshAdvert
			//			setTimeout( refresh, 10000 );	
		}
		
		private function adverts_userDismissedHandler( event:AdvertEvent ):void
		{
			message( "adverts_userDismissedHandler" );
		}
		
		private function adverts_userLeaveHandler( event:AdvertEvent ):void
		{
			message( "adverts_userLeaveHandler" );
		}
		
		private function adverts_userShowAdHandler( event:AdvertEvent ):void
		{
			message( "adverts_userShowAdHandler" );
		}
		
		
		
		
		
		private function interstitial_loadedHandler( event:InterstitialEvent ):void
		{
			message( "interstitial_loadedHandler" );
		}
		
		private function interstitial_errorHandler( event:InterstitialEvent ):void
		{
			message( "interstitial_errorHandler" );
		}
		
		private function interstitial_dismissedHandler( event:InterstitialEvent ):void
		{
			message( "interstitial_dismissedHandler" );
		}
		
		
	}
	
}

