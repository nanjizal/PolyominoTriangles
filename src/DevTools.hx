package ;
// Borrowed from Back2dos gist, used for testing of timing.
class DevTools {
  macro static public function measure(e, ?msg:String) {
    if (msg == null) 
      msg = haxe.macro.ExprTools.toString(e);
    return macro @:pos(e.pos) {
      var start = haxe.Timer.stamp(),
          result = [$e];//wrapping in the array skews the result a bit, but avoids issues with Void
      var duration = haxe.Timer.stamp() - start;
      trace($v{msg}+ ' took '+duration + ' seconds');//one could add some formatting here
      result[0];
    }
  }
}