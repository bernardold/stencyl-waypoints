package scripts;

import com.stencyl.graphics.G;
import com.stencyl.graphics.BitmapWrapper;

import com.stencyl.behavior.Script;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.ActorScript;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;

import com.stencyl.models.Actor;
import com.stencyl.models.GameModel;
import com.stencyl.models.actor.Animation;
import com.stencyl.models.actor.ActorType;
import com.stencyl.models.actor.Collision;
import com.stencyl.models.actor.Group;
import com.stencyl.models.Scene;
import com.stencyl.models.Sound;
import com.stencyl.models.Region;
import com.stencyl.models.Font;

import com.stencyl.Engine;
import com.stencyl.Input;
import com.stencyl.Key;
import com.stencyl.utils.Utils;

import openfl.ui.Mouse;
import openfl.display.Graphics;
import openfl.display.BlendMode;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.TouchEvent;
import openfl.net.URLLoader;

import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2Fixture;
import box2D.dynamics.joints.B2Joint;
import box2D.collision.shapes.B2Shape;

import motion.Actuate;
import motion.easing.Back;
import motion.easing.Cubic;
import motion.easing.Elastic;
import motion.easing.Expo;
import motion.easing.Linear;
import motion.easing.Quad;
import motion.easing.Quart;
import motion.easing.Quint;
import motion.easing.Sine;

import com.stencyl.graphics.shaders.BasicShader;
import com.stencyl.graphics.shaders.GrayscaleShader;
import com.stencyl.graphics.shaders.SepiaShader;
import com.stencyl.graphics.shaders.InvertShader;
import com.stencyl.graphics.shaders.GrainShader;
import com.stencyl.graphics.shaders.ExternalShader;
import com.stencyl.graphics.shaders.InlineShader;
import com.stencyl.graphics.shaders.BlurShader;
import com.stencyl.graphics.shaders.SharpenShader;
import com.stencyl.graphics.shaders.ScanlineShader;
import com.stencyl.graphics.shaders.CSBShader;
import com.stencyl.graphics.shaders.HueShader;
import com.stencyl.graphics.shaders.TintShader;
import com.stencyl.graphics.shaders.BloomShader;



class SceneEvents_0 extends SceneScript
{
	
public var _GameIsOn:Bool;

public var _DrawEnd:Bool;
    
/* ========================= Custom Event ========================= */
public function _customEvent_GameStart():Void
{
        _GameIsOn = true;
propertyChanged("_GameIsOn", _GameIsOn);
}

    
/* ========================= Custom Event ========================= */
public function _customEvent_EndGame():Void
{
        _DrawEnd = true;
propertyChanged("_DrawEnd", _DrawEnd);
}


 
 	public function new(dummy:Int, dummy2:Engine)
	{
		super();
		nameMap.set("GameIsOn", "_GameIsOn");
_GameIsOn = false;
nameMap.set("DrawEnd", "_DrawEnd");
_DrawEnd = false;

	}
	
	override public function init()
	{
		    
/* =========================== Keyboard =========================== */
addKeyStateListener("SpaceBar", function(pressed:Bool, released:Bool, list:Array<Dynamic>):Void
{
if(wrapper.enabled && pressed)
{
        if(!(_GameIsOn))
{
            _customEvent_GameStart();
            getActor(1).shout("_customEvent_" + "GameStart");
}

}
});
    
/* ========================= When Drawing ========================= */
addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void
{
if(wrapper.enabled)
{
        if(!(_GameIsOn))
{
            /* "Set a dark box at the bottom of the screen" */                 g.fillColor = Utils.getColorRGB(51,51,51);
                g.alpha = (80/100);
                g.fillRoundRect(5, 350, 630, 125, 20);
            /* "Set a text inside the box" */                 g.setFont(getFont(12));
                g.alpha = (100/100);
                g.drawString("" + "You are a Lifeguard in a Helicopter. Your job is to save ", 10, 355);
                g.drawString("" + "the survivors of an accident in the ocean.", 10, 375);
                g.drawString("" + "Press <space> when the helicopter flies over the", 10, 405);
                g.drawString("" + "lifebuoys.", 10, 425);
                g.alpha = (60/100);
                g.drawString("" + "<space>", 530, 445);
}

        if(_DrawEnd)
{
            /* "Set a dark box at the middle of the screen" */                 g.fillColor = Utils.getColorRGB(51,51,51);
                g.alpha = (100/100);
                g.setFont(getFont(14));
                g.fillRoundRect(5, ((getScreenHeight() / 2) - 50), 630, 100, 20);
            if(Engine.engine.getGameAttribute("Win"))
{
                /* "Set a text inside the box" */                     g.drawString("" + "You Win!!!", ((getScreenWidth() / 2) - 100), ((getScreenHeight() / 2) - 20));
}

            else
{
                /* "Set a text inside the box" */                     g.drawString("" + "You Lose!!", ((getScreenWidth() / 2) - 100), ((getScreenHeight() / 2) - 20));
}

}

}
});

	}	      	
	
	override public function forwardMessage(msg:String)
	{
		
	}
}