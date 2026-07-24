/// How [TokenizedText] splits incoming content for animation.
enum FlowTokenSeparator {
  /// Only animate newly appended suffixes (best for LLM streaming).
  diff,

  /// Split on whitespace boundaries, keeping separators.
  word,

  /// Split per character.
  char,
}
