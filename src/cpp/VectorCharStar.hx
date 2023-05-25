package cpp;

@:include('vector')
@:unreflective
@:structAccess
@:native('std::vector<const char *>')
extern class VectorCharStar
{
	@:native('std::vector<const char *>')
	static function create():VectorCharStar;

	function at(index:Int):CharStar;
	function back():CharStar;
	function data():RawPointer<CharStar>;
	function front():CharStar;
	function pop_back():Void;
	function push_back(value:CharStar):Void;
	function size():Int;
}
