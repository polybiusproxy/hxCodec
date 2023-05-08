package cpp;

typedef CharStar_T = cpp.RawPointer<cpp.Char>;

extern abstract CharStar(CharStar_T) to CharStar_T
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

typedef CharStarStar = cpp.Pointer<CharStar>;

// typedef ConstCharStar = cpp.ConstPointer<cpp.Char>;

typedef ConstCharStarStar = cpp.Pointer<ConstCharStar>;