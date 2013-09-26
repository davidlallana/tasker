class TaskCtrl extends Monocle.Controller

  elements:
    "input[name=name]"            : "name"
    "textarea[name=description]"  : "description"
    "select[name=list]"           : "list"
    "input[name=when]"            : "when"
    "input[name=important]"       : "important"

  events:
    "click [data-action=save]"    : "onSave"

  constructor: ->
    super
    @new = @_new
    @show = @_show

  # Events
  onSave: (event) ->
    if @current
      # Save
      if @current.important != @important[0].checked
      then @changeList()
      else
        @current.name = @name.val  
        @current.description = @description.val 
        @current.list = @list.val
        @current.when = @when.val
        @current.save()
        Lungo.Notification.hide
        Lungo.Notification.show "check", "Task modified"
    else
      # New task
      __Model.Task.create
        name        : @name.val()
        description : @description.val()
        list        : @list.val()
        when        : @when.val()
        important   : @important[0].checked

  changeList: ->
    Lungo.Notification.hide
    Lungo.Notification.show "check", "Task modified"
    __Model.Task.create
      name        : @current.name
      description : @current.description
      list        : @current.list
      when        : @current.when
      important   : @important[0].checked
      done        : @current.done


  # Private Methods
  _new: (@current=null) ->
    @name.val ""
    @description.val ""
    @list.val ""
    @when.val ""
    @important[0].checked = false
    Lungo.Router.section "task"

  _show: (@current) ->
    @name.val  @current.name
    @description.val  @current.description
    @list.val @current.list
    @when.val @current.when
    @important[0].checked = @current.important
    Lungo.Router.section "task"

$$ ->
  __Controller.Task = new TaskCtrl "section#task"

