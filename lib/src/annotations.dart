part of stripe;



/**
 * Used whenever a field of a resource is required
 */
class Required {

  /// use [alternative] if either this or [alternative] is required
  final String alternative;
  const Required({String this.alternative});

}

/// See [Required]
const required = const Required();

