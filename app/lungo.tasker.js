(function() {
  var _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  __Model.Task = (function(_super) {
    __extends(Task, _super);

    function Task() {
      _ref = Task.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    Task.fields("name", "description", "list", "when", "important", "done");

    Task.pending = function() {
      return this.select(function(task) {
        return !task.done;
      });
    };

    Task.completed = function() {
      return this.select(function(task) {
        return !!task.done;
      });
    };

    Task.important = function() {
      return this.select(function(task) {
        return task.important === true;
      });
    };

    Task.pending_not_important = function() {
      return this.select(function(task) {
        return task.important === false & !task.done;
      });
    };

    Task.pending_important = function() {
      return this.select(function(task) {
        return task.important === true & !task.done;
      });
    };

    return Task;

  })(Monocle.Model);

}).call(this);

(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  __View.Task = (function(_super) {
    __extends(Task, _super);

    Task.prototype.template = "<li class=\"thumb\">\n  <fieldset><input type=\"checkbox\" {{#done}}checked{{/done}}></fieldset>\n  <div>\n    <div class=\"on-right\">{{list}}</div>\n    <strong class=\"text\">{{name}}</strong>\n    <small>{{description}}</small>\n  </div>\n</li>";

    function Task() {
      Task.__super__.constructor.apply(this, arguments);
      this.append(this.model);
    }

    Task.prototype.events = {
      "swipeLeft li": "onDelete",
      "singleTap input[type=checkbox]": "onDone",
      "hold li": "onDone",
      "singleTap .text": "onView"
    };

    Task.prototype.onDone = function(event) {
      this.model.done = !this.model.done;
      this.model.save();
      this.refresh();
      return console.log("[DONE]", this.model);
    };

    Task.prototype.onDelete = function(event) {
      this.remove();
      this.model.destroy();
      return console.log("[DELETE]", this.model);
    };

    Task.prototype.onView = function(event) {
      return __Controller.Task.show(this.model);
    };

    return Task;

  })(Monocle.View);

}).call(this);

(function() {
  var TaskCtrl,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  TaskCtrl = (function(_super) {
    __extends(TaskCtrl, _super);

    TaskCtrl.prototype.elements = {
      "input[name=name]": "name",
      "textarea[name=description]": "description",
      "select[name=list]": "list",
      "input[name=when]": "when",
      "input[name=important]": "important"
    };

    TaskCtrl.prototype.events = {
      "click [data-action=save]": "onSave"
    };

    function TaskCtrl() {
      TaskCtrl.__super__.constructor.apply(this, arguments);
      this["new"] = this._new;
      this.show = this._show;
    }

    TaskCtrl.prototype.onSave = function(event) {
      if (this.current) {
        if (this.current.important !== this.important[0].checked) {
          return this.changeList();
        } else {
          this.current.name = this.name.val;
          this.current.description = this.description.val;
          this.current.list = this.list.val;
          this.current.when = this.when.val;
          this.current.save();
          Lungo.Notification.hide;
          return Lungo.Notification.show("check", "Task modified");
        }
      } else {
        return __Model.Task.create({
          name: this.name.val(),
          description: this.description.val(),
          list: this.list.val(),
          when: this.when.val(),
          important: this.important[0].checked
        });
      }
    };

    TaskCtrl.prototype.changeList = function() {
      Lungo.Notification.hide;
      Lungo.Notification.show("check", "Task modified");
      return __Model.Task.create({
        name: this.current.name,
        description: this.current.description,
        list: this.current.list,
        when: this.current.when,
        important: this.important[0].checked,
        done: this.current.done
      });
    };

    TaskCtrl.prototype._new = function(current) {
      this.current = current != null ? current : null;
      this.name.val("");
      this.description.val("");
      this.list.val("");
      this.when.val("");
      this.important[0].checked = false;
      return Lungo.Router.section("task");
    };

    TaskCtrl.prototype._show = function(current) {
      this.current = current;
      this.name.val(this.current.name);
      this.description.val(this.current.description);
      this.list.val(this.current.list);
      this.when.val(this.current.when);
      this.important[0].checked = this.current.important;
      return Lungo.Router.section("task");
    };

    return TaskCtrl;

  })(Monocle.Controller);

  $$(function() {
    return __Controller.Task = new TaskCtrl("section#task");
  });

}).call(this);

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  __Controller.TasksCtrl = (function(_super) {
    __extends(TasksCtrl, _super);

    TasksCtrl.prototype.events = {
      "click [data-action=new]": "onNew"
    };

    TasksCtrl.prototype.elements = {
      "#pending": "pending",
      "#important": "important"
    };

    function TasksCtrl() {
      this.bindTaskDeleted = __bind(this.bindTaskDeleted, this);
      this.bindTaskUpdated = __bind(this.bindTaskUpdated, this);
      this.bindTaskCreated = __bind(this.bindTaskCreated, this);
      TasksCtrl.__super__.constructor.apply(this, arguments);
      __Model.Task.bind("create", this.bindTaskCreated);
      __Model.Task.bind("update", this.bindTaskUpdated);
      __Model.Task.bind("destroy", this.bindTaskDeleted);
    }

    TasksCtrl.prototype.onNew = function(event) {
      return __Controller.Task["new"]();
    };

    TasksCtrl.prototype.bindTaskCreated = function(task) {
      var context;
      context = task.important === true ? "high" : "normal";
      new __View.Task({
        model: task,
        container: "article#" + context + " ul"
      });
      Lungo.Router.back();
      Lungo.Notification.show("check", "Task created", 3);
      return this.renderCounts();
    };

    TasksCtrl.prototype.bindTaskUpdated = function(task) {
      Lungo.Router.back();
      Lungo.Notification.show("check", "Task modified", 3);
      return this.renderCounts();
    };

    TasksCtrl.prototype.bindTaskDeleted = function(task) {
      Lungo.Notification.show("check", "Task deleted", 3);
      return this.renderCounts();
    };

    TasksCtrl.prototype.renderCounts = function() {
      Lungo.Element.count("#pending", __Model.Task.pending_not_important().length);
      return Lungo.Element.count("#important", __Model.Task.pending_important().length);
    };

    return TasksCtrl;

  })(Monocle.Controller);

  $$(function() {
    var Tasks;
    Lungo.init({});
    return Tasks = new __Controller.TasksCtrl("section#tasks");
  });

}).call(this);
