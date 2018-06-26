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



class Design_4_4_EnemyWaypointBehavior extends ActorScript
{          	
	
public var _Waypoints:Array<Dynamic>;

public var _WaypointsToFind:Array<Dynamic>;

public var _StartAtFirstWaypoint:Bool;

public var _ControlNum01:Float;

public var _TempRotation:Float;

public var _MoveSpeed:Float;

public var _Moving:Bool;

public var _Range:Float;

public var _BouysCollected:Float;
    
/* ========================= Custom Event ========================= */
public function _customEvent_GameStart():Void
{
        runLater(1000 * .2, function(timeTask:TimedTask):Void {
                    _Moving = true;
propertyChanged("_Moving", _Moving);
                    _customEvent_Fly();
}, actor);
}

    
/* ========================= Custom Event ========================= */
public function _customEvent_Fly():Void
{
        if(_Moving)
{
            _TempRotation = asNumber((Utils.DEG * (Math.atan2((actor.getYCenter() - _Waypoints[Std.int(_ControlNum01)].getYCenter()), (actor.getXCenter() - _Waypoints[Std.int(_ControlNum01)].getXCenter()))) + 180));
propertyChanged("_TempRotation", _TempRotation);
            actor.setAngle(Utils.RAD * (_TempRotation));
            actor.setVelocity(_TempRotation, _MoveSpeed);
}

}


 
 	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("Actor", "actor");
nameMap.set("Waypoints", "_Waypoints");
_Waypoints = [];
nameMap.set("WaypointsToFind", "_WaypointsToFind");
_WaypointsToFind = [];
nameMap.set("StartAtFirstWaypoint", "_StartAtFirstWaypoint");
_StartAtFirstWaypoint = false;
nameMap.set("ControlNum01", "_ControlNum01");
_ControlNum01 = 0.0;
nameMap.set("TempRotation", "_TempRotation");
_TempRotation = 0.0;
nameMap.set("MoveSpeed", "_MoveSpeed");
_MoveSpeed = 0.0;
nameMap.set("Moving", "_Moving");
_Moving = false;
nameMap.set("Range", "_Range");
_Range = 25.0;
nameMap.set("BouysCollected", "_BouysCollected");
_BouysCollected = 0.0;

	}
	
	override public function init()
	{
		    
/* ======================== When Creating ========================= */
        _Waypoints = new Array<Dynamic>();
propertyChanged("_Waypoints", _Waypoints);
        runLater(1000 * 0.125, function(timeTask:TimedTask):Void {
                    for(item in cast(_WaypointsToFind, Array<Dynamic>))
{
                        for(actorInGroup in cast(getActorGroup(4), Group).list)
{
if(actorInGroup != null && !actorInGroup.dead && !actorInGroup.recycled){
                            if((actorInGroup.getActorValue("WaypointIndex") == item))
{
                                _Waypoints.push(actorInGroup);
                                break;
}

}
}

}

                    if(_StartAtFirstWaypoint)
{
                        actor.setX((_Waypoints[Std.int(_ControlNum01)].getXCenter() - (actor.getWidth()/2)));
                        actor.setY((_Waypoints[Std.int(_ControlNum01)].getYCenter() - (actor.getHeight()/2)));
                        _ControlNum01 += 1;
propertyChanged("_ControlNum01", _ControlNum01);
}

}, actor);
    
/* ======================== When Updating ========================= */
addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
{
if(wrapper.enabled)
{
        if(_Moving)
{
            if((((actor.getXCenter() >= (_Waypoints[Std.int(_ControlNum01)].getXCenter() - 5)) && (actor.getXCenter() <= (_Waypoints[Std.int(_ControlNum01)].getXCenter() + 5))) && ((actor.getYCenter() >= (_Waypoints[Std.int(_ControlNum01)].getYCenter() - 5)) && (actor.getYCenter() <= (_Waypoints[Std.int(_ControlNum01)].getYCenter() + 5)))))
{
                _ControlNum01 += 1;
propertyChanged("_ControlNum01", _ControlNum01);
                /* "Finish condition (End of Waypoints list)" */
                if((_ControlNum01 > (_Waypoints.length - 1)))
{
                    _Moving = false;
propertyChanged("_Moving", _Moving);
                    _MoveSpeed = asNumber(0);
propertyChanged("_MoveSpeed", _MoveSpeed);
                    actor.setVelocity(0, _MoveSpeed);
                    if((_BouysCollected == 10))
{
                        Engine.engine.setGameAttribute("Win", true);
}

                    shoutToScene("_customEvent_" + "EndGame");
}

                else
{
                    _customEvent_Fly();
}

}

}

}
});
    
/* ======================== Actor of Type ========================= */
addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
{
if(wrapper.enabled && sameAsAny(getActorType(2), event.otherActor.getType(),event.otherActor.getGroup()))
{
        if(_Moving)
{
            if(isKeyDown("SpaceBar"))
{
                /* "If before touch the center" */
                if((((actor.getXCenter() >= (_Waypoints[Std.int(_ControlNum01)].getXCenter() - _Range)) && (actor.getXCenter() <= (_Waypoints[Std.int(_ControlNum01)].getXCenter() + _Range))) && ((actor.getYCenter() >= (_Waypoints[Std.int(_ControlNum01)].getYCenter() - _Range)) && (actor.getYCenter() <= (_Waypoints[Std.int(_ControlNum01)].getYCenter() + _Range)))))
{
                    recycleActor(actor.getLastCollidedActor());
                    _BouysCollected += 1;
propertyChanged("_BouysCollected", _BouysCollected);
                    playSound(getSound(10));
                    _ControlNum01 += 1;
propertyChanged("_ControlNum01", _ControlNum01);
                    _customEvent_Fly();
}

                /* "If after touch the center" */
                else if((((actor.getXCenter() >= (_Waypoints[Std.int((_ControlNum01 - 1))].getXCenter() - _Range)) && (actor.getXCenter() <= (_Waypoints[Std.int((_ControlNum01 - 1))].getXCenter() + _Range))) && ((actor.getYCenter() >= (_Waypoints[Std.int((_ControlNum01 - 1))].getYCenter() - _Range)) && (actor.getYCenter() <= (_Waypoints[Std.int((_ControlNum01 - 1))].getYCenter() + _Range)))))
{
                    recycleActor(actor.getLastCollidedActor());
                    _BouysCollected += 1;
propertyChanged("_BouysCollected", _BouysCollected);
                    playSound(getSound(10));
                    _customEvent_Fly();
}

}

}

}
});
    
/* =========================== Keyboard =========================== */
addKeyStateListener("SpaceBar", function(pressed:Bool, released:Bool, list:Array<Dynamic>):Void
{
if(wrapper.enabled && pressed)
{
        if((!((((actor.getXCenter() >= (_Waypoints[Std.int(_ControlNum01)].getXCenter() - _Range)) && (actor.getXCenter() <= (_Waypoints[Std.int(_ControlNum01)].getXCenter() + _Range))) && ((actor.getYCenter() >= (_Waypoints[Std.int(_ControlNum01)].getYCenter() - _Range)) && (actor.getYCenter() <= (_Waypoints[Std.int(_ControlNum01)].getYCenter() + _Range))))) && !((((actor.getXCenter() >= (_Waypoints[Std.int((_ControlNum01 - 1))].getXCenter() - _Range)) && (actor.getXCenter() <= (_Waypoints[Std.int((_ControlNum01 - 1))].getXCenter() + _Range))) && ((actor.getYCenter() >= (_Waypoints[Std.int((_ControlNum01 - 1))].getYCenter() - _Range)) && (actor.getYCenter() <= (_Waypoints[Std.int((_ControlNum01 - 1))].getYCenter() + _Range)))))))
{
            playSound(getSound(11));
}

}
});

	}	      	
	
	override public function forwardMessage(msg:String)
	{
		
	}
}