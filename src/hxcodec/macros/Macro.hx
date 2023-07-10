package hxcodec.macros;

import haxe.macro.Printer;
import haxe.io.Path;
import haxe.macro.Expr;
import haxe.macro.Context;

using haxe.macro.PositionTools;

class Macro {
	macro public static function includeXml(_lib:String, _file:String, _relative_root:String='../../../'):Array<Field> {
		var _pos =  Context.currentPos();
		var _pos_info = _pos.getInfos();
		var _class = Context.getLocalClass();

		var _source_path = Path.directory(_pos_info.file);
		if(!Path.isAbsolute(_source_path)) {
			_source_path = Path.join([Sys.getCwd(), _source_path]);
		}

		_source_path = Path.normalize(_source_path);

		var _lib_path = Path.normalize(Path.join([_source_path, _relative_root]));
		var _include_path = Path.normalize(Path.join([_lib_path, _file]));
		var _lib_var = '${_lib.toUpperCase()}_PATH';

		var _define = '<set name="$_lib_var" value="$_lib_path/"/>';
		var _import_path = '$${$_lib_var}$_file';
		var _import = '<include name="$_import_path" />';

		_class.get().meta.add(":buildXml", [
			{
				expr: EConst(CString('$_define\n$_import')),
				pos:_pos
			}
		], _pos);

		return Context.getBuildFields();
	}

	macro public static function includeHeader(_lib:String, _file:String, _relative_root:String='../../../'):Array<Field> {
		var _pos =  Context.currentPos();
		var _pos_info = _pos.getInfos();
		var _class = Context.getLocalClass();

		var _source_path = Path.directory(_pos_info.file);
		if( !Path.isAbsolute(_source_path) ) {
			_source_path = Path.join([Sys.getCwd(), _source_path]);
		}

		_source_path = Path.normalize(_source_path);

		var _lib_path = Path.normalize(Path.join([_source_path, _relative_root]));

		_class.get().meta.add(":include", [{ expr:EConst( CString( '$_lib_path/$_file' ) ), pos:_pos }], _pos );

		return Context.getBuildFields();
	}
}