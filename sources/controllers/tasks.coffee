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
      context = if task.important is true then "high" else "normal"
      new __View.Task model: task, container: "article##{context} ul"
      Lungo.Router.back()
      Lungo.Notification.hide()
      @renderCounts()

    bindTaskUpdated: (task) =>
      Lungo.Router.back()
      Lungo.Notification.hide()
      @renderCounts()
    
    bindTaskDeleted: (task) => 
      @renderCounts()

    renderCounts: ->
      Lungo.Element.count("#pending", __Model.Task.pending_not_important().length);
      Lungo.Element.count("#important",__Model.Task.pending_important().length);

$$ ->
  Lungo.init({})
  Tasks = new __Controller.TasksCtrl "section#tasks"


