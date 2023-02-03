package hxcodecpro._internal;

@:cppNamespaceCode("
int add_numbers(int a, int b) {
    return a + b;
}

void print_hello() {
    printf(\"Hello from C++!\");
}

int get_seven() {
    return 7;
}

void print_number(int number) {
    printf(\"Number: %d\", number);
}
")
class LibVLC {
    @:native("add_numbers")
    static extern function add_numbers(a:Int, b:Int):Int;
    public static function addNumbers(a:Int, b:Int):Int { return add_numbers(a, b); }

    @:native("print_hello")
    static extern function print_hello():Void;
    public static function printHello():Void { print_hello(); }

    @:native("get_seven")
    static extern function get_seven():Int;
    public static function getSeven():Int { return get_seven(); }

    @:native("print_number")
    static extern function print_number(a:Int):Void;
    public static function printNumber(a:Int):Void { print_number(a); }
}