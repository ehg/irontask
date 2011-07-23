beforeEach ->
  @addMatchers
    toBeEmpty: -> this.actual and this.actual.length == 0

    toInclude: (value) -> _.include @actual, value
