class TaskCtrl extends Monocle.Controller

  elements:
    "input[name=name]"            : "name"
    "textarea[name=description]"  : "description"
    "select[name=list]"           : "list"
    "input[name=when]"            : "when"
    "input[name=important]"       : "important"

  events:
    "click [data-action=save]"    : "onSave"

  _views = undefined

  constructor: ->
    super
    @new = @_new
    @show = @_show
    _views = []
    __Model.Task.bind "create", @bindTaskCreated

  # Events
  onSave: (event) ->
    if @current
      # Save
      if @current.important != @important[0].checked
      then @changeList()
      else
        @current.name = @name.val()
        @current.description = @description.val()
        @current.list = @list.val()
        @current.when = @when.val()
        @current.save()
        for view in _views
          if view.model.uid == @current.uid
            view.refresh()    
        Lungo.Notification.show "pencil", "Task modified",1
    else
      # New task
      __Model.Task.create
        name        : @name.val()
        description : @description.val()
        list        : @list.val()
        when        : @when.val()
        important   : @important[0].checked
        Lungo.Notification.show "check", "Task created", 1

  changeList: ->
    for view in _views
      if view.model.uid == @current.uid
        view.model.destroy()  
        view.destroy()  
        view.refresh()    
    __Model.Task.create
      name        : @current.name
      description : @current.description
      list        : @current.list
      when        : @current.when
      important   : @important[0].checked
      done        : @current.done
    Lungo.Notification.show "pencil", "Task modified", 1

  bindTaskCreated: (task) =>
    context = if task.important is true then "high" else "normal"
    tt = new __View.Task model: task, container: "article##{context} ul"
    _views.push tt
    Lungo.Notification.show "check", "Task created", 1

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

