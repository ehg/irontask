class IronTask.Guid
  @new: ->
    "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace /[xy]/g, (c) ->
      r = Math.random() * 16 | 0
      v = (if c == "x" then r else (r & 0x3 | 0x8))
      v.toString 16
  
  @is_valid: (guid) ->
    return false unless guid?
    regex = /^(\{{0,1}([0-9a-fA-F]){8}-([0-9a-fA-F]){4}-([0-9a-fA-F]){4}-([0-9a-fA-F]){4}-([0-9a-fA-F]){12}\}{0,1})$/
    regex.test guid



