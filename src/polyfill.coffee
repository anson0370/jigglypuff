if not String.prototype.startsWith
  Object.defineProperty(String.prototype, 'startsWith', {
    enumerable: false
    configurable: false
    writable: false
    value: (searchString, position) ->
      position = position || 0
      this.indexOf(searchString, position) == position
  })
