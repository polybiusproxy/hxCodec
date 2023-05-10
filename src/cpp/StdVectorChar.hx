package cpp;

@:include('vector')
@:unreflective
@:structAccess
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
