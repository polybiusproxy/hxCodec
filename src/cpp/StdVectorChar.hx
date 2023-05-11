package cpp;

@:include('vector')
@:unreflective
@:structAccess
@:native('std::vector<char *>')
extern class StdVectorChar
{
	@:native('std::vector<char *>')
	static function create():StdVectorChar;

	function at(index:Int):CharStar;
	function back():CharStar;
	function data():RawPointer<CharStar>;
	function front():CharStar;
	function pop_back():Void;
	function push_back(value:CharStar):Void;
	function size():Int;
}
