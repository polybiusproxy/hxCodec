package cpp;

/**
 * A `std::vector<char *>` instance.
 */
@:keep
@:structAccess
@:include('vector')
@:native('std::vector<char *>')
extern class StdVectorChar
{
	@:native('std::vector<char *>')
	static function create():StdVectorChar;

	function at(index:Int):cpp.CharStar;
	function back():cpp.CharStar;
	function data():cpp.RawPointer<cpp.CharStar>;
	function front():cpp.CharStar;
	function pop_back():Void;
	function push_back(value:cpp.CharStar):Void;
	function size():Int;
}

/**
 * A `std::vector<const char *>` instance.
 */
@:keep
@:structAccess
@:include('vector')
@:native('std::vector<const char *>')
extern class StdVectorConstChar
{
	@:native('std::vector<const char *>')
	static function create():StdVectorConstChar;

	function at(index:Int):cpp.ConstCharStar;
	function back():cpp.ConstCharStar;
	function data():cpp.RawPointer<cpp.ConstCharStar>;
	function front():cpp.ConstCharStar;
	function pop_back():Void;
	function push_back(value:cpp.ConstCharStar):Void;
	function size():Int;
}
