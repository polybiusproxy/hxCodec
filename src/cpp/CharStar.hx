package cpp;

extern abstract CharStar(cpp.RawPointer<cpp.Char>) to (cpp.RawPointer<cpp.Char>)
{
    	inline function new(s:String):Void
        		this = untyped s.__s;

                	@:from
                    	static public inline function fromString(s:String):CharStar
                        		return new CharStar(s);

                                	@:to extern public inline function toString():String
                                    		return new String(untyped this);

                                            	@:to extern public inline function toPointer():cpp.RawPointer<cpp.Char>
                                                		return this;
}
}