class __Controller.TasksCtrl extends Monocle.Controller

    events:
      "click [data-action=new]"    :   "onNew"

    elements:
      "#pending"    :   "pending"
      "#important"  :   "important"

    constructor: ->
      super
      __Model.Task.bind "create", @bindTaskCreated
      __Model.Task.bind "update", @bindTaskUpdated
      __Model.Task.bind "destroy", @bindTaskDeleted

    onNew: (event) ->
      __Controller.Task.new()

    bindTaskCreated: (task) =>
      Lungo.Router.back()
      @renderCounts()

    bindTaskUpdated: (task) =>
      Lungo.Router.back()
      @renderCounts()
    
    bindTaskDeleted: (task) =>
      console.log "uiuiuh"
      Lungo.Notification.show "check", "Task deleted",1
      @renderCounts()

    renderCounts: ->
      Lungo.Element.count("#pending", __Model.Task.pending_not_important().length);
      Lungo.Element.count("#important",__Model.Task.pending_important().length);

$$ ->
  Lungo.init({})
  Tasks = new __Controller.TasksCtrl "section#tasks"


