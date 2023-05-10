package cpp;

@:include('vector')
@:unreflective
@:structAccess
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
