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

  events:
    "swipeLeft li"                    :  "onDelete"
    "singleTap input[type=checkbox]"  :  "onDone"
    "hold li"                         :  "onDone"
    "singleTap .text"                 :  "onView"

  onDone: (event) ->
    @model.done =  !@model.done
    @model.save()
    @refresh()
    console.log "[DONE]", @model

  onDelete: (event) ->
    Lungo.Notification.confirm
      icon: "trash"
      title: "Are you sure?"
      description: "You are going to delete this task"
      accept:
        label: "Yes"
        callback: =>
          @remove()
          @model.destroy()
          console.log "[DELETE]", @model
      cancel:
        label: "No"
        callback: ->
          @

  onView: (event) ->
    __Controller.Task.show @model
