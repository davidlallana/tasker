class __View.Task extends Monocle.View

  template  : """
    <li class="thumb">
      <fieldset><input type="checkbox" {{#done}}checked{{/done}}></fieldset>
      <div>
        <div class="on-right">{{list}}</div>
        <strong class="text">{{name}}</strong>
        <small>{{description}}</small>
      </div>
    </li>
  """

  constructor: ->
    super
    @append @model
    __Model.Task.bind "destroy", @bindTaskDeleted

  events:
    "swipeLeft li"                    :  "onDelete"
    "singleTap input[type=checkbox]"  :  "onDone"
    "hold li"                         :  "onDone"
    "singleTap .text"                 :  "onView"

  onDone: (event) ->
    @model.done =  !@model.done
    @model.save()
    console.log "[DONE]", @model

  onDelete: (event) -> 
    Lungo.Notification.hide
    Lungo.Notification.show "check", "Success", 3, alert("Tarea borrada")
    @remove()
    @model.destroy()  
    console.log "[DELETE]", @model

  onView: (event) ->
    __Controller.Task.show @model

  bindTaskDeleted: (task) => 
    @task.destroy()