package cpp;

extern abstract CharStar(RawPointer<Char>) to (RawPointer<Char>)
{
	inline function new(s:String):Void
		this = untyped s.__s;

	@:from
	static public inline function fromString(s:String):CharStar
		return new CharStar(s);

	@:to extern public inline function toString():String
		return new String(untyped this);

	@:to extern public inline function toPointer():RawPointer<Char>
		return this;
}
