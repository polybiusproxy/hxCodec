package cpp;

extern abstract CharStar(cpp.RawPointer<cpp.Char>)
{
  inline function new(s:String)
  {
    this = untyped s.__s;
  }

  /**
   * Allocate a new `char *` of the given size.
   * @param size The size of the `char *` to allocate.
   * @return The resulting `CharStar`.
   */
  public static inline function allocate(size:Int):CharStar
  {
    return untyped __cpp__("new char[{0}]", size);
  }

  /**
   * Free a `char *` allocated with `allocate`.
   * @param ptr The `char *` to free.
   */
  public static inline function free(ptr:CharStar):Void
  {
    untyped __cpp__("delete[] {0}", ptr);
  }

  /**
   * Add implicit casting to string.
   * @return The resulting haxe `String`.
   */
  @:to
  public inline function toString():String
  {
    return new String(untyped this);
  }

  /**
   * Add implicit casting to pointer.
   * @return The resulting `cpp.Pointer<cpp.Char>`.
   */
  @:to
  public inline function toPointer():cpp.Pointer<cpp.Char>
  {
    return untyped this;
  }

  /**
   * Add implicit casting from string.
   * @param s The string to cast.
   * @return The resulting `CharStar`.
   */
  @:from
  public static inline function fromString(s:String):CharStar
  {
    return new CharStar(s);
  }
}

typedef CharStarStar = cpp.RawPointer<CharStar>;

// typedef ConstCharStar = cpp.ConstPointer<cpp.Char>;

typedef ConstCharStarStar = cpp.RawPointer<ConstCharStar>;